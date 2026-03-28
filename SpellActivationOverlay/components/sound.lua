local AddonName,SAO=...
local GetTime=GetTime
local PlaySound=PlaySound
local PlaySoundFile=PlaySoundFile
local StopSound=StopSound
local timeOfLastPlayedAlert
function SAO.PlaySpellAlertSound(self)
if GetTime()==timeOfLastPlayedAlert then
return
end
local willPlay,soundHandle
if SAO.IsProject(SAO.ERA + SAO.TBC + SAO.WRATH + SAO.RETAIL)then
willPlay,soundHandle=PlaySoundFile("Interface\\Addons\\SpellActivationOverlay\\sounds\\UI_PowerAura_Generic.ogg")
else
willPlay,soundHandle=PlaySound(SOUNDKIT.UI_POWER_AURA_GENERIC)
end
if willPlay then
timeOfLastPlayedAlert=GetTime()
return soundHandle
end
end
function SAO.StopSpellAlertSound(self,handle,fadeoutTime)
if handle then
StopSound(handle,fadeoutTime)
end
end
