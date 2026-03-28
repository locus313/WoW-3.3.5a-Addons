local AddonName,SAO=...
local PRIEST_SPEC_DISCIPLINE=SAO.TALENT.SPEC_1
local PRIEST_SPEC_HOLY=SAO.TALENT.SPEC_2
local PRIEST_SPEC_SHADOW=SAO.TALENT.SPEC_3
local bindingHeal=SAO.IsSoD() and 401937 or 32546
local devouringPlague=2944
local flashHeal=2061
local flashHealNoMana=101062
local greaterHeal=2060
local heal=2054
local innerFire=588
local lesserHeal=2050
local mindBlast=8092
local mindSpike=73510
local prayerOfHealing=596
local shadowform=15473
local smite=585
local swDeath=32379
local function useInnerFire()
SAO:CreateEffect(
"inner_fire",
SAO.WRATH + SAO.CATA,
innerFire,
"aura",
{
combatOnly=true,
button={stacks=-1},
}
)
end
local function useSerendipity()
if SAO.IsMoP()then
SAO:CreateEffect(
"serendipity",
SAO.MOP,
63735,
"aura",
{
overlays={
default={texture="fury_of_stormrage_yellow",position="Top",level=2},
{stacks=1,scale=1.1,pulse=false},
{stacks=2,scale=1.2,pulse=true},
},
buttons={
default={stacks=2},
[SAO.MOP]={greaterHeal,prayerOfHealing},
},
}
)
elseif SAO.IsProject(SAO.TBC + SAO.WRATH + SAO.CATA)then
local serendipityBuff1=63731
local serendipityBuff2=63735
local serendipityBuff3=63734
local ghAndPoh={SAO:GetSpellName(greaterHeal),SAO:GetSpellName(prayerOfHealing)}
if SAO.IsWrath()then
SAO:AddOverlayLink(serendipityBuff3,serendipityBuff1)
SAO:AddOverlayLink(serendipityBuff3,serendipityBuff2)
SAO:AddGlowingLink(serendipityBuff3,serendipityBuff1)
SAO:AddGlowingLink(serendipityBuff3,serendipityBuff2)
elseif SAO.IsCata()then
SAO:AddOverlayLink(serendipityBuff2,serendipityBuff1)
SAO:AddGlowingLink(serendipityBuff2,serendipityBuff1)
end
if SAO.IsWrath()then
for talentPoints=1,3 do
local auraName=({"serendipity_low", "serendipity_medium", "serendipity_high"})[talentPoints]
local auraBuff=({serendipityBuff1,serendipityBuff2,serendipityBuff3})[talentPoints]
for nbStacks=1,3 do
local scale=0.4 + 0.2 * nbStacks
local pulse=nbStacks==3
local glowIDs=nbStacks==3 and ghAndPoh or nil
SAO:RegisterAura(auraName,nbStacks,auraBuff, "serendipity", "Top",scale,255,255,255,pulse,glowIDs)
end
end
elseif SAO.IsCata()then
for talentPoints=1,2 do
local auraName=({"serendipity_low", "serendipity_high"})[talentPoints]
local auraBuff=({serendipityBuff1,serendipityBuff2})[talentPoints]
for nbStacks=1,2 do
local scale=0.7 + 0.3 * nbStacks
local pulse=nbStacks==2
local glowIDs=nbStacks==2 and ghAndPoh or nil
SAO:RegisterAura(auraName,nbStacks,auraBuff, "serendipity", "Top",scale,255,255,255,pulse,glowIDs)
end
end
end
SAO:RegisterAuraEyeOfGruul("eye_of_gruul_priest",37706)
SAO:RegisterAuraSoulPreserver("soul_preserver_priest",60514)
elseif SAO.IsSoD()then
local serendipityBuff=413247
local serendipityImprovedSpells={SAO:GetSpellName(lesserHeal),SAO:GetSpellName(heal),SAO:GetSpellName(greaterHeal),SAO:GetSpellName(prayerOfHealing)}
for nbStacks=1,3 do
local scale=0.4 + 0.2 * nbStacks
local pulse=nbStacks==3
local glowIDs=nbStacks==3 and serendipityImprovedSpells or nil
SAO:RegisterAura("serendipity_sod",nbStacks,serendipityBuff, "serendipity", "Top",scale,255,255,255,pulse,glowIDs)
end
end
end
local function useSurgeOfLight()
local hash0Stacks=SAO:HashNameFromStacks(0)
local hash2Stacks=SAO:HashNameFromStacks(2)
SAO:CreateEffect(
"surge_of_light",
SAO.SOD + SAO.TBC + SAO.WRATH + SAO.CATA + SAO.MOP,
{
[SAO.SOD]=431666,
[SAO.TBC+SAO.WRATH]=33151,
[SAO.CATA]=88688,
[SAO.MOP]=114255,
},
"aura",
{
aka={
[SAO.MOP]=128654,
},
talent={
[SAO.SOD]=431664,
[SAO.TBC+SAO.WRATH]=33150,
[SAO.CATA]=88687,
[SAO.MOP]=114255,
},
overlays={
[SAO.SOD+SAO.TBC+SAO.WRATH+SAO.CATA]={texture="surge_of_light",position="Left + Right (Flipped)"},
[SAO.MOP]={
{stacks=1,texture="surge_of_light",position="Left",option=false},
{stacks=2,texture="surge_of_light",position="Left + Right (Flipped)",option={setupHash=hash0Stacks,testHash=hash2Stacks}},
},
},
buttons={
[SAO.SOD]={smite,flashHeal,bindingHeal},
[SAO.TBC]=smite,
[SAO.WRATH]={smite,flashHeal},
[SAO.CATA]=flashHealNoMana,
[SAO.MOP]=flashHeal,
},
}
)
if SAO.IsMoP()then
SAO:CreateEffect(
"surge_of_darkness",
SAO.MOP,
87160,
"aura",
{
aka=126083,
talent=87160,
overlays={
{stacks=1,texture="surge_of_darkness",position="Left",option=false},
{stacks=2,texture="surge_of_darkness",position="Left + Right (Flipped)",option={setupHash=hash0Stacks,testHash=hash2Stacks}},
},
button=mindSpike,
}
)
end
end
local function useClearcasting()
SAO:CreateEffect(
"clearcasting",
SAO.TBC,
34754,
"aura",
{
overlay={texture="genericarc_05",position="Left + Right (Flipped)",scale=1.5,color={192,192,192},pulse=false},
buttons={flashHeal,bindingHeal,greaterHeal},
}
)
end
local function useHolyWordChastise()
SAO:CreateEffect(
"hw_castise",
SAO.MOP,
88625,
"counter",
{
combatOnly=true,
}
)
end
local function useShadowform()
SAO:CreateEffect(
"shadowform",
SAO.ALL_PROJECTS,
shadowform,
"aura",
{
talent={
[SAO.ERA+SAO.TBC+SAO.WRATH+SAO.CATA]=shadowform,
[SAO.MOP]=PRIEST_SPEC_SHADOW,
},
requireTalent=true,
combatOnly=true,
button={stacks=-1},
}
)
end
local function useShadowWordDeath()
SAO:CreateEffect(
"sw_death",
SAO.CATA,
swDeath,
"counter",
{
useExecute=true,
execThreshold=25,
buttonOption={spellSubText=SAO:ExecuteBelow(25)},
}
)
end
local function useMindMelt()
local mindMeltBuff2=87160
local mindMeltTalent=14910
if SAO.IsCata()then
SAO:CreateEffect(
"mind_melt",
SAO.CATA,
mindMeltBuff2,
"aura",
{
talent=mindMeltTalent,
button=mindBlast,
}
)
end
end
local function useDivineInsight()
local divineInsights={
{
spec="discipline",
buff=123266,
texture="serendipity",
},
{
spec="holy",
buff=123267,
texture="serendipity",
},
{
spec="shadow",
buff=124430,
texture="shadow_of_death",
},
}
for index,divineInsight in ipairs(divineInsights)do
local subText=function()
return C_SpecializationInfo and select(2,C_SpecializationInfo.GetSpecializationInfo(index))
end
SAO:CreateEffect(
"divine_insight_"..divineInsight.spec,
SAO.MOP,
divineInsight.buff,
"aura",
{
overlay={texture=divineInsight.texture,position="Top",option={subText=subText}},
}
)
end
end
local function useDevouringPlague()
SAO:CreateEffect(
"devouring_plague",
SAO.MOP,
devouringPlague,
"generic",
{
useHolyPower=true,
combatOnly=true,
button={holyPower=3,spellID=devouringPlague},
}
)
end
local function useMindSpike()
end
local function useGlyphOfMindSpike()
SAO:CreateEffect(
"glyph_of_mind_spike",
SAO.MOP,
81292,
"aura",
{
talent=33371,
button={stacks=2,spellID=mindBlast},
}
)
end
local function registerClass(self)
useInnerFire()
useSerendipity()
useSurgeOfLight()
useClearcasting()
useHolyWordChastise()
useShadowWordDeath()
useShadowform()
useDevouringPlague()
useMindMelt()
useMindSpike()
useDivineInsight()
useGlyphOfMindSpike()
end
local function loadOptions(self)
local serendipityBuff2=63735
local serendipityBuff3=63734
local serendipityTalent=63730
local serendipitySoDBuff=413247
local oneOrTwoStacks=self:NbStacks(1,2)
local twoStacks=self:NbStacks(2)
local threeStacks=self:NbStacks(3)
if self.IsTBC()then
self:AddEyeOfGruulOverlayOption(37706)
elseif self.IsProject(SAO.WRATH + SAO.CATA)then
if self.IsWrath()then
self:AddOverlayOption(serendipityTalent,serendipityBuff3,0,oneOrTwoStacks,nil,2)
self:AddOverlayOption(serendipityTalent,serendipityBuff3,self:HashNameFromStacks(3))
elseif self.IsCata()then
self:AddOverlayOption(serendipityTalent,serendipityBuff2,self:HashNameFromStacks(1))
self:AddOverlayOption(serendipityTalent,serendipityBuff2,self:HashNameFromStacks(2))
end
self:AddSoulPreserverOverlayOption(60514)
if self.IsWrath()then
self:AddGlowingOption(serendipityTalent,serendipityBuff3,greaterHeal,threeStacks)
self:AddGlowingOption(serendipityTalent,serendipityBuff3,prayerOfHealing,threeStacks)
elseif self.IsCata()then
self:AddGlowingOption(serendipityTalent,serendipityBuff2,greaterHeal,twoStacks)
self:AddGlowingOption(serendipityTalent,serendipityBuff2,prayerOfHealing,twoStacks)
end
elseif self.IsSoD()then
self:AddOverlayOption(serendipitySoDBuff,serendipitySoDBuff,0,oneOrTwoStacks,nil,2)
self:AddOverlayOption(serendipitySoDBuff,serendipitySoDBuff,self:HashNameFromStacks(3))
self:AddGlowingOption(serendipitySoDBuff,serendipitySoDBuff,lesserHeal,threeStacks)
self:AddGlowingOption(serendipitySoDBuff,serendipitySoDBuff,heal,threeStacks)
self:AddGlowingOption(serendipitySoDBuff,serendipitySoDBuff,greaterHeal,threeStacks)
self:AddGlowingOption(serendipitySoDBuff,serendipitySoDBuff,prayerOfHealing,threeStacks)
end
end
SAO.Class["PRIEST"]={
["Register"]=registerClass,
["LoadOptions"]=loadOptions,
}
