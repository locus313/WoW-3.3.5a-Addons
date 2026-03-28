local AddonName,SAO=...
local avengersShield=31935
local divineLight=82326
local divineStorm=SAO.IsSoD() and 407778 or 53385
local eternalFlame=114163
local exorcism=879
local flashOfLight=19750
local holyLight=635
local holyRadiance=82327
local holyShock=20473
local how=24275
local inquisition=84963
local lightOfDawn=85222
local shieldOfTheRighteous=53600
local templarsVerdict=85256
local wordOfGlory=85673
local zealotry=85696
local handlerTruncateTo3HolyPower={
[SAO.MOP_AND_ONWARD]={
onAboutToApplyHash=function(hashCalculator)
local holyPower=hashCalculator:getHolyPower()
if type(holyPower)=='number' and holyPower > 3 then
hashCalculator:setHolyPower(3)
end
end
},
}
local function useHolyPowerTracker()
local holyPower=85247
local overlays={}
for hp=1,3 do
local texture="surge_of_light"
local scale=0.4 + 0.1*hp
local pulse=hp==3
tinsert(overlays,{holyPower=hp,texture=texture,position="Left (vFlipped)",level=4,scale=scale,pulse=pulse})
tinsert(overlays,{holyPower=hp,texture=texture,position="Right (180)",level=4,scale=scale,pulse=pulse,option=false})
end
SAO:CreateEffect(
"holy_power_tracker",
SAO.CATA_AND_ONWARD,
holyPower,
"generic",
{
useHolyPower=true,
overlays=overlays,
handlers=handlerTruncateTo3HolyPower,
}
)
end
local function useHammerOfWrath()
SAO:CreateEffect(
"how",
SAO.ALL_PROJECTS - SAO.MOP_AND_ONWARD,
how,
"counter"
)
end
local function useHolyShock()
SAO:CreateEffect(
"holy_shock",
SAO.ALL_PROJECTS,
holyShock,
"counter",
{combatOnly=true}
)
end
local function useExorcism()
SAO:CreateEffect(
"exorcism",
SAO.ALL_PROJECTS,
exorcism,
"counter",
{combatOnly=true}
)
end
local function useHolySpender(name,spellID,project)
SAO:CreateEffect(
name,
project or SAO.CATA_AND_ONWARD,
spellID,
"counter",
{
useHolyPower=true,
holyPower=3,
handlers=handlerTruncateTo3HolyPower,
}
)
end
local function useDivineStorm()
if SAO.IsProject(SAO.MOP_AND_ONWARD)then
useHolySpender("divine_storm",divineStorm)
else
SAO:CreateEffect(
"divine_storm",
SAO.SOD + SAO.WRATH + SAO.CATA,
divineStorm,
"counter",
{combatOnly=true}
)
end
end
local function useJudgementsOfThePure()
local judgementOfLight,judgementOfWisdom,judgementOfJustice=20271,53408,53407
local judgement=20271
local judgementsOfThePureBuff=53657
local judgementsOfThePureTalent=53671
SAO:CreateEffect(
"jotp",
SAO.WRATH + SAO.CATA,
judgementsOfThePureBuff,
"aura",
{
talent=judgementsOfThePureTalent,
requireTalent=true,
combatOnly=true,
buttons={
default={stacks=-1},
[SAO.WRATH]={judgementOfLight,judgementOfWisdom,judgementOfJustice},
[SAO.CATA]=judgement,
}
}
)
end
local function useInfusionOfLight()
if SAO.IsProject(SAO.MOP_AND_ONWARD)then
local infusionOfLightBuff=54149
local infusionOfLightTalent=53576
SAO:CreateEffect(
"infusion_of_light",
SAO.MOP_AND_ONWARD,
infusionOfLightBuff,
"aura",
{
talent=infusionOfLightTalent,
overlay={texture="daybreak",position="Left + Right (Flipped)",option={subText=SAO:RecentlyUpdated()}},
}
)
else
local infusionOfLightBuff1=53672
local infusionOfLightBuff2=54149
local infusionOfLightTalent=53569
SAO:CreateLinkedEffects(
"infusion_of_light",
SAO.WRATH_AND_ONWARD,
{infusionOfLightBuff1,infusionOfLightBuff2},
"aura",
{
talent=infusionOfLightTalent,
overlays={
[SAO.WRATH]={texture="daybreak",position="Left + Right (Flipped)"},
[SAO.CATA]={texture="denounce",position="Top"},
},
buttons={
[SAO.WRATH]={flashOfLight,holyLight},
[SAO.CATA]={flashOfLight,holyLight,divineLight,holyRadiance},
},
}
)
end
end
local function useDaybreak()
SAO:CreateEffect(
"daybreak",
SAO.CATA_AND_ONWARD,
88819,
"aura",
{
talent={
[SAO.CATA]=88820,
[SAO.MOP_AND_ONWARD]=88821,
},
action=holyShock,
actionUsable=true,
overlays={
[SAO.CATA]={texture="daybreak",position="Left + Right (Flipped)"},
[SAO.MOP_AND_ONWARD]={texture="eclipse_sun",position="Top (CW)",scale=0.8,level=2,option={subText=SAO:RecentlyUpdated()}},
},
buttons={
[SAO.CATA]=holyShock,
}
}
)
end
local function useGrandCrusader()
SAO:CreateEffect(
"grand_crusader",
SAO.CATA_AND_ONWARD,
85416,
"aura",
{
talent={
[SAO.CATA]=75806,
[SAO.MOP_AND_ONWARD]=85043,
},
overlay={texture="grand_crusader",position="Left + Right (Flipped)"},
buttons={
[SAO.CATA]=avengersShield,
},
}
)
end
local function useCrusade()
SAO:CreateEffect(
"crusade",
SAO.CATA,
94686,
"aura",
{
talent=31866,
button=holyLight
}
)
end
local function useDivinePurpose()
SAO:CreateEffect(
"divine_purpose",
SAO.CATA_AND_ONWARD,
90174,
"aura",
{
talent={
[SAO.CATA]=85117,
[SAO.MOP_AND_ONWARD]=86172,
},
overlay={texture="hand_of_light",position="Top"},
buttons={
[SAO.CATA]={wordOfGlory,templarsVerdict,inquisition,zealotry},
[SAO.MOP_AND_ONWARD]={wordOfGlory,templarsVerdict,inquisition,lightOfDawn,shieldOfTheRighteous,divineStorm,eternalFlame},
},
}
)
end
local function registerArtOfWar(name,project,buff,glowingButtons,defaultOverlay,defaultButton)
SAO:CreateEffect(
name,
project,
buff,
"aura",
{
talent=53486,
overlays={
default=defaultOverlay,
[project]={texture="art_of_war",position="Left + Right (Flipped)"},
},
buttons={
default=defaultButton,
[project]=glowingButtons,
},
}
)
end
local function useArtOfWar()
if SAO.IsWrath()then
local artOfWarBuff1=53489
local artOfWarBuff2=59578
SAO:AddOverlayLink(artOfWarBuff2,artOfWarBuff1)
SAO:AddGlowingLink(artOfWarBuff2,artOfWarBuff1)
registerArtOfWar("art_of_war_low",SAO.WRATH,artOfWarBuff1,{flashOfLight,exorcism},{scale=0.6,pulse=false,option=false},{option=false})
registerArtOfWar("art_of_war_high",SAO.WRATH,artOfWarBuff2,{flashOfLight,exorcism})
elseif SAO.IsProject(SAO.CATA_AND_ONWARD)then
SAO:CreateEffect(
"art_of_war",
SAO.CATA_AND_ONWARD,
59578,
"aura",
{
talent={
[SAO.CATA]=53486,
[SAO.MOP_AND_ONWARD]=87138,
},
overlay={texture="art_of_war",position="Left + Right (Flipped)"},
buttons={
[SAO.CATA]=exorcism,
},
}
)
end
end
local function useSupplication()
SAO:CreateEffect(
"supplication",
SAO.MOP,
94686,
"aura",
{
button=flashOfLight,
}
)
end
local function registerClass(self)
useHolyPowerTracker()
useHammerOfWrath()
useHolyShock()
useExorcism()
useDivineStorm()
useHolySpender("word_of_glory",wordOfGlory)
useHolySpender("light_of_dawn",lightOfDawn)
useHolySpender("shield_of_the_righteous",shieldOfTheRighteous)
useHolySpender("templars_verdict",templarsVerdict)
useHolySpender("inquisition",inquisition)
useHolySpender("eternal_flame",eternalFlame,SAO.MOP_AND_ONWARD)
self:RegisterAuraEyeOfGruul("eye_of_gruul_paladin",37723)
self:RegisterAuraSoulPreserver("soul_preserver_paladin",60513)
useJudgementsOfThePure()
useInfusionOfLight()
useDaybreak()
useGrandCrusader()
useCrusade()
useArtOfWar()
useDivinePurpose()
useSupplication()
end
local function loadOptions(self)
self:AddEyeOfGruulOverlayOption(37723)
self:AddSoulPreserverOverlayOption(60513)
end
SAO.Class["PALADIN"]={
["Register"]=registerClass,
["LoadOptions"]=loadOptions,
}
