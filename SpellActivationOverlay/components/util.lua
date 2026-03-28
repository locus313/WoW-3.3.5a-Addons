local AddonName,SAO=...
local ShortAddonName=strlower(AddonName):sub(0,8)=="necrosis" and "Necrosis" or "SAO"
local Module="util"
local GetActionInfo=GetActionInfo
local GetMacroSpell=GetMacroSpell
local GetNumSpellTabs=GetNumSpellTabs
local GetNumTalents=GetNumTalents
local GetNumTalentTabs=GetNumTalentTabs
local GetSpellBookItemName=GetSpellBookItemName
local GetSpellTabInfo=GetSpellTabInfo
local GetTalentInfo=GetTalentInfo
local GetTalentTabInfo=GetTalentTabInfo
local GetTime=GetTime
local UnitAura=UnitAura
local UnitClassBase=UnitClassBase
local GetAuraDataBySpellName=C_UnitAuras and C_UnitAuras.GetAuraDataBySpellName
local GetPlayerAuraBySpellID=C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
local GetNumSpecializationsForClassID=C_SpecializationInfo and C_SpecializationInfo.GetNumSpecializationsForClassID
local GetSpecializationInfo=C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
GetTalentInfo=C_SpecializationInfo and C_SpecializationInfo.GetTalentInfo or GetTalentInfo
local IsEquippedItem=C_Item and C_Item.IsEquippedItem
function SAO:Error(prefix,msg,...)
print(WrapTextInColor("**"..ShortAddonName.."** -"..prefix.."- "..msg,RED_FONT_COLOR),...)
end
function SAO:Warn(prefix,msg,...)
print(WrapTextInColor("!"..ShortAddonName.."! -"..prefix.."- "..msg,WARNING_FONT_COLOR),...)
end
function SAO:Info(prefix,msg,...)
print(WrapTextInColor(ShortAddonName.." -"..prefix.."- "..msg,LIGHTBLUE_FONT_COLOR),...)
end
function SAO:HasDebug()
return SpellActivationOverlayDB and SpellActivationOverlayDB.debug
end
function SAO:Debug(prefix,msg,...)
if SpellActivationOverlayDB and SpellActivationOverlayDB.debug then
print(WrapTextInColorCode("["..ShortAddonName.."@"..GetTime().."] -"..prefix.."- "..msg, "FFFFFFAA"),...)
end
end
function SAO:HasTrace(prefix)
return SpellActivationOverlayDB and SpellActivationOverlayDB.trace and SpellActivationOverlayDB.trace[prefix]
end
function SAO.Trace(self,prefix,msg,...)
if SpellActivationOverlayDB and SpellActivationOverlayDB.trace and SpellActivationOverlayDB.trace[prefix] then
print(WrapTextInColorCode("{"..ShortAddonName.."@"..GetTime().."} -"..prefix.."- "..msg, "FFAAFFCC"),...)
end
end
function SAO:LogPersistent(prefix,msg)
if SpellActivationOverlayDB then
local line="[@"..GetTime().."] :"..prefix..": "..msg
if not SpellActivationOverlayDB.logs then
SpellActivationOverlayDB.logs={line}
else
tinsert(SpellActivationOverlayDB.logs,line)
end
end
end
local timeOfLastTrace={}
function SAO.TraceThrottled(self,key,prefix,...)
key=tostring(key)..tostring(prefix)
if not timeOfLastTrace[key] or GetTime() > timeOfLastTrace[key]+1 then
self:Trace(prefix,...)
timeOfLastTrace[key]=GetTime()
end
end
function SAO:CanReport()
return SAO.IsProject(SAO.MOP_AND_ONWARD)
end
function SAO:HasReport()
return SpellActivationOverlayDB and SpellActivationOverlayDB.report~=false
end
function SAO:ReportUnknownEffect(prefix,spellID,texture,positions,scale,r,g,b)
if self:CanReport()
and self:HasReport()
and self:AreEffectsInitialized()
and spellID
and not self:GetBucketBySpellID(spellID)
and not self:IsAka(spellID)
then
if not self.UnknownNativeEffects then
self.UnknownNativeEffects={}
end
if not self.UnknownNativeEffects[spellID] then
local text=""
text=text..", ".."flavor="..tostring(self.GetFlavorName())
text=text..", ".."spell="..tostring(spellID).." ("..self:GetSpellName(spellID, "unknown spell")..")"
text=text..", ".."tex="..tostring(texture)
text=text..", ".."pos="..((type(positions)=='string') and ("'"..positions.."'") or tostring(positions))
text=text..", ".."scale="..tostring(scale)
text=text..", ".."rgb=("..tostring(r).." "..tostring(g).." "..tostring(b)..")"
self:Info(prefix,SAO:unsupportedShowEvent(text))
self.UnknownNativeEffects[spellID]=true
end
end
end
function SAO:GetGCD()
if self.IsEra() or self.IsTBC()then
return 1.5
else
local _,gcdDuration=self:GetSpellCooldown(61304)
return gcdDuration
end
end
function SAO:gradientText(text,colors)
local function utf8_iter(str)
local pos=1
local len=#str
return function()
if pos > len then return nil; end
local c=str:byte(pos)
local bytes
if c < 0x80 then
bytes=1
elseif c < 0xE0 then
bytes=2
elseif c < 0xF0 then
bytes=3
else
bytes=4
end
local char=str:sub(pos,pos + bytes - 1)
pos=pos + bytes
return char
end
end
local chars={}
for ch in utf8_iter(text)do
table.insert(chars,ch)
end
local len=#chars
local result=""
for i=1,len do
local t=(i-1)/(len-1)
local idx,localT
if t <=0 then
idx=1
localT=0
elseif t >=1 then
idx=#colors - 1
localT=1
else
idx=math.floor(t * (#colors - 1)) + 1
localT=(t * (#colors - 1)) % 1
end
local c1=colors[idx]
local c2=colors[idx+1]
local r=c1.r + (c2.r-c1.r)*localT
local g=c1.g + (c2.g-c1.g)*localT
local b=c1.b + (c2.b-c1.b)*localT
local hex=string.format("%02x%02x%02x",r*255,g*255,b*255)
result=result .. "|cff" .. hex .. chars[i] .. "|r"
end
return result
end
function SAO:IsResponsiveMode()
return SpellActivationOverlayDB and SpellActivationOverlayDB.responsiveMode==true
end
function SAO:IsTimeAlmostEqual(t1,t2,delta)
return t1-delta < t2 and t2 < t1+delta
end
local function PlayerAura(index,filter)
return UnitAura("player",index,filter)
end
local function FindPlayerAuraBy(condition)
for _,filter in ipairs({"HELPFUL", "HARMFUL"})do
local i=1
local name,_,_,_,_,_,_,_,_,spellId=PlayerAura(i,filter)
while name do
if condition(spellId,name)then
return i,filter
end
i=i+1
name,_,_,_,_,_,_,_,_,spellId=PlayerAura(i,filter)
end
end
end
local function FindPlayerAuraByID(self,id)
local index,filter=FindPlayerAuraBy(function(_id,_name) return _id==id end)
if index then
return PlayerAura(index,filter)
end
end
local function FindPlayerAuraByName(self,name)
local index,filter=FindPlayerAuraBy(function(_id,_name) return _name==name end)
if index then
return PlayerAura(index,filter)
end
end
function SAO:HasPlayerAuraBySpellID(id)
if GetPlayerAuraBySpellID then
return GetPlayerAuraBySpellID(id)~=nil
else
return FindPlayerAuraByID(id)~=nil
end
end
function SAO:GetPlayerAuraStacksBySpellID(id)
if GetPlayerAuraBySpellID then
local aura=GetPlayerAuraBySpellID(id)
if aura then
return aura.applications,aura.auraInstanceID
end
else
local exists,_,count=FindPlayerAuraByID(id)
if exists then
return count,nil
end
end
return nil,nil
end
function SAO:GetPlayerAuraDurationExpirationTimBySpellIdOrName(spellIdOrName)
if type(spellIdOrName)=='string' then
if GetAuraDataBySpellName then
local aura=GetAuraDataBySpellName("player",spellIdOrName, "HELPFUL")
if not aura then
aura=GetAuraDataBySpellName("player",spellIdOrName, "HARMFUL")
end
if aura then
return aura.duration,aura.expirationTime
end
else
local exists,_,_,_,duration,expirationTime=FindPlayerAuraByName(spellIdOrName)
if exists then
return duration,expirationTime
end
end
elseif type(spellIdOrName)=='number' and not self:IsFakeSpell(spellIdOrName)then
if GetPlayerAuraBySpellID then
local aura=GetPlayerAuraBySpellID(spellIdOrName)
if aura then
return aura.duration,aura.expirationTime
end
else
local exists,_,_,_,duration,expirationTime=FindPlayerAuraByID(spellIdOrName)
if exists then
return duration,expirationTime
end
end
end
return nil,nil
end
function SAO:GetTalentByName(talentName)
if self.IsProject(SAO.MOP_AND_ONWARD)then
for tier=1,MAX_NUM_TALENT_TIERS do
for column=1,NUM_TALENT_COLUMNS do
local talentInfo=GetTalentInfo({tier=tier,column=column})
if talentInfo and talentInfo.name==talentName then
local rank=talentInfo.selected and 1 or 0
local maxRank=talentInfo.maxRank
return rank,maxRank,tier,column
end
end
end
elseif C_SpecializationInfo and C_SpecializationInfo.GetTalentInfo then
assert(GetTalentInfo==C_SpecializationInfo.GetTalentInfo)
for tab=1,GetNumTalentTabs()do
local nbTabs=GetNumTalents(tab)
for index=1,nbTabs do
local talentInfo=GetTalentInfo({specializationIndex=tab,talentIndex=index})
if talentInfo and talentInfo.name==talentName then
local rank=talentInfo.selected and 1 or 0
local maxRank=talentInfo.maxRank
return rank,maxRank,tab,index
end
end
end
else
for tab=1,GetNumTalentTabs()do
for index=1,GetNumTalents(tab)do
local name,iconTexture,tier,column,rank,maxRank,isExceptional,available=GetTalentInfo(tab,index)
if name==talentName then
return rank,maxRank,tab,index
end
end
end
end
end
function SAO:GetNbTalentPoints(i,j)
if self.IsProject(SAO.MOP_AND_ONWARD)then
local talentInfo=GetTalentInfo({tier=i,column=j})
return talentInfo and talentInfo.selected and 1 or 0
elseif C_SpecializationInfo and C_SpecializationInfo.GetTalentInfo then
assert(GetTalentInfo==C_SpecializationInfo.GetTalentInfo)
local talentInfo=GetTalentInfo({specializationIndex=i,talentIndex=j})
return talentInfo and talentInfo.rank and 1 or 0
else
return (select(5,GetTalentInfo(i,j)))
end
end
function SAO:GetTotalPointsInTree(specIndex)
if self.IsProject(SAO.MOP_AND_ONWARD)then
self:Error(Module, "Getting total points in tree for specIndex "..tostring(specIndex).." but no talent trees exist in MoP+")
return nil
elseif GetSpecializationInfo then
return (select(7,GetSpecializationInfo(specIndex)))
else
local selector=SAO.IsCata() and 5 or 3
return (select(selector,GetTalentTabInfo(specIndex)))
end
end
function SAO:GetSpecsFromTalent(talentID)
if type(talentID)~='number' or talentID >=0 then
SAO:Error(Module, "Getting specializations for a non-negative talentID "..tostring(talentID))
return nil
end
local specs={}
for spec=1,SAO:GetNbSpecs()do
local hasSpec=bit.band(-talentID,bit.lshift(1,spec-1))~=0
if hasSpec then
tinsert(specs,spec)
end
end
return specs
end
function SAO:GetTalentText(talentID)
if type(talentID)=='number' and talentID < 0 then
if not self.IsMoP()then
self:Error(Module, "Getting talent text for a negative talentID "..talentID.." but prior to the Mists of Pandaria specialization rework")
return nil
end
local specs=self:GetSpecsFromTalent(talentID)
if not specs or #specs==0 then
return nil
elseif #specs==1 then
local _,name,_,icon=GetSpecializationInfo(specs[1])
local text="|T"..icon..":0|t "..name
return SPECIALIZATION..": "..text
else
local text=""
for _,spec in ipairs(specs)do
local _,name,_,icon=GetSpecializationInfo(spec)
if text~="" then text=text.." / " end
text=text.."|T"..icon..":0|t "..name
end
return SPECIALIZATION..": "..text
end
else
local spellIconAndText=self:GetSpellIconAndText(talentID)
if not spellIconAndText then
self:Error(Module, "Unknown spell for talentID "..tostring(talentID))
return nil
end
return spellIconAndText
end
end
function SAO:GetNbSpecs()
return GetNumSpecializationsForClassID(select(2,UnitClassBase("player")))
end
function SAO:GetSpecName(specIndex)
if SAO.IsProject(SAO.MOP_AND_ONWARD)==false then
return (select(2,GetSpecializationInfo(specIndex)))
elseif GetSpecializationInfo then
return (select(2,GetSpecializationInfo(specIndex)))
else
local selector=SAO.IsCata() and 2 or 1
return (select(selector,GetTalentTabInfo(specIndex)))
end
end
function SAO:GetSpecNameFunction(specIndex)
if not GetSpecializationInfo then
return nil
end
return function()
return (select(2,GetSpecializationInfo(specIndex)))
end
end
function SAO:GetSpellIDByActionSlot(actionSlot)
local actionType,id,subType=GetActionInfo(actionSlot)
if actionType=="spell" then
return id
elseif actionType=="macro" then
return GetMacroSpell(id)
end
end
function SAO:GetHomonymSpellIDs(spell)
local spellName
if type(spell)=="string" then
spellName=spell
elseif type(spell)=="number" then
spellName=self:GetSpellName(spell)
end
if not spellName then
return {}
end
local homonyms={}
for tab=1,GetNumSpellTabs()do
local offset,numSlots=select(3,GetSpellTabInfo(tab))
for index=offset+1,offset+numSlots do
local name,_,id=GetSpellBookItemName(index,BOOKTYPE_SPELL)
if (name==spellName)then
table.insert(homonyms,id)
end
end
end
return homonyms
end
function SAO:GetNbItemsEquipped(itemList)
local nbItems=0
for _,item in ipairs(itemList)do
if IsEquippedItem(item)then
nbItems=nbItems + 1
end
end
return nbItems
end
function SAO:HashNameFromHashNumber(hash)
return self.Hash:new(hash):toString()
end
function SAO:HashNameFromStacks(stacks)
local hash=self.Hash:new()
hash:setAuraStacks(stacks)
return hash:toString()
end
local eventHandlers={}
local function getHandlerName(handler)
return handler.GetName and tostring(handler:GetName()) or tostring(handler)
end
local function getFromDescription(from)
if type(from)=='string' then
return " from "..from
else
return ""
end
end
function SAO:RegisterEventHandler(handler,event,from)
if false or
false then
self:Warn(Module, "Refusing to register handler for " ..tostring(event).. " for "..getHandlerName(handler)..getFromDescription(from))
return
end
if not eventHandlers then
eventHandlers={}
end
if not eventHandlers[event] then
eventHandlers[event]={}
end
table.insert(eventHandlers[event],handler)
handler:RegisterEvent(event)
SAO:Debug(Module, "Handling event "..tostring(event).." for "..getHandlerName(handler)..getFromDescription(from))
end
function SAO:UnregisterEventHandler(handler,event,from)
local found=false
for i,h in ipairs(eventHandlers[event] or {})do
if h==handler then
table.remove(eventHandlers[event],i)
handler:UnregisterEvent(event)
SAO:Debug(Module, "Un-handling event "..tostring(event).." for "..getHandlerName(handler)..getFromDescription(from))
found=true
break
end
end
if not found then
SAO:Warn(Module, "Could not unregister event "..tostring(event).." for "..getHandlerName(handler)..getFromDescription(from))
end
end
SAO.GlowInterface={
bind=function(self,obj)
self.__index=nil
setmetatable(obj,self)
self.__index=self
end,
initVars=function(self,id,name,separateAuraID,maxDuration,variantValues,optionTestFunc)
self.spellID=id
self.spellName=name
local shiftID=separateAuraID and 1000000 or 0
if type(separateAuraID)=='number' then
shiftID=shiftID * separateAuraID
end
self.auraID=id + shiftID
self.optionID=id
self.glowing=false
self.vanishTime=nil
self.maxDuration=maxDuration
self.variants=variantValues and SAO:CreateStringVariants("glow",self.optionID,self.spellID,variantValues) or nil
self.optionTestFunc=self.variants and optionTestFunc or nil
end,
glow=function(self,skipTimer)
if type(self.optionTestFunc)~='function' or self.optionTestFunc(self.variants.getOption())then
SAO:AddGlow(self.auraID,{self.spellName})
self.glowing=true
if self.maxDuration and not skipTimer then
local tolerance=0.2
self.vanishTime=GetTime() + self.maxDuration - tolerance
C_Timer.After(self.maxDuration,function()
self:timeout()
end)
end
end
end,
unglow=function(self,skipTimer)
SAO:RemoveGlow(self.auraID)
self.glowing=false
if not skipTimer then
self.vanishTime=nil
end
end,
timeout=function(self)
if self.vanishTime and GetTime() > self.vanishTime then
self:unglow()
if type(self.onTimeout)=='function' then
self:onTimeout()
end
end
end,
}
function SAO:DumpCopyableText(title,text)
local f=CreateFrame("Frame") f:SetPoint("TOPLEFT",200,-200) f:SetWidth(256) f:SetHeight(256) f.t=f:CreateTexture() f.t:SetColorTexture(0,0,0.5); f.t:SetAllPoints()
local CBT=function(b,icon) b[icon]=b:CreateTexture() b[icon]:SetTexture("Interface/Buttons/UI-Panel-MinimizeButton-"..icon) b[icon]:SetAllPoints() b[icon]:SetTexCoord(0.08,0.9,0.1,0.9) return b[icon] end
local b=CreateFrame("Button",nil,f) b:SetPoint("TOPRIGHT",0,0) b:SetWidth(14) b:SetHeight(14) b:SetScript("OnClick",function() f:Hide() end) b:SetNormalTexture(CBT(b,"Up")) b:SetPushedTexture(CBT(b,"Down")) b:SetHighlightTexture(CBT(b,"Highlight"))
local g=CreateFrame("EditBox",nil,f) g:SetMultiLine(true) g:SetAutoFocus(false) g:SetAllPoints() g:SetFontObject(GameTooltipTextSmall) g:SetText(title.."\n"..text)
end
