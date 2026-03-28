local AddonName,SAO=...
local Module="glow"
local GetNumShapeshiftForms=GetNumShapeshiftForms
local HasAction=HasAction
SAO.ActionButtons={}
SAO.DormantActionButtons={}
SAO.GlowingSpells={}
SAO.RegisteredGlowSpellIDs={}
SAO.RegisteredGlowSpellNames={}
function SAO.RegisterGlowID(self,glowID)
if (type(glowID)=="number")then
self.RegisteredGlowSpellIDs[glowID]=true
self:AwakeButtonsBySpellID(glowID)
elseif (type(glowID)=="string")then
if (not SAO.RegisteredGlowSpellNames[glowID])then
SAO.RegisteredGlowSpellNames[glowID]=true
local glowSpellIDs=self:GetSpellIDsByName(glowID)
for _,glowSpellID in ipairs(glowSpellIDs)do
self.RegisteredGlowSpellIDs[glowSpellID]=true
self:AwakeButtonsBySpellID(glowSpellID)
end
end
end
end
function SAO.RegisterGlowIDs(self,glowIDs)
for _,glowID in ipairs(glowIDs or {})do
self:RegisterGlowID(glowID)
end
end
local GlowEngine=SAO.IsProject(SAO.CATA_AND_ONWARD) and {
SAOGlows={},
NativeGlows={},
FrameName=function(self,frame)
return tostring(frame and frame.GetName and frame:GetName() or "")
end,
SpellInfo=function(self,glowID)
return tostring(glowID).." ("..tostring(SAO:GetSpellName(glowID))..")"
end,
ParamName=function(self,frame,glowID)
return self:FrameName(frame)..", "..self:SpellInfo(glowID)
end,
BeginGlowFinally=function(self,frame,noAnimIn)
if frame.__sao.startTimer==nil then
frame.__sao.startTimer=C_Timer.NewTimer(
SAO:IsResponsiveMode() and 0.01 or 0.028,
function()
frame.__sao.EnableGlow()
if noAnimIn and frame.__sao.useExternalGlow==false then
local animIn=frame.__LBGoverlay and frame.__LBGoverlay.animIn
if animIn then
local finishScript=animIn.GetScript and animIn:GetScript("OnFinished")
if finishScript then
animIn:Stop()
finishScript(animIn)
end
end
end
end
)
end
end,
EndGlowFinally=function(self,frame,onlyIfInternal)
if frame.__sao.startTimer then
frame.__sao.startTimer:Cancel()
frame.__sao.startTimer=nil
end
if onlyIfInternal then
if not frame.__sao.useExternalGlow then
frame.__sao.DisableGlow()
end
else
frame.__sao.DisableGlow()
end
end,
BeginSAOGlow=function(self,frame,glowID)
local saoGlowForGlowID=self.SAOGlows[glowID]
if saoGlowForGlowID then
SAO:Debug(Module, "Re-glowing an already glowing button "..self:ParamName(frame,glowID))
if saoGlowForGlowID[frame]==true then
return
end
else
self.SAOGlows[glowID]={}
saoGlowForGlowID=self.SAOGlows[glowID]
end
local isStartingGlow
if self.NativeGlows[glowID] then
SAO:Debug(Module, "BeginSAOGlow does not glow to prevent conflict with Native glow of "..self:ParamName(frame,glowID))
isStartingGlow=false
else
isStartingGlow=true
self:BeginGlowFinally(frame)
end
saoGlowForGlowID[frame]=isStartingGlow
end,
EndSAOGlow=function(self,frame,glowID)
self:EndGlowFinally(frame)
local saoGlowForGlowID=self.SAOGlows[glowID]
if not saoGlowForGlowID then
SAO:Debug(Module, "Trying to un-glow a non-tracked action "..self:SpellInfo(glowID))
return
end
if saoGlowForGlowID[frame]==nil then
SAO:Debug(Module, "Trying to un-glow a tracked action but un-tracked button "..self:SpellInfo(glowID))
return
end
saoGlowForGlowID[frame]=nil
local nbFrames=0
for _,_ in pairs(saoGlowForGlowID)do nbFrames=nbFrames + 1; end
if nbFrames==0 then
self.SAOGlows[glowID]=nil
end
end,
BeginNativeGlow=function(self,glowID)
if self.NativeGlows[glowID] then
return
end
local saoGlowForGlowID=self.SAOGlows[glowID]
if saoGlowForGlowID then
for frame,isGlowingByUs in pairs(saoGlowForGlowID)do
if isGlowingByUs then
SAO:Debug(Module, "BeginNativeGlow un-glows SAO glowing button "..self:FrameName(frame,glowID))
self:EndGlowFinally(frame,true)
saoGlowForGlowID[frame]=false
end
end
end
self.NativeGlows[glowID]=true
end,
EndNativeGlow=function(self,glowID)
if not self.NativeGlows[glowID] then
return
end
local saoGlowForGlowID=self.SAOGlows[glowID]
if saoGlowForGlowID then
for frame,isGlowingByUs in pairs(saoGlowForGlowID)do
if not isGlowingByUs then
SAO:Debug(Module, "EndNativeGlow allows to re-glow SAO glowing buttons "..self:FrameName(frame,glowID))
self:BeginGlowFinally(frame,true)
saoGlowForGlowID[frame]=true
end
end
end
self.NativeGlows[glowID]=nil
end,
} or {
BeginSAOGlow=function(self,frame,glowID)
frame.__sao.EnableGlow()
end,
EndSAOGlow=function(self,frame,glowID)
frame.__sao.DisableGlow()
end,
}
if SAO.IsProject(SAO.CATA_AND_ONWARD)then
local GlowEngineFrame=CreateFrame("Frame", "SpellActivationOverlayGlowEngineFrame")
SAO:RegisterEventHandler(GlowEngineFrame, "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", "Static initializer: "..Module)
SAO:RegisterEventHandler(GlowEngineFrame, "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", "Static initializer: "..Module)
GlowEngineFrame:SetScript("OnEvent",function (self,event,spellID)
if event=="SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
GlowEngine:BeginNativeGlow(spellID)
elseif event=="SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
GlowEngine:EndNativeGlow(spellID)
end
end)
end
local function EnableGlow(frame,glowID,reason)
if SAO.Shutdown:IsAddonDisabled()then
return
end
if frame:IsShown()then
SAO:Debug(Module, "Enabling Glow for button "..tostring(frame.GetName and frame:GetName() or "").." with glow id "..tostring(glowID).." due to "..reason)
GlowEngine:BeginSAOGlow(frame,glowID)
end
end
local function DisableGlow(frame,glowID,reason)
SAO:Debug(Module, "Disabling Glow for button "..tostring(frame.GetName and frame:GetName() or "").." with glow id "..tostring(glowID).." due to "..reason)
GlowEngine:EndSAOGlow(frame,glowID)
end
function SAO.UpdateActionButton(self,button,forceRefresh)
local oldGlowID=button.__sao.lastGlowID
local newGlowID=button.__sao.GetGlowID()
button.__sao.lastGlowID=newGlowID
if (oldGlowID==newGlowID and not forceRefresh)then
return
end
if (oldGlowID and not self.RegisteredGlowSpellIDs[oldGlowID] and type(self.DormantActionButtons[oldGlowID])=='table')then
if (self.DormantActionButtons[oldGlowID][button]==button)then
self.DormantActionButtons[oldGlowID][button]=nil
end
end
if (newGlowID and not self.RegisteredGlowSpellIDs[newGlowID])then
if (type(self.DormantActionButtons[newGlowID])=='table')then
if (self.DormantActionButtons[newGlowID][button]~=button)then
self.DormantActionButtons[newGlowID][button]=button
end
else
self.DormantActionButtons[newGlowID]={[button]=button}
end
end
if (not self.RegisteredGlowSpellIDs[oldGlowID] and not self.RegisteredGlowSpellIDs[newGlowID])then
return
end
if (oldGlowID and self.RegisteredGlowSpellIDs[oldGlowID] and type(self.ActionButtons[oldGlowID])=='table')then
if (self.ActionButtons[oldGlowID][button]==button)then
self.ActionButtons[oldGlowID][button]=nil
end
end
if (newGlowID and self.RegisteredGlowSpellIDs[newGlowID])then
if (type(self.ActionButtons[newGlowID])=='table')then
if (self.ActionButtons[newGlowID][button]~=button)then
self.ActionButtons[newGlowID][button]=button
end
else
self.ActionButtons[newGlowID]={[button]=button}
end
if (type(self.DormantActionButtons[newGlowID])=='table' and self.DormantActionButtons[newGlowID][button]==button)then
self.DormantActionButtons[newGlowID][button]=nil
end
end
local wasGlowing=oldGlowID and (self.GlowingSpells[oldGlowID]~=nil)
local mustGlow=newGlowID and (self.GlowingSpells[newGlowID]~=nil)
if (not wasGlowing and mustGlow)then
if (not SpellActivationOverlayDB or not SpellActivationOverlayDB.glow or SpellActivationOverlayDB.glow.enabled)then
EnableGlow(button,newGlowID, "action button update (was "..tostring(oldGlowID)..")")
end
elseif (wasGlowing and not mustGlow)then
DisableGlow(button,oldGlowID, "action button update (now "..tostring(newGlowID)..")")
end
end
local LBG=LibStub("LibButtonGlow-1.0",false)
local function HookActionButton_Update(button)
if (button:GetParent()==OverrideActionBar)then
if not button.saoAnalyzed then
button.saoAnalyzed=true
local useOverrideActionBar=((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player")~="")
or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin()~=0))
if not useOverrideActionBar then
button:SetAttribute("statehidden",true)
end
end
return
end
if not button.__sao then
button.__sao={useExternalGlow=false}
button.__sao.GetGlowID=function()
if (button.action and HasAction(button.action))then
return SAO:GetSpellIDByActionSlot(button.action)
end
end
button.__sao.EnableGlow=function()
LBG.ShowOverlayGlow(button)
end
button.__sao.DisableGlow=function()
LBG.HideOverlayGlow(button)
end
end
SAO:UpdateActionButton(button)
end
if SAO.HasMidnightUI()then
local actionBars={
MainActionBar,
MultiBarLeft,
MultiBarRight,
MultiBarBottomLeft,
MultiBarBottomRight,
MultiBar5,
MultiBar6,
MultiBar7,
}
for index,actionBar in ipairs(actionBars)do
for _,actionButton in ipairs(actionBar and actionBar.actionButtons or {})do
hooksecurefunc(actionButton, "Update",HookActionButton_Update)
end
end
else
hooksecurefunc("ActionButton_Update",HookActionButton_Update)
end
local function HookStanceBar_UpdateState()
local numForms=GetNumShapeshiftForms()
for i=1,numForms do
if i > NUM_STANCE_SLOTS then
break
end
local button=StanceBarFrame.StanceButtons[i]
button.stanceForm=i
if not button.__sao then
button.__sao={useExternalGlow=false}
button.__sao.GetGlowID=function()
return select(4,GetShapeshiftFormInfo(button.stanceForm))
end
button.__sao.EnableGlow=function()
LBG.ShowOverlayGlow(button)
end
button.__sao.DisableGlow=function()
LBG.HideOverlayGlow(button)
end
end
SAO:UpdateActionButton(button)
end
end
if select(2,UnitClass("player"))=="PRIEST" then
if not SAO.HasMidnightUI()then
hooksecurefunc("StanceBar_UpdateState",HookStanceBar_UpdateState)
end
end
function SAO.AwakeButtonsBySpellID(self,spellID)
local dormantButtons={}
for _,button in pairs(self.DormantActionButtons[spellID] or {})do
table.insert(dormantButtons,button)
end
for _,button in ipairs(dormantButtons)do
self:UpdateActionButton(button,true)
end
end
function SAO.AddGlowNumber(self,spellID,glowID)
local actionButtons=self.ActionButtons[glowID]
if (self.GlowingSpells[glowID])then
self.GlowingSpells[glowID][spellID]=true
else
self.GlowingSpells[glowID]={[spellID]=true}
for _,frame in pairs(actionButtons or {})do
if (not SpellActivationOverlayDB or not SpellActivationOverlayDB.glow or SpellActivationOverlayDB.glow.enabled)then
if not frame.__sao then
SAO:Debug(Module, "Action Button "..tostring(frame:GetName()).." does not have __sao, ".."glow may fail")
elseif not frame.__sao.GetGlowID()then
SAO:Debug(Module, "Action Button "..tostring(frame:GetName()).." has a nil __sao.GetGlowID, ".."glow may fail")
elseif not frame.__sao.lastGlowID then
SAO:Debug(Module, "Action Button "..tostring(frame:GetName()).." has a nil __sao.lastGlowID, ".."glow may fail")
elseif frame.__sao.GetGlowID()~=frame.__sao.lastGlowID then
SAO:Debug(Module, "Action Button "..tostring(frame:GetName()).." has a different __sao.GetGlowID ("..tostring(frame.__sao.GetGlowID())..") vs. __sao.lastGlowID ("..tostring(frame.__sao.lastGlowID).."), ".."glow may fail")
end
EnableGlow(frame,frame.__sao and (frame.__sao.GetGlowID() or frame.__sao.lastGlowID) or glowID, "direct activation")
end
end
end
end
local function isGlowingOptionEnabled(glowingOptions,glowID,hashData)
if not glowingOptions then
return true
end
local optionIndex=hashData and hashData.optionIndex
local legacyAllowed=hashData==nil or hashData.legacyGlowingOption
if type(glowID)=="number" then
if optionIndex and type(glowingOptions[optionIndex])=='table' and type(glowingOptions[optionIndex][glowID])=='boolean' then
return glowingOptions[optionIndex][glowID]
elseif legacyAllowed and type(glowingOptions[glowID])=="boolean" then
return glowingOptions[glowID]
end
else
local glowSpellName=(type(glowID)=="number") and SAO:GetSpellName(glowID) or glowID
if optionIndex and type(glowingOptions[optionIndex])=='table' then
for optionSpellID,optionEnabled in pairs(glowingOptions[optionIndex])do
if SAO:GetSpellName(optionSpellID)==glowSpellName then
return optionEnabled
end
end
end
if legacyAllowed then
for optionSpellID,optionEnabled in pairs(glowingOptions)do
if type(optionSpellID)=='number' and SAO:GetSpellName(optionSpellID)==glowSpellName then
return optionEnabled
end
end
end
end
return true
end
function SAO.AddGlow(self,spellID,glowIDs,hashData)
if (glowIDs==nil)then
return
end
local glowingOptions=self:GetGlowingOptions(spellID)
for _,glowID in ipairs(glowIDs)do
local glowEnabled=isGlowingOptionEnabled(glowingOptions,glowID,hashData)
if (glowEnabled)then
if (type(glowID)=="number")then
self:AddGlowNumber(spellID,glowID)
elseif (type(glowID)=="string")then
local glowSpellIDs=self:GetSpellIDsByName(glowID)
for _,glowSpellID in ipairs(glowSpellIDs)do
self:AddGlowNumber(spellID,glowSpellID)
end
end
end
end
end
function SAO.RemoveGlow(self,spellID,glowIDs)
local consumedGlowSpellIDs={}
local onlyTheseGlowIDs
if type(glowIDs)=='table' then
onlyTheseGlowIDs={}
for _,glowID in ipairs(glowIDs)do
if (type(glowID)=="number")then
onlyTheseGlowIDs[glowID]=true
elseif (type(glowID)=="string")then
local glowSpellIDs=self:GetSpellIDsByName(glowID)
for _,glowSpellID in ipairs(glowSpellIDs)do
onlyTheseGlowIDs[glowSpellID]=true
end
end
end
end
for glowSpellID,triggerSpellIDs in pairs(self.GlowingSpells)do
if triggerSpellIDs[spellID] and (not onlyTheseGlowIDs or onlyTheseGlowIDs[glowSpellID])then
local count=0
for _,_ in pairs(triggerSpellIDs)do
count=count+1
end
consumedGlowSpellIDs[glowSpellID]=count
end
end
for glowSpellID,count in pairs(consumedGlowSpellIDs)do
if (count > 1)then
self.GlowingSpells[glowSpellID][spellID]=nil
else
self.GlowingSpells[glowSpellID]=nil
local actionButtons=self.ActionButtons[glowSpellID]
for _,frame in pairs(actionButtons or {})do
DisableGlow(frame,glowSpellID, "direct deactivation")
end
end
end
end
local warnedOutdatedLBG=false
local function warnOutdatedLBG()
if warnedOutdatedLBG then return end
local text="[|cffa2f3ff"..AddonName.."|r] One of your addons uses an old version of LibButtonGlow. "
.."|cffff0000Please consider updating your addons|r. "
.."Glowing buttons have been |cffff8040temporarily disabled|r to prevent issues. "
.."(note: the Glowing Buttons option can still be enabled, ".."but it will have no effect until the faulty addon is up-to-date)"
print(text)
warnedOutdatedLBG=true
end
local binder=CreateFrame("Frame", "SpellActivationOverlayLABBinder")
binder:RegisterEvent("PLAYER_LOGIN")
binder:SetScript("OnEvent",function()
if (not LibStub)then
return
end
local LAB=LibStub("LibActionButton-1.0",true)
local LAB_ElvUI=LibStub("LibActionButton-1.0-ElvUI",true)
local LAB_GE=LibStub("LibActionButton-1.0-GE",true)
local LBG,LBGversion=LibStub("LibButtonGlow-1.0",true)
local LCG=LibStub("LibCustomGlow-1.0",true)
local Dominos=LibStub("AceAddon-3.0",true) and LibStub("AceAddon-3.0",true):GetAddon("Dominos",true)
local buttonUpdateFunc=function(libGlow,event,self)
if (self._state_type~="action")then
return
end
if not self.__sao or self.__sao.useExternalGlow==false then
if self.__sao then
SAO:Debug(Module, "Replacing glowing button functions of "..tostring(self.GetName and self.GetName()).." with external lib")
self.__sao.useExternalGlow=true
else
self.__sao={useExternalGlow=true}
end
self.__sao.GetGlowID=function()
return self:GetSpellId()
end
self.__sao.EnableGlow=function()
libGlow.ShowOverlayGlow(self)
end
self.__sao.DisableGlow=function()
libGlow.HideOverlayGlow(self)
end
end
SAO:UpdateActionButton(self)
end
local LBGButtonUpdateFunc=function(event,self)
buttonUpdateFunc(LBG,event,self)
end
local LCGButtonUpdateFunc=function(event,self)
buttonUpdateFunc(LCG,event,self)
end
local LAB_GEButtonUpdateFunc=function(event,self)
buttonUpdateFunc(LAB_GE,event,self)
end
if (LAB and LBG and LBGversion >=8)then
LAB:RegisterCallback("OnButtonUpdate",LBGButtonUpdateFunc)
elseif (LAB and LCG)then
LAB:RegisterCallback("OnButtonUpdate",LCGButtonUpdateFunc)
elseif (LAB and LBG)then
warnOutdatedLBG()
end
if (LAB_ElvUI)then
local hasElvUI13OrHigher,hasElvUI1381OrHigher=false,false
if (ElvUI and ElvUI[1] and type(ElvUI[1].version)=='number')then
hasElvUI13OrHigher=ElvUI[1].version >=13
hasElvUI1381OrHigher=ElvUI[1].version >=13.81
end
local hasAzilroka186OrLower=false
if (ProjectAzilroka and type(ProjectAzilroka.Version)=='string')then
local _,_,azilMajor,azilMinor=strfind(ProjectAzilroka.Version, "(%d+)%.(%d+)")
azilMajor=tonumber(azilMajor)
azilMinor=tonumber(azilMinor)
if (type(azilMajor)=='number' and type(azilMinor)=='number')then
hasAzilroka186OrLower=azilMajor < 1 or azilMajor==1 and azilMinor <=86
end
end
if (hasElvUI13OrHigher and not hasElvUI1381OrHigher and not hasAzilroka186OrLower)then
if (LBG and LBGversion >=8)then
LAB_ElvUI:RegisterCallback("OnButtonUpdate",LBGButtonUpdateFunc)
elseif (LCG)then
LAB_ElvUI:RegisterCallback("OnButtonUpdate",LCGButtonUpdateFunc)
elseif (LBG)then
warnOutdatedLBG()
end
else
if (LCG)then
LAB_ElvUI:RegisterCallback("OnButtonUpdate",LCGButtonUpdateFunc)
elseif (LBG and LBGversion >=8)then
LAB_ElvUI:RegisterCallback("OnButtonUpdate",LBGButtonUpdateFunc)
elseif (LBG)then
warnOutdatedLBG()
end
end
end
if (LAB_GE)then
LAB_GE:RegisterCallback("OnButtonUpdate",LAB_GEButtonUpdateFunc)
end
if (Dominos and SAO.HasMidnightUI())then
for i=1,Dominos:NumBars()do
local bar=_G["DominosFrame"..i]
if bar and bar.buttons then
for _,button in pairs(bar.buttons)do
hooksecurefunc(button, "Update",HookActionButton_Update)
end
end
end
end
binder:UnregisterEvent("PLAYER_LOGIN")
end)
