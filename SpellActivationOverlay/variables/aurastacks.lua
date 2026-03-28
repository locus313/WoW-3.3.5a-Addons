local AddonName,SAO=...
local Module="aurastacks"
SAO.AURASTACKS={
LEGACY=not SAO.IsRetail(),
MODERN=SAO.IsRetail(),
}
local HASH_AURA_ABSENT=1
local HASH_AURA_ANY=2
local HASH_AURA_ZERO=HASH_AURA_ANY
local HASH_AURA_MAX=HASH_AURA_ZERO + 10
local HASH_AURA_MASK=0xF
local bucketsByAuraInstanceID={}
SAO.Variable:register({
order=1,
core="AuraStacks",
trigger={
flag=SAO.TRIGGER_AURA,
name="aura",
},
hash={
mask=HASH_AURA_MASK,
key="aura_stacks",
setterFunc=function(self,stacks,bucket)
if stacks==nil then
self:setMaskedHash(HASH_AURA_ABSENT,HASH_AURA_MASK)
elseif type(stacks)~='number' or stacks < 0 then
SAO:Warn(Module, "Invalid stack count "..tostring(stacks))
elseif bucket and bucket.stackAgnostic then
self:setMaskedHash(HASH_AURA_ANY,HASH_AURA_MASK)
elseif stacks > 10 then
SAO:Debug(Module, "Stack overflow ("..stacks..") truncated to 10")
self:setMaskedHash(HASH_AURA_MAX,HASH_AURA_MASK)
else
self:setMaskedHash(HASH_AURA_ZERO + stacks,HASH_AURA_MASK)
end
end,
getterFunc=function(self)
local maskedHash=self:getMaskedHash(HASH_AURA_MASK)
if maskedHash==nil then return nil; end
if maskedHash==HASH_AURA_ABSENT then
return nil
end
return maskedHash - HASH_AURA_ZERO
end,
toAnyFunc=function(self)
return bit.band(self.hash,bit.bnot(HASH_AURA_MASK)) + HASH_AURA_ANY
end,
toValue=function(hash)
local auraStacks=hash:getAuraStacks()
return (auraStacks==nil) and "missing" or (auraStacks==0 and "any" or tostring(auraStacks))
end,
fromValue=function(hash,value)
if value=="missing" then
hash:setAuraStacks(nil)
return true
elseif value=="any" then
hash:setAuraStacks(0)
return true
elseif tostring(tonumber(value))==value then
hash:setAuraStacks(tonumber(value))
return true
else
return nil
end
end,
getHumanReadableKeyValue=function(hash)
local auraStacks=hash:getAuraStacks()
if auraStacks and auraStacks > 0 then
return SAO:NbStacks(auraStacks)
elseif auraStacks==nil then
return ACTION_SPELL_AURA_REMOVED_DEBUFF
else
return nil
end
end,
optionIndexer=function(hash)
return hash:getAuraStacks() or -1
end,
},
bucket={
impossibleValue=-1,
fetchAndSet=function(bucket)
local auraStacks,auraInstanceID=SAO:GetPlayerAuraStacksBySpellID(bucket.spellID)
if auraStacks~=nil then
if bucket.stackAgnostic then
bucket:setAuraStacks(0)
else
bucket:setAuraStacks(auraStacks)
end
else
bucket:setAuraStacks(nil)
end
if SAO.AURASTACKS.MODERN then
bucket.lastKnownAuraStacks=auraStacks
bucket.lastTimeUnitAuraEvent=nil
bucket.auraInstanceID=auraInstanceID
if auraInstanceID~=nil then
bucketsByAuraInstanceID[auraInstanceID]=bucket
end
end
end,
},
event={
isRequired=true,
names=SAO.AURASTACKS.MODERN and {"UNIT_AURA"} or {"COMBAT_LOG_EVENT_UNFILTERED"},
COMBAT_LOG_EVENT_UNFILTERED=SAO.AURASTACKS.LEGACY and function(...)
local _,event,_,_,_,_,_,destGUID=CombatLogGetCurrentEventInfo()
if ((event:sub(0,11)=="SPELL_AURA_") and (destGUID==UnitGUID("player")))then
local spellID,spellName=select(12,CombatLogGetCurrentEventInfo())
local auraApplied=event:sub(0,18)=="SPELL_AURA_APPLIED"; -- includes "SPELL_AURA_APPLIED" and "SPELL_AURA_APPLIED_DOSE"
local auraRemovedLast=event=="SPELL_AURA_REMOVED"
local auraRemovedDose=event=="SPELL_AURA_REMOVED_DOSE"
local auraRefresh=event=="SPELL_AURA_REFRESH"
if not auraApplied and not auraRemovedLast and not auraRemovedDose and not auraRefresh then
return
end
local bucket
bucket,spellID=SAO:GetBucketBySpellIDOrSpellName(spellID,spellName)
if not bucket then
return
end
if not bucket.trigger:reactsWith(SAO.TRIGGER_AURA)then
return
end
if (auraRefresh)then
bucket:refresh()
return
end
if (auraRemovedLast)then
bucket:setAuraStacks(nil); -- nil means "not currently holding any stacks"
return
end
local stacks=0
if not bucket.stackAgnostic then
if event~="SPELL_AURA_REMOVED" then
stacks=SAO:GetPlayerAuraStacksBySpellID(spellID) or 0
end
end
bucket:setAuraStacks(stacks)
end
end or nil,
UNIT_AURA=SAO.AURASTACKS.MODERN and function(unitTarget,updateInfo)
if not UnitIsUnit(unitTarget, "player")then
return
end
if updateInfo.isFullUpdate then
SAO:Debug(Module, "Full aura update detected,rechecking all buckets")
SAO:CheckManuallyAllBuckets(SAO.TRIGGER_AURA)
return
end
local addAura=function(auraInstanceID,aura,bucket)
SAO:Trace(Module, "Associating aura instance ID "..tostring(auraInstanceID).." to bucket "..bucket.name)
bucket:setAuraStacks(bucket.stackAgnostic and 0 or aura.applications)
bucket.lastKnownAuraStacks=aura.applications
bucket.auraInstanceID=auraInstanceID
bucketsByAuraInstanceID[auraInstanceID]=bucket
bucket.lastTimeUnitAuraEvent=GetTime()
end
local removeAura=function(auraInstanceID,bucket)
SAO:Trace(Module, "Removing association of aura instance ID "..tostring(auraInstanceID).." from bucket "..bucket.name)
bucket:setAuraStacks(nil)
bucket.lastKnownAuraStacks=nil
bucket.auraInstanceID=nil
bucketsByAuraInstanceID[auraInstanceID]=nil
bucket.lastTimeUnitAuraEvent=GetTime()
end
local updateAura=function(auraInstanceID,aura,bucket)
SAO:Trace(Module, "Updating aura instance ID "..tostring(auraInstanceID).." for bucket "..bucket.name)
if bucket.lastKnownAuraStacks~=aura.applications then
SAO:Trace(Module, "Bucket "..tostring(bucket.name).." aura stacks changed from "..tostring(bucket.lastKnownAuraStacks).." to "..tostring(aura.applications))
bucket:setAuraStacks(bucket.stackAgnostic and 0 or aura.applications)
bucket.lastKnownAuraStacks=aura.applications
else
SAO:Trace(Module, "Bucket "..tostring(bucket.name).." aura stacks remain unchanged at "..tostring(bucket.lastKnownAuraStacks))
bucket:refresh()
end
bucket.lastTimeUnitAuraEvent=GetTime()
end
for _,auraInstanceID in ipairs(updateInfo.updatedAuraInstanceIDs or {})do
local bucket=bucketsByAuraInstanceID[auraInstanceID]
if bucket then
if bucket.lastTimeUnitAuraEvent==GetTime()then
SAO:Trace(Module, "Skipping UNIT_AURA update of bucket "..tostring(bucket.name).." and aura instance ID "..tostring(auraInstanceID))
else
SAO:Trace(Module, "Trying to update aura instance ID "..tostring(auraInstanceID).." for bucket "..bucket.name)
local aura=C_UnitAuras.GetAuraDataByAuraInstanceID(unitTarget,auraInstanceID)
if not aura then
removeAura(auraInstanceID,bucket)
else
updateAura(auraInstanceID,aura,bucket)
end
end
end
end
for _,auraInstanceID in ipairs(updateInfo.removedAuraInstanceIDs or {})do
local bucket=bucketsByAuraInstanceID[auraInstanceID]
if bucket then
if bucket.lastTimeUnitAuraEvent==GetTime()then
SAO:Trace(Module, "Skipping UNIT_AURA removal of bucket "..tostring(bucket.name).." and aura instance ID "..tostring(auraInstanceID))
else
removeAura(auraInstanceID,bucket)
end
end
end
for _,aura in ipairs(updateInfo.addedAuras or {})do
local bucket=SAO:GetBucketBySpellID(aura.spellId)
if bucket and bucket.trigger:reactsWith(SAO.TRIGGER_AURA)then
if bucket.lastTimeUnitAuraEvent==GetTime()then
SAO:Trace(Module, "Skipping UNIT_AURA addition of bucket "..tostring(bucket.name).." and aura instance ID "..tostring(aura.auraInstanceID))
else
local auraInstanceID=aura.auraInstanceID
if bucketsByAuraInstanceID[auraInstanceID] then
SAO:Warn(Module, "Associating the (supposedly) newfound aura instance ID "..tostring(auraInstanceID).." to bucket "..bucket.name
..", ".."but this aura instance ID is already associated with bucket "..bucketsByAuraInstanceID[auraInstanceID].name)
end
addAura(auraInstanceID,aura,bucket)
end
end
end
end or nil,
},
condition={
noeVar="aura",
hreVar="stacks",
noeDefault=0,
description="number of stacks",
checker=function(value) return type(value)=='number' and value >=-1 and value <=10 end,
noeToHash=function(value) return value >=0 and value or nil end,
},
import={
noeTrigger="aura",
hreTrigger="requireAura",
dependency=nil,
classes={
force="aura",
ignore=nil,
},
},
})
