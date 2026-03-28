local AddonName,SAO=...
local chainHeal=1064
local chainLightning=421
local earthShock=8042
local elementalBlast=117014
local flameShock=8050
local frostShock=8056
local greaterHealingWave=77472
local healingRain=73920
local healingSurge=8004
local healingWave=331
local hex=51514
local lavaBurst=51505
local lavaBurstSoD=408490
local lesserHealingWave=8004
local lightningBolt=403
local function useElementalFocus(self)
local hash0Stacks=self:HashNameFromStacks(0)
local hash2Stacks=self:HashNameFromStacks(2)
self:CreateEffect(
"elemental_focus",
SAO.TBC_AND_ONWARD,
16246,
"aura",
{
talent=16164,
overlays={
{stacks=1,texture="genericarc_05",position="Left",scale=1.5,pulse=false,option=false},
{stacks=2,texture="genericarc_05",position="Left + Right (Flipped)",scale=1.5,pulse=false,option={setupHash=hash0Stacks,testHash=hash2Stacks}},
},
}
)
if self.IsEra() and not self.IsSoD()then
self:RegisterAura("elemental_focus",0,16246, "genericarc_05", "Left + Right (Flipped)",1.25,255,255,255,false)
end
end
local function useShamanisticFocus(self)
self:CreateEffect(
"shamanistic_focus",
SAO.TBC + SAO.WRATH + SAO.CATA,
43339,
"aura",
{
talent=43338,
overlay={texture="genericarc_05",position="Left + Right (Flipped)",scale=1.25,color={255,128,0},pulse=false},
buttons={earthShock,flameShock,frostShock},
}
)
end
local function useLavaSurge(self)
self:CreateEffect(
"lava_surge",
SAO.CATA,
lavaBurst,
"counter",
{
talent=77756,
requireTalent=true,
combatOnly=true,
overlay={texture="imp_empowerment",position="Left + Right (Flipped)"},
}
)
local lavaSurgeMop=77762
self:CreateEffect(
"lava_surge",
SAO.MOP,
lavaSurgeMop,
"aura",
{
talent=77756,
combatOnly=true,
overlay={texture="imp_empowerment",position="Left + Right (Flipped)"},
}
)
self:CreateEffect(
"lava_burst",
SAO.MOP,
lavaBurst,
"counter",
{combatOnly=true}
)
end
local function useTidalWaves(self)
local hash0Stacks=self:HashNameFromStacks(0)
local hash2Stacks=self:HashNameFromStacks(2)
local tidalWavesBuff=self.IsSoD() and 432041 or 53390
local tidalWavesTalent=self.IsSoD() and 432233 or 51564
self:CreateEffect(
"tidal_waves",
SAO.SOD + SAO.WRATH_AND_ONWARD,
tidalWavesBuff,
"aura",
{
talent=tidalWavesTalent,
overlays={
{stacks=1,texture="high_tide",position="Left (CCW)",scale=0.8,option=false},
{stacks=2,texture="high_tide",position="Left (CCW)",scale=0.8,option=false},
{stacks=2,texture="high_tide",position="Right (CW)",scale=0.8,option={setupHash=hash0Stacks,testHash=hash2Stacks}},
},
buttons={
[SAO.SOD+SAO.WRATH]={lesserHealingWave,healingWave},
[SAO.CATA_AND_ONWARD]={greaterHealingWave,healingWave,healingSurge},
},
}
)
end
local function useMaelstromWeapon(self)
local hash0Stacks=self:HashNameFromStacks(0)
local hash4Stacks=self:HashNameFromStacks(4)
local hash6Stacks=self:HashNameFromStacks(6)
local hash9Stacks=self:HashNameFromStacks(9)
local maelstromWeaponBuff=self.IsSoD() and 408505 or 53817
local maelstromWeaponTalent=self.IsSoD() and 408498 or 51530
local maelstromWeaponScale=self.IsSoD() and 0.8 or 1
local mustPulseMSW5=function()
local t4Items={240131,240135,240128,240136,240134,240129,240137,240130}
local nbT4Items=self:GetNbItemsEquipped(t4Items)
if nbT4Items < 6 then
return true
else
return false
end
end
self:CreateEffect(
"maelstrom_weapon",
SAO.SOD + SAO.WRATH_AND_ONWARD,
maelstromWeaponBuff,
"aura",
{
aka={
[SAO.MOP]=60349,
},
talent=maelstromWeaponTalent,
overlays={
{stacks=1,texture="maelstrom_weapon_1",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=2,texture="maelstrom_weapon_2",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=3,texture="maelstrom_weapon_3",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=4,texture="maelstrom_weapon_4",position="Top",scale=maelstromWeaponScale,pulse=false,option={setupHash=hash0Stacks,testHash=hash4Stacks,subText=self:NbStacks(1,4)}},
[SAO.WRATH_AND_ONWARD]={
{stacks=5,texture="maelstrom_weapon" ,position="Top",scale=maelstromWeaponScale,pulse=true ,option=true},
},
[SAO.SOD]={
{stacks=5,texture="maelstrom_weapon" ,position="Top",scale=maelstromWeaponScale,pulse=mustPulseMSW5,option=true},
{stacks=6,texture="maelstrom_weapon_6",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=7,texture="maelstrom_weapon_7",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=8,texture="maelstrom_weapon_8",position="Top",scale=maelstromWeaponScale,pulse=false,option=false},
{stacks=9,texture="maelstrom_weapon_9",position="Top",scale=maelstromWeaponScale,pulse=false,option={setupHash=hash6Stacks,testHash=hash9Stacks,subText=self:NbStacks(6,9)}},
{stacks=10,texture="maelstrom_weapon_10" ,position="Top",scale=maelstromWeaponScale,pulse=true ,option=true},
},
},
buttons={
default={stacks=5},
[SAO.SOD]={lightningBolt,chainLightning,lesserHealingWave,lavaBurstSoD},
[SAO.WRATH]={lightningBolt,chainLightning,lesserHealingWave,healingWave,chainHeal,hex},
[SAO.CATA]={lightningBolt,chainLightning,healingSurge,greaterHealingWave,healingWave,chainHeal,healingRain,hex},
[SAO.MOP]={lightningBolt,chainLightning,healingSurge,greaterHealingWave,healingWave,chainHeal,healingRain,hex,elementalBlast},
},
handlers={
[SAO.SOD]={onRepeat=function(bucket) bucket:refresh(); end},
},
}
)
end
local function useFulmination(self)
SAO:CreateEffect(
"fulmination",
SAO.CATA_AND_ONWARD,
324,
"aura",
{
aka=95774,
talent=88767,
combatOnly=true,
overlays={
default={texture="fulmination",position="Top"},
[SAO.CATA]={
{scale=0.5,stacks=6,pulse=false,},
{scale=0.6,stacks=7,pulse=false,},
{scale=0.7,stacks=8,pulse=false,},
{scale=0.8,stacks=9,pulse=true,},
},
[SAO.MOP]={
{scale=0.8,stacks=7,},
},
},
buttons={
default={spellID=earthShock},
[SAO.CATA]={stacks=9},
[SAO.MOP]={stacks=7},
},
}
)
SAO:CreateLinkedEffects(
"rolling_thunder",
SAO.SOD,
{324,325,905,945,8134,10431,10432},
"aura",
{
talent=432056,
requireTalent=true,
combatOnly=true,
overlays={
default={texture="fulmination",position="Top"},
{scale=0.6,stacks=7,pulse=false,},
{scale=0.7,stacks=8,pulse=false,},
{scale=0.8,stacks=9,pulse=true,},
},
button={stacks=9,spellID=earthShock},
}
)
end
local function useMoltenBlast(self)
local moltenBlastSoD=425339
self:CreateEffect(
"molten_blast",
SAO.SOD,
moltenBlastSoD,
"counter",
{
combatOnly=true,
overlay={texture="impact",position="Top",scale=0.8},
}
)
end
local function usePowerSurge(self)
if not self.IsSoD()then
return
end
local powerSurgeSoDBuff=415105
local powerSurgeSoDHealBuff=468526
local powerSurgeSpells={
self:GetSpellName(chainLightning),
self:GetSpellName(lavaBurstSoD),
}
local elementalFocusBuff=16246
local elementalFocusTalent=16164
local _,_,efTalentTab,efTalentIndex=SAO:GetTalentByName(self:GetSpellName(elementalFocusTalent))
local powerSurgeSoDRune=48829
local powerSurgeRightTextureFunc=function()
local hasElementalFocusOption=SpellActivationOverlayDB.classes["SHAMAN"]["alert"][elementalFocusBuff][0]
local canProcElementalFocus=efTalentTab and efTalentIndex and self:GetNbTalentPoints(efTalentTab,efTalentIndex) > 0
if hasElementalFocusOption and canProcElementalFocus then
return
end
return self.TexName["imp_empowerment"]
end
local elementalFocusLeftTextureFunc=function()
local hasPowerSurgeOption=SpellActivationOverlayDB.classes["SHAMAN"]["alert"][powerSurgeSoDBuff][0]
local canProcPowerSurge=C_Engraving and C_Engraving.IsRuneEquipped(powerSurgeSoDRune)
if hasPowerSurgeOption and canProcPowerSurge then
return
end
return self.TexName["genericarc_05"]
end
self:RegisterAura("power_surge_sod",0,powerSurgeSoDBuff, "imp_empowerment", "Left",1.25,255,255,255,true,powerSurgeSpells)
self:RegisterAura("power_surge_sod",0,powerSurgeSoDBuff,powerSurgeRightTextureFunc, "Right (Flipped)",1.25,255,255,255,true,powerSurgeSpells)
self:RegisterAura("elemental_focus",0,elementalFocusBuff,elementalFocusLeftTextureFunc, "Left",1.25,255,255,255,false)
self:RegisterAura("elemental_focus",0,elementalFocusBuff, "genericarc_05", "Right (Flipped)",1.25,255,255,255,false)
SAO:CreateEffect(
"power_surge_sod_heal",
SAO.SOD,
powerSurgeSoDHealBuff,
"aura",
{
talent=powerSurgeSoDHealBuff,
button={spellID=chainHeal,option={talentSubText=HEALER}},
}
)
end
local function registerClass(self)
useElementalFocus(self)
useShamanisticFocus(self)
useLavaSurge(self)
useTidalWaves(self)
useMaelstromWeapon(self)
useFulmination(self)
useMoltenBlast(self)
usePowerSurge(self)
self:RegisterAuraEyeOfGruul("eye_of_gruul_shaman",37722)
self:RegisterAuraSoulPreserver("soul_preserver_shaman",60515)
end
local function loadOptions(self)
if self.IsEra()then
local elementalFocusBuff=16246
local elementalFocusTalent=16164
self:AddOverlayOption(elementalFocusTalent,elementalFocusBuff)
end
self:AddEyeOfGruulOverlayOption(37722)
self:AddSoulPreserverOverlayOption(60515)
if self.IsSoD()then
local powerSurgeSoDBuff=415105
local powerSurgeSoD=415100
self:AddOverlayOption(powerSurgeSoD,powerSurgeSoDBuff,nil,DAMAGER)
self:AddGlowingOption(powerSurgeSoD,powerSurgeSoDBuff,chainLightning,DAMAGER)
self:AddGlowingOption(powerSurgeSoD,powerSurgeSoDBuff,lavaBurstSoD,DAMAGER)
end
end
SAO.Class["SHAMAN"]={
["Register"]=registerClass,
["LoadOptions"]=loadOptions,
}
