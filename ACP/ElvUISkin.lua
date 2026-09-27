-- ElvUI integration for the Addon Control Panel window.
-- Only runs when ElvUI is installed and enabled; otherwise ACP keeps its default Blizzard look.
-- ACP.toc lists ElvUI as an OptionalDep so, when ElvUI is enabled, its files (and the ElvUI global)
-- are guaranteed to be fully loaded before this file runs.
if not IsAddOnLoaded("ElvUI") then return end

local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

-- Number of addon row buttons created in ACP.xml (ACP_AddonListEntry1..20); kept in sync with
-- the local ACP_MAXADDONS constant in ACP.lua.
local ACP_MAXADDONS = 20

-- Bottom-row buttons copy their size and font from Interface Options' Okay button (skinned by
-- ElvUI) so they match it exactly. The fallback values are Blizzard's defaults for that button.
local BUTTON_GAP = 3
local SETS_BUTTON_WIDTH = 48

local function GetReferenceButtonStyle()
	local ref = InterfaceOptionsFrameOkay
	local width, height = 96, 22
	local font, fontSize, fontFlags

	if ref then
		width, height = ref:GetWidth(), ref:GetHeight()
		local text = ref:GetFontString()
		if text then
			font, fontSize, fontFlags = text:GetFont()
		end
	end

	return width, height, font, fontSize, fontFlags
end

local function StyleBottomButton(button, width, height, font, fontSize, fontFlags)
	if not button then return end

	S:HandleButton(button)
	button:SetSize(width, height)

	local text = button:GetFontString()
	if text and font then
		text:SetFont(font, fontSize, fontFlags)
	end
end

-- ACP.xml spaces these buttons for its original 80px widths, so the wider reference buttons would
-- overlap. Chain them from the frame corners instead, like Interface Options does.
local function LayoutBottomButtons()
	local width, height, font, fontSize, fontFlags = GetReferenceButtonStyle()

	StyleBottomButton(ACP_AddonListSetButton, SETS_BUTTON_WIDTH, height, font, fontSize, fontFlags)
	StyleBottomButton(ACP_AddonListDisableAll, width, height, font, fontSize, fontFlags)
	StyleBottomButton(ACP_AddonListEnableAll, width, height, font, fontSize, fontFlags)
	StyleBottomButton(ACP_AddonListBottomClose, width, height, font, fontSize, fontFlags)
	StyleBottomButton(ACP_AddonList_ReloadUI, width, height, font, fontSize, fontFlags)

	ACP_AddonListDisableAll:ClearAllPoints()
	ACP_AddonListDisableAll:SetPoint("LEFT", ACP_AddonListSetButton, "RIGHT", BUTTON_GAP, 0)
	ACP_AddonListEnableAll:ClearAllPoints()
	ACP_AddonListEnableAll:SetPoint("LEFT", ACP_AddonListDisableAll, "RIGHT", BUTTON_GAP, 0)
	ACP_AddonList_ReloadUI:ClearAllPoints()
	ACP_AddonList_ReloadUI:SetPoint("RIGHT", ACP_AddonListBottomClose, "LEFT", -BUTTON_GAP, 0)
end

-- ACP's "Enabled" checkbox is 32x32 (vs. ElvUI's usual ~16-20px checkboxes); left at full size,
-- its skinned checked texture overlaps neighboring 16px-tall rows and merges into a solid bar.
local ENTRY_CHECKBOX_SIZE = 20

local function ClampCheckboxSize(checkbox)
	if checkbox and checkbox:GetWidth() > ENTRY_CHECKBOX_SIZE then
		checkbox:SetSize(ENTRY_CHECKBOX_SIZE, ENTRY_CHECKBOX_SIZE)
	end
end

local function SkinEntry(entry)
	if not entry or entry.isSkinned then return end

	local name = entry:GetName()

	local enabled = _G[name.."Enabled"]
	if enabled then
		S:HandleCheckBox(enabled)
		ClampCheckboxSize(enabled)
	end

	S:HandleButton(_G[name.."LoadNow"])

	entry.isSkinned = true
end

-- ACP:AddonList_OnShow() re-runs on every list refresh/scroll and explicitly resets each row's
-- checkbox back to 32x32 (ACP.lua ~1579), undoing the resize above; clamp it back down each time.
local function ClampAllCheckboxSizes()
	for i = 1, ACP_MAXADDONS do
		ClampCheckboxSize(_G["ACP_AddonListEntry"..i.."Enabled"])
	end
end

local function SkinACP()
	local frame = ACP_AddonList
	if not frame or frame.isSkinned then return end

	-- ACP.xml defines this frame with no parent, so it ignores the UI scale ElvUI applies to
	-- UIParent (e.g. 0.68) and renders noticeably larger than every other skinned window.
	-- ElvUI's pixel-perfect border math (E.mult) also assumes UIParent's scale.
	frame:SetParent(UIParent)

	-- Remove the Blizzard HelpFrame border art and DialogBox header texture, then apply
	-- ElvUI's flat backdrop + border in their place.
	frame:StripTextures()
	frame:SetTemplate('Transparent')

	if ACP_AddonListHeaderTitle then
		ACP_AddonListHeaderTitle:FontTemplate()
	end

	S:HandleCloseButton(ACP_AddonListCloseButton)
	S:HandleDropDownBox(ACP_AddonListSortDropDown, 130)

	LayoutBottomButtons()

	S:HandleCheckBox(ACP_AddonList_NoRecurse)
	if ACP_AddonList_NoRecurse then
		ACP_AddonList_NoRecurse:Size(ENTRY_CHECKBOX_SIZE)
	end

	-- ElvUI's own game-menu skin (Blizzard/Misc.lua) only knows about Blizzard's stock Escape
	-- menu buttons, not the "AddOns" button ACP injects into GameMenuFrame, so skin it ourselves
	-- to match the rest of the menu.
	if GameMenuButtonAddOns then
		S:HandleButton(GameMenuButtonAddOns)
	end

	-- FauxScrollFrame has no real scrollbar widget here, just decorative track art; strip it
	-- to match ElvUI's flat look (mouse-wheel scrolling keeps working either way).
	if ACP_AddonList_ScrollFrame then
		ACP_AddonList_ScrollFrame:StripTextures()
	end

	for i = 1, ACP_MAXADDONS do
		SkinEntry(_G["ACP_AddonListEntry"..i])
	end

	ClampAllCheckboxSizes()
	hooksecurefunc(ACP, "AddonList_OnShow", ClampAllCheckboxSizes)

	frame.isSkinned = true
end

-- ACP loads well before PLAYER_LOGIN, but ElvUI doesn't populate E.media (colors/textures) or
-- finish its own initialization until PLAYER_LOGIN, so defer skinning until then.
local skinner = CreateFrame("Frame")
skinner:RegisterEvent("PLAYER_LOGIN")
skinner:SetScript("OnEvent", function(self)
	SkinACP()
	self:UnregisterEvent("PLAYER_LOGIN")
end)
