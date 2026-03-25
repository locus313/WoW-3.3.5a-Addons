local addon, L = HidingBarConfigAddon.name, HidingBarConfigAddon.L
local aboutConfig = HidingBarConfigAbout
-- local aboutConfig = CreateFrame("FRAME", addon.."ConfigAbout")
-- aboutConfig:Hide()


	-- ADDON NAME
local addonName = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
addonName:SetPoint("TOP", 0, -48)
addonName:SetText(addon)
local font, size, flags = addonName:GetFont()
addonName:SetFont(font, 30, flags)

-- AUTHOR
local author = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
author:SetPoint("TOPRIGHT", addonName, "BOTTOM", -2, -48)
author:SetText(L["author"])

local authorName = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
authorName:SetPoint("LEFT", author, "RIGHT", 4, 0)
authorName:SetText(C_AddOns.GetAddOnMetadata(addon, "Author") or GetAddOnMetadata(addon, "Author") or "")

-- VERSION
local versionText = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
versionText:SetPoint("TOPRIGHT", author, "BOTTOMRIGHT", 0, -8)
versionText:SetText(GAME_VERSION_LABEL or "Version")

local version = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
version:SetPoint("LEFT", versionText, "RIGHT", 4, 0)
version:SetText(C_AddOns.GetAddOnMetadata(addon, "Version") or GetAddOnMetadata(addon, "Version") or "")

-- HELP TRANSLATION
local helpText = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
helpText:SetPoint("TOP", version, "BOTTOM", 0, -48)
helpText:SetPoint("LEFT", 32, 0)
helpText:SetText(L["Help with translation of %s. Thanks."]:format(addon))

local link = "https://www.curseforge.com/wow/addons/hidingbar/localization"
local editbox = CreateFrame("Editbox", nil, aboutConfig)
editbox:SetAutoFocus(false)
editbox:SetAltArrowKeyMode(true)
editbox:SetFontObject("GameFontHighlight")
editbox:SetSize(500, 20)
editbox:SetPoint("TOPLEFT", helpText, "BOTTOMLEFT", 8, 0)
editbox:SetText(link)
editbox:SetCursorPosition(0)
editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
editbox:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)
editbox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
editbox:SetScript("OnTextChanged", function(self, userInput)
	if userInput then
		self:SetText(link)
		self:HighlightText()
	end
end)

-- TRANSLATORS
local translators = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
translators:SetPoint("TOPLEFT", helpText, "BOTTOMLEFT", 0, -80)
translators:SetText(L["Localization Translators:"])

local langs, last = {
	{"deDE", "SlayerEGT"},
	{"esES", "neolynx_zero"},
	{"frFR", "PhantomLord"},
	{"koKR", "drixwow, netaras"},
	{"ptBR", "cathzinhas, 6605270"},
	{"zhCN", "lambdapak, huchang47"},
	{"zhTW", "BNS333, terry1314"},
}

for _, l in ipairs(langs) do
	local sl = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	if last then
		sl:SetPoint("TOPRIGHT", last, "BOTTOMLEFT", -5, -10)
	else
		sl:SetPoint("TOP", translators, "BOTTOM", 0, -16)
		sl:SetPoint("RIGHT", aboutConfig, "LEFT", 136, 0)
	end
	sl:SetJustifyH("RIGHT")
	sl:SetText("|cff82c5ff"..l[1]..":|r")

	local st = aboutConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	st:SetPoint("LEFT", sl, "RIGHT", 5, 0)
	st:SetPoint("RIGHT", -96, 0)
	st:SetJustifyH("LEFT")
	st:SetText("|cffffff9a"..l[2].."|r")

	last = st
end


-- local category = Settings.GetCategory(addon)
-- local subcategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, aboutConfig,  L["About"])
-- subcategory.ID = L["About"]
-- layout:AddAnchorPoint("TOPLEFT", -12, 8)
-- layout:AddAnchorPoint("BOTTOMRIGHT", 0, 0)
-- Settings.RegisterAddOnCategory(subcategory)