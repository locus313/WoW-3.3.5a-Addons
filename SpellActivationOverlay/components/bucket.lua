local AddonName,SAO=...
local Module="bucket"
SAO.RegisteredBucketsByName={}
SAO.RegisteredBucketsBySpellID={}
SAO.Bucket={
create=function(self,name,spellID)
local spellName=SAO:GetSpellName(spellID)
local bucket={
name=name,
spellID=spellID,
stackAgnostic=true,
displayedHash=nil,
currentHash=nil,
hashCalculator=SAO.Hash:new(),
hashCalculatorToApply=SAO.Hash:new(),
description=name.." ("..spellID..(spellName and ("="..spellName) or "")..")",
}
bucket.trigger=SAO.Trigger:new(bucket)
bucket.currentState=SAO.VariableState:new(bucket)
self.__index=nil
setmetatable(bucket,self)
self.__index=self
return bucket
end,
reset=function(self)
self.currentState:reset()
self.trigger.informed=0
if self.hashCalculator.hash~=0 then
self.hashCalculator:reset()
self:applyHash()
end
end,
getOrCreateDisplay=function(self,hash)
local created=false
if not self[hash.hash] then
self[hash.hash]=SAO.Display:new(self,hash.hash)
if hash:hasAuraStacks()then
local stacks=hash:getAuraStacks()
if stacks and stacks > 0 then
self.stackAgnostic=false
end
end
created=true
end
return self[hash.hash],created
end,
isDisplayed=function(self,hash)
if hash then
return self.displayedHash==hash
else
return self.displayedHash~=nil
end
end,
refresh=function(self)
if self.displayedHash==nil then
return
end
local currentStacks=self.currentState.currentAuraStacks
if not self.stackAgnostic and (currentStacks and currentStacks > 0)then
local hashForAnyStacks=self.hashCalculator:toAnyAuraStacks()
if self[hashForAnyStacks] then
self[hashForAnyStacks]:refresh()
end
end
self[self.displayedHash]:refresh()
end,
checkCombat=function(self,inCombat)
if self.displayedHash then
self[self.displayedHash]:checkCombat(inCombat)
end
end,
applyHash=function(self)
self.hashCalculatorToApply.hash=self.hashCalculator.hash
local alwaysRefresh=false
if self.onAboutToApplyHash then
alwaysRefresh=self.onAboutToApplyHash(self.hashCalculatorToApply)
end
if SAO:HasDebug() or SAO:HasTrace(Module)then
local describeHash=function(hash)
local str,num="unknown",tostring(hash)
if type(hash)=='number' then
str=SAO.Hash:new(hash):toString()
num=string.format("0x%X==%d",hash,hash)
end
return str,string.format("%s (%s)",str,num)
end
local logHashUpdate=function(oldHash,newHash,prefix)
if oldHash==newHash then return end
prefix=prefix or ""
if oldHash==nil or oldHash==0 then
local shortStrHashAfter,longStrHashAfter=describeHash(newHash)
SAO:Debug(Module,prefix.."Setting hash to "..shortStrHashAfter.." for "..self.description)
elseif newHash==0 then
local _,longStrHashBefore=describeHash(oldHash)
SAO:Debug(Module,prefix.."Resetting hash for "..self.description)
else
local shortStrHashBefore,longStrHashBefore=describeHash(oldHash)
local shortStrHashAfter,longStrHashAfter=describeHash(newHash)
SAO:Debug(Module,prefix.."Changing hash from "..shortStrHashBefore.." to "..shortStrHashAfter.." for "..self.description)
end
end
if self.onAboutToApplyHash then
logHashUpdate(self.lastRealHash,self.hashCalculator.hash, "(real hash) ")
self.lastRealHash=self.hashCalculator.hash
logHashUpdate(self.currentHash,self.hashCalculatorToApply.hash, "(virtual hash) ")
else
logHashUpdate(self.currentHash,self.hashCalculatorToApply.hash)
end
end
if self.currentHash==self.hashCalculatorToApply.hash then
if alwaysRefresh then
self:refresh()
end
return
end
self.currentHash=self.hashCalculatorToApply.hash
if not self.trigger:isFullyInformed()then
return
end
local currentStacks=self.currentState.currentAuraStacks
local transitionOptions={mimicPulse=true}
if self.stackAgnostic then
if self.displayedHash==nil then
if self[self.currentHash] then
self[self.currentHash]:show()
end
else
self[self.displayedHash]:hide()
if self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
end
else
local hashForAnyStacks=self.hashCalculatorToApply:toAnyAuraStacks()
if self.displayedHash==nil then
if currentStacks==nil or currentStacks==0 then
if self[self.currentHash] then
self[self.currentHash]:show()
end
else
if self[hashForAnyStacks] then
self[hashForAnyStacks]:show()
end
if self[self.currentHash] then
self[self.currentHash]:show()
end
end
else
local displayedStacks=SAO.Hash:new(self.displayedHash):getAuraStacks()
if displayedStacks==nil then
self[self.displayedHash]:hide()
if self[hashForAnyStacks] then
self[hashForAnyStacks]:show(transitionOptions)
end
if currentStacks > 0 and self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
elseif displayedStacks==0 then
if currentStacks==nil then
self[self.displayedHash]:hide()
if self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
else
if self[self.currentHash] then
self[self.currentHash]:show()
end
end
else
if currentStacks==nil then
local displayedHash=self.displayedHash
if self[hashForAnyStacks] then
self[hashForAnyStacks]:hide()
end
self[displayedHash]:hide()
if self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
elseif currentStacks==0 then
self[self.displayedHash]:hide()
if self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
else
self[self.displayedHash]:hide()
if self[hashForAnyStacks] then
self[hashForAnyStacks]:show(transitionOptions)
end
if self[self.currentHash] then
self[self.currentHash]:show(transitionOptions)
end
end
end
end
end
end,
}
SAO.BucketManager={
addAura=function(self,aura)
local bucket,created=self:getOrCreateBucket(aura.name,aura.spellID)
if created and not SAO:IsFakeSpell(aura.spellID)then
bucket.trigger:require(SAO.TRIGGER_AURA)
end
local displayHash=SAO.Hash:new()
displayHash:setAuraStacks(aura.stacks)
local display=bucket:getOrCreateDisplay(displayHash)
if aura.overlay then
display:addOverlay(aura.overlay)
end
for _,button in ipairs(aura.buttons or {})do
display:addButton(button)
end
if type(aura.combatOnly)=='boolean' then
display:setCombatOnly(aura.combatOnly)
end
end,
addEffectOverlay=function(self,bucket,hash,overlay,combatOnly)
local display=bucket:getOrCreateDisplay(hash)
display:addOverlay(overlay)
display:setCombatOnly(combatOnly)
end,
addEffectButton=function(self,bucket,hash,button,combatOnly)
local display=bucket:getOrCreateDisplay(hash)
display:addButton(button)
display:setCombatOnly(combatOnly)
end,
getOrCreateBucket=function(self,name,spellID)
if type(spellID)~='number' then
SAO:Warn(Module, "Creating a bucket for spellID "..tostring(spellID).." which is of type "..type(spellID).." instead of number")
end
local bucket=SAO.RegisteredBucketsBySpellID[spellID]
local created=false
if not bucket then
bucket=SAO.Bucket:create(name,spellID)
SAO.RegisteredBucketsBySpellID[spellID]=bucket
SAO.RegisteredBucketsByName[name]=bucket
if SAO.IsEra() and not SAO:IsFakeSpell(spellID)then
local spellName=SAO:GetSpellName(spellID)
if spellName then
local conflictingBucket=SAO.RegisteredBucketsBySpellID[spellName]
if conflictingBucket then
SAO:Debug(Module, "Registering spells with different spell IDs ("..conflictingBucket.name.." uses spell ID "..conflictingBucket.spellID.." vs. "..bucket.name.." uses spell ID "..bucket.spellID..") but sharing the same spell name '"..spellName.."', ".."this might cause issues")
end
SAO.RegisteredBucketsBySpellID[spellName]=bucket
else
SAO:Debug(Module, "Registering bucket with unknown spell "..tostring(spellID))
end
end
created=true
end
return bucket,created
end,
}
function SAO:GetBucketByName(name)
return self.RegisteredBucketsByName[name]
end
function SAO:GetBucketBySpellID(spellID)
return self.RegisteredBucketsBySpellID[spellID]
end
function SAO:GetBucketBySpellIDOrSpellName(spellID,fallbackSpellName)
if not self.IsEra() or (type(spellID)=='number' and spellID~=0)then
return self.RegisteredBucketsBySpellID[spellID],spellID
else
local bucket=self.RegisteredBucketsBySpellID[fallbackSpellName]
if bucket then
spellID=bucket.spellID
end
return bucket,spellID
end
end
function SAO:ForEachBucket(bucketFunc)
for key,bucket in pairs(self.RegisteredBucketsBySpellID)do
if type(key)=='number' then
bucketFunc(bucket)
end
end
end
function SAO:CheckManuallyAllBuckets(trigger)
if trigger then
local buckets=self:GetBucketsByTrigger(trigger)
for _,bucket in ipairs(buckets or {})do
bucket.trigger:manualCheck(trigger)
end
else
SAO:ForEachBucket(function(bucket)
if bucket.trigger.required~=0 then
bucket.trigger:manualCheckAll()
end
end)
end
end
local function dumpOneBucket(bucket,devDump)
if devDump then
DevTools_Dump({[bucket.spellID]=bucket})
else
local describeHash=function(hash)
local str=tostring(hash)
if hash then
str=string.format("%s==0x%X==%d",SAO.Hash:new(hash):toString(),hash,hash)
end
return str
end
local str=bucket.name..", "..
"spellID=="..tostring(bucket.spellID)..", "..
"currentHash=="..describeHash(bucket.currentHash)..", "..
"displayedHash=="..describeHash(bucket.displayedHash)..", "..
"triggerRequired=="..tostring(bucket.trigger.required)..", "..
"triggerInformed=="..tostring(bucket.trigger.informed)
SAO:Info(Module,str)
end
end
function SpellActivationOverlay_DumpBuckets(spellID,devDump)
if spellID then
local bucket=SAO.RegisteredBucketsBySpellID[spellID]
if bucket then
dumpOneBucket(bucket,devDump)
return
end
SAO:Info(Module, "Bucket not found with spellID "..tostring(spellID))
return
end
local nbBuckets=0
SAO:ForEachBucket(function(bucket)
nbBuckets=nbBuckets + 1
end)
SAO:Info(Module, "Listing buckets ("..nbBuckets.." item"..(nbBuckets==1 and "" or "s")..")")
SAO:ForEachBucket(function(bucket)
dumpOneBucket(bucket,devDump)
end)
end
function SpellActivationOverlay_CheckBuckets(spellID)
if spellID then
local bucket=SAO:GetBucketBySpellID(spellID)
if bucket then
SAO:Info(Module, "Checking bucket "..bucket.description)
bucket.trigger:manualCheckAll()
else
SAO:Info(Module, "Bucket not found with spellID "..tostring(spellID))
end
else
local nbBuckets=0
SAO:ForEachBucket(function(bucket)
nbBuckets=nbBuckets + 1
end)
SAO:Info(Module, "Checking all buckets ("..nbBuckets.." item"..(nbBuckets==1 and "" or "s")..")")
SAO:ForEachBucket(function(bucket)
bucket.trigger:manualCheckAll()
end)
end
end
