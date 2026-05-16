local AddonName,SAO=...
local iamNecrosis=strlower(AddonName):sub(0,8)=="necrosis"
local GetAddOnMetadata=C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
function SpellActivationOverlayOptionsPanel_Init(self)
local shutdownCategory=SAO.Shutdown:GetCategory()
if shutdownCategory then
if shutdownCategory.Reason then
local globalOffReason=SpellActivationOverlayOptionsPanel.globalOff.reason
globalOffReason:SetText("("..shutdownCategory.Reason..")")
end
if shutdownCategory.Button then
local globalOffButton=SpellActivationOverlayOptionsPanel.globalOff.button
globalOffButton:SetText(shutdownCategory.Button.Text)
local estimatedWidth=(2+strlenutf8(shutdownCategory.Button.Text))*8
globalOffButton:SetWidth(estimatedWidth)
if estimatedWidth > 48 then
globalOffButton:SetHeight(globalOffButton:GetHeight()+ceil((estimatedWidth-32)/16))
end
globalOffButton:SetScript("OnClick",shutdownCategory.Button.OnClick)
globalOffButton:Show()
end
if shutdownCategory.DisableCondition then
local disableCondition=SAO.Shutdown:GetCategory().DisableCondition
local disableConditionButton=SpellActivationOverlayOptionsPanelDisableConditionButton
disableConditionButton.Text:SetText(disableCondition.Text)
disableConditionButton.OnValueChanged=function(self,checked)
if checked then
disableCondition.OnValueChanged(self,true)
SpellActivationOverlayOptionsPanel.globalOff:Show()
local testButton=SpellActivationOverlayOptionsPanelSpellAlertTestButton
if testButton.isTesting then
testButton:StopTest()
end
else
disableCondition.OnValueChanged(self,false)
SpellActivationOverlayOptionsPanel.globalOff:Hide()
end
end
disableConditionButton:SetChecked(SAO.Shutdown:IsAddonDisabled())
disableConditionButton:OnValueChanged(disableConditionButton:GetChecked())
if disableCondition.ShowIf==nil or disableCondition.ShowIf()then
disableConditionButton:Show()
end
else
SpellActivationOverlayOptionsPanel.globalOff:Show()
end
end
local mustDisableGlowForEveryone=false
if not shutdownCategory and mustDisableGlowForEveryone then
SpellActivationOverlayOptionsPanel.glowOff:Show()
else
SpellActivationOverlayOptionsPanel.glowOff:Hide()
end
local buildInfoLabel=SpellActivationOverlayOptionsPanelBuildInfo
local xSaoBuild=GetAddOnMetadata(AddonName, "X-SAO-Build")
if type(xSaoBuild)=='string' and #xSaoBuild > 0 then
local titleText=GetAddOnMetadata(AddonName, "Title")
if xSaoBuild=="universal" then
local universalText=SAO:gradientText(
SAO:universalBuild(),
{
{r=0.1,g=1,b=0.3},
{r=1,g=1,b=0.5},
{r=0.9,g=0.1,b=0},
{r=0.7,g=0,b=0.8},
{r=0,g=0.3,b=1},
}
)
buildInfoLabel:SetText(titleText.."\n"..universalText)
elseif xSaoBuild=="dev" then
local buildForDevs=SAO:gradientText(
"Build for Developers",
{
{r=0,g=0.3,b=1},
{r=1,g=1,b=1},
{r=0,g=0.3,b=1},
}
)
buildInfoLabel:SetText(titleText.."\n"..buildForDevs)
else
local addonBuild=SAO.GetFullProjectName(xSaoBuild)
local expectedBuild=SAO.GetFullProjectName(SAO.GetExpectedBuildID())
if addonBuild~=expectedBuild then
titleText=WrapTextInColorCode(titleText, "ffff0000")
addonBuild=WrapTextInColorCode(addonBuild, "ffff0000")
expectedBuild=WrapTextInColorCode(expectedBuild, "ffff0000")
buildInfoLabel:SetFontObject(GameFontNormalLarge)
SAO:Info("",SAO:compatibilityWarning(addonBuild,expectedBuild))
end
local optimizedForText
if xSaoBuild=="vanilla" then
if addonBuild==expectedBuild then
optimizedForText=SAO:optimizedFor(BNET_FRIEND_TOOLTIP_WOW_CLASSIC)
else
optimizedForText=SAO:optimizedFor(WrapTextInColorCode(BNET_FRIEND_TOOLTIP_WOW_CLASSIC, "ffff0000"))
end
else
optimizedForText=SAO:optimizedFor(string.format(BNET_FRIEND_ZONE_WOW_CLASSIC,addonBuild))
end
local subProjectName=SAO.GetSubProjectName(xSaoBuild)
if subProjectName then
optimizedForText=optimizedForText .. " (" .. subProjectName .. ")"
end
buildInfoLabel:SetText(titleText.."\n"..optimizedForText)
end
end
local classInfoLabel=SpellActivationOverlayOptionsPanelClassInfo
if SAO.CurrentClass then
local className,classFile,classId=SAO.CurrentClass.Intrinsics[1],SAO.CurrentClass.Intrinsics[2],SAO.CurrentClass.Intrinsics[3]
local gradientColors
if classFile=="PRIEST" then
gradientColors={
{r=0.8,g=0.8,b=0.8},
RAID_CLASS_COLORS[classFile],
{r=0.9,g=0.9,b=0.9},
{r=0.7,g=0.7,b=0.7},
}
else
local function mixColors(color1,color2,t)
return {
r=color1.r * (1 - t) + color2.r * t,
g=color1.g * (1 - t) + color2.g * t,
b=color1.b * (1 - t) + color2.b * t,
}
end
local classColor=RAID_CLASS_COLORS[classFile]
gradientColors={
classColor,
mixColors(classColor,{r=1,g=1,b=1},0.25),
classColor,
mixColors(classColor,{r=0,g=0,b=0},0.15),
}
end
local classIcons={
["DEATHKNIGHT"]="Interface/Icons/Spell_Deathknight_ClassIcon",
["DRUID"]="Interface/Icons/ClassIcon_Druid",
["HUNTER"]="Interface/Icons/ClassIcon_Hunter",
["MAGE"]="Interface/Icons/ClassIcon_Mage",
["MONK"]="Interface/Icons/ClassIcon_Monk",
["PALADIN"]="Interface/Icons/ClassIcon_Paladin",
["PRIEST"]="Interface/Icons/ClassIcon_Priest",
["ROGUE"]="Interface/Icons/ClassIcon_Rogue",
["SHAMAN"]="Interface/Icons/ClassIcon_Shaman",
["WARLOCK"]="Interface/Icons/ClassIcon_Warlock",
["WARRIOR"]="Interface/Icons/ClassIcon_Warrior",
}
local classIcon=classIcons[classFile] or "Interface/Icons/INV_Misc_QuestionMark"
local classText=SAO:gradientText(className,gradientColors)
classInfoLabel:SetText(string.format("|T%s:16:16:0:0:512:512:32:480:32:480|t %s",classIcon,classText))
else
classInfoLabel:SetText("")
end
local opacitySlider=SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider.Text:SetText(SPELL_ALERT_OPACITY)
_G[opacitySlider:GetName().."Low"]:SetText(OFF)
opacitySlider:SetMinMaxValues(0,1)
opacitySlider:SetValueStep(0.05)
opacitySlider.initialValue=SpellActivationOverlayDB.alert.opacity
opacitySlider:SetValue(opacitySlider.initialValue)
opacitySlider.ApplyValueToEngine=function(self,value)
SpellActivationOverlayDB.alert.opacity=value
SpellActivationOverlayDB.alert.enabled=value > 0
SAO:ApplySpellAlertOpacity()
end
local scaleSlider=SpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider.Text:SetText("Spell Alert Scale")
_G[scaleSlider:GetName().."Low"]:SetText(SMALL)
_G[scaleSlider:GetName().."High"]:SetText(LARGE)
scaleSlider:SetMinMaxValues(0.25,2.5)
scaleSlider:SetValueStep(0.05)
scaleSlider.initialValue=SpellActivationOverlayDB.alert.scale
scaleSlider:SetValue(scaleSlider.initialValue)
scaleSlider.ApplyValueToEngine=function(self,value)
SpellActivationOverlayDB.alert.scale=value
SAO:ApplySpellAlertGeometry()
end
local offsetSlider=SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider.Text:SetText("Spell Alert Offset")
_G[offsetSlider:GetName().."Low"]:SetText(NEAR)
_G[offsetSlider:GetName().."High"]:SetText(FAR)
offsetSlider:SetMinMaxValues(-200,400)
offsetSlider:SetValueStep(20)
offsetSlider.initialValue=SpellActivationOverlayDB.alert.offset
offsetSlider:SetValue(offsetSlider.initialValue)
offsetSlider.ApplyValueToEngine=function(self,value)
SpellActivationOverlayDB.alert.offset=value
SAO:ApplySpellAlertGeometry()
end
local timerSlider=SpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider.Text:SetText("Spell Alert Progressive Timer")
_G[timerSlider:GetName().."Low"]:SetText(DISABLE)
_G[timerSlider:GetName().."High"]:SetText(ENABLE)
timerSlider:SetMinMaxValues(0,1)
timerSlider:SetValueStep(1)
timerSlider.initialValue=SpellActivationOverlayDB.alert.timer
timerSlider:SetValue(timerSlider.initialValue)
timerSlider.ApplyValueToEngine=function(self,value)
SpellActivationOverlayDB.alert.timer=value
SAO:ApplySpellAlertTimer()
end
local soundSlider=SpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider.Text:SetText("Spell Alert Sound Effect")
_G[soundSlider:GetName().."Low"]:SetText(DISABLE)
_G[soundSlider:GetName().."High"]:SetText(ENABLE)
soundSlider:SetMinMaxValues(0,1)
soundSlider:SetValueStep(1)
soundSlider.initialValue=SpellActivationOverlayDB.alert.sound
soundSlider:SetValue(soundSlider.initialValue)
soundSlider.ApplyValueToEngine=function(self,value)
SpellActivationOverlayDB.alert.sound=value
SAO:ApplySpellAlertSound()
end
local testButton=SpellActivationOverlayOptionsPanelSpellAlertTestButton
testButton:SetText("Toggle Test")
testButton.fakeSpellID=42
testButton.isTesting=false
local testTextureLeftRight=SAO.IsEra() and "echo_of_the_elements" or "imp_empowerment"
local testTextureTop=SAO.IsEra() and "fury_of_stormrage" or "brain_freeze"
local testPositionTop=SAO.IsCata() and "Top (CW)" or "Top"
testButton.StartTest=function(self)
if (not self.isTesting)then
self.isTesting=true
SAO:ActivateOverlay(0,self.fakeSpellID,SAO.TexName[testTextureLeftRight], "Left + Right (Flipped)",1,255,255,255,false,nil,GetTime()+5,false,{strata="DIALOG",level=9999})
SAO:ActivateOverlay(0,self.fakeSpellID,SAO.TexName[testTextureTop] ,testPositionTop ,1,255,255,255,false,nil,GetTime()+5,false,{strata="DIALOG",level=9999})
self.testTimerTicker=C_Timer.NewTicker(4.9,
function()
SAO:RefreshOverlayTimer(self.fakeSpellID,GetTime()+5)
end)
SpellActivationOverlayFrame_SetForceAlpha1(true)
end
end
testButton.StopTest=function(self)
if (self.isTesting)then
self.isTesting=false
self.testTimerTicker:Cancel()
SAO:DeactivateOverlay(self.fakeSpellID)
SpellActivationOverlayFrame_SetForceAlpha1(false)
end
end
testButton:SetEnabled(SpellActivationOverlayDB.alert.enabled)
SAO:MarkTexture(testTextureLeftRight)
SAO:MarkTexture(testTextureTop)
local debugButton=SpellActivationOverlayOptionsPanelSpellAlertDebugButton
debugButton.Text:SetText(SAO:optionDebugToChatbox())
debugButton:SetChecked(SpellActivationOverlayDB.debug==true)
local reportButton=SpellActivationOverlayOptionsPanelSpellAlertReportButton
if SAO:CanReport()then
reportButton.Text:SetText(SAO:reportUnsupportedOverlays())
reportButton:SetChecked(SpellActivationOverlayDB.report~=false)
else
reportButton:Hide()
end
local responsiveButton=SpellActivationOverlayOptionsPanelSpellAlertResponsiveButton
responsiveButton.Text:SetText(SAO:responsiveMode())
responsiveButton:SetChecked(SpellActivationOverlayDB.responsiveMode==true)
local askDisableGameAlertButton=SpellActivationOverlayOptionsPanelSpellAlertAskDisableGameAlertButton
if SAO:IsQuestionPossible(SAO.QUESTIONS.DISABLE_GAME_ALERT)then
askDisableGameAlertButton:Show()
askDisableGameAlertButton.Text:SetText(SAO:askToDisableGameAlerts())
askDisableGameAlertButton:SetChecked(not SpellActivationOverlayDB.questions or SpellActivationOverlayDB.questions.disableGameAlert~="no")
askDisableGameAlertButton.OnValueChanged=function(self,checked)
SpellActivationOverlayDB.questions=SpellActivationOverlayDB.questions or {}
if checked then
SpellActivationOverlayDB.questions.disableGameAlert=nil
SAO:AskQuestion(SAO.QUESTIONS.DISABLE_GAME_ALERT)
else
SpellActivationOverlayDB.questions.disableGameAlert="no"
SAO:CancelQuestion(SAO.QUESTIONS.DISABLE_GAME_ALERT)
end
end
else
askDisableGameAlertButton:Hide()
local anchorBuildInfo={SpellActivationOverlayOptionsPanelBuildInfo:GetPoint(1)}
SpellActivationOverlayOptionsPanelBuildInfo:SetPoint(anchorBuildInfo[1],anchorBuildInfo[2],anchorBuildInfo[3],anchorBuildInfo[4],anchorBuildInfo[5] - 24)
end
local glowingButtonCheckbox=SpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox.Text:SetText("Glowing Buttons")
glowingButtonCheckbox.initialValue=SpellActivationOverlayDB.glow.enabled
glowingButtonCheckbox:SetChecked(glowingButtonCheckbox.initialValue)
glowingButtonCheckbox.ApplyValueToEngine=function(self,checked)
SpellActivationOverlayDB.glow.enabled=checked
for _,checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {})do
checkbox:ApplyParentEnabling()
end
SAO:ApplyGlowingButtonsToggle()
end
local classOptions=SpellActivationOverlayDB.classes and SAO.CurrentClass and SpellActivationOverlayDB.classes[SAO.CurrentClass.Intrinsics[2]]
if (classOptions)then
SpellActivationOverlayOptionsPanel.classOptions={initialValue=CopyTable(classOptions)}
else
SpellActivationOverlayOptionsPanel.classOptions={initialValue={}}
end
SpellActivationOverlayOptionsPanel.additionalCheckboxes={}
end
local function okayFunc(self)
local opacitySlider=SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider.initialValue=opacitySlider:GetValue()
local scaleSlider=SpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider.initialValue=scaleSlider:GetValue()
local offsetSlider=SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider.initialValue=offsetSlider:GetValue()
local timerSlider=SpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider.initialValue=timerSlider:GetValue()
local soundSlider=SpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider.initialValue=soundSlider:GetValue()
local glowingButtonCheckbox=SpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox.initialValue=glowingButtonCheckbox:GetChecked()
local classOptions=SpellActivationOverlayDB.classes and SAO.CurrentClass and SpellActivationOverlayDB.classes[SAO.CurrentClass.Intrinsics[2]]
if (classOptions)then
SpellActivationOverlayOptionsPanel.classOptions.initialValue=CopyTable(classOptions)
end
end
local function cancelFunc(self)
local opacitySlider=SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
local scaleSlider=SpellActivationOverlayOptionsPanelSpellAlertScaleSlider
local offsetSlider=SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
local timerSlider=SpellActivationOverlayOptionsPanelSpellAlertTimerSlider
local soundSlider=SpellActivationOverlayOptionsPanelSpellAlertSoundSlider
local glowingButtonCheckbox=SpellActivationOverlayOptionsPanelGlowingButtons
local classOptions=SpellActivationOverlayOptionsPanel.classOptions
self:applyAll(
opacitySlider.initialValue,
scaleSlider.initialValue,
offsetSlider.initialValue,
timerSlider.initialValue,
soundSlider.initialValue,
glowingButtonCheckbox.initialValue,
classOptions.initialValue
)
end
local function defaultFunc(self)
local defaultClassOptions=SAO.defaults.classes and SAO.CurrentClass and SAO.defaults.classes[SAO.CurrentClass.Intrinsics[2]]
self:applyAll(
1,
1,
0,
1,
SAO.IsCata() and 1 or 0,
true,
defaultClassOptions
)
end
local function applyAllFunc(self,opacityValue,scaleValue,offsetValue,timerValue,soundValue,isGlowEnabled,classOptions)
local opacitySlider=SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider:SetValue(opacityValue)
if (SpellActivationOverlayDB.alert.opacity~=opacityValue)then
SpellActivationOverlayDB.alert.opacity=opacityValue
SpellActivationOverlayDB.alert.enabled=opacityValue > 0
SAO:ApplySpellAlertOpacity()
end
local geometryChanged=false
local scaleSlider=SpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider:SetValue(scaleValue)
if (SpellActivationOverlayDB.alert.scale~=scaleValue)then
SpellActivationOverlayDB.alert.scale=scaleValue
geometryChanged=true
end
local offsetSlider=SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider:SetValue(offsetValue)
if (SpellActivationOverlayDB.alert.offset~=offsetValue)then
SpellActivationOverlayDB.alert.offset=offsetValue
geometryChanged=true
end
if (geometryChanged)then
SAO:ApplySpellAlertGeometry()
end
local timerSlider=SpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider:SetValue(timerValue)
if (SpellActivationOverlayDB.alert.timer~=timerValue)then
SpellActivationOverlayDB.alert.timer=timerValue
SAO:ApplySpellAlertTimer()
end
local soundSlider=SpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider:SetValue(soundValue)
if (SpellActivationOverlayDB.alert.sound~=soundValue)then
SpellActivationOverlayDB.alert.sound=soundValue
SAO:ApplySpellAlertSound()
end
local testButton=SpellActivationOverlayOptionsPanelSpellAlertTestButton
testButton:SetEnabled(SpellActivationOverlayDB.alert.enabled)
local glowingButtonCheckbox=SpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox:SetChecked(isGlowEnabled)
if (SpellActivationOverlayDB.glow.enabled~=isGlowEnabled)then
SpellActivationOverlayDB.glow.enabled=isGlowEnabled
glowingButtonCheckbox:ApplyValueToEngine(isGlowEnabled)
end
if (SpellActivationOverlayDB.classes and SAO.CurrentClass and SpellActivationOverlayDB.classes[SAO.CurrentClass.Intrinsics[2]] and classOptions)then
SpellActivationOverlayDB.classes[SAO.CurrentClass.Intrinsics[2]]=CopyTable(classOptions)
for _,checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.alert or {})do
checkbox:ApplyValue()
end
for _,checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {})do
checkbox:ApplyValue()
end
end
end
local InterfaceOptions_AddCategory=InterfaceOptions_AddCategory
local InterfaceOptionsFrame_OpenToCategory=InterfaceOptionsFrame_OpenToCategory
if Settings and Settings.RegisterCanvasLayoutCategory then
InterfaceOptions_AddCategory=function(frame,addOn,position)
frame.OnCommit=frame.okay
frame.OnDefault=frame.default
frame.OnRefresh=frame.refresh
if frame.parent then
local category=Settings.GetCategory(frame.parent)
local subcategory,layout=Settings.RegisterCanvasLayoutSubcategory(category,frame,frame.name,frame.name)
subcategory.ID=frame.name
return subcategory,category
else
local category,layout=Settings.RegisterCanvasLayoutCategory(frame,frame.name,frame.name)
category.ID=frame.name
Settings.RegisterAddOnCategory(category)
return category
end
end
InterfaceOptionsFrame_OpenToCategory=function(categoryIDOrFrame)
if type(categoryIDOrFrame)=="table" then
local categoryID=categoryIDOrFrame.name
return Settings.OpenToCategory(categoryID)
else
return Settings.OpenToCategory(categoryIDOrFrame)
end
end
end
function SpellActivationOverlayOptionsPanel_OnLoad(self)
self.name=AddonName
self.okay=okayFunc
self.cancel=cancelFunc
self.default=defaultFunc
self.refresh=SpellActivationOverlayOptionsPanel_Init
self.applyAll=applyAllFunc
InterfaceOptions_AddCategory(self)
SAO.OptionsPanel=self
end
local optionsLoaded=false
function SpellActivationOverlayOptionsPanel_OnShow(self)
if optionsLoaded then
return
end
for _,classDef in ipairs({SAO.CurrentClass,SAO.SharedClass})do
if classDef and type(classDef.LoadOptions)=='function' then
classDef.LoadOptions(SAO)
end
end
SAO:AddEffectOptions()
for _,optionType in ipairs({"alert", "glow"})do
if (type(SpellActivationOverlayOptionsPanel.additionalCheckboxes[optionType])=="nil")then
local className=SAO.CurrentClass and SAO.CurrentClass.Intrinsics[1] or select(1,UnitClass("player"))
local classFile=SAO.CurrentClass and SAO.CurrentClass.Intrinsics[2] or select(2,UnitClass("player"))
local dimFactor=0.7
local dimmedTextColor=CreateColor(dimFactor,dimFactor,dimFactor)
local dimmedClassColor=CreateColor(dimFactor*RAID_CLASS_COLORS[classFile].r,dimFactor*RAID_CLASS_COLORS[classFile].g,dimFactor*RAID_CLASS_COLORS[classFile].b)
local text=WrapTextInColor(string.format("%s (%s)",NONE,WrapTextInColor(className,dimmedClassColor)),dimmedTextColor)
SpellActivationOverlayOptionsPanel[optionType.."None"]:SetText(text)
end
end
optionsLoaded=true
end
if not iamNecrosis then
SLASH_SAO1="/sao"
SLASH_SAO2="/spellactivationoverlay"
SlashCmdList.SAO=function(msg,editBox)
InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel)
InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel)
end
end
