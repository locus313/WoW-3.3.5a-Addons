-- Compat335.lua
-- API compatibility shims for running ThreatPlates on the original WoW 3.3.5a
-- client (private / legacy servers). Must be the very first file loaded by the
-- TOC so that all upvalues in subsequent files resolve to our stubs.
--
-- Design: every stub is behind an individual  if not X then  guard so it only
-- activates when that specific API is absent. This is safe to run on any client
-- (3.3.5a originals, private servers, WotLK Classic re-release, Retail) because
-- no existing API is ever overwritten.

local ADDON_NAME, Addon = ...

-- ==========================================================================
-- 0.  xpcall argument-forwarding polyfill (Lua 5.1 / WoW 3.3.5a)
--     Lua 5.1's xpcall(f, handler, ...) silently ignores any extra arguments
--     after 'handler' and calls f() with no args.  Lua 5.2 added proper
--     forwarding.  Modern AceAddon-3.0 relies on this (safecall passes the
--     addon object as 'self'), so every Ace OnInitialize/OnEnable receives
--     self = nil in 3.3.5a.  We detect and fix this before Libs.xml loads.
-- ==========================================================================
do
  local _orig_xpcall = xpcall
  local _extra_arg_forwarded = false
  _orig_xpcall(
    function(x) _extra_arg_forwarded = (x == "compat_probe") end,
    function() end,
    "compat_probe"
  )
  if not _extra_arg_forwarded then
    xpcall = function(func, handler, ...)
      if select('#', ...) == 0 then
        return _orig_xpcall(func, handler)
      end
      local args = { ... }
      return _orig_xpcall(function() return func(unpack(args)) end, handler)
    end
  end
end

-- ==========================================================================
-- 1a. BackdropTemplate XML template probe
--     ChromieCraft's BlizRuntimeLib defines BackdropTemplateMixin (a Lua mixin
--     table), so Init.lua would set Addon.BackdropTemplate = "BackdropTemplate".
--     However the actual XML frame template "BackdropTemplate" is not registered
--     in the 3.3.5a client, meaning any CreateFrame(..., "BackdropTemplate")
--     call crashes with "Couldn't find inherited node".  Probe here (before
--     Init.lua runs) and nil out BackdropTemplateMixin when the template is
--     absent, so Init.lua leaves Addon.BackdropTemplate = nil.
-- ==========================================================================
do
  local ok = pcall(CreateFrame, "Frame", nil, nil, "BackdropTemplate")
  if not ok then
    BackdropTemplateMixin = nil
  end
end

-- ==========================================================================
-- 1.  Version detection constants
--     Init.lua derives IS_WRATH_CLASSIC etc. from these; we set them so that
--     the code follows the correct "WotLK Classic" code paths.
--     Use individual guards so we don't overwrite values the server already set.
-- ==========================================================================
if WOW_PROJECT_MAINLINE              == nil then WOW_PROJECT_MAINLINE              = 1   end
if WOW_PROJECT_CLASSIC               == nil then WOW_PROJECT_CLASSIC               = 2   end
if WOW_PROJECT_BURNING_CRUSADE_CLASSIC == nil then WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5 end
-- Only set WOW_PROJECT_ID when nothing else has (e.g. some private-server runtimes already set it)
if WOW_PROJECT_ID                    == nil then WOW_PROJECT_ID                    = 100 end

if LE_EXPANSION_CLASSIC                  == nil then LE_EXPANSION_CLASSIC                  = 0 end
if LE_EXPANSION_BURNING_CRUSADE          == nil then LE_EXPANSION_BURNING_CRUSADE          = 2 end
if LE_EXPANSION_WRATH_OF_THE_LICH_KING  == nil then LE_EXPANSION_WRATH_OF_THE_LICH_KING   = 3 end
if LE_EXPANSION_CATACLYSM               == nil then LE_EXPANSION_CATACLYSM                = 4 end
if LE_EXPANSION_MISTS_OF_PANDARIA       == nil then LE_EXPANSION_MISTS_OF_PANDARIA        = 5 end

-- Returns WotLK expansion index so IS_WRATH_CLASSIC becomes true
if not GetClassicExpansionLevel then
  function GetClassicExpansionLevel()
    return LE_EXPANSION_WRATH_OF_THE_LICH_KING
  end
end

-- ==========================================================================
-- 2.  Missing global utility functions
-- ==========================================================================

if not Lerp then
  function Lerp(startValue, endValue, amount)
    return startValue + (endValue - startValue) * amount
  end
end

-- UnitEffectiveLevel: Legion+; fall back to UnitLevel
if not UnitEffectiveLevel then
  function UnitEffectiveLevel(unitid)
    return UnitLevel(unitid) or 0
  end
end

-- UnitIsTapDenied replaced UnitIsTapped in MoP 5.0.4
if not UnitIsTapDenied then
  UnitIsTapDenied = UnitIsTapped or function() return false end
end

-- UnitNameplateShowsWidgetsOnly: Shadowlands+
if not UnitNameplateShowsWidgetsOnly then
  function UnitNameplateShowsWidgetsOnly(unitid) return false end
end

-- UnitSelectionColor: returns the RGB of the selection ring colour.
-- In 3.3.5a this API does not exist; derive a reasonable value from
-- UnitReaction so that GetReactionByColor fallback works correctly.
if not UnitSelectionColor then
  function UnitSelectionColor(unitid)
    local r = UnitReaction("player", unitid)
    if not r then return 1, 0, 0 end        -- unknown → hostile red
    if r > 4  then return 0, 1, 0 end        -- friendly → green
    if r == 4 then return 1, 1, 0 end        -- neutral  → yellow
    return 1, 0, 0                            -- hostile  → red
  end
end

-- GetPhysicalScreenSize: MoP+; only used for PixelPerfect UI scaling
if not GetPhysicalScreenSize then
  function GetPhysicalScreenSize() return 1920, 1080 end
end

-- CreateColor: Legion+. Returns a ColorMixin-like object.
-- Only GenerateHexColor is used by ThreatPlates (in RGB_WITH_HEX).
if not CreateColor then
  function CreateColor(r, g, b, a)
    local function toHex(v)
      return string.format("%02x", math.floor((v or 1) * 255 + 0.5))
    end
    local obj = { r = r or 0, g = g or 0, b = b or 0, a = a or 1 }
    function obj:GenerateHexColor()
      return toHex(self.a) .. toHex(self.r) .. toHex(self.g) .. toHex(self.b)
    end
    function obj:GetRGB() return self.r, self.g, self.b end
    function obj:GetRGBA() return self.r, self.g, self.b, self.a end
    return obj
  end
end

-- GetCurrentRegion / GetCurrentRegionName: not present on 3.3.5a private servers.
-- AceDB-3.0 uses these to build a per-region database key; default to US (1).
if not GetCurrentRegion then
  function GetCurrentRegion() return 1 end
end
if not GetCurrentRegionName then
  function GetCurrentRegionName() return "US" end
end

-- Enum: global namespace added in BfA; accessed by ChatThrottleLib and others
-- with the safe pattern  Enum.Foo or fallback  but that itself errors if Enum
-- is nil.  Provide an empty table so any Enum.X access returns nil gracefully.
if not Enum then
  Enum = {}
end

-- Enum.PowerType: BfA+. Numeric values match the Blizzard constants used by
-- UnitPower / UNIT_POWER_UPDATE and must be correct for 3.3.5a as well.
if not Enum.PowerType then
  Enum.PowerType = {
    Mana          = 0,
    Rage          = 1,
    Focus         = 2,
    Energy        = 3,
    ComboPoints   = 4,
    Runes         = 5,
    RunicPower    = 6,
    SoulShards    = 7,
    LunarPower    = 8,
    HolyPower     = 9,
    Alternate     = 10,
    Maelstrom     = 11,
    Chi           = 12,
    Insanity      = 13,
    ArcaneCharges = 16,
    Fury          = 17,
    Pain          = 18,
    Essence       = 19,
  }
end

-- ==========================================================================
-- 10.  C_FriendList  (BfA+)
--      In 3.3.5a these are plain global functions.
-- ==========================================================================
if not C_FriendList then
  C_FriendList = {
    ShowFriends          = ShowFriends          or function() end,
    GetNumFriends        = GetNumFriends        or function() return 0 end,
    GetNumOnlineFriends  = GetNumOnlineFriends  or function() return 0 end,
    -- GetFriendInfo returns: name, level, class, area, connected, status, note
    GetFriendInfo        = GetFriendInfo        or function(index) return nil end,
    AddFriend            = AddFriend            or function() end,
    RemoveFriend         = RemoveFriend         or function() end,
    GetFriendInfoByIndex = GetFriendInfoByIndex or function(index) return nil end,
  }
end

-- ==========================================================================
-- 9.  Object / Frame / Texture pools  (BfA+)
--     CreateTexturePool and CreateFramePool are used by LibCustomGlow-1.0.
--     Provide minimal pool implementations that simply create/recycle objects.
-- ==========================================================================
if not CreateTexturePool then
  function CreateTexturePool(parent, layer, sublevel, textureTemplate, resetter)
    local pool = {
      _parent    = parent,
      _layer     = layer or "ARTWORK",
      _sublevel  = sublevel or 0,
      _template  = textureTemplate,
      _resetter  = resetter,
      _inactive  = {},
      _active    = {},
    }
    function pool:Acquire()
      local tex = tremove(self._inactive)
      local isNew = tex == nil
      if isNew then
        tex = self._parent:CreateTexture(nil, self._layer, self._template, self._sublevel)
      end
      self._active[tex] = true
      return tex, isNew
    end
    function pool:Release(tex)
      if self._active[tex] then
        if self._resetter then self._resetter(self, tex) end
        self._active[tex] = nil
        tinsert(self._inactive, tex)
        return true
      end
      return false
    end
    function pool:ReleaseAll()
      for tex in pairs(self._active) do self:Release(tex) end
    end
    function pool:GetNumActive()
      local n = 0
      for _ in pairs(self._active) do n = n + 1 end
      return n
    end
    return pool
  end
end

if not CreateFramePool then
  function CreateFramePool(frameType, parent, template, resetter)
    local pool = {
      _frameType = frameType or "Frame",
      _parent    = parent,
      _template  = template,
      _resetter  = resetter,
      _inactive  = {},
      _active    = {},
    }
    function pool:Acquire()
      local frame = tremove(self._inactive)
      local isNew = frame == nil
      if isNew then
        frame = CreateFrame(self._frameType, nil, self._parent, self._template)
      end
      self._active[frame] = true
      return frame, isNew
    end
    function pool:Release(frame)
      if self._active[frame] then
        if self._resetter then self._resetter(self, frame) end
        self._active[frame] = nil
        tinsert(self._inactive, frame)
        return true
      end
      return false
    end
    function pool:ReleaseAll()
      for frame in pairs(self._active) do self:Release(frame) end
    end
    function pool:GetNumActive()
      local n = 0
      for _ in pairs(self._active) do n = n + 1 end
      return n
    end
    return pool
  end
end

-- GetSpecializationInfo / GetSpecialization / GetNumSpecializations: MoP+
-- WotLK uses talent trees; provide stubs so UI code doesn't error
if not GetSpecializationInfo then
  function GetSpecializationInfo(index)
    return index, "Unknown", "", 0, "", "DAMAGER"
  end
end
if not GetSpecialization then
  function GetSpecialization() return 1 end
end
if not GetNumSpecializations then
  function GetNumSpecializations() return 3 end
end

-- ==========================================================================
-- 3.  C_CVar  (Shadowlands namespace; maps to legacy GetCVar / SetCVar)
-- ==========================================================================
if not C_CVar then
  C_CVar = {
    GetCVar        = GetCVar,
    GetCVarDefault = GetCVarDefault,
    GetCVarBool    = function(name)
                       local v = GetCVar(name)
                       return v == "1" or v == "true"
                     end,
    RegisterCVar   = function(name) end,   -- no-op on original 3.x client
    SetCVar        = SetCVar,
  }
end

-- ==========================================================================
-- 4.  C_Timer  (WoD+; implement with an OnUpdate frame)
-- ==========================================================================
if not C_Timer then
  local _timers     = {}
  local _timerFrame = CreateFrame("Frame")
  _timerFrame:SetScript("OnUpdate", function(self, elapsed)
    if #_timers == 0 then return end
    local now = GetTime()
    for i = #_timers, 1, -1 do
      local t = _timers[i]
      if now >= t.expiry then
        table.remove(_timers, i)
        if not t.cancelled then
          t.func()
        end
      end
    end
  end)

  C_Timer = {
    After = function(seconds, func)
      if seconds <= 0 then
        func()
      else
        table.insert(_timers, {
          expiry    = GetTime() + seconds,
          func      = func,
          cancelled = false,
        })
      end
    end,
    NewTimer = function(seconds, func)
      local entry = { expiry = GetTime() + seconds, func = func, cancelled = false }
      table.insert(_timers, entry)
      return { Cancel = function() entry.cancelled = true end }
    end,
  }
end

-- ==========================================================================
-- 5.  C_PvP  (Shadowlands+; SoloShuffle not relevant in WotLK)
-- ==========================================================================
if not C_PvP then
  C_PvP = {
    IsSoloShuffle = function() return false end,
    IsInBrawl     = function() return false end,
  }
elseif not C_PvP.IsInBrawl then
  C_PvP.IsInBrawl = function() return false end
end

-- ==========================================================================
-- 6.  NamePlateDriverFrame stub  (modern UI driver; not present in 3.x)
-- ==========================================================================
if not NamePlateDriverFrame then
  NamePlateDriverFrame = {}
end

-- ==========================================================================
-- 7.  CombatLogGetCurrentEventInfo  (Legion+)
--     In 3.3.5a the COMBAT_LOG_EVENT_UNFILTERED handler receives its data as
--     varargs; we capture them here so handlers that call this function work.
--     Note: WotLK did not have the "hideCaster" field (added in 4.0.1), so we
--     insert nil at position 3 to match the modern return signature.
-- ==========================================================================
if not CombatLogGetCurrentEventInfo then
  local _cleuArgs = nil

  local _cleuCapture = CreateFrame("Frame")
  _cleuCapture:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  _cleuCapture:SetScript("OnEvent", function(self, event, ...)
    _cleuArgs = { ... }
  end)

  function CombatLogGetCurrentEventInfo()
    if not _cleuArgs then return nil end
    -- WoW 3.x CLEU: timestamp, subevent, sourceGUID, sourceName, sourceFlags,
    --               sourceRaidFlags, destGUID, destName, destFlags,
    --               destRaidFlags[, spellParams...]
    -- Modern API inserts hideCaster at position 3. We insert nil to match.
    return _cleuArgs[1], _cleuArgs[2], nil, unpack(_cleuArgs, 3)
  end
end

-- ==========================================================================
-- 8.  C_NamePlate  (Legion+)
--
--     In WoW 3.3.5a, Blizzard creates nameplate frames as children of
--     WorldFrame named "NamePlate1" .. "NamePlate40", and nameplate unit IDs
--     "nameplate1" .. "nameplate40" are valid for unit queries.
--
--     We scan WorldFrame children to discover these frames, synthesise the
--     events  NAME_PLATE_CREATED / NAME_PLATE_UNIT_ADDED / _REMOVED  that
--     ThreatPlates expects, and expose C_NamePlate.GetNamePlateForUnit.
-- ==========================================================================
if not C_NamePlate then
  local _plateByUnit = {}   -- "nameplate1" → frame
  local _unitByPlate = {}   -- frame         → "nameplate1"
  local _knownPlates = {}   -- frame         → true  (already processed)

  -- Fire a synthetic event through ThreatPlates' own event dispatcher.
  -- Addon.EventHandler is populated by TidyPlatesCore.lua at load time; by
  -- the time our OnUpdate fires at runtime, it will already be set.
  local function _FireNameplateEvent(event, ...)
    local h = Addon.EventHandler
    if h and h[event] then
      h[event](event, ...)
    end
  end

  -- "NamePlate3" → "nameplate3"
  local function _GetUnitIdForFrame(frame)
    local name = frame:GetName()
    if name then
      local n = name:match("^NamePlate(%d+)$")
      if n then return "nameplate" .. n end
    end
    return nil
  end

  -- Hide / show all visual children of a Blizzard nameplate frame so that
  -- ThreatPlates' custom overlay can display exclusively.
  -- We leave the plate Frame itself visible so its world-space position keeps
  -- updating and TPFrame (anchored to it) moves correctly.
  local function _SetBlizzardChildrenShown(plate, shown, skipFrame)
    for _, child in ipairs({ plate:GetChildren() }) do
      if child ~= skipFrame then
        if shown then child:Show() else child:Hide() end
      end
    end
    for _, region in ipairs({ plate:GetRegions() }) do
      if shown then region:Show() else region:Hide() end
    end
  end

  -- Build a lightweight proxy that looks like the modern "UnitFrame" child of
  -- a Classic nameplate.  ThreatPlates calls Show/Hide/SetShown/HookScript on
  -- it to toggle Blizzard plate visibility; it also reads .unit for the token.
  local function _CreateUnitFrameProxy(plate, unitid)
    if plate.UnitFrame then
      plate.UnitFrame.unit = unitid
      return plate.UnitFrame
    end

    local proxy = {}
    proxy.unit       = unitid
    proxy.ThreatPlates = false
    proxy.WidgetContainer = nil   -- no widget container in 3.x

    -- Stubs expected by various ThreatPlates code paths
    function proxy:IsForbidden() return false end
    proxy.LevelFrame = { SetAlpha = function() end }
    proxy.BuffFrame  = { Hide = function() end, Show = function() end }

    -- Visibility: manipulate the Blizzard children, not the plate alpha, so
    -- that the occlusion detection (which reads plate:GetAlpha()) still works.
    function proxy:Hide()
      _SetBlizzardChildrenShown(plate, false, proxy)
    end
    function proxy:Show()
      _SetBlizzardChildrenShown(plate, true, proxy)
    end
    function proxy:SetShown(v) if v then proxy:Show() else proxy:Hide() end end
    function proxy:IsShown() return plate:IsShown() end
    function proxy:GetParent() return plate end

    -- HookScript: delegate to the real plate frame but pass proxy as "self" to
    -- the handler, matching modern UnitFrame:HookScript behaviour.
    function proxy:HookScript(scriptType, handler)
      plate:HookScript(scriptType, function(frame, ...)
        handler(proxy, ...)
      end)
    end

    plate.UnitFrame = proxy
    return proxy
  end

  -- ── plate show/hide handlers ────────────────────────────────────────────

  local function _OnPlateShow(plate)
    local unitid = _GetUnitIdForFrame(plate)
    if unitid and UnitExists(unitid) then
      _plateByUnit[unitid] = plate
      _unitByPlate[plate]  = unitid
      _CreateUnitFrameProxy(plate, unitid)
      _FireNameplateEvent("NAME_PLATE_UNIT_ADDED", unitid)
    end
  end

  local function _OnPlateHide(plate)
    local unitid = _unitByPlate[plate]
    if unitid then
      _plateByUnit[unitid] = nil
      _unitByPlate[plate]  = nil
      if plate.UnitFrame then
        plate.UnitFrame.unit = nil
      end
      _FireNameplateEvent("NAME_PLATE_UNIT_REMOVED", unitid)
    end
  end

  -- ── WorldFrame scanner ──────────────────────────────────────────────────
  -- Polls for new "NamePlateN" children and synthesises NAME_PLATE_CREATED.
  -- Hooks are registered BEFORE firing NAME_PLATE_CREATED so that _OnPlateShow
  -- runs before the FrameOnShow handler that ThreatPlates registers inside the
  -- NAME_PLATE_CREATED callback.

  local _scanFrame    = CreateFrame("Frame")
  local _scanClock    = 0
  local SCAN_INTERVAL = 0.1

  _scanFrame:SetScript("OnUpdate", function(self, elapsed)
    _scanClock = _scanClock + elapsed
    if _scanClock < SCAN_INTERVAL then return end
    _scanClock = 0

    for _, child in ipairs({ WorldFrame:GetChildren() }) do
      if not _knownPlates[child] then
        local name = child:GetName()
        if name and name:match("^NamePlate%d+$") then
          _knownPlates[child] = true

          -- Register show/hide callbacks first so _OnPlateShow fires before
          -- any FrameOnShow hook ThreatPlates adds in NAME_PLATE_CREATED.
          child:HookScript("OnShow", _OnPlateShow)
          child:HookScript("OnHide", _OnPlateHide)

          -- Pre-create the UnitFrame proxy so NAME_PLATE_CREATED can find it.
          local unitid = _GetUnitIdForFrame(child)
          if unitid then
            _CreateUnitFrameProxy(child, unitid)
          end

          _FireNameplateEvent("NAME_PLATE_CREATED", child)

          -- If the plate is already visible synthesise UNIT_ADDED immediately.
          if child:IsShown() and unitid and UnitExists(unitid) then
            _plateByUnit[unitid] = child
            _unitByPlate[child]  = unitid
            _FireNameplateEvent("NAME_PLATE_UNIT_ADDED", unitid)
          end
        end
      end
    end
  end)

  -- ── Public C_NamePlate API ──────────────────────────────────────────────

  C_NamePlate = {}

  C_NamePlate.GetNamePlateForUnit = function(unitid, isLargePlate)
    if not unitid then return nil end
    if _plateByUnit[unitid] then return _plateByUnit[unitid] end

    -- Fallback: direct frame-name lookup (handles stale / not-yet-mapped state)
    local n = unitid:match("^nameplate(%d+)$")
    if n then
      local frame = _G["NamePlate" .. n]
      if frame and frame:IsShown() then
        if not _unitByPlate[frame] then
          _plateByUnit[unitid] = frame
          _unitByPlate[frame]  = unitid
        end
        return frame
      end
    end
    return nil
  end

  C_NamePlate.GetNamePlates = function(isLargeNamePlates)
    local plates = {}
    for _, frame in pairs(_plateByUnit) do
      table.insert(plates, frame)
    end
    return plates
  end

  -- Size / click-through functions: the corresponding CVars do not exist in 3.x
  C_NamePlate.SetNamePlateFriendlySize         = function() end
  C_NamePlate.SetNamePlateEnemySize            = function() end
  -- Return the default Blizzard nameplate size for 3.x (128 × 32)
  C_NamePlate.GetNamePlateFriendlySize         = function() return 128, 32 end
  C_NamePlate.GetNamePlateEnemySize            = function() return 128, 32 end
  C_NamePlate.SetNamePlateFriendlyClickThrough = function() end
  C_NamePlate.SetNamePlateEnemyClickThrough    = function() end
  C_NamePlate.GetNamePlateFriendlyClickThrough = function() return false end
  C_NamePlate.GetNamePlateEnemyClickThrough    = function() return false end
end

-- ── Section 13: C_QuestLog ────────────────────────────────────────────────
-- QuestWidget.lua captures these upvalues at load time; the widget itself is
-- disabled for non-mainline but the file-scope code still runs.
if not C_QuestLog then
  C_QuestLog = {}
  -- Map to 3.3.5a globals where possible
  C_QuestLog.GetNumQuestLogEntries = function()
    local numEntries, numQuests = GetNumQuestLogEntries()
    return numEntries, numQuests
  end
  C_QuestLog.RequestLoadQuestByID = function() end  -- quests always loaded in 3.x
  C_QuestLog.GetQuestObjectives = function(questID)
    return {}  -- widget disabled; stub never actually called
  end
  C_QuestLog.GetInfo = function(questIndex)
    return nil  -- widget disabled; stub never actually called
  end
  C_QuestLog.GetLogIndexForQuestID = function(questID)
    -- Linear scan of the quest log to find a matching quest ID
    local numEntries = GetNumQuestLogEntries()
    for i = 1, numEntries do
      local _, _, _, _, _, _, _, id = GetQuestLogTitle(i)
      if id == questID then return i end
    end
    return nil
  end
end

-- ── Section 14: C_UIWidgetManager ────────────────────────────────────────
-- ExperienceWidget.lua upvalues C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo
-- at file scope; the widget itself is disabled for non-mainline, but the upvalue
-- capture still executes.
if not C_UIWidgetManager then
  C_UIWidgetManager = {
    GetStatusBarWidgetVisualizationInfo = function() return nil end,
  }
end

-- ── Section 15: Battle.net stubs ─────────────────────────────────────────
-- SocialWidget calls BN_CONNECTED directly in OnEnable, which calls BNGetNumFriends.
-- These functions don't exist on 3.3.5a private servers.
if not BNGetNumFriends then
  BNGetNumFriends = function() return 0, 0 end
end
if not BNGetGameAccountInfo then
  BNGetGameAccountInfo = function() return nil end
end
if not BNGetFriendInfo then
  BNGetFriendInfo = function() return nil end
end
if not BNGetFriendInfoByID then
  BNGetFriendInfoByID = function() return nil end
end

-- ── Section 16: Misc unit API stubs ──────────────────────────────────────
-- UnitIsOwnerOrControllerOfUnit added in Legion; used in a debug log in Init.lua.
if not UnitIsOwnerOrControllerOfUnit then
  UnitIsOwnerOrControllerOfUnit = function(unit1, unit2)
    return UnitIsUnit(unit1, unit2) or UnitIsUnit(unit1 .. "pet", unit2)
  end
end

-- ── Section 17: PixelUtil ─────────────────────────────────────────────────
-- PixelUtil (Legion+) snaps frames to pixel-perfect boundaries.
-- On 3.3.5a a plain SetPoint/SetSize is close enough; sub-pixel accuracy
-- doesn't matter on the classic client.
if not PixelUtil then
  PixelUtil = {
    SetPoint = function(region, point, relativeTo, relativePoint, x, y)
      region:SetPoint(point, relativeTo, relativePoint, x or 0, y or 0)
    end,
    SetWidth = function(region, width)
      region:SetWidth(width)
    end,
    SetHeight = function(region, height)
      region:SetHeight(height)
    end,
    SetSize = function(region, width, height)
      region:SetSize(width, height)
    end,
  }
end

-- ── Section 18: Chat/Comm API stubs ──────────────────────────────────────
-- RegisterAddonMessagePrefix was added in Cataclysm (4.0.1).
-- In WoW 3.3.5a, addon message channels are always open and no registration
-- is needed.  AceComm-3.0 (used by ThreatPlates and many other addons) calls
-- this when C_ChatInfo is absent, so we provide a no-op global so every
-- addon's bundled AceComm copy works without crashing.
if not RegisterAddonMessagePrefix then
  RegisterAddonMessagePrefix = function() end
end

-- Ambiguate(name, context) was added in MoP (5.0) to strip realm suffixes
-- from cross-realm player names ("Player-Realm" → "Player").  In 3.3.5a all
-- names are already plain, so just return the name unchanged.
if not Ambiguate then
  Ambiguate = function(name, context)
    return name or ""
  end
end
