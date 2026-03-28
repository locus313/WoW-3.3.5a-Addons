local AddonName,SAO=...
local Module="events"
local CombatLogGetCurrentEventInfo=CombatLogGetCurrentEventInfo
local UnitGUID=UnitGUID
local arePendingEffectsRegistered=false
function SAO.LOADING_SCREEN_DISABLED(self,...)
if not arePendingEffectsRegistered then
arePendingEffectsRegistered=true
self:RegisterPendingEffectsAfterPlayerLoggedIn()
end
self:CheckManuallyAllBuckets()
end
function SAO.PLAYER_REGEN_ENABLED(self,...)
local inCombat=false
self:ForEachBucket(function(bucket) bucket:checkCombat(inCombat) end)
end
function SAO.PLAYER_REGEN_DISABLED(self,...)
local inCombat=true
self:ForEachBucket(function(bucket) bucket:checkCombat(inCombat) end)
end
function SAO.SPELLS_CHANGED(self,...)
for glowID,_ in pairs(self.RegisteredGlowSpellNames)do
self:RefreshSpellIDsByName(glowID,true)
end
end
function SAO.LEARNED_SPELL_IN_TAB(self,...)
local spellID,skillInfoIndex,isGuildPerkSpell=...
self:LearnNewSpell(spellID)
end
function SAO.LEARNED_SPELL_IN_SKILL_LINE(self,...)
local spellID,skillInfoIndex,isGuildPerkSpell=...
self:LearnNewSpell(spellID)
end
local warnedSaoVsNecrosis=false
function SAO.ADDON_LOADED(self,addOnName,containsBindings)
if warnedSaoVsNecrosis then
return
end
local iamSAO=strlower(AddonName)=="spellactivationoverlay"
local itisSAO=strlower(addOnName)=="spellactivationoverlay"
local iamNecrosis=strlower(AddonName):sub(0,8)=="necrosis"
local itisNecrosis=strlower(addOnName):sub(0,8)=="necrosis"
if (iamSAO and (itisNecrosis or itisSAO and NecrosisConfig)) or
(iamNecrosis and (itisSAO or itisNecrosis and _G["Spell".."ActivationOverlayDB"]))then
local className,classFilename,classId=UnitClass("player")
if classFilename=="WARLOCK" then
self:Info("==", "You have installed Necrosis and Spell".."ActivationOverlay at the same time.")
if iamSAO then
self.Shutdown:EnableCategory("NECROSIS_INSTALLED")
local shutdownCategory=self.Shutdown:GetCategory()
if shutdownCategory.Name=="NECROSIS_INSTALLED" and shutdownCategory.DisableCondition.IsDisabled()then
self:Warn("==", "Spell".."ActivationOverlay will be disabled for this character to avoid double procs with Necrosis. "..
"You can go to Options > AddOns to change the preferred addon.")
end
elseif iamNecrosis then
self.Shutdown:EnableCategory("SAO_INSTALLED")
local shutdownCategory=self.Shutdown:GetCategory()
if shutdownCategory.Name=="SAO_INSTALLED" and shutdownCategory.DisableCondition.IsDisabled()then
self:Warn("==", "Necrosis Spell Activations will be disabled for this character to avoid double procs with Spell".."ActivationOverlay. "..
"You can go to Options > AddOns to change the preferred addon. "..
"This concerns only \"Spell Activations\" of Necrosis; it has no effect on other features of Necrosis.")
end
end
else
self:Info("==", "You have installed Necrosis and SpellActivationOverlay at the same time.")
self:Info("==", "Because you are playing "..className..", ".."Necrosis is not necessary.")
end
warnedSaoVsNecrosis=true
end
end
local DirectFrameEventHandlers={}
if SAO.IsProject(SAO.CATA_AND_ONWARD)then
DirectFrameEventHandlers["SPELL_ACTIVATION_OVERLAY_SHOW"]=function(self,event,...)
local spellID,texture,positions,scale,r,g,b=...
SAO:Debug(Module, "Received native SPELL_ACTIVATION_OVERLAY_SHOW with spell ID "..tostring(spellID)..", ".."texture "..tostring(texture)..", ".."positions '"..tostring(positions).."', ".."scale "..tostring(scale)..", ".."(r g b)=("..tostring(r).." "..tostring(g).." "..tostring(b)..")")
SAO:ReportUnknownEffect(Module,spellID,texture,positions,scale,r,g,b)
end
DirectFrameEventHandlers["SPELL_ACTIVATION_OVERLAY_HIDE"]=function(self,event,...)
local spellID=...
if spellID then
SAO:Debug(Module, "Received native SPELL_ACTIVATION_OVERLAY_HIDE with spell ID "..tostring(spellID))
end
end
end
DirectFrameEventHandlers["PLAYER_REGEN_DISABLED"]=function(self,event,...)
if not self.disableDimOutOfCombat and event=="PLAYER_REGEN_DISABLED" and self.inPseudoCombat~=true then
self.combatAnimOut:Stop()
self.combatAnimIn:Play()
for _,overlay in ipairs(self.combatOnlyOverlays)do
overlay.combat.animOut:Stop()
SpellActivationOverlayFrame_PlayCombatAnimIn(overlay.combat.animIn)
end
end
end
DirectFrameEventHandlers["PLAYER_REGEN_ENABLED"]=function(self,event,...)
if not self.disableDimOutOfCombat and event=="PLAYER_REGEN_ENABLED" and self.inPseudoCombat~=false then
self.combatAnimIn:Stop()
self.combatAnimOut:Play()
for _,overlay in ipairs(self.combatOnlyOverlays)do
overlay.combat.animIn:Stop()
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
end
end
SAO.CentralizedEventDispatcher={}
function SAO:InitializeEventDispatcher()
local isEventPair=function(event,handler)
return type(handler)=='function' and type(event)=='string' and event:match("^[A-Z_]+$")~=nil
end
local addDispatcher=function(event,func)
if not self.CentralizedEventDispatcher[event] then
self.CentralizedEventDispatcher[event]={}
end
tinsert(self.CentralizedEventDispatcher[event],func)
end
for event,handler in pairs(DirectFrameEventHandlers)do
if isEventPair(event,handler)then
local func=function(frame,self,event,...)
handler(frame,event,...)
end
addDispatcher(event,func)
end
end
for event,handler in pairs(SAO)do
if isEventPair(event,handler)then
local func=function(frame,self,event,...)
handler(self,...)
end
addDispatcher(event,func)
end
end
for event,handlers in pairs(SAO.VariableEventProxy)do
for _,var in ipairs(handlers)do
local handler=var.event[event]
if isEventPair(event,handler)then
local func=function(frame,self,event,...)
handler(...)
end
addDispatcher(event,func)
end
end
end
for event,handler in pairs(SAO.CurrentClass or {})do
if isEventPair(event,handler)then
local func=function(frame,self,event,...)
handler(self,...)
end
addDispatcher(event,func)
end
end
end
