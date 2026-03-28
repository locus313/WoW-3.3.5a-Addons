local AddonName,SAO=...
local Module="main"
local GetTime=GetTime
local InCombatLockdown=InCombatLockdown
local sizeScale=0.8
local longSide=256 * sizeScale
local shortSide=128 * sizeScale
local combatOverlayFactor=2
local useTimer=true
local useSound=false
function SpellActivationOverlay_OnLoad(self)
SAO.Frame=self
SAO.ShowAllOverlays=SpellActivationOverlay_ShowAllOverlays
SAO.HideOverlays=SpellActivationOverlay_HideOverlays
SAO.HideAllOverlays=SpellActivationOverlay_HideAllOverlays
SAO.SetOverlayTimer=SpellActivationOverlay_SetAllOverlayTimers
self.overlaysInUse={}
self.unusedOverlays={}
self.combatOnlyOverlays={}
self.offset=0
self.scale=1
SpellActivationOverlay_OnChangeGeometry(self)
self.useTimer=true
SpellActivationOverlay_OnChangeTimerVisibility(self)
self.useSound=false
SpellActivationOverlay_OnChangeSoundToggle(self)
local className,classFile,classId=UnitClass("player")
local class=SAO.Class[classFile]
if class and not class.IsDisabled then
class.Intrinsics={className,classFile,classId}
SAO.CurrentClass=class
SAO.SharedClass=SAO.Class["__SHARED"]
for _,classDef in ipairs({SAO.CurrentClass,SAO.SharedClass})do
for key,_ in pairs(classDef or {})do
if (key~="Intrinsics" and key~="Register" and key~="LoadOptions" and key~="IsDisabled")then
SAO:RegisterEventHandler(self,key, "Main init: Class custom events")
end
end
end
else
local currentClass=tostring(select(1,UnitClass("player")))
if class and class.IsDisabled then
SAO:Warn(Module,string.format(SAO:disabledClass(),currentClass))
SAO.Shutdown:EnableCategory("DISABLED_CLASS")
else
SAO:Error(Module,SAO:unsupportedClass(),currentClass)
SAO.Shutdown:EnableCategory("UNSUPPORTED_CLASS")
end
end
if SAO.IsProject(SAO.CATA_AND_ONWARD)then
SAO:RegisterEventHandler(self, "SPELL_ACTIVATION_OVERLAY_SHOW", "Main init")
SAO:RegisterEventHandler(self, "SPELL_ACTIVATION_OVERLAY_HIDE", "Main init")
end
SAO:RegisterEventHandler(self, "PLAYER_REGEN_ENABLED", "Main init")
SAO:RegisterEventHandler(self, "PLAYER_REGEN_DISABLED", "Main init")
SAO:RegisterEventHandler(self, "SPELLS_CHANGED", "Main init")
if SAO.HasMidnightUI()then
SAO:RegisterEventHandler(self, "LEARNED_SPELL_IN_SKILL_LINE", "Main init")
else
SAO:RegisterEventHandler(self, "LEARNED_SPELL_IN_TAB", "Main init")
end
SAO:RegisterEventHandler(self, "LOADING_SCREEN_DISABLED", "Main init")
SAO:RegisterEventHandler(self, "PLAYER_LOGIN", "Main init")
SAO:RegisterEventHandler(self, "ADDON_LOADED", "Main init")
for _,var in pairs(SAO.Variables)do
if type(var.event.isRequired)=='function' and var.event.isRequired()
or type(var.event.isRequired)=='boolean' and var.event.isRequired then
for _,eventName in ipairs(var.event.names)do
SAO:RegisterEventHandler(self,eventName, "Main init: Variable "..var.core)
end
end
end
SAO:InitializeEventDispatcher()
end
function SpellActivationOverlay_OnChangeGeometry(self)
local newSize=256 * sizeScale + self.offset
self:GetParent():SetSize(newSize,newSize)
longSide=256 * sizeScale * self.scale
shortSide=128 * sizeScale * self.scale
for _,overlayList in pairs(self.overlaysInUse)do
for i=1,#overlayList do
local overlay=overlayList[i]
overlay:SetGeometry(longSide,shortSide)
end
end
for _,overlay in ipairs(self.combatOnlyOverlays)do
if overlay.combat.animOut:IsPlaying()then
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
end
end
function SpellActivationOverlay_OnChangeTimerVisibility(self)
if useTimer==self.useTimer then
return
end
useTimer=self.useTimer
for _,overlayList in pairs(self.overlaysInUse)do
for i=1,#overlayList do
local overlay=overlayList[i]
overlay.mask:SetShown(useTimer)
end
end
end
function SpellActivationOverlay_OnChangeSoundToggle(self)
if useSound==self.useSound then
return
end
useSound=self.useSound
if useSound then
for _,overlayList in pairs(self.overlaysInUse)do
if #overlayList > 0 then
overlayList[1].soundHandle=SAO:PlaySpellAlertSound()
break
end
end
else
for _,overlayList in pairs(self.overlaysInUse)do
for i=1,#overlayList do
local overlay=overlayList[i]
SAO:StopSpellAlertSound(overlay.soundHandle)
overlay.soundHandle=nil
end
end
end
end
function SpellActivationOverlay_OnEvent(self,event,...)
local dispatcher=SAO.CentralizedEventDispatcher[event]
if dispatcher then
for _,func in ipairs(dispatcher)do
func(self,SAO,event,...)
end
end
end
local complexLocationTable={
["RIGHT (FLIPPED)"]={
RIGHT={hFlip=true},
},
["BOTTOM (FLIPPED)"]={
BOTTOM={vFlip=true},
},
["LEFT + RIGHT (FLIPPED)"]={
LEFT={},
RIGHT={hFlip=true},
},
["TOP + BOTTOM (FLIPPED)"]={
TOP={},
BOTTOM={vFlip=true},
},
["LEFT (CW)"]={
LEFT={cw=1},
},
["LEFT (CCW)"]={
LEFT={cw=-1},
},
["LEFT (180)"]={
LEFT={hFlip=true,vFlip=true},
},
["LEFT (VFLIPPED)"]={
LEFT={vFlip=true},
},
["RIGHT (CW)"]={
RIGHT={cw=1},
},
["RIGHT (CCW)"]={
RIGHT={cw=-1},
},
["RIGHT (180)"]={
RIGHT={hFlip=true,vFlip=true},
},
["RIGHT (VFLIPPED)"]={
RIGHT={vFlip=true},
},
["TOP (CW)"]={
TOP={cw=1},
},
["TOP (CCW)"]={
TOP={cw=-1},
},
["TOP (180)"]={
TOP={hFlip=true,vFlip=true},
},
["TOP (HFLIPPED)"]={
TOP={hFlip=true},
},
["BOTTOM (CW)"]={
BOTTOM={cw=1},
},
["BOTTOM (CCW)"]={
BOTTOM={cw=-1},
},
["BOTTOM (180)"]={
BOTTOM={hFlip=true,vFlip=true},
},
["BOTTOM (HFLIPPED)"]={
BOTTOM={hFlip=true},
},
}
function SpellActivationOverlay_ShowAllOverlays(self,spellID,texturePath,positions,scale,r,g,b,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
if SAO.Shutdown:IsAddonDisabled()then
return
end
positions=strupper(positions)
if (complexLocationTable[positions])then
for location,info in pairs(complexLocationTable[positions])do
SpellActivationOverlay_ShowOverlay(self,spellID,texturePath,location,scale,r,g,b,info.vFlip,info.hFlip,info.cw,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
end
else
SpellActivationOverlay_ShowOverlay(self,spellID,texturePath,positions,scale,r,g,b,false,false,0,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
end
end
function SpellActivationOverlay_ShowOverlay(self,spellID,texturePath,position,scale,r,g,b,vFlip,hFlip,cw,autoPulse,forcePulsePlay,endTime,combatOnly,extra)
SAO:Debug(Module, "Starting Overlay at location "..position.." for spell ID "..spellID.." "..SAO:GetSpellName(spellID, "")..(endTime and (" for "..math.floor((type(endTime)=='number' and endTime or endTime.endTime)-GetTime()+0.5).." secs") or ""))
if (SpellActivationOverlayDB and SpellActivationOverlayDB.alert and not SpellActivationOverlayDB.alert.enabled)then
return
end
local overlay=SpellActivationOverlay_GetOverlay(self,spellID,position)
SAO_LastShownOverlay=overlay
overlay.spellID=spellID
overlay.position=position
local texLeft,texRight,texTop,texBottom=0,1,0,1
if (vFlip)then
texTop,texBottom=1,0
end
if (hFlip)then
texLeft,texRight=1,0
end
if (not cw or cw==0)then
overlay.texture:SetTexCoord(texLeft,texRight,texTop,texBottom)
elseif (cw > 0)then
overlay.texture:SetTexCoord(texLeft,texBottom,texRight,texBottom,texLeft,texTop,texRight,texTop)
else
overlay.texture:SetTexCoord(texRight,texTop,texLeft,texTop,texRight,texBottom,texLeft,texBottom)
end
overlay.SetGeometry=function(self,longSide,shortSide)
local parent=self:GetParent()
self:ClearAllPoints()
local width,height
if (position=="CENTER")then
width,height=longSide,longSide
self:SetPoint("CENTER",parent, "CENTER",0,0)
elseif (position=="LEFT")then
width,height=shortSide,longSide
self:SetPoint("RIGHT",parent, "LEFT",0,0)
elseif (position=="RIGHT")then
width,height=shortSide,longSide
self:SetPoint("LEFT",parent, "RIGHT",0,0)
elseif (position=="TOP")then
width,height=longSide,shortSide
self:SetPoint("BOTTOM",parent, "TOP")
elseif (position=="BOTTOM")then
width,height=longSide,shortSide
self:SetPoint("TOP",parent, "BOTTOM")
elseif (position=="TOPRIGHT")then
width,height=shortSide,shortSide
self:SetPoint("BOTTOMLEFT",parent, "TOPRIGHT",0,0)
elseif (position=="TOPLEFT")then
width,height=shortSide,shortSide
self:SetPoint("BOTTOMRIGHT",parent, "TOPLEFT",0,0)
elseif (position=="BOTTOMRIGHT")then
width,height=shortSide,shortSide
self:SetPoint("TOPLEFT",parent, "BOTTOMRIGHT",0,0)
elseif (position=="BOTTOMLEFT")then
width,height=shortSide,shortSide
self:SetPoint("TOPRIGHT",parent, "BOTTOMLEFT",0,0)
else
return
end
self:SetSize(width * scale,height * scale)
self.mask:SetSize(longSide * scale,longSide * scale)
self.combat:SetSize(longSide * scale * combatOverlayFactor,longSide * scale * combatOverlayFactor)
end
overlay:SetGeometry(longSide,shortSide)
overlay.texture:SetTexture(texturePath)
overlay.texture:SetVertexColor(r / 255,g / 255,b / 255)
overlay.animOut:Stop()
if useSound and (autoPulse or forcePulsePlay)then
overlay.soundHandle=SAO:PlaySpellAlertSound()
end
if (combatOnly)then
overlay.animIn.alpha1:SetToAlpha(0.01)
overlay.animIn.alpha2:SetFromAlpha(0.01)
else
overlay.animIn.alpha1:SetToAlpha(0.5)
overlay.animIn.alpha2:SetFromAlpha(0.5)
end
overlay:Show()
if (forcePulsePlay and not overlay.pulse:IsPlaying())then
overlay.pulse:Play()
end
overlay.pulse.autoPlay=autoPulse
overlay.mask:SetShown(useTimer)
SpellActivationOverlay_SetOverlayTimer(self,overlay,endTime)
overlay.combatOnly=combatOnly
if (combatOnly)then
tDeleteItem(self.combatOnlyOverlays,overlay)
tinsert(self.combatOnlyOverlays,overlay)
if (InCombatLockdown())then
overlay.combat.animOut:Stop()
elseif (self.disableDimOutOfCombat)then
overlay.combat.animIn:Stop()
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
else
tDeleteItem(self.combatOnlyOverlays,overlay)
end
if (not self.disableDimOutOfCombat and not InCombatLockdown())then
self.combatAnimOut:Stop()
self.combatAnimIn:Play()
if (combatOnly)then
overlay.combat.animOut:Stop()
SpellActivationOverlayFrame_PlayCombatAnimIn(overlay.combat.animIn)
end
end
local frameStrata=type(extra)=='table' and extra.strata or "MEDIUM"
overlay:SetFrameStrata(frameStrata)
local frameLevel=type(extra)=='table' and extra.level or 3
overlay:SetFrameLevel(frameLevel)
end
function SpellActivationOverlay_DumpCombatOnlyOverlays()
SAO:Info(Module, "Listing combat-only overlays ("..#SAO.Frame.combatOnlyOverlays.." item"..(#SAO.Frame.combatOnlyOverlays==1 and "" or "s")..")")
for i,overlay in pairs(SAO.Frame.combatOnlyOverlays)do
SAO:Info(Module, "combat-only-overlay["..i.."] location=="..overlay.position..", ".."spell ID=="..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, ""))
end
end
function SpellActivationOverlay_GetOverlay(self,spellID,position)
local overlayList=self.overlaysInUse[spellID]
local overlay
if (overlayList)then
for i=1,#overlayList do
if (overlayList[i].position==position)then
overlay=overlayList[i]
end
end
end
if (not overlay)then
overlay=SpellActivationOverlay_GetUnusedOverlay(self)
if (overlayList)then
tinsert(overlayList,overlay)
else
self.overlaysInUse[spellID]={overlay}
end
end
return overlay
end
function SpellActivationOverlay_HideOverlays(self,spellID)
local overlayList=self.overlaysInUse[spellID]
if (overlayList)then
for i=1,#overlayList do
local overlay=overlayList[i]
SAO:Debug(Module, "Hiding Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, ""))
overlay.pulse:Pause()
overlay.animOut:Play()
end
end
end
function SpellActivationOverlay_HideAllOverlays(self)
for spellID,overlayList in pairs(self.overlaysInUse)do
SpellActivationOverlay_HideOverlays(self,spellID)
end
end
function SpellActivationOverlay_SetAllOverlayTimers(self,spellID,endTime)
if (not endTime)then
return
end
local overlayList=self.overlaysInUse[spellID]
if (overlayList)then
for i=1,#overlayList do
local overlay=overlayList[i]
SpellActivationOverlay_SetOverlayTimer(self,overlay,endTime)
end
end
end
function SpellActivationOverlay_SetOverlayTimer(self,overlay,endTime)
local startTime=type(endTime)=='table' and endTime.startTime or nil
endTime=type(endTime)=='table' and endTime.endTime or endTime
if (not endTime or endTime <=GetTime())then
return; -- endTime not set or "too soon"
end
local maxLag=0.25
if (type(overlay.endTime)=='number' and SAO:IsTimeAlmostEqual(endTime,overlay.endTime,maxLag))then
return
end
overlay.endTime=endTime
SAO:Debug(Module, "Setting Overlay Timer at location "..overlay.position.." for spell ID "..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, "")..(endTime and (" for "..math.floor(endTime-GetTime()+0.5).." secs") or " without time"))
local offset=startTime and (GetTime() - startTime) or 0
local duration=endTime - GetTime() + offset - 0.1
local position=overlay.position
local isHorizontal=position:sub(1,3)=="TOP" or position:sub(1,6)=="BOTTOM"
local isVertical=position:sub(#position-3)=="LEFT" or position:sub(#position-4)=="RIGHT"
if (isHorizontal and isVertical)then
overlay.mask.timeoutXY.scaleXY:SetDuration(duration)
overlay.mask.timeoutXY:Stop()
overlay.mask.timeoutXY:Play(false,offset)
elseif (isHorizontal)then
overlay.mask.timeoutX.scaleX:SetDuration(duration)
overlay.mask.timeoutX:Stop()
overlay.mask.timeoutX:Play(false,offset)
elseif (isVertical)then
overlay.mask.timeoutY.scaleY:SetDuration(duration)
overlay.mask.timeoutY:Stop()
overlay.mask.timeoutY:Play(false,offset)
end
end
function SpellActivationOverlay_GetUnusedOverlay(self)
local overlay=tremove(self.unusedOverlays,#self.unusedOverlays)
if (not overlay)then
overlay=SpellActivationOverlay_CreateOverlay(self)
end
return overlay
end
function SpellActivationOverlay_CreateOverlay(self)
return CreateFrame("Frame",nil,self, "SpellActivationOverlayAddonTemplate")
end
function SpellActivationOverlayTexture_OnShow(self)
self.animIn:Play()
end
function SpellActivationOverlayTexture_TerminateOverlay(overlay)
SAO:Debug(Module, "Terminating Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, ""))
local overlayParent=overlay:GetParent()
overlay.pulse:Stop()
overlay.animOut:Stop()
overlay.mask.timeoutXY:Stop()
overlay.mask.timeoutX:Stop()
overlay.mask.timeoutY:Stop()
overlay.combat.animIn:Stop()
overlay.combat.animOut:Stop()
SAO:StopSpellAlertSound(overlay.soundHandle,1000)
overlay.soundHandle=nil
overlay.mask:SetAlpha(0)
overlay.mask:SetScale(1)
overlay.endTime=nil
overlay:Hide()
tDeleteItem(overlayParent.overlaysInUse[overlay.spellID],overlay)
tinsert(overlayParent.unusedOverlays,overlay)
tDeleteItem(overlayParent.combatOnlyOverlays,overlay)
end
function SpellActivationOverlayFrame_OnTimeoutFinished(anim)
local mask=anim:GetParent()
local overlay=mask:GetParent()
mask:SetScale(0.01)
overlay.animOut:Play()
end
function SpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(anim)
local combat=anim:GetParent()
local overlay=combat:GetParent()
local frame=overlay:GetParent()
local position=overlay.position
local baseLongSide=256
local baseShortSide=128
local farAway=((baseLongSide-baseShortSide) / 2 + baseShortSide) * sizeScale * frame.scale * combatOverlayFactor
if (position=="CENTER")then
return 0,0
elseif (position=="LEFT")then
return farAway,0
elseif (position=="RIGHT")then
return -farAway,0
elseif (position=="TOP")then
return 0,-farAway
elseif (position=="BOTTOM")then
return 0,farAway
elseif (position=="TOPRIGHT")then
return -farAway,-farAway
elseif (position=="TOPLEFT")then
return farAway,-farAway
elseif (position=="BOTTOMRIGHT")then
return -farAway,farAway
elseif (position=="BOTTOMLEFT")then
return farAway,farAway
else
return
end
end
function SpellActivationOverlayFrame_PlayCombatAnimIn(animIn)
local offsetX,offsetY=SpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(animIn)
offsetX,offsetY=0.7 * offsetX,0.7 * offsetY
animIn.point1:SetOffset(offsetX,offsetY)
animIn.point2:SetOffset(-offsetX,-offsetY)
animIn:Play()
end
function SpellActivationOverlayFrame_PlayCombatAnimOut(animOut)
local offsetX,offsetY=SpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(animOut)
animOut.point1:SetOffset(offsetX,offsetY)
animOut:Play()
end
function SpellActivationOverlayTexture_ShowCombatMask(anim)
local combat=anim:GetParent():GetParent()
combat:SetTexture("Interface/Addons/SpellActivationOverlay/textures/maskzero")
local overlay=combat:GetParent()
SAO:Debug(Module, "Showing combat mask for Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, ""))
end
function SpellActivationOverlayTexture_HideCombatMask(anim)
local combat=anim:GetParent():GetParent()
combat:SetTexture("")
local overlay=combat:GetParent()
SAO:Debug(Module, "Hiding combat mask for Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..SAO:GetSpellName(overlay.spellID, ""))
end
function SpellActivationOverlayTexture_OnCombatAnimInPlay(animIn)
SpellActivationOverlayTexture_HideCombatMask(animIn)
end
function SpellActivationOverlayTexture_OnCombatAnimInFinished(animIn)
SpellActivationOverlayTexture_ShowCombatMask(animIn)
end
function SpellActivationOverlayTexture_OnCombatAnimInStop(animIn)
SpellActivationOverlayTexture_ShowCombatMask(animIn)
end
function SpellActivationOverlayTexture_OnCombatAnimOutPlay(animOut)
SpellActivationOverlayTexture_ShowCombatMask(animOut)
end
function SpellActivationOverlayTexture_OnFadeInPlay(animGroup)
local overlay=animGroup:GetParent()
overlay:SetAlpha(0)
end
function SpellActivationOverlayTexture_OnFadeInFinished(animGroup)
local overlay=animGroup:GetParent()
overlay:SetAlpha(1)
if (overlay.pulse.autoPlay and not overlay.pulse:IsPlaying())then
overlay.pulse:Play()
end
end
function SpellActivationOverlayTexture_PreStartPulse(anim)
local overlay=anim:GetParent():GetParent()
if (overlay.combatOnly and overlay.pulse.autoPlay and not overlay.pulse:IsPlaying())then
overlay.pulse:Play()
end
end
function SpellActivationOverlayTexture_OnFadeOutFinished(anim)
local overlay=anim:GetRegionParent()
SpellActivationOverlayTexture_TerminateOverlay(overlay)
end
function SpellActivationOverlayFrame_OnFadeInFinished(anim)
if (not InCombatLockdown())then
local frame=anim:GetParent()
if (not frame.disableDimOutOfCombat)then
frame.combatAnimOut:Play()
for _,overlay in ipairs(frame.combatOnlyOverlays)do
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
end
end
end
function SpellActivationOverlayFrame_OnEnterCombat(anim)
local frame=anim:GetParent()
frame.inPseudoCombat=true
end
function SpellActivationOverlayFrame_OnLeaveCombat(anim)
local frame=anim:GetParent()
frame.inPseudoCombat=false
end
function SpellActivationOverlayFrame_SetForceAlpha1(enabled)
local self=SpellActivationOverlayAddonFrame
if (enabled)then
if (not self.disableDimOutOfCombat)then
self.disableDimOutOfCombat=1
self.combatAnimOut:Stop()
self:SetAlpha(1)
for _,overlay in ipairs(self.combatOnlyOverlays)do
overlay.combat.animOut:Stop()
overlay.texture:SetAlpha(1)
end
else
self.disableDimOutOfCombat=self.disableDimOutOfCombat-self.disableDimOutOfCombat%10+1
end
else
if (self.disableDimOutOfCombat)then
self.disableDimOutOfCombat=self.disableDimOutOfCombat-self.disableDimOutOfCombat%10
if (self.disableDimOutOfCombat==0)then
self.disableDimOutOfCombat=nil
if (not InCombatLockdown())then
self.combatAnimOut:Play()
for _,overlay in ipairs(self.combatOnlyOverlays)do
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
end
end
end
end
end
function SpellActivationOverlayFrame_SetForceAlpha2(enabled)
local self=SpellActivationOverlayAddonFrame
if (enabled)then
if (not self.disableDimOutOfCombat)then
self.disableDimOutOfCombat=10
self.combatAnimOut:Stop()
self:SetAlpha(1)
for _,overlay in ipairs(self.combatOnlyOverlays)do
overlay.combat.animOut:Stop()
overlay.texture:SetAlpha(1)
end
else
self.disableDimOutOfCombat=self.disableDimOutOfCombat%10+10
end
else
if (self.disableDimOutOfCombat)then
self.disableDimOutOfCombat=self.disableDimOutOfCombat%10
if (self.disableDimOutOfCombat==0)then
self.disableDimOutOfCombat=nil
if (not InCombatLockdown())then
self.combatAnimOut:Play()
for _,overlay in ipairs(self.combatOnlyOverlays)do
SpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut)
end
end
end
end
end
end
