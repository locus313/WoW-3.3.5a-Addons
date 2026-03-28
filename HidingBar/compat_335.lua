-- WoW 3.3.5a Compatibility Shim for HidingBar
-- Provides polyfills for APIs added after 3.3.5a

-- securecallfunction polyfill
-- Added after 3.3.5a; used by CallbackHandler-1.0 to fire callbacks.
-- In 3.3.5a we just call the function directly (no taint protection needed).
if not securecallfunction then
	securecallfunction = function(func, ...)
		return func(...)
	end
end

-- C_Timer.After polyfill
-- Used for delayed function execution
if not C_Timer then
	C_Timer = {}
end
if not C_Timer.After then
	C_Timer.After = function(delay, func)
		local f = CreateFrame("Frame")
		local elapsed = 0
		f:SetScript("OnUpdate", function(self, e)
			elapsed = elapsed + e
			if elapsed >= delay then
				self:SetScript("OnUpdate", nil)
				func()
			end
		end)
	end
end

-- C_Texture polyfill (atlases don't exist in 3.3.5a)
if not C_Texture then
	C_Texture = {
		GetAtlasInfo = function() return nil end,
	}
end

-- C_AddOns polyfill
if not C_AddOns then
	C_AddOns = {
		GetAddOnMetadata = GetAddOnMetadata,
		IsAddOnLoaded    = IsAddOnLoaded,
		EnableAddOn      = EnableAddOn,
		LoadAddOn        = LoadAddOn,
	}
end

-- GetPhysicalScreenSize polyfill
-- In 3.3.5a the physical screen size is the same as the virtual screen width
if not GetPhysicalScreenSize then
	GetPhysicalScreenSize = function()
		return GetScreenWidth(), GetScreenHeight()
	end
end

-- BackdropTemplateMixin / CreateFromMixins polyfill
-- In 3.3.5a frames already have native backdrop support, no mixin needed
if not BackdropTemplateMixin then
	BackdropTemplateMixin = {}
end

if not CreateFromMixins then
	function CreateFromMixins(...)
		local result = {}
		for i = 1, select("#", ...) do
			local mixin = select(i, ...)
			if mixin then
				for k, v in pairs(mixin) do
					result[k] = v
				end
			end
		end
		return result
	end
end

-- Polyfill missing Frame methods for WoW 3.3.5a
-- Strategy:
--   1. Try to patch via the frame metatable __index (works if it's a Lua table).
--   2. Add the same stubs as direct instance-level methods on a shared probe
--      frame — HidingBar uses `hb.METHOD(frame)` where hb is itself a Frame,
--      so adding them directly to the probe object also covers that callsite.
do
	local noop        = function() end
	local returnFalse = function() return false end
	local returnNil   = function() return nil end

	local stubs = {
		-- query stubs
		IsIgnoringParentScale = returnFalse,
		HasFixedFrameStrata   = returnFalse,
		HasFixedFrameLevel    = returnFalse,
		DoesClipChildren      = returnFalse,
		-- setter stubs
		SetClipsChildren      = noop,
		SetFixedFrameStrata   = noop,
		SetFixedFrameLevel    = noop,
		SetIgnoreParentScale  = noop,   -- called via hb:setParams
		-- mouse stubs
		IsMouseMotionEnabled  = function(self) return self:IsMouseEnabled() end,
		IsMouseClickEnabled   = function(self) return self:IsMouseEnabled() end,
		SetMouseMotionEnabled = function(self, v) if v then self:EnableMouse(true) end end,
		SetMouseClickEnabled  = function(self, v) if v then self:EnableMouse(true) end end,
		-- SetShown: added after 3.3.5a
		SetShown              = function(self, show) if show then self:Show() else self:Hide() end end,
	}

	for _, ftype in next, { "Frame", "Button" } do
		local probe = CreateFrame(ftype)
		local mt = getmetatable(probe)
		if mt and type(mt.__index) == "table" then
			local methods = mt.__index
			for name, fn in next, stubs do
				if not methods[name] then
					methods[name] = fn
				end
			end
			break  -- all frame types share one metatable; one pass is enough
		end
	end
end

-- Texture method polyfills (SetColorTexture, SetRotation, GetAtlas, SetAtlas,
-- SetScale)
-- Try via metatable; callers also guard at the usage site via pcall where needed.
do
	local probe = CreateFrame("Frame"):CreateTexture()
	local mt = getmetatable(probe)
	if mt and type(mt.__index) == "table" then
		local tex = mt.__index
		if not probe.SetColorTexture then
			tex.SetColorTexture = function(self, r, g, b, a)
				self:SetTexture("Interface\\Buttons\\WHITE8X8")
				self:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
			end
		end
		if not probe.SetRotation then tex.SetRotation = function() end end
		if not probe.GetAtlas then tex.GetAtlas = function() return nil end end
		if not probe.SetAtlas then tex.SetAtlas = function() end end
		-- SetScale was added to Region/Texture after 3.3.5a.
		-- Emulate via SetSize: capture the pre-scale size on first call, restore
		-- it when scale is reset to 1.  HidingBar only ever calls SetScale(0.9)
		-- (press) and SetScale(1) (release), so this covers the full use-case.
		if not probe.SetScale then
			tex.SetScale = function(self, scale)
				if scale == 1 then
					if self._hb_baseW then
						self:SetSize(self._hb_baseW, self._hb_baseH)
						self._hb_baseW = nil
						self._hb_baseH = nil
					end
				else
					if not self._hb_baseW then
						local w, h = self:GetSize()
						if w > 0 and h > 0 then
							self._hb_baseW = w
							self._hb_baseH = h
						end
					end
					if self._hb_baseW then
						self:SetSize(self._hb_baseW * scale, self._hb_baseH * scale)
					end
				end
			end
		end
	end
end

-- Fallback: if metatable patching didn't work, define global helper wrappers
-- that HidingBar.lua can call. HidingBar.lua already guards SetMouseClickEnabled
-- and SetColorTexture is accessed on texture objects — we can't easily patch
-- those without metatable access, but we set up the polyfills as best we can.
if not SetColorTexture then
	-- Global shim (not method): won't fix obj:SetColorTexture(), but
	-- helps confirm the polyfill infrastructure is loaded.
	SetColorTexture = function(tex, r, g, b, a)
		tex:SetTexture("Interface\\Buttons\\WHITE8X8")
		tex:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
	end
end

-- AnimationGroup polyfill for WoW 3.3.5a
-- WoW 3.3.5a has CreateAnimationGroup natively, but some Alpha animation
-- methods were added in later patches (SetFromAlpha, SetToAlpha, SetStartDelay,
-- SetToFinalAlpha).  We add ONLY the missing methods to the native animation
-- object metatables so all other animation methods (SetChange, etc.) still work.
-- We do NOT replace CreateAnimationGroup — that would break addons like Details
-- that rely on the full native animation API.
-- LibDBIcon is also patched directly (see guarded calls in LibDBIcon-1.0.lua).
do
	local noop = function() end

	local f  = CreateFrame("Frame")
	-- Native AnimationGroup: add SetToFinalAlpha if missing
	local ag = f:CreateAnimationGroup()
	local ag_mt = getmetatable(ag)
	if ag_mt and type(ag_mt.__index) == "table" then
		if not ag.SetToFinalAlpha then ag_mt.__index.SetToFinalAlpha = noop end
	end

	-- Native Alpha animation: add SetFromAlpha/SetToAlpha/SetStartDelay if missing
	local ok, anim = pcall(function() return ag:CreateAnimation("Alpha") end)
	if ok and anim then
		local mt = getmetatable(anim)
		if mt and type(mt.__index) == "table" then
			local amethods = mt.__index
			if not anim.SetFromAlpha  then amethods.SetFromAlpha  = noop end
			if not anim.SetToAlpha    then amethods.SetToAlpha    = noop end
			if not anim.SetStartDelay then amethods.SetStartDelay = noop end
		end
	end
end

-- WOW_PROJECT_ID / WOW_PROJECT_MAINLINE constants
-- Ensure LibDBIcon uses the non-mainline code path (correct for WoW 3.3.5a / WotLK)
if not WOW_PROJECT_ID then      WOW_PROJECT_ID       = 0 end   -- unknown / classic
if not WOW_PROJECT_MAINLINE then WOW_PROJECT_MAINLINE = 1 end   -- retail sentinel
-- Result: 0 ~= 1, so the WotLK branch in LibDBIcon is taken
