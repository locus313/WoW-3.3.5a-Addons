local addon, L = ...


local function onShow(self)
	self:SetPoint("TOPLEFT", -12, 8)
end


local function loadOptions(self)
	self:SetPoint("TOPLEFT", -12, 8)

	local name = addon.."_Options"
	if IsAddOnLoaded(name) then
		self:SetScript("OnShow", onShow)
		return
	end
	if select(5, GetAddOnInfo(name)) == "DISABLED" then
		EnableAddOn(name)
	end
	local loaded, reason = LoadAddOn(name)
	if loaded then
		self:SetScript("OnShow", onShow)
	else
		print("Failed to load "..name..": "..tostring(reason))
	end
end


-- MAIN
local config = CreateFrame("FRAME", addon.."ConfigAddon")
config.name = addon
config:Hide()
config.L = L
config.noIcon = config:CreateTexture()
config:SetScript("OnShow", loadOptions)

-- Register with the WoW 3.3.5a Interface Options panel
InterfaceOptions_AddCategory(config)


-- ABOUT
local aboutConfig = CreateFrame("FRAME", addon.."ConfigAbout")
aboutConfig.name = L["About"]
aboutConfig.parent = addon
aboutConfig:Hide()
aboutConfig:SetScript("OnShow", loadOptions)

-- Register About as a sub-category
InterfaceOptions_AddCategory(aboutConfig)


-- OPEN CONFIG
function config:openConfig()
	if InterfaceOptionsFrame:IsShown() and self:IsVisible() then
		HideUIPanel(InterfaceOptionsFrame)
	else
		InterfaceOptionsFrame_OpenToCategory(self)
		-- Call twice: first call may only open the panel, second selects the category
		InterfaceOptionsFrame_OpenToCategory(self)
	end
end


SLASH_HIDDINGBAR1 = "/hidingbar"
SlashCmdList["HIDDINGBAR"] = function() config:openConfig() end