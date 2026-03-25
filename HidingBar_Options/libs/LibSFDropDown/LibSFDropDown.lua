--@curseforge-project-slug: libsfdropdown@
-----------------------------------------------------------
-- LibSFDropDown - DropDown menu for non-Blizzard addons --
-----------------------------------------------------------
local MAJOR_VERSION, MINOR_VERSION = "LibSFDropDown-1.4", 8
local lib, oldminor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end
oldminor = oldminor or 0


local math, next, ipairs, rawget, type, wipe = math, next, ipairs, rawget, type, wipe
local CreateFrame, GetBindingKey, PlaySound, SOUNDKIT, GameTooltip, GetScreenWidth, UIParent, GetCursorPosition, InCombatLockdown = CreateFrame, GetBindingKey, PlaySound, SOUNDKIT, GameTooltip, GetScreenWidth, UIParent, GetCursorPosition, InCombatLockdown
local HybridScrollFrame_GetOffset, HybridScrollFrame_Update, HybridScrollFrame_OnValueChanged, HybridScrollFrameScrollButton_OnClick, HybridScrollFrameScrollUp_OnLoad, HybridScrollFrameScrollDown_OnLoad, SearchBoxTemplate_OnTextChanged, ScrollFrame_OnVerticalScroll, UIPanelScrollBar_OnValueChanged, UIPanelScrollBarScrollUpButton_OnClick, UIPanelScrollBarScrollDownButton_OnClick = HybridScrollFrame_GetOffset, HybridScrollFrame_Update, HybridScrollFrame_OnValueChanged, HybridScrollFrameScrollButton_OnClick, HybridScrollFrameScrollUp_OnLoad, HybridScrollFrameScrollDown_OnLoad, SearchBoxTemplate_OnTextChanged, ScrollFrame_OnVerticalScroll, UIPanelScrollBar_OnValueChanged, UIPanelScrollBarScrollUpButton_OnClick, UIPanelScrollBarScrollDownButton_OnClick


if oldminor < 1 then
	lib._v = {
		-- DROPDOWNBUTTON = nil,
		defaultStyle = "backdrop",
		menuStyle = "menuBackdrop",
		menuStyles = {},
		colorSwatchFrames = {},
		dropDownSearchFrames = {},
		dropDownMenusList = {},
		dropDownCreatedButtons = {},
		dropDownCreatedStretchButtons = {},
	}
	lib._m = {
		__metatable = "access denied",
		__index = {},
	}
	setmetatable(lib, lib._m)
end


--[[
List of button attributes
====================================================================================================
info.text = [string, function(self)] -- The text of the button or function that returns the text
info.value = [anything] -- The value that is set to button.value
info.func = [function(self, arg1, arg2, checked)] -- The function that is called when you click the button
info.checked = [nil, true, function(self)] -- Check the button if true or function returns true
info.isNotRadio = [nil, true] -- Check the button uses radial image if false check box image if true
info.notCheckable = [nil, true] -- Shrink the size of the buttons and don't display a check box
info.isTitle = [nil, true] -- If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, true, function(self)] -- Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, true] -- Show the expand arrow for multilevel menus
info.keepShownOnClick = [nil, true] -- Don't hide the dropdownlist after a button is clicked
info.arg1 = [anything] -- This is the first argument used by info.func
info.arg2 = [anything] -- This is the second argument used by info.func
info.icon = [texture] -- An icon for the button
info.iconOnly = [nil, true] -- Streaches the texture to the width of the button
info.iconInfo = [table] -- A table that looks like {
	tCoordLeft = [0.0 - 1.0], -- left for SetTexCoord func
	tCoordRight = [0.0 - 1.0], -- right for SetTexCoord func
	tCoordTop = [0.0 - 1.0], -- top for SetTexCoord func
	tCoordBottom = [0.0 - 1.0], -- bottom for SetTexCoord func
	tSizeX = [number], -- texture width
	tSizeY = [number], -- texture height
	tWrap = [nil, string] -- horizontal wrapping type from SetTexture function
}
info.indent = [number] -- Number of pixels to pad the button on the left side
info.remove = [function(self)] -- The function that is called when you click the remove button
info.order = [function(self, delta)] -- The function that is called when you click the up or down arrow button
info.hasColorSwatch = [nil, true] -- Show color swatch or not, for color selection
info.r = [0.0 - 1.0] -- Red color value of the color swatch
info.g = [0.0 - 1.0] -- Green color value of the color swatch
info.b = [0.0 - 1.0] -- Blue color value of the color swatch
info.swatchFunc = [function] -- Function called by the color picker on color change
info.hasOpacity = [nil, ture] -- Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0] -- Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function] -- Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.justifyH = [nil, "CENTER", "RIGHT"] -- Justify button text
info.fontObject = [font] -- The font object replacement for Normal and Highlight
info.OnEnter = [function(self, arg1, arg2)] -- Handler OnEnter
info.OnLeave = [function(self, arg1, arg2)] -- Handler OnLeave
info.tooltipWhileDisabled = [nil, true] -- Show the tooltip, even when the button is disabled
info.OnTooltipShow = [function(self, tooltipFrame, arg1, arg2)] -- Handler tooltip show
info.customFrame = [frame] -- Allows this button to be a completely custom frame
info.fixedWidth = [nil, true] -- If nil then custom frame is stretched
info.OnLoad = [function(customFrame)] -- Function called when the custom frame is attached
info.hideSearch = [nil, true] -- Remove SearchBox if info.list displays as scroll menu
info.list = [table] -- The table of info buttons, if there are more than 20 buttons, a scroll frame is added. Available attributes in table "dropDonwOptions".
]]
local dropDownOptions = {
	"text",
	"value",
	"func",
	"checked",
	"isNotRadio",
	"notCheckable",
	"isTitle",
	"disabled",
	"hasArrow",
	"keepShownOnClick",
	"arg1",
	"arg2",
	"icon",
	"iconOnly",
	"iconInfo",
	"indent",
	"remove",
	"order",
	"hasColorSwatch",
	"r",
	"g",
	"b",
	"swatchFunc",
	"hasOpacity",
	"opacity",
	"opacityFunc",
	"cancelFunc",
	"justifyH",
	"fontObject",
	"OnEnter",
	"OnLeave",
	"tooltipWhileDisabled",
	"OnTooltipShow",
}
local DropDownMenuButtonHeight = 16
local DropDownMenuSearchHeight = DropDownMenuButtonHeight * 20 + 26
local v = lib._v
local menuStyles = v.menuStyles


menuStyles.backdrop = function(parent)
	return CreateFrame("FRAME", nil, parent, "DialogBorderDarkTemplate")
end
menuStyles.menuBackdrop = function(parent)
	return CreateFrame("FRAME", nil, parent, "TooltipBackdropTemplate")
end


local function CreateMenuStyle(menu, name, frameFunc)
	local f = frameFunc(menu)
	f:SetFrameLevel(menu:GetFrameLevel())
	if not f:GetPoint() then
		f:SetAllPoints()
	end
	menu.styles[name] = f
end


local function DropDownMenuList_OnHide(self)
	self:Hide()
	if self.customFrames then
		for i = 1, #self.customFrames do
			self.customFrames[i]:Hide()
		end
		self.customFrames = nil
	end
end


local function DropDownMenuListScrollFrame_OnScrollRangeChanged(self, xrange, yrange)
	local scrollBar = self.ScrollBar
	yrange = math.floor(yrange or self:GetVerticalScrollRange())
	scrollBar:SetMinMaxValues(0, yrange)
	scrollBar:SetValue(math.min(scrollBar:GetValue(), yrange))
end


local function DropDownMenuListScrollFrame_OnMouseWheel(self, delta)
	local scrollBar = self.ScrollBar
	if not scrollBar:IsShown() then return end
	scrollBar:SetValue(scrollBar:GetValue() - scrollBar:GetHeight() / 2 * delta)
end


local function DropDownMenuListScrollBar_OnMouseWheel(self, delta)
	self:SetValue(self:GetValue() - self:GetHeight() / 2 * delta)
end


local function DropDownMenuListScrollBar_OnEnter(self)
	v.DROPDOWNBUTTON:ddCloseMenus(self.scrollChild.id + 1)
end


local function DropDownMenuListScrollBarControl_OnEnter(self)
	v.DROPDOWNBUTTON:ddCloseMenus(self:GetParent().scrollChild.id + 1)
end


local function CreateDropDownMenuList(parent)
	local menu = CreateFrame("FRAME", nil, parent)
	menu:Hide()
	menu:EnableMouse(true)
	menu:SetClampedToScreen(true)
	menu:SetFrameStrata("FULLSCREEN_DIALOG")
	menu:SetScript("OnHide", DropDownMenuList_OnHide)

	menu.scrollFrame = CreateFrame("ScrollFrame", nil, menu)
	menu.scrollFrame:SetPoint("TOPLEFT", 15, -15)
	menu.scrollFrame:SetScript("OnScrollRangeChanged", DropDownMenuListScrollFrame_OnScrollRangeChanged)
	menu.scrollFrame:SetScript("OnVerticalScroll", ScrollFrame_OnVerticalScroll)
	menu.scrollFrame:SetScript("OnMouseWheel", DropDownMenuListScrollFrame_OnMouseWheel)

	menu.scrollFrame.ScrollBar = CreateFrame("SLIDER", nil, menu.scrollFrame)
	local scrollBar = menu.scrollFrame.ScrollBar
	scrollBar:SetSize(20, 0)
	scrollBar:SetPoint("TOPLEFT", menu.scrollFrame, "TOPRIGHT", 0, -14)
	scrollBar:SetPoint("BOTTOMLEFT", menu.scrollFrame, "BOTTOMRIGHT", 0, 14)
	scrollBar:SetScript("OnValueChanged", UIPanelScrollBar_OnValueChanged)
	scrollBar:SetScript("OnMouseWheel", DropDownMenuListScrollBar_OnMouseWheel)
	scrollBar:SetScript("OnEnter", DropDownMenuListScrollBar_OnEnter)

	scrollBar:SetThumbTexture("Interface/Buttons/UI-ScrollBar-Knob")
	scrollBar.ThumbTexture = scrollBar:GetThumbTexture()
	scrollBar.ThumbTexture:SetBlendMode("ADD")
	scrollBar.ThumbTexture:SetSize(21, 24)
	scrollBar.ThumbTexture:SetTexCoord(.125, .825, .125, .825)

	scrollBar.trackBG = scrollBar:CreateTexture(nil, "BACKGROUND")
	scrollBar.trackBG:SetPoint("TOPLEFT", 1, 0)
	scrollBar.trackBG:SetPoint("BOTTOMRIGHT")
	scrollBar.trackBG:SetColorTexture(0, 0, 0, .15)

	scrollBar.ScrollUpButton = CreateFrame("BUTTON", nil, scrollBar)
	scrollBar.ScrollUpButton:SetSize(18, 16)
	scrollBar.ScrollUpButton:SetPoint("BOTTOM", scrollBar, "TOP", 1, -2)
	scrollBar.ScrollUpButton:SetNormalAtlas("UI-ScrollBar-ScrollUpButton-Up")
	scrollBar.ScrollUpButton:SetPushedAtlas("UI-ScrollBar-ScrollUpButton-Down")
	scrollBar.ScrollUpButton:SetDisabledAtlas("UI-ScrollBar-ScrollUpButton-Disabled")
	scrollBar.ScrollUpButton:SetHighlightAtlas("UI-ScrollBar-ScrollUpButton-Highlight")
	scrollBar.ScrollUpButton:SetScript("OnClick", UIPanelScrollBarScrollUpButton_OnClick)
	scrollBar.ScrollUpButton:SetScript("OnEnter", DropDownMenuListScrollBarControl_OnEnter)
	scrollBar.ScrollUpButton:Disable()

	scrollBar.ScrollDownButton = CreateFrame("BUTTON", nil, scrollBar)
	scrollBar.ScrollDownButton:SetSize(18, 16)
	scrollBar.ScrollDownButton:SetPoint("TOP", scrollBar, "BOTTOM", 1, 1)
	scrollBar.ScrollDownButton:SetNormalAtlas("UI-ScrollBar-ScrollDownButton-Up")
	scrollBar.ScrollDownButton:SetPushedAtlas("UI-ScrollBar-ScrollDownButton-Down")
	scrollBar.ScrollDownButton:SetDisabledAtlas("UI-ScrollBar-ScrollDownButton-Disabled")
	scrollBar.ScrollDownButton:SetHighlightAtlas("UI-ScrollBar-ScrollDownButton-Highlight")
	scrollBar.ScrollDownButton:SetScript("OnClick", UIPanelScrollBarScrollDownButton_OnClick)
	scrollBar.ScrollDownButton:SetScript("OnEnter", DropDownMenuListScrollBarControl_OnEnter)

	menu.scrollChild = CreateFrame("FRAME")
	menu.scrollChild:SetSize(1, 1)
	menu.scrollFrame:SetScrollChild(menu.scrollChild)
	scrollBar.scrollChild = menu.scrollChild

	menu.styles = {}
	for name, frameFunc in next, menuStyles do
		CreateMenuStyle(menu, name, frameFunc)
	end

	return menu
end


---------------------------------------------------
-- DROPDOWN MENU BUTTON
---------------------------------------------------
local function DropDownMenuButton_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

	if not self.notCheckable then
		self._checked = not self._checked
		if self.keepShownOnClick then
			self.Check:SetShown(self._checked)
			self.UnCheck:SetShown(not self._checked)
		end
	end

	if type(self.func) == "function" then
		self:func(self.arg1, self.arg2, self._checked)
	end

	if not self.keepShownOnClick then
		v.DROPDOWNBUTTON:ddCloseMenus()
	end
end


local function DropDownMenuButton_OnEnter(self)
	self.isEnter = true
	if self:IsEnabled() then self.highlight:Show() end

	local level = self:GetParent().id + 1
	if self.hasArrow and self:IsEnabled() then
		v.DROPDOWNBUTTON:ddToggle(level, self.value, self)
	else
		v.DROPDOWNBUTTON:ddCloseMenus(level)
	end

	if self.remove then
		self.removeButton:SetAlpha(1)
	end
	if self.order then
		self.arrowDownButton:SetAlpha(1)
		self.arrowUpButton:SetAlpha(1)
	end

	if self.OnTooltipShow and (self:IsEnabled() or self.tooltipWhileDisabled) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		self:OnTooltipShow(GameTooltip, self.arg1, self.arg2)
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end

	if self.OnEnter then
		self:OnEnter(self.arg1, self.arg2)
	end
end


local function DropDownMenuButton_OnLeave(self)
	self.isEnter = nil
	self.highlight:Hide()
	self.removeButton:SetAlpha(0)
	self.arrowDownButton:SetAlpha(0)
	self.arrowUpButton:SetAlpha(0)

	if self.OnTooltipShow and (self:IsEnabled() or self.tooltipWhileDisabled) then
		GameTooltip:Hide()
	end

	if self.OnLeave then
		self:OnLeave(self.arg1, self.arg2)
	end
end


local function DropDownMenuButton_OnDisable(self)
	self.Check:SetDesaturated(true)
	self.Check:SetAlpha(.5)
	self.UnCheck:SetDesaturated(true)
	self.UnCheck:SetAlpha(.5)
	self.ExpandArrow:SetDesaturated(true)
	self.ExpandArrow:SetAlpha(.5)
end


local function DropDownMenuButton_OnEnable(self)
	self.Check:SetDesaturated()
	self.Check:SetAlpha(1)
	self.UnCheck:SetDesaturated()
	self.UnCheck:SetAlpha(1)
	self.ExpandArrow:SetDesaturated()
	self.ExpandArrow:SetAlpha(1)
end


local function DropDownMenuButton_OnHide(self)
	self:Hide()
	self.colorSwatch = nil
end


local function ControlButton_OnEnter(self)
	self.icon:SetVertexColor(1, 1, 1)
	local parent = self:GetParent()
	parent:GetScript("OnEnter")(parent)
end


local function ControlButton_OnLeave(self)
	self.icon:SetVertexColor(.7, .7, .7)
	local parent = self:GetParent()
	parent:GetScript("OnLeave")(parent)
end


local function ControlButton_OnMouseDown(self)
	self.icon:SetScale(.9)
end


local function ControlButton_OnMouseUp(self)
	self.icon:SetScale(1)
end


local function RemoveButton_OnClick(self)
	local parent = self:GetParent()
	parent:remove(parent.arg1, parent.arg2)
	v.DROPDOWNBUTTON:ddCloseMenus()
end


local function ArrowDownButton_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local parent = self:GetParent()
	parent:order(1)
	v.DROPDOWNBUTTON:ddRefresh(parent:GetParent().id, v.DROPDOWNBUTTON.anchorFrame)
end


local function ArrowUpButton_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local parent = self:GetParent()
	parent:order(-1)
	v.DROPDOWNBUTTON:ddRefresh(parent:GetParent().id, v.DROPDOWNBUTTON.anchorFrame)
end


local function CreateDropDownMenuButton(parent)
	local btn = CreateFrame("BUTTON", nil, parent)
	btn:SetMotionScriptsWhileDisabled(true)
	btn:SetHeight(DropDownMenuButtonHeight)
	btn:SetNormalFontObject(GameFontHighlightSmallLeft)
	btn:SetHighlightFontObject(GameFontHighlightSmallLeft)
	btn:SetDisabledFontObject(GameFontDisableSmallLeft)
	btn:SetScript("OnClick", DropDownMenuButton_OnClick)
	btn:SetScript("OnEnter", DropDownMenuButton_OnEnter)
	btn:SetScript("OnLeave", DropDownMenuButton_OnLeave)
	btn:SetScript("OnDisable", DropDownMenuButton_OnDisable)
	btn:SetScript("OnEnable", DropDownMenuButton_OnEnable)
	btn:SetScript("OnHide", DropDownMenuButton_OnHide)

	btn.highlight = btn:CreateTexture(nil, "BACKGROUND")
	btn.highlight:SetTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
	btn.highlight:Hide()
	btn.highlight:SetBlendMode("ADD")
	btn.highlight:SetAllPoints()

	btn.Check = btn:CreateTexture(nil, "ARTWORK")
	btn.Check:SetTexture("Interface/Common/UI-DropDownRadioChecks")
	btn.Check:SetSize(16, 16)
	btn.Check:SetPoint("LEFT")
	btn.Check:SetTexCoord(0, .5, .5, 1)

	btn.UnCheck = btn:CreateTexture(nil, "ARTWORK")
	btn.UnCheck:SetTexture("Interface/Common/UI-DropDownRadioChecks")
	btn.UnCheck:SetSize(16, 16)
	btn.UnCheck:SetPoint("LEFT")
	btn.UnCheck:SetTexCoord(.5, 1, .5, 1)

	btn.Icon = btn:CreateTexture(nil, "ARTWORK")
	btn.Icon:Hide()
	btn.Icon:SetSize(16, 16)

	btn.ExpandArrow = btn:CreateTexture(nil, "ARTWORK")
	btn.ExpandArrow:SetTexture("Interface/ChatFrame/ChatFrameExpandArrow")
	btn.ExpandArrow:Hide()
	btn.ExpandArrow:SetSize(16, 16)
	btn.ExpandArrow:SetPoint("RIGHT", 4, 0)

	btn:SetText(" ")
	btn.NormalText = btn:GetFontString()

	btn.removeButton = CreateFrame("BUTTON", nil, btn)
	btn.removeButton:SetAlpha(0)
	btn.removeButton:SetSize(16, 16)
	btn.removeButton:SetScript("OnEnter", ControlButton_OnEnter)
	btn.removeButton:SetScript("OnLeave", ControlButton_OnLeave)
	btn.removeButton:SetScript("OnMouseDown", ControlButton_OnMouseDown)
	btn.removeButton:SetScript("OnMouseUp", ControlButton_OnMouseUp)
	btn.removeButton:SetScript("OnClick", RemoveButton_OnClick)

	btn.removeButton.icon = btn.removeButton:CreateTexture(nil, "BACKGROUND")
	btn.removeButton.icon:SetTexture("Interface/BUTTONS/UI-GroupLoot-Pass-Up")
	btn.removeButton.icon:SetSize(16, 16)
	btn.removeButton.icon:SetPoint("CENTER")
	btn.removeButton.icon:SetVertexColor(.7, .7, .7)

	btn.arrowDownButton = CreateFrame("BUTTON", nil, btn)
	btn.arrowDownButton:SetAlpha(0)
	btn.arrowDownButton:SetSize(12, 16)
	btn.arrowDownButton:SetScript("OnEnter", ControlButton_OnEnter)
	btn.arrowDownButton:SetScript("OnLeave", ControlButton_OnLeave)
	btn.arrowDownButton:SetScript("OnMouseDown", ControlButton_OnMouseDown)
	btn.arrowDownButton:SetScript("OnMouseUp", ControlButton_OnMouseUp)
	btn.arrowDownButton:SetScript("OnClick", ArrowDownButton_OnClick)

	btn.arrowDownButton.icon = btn.arrowDownButton:CreateTexture(nil, "BACKGROUND")
	btn.arrowDownButton.icon:SetTexture("Interface/BUTTONS/UI-MicroStream-Yellow")
	btn.arrowDownButton.icon:SetSize(8, 14)
	btn.arrowDownButton.icon:SetPoint("CENTER")
	btn.arrowDownButton.icon:SetTexCoord(.25, .75, 0, .875)
	btn.arrowDownButton.icon:SetVertexColor(.7, .7, .7)

	btn.arrowUpButton = CreateFrame("BUTTON", nil, btn)
	btn.arrowUpButton:SetAlpha(0)
	btn.arrowUpButton:SetSize(12, 16)
	btn.arrowUpButton:SetPoint("RIGHT", btn.arrowDownButton, "LEFT")
	btn.arrowUpButton:SetScript("OnEnter", ControlButton_OnEnter)
	btn.arrowUpButton:SetScript("OnLeave", ControlButton_OnLeave)
	btn.arrowUpButton:SetScript("OnMouseDown", ControlButton_OnMouseDown)
	btn.arrowUpButton:SetScript("OnMouseUp", ControlButton_OnMouseUp)
	btn.arrowUpButton:SetScript("OnClick", ArrowUpButton_OnClick)

	btn.arrowUpButton.icon = btn.arrowUpButton:CreateTexture(nil, "BACKGROUND")
	btn.arrowUpButton.icon:SetTexture("Interface/BUTTONS/UI-MicroStream-Yellow")
	btn.arrowUpButton.icon:SetSize(8, 14)
	btn.arrowUpButton.icon:SetPoint("CENTER")
	btn.arrowUpButton.icon:SetTexCoord(.25, .75, .875, 0)
	btn.arrowUpButton.icon:SetVertexColor(.7, .7, .7)

	return btn
end


---------------------------------------------------
-- DROPDOWN COLOR SWATCH
---------------------------------------------------
local function OnHide(self)
	self:Hide()
end


local function ColorSwatch_OnClick(self)
	v.DROPDOWNBUTTON:ddCloseMenus()
	OpenColorPicker(self:GetParent())
end


local function ColorSwatch_OnEnter(self)
	self.swatchBg:SetVertexColor(NORMAL_FONT_COLOR:GetRGB())
	local parent = self:GetParent()
	parent:GetScript("OnEnter")(parent)
end


local function ColorSwatch_OnLeave(self)
	self.swatchBg:SetVertexColor(HIGHLIGHT_FONT_COLOR:GetRGB())
	local parent = self:GetParent()
	parent:GetScript("OnLeave")(parent)
end


local function CreateColorSwatchFrame()
	local f = CreateFrame("BUTTON")
	f:Hide()
	f:SetSize(16, 16)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnClick", ColorSwatch_OnClick)
	f:SetScript("OnEnter", ColorSwatch_OnEnter)
	f:SetScript("OnLeave", ColorSwatch_OnLeave)

	f.swatchBg = f:CreateTexture(nil, "BACKGROUND", nil, -3)
	f.swatchBg:SetSize(14, 14)
	f.swatchBg:SetPoint("CENTER")
	f.swatchBg:SetColorTexture(HIGHLIGHT_FONT_COLOR:GetRGB())

	f.innerBorder = f:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.innerBorder:SetSize(12, 12)
	f.innerBorder:SetPoint("CENTER")
	f.innerBorder:SetColorTexture(BLACK_FONT_COLOR:GetRGB())

	f.color = f:CreateTexture(nil, "BACKGROUND", nil, -1)
	f.color:SetSize(10, 10)
	f.color:SetPoint("CENTER")
	f.color:SetColorTexture(HIGHLIGHT_FONT_COLOR:GetRGB())

	return f
end


local colorSwatchFrames = v.colorSwatchFrames
local function GetColorSwatchFrame()
	for i = 1, #colorSwatchFrames do
		local frame = colorSwatchFrames[i]
		if not frame:IsShown() then return frame end
	end
	local frame = CreateColorSwatchFrame()
	colorSwatchFrames[#colorSwatchFrames + 1] = frame
	return frame
end


---------------------------------------------------
-- DROPDOWN MENU SEARCH
---------------------------------------------------
local function DropDownMenuSearch_OnShow(self)
	self.searchBox:SetText("")
	self:updateFilters()
	local totalHeight = (self.index + 1) * self.listScroll.buttonHeight
	self.listScroll.scrollBar:SetValue(totalHeight - self.listScroll:GetHeight())
end


local function DropDownMenuSearchBox_OnTextChanged(self, userInput)
	SearchBoxTemplate_OnTextChanged(self)
	if userInput then
		self:GetParent():updateFilters()
	end
end


local function DropDownMenuSearchBox_OnEnter(self)
	v.DROPDOWNBUTTON:ddCloseMenus(self:GetParent().listScroll.scrollChild.id + 1)
end


local function DropDownMenuSearchBoxClear_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local searchBox = self:GetParent()
	searchBox:SetText("")
	searchBox:ClearFocus()
	searchBox:GetParent():updateFilters()
end


local function DropDownMenuSearchScrollBar_OnMouseWheel(self, delta)
	self:SetValue(self:GetValue() - self.buttonHeight * delta)
end


local function DropDownMenuSearchScrollBar_OnEnter(self)
	v.DROPDOWNBUTTON:ddCloseMenus(self.scrollChild.id + 1)
end


local function DropDownMenuSearchScrollBarControl_OnEnter(self)
	v.DROPDOWNBUTTON:ddCloseMenus(self:GetParent().scrollChild.id + 1)
end


local function DropDownMenuSearch_Update(self)
	self:GetParent():refresh()
end


local function DropDownScrollFrame_CreateButtons(self)
	local scrollChild = self.scrollChild
	local btn = CreateDropDownMenuButton(scrollChild)
	btn:SetPoint("TOPLEFT")
	self.buttons = {btn}
	self.buttonHeight = btn:GetHeight()
	local numButtons = math.ceil(self:GetHeight() / self.buttonHeight) + 1

	for i = 2, numButtons do
		btn = CreateDropDownMenuButton(scrollChild)
		btn:SetPoint("TOPLEFT", self.buttons[i - 1], "BOTTOMLEFT")
		self.buttons[#self.buttons + 1] = btn
	end

	local childHeight = numButtons * self.buttonHeight
	scrollChild:SetWidth(self:GetWidth())
	scrollChild:SetHeight(childHeight)
	self:SetVerticalScroll(0)
	self:UpdateScrollChildRect()

	local scrollBar = self.scrollBar
	scrollBar:SetMinMaxValues(0, childHeight)
	scrollBar.buttonHeight = self.buttonHeight
	scrollBar:SetValueStep(self.buttonHeight)
	scrollBar:SetStepsPerPage(numButtons - 2)
	scrollBar:SetValue(0)
end


local DropDownMenuSearchMixin = {}


function DropDownMenuSearchMixin:reset()
	self.index = 1
	self.width = 0
	wipe(self.buttons)
	return self
end


function DropDownMenuSearchMixin:getEntryWidth()
	return self.width
end


do
	local deleteStr, len = {
		{"|?|c%x%x%x%x%x%x%x%x", 10},
		{"|?|r", 2},
	}
	local function compareFunc(s)
		return #s == len and "" or s
	end
	local function find(text, str)
		for i = 1, #deleteStr do
			local ds = deleteStr[i]
			len = ds[2]
			text = text:gsub(ds[1], compareFunc)
		end
		return text:lower():find(str, 1, true)
	end


	function DropDownMenuSearchMixin:updateFilters()
		local text = self.searchBox:GetText():trim():lower()

		wipe(self.filtredButtons)
		for i = 1, #self.buttons do
			local btn = self.buttons[i]
			if #text == 0 or btn.text == nil or find(type(btn.text) == "function" and btn:text() or btn.text, text) then
				self.filtredButtons[#self.filtredButtons + 1] = btn
			end
		end

		self:refresh()
	end
end


function DropDownMenuSearchMixin:refresh()
	local scrollFrame = self.listScroll
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local numButtons = #self.filtredButtons

	for i = 1, #scrollFrame.buttons do
		local btn = scrollFrame.buttons[i]
		local index = i + offset

		if index <= numButtons then
			local info = self.filtredButtons[index]
			for i = 1, #dropDownOptions do
				local opt = dropDownOptions[i]
				btn[opt] = info[opt]
			end

			btn._text = btn.text
			if btn._text then
				if type(btn._text) == "function" then btn._text = btn:_text() end
				btn:SetText(btn._text)
				btn:SetDisabledFontObject(btn.isTitle and GameFontNormalSmallLeft or GameFontDisableSmallLeft)
				btn:SetNormalFontObject(btn.fontObject or GameFontHighlightSmallLeft)
				btn:SetHighlightFontObject(btn.fontObject or GameFontHighlightSmallLeft)
			else
				btn:SetText("")
			end

			local disabled = btn.disabled
			if type(disabled) == "function" then disabled = disabled(btn) end
			if disabled or btn.isTitle then
				btn:Disable()
			else
				btn:Enable()
			end

			local textPos = -5
			if btn.hasArrow then
				textPos = -12
			end
			btn.ExpandArrow:SetShown(btn.hasArrow)

			if btn.remove then
				btn.removeButton:SetPoint("RIGHT", textPos, 0)
				textPos = textPos - 17
				btn.removeButton:Show()
			else
				btn.removeButton:Hide()
			end

			if btn.order then
				btn.arrowDownButton:SetPoint("RIGHT", textPos, 0)
				textPos = textPos - 25
				btn.arrowDownButton:Show()
				btn.arrowUpButton:Show()
			else
				btn.arrowDownButton:Hide()
				btn.arrowUpButton:Hide()
			end

			if btn.hasColorSwatch then
				if not btn.colorSwatch then
					btn.colorSwatch = GetColorSwatchFrame()
					btn.colorSwatch:SetParent(btn)
				end
				btn.colorSwatch:SetPoint("RIGHT", textPos, 0)
				textPos = textPos - 17
				btn.colorSwatch.color:SetVertexColor(btn.r, btn.g, btn.b)
				btn.colorSwatch:Show()
				if not btn.func then
					btn.func = function() btn.colorSwatch:Click() end
				end
			elseif btn.colorSwatch then
				btn.colorSwatch:Hide()
				btn.colorSwatch = nil
			end

			if btn.icon then
				local iconWrap
				if btn.iconInfo then
					local iInfo = btn.iconInfo
					btn.Icon:SetSize(btn.iconInfo.tSizeX or DropDownMenuButtonHeight, btn.iconInfo.tSizeY or DropDownMenuButtonHeight)
					btn.Icon:SetTexCoord(iInfo.tCoordLeft or 0, iInfo.tCoordRight or 1, iInfo.tCoordTop or 0, iInfo.tCoordBottom or 1)
					btn.Icon:SetHorizTile(iInfo.tWrap and true or false)
					iconWrap = iInfo.tWrap
				else
					btn.Icon:SetSize(DropDownMenuButtonHeight, DropDownMenuButtonHeight)
					btn.Icon:SetTexCoord(0, 1, 0, 1)
				end
				btn.Icon:SetTexture(btn.icon, iconWrap)

				if btn.iconOnly then
					btn.Icon:SetPoint("RIGHT")
				else
					btn.Icon:ClearAllPoints()
				end
				btn.Icon:Show()
			else
				btn.Icon:Hide()
			end

			local indent = btn.indent or 0
			textPos = textPos == -5 and 0 or textPos - 2
			btn.NormalText:ClearAllPoints()
			if btn.notCheckable then
				btn.Check:Hide()
				btn.UnCheck:Hide()
				if btn.icon then
					btn.Icon:SetPoint("LEFT", indent, 0)
					if not btn.iconOnly then
						indent = indent + btn.Icon:GetWidth() + 2
					end
				end

				if btn.justifyH == "CENTER" then
					btn.NormalText:SetPoint("CENTER", (indent + textPos) / 2, 0)
				elseif btn.justifyH == "RIGHT" then
					btn.NormalText:SetPoint("RIGHT", textPos, 0)
				else
					btn.NormalText:SetPoint("LEFT", indent, 0)
				end
			else
				btn.Check:SetPoint("LEFT", indent, 0)
				btn.UnCheck:SetPoint("LEFT", indent, 0)
				if btn.icon then
					btn.Icon:SetPoint("LEFT", 20 + indent, 0)
					if not btn.iconOnly then
						indent = indent + btn.Icon:GetWidth() + 2
					end
				end
				btn.NormalText:SetPoint("LEFT", 20 + indent, 0)

				if btn.isNotRadio then
					btn.Check:SetTexCoord(0, .5, 0, .5)
					btn.UnCheck:SetTexCoord(.5, 1, 0, .5)
				else
					btn.Check:SetTexCoord(0, .5, .5, 1)
					btn.UnCheck:SetTexCoord(.5, 1, .5, 1)
				end

				btn._checked = btn.checked
				if type(btn._checked) == "function" then
					btn._checked = btn:_checked()
				elseif v.DROPDOWNBUTTON.dropDownSetText and btn._checked == nil and not btn.isNotRadio then
					btn._checked = btn.value == v.DROPDOWNBUTTON.selectedValue
				end

				btn.Check:SetShown(btn._checked)
				btn.UnCheck:SetShown(not btn._checked)
			end

			if btn.isEnter then
				btn:GetScript("OnEnter")(btn)
			end

			btn:SetWidth(self:GetWidth() - 28)
			btn:Show()
		else
			btn:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame, scrollFrame.buttonHeight * numButtons, scrollFrame:GetHeight())
end


function DropDownMenuSearchMixin:addButton(info)
	local btnInfo = {}
	local btn = self.listScroll.buttons[1]
	for i = 1, #dropDownOptions do
		local opt = dropDownOptions[i]
		btnInfo[opt] = info[opt]
		btn[opt] = info[opt]
	end
	self.buttons[#self.buttons + 1] = btnInfo

	local width = 50

	if btn.text then
		btn:SetText(type(btn.text) == "function" and btn:text() or btn.text)

		if btn.isTitle then
			btn:SetDisabledFontObject(GameFontNormalSmallLeft)
		else
			btn:SetDisabledFontObject(GameFontDisableSmallLeft)
		end

		local disabled = btn.disabled
		if type(disabled) == "function" then disabled = disabled(btn) end
		if disabled or btn.isTitle then
			btn:Disable()
		else
			btn:Enable()
			btn:SetNormalFontObject(btn.fontObject or GameFontHighlightSmallLeft)
			btn:SetHighlightFontObject(btn.fontObject or GameFontHighlightSmallLeft)
		end

		width = width + btn.NormalText:GetWidth()
	end

	if btn.indent then
		width = width + btn.indent
	end

	if btn.notCheckable then
		width = width - 20
	elseif not btn.isNotRadio then
		local checked = btn.checked
		if type(checked) == "function" then
			checked = checked(btn)
		elseif v.DROPDOWNBUTTON.dropDownSetText and checked == nil and not btn.isNotRadio then
			checked = btn.value == v.DROPDOWNBUTTON.selectedValue
		end
		if checked then self.index = #self.buttons end
	end

	if btn.icon and not btn.iconOnly then
		width = width + (btn.iconInfo and btn.iconInfo.tSizeX or DropDownMenuButtonHeight) + 2
	end

	local textPos = -7
	if btn.hasArrow then
		textPos = -12
	end

	if btn.remove then
		textPos = textPos - 17
	end

	if btn.order then
		textPos = textPos - 25
	end

	if btn.hasColorSwatch then
		textPos = textPos - 17
	end

	width = width - (textPos == -7 and 0 or textPos)

	if self.width < width then
		self.width = width
	end
end


local function CreateDropDownMenuSearch(i)
	local f = CreateFrame("FRAME")
	f:Hide()
	f:SetHeight(DropDownMenuSearchHeight)
	f:SetScript("OnShow", DropDownMenuSearch_OnShow)
	f:SetScript("OnHide", OnHide)

	f.searchBox = CreateFrame("EditBox", MAJOR_VERSION.."SearchBox"..i, f, "SearchBoxTemplate")
	f.searchBox:SetMaxLetters(40)
	f.searchBox:SetHeight(20)
	f.searchBox:SetPoint("TOPLEFT", 5, -3)
	f.searchBox:SetPoint("TOPRIGHT", 1, 0)
	f.searchBox:SetScript("OnTextChanged", DropDownMenuSearchBox_OnTextChanged)
	f.searchBox:SetScript("OnEnter", DropDownMenuSearchBox_OnEnter)

	f.searchBox.clearButton:SetScript("OnClick", DropDownMenuSearchBoxClear_OnClick)

	f.listScroll = CreateFrame("ScrollFrame", MAJOR_VERSION.."ScrollFrame"..i, f, "HybridScrollFrameTemplate")
	f.listScroll:SetSize(30, DropDownMenuSearchHeight - 26)
	f.listScroll:SetPoint("TOPLEFT", f.searchBox, "BOTTOMLEFT", -5, -3)
	f.listScroll:SetPoint("RIGHT", -25, 0)

	f.listScroll.scrollBar = CreateFrame("SLIDER", nil, f.listScroll)
	local scrollBar = f.listScroll.scrollBar
	scrollBar.doNotHide = true
	scrollBar:SetSize(20, 0)
	scrollBar:SetPoint("TOPLEFT", f.listScroll, "TOPRIGHT", 5, -15)
	scrollBar:SetPoint("BOTTOMLEFT", f.listScroll, "BOTTOMRIGHT", 5, 15)
	scrollBar:SetScript("OnValueChanged", HybridScrollFrame_OnValueChanged)
	scrollBar:SetScript("OnMouseWheel", DropDownMenuSearchScrollBar_OnMouseWheel)
	scrollBar:SetScript("OnEnter", DropDownMenuSearchScrollBar_OnEnter)
	scrollBar.scrollChild = f.listScroll.scrollChild

	scrollBar:SetThumbTexture("Interface/Buttons/UI-ScrollBar-Knob")
	scrollBar.thumbTexture = scrollBar:GetThumbTexture()
	scrollBar.thumbTexture:SetBlendMode("ADD")
	scrollBar.thumbTexture:SetSize(21, 24)
	scrollBar.thumbTexture:SetTexCoord(.125, .825, .125, .825)

	scrollBar.trackBG = scrollBar:CreateTexture(nil, "BACKGROUND")
	scrollBar.trackBG:SetPoint("TOPLEFT", 1, 0)
	scrollBar.trackBG:SetPoint("BOTTOMRIGHT")
	scrollBar.trackBG:SetColorTexture(0, 0, 0, .15)

	scrollBar.UpButton = CreateFrame("BUTTON", nil, scrollBar)
	scrollBar.UpButton:SetSize(18, 16)
	scrollBar.UpButton:SetPoint("BOTTOM", scrollBar, "TOP", 1, -2)
	scrollBar.UpButton:SetNormalAtlas("UI-ScrollBar-ScrollUpButton-Up")
	scrollBar.UpButton:SetPushedAtlas("UI-ScrollBar-ScrollUpButton-Down")
	scrollBar.UpButton:SetDisabledAtlas("UI-ScrollBar-ScrollUpButton-Disabled")
	scrollBar.UpButton:SetHighlightAtlas("UI-ScrollBar-ScrollUpButton-Highlight")
	scrollBar.UpButton:SetScript("OnClick", HybridScrollFrameScrollButton_OnClick)
	scrollBar.UpButton:SetScript("OnEnter", DropDownMenuSearchScrollBarControl_OnEnter)
	HybridScrollFrameScrollUp_OnLoad(scrollBar.UpButton)

	scrollBar.DownButton = CreateFrame("BUTTON", nil, scrollBar)
	scrollBar.DownButton:SetSize(18, 16)
	scrollBar.DownButton:SetPoint("TOP", scrollBar, "BOTTOM", 1, 1)
	scrollBar.DownButton:SetNormalAtlas("UI-ScrollBar-ScrollDownButton-Up")
	scrollBar.DownButton:SetPushedAtlas("UI-ScrollBar-ScrollDownButton-Down")
	scrollBar.DownButton:SetDisabledAtlas("UI-ScrollBar-ScrollDownButton-Disabled")
	scrollBar.DownButton:SetHighlightAtlas("UI-ScrollBar-ScrollDownButton-Highlight")
	scrollBar.DownButton:SetScript("OnClick", HybridScrollFrameScrollButton_OnClick)
	scrollBar.DownButton:SetScript("OnEnter", DropDownMenuSearchScrollBarControl_OnEnter)
	HybridScrollFrameScrollDown_OnLoad(scrollBar.DownButton)

	f.listScroll.update = DropDownMenuSearch_Update
	DropDownScrollFrame_CreateButtons(f.listScroll)

	f.buttons = {}
	f.filtredButtons = {}
	for k, v in next, DropDownMenuSearchMixin do
		f[k] = v
	end

	return f
end


local dropDownSearchFrames = v.dropDownSearchFrames
local function GetDropDownSearchFrame()
	for i = 1, #dropDownSearchFrames do
		local frame = dropDownSearchFrames[i]
		if not frame:IsShown() then return frame:reset() end
	end
	local i = #dropDownSearchFrames + 1
	local frame = CreateDropDownMenuSearch(i)
	dropDownSearchFrames[i] = frame
	return frame:reset()
end


---------------------------------------------------
-- UPDATE OLD VERSION
---------------------------------------------------
if oldminor < MINOR_VERSION then
	for i = 1, #dropDownSearchFrames do
		local f = dropDownSearchFrames[i]
		f.refresh = DropDownMenuSearchMixin.refresh
		f.addButton = DropDownMenuSearchMixin.addButton
	end
end


---------------------------------------------------
-- DROPDOWN CREATING
---------------------------------------------------
local dropDownMenusList = setmetatable(v.dropDownMenusList, {
	__index = function(self, key)
		local frame = CreateDropDownMenuList(key == 1 and UIParent or self[key - 1])
		if key ~= 1 then
			frame:SetFrameLevel(self[key - 1]:GetFrameLevel() + 3)
		end
		frame.scrollChild.id = key
		frame.searchFrames = {}
		frame.buttonsList = setmetatable({}, {
			__index = function(self, key)
				local btn = CreateDropDownMenuButton(frame.scrollChild)
				btn:SetPoint("RIGHT")
				self[key] = btn
				return btn
			end,
		})
		self[key] = frame
		return frame
	end,
})


local menu1 = dropDownMenusList[1]
-- CLOSE ON ESC
menu1:SetScript("OnKeyDown", function(self, key)
	if key == GetBindingKey("TOGGLEGAMEMENU") then
		self:Hide()
		self:SetPropagateKeyboardInput(false)
	else
		self:SetPropagateKeyboardInput(true)
	end
end)


-- CLOSE WHEN CLICK ON A FREE PLACE
local function ContainsMouse()
	for i = 1, #dropDownMenusList do
		local menu = dropDownMenusList[i]
		if menu:IsShown() and menu:IsMouseOver() then
			return true
		end
	end
	return false
end


local GetMouseFocus = GetMouseFocus
local function ContainsFocus()
	local focus = GetMouseFocus()
	return focus and focus.LibSFDropDownNoGMEvent
end


menu1:SetScript("OnEvent", function(self, event, button)
	if event == "PLAYER_REGEN_DISABLED" then
		self:EnableKeyboard(false)
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:EnableKeyboard(true)
	elseif (button == "LeftButton" or button == "RightButton")
	and not (ContainsFocus() or ContainsMouse()) then
		self:Hide()
	end
end)
menu1:SetScript("OnShow", function(self)
	self:Raise()
	self:EnableKeyboard(not InCombatLockdown())
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("GLOBAL_MOUSE_DOWN")
end)
menu1:SetScript("OnHide", function(self)
	DropDownMenuList_OnHide(self)
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("GLOBAL_MOUSE_DOWN")
end)
-- fix counting from old revisions
menu1:SetScript("OnUpdate", nil)


---------------------------------------------------
-- DROPDOWN TOGGLE BUTTON
---------------------------------------------------
local function MenuReset(menu)
	menu.width = 0
	menu.height = 0
	menu.numButtons = 0
	menu.scrollFrame.ScrollBar:SetValue(0)
	wipe(menu.searchFrames)
end


local DropDownButtonMixin = {}


function DropDownButtonMixin:ddSetSelectedValue(value, level, anchorFrame)
	self.selectedValue = value
	self:ddRefresh(level, anchorFrame)
end


function DropDownButtonMixin:ddSetSelectedText(text, icon, iconInfo, iconOnly, fontObject)
	self.Text:SetFontObject(fontObject or GameFontHighlightSmall)
	self.Text:SetText(text)
	if not self.Icon then return end
	if icon then
		self.Icon:Show()
		self.Icon:SetTexture(icon)
		if iconInfo then
			self.Icon:SetSize(iconInfo.tSizeX or DropDownMenuButtonHeight, iconInfo.tSizeY or DropDownMenuButtonHeight)
			self.Icon:SetTexCoord(iconInfo.tCoordLeft or 0, iconInfo.tCoordRight or 1, iconInfo.tCoordTop or 0, iconInfo.tCoordBottom or 1)
		else
			self.Icon:SetSize(DropDownMenuButtonHeight, DropDownMenuButtonHeight)
			self.Icon:SetTexCoord(0, 1, 0, 1)
		end
		if iconOnly then
			self.Text:SetPoint("LEFT", self.Left, "RIGHT", 0, 1)
			self.Icon:SetPoint("LEFT", self.Left, "RIGHT", -2, 1)
			self.Icon:SetPoint("RIGHT", self.Right, "LEFT", -15, 1)
		else
			self.Text:SetPoint("LEFT", self.Left, "RIGHT", self.Icon:GetWidth() - 2, 1)
			self.Icon:ClearAllPoints()
			self.Icon:SetPoint("RIGHT", self.Text, "RIGHT", -math.min(self.Text:GetStringWidth(), self.Text:GetWidth()) - 1, 0)
		end
	else
		self.Icon:Hide()
		self.Text:SetPoint("LEFT", self.Left, "RIGHT", 0, 1)
	end
end


function DropDownButtonMixin:ddSetInitFunc(initFunction)
	self.initialize = initFunction
end


function DropDownButtonMixin:ddInitialize(level, value, initFunction)
	if type(level) == "function" then
		initFunction = level
		level = nil
		value = nil
	elseif type(value) == "function" and not initFunction then
		initFunction = value
		value = nil
	end
	self:ddSetInitFunc(initFunction)

	if not self.dropDownSetText then return end
	level = level or 1
	local menu = dropDownMenusList[level]
	menu.anchorFrame = self
	v.DROPDOWNBUTTON = self
	MenuReset(menu)
	if level == 1 and value == nil then
		value = self.menuValue
	end
	self:initialize(level, value)

	for i = 1, menu.numButtons do
		local btn = menu.buttonsList[i]

		if not (btn.notCheckable or btn.isNotRadio) and btn.value == self.selectedValue then
			local text = type(btn.text) == "function" and btn:text() or btn.text
			self:ddSetSelectedText(text, btn.icon, btn.iconInfo, btn.iconOnly, btn.fontObject)
		end

		btn:Hide()
		if btn.colorSwatch then
			btn.colorSwatch:Hide()
			btn.colorSwatch = nil
		end
	end

	for i = 1, #menu.searchFrames do
		local searchFrame = menu.searchFrames[i]

		for j = 1, #searchFrame.buttons do
			local btn = searchFrame.buttons[j]

			if not (btn.notCheckable or btn.isNotRadio) and btn.value == self.selectedValue then
				local text = type(btn.text) == "function" and btn:text() or btn.text
				self:ddSetSelectedText(text, btn.icon, btn.iconInfo, btn.iconOnly, btn.fontObject)
				break
			end
		end

		searchFrame:Hide()
	end
end


function DropDownButtonMixin:ddSetDisplayMode(displayMode)
	self.displayMode = displayMode
end


function DropDownButtonMixin:ddSetAutoSetText(enabled)
	self.dropDownSetText = enabled
end


function DropDownButtonMixin:ddSetMaxHeight(height)
	self.maxHeight = height
end


function DropDownButtonMixin:ddSetMinMenuWidth(width)
	self.minMenuWidth = width
end


function DropDownButtonMixin:ddSetValue(value)
	self.menuValue = value
end


function DropDownButtonMixin:ddSetNoGlobalMouseEvent(enabled, frame)
	(frame or self).LibSFDropDownNoGMEvent = enabled and true or nil
end


function DropDownButtonMixin:ddHideWhenButtonHidden(frame)
	if frame then
		frame:HookScript("OnHide", function() self:ddOnHide() end)
	else
		self:HookScript("OnHide", self.ddOnHide)
	end
end


function DropDownButtonMixin:ddToggle(level, value, anchorFrame, xOffset, yOffset)
	if not level then level = 1 end
	local menu = dropDownMenusList[level]

	if menu:IsShown() then
		menu:Hide()
		if level == 1 and menu.anchorFrame == anchorFrame then return end
	end
	menu.anchorFrame = anchorFrame

	if level == 1 then
		v.DROPDOWNBUTTON = self
		if value == nil then value = self.menuValue end
	end
	MenuReset(menu)
	self:initialize(level, value)

	if menu.width < 30 then menu.width = 30 end
	if menu.height < 16 then menu.height = 16 end
	menu.scrollChild:SetWidth(menu.width)
	menu.width = menu.width + 30
	menu.height = menu.height + 30
	local maxHeight = self.maxHeight or UIParent:GetHeight()
	if menu.height > maxHeight then
		menu.height = maxHeight
		menu.width = menu.width + 26
		menu.scrollFrame:SetPoint("BOTTOMRIGHT", -35, 15)
		menu.scrollFrame.ScrollBar:Show()
	else
		menu.scrollFrame:SetPoint("BOTTOMRIGHT", -15, 15)
		menu.scrollFrame.ScrollBar:Hide()
	end
	menu:SetSize(menu.width, menu.height)

	if anchorFrame == "cursor" then
		anchorFrame = UIParent
		local x, y = GetCursorPosition()
		local scale = UIParent:GetScale()
		xOffset = (xOffset or 0) + x / scale
		yOffset = (yOffset or 0) + y / scale
	end

	if not xOffset or not yOffset then
		xOffset = -5
		yOffset = 3
	end

	if level == 1 then
		menu:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", xOffset, yOffset)
	else
		if GetScreenWidth() - anchorFrame:GetRight() - 2 < menu.width then
			menu:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -2, 14)
		else
			menu:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 2, 14)
		end
	end

	for name, frame in next, menu.styles do
		frame:Hide()
	end
	local style = v.DROPDOWNBUTTON.displayMode
	if style == "menu" then
		style = v.menuStyle
	elseif not menu.styles[style] then
		style = v.defaultStyle
	end
	menu.styles[style]:Show()

	menu:Show()
end


do
	local function RefreshButton(self, btn, setText)
		if type(btn.disabled) == "function" then
			btn:SetEnabled(not btn:disabled())
		end

		if type(btn.text) == "function" then
			btn._text = btn:text()
			btn:SetText(btn._text)
		end

		if not btn.notCheckable then
			if type(btn.checked) == "function" then
				btn._checked = btn:checked()
			elseif self.dropDownSetText and btn.checked == nil and not btn.isNotRadio then
				btn._checked = btn.value == self.selectedValue
			end
			btn.Check:SetShown(btn._checked)
			btn.UnCheck:SetShown(not btn._checked)

			if setText and btn._checked and not btn.isNotRadio then
				self:ddSetSelectedText(btn._text, btn.icon, btn.iconInfo, btn.iconOnly, btn.fontObject)
			end
		end
	end


	function DropDownButtonMixin:ddRefresh(level, anchorFrame)
		if not level then level = 1 end
		if not anchorFrame then anchorFrame = self end
		local menu = dropDownMenusList[level]
		local setText = self.dropDownSetText and menu.anchorFrame == anchorFrame

		for i = 1, #menu.buttonsList do
			local btn = menu.buttonsList[i]
			if not btn:IsShown() then break end
			RefreshButton(self, btn, setText)
		end

		for i = 1, #menu.searchFrames do
			local scrollFrame = menu.searchFrames[i].listScroll
			if not scrollFrame:IsShown() then break end
			for j = 1, #scrollFrame.buttons do
				local btn = scrollFrame.buttons[j]
				if not btn:IsShown() then break end
				RefreshButton(self, btn, setText)
			end
		end
	end
end


function DropDownButtonMixin:ddCloseMenus(level)
	local menu = rawget(dropDownMenusList, level or 1)
	if menu then menu:Hide() end
end


function DropDownButtonMixin:ddOnHide()
	if self == v.DROPDOWNBUTTON then
		self:ddCloseMenus()
	end
end


function DropDownButtonMixin:ddAddButton(info, level)
	if not level then level = 1 end
	local width = 0
	local menu = dropDownMenusList[level]

	if info.list then
		if #info.list > 20 then
			local searchFrame, height = GetDropDownSearchFrame()
			searchFrame:SetParent(menu.scrollChild)
			searchFrame:SetFrameLevel(menu.scrollChild:GetFrameLevel())
			searchFrame:SetPoint("TOPLEFT", 0, -menu.height)
			searchFrame:SetPoint("RIGHT")
			searchFrame.listScroll.scrollChild.id = level

			if info.hideSearch then
				searchFrame.searchBox:Hide()
				searchFrame.listScroll:SetPoint("TOPLEFT", 0, -3)
				height = DropDownMenuSearchHeight - 23
			else
				searchFrame.searchBox:Show()
				searchFrame.listScroll:SetPoint("TOPLEFT", searchFrame.searchBox, "BOTTOMLEFT", -5, -3)
				height = DropDownMenuSearchHeight
			end

			for i = 1, #info.list do
				searchFrame:addButton(info.list[i])
			end

			width = searchFrame:getEntryWidth()
			menu.width = math.max(menu.width, width, self.minMenuWidth or 0)
			if menu.width < width then menu.width = width end
			searchFrame:Show()

			menu.searchFrames[#menu.searchFrames + 1] = searchFrame
			menu.height = menu.height + height
		else
			for i = 1, #info.list do
				self:ddAddButton(info.list[i], level)
			end
		end
		return
	end

	if info.customFrame then
		local frame = info.customFrame
		if info.OnLoad then info.OnLoad(frame) end

		frame:SetParent(menu.scrollChild)
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", 0, -menu.height)

		width = frame:GetWidth()
		menu.width = math.max(menu.width, width, self.minMenuWidth or 0)

		if not info.fixedWidth then
			frame:SetPoint("RIGHT")
		end
		frame:Show()

		menu.customFrames = menu.customFrames or {}
		menu.customFrames[#menu.customFrames + 1] = frame
		menu.height = menu.height + frame:GetHeight()
		return
	end

	menu.numButtons = menu.numButtons + 1
	local btn = menu.buttonsList[menu.numButtons]

	for i = 1, #dropDownOptions do
		local opt = dropDownOptions[i]
		btn[opt] = info[opt]
	end

	btn._text = btn.text
	if btn._text then
		if type(btn._text) == "function" then btn._text = btn:_text() end
		btn:SetText(btn._text)
		btn:SetDisabledFontObject(btn.isTitle and GameFontNormalSmallLeft or GameFontDisableSmallLeft)
		btn:SetNormalFontObject(btn.fontObject or GameFontHighlightSmallLeft)
		btn:SetHighlightFontObject(btn.fontObject or GameFontHighlightSmallLeft)
		width = width + btn.NormalText:GetWidth()
	else
		btn:SetText("")
	end

	local disabled = btn.disabled
	if type(disabled) == "function" then disabled = disabled(btn) end
	if disabled or btn.isTitle then
		btn:Disable()
	else
		btn:Enable()
	end

	local textPos = -5
	if btn.hasArrow then
		textPos = -12
	end
	btn.ExpandArrow:SetShown(btn.hasArrow)

	if btn.remove then
		btn.removeButton:SetPoint("RIGHT", textPos, 0)
		textPos = textPos - 17
		btn.removeButton:Show()
	else
		btn.removeButton:Hide()
	end

	if btn.order then
		btn.arrowDownButton:SetPoint("RIGHT", textPos, 0)
		textPos = textPos - 25
		btn.arrowDownButton:Show()
		btn.arrowUpButton:Show()
	else
		btn.arrowDownButton:Hide()
		btn.arrowUpButton:Hide()
	end

	if btn.hasColorSwatch then
		btn.colorSwatch = GetColorSwatchFrame()
		btn.colorSwatch:SetParent(btn)
		btn.colorSwatch:SetPoint("RIGHT", textPos, 0)
		textPos = textPos - 17
		btn.colorSwatch.color:SetVertexColor(btn.r, btn.g, btn.b)
		btn.colorSwatch:Show()
		if not btn.func then
			btn.func = function() btn.colorSwatch:Click() end
		end
	end

	if btn.icon then
		local iconWrap
		if btn.iconInfo then
			local iInfo = btn.iconInfo
			btn.Icon:SetSize(iInfo.tSizeX or DropDownMenuButtonHeight, iInfo.tSizeY or DropDownMenuButtonHeight)
			btn.Icon:SetTexCoord(iInfo.tCoordLeft or 0, iInfo.tCoordRight or 1, iInfo.tCoordTop or 0, iInfo.tCoordBottom or 1)
			btn.Icon:SetHorizTile(iInfo.tWrap and true or false)
			iconWrap = iInfo.tWrap
		else
			btn.Icon:SetSize(DropDownMenuButtonHeight, DropDownMenuButtonHeight)
			btn.Icon:SetTexCoord(0, 1, 0, 1)
		end
		btn.Icon:SetTexture(btn.icon, iconWrap)

		if btn.iconOnly then
			btn.Icon:SetPoint("RIGHT")
		else
			btn.Icon:ClearAllPoints()
			width = width + btn.Icon:GetWidth() + 2
		end
		btn.Icon:Show()
	else
		btn.Icon:Hide()
	end

	local indent = btn.indent or 0
	textPos = textPos == -5 and 0 or textPos - 2
	width = width + indent - textPos

	btn.NormalText:ClearAllPoints()
	if btn.notCheckable then
		btn.Check:Hide()
		btn.UnCheck:Hide()
		if btn.icon then
			btn.Icon:SetPoint("LEFT", indent, 0)
			if not btn.iconOnly then
				indent = indent + btn.Icon:GetWidth() + 2
			end
		end

		if btn.justifyH == "CENTER" then
			btn.NormalText:SetPoint("CENTER", (indent + textPos) / 2, 0)
		elseif btn.justifyH == "RIGHT" then
			btn.NormalText:SetPoint("RIGHT", textPos, 0)
		else
			btn.NormalText:SetPoint("LEFT", indent, 0)
		end
	else
		btn.Check:SetPoint("LEFT", indent, 0)
		btn.UnCheck:SetPoint("LEFT", indent, 0)
		if btn.icon then
			btn.Icon:SetPoint("LEFT", 20 + indent, 0)
			if not btn.iconOnly then
				indent = indent + btn.Icon:GetWidth() + 2
			end
		end
		btn.NormalText:SetPoint("LEFT", 20 + indent, 0)
		width = width + 22

		if btn.isNotRadio then
			btn.Check:SetTexCoord(0, .5, 0, .5)
			btn.UnCheck:SetTexCoord(.5, 1, 0, .5)
		else
			btn.Check:SetTexCoord(0, .5, .5, 1)
			btn.UnCheck:SetTexCoord(.5, 1, .5, 1)
		end

		btn._checked = btn.checked
		if type(btn._checked) == "function" then
			btn._checked = btn:_checked()
		elseif self.dropDownSetText and btn.checked == nil and not btn.isNotRadio then
			btn._checked = btn.value == self.selectedValue
		end

		btn.Check:SetShown(btn._checked)
		btn.UnCheck:SetShown(not btn._checked)
	end

	btn:SetPoint("TOPLEFT", 0, -menu.height)
	btn:Show()

	menu.height = menu.height + DropDownMenuButtonHeight
	menu.width = math.max(menu.width, width, self.minMenuWidth or 0)
end


function DropDownButtonMixin:ddAddSeparator(level)
	local info = {
		disabled = true,
		notCheckable = true,
		iconOnly = true,
		icon = "Interface/Common/UI-TooltipDivider-Transparent",
		iconInfo = {
			tSizeX = 0,
			tSizeY = 8,
		},
	}
	self:ddAddButton(info, level)
end


function DropDownButtonMixin:ddAddSpace(level)
	local info = {
		disabled = true,
		notCheckable = true,
	}
	self:ddAddButton(info, level)
end


DropDownButtonMixin.ddEasyMenuInitialize = function(self, level, menuList)
	for i = 1, #menuList do
		local info = menuList[i]
		if info.menuList then
			info.hasArrow = true
			info.value = info.menuList
		end
		if info.list then
			for j = 1, #info.list do
				local subInfo = info.list[j]
				if subInfo.menuList then
					subInfo.hasArrow = true
					subInfo.value = subInfo.menuList
				end
			end
		end
		self:ddAddButton(info, level)
	end
end


function DropDownButtonMixin:ddEasyMenu(menuList, anchorFrame, xOffset, yOffset, displayMode)
	self:ddSetDisplayMode(displayMode)
	self:ddInitialize(1, menuList, self.ddEasyMenuInitialize)
	self:ddToggle(1, menuList, anchorFrame, xOffset, yOffset)
end


---------------------------------------------------
-- LIBRARY METHODS
---------------------------------------------------
local libMethods = lib._m.__index


function libMethods:IterateMenus()
	return ipairs(dropDownMenusList)
end


function libMethods:IterateMenuButtons(level)
	local menu = rawget(dropDownMenusList, level or 1)
	if menu then
		return ipairs(menu.buttonsList)
	else
		error("The menu with a level "..level.." dosn't exist.")
	end
end


function libMethods:IterateSearchFrames()
	return ipairs(dropDownSearchFrames)
end


function libMethods:IterateSearchFrameButtons(num)
	local searchFrame = dropDownSearchFrames[num]
	if searchFrame then
		return ipairs(searchFrame.listScroll.buttons)
	else
		error("SearchFrame number "..num.." dosn't exist.")
	end
end


function libMethods:CreateMenuStyle(name, overwrite, frameFunc)
	if type(overwrite) == "function" then
		frameFunc = overwrite
		overwrite = nil
	end
	if type(name) == "string" and type(frameFunc) == "function" then
		if menuStyles[name] then
			if overwrite and name ~= "backdrop" and name ~= "menuBackdrop" then
				for i = 1, #dropDownMenusList do
					local styles = dropDownMenusList[i].styles
					styles[name]:Hide()
					styles[name] = nil
				end
				menuStyles[name] = nil
			else
				return false
			end
		end
		for i = 1, #dropDownMenusList do
			CreateMenuStyle(dropDownMenusList[i], name, frameFunc)
		end
		menuStyles[name] = frameFunc
		return true
	end
end


function libMethods:SetDefaultStyle(name)
	if menuStyles[name] then
		v.defaultStyle = name
	else
		error("The style named \""..name.."\" dosn't exist.")
	end
end


function libMethods:SetMenuStyle(name)
	if menuStyles[name] then
		v.menuStyle = name
	else
		error("The style named \""..name.."\" dosn't exist.")
	end
end


function libMethods:SetMixin(btn)
	for k, v in next, DropDownButtonMixin do
		btn[k] = v
	end
	return btn
end


function libMethods:IterateCreatedButtons()
	return ipairs(self._v.dropDownCreatedButtons)
end


function libMethods:IterateCreatedStretchButtons()
	return ipairs(self._v.dropDownCreatedStretchButtons)
end


local function DropDownTooltip_OnEnter(self)
	if self.Text:IsTruncated() then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
		GameTooltip:SetText(self.Text:GetText())
		GameTooltip:Show()
	end
end


local function DropDownTooltip_OnLeave()
	GameTooltip:Hide()
end


do
	local function SetEnabled(self, enabled)
		self.Button:SetEnabled(enabled)
		self.Icon:SetDesaturated(not enabled)
		local color = enabled and HIGHLIGHT_FONT_COLOR or GRAY_FONT_COLOR
		self.Text:SetTextColor(color:GetRGB())
	end


	local function Enable(self)
		self:SetEnabled(true)
	end


	local function Disable(self)
		self:SetEnabled(false)
	end


	local function Button_OnClick(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local parent = self:GetParent()
		parent:ddToggle(1, nil, parent)
	end


	function libMethods:CreateButtonOriginal(parent, width)
		self.CreateButtonOriginal = nil

		local btn = CreateFrame("FRAME", nil, parent)
		btn:SetSize(width or 135, 24)
		btn:SetScript("OnEnter", DropDownTooltip_OnEnter)
		btn:SetScript("OnLeave", DropDownTooltip_OnLeave)

		self:SetMixin(btn)
		btn:ddSetAutoSetText(true)
		btn:ddHideWhenButtonHidden()
		btn.SetEnabled = SetEnabled
		btn.Enable = Enable
		btn.Disable = Disable

		btn.Left = btn:CreateTexture(nil, "BACKGROUND")
		btn.Left:SetTexture("Interface/Glues/CharacterCreate/CharacterCreate-LabelFrame")
		btn.Left:SetSize(25, 64)
		btn.Left:SetPoint("LEFT", -15, 0)
		btn.Left:SetTexCoord(0, .1953125, 0, 1)

		btn.Right = btn:CreateTexture(nil, "BACKGROUND")
		btn.Right:SetTexture("Interface/Glues/CharacterCreate/CharacterCreate-LabelFrame")
		btn.Right:SetSize(25, 64)
		btn.Right:SetPoint("RIGHT", 15, 0)
		btn.Right:SetTexCoord(.8046875, 1, 0, 1)

		btn.Middle = btn:CreateTexture(nil, "BACKGROUND")
		btn.Middle:SetTexture("Interface/Glues/CharacterCreate/CharacterCreate-LabelFrame")
		btn.Middle:SetHeight(64)
		btn.Middle:SetPoint("LEFT", btn.Left, "RIGHT")
		btn.Middle:SetPoint("RIGHT", btn.Right, "LEFT")
		btn.Middle:SetTexCoord(.1953125, .8046875, 0, 1)

		btn.Text = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		btn.Text:SetWordWrap(false)
		btn.Text:SetJustifyH("RIGHT")
		btn.Text:SetPoint("LEFT", btn.Left, "RIGHT", 0, 2)
		btn.Text:SetPoint("RIGHT", btn.Right, "LEFT", -17, 2)

		btn.Icon = btn:CreateTexture(nil, "ARTWORK")

		btn.Button = CreateFrame("BUTTON", nil, btn)
		btn.Button:SetMotionScriptsWhileDisabled(true)
		btn.Button:SetSize(26, 26)
		btn.Button:SetPoint("RIGHT", btn.Right, "LEFT", 9, 1)
		btn.Button:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
		btn.Button:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
		btn.Button:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Disabled")
		btn.Button:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
		btn.Button:GetHighlightTexture():SetBlendMode("ADD")
		btn.Button:SetScript("OnClick", Button_OnClick)
		btn:ddSetNoGlobalMouseEvent(true, btn.Button)

		return btn
	end


	function libMethods:CreateButton(...)
		local btn = self:CreateButtonOriginal(...)
		self._v.dropDownCreatedButtons[#self._v.dropDownCreatedButtons + 1] = btn
		return btn
	end
end


do
	local function OnClick(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ddToggle(1, nil, self, self:GetWidth() - 18, self:GetHeight() / 2 + 6)
	end


	function libMethods:CreateStretchButtonOriginal(parent, width, height, wrap)
		self.CreateStretchButtonOriginal = nil

		local btn = CreateFrame("BUTTON", nil, parent, "UIMenuButtonStretchTemplate")
		if width then btn:SetWidth(width) end
		if height then btn:SetHeight(height) end
		if wrap == nil then wrap = false end
		btn:SetScript("OnClick", OnClick)
		btn:SetScript("OnEnter", DropDownTooltip_OnEnter)
		btn:SetScript("OnLeave", DropDownTooltip_OnLeave)
		btn:SetMotionScriptsWhileDisabled(true)

		self:SetMixin(btn)
		btn:ddSetDisplayMode("menu")
		btn:ddHideWhenButtonHidden()
		btn:ddSetNoGlobalMouseEvent(true)

		btn.Arrow = btn:CreateTexture(nil, "ARTWORK")
		btn.Arrow:SetTexture("Interface/ChatFrame/ChatFrameExpandArrow")
		btn.Arrow:SetSize(10, 12)
		btn.Arrow:SetPoint("RIGHT", -5, 0)

		btn:SetText(" ")
		btn.Text = btn:GetFontString()
		btn.Text:SetWordWrap(wrap)
		btn.Text:ClearAllPoints()
		btn.Text:SetPoint("TOP", 0, -4)
		btn.Text:SetPoint("BOTTOM", 0, 4)
		btn.Text:SetPoint("LEFT", 4, 0)
		btn.Text:SetPoint("RIGHT", -15, 0)

		return btn
	end


	function libMethods:CreateStretchButton(...)
		local btn = self:CreateStretchButtonOriginal(...)
		self._v.dropDownCreatedStretchButtons[#self._v.dropDownCreatedStretchButtons + 1] = btn
		return btn
	end
end