-- WoW 3.3.5a Compatibility Shim for HidingBar_Options
-- Must be loaded BEFORE embeds.xml (LibSFDropDown) because the library
-- captures these globals in local variables at load time.

-- -----------------------------------------------------------------------
-- SOUNDKIT constants
-- In 3.3.5a, PlaySound() takes a numeric ID; SOUNDKIT table doesn't exist
-- -----------------------------------------------------------------------
if not SOUNDKIT then
	SOUNDKIT = {
		IG_MAINMENU_OPTION_CHECKBOX_ON  = 856,
		IG_MAINMENU_OPTION_CHECKBOX_OFF = 857,
		IG_CHARACTER_INFO_TAB           = 832,
		U_CHAT_SCROLL_BUTTON            = 857,
	}
end

-- -----------------------------------------------------------------------
-- HybridScrollFrame polyfill using FauxScrollFrame semantics
-- In 3.3.5a there is no HybridScrollFrame; we implement the same API
-- on top of a plain Frame + manual offset tracking.
-- -----------------------------------------------------------------------
if not HybridScrollFrame_GetOffset then

	-- Returns how many button-rows have been scrolled off the top
	function HybridScrollFrame_GetOffset(self)
		return self.offset or 0
	end

	-- Update the scroll range after the item count changes.
	-- totalHeight   = numItems * buttonHeight
	-- displayedHeight = scroll frame's pixel height (ignored; we use button count)
	function HybridScrollFrame_Update(self, totalHeight, displayedHeight)
		local buttonHeight = self.buttonHeight
		if not buttonHeight or buttonHeight <= 0 then return end

		local numItems     = math.ceil(totalHeight / buttonHeight)
		local numToDisplay = #(self.buttons or {})
		local scrollBar    = self.scrollBar
		if not scrollBar then return end

		local maxScroll = math.max(0, (numItems - numToDisplay) * buttonHeight)
		scrollBar:SetMinMaxValues(0, maxScroll)

		if maxScroll <= 0 then
			if not scrollBar.doNotHide then scrollBar:Hide() end
			self.offset = 0
			scrollBar._hbIgnore = true
			scrollBar:SetValue(0)
			scrollBar._hbIgnore = nil
		else
			scrollBar:Show()
			-- clamp current scroll position
			local cur = math.min(scrollBar:GetValue(), maxScroll)
			scrollBar._hbIgnore = true
			scrollBar:SetValue(cur)
			scrollBar._hbIgnore = nil
			self.offset = math.floor(cur / buttonHeight + 0.5)
		end
	end

	-- Create enough buttons to fill the scroll frame's height, anchored downward
	function HybridScrollFrame_CreateButtons(self, buttonTemplate)
		self.buttons = {}
		local height = self:GetHeight()
		local y = 0
		repeat
			local btn = CreateFrame("Button", nil, self, buttonTemplate)
			local bw, bh = btn:GetSize()
			if bh == 0 then bh = 18 end      -- fallback if template has no size
			if not self.buttonHeight then
				self.buttonHeight = bh
			end
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -y)
			btn:SetWidth(self:GetWidth())
			tinsert(self.buttons, btn)
			y = y + self.buttonHeight
		until y >= height
	end

	-- Called when the scrollbar value changes (wired up in the XML template).
	-- Uses _hbIgnore flag to break SetValue → OnValueChanged → update → SetValue loops.
	function HybridScrollFrame_OnValueChanged(self, value, userInput)
		if self._hbIgnore then return end
		local sf = self:GetParent()   -- scrollBar's parent is the scroll Frame
		if not sf or not sf.buttonHeight then return end
		sf.offset = math.floor(self:GetValue() / sf.buttonHeight + 0.5)
		if sf.update then sf:update() end
	end

	-- Stubs expected by LibSFDropDown's local-variable capture
	HybridScrollFrameScrollButton_OnClick      = HybridScrollFrameScrollButton_OnClick or function() end
	HybridScrollFrameScrollUp_OnLoad           = HybridScrollFrameScrollUp_OnLoad      or function() end
	HybridScrollFrameScrollDown_OnLoad         = HybridScrollFrameScrollDown_OnLoad    or function() end
end

-- -----------------------------------------------------------------------
-- Button atlas-setter stubs
-- SetNormalAtlas / SetPushedAtlas / SetDisabledAtlas / SetHighlightAtlas
-- were added after 3.3.5a.  LibSFDropDown uses them for the scroll-bar
-- up/down buttons inside the search frame (shown when lists have >20 items).
-- Stub them as no-ops so the buttons exist but are just invisible.
-- -----------------------------------------------------------------------
do
	local probe = CreateFrame("BUTTON")
	local mt = getmetatable(probe)
	if mt and mt.__index then
		local methods = mt.__index
		for _, m in next, {
			"SetNormalAtlas", "SetPushedAtlas",
			"SetDisabledAtlas", "SetHighlightAtlas",
		} do
			if not methods[m] then
				methods[m] = function() end
			end
		end
	end
end

-- -----------------------------------------------------------------------
-- SearchBoxTemplate_OnTextChanged
-- In 3.3.5a this global does not exist; provide a simple implementation
-- -----------------------------------------------------------------------
if not SearchBoxTemplateClearButton_OnClick then
	function SearchBoxTemplateClearButton_OnClick(self)
		local editBox = self:GetParent()
		editBox:SetText("")
		editBox:ClearFocus()
		self:Hide()
	end
end

if not SearchBoxTemplate_OnTextChanged then
	function SearchBoxTemplate_OnTextChanged(self)
		if self.clearButton then
			if self:GetText() ~= "" then
				self.clearButton:Show()
			else
				self.clearButton:Hide()
			end
		end
	end
end

-- -----------------------------------------------------------------------
-- Color-object method polyfills
-- In 3.3.5a, NORMAL_FONT_COLOR / GRAY_FONT_COLOR / etc. are plain tables
-- {r, g, b}.  Newer WoW code calls :WrapTextInColorCode() and :GetRGB().
-- -----------------------------------------------------------------------
local function patchColorTable(t, hexStr)
	if not t then return end
	if not t.WrapTextInColorCode then
		t.WrapTextInColorCode = function(_, text)
			return "|cff" .. hexStr .. text .. "|r"
		end
	end
	if not t.GetRGB then
		t.GetRGB = function(self)
			return self.r or 1, self.g or 1, self.b or 1
		end
	end
end

-- Patch well-known color tables (they are defined in GlobalStrings / FrameXML)
patchColorTable(NORMAL_FONT_COLOR,    "ffd200")
patchColorTable(GRAY_FONT_COLOR,      "808080")
patchColorTable(HIGHLIGHT_FONT_COLOR, "ffffff")
patchColorTable(RED_FONT_COLOR,       "ff1a1a")

-- BLACK_FONT_COLOR may not exist at all in 3.3.5a; create it if missing
if not BLACK_FONT_COLOR then
	BLACK_FONT_COLOR = {r = 0, g = 0, b = 0}
end
patchColorTable(BLACK_FONT_COLOR, "000000")

-- DARKGRAY_COLOR may not exist at all in 3.3.5a; create it if missing
if not DARKGRAY_COLOR then
	DARKGRAY_COLOR = {r = 0.4, g = 0.4, b = 0.4}
end
patchColorTable(DARKGRAY_COLOR, "666666")
