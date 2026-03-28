local AddonName,SAO=...
local Module="rogue"
local CombatLogGetCurrentEventInfo=CombatLogGetCurrentEventInfo
local GetTime=GetTime
local UnitGUID=UnitGUID
local RiposteHandler={
initialized=false,
hash=nil,
init=function(self,id,name)
SAO.GlowInterface:bind(self)
local variantValues={
SAO:CooldownVariantValue({"off"}),
SAO:CooldownVariantValue({"off", "on"}),
}
self:initVars(id,name,true,5,variantValues,function (option)
return option=="cd:off/on"
end)
self.alertVariants=SAO:CreateStringVariants("alert",self.optionID,0,variantValues)
self.alerting=false
self.lastRiposteTime=nil
local hash=SAO.Hash:new()
hash:setActionUsable(true)
hash:setTalented(true)
self.hash=hash.hash
self.initialized=true
end,
parried=function(self)
if self.lastRiposteTime and GetTime() < self.lastRiposteTime + 1 then
SAO:Debug(Module, "Ignoring a parry event because it occurred less than 1 second after last Riposte cast")
return
end
self:glow()
self:alert()
end,
riposte=function(self)
self.lastRiposteTime=GetTime()
self:unglow()
self:unalert()
end,
cleu=function(self,...)
local timestamp,event,_,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags,destRaidFlags=...
local myGuid=UnitGUID("player")
if sourceGUID==myGuid then
if event=="SPELL_CAST_SUCCESS" and select(13,...)==self.spellName then
self:riposte()
end
end
if destGUID==myGuid and (event=="SWING_MISSED" or event=="SPELL_MISSED")then
local missType
if event=="SWING_MISSED" then
missType=select(12,...)
elseif event=="SPELL_MISSED" then
missType=select(15,...)
end
if missType=="PARRY" then
self:parried()
end
end
end,
alert=function(self)
if self.optionTestFunc(self.alertVariants.getOption())then
if not self.alerting then
local bucket=SAO:GetBucketByName("riposte")
if bucket then
bucket[self.hash]:showOverlays()
end
self.alerting=true
end
local tolerance=0.2
self.alertVanishTime=GetTime() + self.maxDuration - tolerance
C_Timer.After(self.maxDuration,function()
if self.alertVanishTime and GetTime() > self.alertVanishTime then
self:unalert()
end
end)
end
end,
unalert=function(self)
if self.alerting then
self.alerting=false
local bucket=SAO:GetBucketByName("riposte")
if bucket then
bucket[self.hash]:hideOverlays()
end
self.alertVanishTime=nil
end
end,
}
local function customLogin(self,...)
local riposteSpellID=14251
local riposteSpellName=SAO:GetSpellName(riposteSpellID)
if riposteSpellName then
RiposteHandler:init(riposteSpellID,riposteSpellName)
end
end
local function customCLEU(self,...)
if RiposteHandler.initialized then
RiposteHandler:cleu(CombatLogGetCurrentEventInfo())
end
end
local function useRiposte()
local riposte=14251
local riposteOverlayOption={variants=function() return RiposteHandler.alertVariants end}
local riposteButtonOption={variants=function() return RiposteHandler.variants end}
SAO:CreateEffect(
"riposte",
SAO.ERA + SAO.TBC + SAO.WRATH,
riposte,
"counter",
{
talent=riposte,
requireTalent=true,
useName=false,
overlay={texture="bandits_guile",position="Top (CW)",option=riposteOverlayOption},
buttonOption=riposteButtonOption,
}
)
end
local function useMurderousIntent()
local backstab=53
local murderousIntent=14158
SAO:CreateEffect(
"murderous_intent",
SAO.CATA,
murderousIntent,
"execute",
{
execThreshold=35,
requireTalent=true,
button=backstab,
}
)
end
local function useCutthroat()
local ambush=8676
local cutthroatBuff=462707
local cutthroatRune=424980
SAO:CreateEffect(
"cutthroat",
SAO.SOD,
cutthroatBuff,
"aura",
{
talent=cutthroatRune,
overlay={texture="white_tiger",position="Left + Right (Flipped)"},
button=ambush,
}
)
end
local function useBlindside()
local blindsideBuff=121153
local blindsideTalent=121152
SAO:CreateEffect(
"blindside",
SAO.MOP,
blindsideBuff,
"aura",
{
talent=blindsideTalent,
overlay={texture="sudden_death",position="Left + Right (Flipped)"},
}
)
end
local function useDispatch()
local dispatch=111240
SAO:CreateEffect(
"dispatch",
SAO.MOP_AND_ONWARD,
dispatch,
"execute",
{
execThreshold=35,
button=dispatch,
}
)
end
local function registerClass(self)
useRiposte()
useMurderousIntent()
useCutthroat()
useBlindside()
useDispatch()
end
local hasRiposte=SAO.IsProject(SAO.ERA + SAO.TBC + SAO.WRATH)
SAO.Class["ROGUE"]={
["Register"]=registerClass,
["PLAYER_LOGIN"]=hasRiposte and customLogin or nil,
["COMBAT_LOG_EVENT_UNFILTERED"]=hasRiposte and customCLEU or nil,
}
