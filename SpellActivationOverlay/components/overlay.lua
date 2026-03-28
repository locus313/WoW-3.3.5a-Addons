local AddonName,SAO=...
local Module="overlay"
local function discardedByOverlayOption(self,auraID,optionIndex,optionAnyStacks)
if (not SpellActivationOverlayDB)then
return false
end
if (SpellActivationOverlayDB.alert and not SpellActivationOverlayDB.alert.enabled)then
return true
end
local overlayOptions=self:GetOverlayOptions(auraID)
if (not overlayOptions)then
return false
end
if optionIndex and type(overlayOptions[optionIndex])~='nil' then
return not overlayOptions[optionIndex]
elseif optionAnyStacks and type(overlayOptions[optionAnyStacks])~='nil' then
return not overlayOptions[optionAnyStacks]
end
return false
end
function SAO.ActivateOverlay(self,hashData,spellID,texture,positions,scale,r,g,b,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
if (texture)then
if type(hashData)=='number' then
local stacks=hashData
local fallbackAny=stacks > 0 and 0 or nil
if discardedByOverlayOption(self,spellID,stacks,fallbackAny)then
return
end
elseif type(hashData)=='table' then
local optionIndex,optionAnyStacks=hashData.optionIndex,hashData.optionAnyStacks
if discardedByOverlayOption(self,spellID,optionIndex,optionAnyStacks)then
return
end
else
SAO:Warn(Module, "Unknown overlay hash-data type '"..type(hashData).."'")
end
if (type(forcePulsePlay)=='table')then
forcePulsePlay=false
end
if (type(autoPulse)=='function')then
autoPulse=autoPulse(self)
end
if (type(forcePulsePlay)=='function')then
forcePulsePlay=forcePulsePlay(self)
end
if (type(texture)=='function')then
texture=texture(self)
end
endTime=self:GetSpellEndTime(spellID,endTime)
self.ShowAllOverlays(self.Frame,spellID,texture,positions,scale,r,g,b,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
end
end
function SAO.DeactivateOverlay(self,spellID)
self.HideOverlays(self.Frame,spellID)
end
function SAO.RefreshOverlayTimer(self,spellID,endTime)
endTime=self:GetSpellEndTime(spellID,endTime)
if (endTime)then
self.SetOverlayTimer(self.Frame,spellID,endTime)
end
end
