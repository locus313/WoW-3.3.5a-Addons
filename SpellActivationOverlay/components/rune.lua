local AddonName,SAO=...
local Module="rune"
local InCombatLockdown=InCombatLockdown
local runeMapping={initialized=false}
local function addRuneMapping(rune)
local runeID=rune.skillLineAbilityID
for _,spellID in pairs(rune.learnedAbilitySpellIDs)do
if runeMapping[spellID]~=runeID then
SAO:Debug(Module,SAO:GetSpellName(spellID, "x").." ("..spellID..") from rune "..runeID)
runeMapping[spellID]=runeID
end
end
end
local function initRuneMapping()
local categories=C_Engraving and C_Engraving.GetRuneCategories(false,false) or {}
local foundRune=false
for _,cat in pairs(categories)do
local runes=C_Engraving.GetRunesForCategory(cat,false) or {}
for _,rune in pairs(runes)do
addRuneMapping(rune)
foundRune=true
end
end
runeMapping.initialized=foundRune
end
function SAO.GetRuneFromSpell(self,spellID)
if not runeMapping.initialized then
C_Engraving.RefreshRunesList()
initRuneMapping()
end
return runeMapping[spellID]
end
if SAO.IsSoD()then
local RuneUpdateTracker=CreateFrame("FRAME")
SAO:RegisterEventHandler(RuneUpdateTracker, "RUNE_UPDATED", "Static initializer: "..Module)
RuneUpdateTracker:SetScript("OnEvent",function(self,event,rune)
if runeMapping.initialized and rune then
addRuneMapping(rune)
else
initRuneMapping()
end
end)
C_Timer.NewTicker(10,function(self)
if runeMapping.initialized then
self:Cancel()
SAO:Debug(Module, "Stopping regular checks because at least one rune was found from another check")
elseif InCombatLockdown()then
SAO:Debug(Module, "Cannot perform regular checks because you are in combat")
else
SAO:Debug(Module, "Performing a regular check")
C_Engraving.RefreshRunesList()
initRuneMapping()
if runeMapping.initialized then
self:Cancel()
SAO:Debug(Module, "Found at least one rune, ".."stopping regular checks now")
else
SAO:Debug(Module, "No rune was found during regular check")
end
end
end)
end
