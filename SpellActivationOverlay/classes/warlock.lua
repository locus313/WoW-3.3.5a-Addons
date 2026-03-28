local AddonName,SAO=...
local Module="warlock"
local UnitCanAttack=UnitCanAttack
local UnitHealth=UnitHealth
local UnitHealthMax=UnitHealthMax
local WARLOCK_SPEC_AFFLICTION=SAO.TALENT.SPEC_1
local WARLOCK_SPEC_DEMONOLOGY=SAO.TALENT.SPEC_2
local WARLOCK_SPEC_DESTRUCTION=SAO.TALENT.SPEC_3
local chaosBoltCata=50796
local chaosBoltMoP=116858
local conflagrateFAB=108685
local curseElementsFAB=104225
local curseEnfeeblementFAB=109468
local drainSoul=1120
local felFlame=77799
local felSpark=89937
local hellfire=1949
local immolateFAB=108686
local incinerate=29722
local incinerateFAB=114654
local rainOfFire=104232
local shadowBolt=686
local shadowburn=17877
local shadowCleave=403841
local seedOfCorruption=27285
local soulFire=6353
local soulSwap=86121
local moltenCoreBuff={47383,71162,71165}
local decimationBuff={63165,63167}
local backdraftBuff={54274,54276,54277}
local moltenCoreOrange=122355
local moltenCoreGreen=140074
local requiresDrainSoulHandler=SAO.IsWrath() or SAO.IsCata()
local DrainSoulHandler={
initialized=false,
checkOption=function(option)
if option=="spec:1/2/3" then
return true
elseif option=="spec:1" then
local afflictionPoints=SAO:GetTotalPointsInTree(1)
local demonologyPoints=SAO:GetTotalPointsInTree(2)
local destructionPoints=SAO:GetTotalPointsInTree(3)
return afflictionPoints > demonologyPoints and afflictionPoints > destructionPoints
end
return false
end,
init=function(self,id,name)
SAO.GlowInterface:bind(self)
self:initVars(id,name,false,nil,{
SAO:SpecVariantValue({1}),
SAO:SpecVariantValue({1,2,3}),
},self.checkOption)
self.initialized=true
end,
checkTargetHealth=function(self)
local canExecute=false
if UnitCanAttack("player", "target")then
local hp=UnitHealth("target")
local hpMax=UnitHealthMax("target")
canExecute=hp > 0 and hp/hpMax <=0.25
end
if canExecute and not self.glowing then
self:glow()
elseif not canExecute and self.glowing then
self:unglow()
end
end,
}
local function customLogin(self,...)
local spellName=self:GetSpellName(drainSoul)
if spellName then
self:RegisterGlowIDs({spellName})
local allSpellIDs=self:GetSpellIDsByName(spellName)
for _,oneSpellID in ipairs(allSpellIDs)do
self:AwakeButtonsBySpellID(oneSpellID)
end
DrainSoulHandler:init(drainSoul,spellName)
end
end
local function retarget(self,...)
if DrainSoulHandler.initialized then
DrainSoulHandler:checkTargetHealth()
end
end
local function unitHealth(self,unitID)
if DrainSoulHandler.initialized and unitID=="target" then
DrainSoulHandler:checkTargetHealth()
end
end
local function unitHealthFrequent(self,unitID)
if self:IsResponsiveMode()then
unitHealth(self,unitID)
end
end
local function useDrainSoul(self)
self:CreateEffect(
"drain_soul",
SAO.SOD + SAO.MOP_AND_ONWARD,
drainSoul,
"execute",
{
execThreshold=20,
requireTalent=SAO.IsSoD(),
talent={
[SAO.SOD]=403511,
},
button=drainSoul,
}
)
end
local function useEyeOfKilrogg(self)
self:CreateEffect(
"eye_of_kilrogg",
SAO.ALL_PROJECTS,
126,
"aura",
{
overlay={texture="generictop_01",position="Top",color={64,255,64},pulse=false},
}
)
end
local function useNightfall(self)
local SAO_UP_UNTIL_CATA=SAO.ERA + SAO.TBC + SAO.WRATH + SAO.CATA
self:CreateEffect(
"nightfall",
SAO.ALL_PROJECTS,
17941,
"aura",
{
talent={
[SAO_UP_UNTIL_CATA]=18094,
[SAO.MOP]=108558,
},
overlays={
default={texture="nightfall",position="Left + Right (Flipped)"},
[SAO_UP_UNTIL_CATA]={pulse=true},
[SAO.MOP_AND_ONWARD]={pulse=false,scale=0.8,level=4},
},
buttons={
[SAO_UP_UNTIL_CATA]=shadowBolt,
[SAO.SOD]=shadowCleave,
},
}
)
end
local function useSoulburn(self)
self:CreateEffect(
"soulburn",
SAO.CATA + SAO.MOP,
74434,
"aura",
{
overlay={texture="shadow_word_insanity",position="Left + Right (Flipped)",level=2,pulse=false,scale=1.1,color={222,222,222}},
}
)
end
local function useSoulSwap(self)
self:CreateEffect(
"soul_swap",
SAO.MOP,
86211,
"aura",
{
overlay={texture="sudden_doom",position="Left + Right (Flipped)",scale=1.25},
button=soulSwap,
}
)
end
local function registerMoltenCore(self,rank)
local moltenCoreName={"molten_core_low", "molten_core_medium", "molten_core_high"}
local overlayOption=(rank==3) and {setupHash=SAO:HashNameFromStacks(0),testHash=SAO:HashNameFromStacks(3)}
local buttonOption=rank==3
self:CreateEffect(
moltenCoreName[rank],
SAO.WRATH + SAO.CATA,
moltenCoreBuff[rank],
"aura",
{
talent=47245,
overlays={
{stacks=1,texture="molten_core",position="Left",option=false},
{stacks=2,texture="molten_core",position="Left + Right (Flipped)",option=false},
{stacks=3,texture="molten_core",position="Left + Right (Flipped)",option=overlayOption},
},
buttons={
default={option=buttonOption},
[SAO.WRATH]={incinerate,soulFire},
[SAO.CATA]={incinerate},
},
}
)
end
local function useMoltenCore(self)
if self.IsWrath() or self.IsCata()then
self:AddOverlayLink(moltenCoreBuff[3],moltenCoreBuff[1])
self:AddOverlayLink(moltenCoreBuff[3],moltenCoreBuff[2])
self:AddGlowingLink(moltenCoreBuff[3],moltenCoreBuff[1])
self:AddGlowingLink(moltenCoreBuff[3],moltenCoreBuff[2])
registerMoltenCore(self,1)
registerMoltenCore(self,2)
registerMoltenCore(self,3)
end
if SAO.IsMoP()then
local hash0Stacks=self:HashNameFromStacks(0)
local hash2Stacks=self:HashNameFromStacks(2)
local handler={
onAboutToApplyHash=function(hashCalculator)
local mustRefresh=false
local currentStacks=hashCalculator:getAuraStacks()
if type(currentStacks)=='number' and currentStacks > 2 then
hashCalculator:setAuraStacks(2)
if hashCalculator.lastAuraStacks~=currentStacks then
mustRefresh=true
end
end
hashCalculator.lastAuraStacks=currentStacks
return mustRefresh
end,
}
self:CreateEffect(
"molten_core",
SAO.MOP,
moltenCoreOrange,
"aura",
{
aka=126090,
overlays={
default={texture="molten_core",option=false},
{stacks=1,position="Left"},
{stacks=2,position="Left + Right (Flipped)",option={setupHash=hash0Stacks,testHash=hash2Stacks}},
},
handler=handler,
}
)
self:CreateEffect(
"molten_core_red",
SAO.MOP,
moltenCoreGreen,
"aura",
{
aka=140075,
overlays={
default={texture="molten_core_green",option=false},
{stacks=1,position="Left"},
{stacks=2,position="Left + Right (Flipped)"},
},
handler=handler,
}
)
self:AddOverlayLink(moltenCoreOrange,moltenCoreGreen)
end
end
local function unitAura(self,unitTarget,updateInfo)
if UnitIsUnit(unitTarget, "player")then
if updateInfo and updateInfo.updatedAuraInstanceIDs then
for _,id in ipairs(updateInfo.updatedAuraInstanceIDs)do
local auraData=C_UnitAuras.GetAuraDataByAuraInstanceID("player",id)
if auraData
and (auraData.spellId==moltenCoreOrange or auraData.spellId==moltenCoreGreen)
and auraData.applications >=10
then
local bucket=self:GetBucketBySpellID(auraData.spellId)
if bucket then
bucket:refresh()
SAO:Debug(Module,string.format("Refreshing the %dth stack of %d",auraData.applications,auraData.spellId))
end
end
end
end
end
end
local function registerDecimation(self,rank)
local decimationName={"decimation_low", "decimation_high"}
self:CreateEffect(
decimationName[rank],
SAO.WRATH + SAO.CATA,
decimationBuff[rank],
"aura",
{
talent=63156,
overlay={texture="impact",position="Top",scale=0.8,option=(rank==2)},
button={spellID=soulFire,option=(rank==2)},
}
)
end
local function useDecimation(self)
if self.IsWrath() or self.IsCata()then
self:AddOverlayLink(decimationBuff[2],decimationBuff[1])
self:AddGlowingLink(decimationBuff[2],decimationBuff[1])
registerDecimation(self,1)
registerDecimation(self,2)
elseif self.IsSoD()then
self:CreateEffect(
"decimation",
SAO.SOD,
440873,
"aura",
{
talent=440870,
overlay={texture="impact",position="Top",scale=0.8},
button={spellID=soulFire},
}
)
end
end
local function useDemonicRebirth(self)
self:CreateEffect(
"demonic_rebirth",
SAO.CATA + SAO.MOP,
88448,
"aura",
{
overlay={texture="dark_transformation",position="Top",scale=1.2,color={222,222,222},level=2},
}
)
end
local function registerBackdraft(self,rank)
local backdraftName={"backdraft_low", "backdraft_medium", "backdraft_high"}
self:CreateEffect(
backdraftName[rank],
SAO.CATA,
backdraftBuff[rank],
"aura",
{
talent=47258,
buttons={
default={option=(rank==3)},
[SAO.CATA]={shadowBolt,incinerate,chaosBoltCata},
},
}
)
end
local function useBackdraft(self)
if self.IsCata()then
self:AddOverlayLink(backdraftBuff[3],backdraftBuff[1])
self:AddOverlayLink(backdraftBuff[3],backdraftBuff[2])
self:AddGlowingLink(backdraftBuff[3],backdraftBuff[1])
self:AddGlowingLink(backdraftBuff[3],backdraftBuff[2])
registerBackdraft(self,1)
registerBackdraft(self,2)
registerBackdraft(self,3)
else
self:CreateEffect(
"backdraft",
SAO.MOP,
117828,
"aura",
{
talent=117896,
buttons={
{stacks=0,spellID=incinerate},
{stacks=3,spellID=chaosBoltMoP},
},
handler={
onAboutToApplyHash=function(hashCalculator)
local mustRefresh=false
local currentStacks=hashCalculator:getAuraStacks()
if type(currentStacks)=='number' then
if currentStacks==2 then
hashCalculator:setAuraStacks(1)
elseif currentStacks > 3 then
hashCalculator:setAuraStacks(3)
end
if hashCalculator.lastAuraStacks~=currentStacks then
mustRefresh=true
end
end
hashCalculator.lastAuraStacks=currentStacks
return mustRefresh
end,
},
}
)
end
end
local function useShadowburn(self)
self:CreateEffect(
"shadowburn",
SAO.CATA,
shadowburn,
"counter"
)
end
local function useBacklash(self)
local backlashOrange=34936
local backlashGreen=140076
self:CreateEffect(
"backlash",
SAO.TBC + SAO.WRATH + SAO.CATA + SAO.MOP,
backlashOrange,
"aura",
{
talent={
[SAO.TBC + SAO.WRATH + SAO.CATA]=34935,
[SAO.MOP]=108563,
},
overlay={texture="backlash",position="Top"},
buttons={
[SAO.TBC + SAO.WRATH + SAO.CATA]={shadowBolt,incinerate},
},
}
)
if SAO.IsMoP()then
self:CreateEffect(
"backlash_green",
SAO.MOP,
backlashGreen,
"aura",
{
talent=108563,
overlay={texture="backlash_green",position="Top",option=false},
}
)
self:AddOverlayLink(backlashOrange,backlashGreen)
end
end
local function useEmpoweredImp(self)
self:CreateEffect(
"empowered_imp",
SAO.WRATH + SAO.CATA,
47283,
"aura",
{
talent=47220,
overlay={texture="imp_empowerment",position="Left + Right (Flipped)"},
buttons={
[SAO.CATA]=soulFire,
}
}
)
end
local function useFireAndBrimstone(self)
self:CreateEffect(
"fire_and_brimstone",
SAO.MOP,
108683,
"aura",
{
overlay={texture="imp_empowerment",position="Left + Right (Flipped)",level=2,pulse=false,scale=1.1,color={222,222,222}},
buttons={immolateFAB,incinerateFAB,conflagrateFAB,curseElementsFAB,curseEnfeeblementFAB},
}
)
end
local function useMannorothsFury(self)
self:CreateEffect(
"mannoroths_fury",
SAO.MOP,
108508,
"aura",
{
overlays={
{texture="ultimatum",position="Left (CCW)",level=1,pulse=false,scale=1.4,color={150,255,150}},
{texture="ultimatum",position="Right (CW)",level=1,pulse=false,scale=1.4,color={150,255,150},option=false},
},
buttons={hellfire,seedOfCorruption,rainOfFire},
}
)
end
local function useFelSpark(self)
self:CreateEffect(
"fel_spark",
SAO.CATA,
felSpark,
"aura",
{
overlays={
{stacks=1,texture="impact",position="Left (CCW)",scale=0.6,color={22,222,122},option=false},
{stacks=2,texture="impact",position="Left (CCW)",scale=0.6,color={22,222,122},option=false},
{stacks=2,texture="impact",position="Right (CW)",scale=0.6,color={22,222,122},option={setupHash=self:HashNameFromStacks(0),testHash=self:HashNameFromStacks(2)}},
},
button=felFlame,
}
)
end
local function registerClass(self)
useDrainSoul(self)
useEyeOfKilrogg(self)
useNightfall(self)
useSoulburn(self)
useSoulSwap(self)
useMoltenCore(self)
useDecimation(self)
useDemonicRebirth(self)
useBackdraft(self)
useShadowburn(self)
useBacklash(self)
useEmpoweredImp(self)
useFireAndBrimstone(self)
useMannorothsFury(self)
useFelSpark(self)
end
local function loadOptions(self)
if DrainSoulHandler.initialized then
self:AddGlowingOption(nil,DrainSoulHandler.optionID,drainSoul,nil,SAO:ExecuteBelow(25),DrainSoulHandler.variants)
end
end
SAO.Class["WARLOCK"]={
["Register"]=registerClass,
["LoadOptions"]=loadOptions,
["PLAYER_LOGIN"]=requiresDrainSoulHandler and customLogin or nil,
["PLAYER_TARGET_CHANGED"]=requiresDrainSoulHandler and retarget or nil,
["UNIT_HEALTH"]=requiresDrainSoulHandler and unitHealth or nil,
["UNIT_HEALTH_FREQUENT"]=requiresDrainSoulHandler and (not SAO.HasMidnightEvents()) and unitHealthFrequent or nil,
["UNIT_AURA"]=SAO.IsMoP() and SAO.AURASTACKS.LEGACY and unitAura or nil,
}
