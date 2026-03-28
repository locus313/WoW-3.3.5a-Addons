local AddonName,SAO=...
local Module="warrior"
local CombatLogGetCurrentEventInfo=CombatLogGetCurrentEventInfo
local GetShapeshiftForm=GetShapeshiftForm
local UnitCanAttack=UnitCanAttack
local UnitGUID=UnitGUID
local UnitHealth=UnitHealth
local UnitHealthMax=UnitHealthMax
local cleave=845
local colossusSmash=86346
local execute=5308
local heroicStrike=78
local impendingVictory=103840
local overpower=7384
local ragingBlowSoD=402911
local revenge=6572
local shieldSlam=23922
local slam=1464
local victoryRush=SAO.IsSoD() and 402927 or 34428
local wildStrike=100130
local function easyAs123(option)
return option=="stance:1/2/3"
end
local OverpowerHandler={
initialized=false,
targetGuid=nil,
init=function(self,id,name)
SAO.GlowInterface:bind(self)
self:initVars(id,name,true,5,{
SAO:StanceVariantValue({1}),
SAO:StanceVariantValue({1,2,3}),
},easyAs123)
self.initialized=true
end,
dodge=function(self,guid)
self.targetGuid=guid
if UnitGUID("target")==guid then
self:glow()
end
end,
overpower=function(self)
self.targetGuid=nil
self:unglow()
end,
retarget=function(self,...)
if not self.targetGuid then return end
if self.glowing and UnitGUID("target")~=self.targetGuid then
self:unglow(true)
elseif not self.glowing and UnitGUID("target")==self.targetGuid then
self:glow(true)
end
end,
onTimeout=function(self)
self.targetGuid=nil
end,
cleu=function(self,...)
local timestamp,event,_,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags,destRaidFlags=...
if sourceGUID~=UnitGUID("player")then return end
if event=="SWING_MISSED" and select(12,...)=="DODGE"
or event=="SPELL_MISSED" and select(15,...)=="DODGE" then
self:dodge(destGUID)
elseif event=="SPELL_CAST_SUCCESS" and select(13,...)==self.spellName then
self:overpower()
end
end,
}
local OPTFBHandler={
initialized=false,
buffID=nil,
hasBuff=nil,
init=function(self,id,name,buffID)
SAO.GlowInterface:bind(self)
self:initVars(id,name,2,nil,{
SAO:StanceVariantValue({1}),
SAO:StanceVariantValue({1,2,3}),
},function(option)
return option=="stance:1/2/3" or GetShapeshiftForm()==1
end)
self.buffID=buffID
self.hasBuff=SAO:HasPlayerAuraBySpellID(self.buffID)
if self.hasBuff then
self:glow()
end
self.initialized=true
end,
cleu=function(self,...)
local _,event,_,_,_,_,_,destGUID=...
if destGUID~=UnitGUID("player")then return end
if (event:sub(0,11)~="SPELL_AURA_")then return end
local spellID,spellName=select(12,CombatLogGetCurrentEventInfo())
if event=="SPELL_AURA_APPLIED" and SAO:IsSpellIdentical(spellID,spellName,self.buffID)then
if not self.hasBuff then
self.hasBuff=true
self:glow()
end
elseif event=="SPELL_AURA_REMOVED" and SAO:IsSpellIdentical(spellID,spellName,self.buffID)then
self.hasBuff=false
self:unglow()
end
end,
}
local RevengeHandler={
initialized=false,
init=function(self,id,name)
SAO.GlowInterface:bind(self)
self:initVars(id,name,true,5,{
SAO:StanceVariantValue({2}),
SAO:StanceVariantValue({1,2,3}),
},easyAs123)
self.initialized=true
end,
dpb=function(self)
self:glow()
end,
revenge=function(self)
self:unglow()
end,
cleu=function(self,...)
local timestamp,event,_,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags,destRaidFlags=...
local myGuid=UnitGUID("player")
if sourceGUID==myGuid then
if event=="SPELL_CAST_SUCCESS" and select(13,...)==self.spellName then
self:revenge()
end
end
if destGUID==myGuid then
if event:sub(0,6)=="SPELL_" then
local spellID=select(12,...)
if spellID==42463 or spellID==53739 then
return
end
end
if event=="SWING_MISSED" or event=="SPELL_MISSED" then
local missType
if event=="SWING_MISSED" then
missType=select(12,...)
elseif event=="SPELL_MISSED" then
missType=select(15,...)
end
if missType=="DODGE" or missType=="PARRY" or missType=="BLOCK" then
self:dpb()
end
elseif event=="SWING_DAMAGE" or event=="SPELL_DAMAGE" then
local blocked
if event=="SWING_DAMAGE" then
blocked=select(16,...)
elseif event=="SPELL_DAMAGE" then
blocked=select(19,...)
end
if blocked then
self:dpb()
end
end
end
end,
}
local ExecuteHandler={
initialized=false,
init=function(self,id,name)
SAO.GlowInterface:bind(self)
self:initVars(id,name,true,nil,{
SAO:StanceVariantValue({1,3}),
SAO:StanceVariantValue({1,2,3}),
},easyAs123)
self.initialized=true
end,
checkTargetHealth=function(self)
local canExecute=false
if UnitCanAttack("player", "target")then
local hp=UnitHealth("target")
local hpMax=UnitHealthMax("target")
canExecute=hp > 0 and hp/hpMax < 0.2
end
if canExecute and not self.glowing then
self:glow()
elseif not canExecute and self.glowing then
self:unglow()
end
end,
retarget=function(self,...)
self:checkTargetHealth()
end,
healthChanged=function(self,unitID)
if unitID=="target" then
self:checkTargetHealth()
end
end
}
local function customLogin(self,...)
if SAO.IsMoP()then
return
end
local overpowerName=self:GetSpellName(overpower)
if overpowerName then
OverpowerHandler:init(overpower,overpowerName)
if self.IsSoD()then
local tasteForBloodBuff=426969
OPTFBHandler:init(overpower,overpowerName,tasteForBloodBuff)
elseif self.IsWrath() or self.IsCata()then
local tasteForBloodBuffSoD=60503
OPTFBHandler:init(overpower,overpowerName,tasteForBloodBuffSoD)
end
end
local revengeName=self:GetSpellName(revenge)
if revengeName then
RevengeHandler:init(revenge,revengeName)
end
local executeName=self:GetSpellName(execute)
if executeName then
ExecuteHandler:init(execute,executeName)
end
end
local function customCLEU(self,...)
if OverpowerHandler.initialized then
OverpowerHandler:cleu(CombatLogGetCurrentEventInfo())
end
if OPTFBHandler.initialized then
OPTFBHandler:cleu(CombatLogGetCurrentEventInfo())
end
if RevengeHandler.initialized then
RevengeHandler:cleu(CombatLogGetCurrentEventInfo())
end
end
local function retarget(self,...)
if OverpowerHandler.initialized then
OverpowerHandler:retarget(...)
end
if ExecuteHandler.initialized then
ExecuteHandler:retarget(...)
end
end
local function unitHealth(self,unitID)
if ExecuteHandler.initialized then
ExecuteHandler:healthChanged(unitID)
end
end
local function unitHealthFrequent(self,unitID)
if self:IsResponsiveMode()then
unitHealth(self,unitID)
end
end
local function useOverpower()
SAO:CreateEffect(
"overpower",
SAO.ALL_PROJECTS - SAO.MOP_AND_ONWARD,
overpower,
"counter",
{
buttonOption=not SAO.IsMoP() and {variants=function() return OverpowerHandler.variants end} or nil,
}
)
end
local function useExecute()
SAO:CreateEffect(
"execute",
SAO.ALL_PROJECTS - SAO.MOP_AND_ONWARD,
execute,
"counter",
{
buttonOption=not SAO.IsMoP() and {variants=function() return ExecuteHandler.variants end} or nil,
}
)
end
local function useRevenge()
SAO:CreateEffect(
"revenge",
SAO.ALL_PROJECTS - SAO.MOP_AND_ONWARD,
revenge,
"counter",
{
buttonOption=not SAO.IsMoP() and {variants=function() return RevengeHandler.variants end} or nil,
}
)
end
local function useVictoryRush()
SAO:CreateEffect(
"victory_rush",
SAO.ALL_PROJECTS - SAO.ERA - SAO.MOP_AND_ONWARD,
victoryRush,
"counter"
)
SAO:CreateEffect(
"victory_rush",
SAO.MOP_AND_ONWARD,
32216,
"aura",
{
overlay={texture="serendipity",position="Top",level=4,scale=0.9,color={255,32,32}},
buttons={victoryRush,impendingVictory},
}
)
end
local function useRagingBlow()
SAO:CreateEffect(
"raging_blow",
SAO.SOD,
ragingBlowSoD,
"counter",
{
overlay={texture="raging_blow",position="Left + Right (Flipped)"},
}
)
end
local function useSuddenDeath()
SAO:CreateEffect(
"sudden_death",
SAO.SOD + SAO.WRATH_AND_ONWARD,
{
[SAO.SOD]=440114,
[SAO.WRATH]=52437,
[SAO.CATA]=52437,
[SAO.MOP]=52437,
},
"aura",
{
talent={
[SAO.SOD]=440113,
[SAO.WRATH]=29723,
[SAO.CATA]=29723,
[SAO.MOP]=29725,
},
overlay={texture="sudden_death",position="Left + Right (Flipped)"},
buttons={
[SAO.SOD]=execute,
[SAO.WRATH]=execute,
[SAO.CATA]=colossusSmash,
},
}
)
end
local function useTasteForBlood()
local hash0Stacks=SAO:HashNameFromStacks(0)
local hash5Stacks=SAO:HashNameFromStacks(5)
SAO:CreateEffect(
"taste_for_blood",
SAO.MOP,
60503,
"aura",
{
talent=56636,
overlays={
default={texture="bandits_guile",position="Left + Right (Flipped)",level=4,scale=0.9,option=false},
{stacks=1,position="Left",option={setupHash=hash0Stacks,testHash=hash5Stacks}},
{stacks=2},
{stacks=3},
{stacks=4},
{stacks=5},
},
button=overpower,
}
)
end
local function useBladestorm()
if SAO.IsProject(SAO.MOP_AND_ONWARD)then
return
end
local bladestorm=46924
local race=select(3,UnitRace("player"))
local gender=UnitSex("player")
local ccw={"Left (vFlipped)", "Right (Flipped)"}
local cw={"Left", "Right (180)"}
local positions={
[1]={nil,ccw,ccw},
[2]={nil,ccw,ccw},
[3]={nil,ccw,ccw},
[4]={nil,ccw,ccw},
[5]={nil,ccw,ccw},
[6]={nil,ccw,ccw},
[7]={nil,ccw,ccw},
[8]={nil,ccw,cw},
[9]={nil,cw ,cw},
[10]={nil,ccw,cw},
[11]={nil,ccw,ccw},
[22]={nil,ccw,ccw},
}
if not positions[race] then
SAO:Error(Module, "Unknown race "..tostring((UnitRace("player"))))
race=2
end
if not positions[race][gender] then
SAO:Error(Module, "Unknown gender "..tostring(gender))
gender=2
end
SAO:CreateEffect(
"bladestorm",
SAO.WRATH + SAO.CATA,
bladestorm,
"aura",
{
overlays={
default={texture="bandits_guile",scale=1.25,color={200,200,200}},
{position=positions[race][gender][1],option=false},
{position=positions[race][gender][2],option=true},
},
}
)
end
local function useBattleTrance()
local battleTranceBuff=12964
local battleTranceTalent=12322
SAO:CreateEffect(
"battle_trance",
SAO.CATA,
battleTranceBuff,
"aura",
{
talent=battleTranceTalent,
buttons={heroicStrike,cleave},
}
)
end
local function useBloodsurge()
local hash0Stacks=SAO:HashNameFromStacks(0)
local hash3Stacks=SAO:HashNameFromStacks(3)
SAO:CreateEffect(
"bloodsurge",
SAO.SOD + SAO.WRATH_AND_ONWARD,
{
[SAO.SOD]=413399,
[SAO.WRATH]=46916,
[SAO.CATA]=46916,
[SAO.MOP]=46916,
},
"aura",
{
talent={
[SAO.SOD]=413380,
[SAO.WRATH]=46913,
[SAO.CATA]=46913,
[SAO.MOP]=46915,
},
overlays={
[SAO.SOD+SAO.WRATH]={texture="blood_surge",position="Top"},
[SAO.CATA]={texture="blood_surge",position="Left + Right (Flipped)"},
[SAO.MOP]={
{stacks=1,texture="blood_surge",position="Left",option=false},
{stacks=2,texture="blood_surge",position="Left + Right (Flipped)",option=false},
{stacks=3,texture="blood_surge",position="Left + Right (Flipped)",option={setupHash=hash0Stacks,testHash=hash3Stacks}},
},
},
buttons={
[SAO.SOD+SAO.WRATH+SAO.CATA]=slam,
},
}
)
end
local function useSwordAndBoard()
SAO:CreateEffect(
"sword_and_board",
SAO.SOD + SAO.WRATH_AND_ONWARD,
{
[SAO.SOD]=426979,
[SAO.WRATH]=50227,
[SAO.CATA]=50227,
[SAO.MOP]=50227,
},
"aura",
{
talent={
[SAO.SOD]=426978,
[SAO.WRATH]=46951,
[SAO.CATA]=46951,
[SAO.MOP]=46953,
},
overlay={texture="sword_and_board",position="Left + Right (Flipped)"},
buttons={
[SAO.SOD + SAO.WRATH + SAO.CATA]=shieldSlam,
},
}
)
end
local function useUltimatum()
local ultimatumBuff=122510
local ultimatumTalent=122509
SAO:CreateEffect(
"ultimatum",
SAO.MOP,
ultimatumBuff,
"aura",
{
talent=ultimatumTalent,
overlay={texture="ultimatum",position="Top"},
}
)
end
local function useIncite()
local inciteBuff=86627
local inciteTalent=50685
SAO:CreateEffect(
"incite",
SAO.CATA,
inciteBuff,
"aura",
{
talent=inciteTalent,
button=heroicStrike,
}
)
end
local function useGlyphOfIncite()
local glyphOfInciteBuff=122016
local glyphOfInciteTalent=122013
SAO:CreateEffect(
"glyph_of_incite",
SAO.MOP,
glyphOfInciteBuff,
"aura",
{
talent=glyphOfInciteTalent,
buttons={heroicStrike,cleave},
}
)
end
local function useRegicide()
local regicideBuff=1231436
SAO:CreateEffect(
"regicide_warrior",
SAO.SOD,
regicideBuff,
"aura",
{
overlay={texture="sudden_death",position="Left + Right (Flipped)"},
button=execute,
}
)
end
local function registerClass(self)
useOverpower()
useExecute()
useRevenge()
useVictoryRush()
useRagingBlow()
useSuddenDeath()
useTasteForBlood()
useBladestorm()
useBattleTrance()
useBloodsurge()
useSwordAndBoard()
useUltimatum()
useIncite()
useGlyphOfIncite()
useRegicide()
end
SAO.Class["WARRIOR"]={
["Register"]=registerClass,
["COMBAT_LOG_EVENT_UNFILTERED"]=customCLEU,
["PLAYER_LOGIN"]=customLogin,
["PLAYER_TARGET_CHANGED"]=retarget,
["UNIT_HEALTH"]=unitHealth,
["UNIT_HEALTH_FREQUENT"]=(not SAO.HasMidnightEvents()) and unitHealthFrequent or nil,
}
