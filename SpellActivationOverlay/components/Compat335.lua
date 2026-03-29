-- Compat335.lua
-- API compatibility shims for running SpellActivationOverlay on the original
-- WoW 3.3.5a client (private / legacy servers). Must be loaded before all
-- other addon files so that every upvalue in subsequent files resolves to the
-- correct stub.
--
-- Design: every stub is behind an individual  if not X then  guard so it only
-- activates when that specific API is absent. This is safe to run on any client
-- (3.3.5a originals, WotLK Classic re-release, etc.) because no existing API
-- is ever overwritten.

-- Capture the addon namespace the same way every other file in this addon does.
-- SAO is NOT a global — it is the shared namespace table passed via varargs.
-- By the time any slash command or event handler runs, the table is fully
-- populated by the other files that loaded after this one.
local AddonName, SAO = ...

-- ==========================================================================
-- 1.  WOW_PROJECT version-detection constants
--     project.lua derives SAO.IsWrath() etc. from these.  We set them so that
--     the addon follows the "Wrath of the Lich King" code paths on any client
--     that hasn't already defined them (i.e. the original 3.3.5a client).
--     Only WOW_PROJECT_ID needs to equal WOW_PROJECT_WRATH_CLASSIC for
--     SAO.IsWrath() to return true.
-- ==========================================================================
if WOW_PROJECT_MAINLINE              == nil then WOW_PROJECT_MAINLINE              = 1   end
if WOW_PROJECT_CLASSIC               == nil then WOW_PROJECT_CLASSIC               = 2   end
if WOW_PROJECT_BURNING_CRUSADE_CLASSIC == nil then WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5 end
if WOW_PROJECT_CATACLYSM_CLASSIC     == nil then WOW_PROJECT_CATACLYSM_CLASSIC     = 14  end
if WOW_PROJECT_MISTS_CLASSIC         == nil then WOW_PROJECT_MISTS_CLASSIC         = 19  end

-- Force WOW_PROJECT_WRATH_CLASSIC and WOW_PROJECT_ID unconditionally.
-- Private 3.3.5a servers may define WOW_PROJECT_ID to a non-standard value
-- (e.g. 1 or 0), which would make SAO.IsWrath() return false and prevent
-- any effects from being registered.  Since this addon's TOC interface is
-- 30300 (only loads on 3.3.5a clients), it is always safe to override both.
WOW_PROJECT_WRATH_CLASSIC = 11
WOW_PROJECT_ID            = 11

-- ==========================================================================
-- 2.  CombatLogGetCurrentEventInfo  (Cataclysm+)
--     In 3.3.5a the COMBAT_LOG_EVENT_UNFILTERED payload is passed as
--     arguments directly to the event handler.  The Cataclysm C function does
--     not exist.  All class files capture it as a local upvalue at load time,
--     so we must define the global HERE, before any other file is loaded.
--
--     Implementation:
--     Register a dedicated frame for COMBAT_LOG_EVENT_UNFILTERED right now,
--     at top-level load time, so it is registered BEFORE the SAO addon frame
--     (which is created later when SpellActivationOverlay.xml is parsed).
--     WoW fires handlers in registration order, so our frame always runs first
--     and _cleuArgs is populated before any SAO dispatcher calls the handler.
--
--     We unconditionally override CombatLogGetCurrentEventInfo so that even
--     if another addon (e.g. WeakAuras) installed a broken stub, SAO always
--     gets the correct payload via our locally-stored args.
-- ==========================================================================
do
    local _cleuArgs = {}
    local _cleuArgCount = 0

    -- Aura cache: tracks player aura stacks from CLEU so that
    -- GetPlayerAuraBySpellID can return the right value even before
    -- UnitAura is updated (3.3.5a fires CLEU before the aura list refreshes).
    -- Key = spellID (number), value = current stack count (number) or nil.
    local _auraCache = {}
    -- Spells ever seen in CLEU for the player.  Once a spell ID appears here
    -- we stop falling back to UnitAura name-scan for that spell ID — the CLEU
    -- cache is authoritative.  This prevents other rank-buckets (47383, 71162)
    -- of the same-named buff from spuriously activating when only one rank
    -- (e.g. 71165) was actually applied by the server.
    local _seenSpells = {}

    local _cleuStore = CreateFrame("Frame")
    _cleuStore:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    _cleuStore:SetScript("OnEvent", function(self, event, ...)
        -- The 3.3.5a CLEU payload (passed as handler varargs) has 8 base fields:
        --   1=timestamp, 2=subevent, 3=srcGUID, 4=srcName, 5=srcFlags,
        --   6=dstGUID, 7=dstName, 8=dstFlags,  9+=spell-specific
        --
        -- The addon was written for the Cata+ 11-field format:
        --   1=timestamp, 2=subevent, 3=hideCaster, 4=srcGUID, 5=srcName,
        --   6=srcFlags, 7=srcRaidFlags, 8=dstGUID, 9=dstName, 10=dstFlags,
        --   11=dstRaidFlags, 12+=spell-specific
        --
        -- Transform by inserting the 3 missing fields so all callers that use
        -- positional offsets (e.g. select(8,...) for dstGUID, select(12,...) for
        -- spellID) get the right values.
        local nRaw = select('#', ...)
        _cleuArgs[1]  = select(1, ...)  -- timestamp
        _cleuArgs[2]  = select(2, ...)  -- subevent
        _cleuArgs[3]  = nil             -- hideCaster (absent in 3.3.5a)
        _cleuArgs[4]  = select(3, ...)  -- srcGUID
        _cleuArgs[5]  = select(4, ...)  -- srcName
        _cleuArgs[6]  = select(5, ...)  -- srcFlags
        _cleuArgs[7]  = 0               -- srcRaidFlags (absent in 3.3.5a)
        _cleuArgs[8]  = select(6, ...)  -- dstGUID
        _cleuArgs[9]  = select(7, ...)  -- dstName
        _cleuArgs[10] = select(8, ...)  -- dstFlags
        _cleuArgs[11] = 0               -- dstRaidFlags (absent in 3.3.5a)
        -- Spell-specific tail: raw positions 9+ become Cata+ positions 12+
        local nTail = nRaw - 8
        for i = 1, nTail do
            _cleuArgs[11 + i] = select(8 + i, ...)
        end
        _cleuArgCount = 11 + nTail

        -- Keep _auraCache in sync so GetPlayerAuraBySpellID can return correct
        -- stacks immediately, before UnitAura reflects the change.
        -- Raw args: 2=subevent, 6=dstGUID, 9=spellID, 13=amount (DOSE only)
        local subevent = select(2, ...)
        local dstGUID  = select(6, ...)
        if dstGUID == UnitGUID("player") then
            local spellId = select(9, ...)
            if spellId then
                if subevent == "SPELL_AURA_APPLIED" then
                    -- First application: exactly 1 stack
                    _seenSpells[spellId] = true
                    _auraCache[spellId] = 1
                elseif subevent == "SPELL_AURA_APPLIED_DOSE" then
                    -- Additional dose; raw arg 13 = new count
                    _seenSpells[spellId] = true
                    local amount = select(13, ...)
                    _auraCache[spellId] = amount or ((_auraCache[spellId] or 0) + 1)
                elseif subevent == "SPELL_AURA_REMOVED" then
                    _seenSpells[spellId] = true
                    _auraCache[spellId] = nil
                elseif subevent == "SPELL_AURA_REMOVED_DOSE" then
                    _seenSpells[spellId] = true
                    local amount = select(13, ...)
                    local newCount = amount or ((_auraCache[spellId] or 1) - 1)
                    _auraCache[spellId] = (newCount > 0) and newCount or nil
                end
                -- SPELL_AURA_REFRESH: stacks unchanged, no cache update needed

                -- DEBUG: print any SPELL_AURA_* on player to chat
                if _SAO_Debug335 then
                    print("|cffFFFF00[SAO335]|r CLEU "..tostring(subevent)
                        .." spellId="..tostring(spellId)
                        .." cache="..tostring(_auraCache[spellId]))
                end
            end
        end
    end)

    -- Always override so aurastacks.lua (which calls the global directly,
    -- not a local upvalue) always gets the args stored above.
    function CombatLogGetCurrentEventInfo()
        return unpack(_cleuArgs, 1, _cleuArgCount)
    end

    -- Expose the cache for C_UnitAuras.GetPlayerAuraBySpellID (section 11).
    _SAO_AuraCache = _auraCache
    -- Expose the "seen" set so Section 11 can avoid spurious UnitAura hits.
    _SAO_SeenSpells = _seenSpells
end

-- ==========================================================================
-- 3.  Color utility functions
--     WrapTextInColorCode / WrapTextInColor were added in Cataclysm.
--     3.3.5a only has raw color escape codes; provide the wrappers here.
--     Also provide the color-object globals that util.lua uses for
--     Error / Warn / Info messages.
-- ==========================================================================
if not WrapTextInColorCode then
    function WrapTextInColorCode(text, colorCode)
        -- colorCode is an 8-char AARRGGBB hex string (e.g. "ffff2020")
        return "|c" .. (colorCode or "ffffffff") .. (text or "") .. "|r"
    end
end

if not WrapTextInColor then
    function WrapTextInColor(text, colorObj)
        if type(colorObj) == "table" then
            local r = math.floor((colorObj.r or 1) * 255 + 0.5)
            local g = math.floor((colorObj.g or 1) * 255 + 0.5)
            local b = math.floor((colorObj.b or 1) * 255 + 0.5)
            return WrapTextInColorCode(text, string.format("ff%02x%02x%02x", r, g, b))
        end
        return text or ""
    end
end

-- Color objects used by SAO:Error / Warn / Info
if not RED_FONT_COLOR   then RED_FONT_COLOR   = { r = 0.93, g = 0.12, b = 0.12 } end
if not WARNING_FONT_COLOR then WARNING_FONT_COLOR = { r = 1.00, g = 0.77, b = 0.00 } end
if not LIGHTBLUE_FONT_COLOR then LIGHTBLUE_FONT_COLOR = { r = 0.28, g = 0.90, b = 1.00 } end
if not GREEN_FONT_COLOR then GREEN_FONT_COLOR = { r = 0.10, g = 1.00, b = 0.10 } end

-- ==========================================================================
-- 4.  C_Timer  (not present on 3.3.5a)
--     Provides NewTimer and NewTicker using a Frame OnUpdate driver.
--     Both return an object with a Cancel() method.
-- ==========================================================================
if not C_Timer then
    C_Timer = {}

    local _timerFrame = CreateFrame("Frame")
    local _timers = {}

    _timerFrame:Hide()
    _timerFrame:SetScript("OnUpdate", function(self, elapsed)
        local now = GetTime()
        local alive = {}
        for _, t in ipairs(_timers) do
            if not t.cancelled then
                if now >= t.fireTime then
                    t.func()
                    if t.repeating then
                        -- Repeating ticker: reschedule
                        if t.maxIterations then
                            t.iterationsDone = (t.iterationsDone or 0) + 1
                            if t.iterationsDone >= t.maxIterations then
                                t.cancelled = true
                            end
                        end
                        if not t.cancelled then
                            t.fireTime = t.fireTime + t.interval
                            alive[#alive + 1] = t
                        end
                    end
                    -- one-shot timers just drop out
                else
                    alive[#alive + 1] = t
                end
            end
        end
        _timers = alive
        if #_timers == 0 then
            self:Hide()
        end
    end)

    local function _addTimer(t)
        _timers[#_timers + 1] = t
        _timerFrame:Show()
    end

    function C_Timer.NewTimer(delay, func)
        local t = {
            fireTime  = GetTime() + delay,
            func      = func,
            repeating = false,
            cancelled = false,
        }
        _addTimer(t)
        return { Cancel = function() t.cancelled = true end }
    end

    function C_Timer.NewTicker(interval, func, maxIterations)
        local t = {
            fireTime       = GetTime() + interval,
            func           = func,
            repeating      = true,
            interval       = interval,
            cancelled      = false,
            maxIterations  = maxIterations,
            iterationsDone = 0,
        }
        _addTimer(t)
        return { Cancel = function() t.cancelled = true end }
    end
end

-- ==========================================================================
-- 5.  strlenutf8  (not available on all 3.3.5a builds)
--     Used in InterfaceOptionsPanels.lua for rough pixel-width estimation.
--     A byte-count fallback is acceptable for this non-critical use.
-- ==========================================================================
if not strlenutf8 then
    function strlenutf8(str)
        -- Count UTF-8 multi-byte sequences: each leading byte starts a char
        local _, n = string.gsub(str or "", "[^\128-\191]", "")
        return n
    end
end

-- ==========================================================================
-- 6.  Missing global localization strings
--     These are used in the options panel for display purposes only.
--     Providing safe fallbacks avoids nil errors at runtime.
-- ==========================================================================
if not BNET_FRIEND_ZONE_WOW_CLASSIC then
    -- Format string: "World of Warcraft: %s" - used in options build display
    BNET_FRIEND_ZONE_WOW_CLASSIC = "World of Warcraft: %s"
end
if not BNET_FRIEND_TOOLTIP_WOW_CLASSIC then
    BNET_FRIEND_TOOLTIP_WOW_CLASSIC = "World of Warcraft Classic"
end
if not KBASE_RECENTLY_UPDATED then
    KBASE_RECENTLY_UPDATED = "Recently Updated"
end

-- GlobalStrings used by tr.lua that were added in Cataclysm or are
-- absent from the 3.3.5a client's BlizRuntimeLib.
--   RACE_CLASS_ONLY  – "X only"         (tr.lua:OnlyFor)
--   STACKS           – "N stacks"        (tr.lua:NbStacks)
--   CALENDAR_TOOLTIP_DATE_RANGE – "A – B" range (tr.lua:NbStacks)
--   HEALTH_COST_PCT  – "%s%% Health"     (tr.lua:ExecuteBelow)
--   FROM             – "From"            (tr.lua:FromClass)
if not RACE_CLASS_ONLY              then RACE_CLASS_ONLY              = "%s only"        end
if not STACKS                       then STACKS                       = "%d stacks"      end
if not CALENDAR_TOOLTIP_DATE_RANGE  then CALENDAR_TOOLTIP_DATE_RANGE  = "%s \226\128\147 %s" end  -- "A – B"
if not HEALTH_COST_PCT              then HEALTH_COST_PCT              = "%s%% Health"    end
if not FROM                         then FROM                         = "From"           end

-- ==========================================================================
-- 7.  GetClassColor 4th return value (hex string)
--     On 3.3.5a, GetClassColor may not return the colorStr as its 4th value.
--     Wrap it so select(4, GetClassColor(classFile)) always yields a hex string.
-- ==========================================================================
do
    local _orig_GetClassColor = GetClassColor
    if _orig_GetClassColor then
        GetClassColor = function(classFile)
            local r, g, b, hex = _orig_GetClassColor(classFile)
            if not hex and r then
                hex = string.format("%02x%02x%02x",
                    math.floor(r * 255 + 0.5),
                    math.floor(g * 255 + 0.5),
                    math.floor(b * 255 + 0.5))
            end
            return r, g, b, hex
        end
    else
        -- GetClassColor itself is absent on some very old builds
        GetClassColor = function(classFile)
            return 1, 1, 1, "ffffffff"
        end
    end
end

-- ==========================================================================
-- 8.  GetNumClasses / GetClassInfo  (Cataclysm+)
--     tr.lua:FromClass() iterates over all classes to map a classFile string
--     (e.g. "WARRIOR") to its localised display name.  On 3.3.5a these
--     globals do not exist; provide them using the Wrath class list.
--     We prefer LOCALIZED_CLASS_NAMES_MALE when available (it is on 3.3.5a)
--     so that non-English clients get the correct class name.
-- ==========================================================================
if not GetNumClasses then
    local _wotlkClasses = {
        { "Warrior",      "WARRIOR"     },
        { "Paladin",      "PALADIN"     },
        { "Hunter",       "HUNTER"      },
        { "Rogue",        "ROGUE"       },
        { "Priest",       "PRIEST"      },
        { "Death Knight", "DEATHKNIGHT" },
        { "Shaman",       "SHAMAN"      },
        { "Mage",         "MAGE"        },
        { "Warlock",      "WARLOCK"     },
        { "Druid",        "DRUID"       },
    }
    function GetNumClasses()
        return #_wotlkClasses
    end
    function GetClassInfo(index)
        local info = _wotlkClasses[index]
        if not info then return nil, nil end
        -- LOCALIZED_CLASS_NAMES_MALE is present in 3.3.5a and has the
        -- correct localised names for every supported locale.
        local localizedName = LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[info[2]]
        return localizedName or info[1], info[2]
    end
end

-- ==========================================================================
-- 9.  GetAddOnMetadata (3.3.5a has the plain global, not C_AddOns)
--     The addon already handles this with  C_AddOns and C_AddOns.GetAddOnMetadata
--     or GetAddOnMetadata  so no shim is needed; just ensure the global exists.
-- ==========================================================================
-- (No action needed: GetAddOnMetadata is available on 3.3.5a natively)

-- ==========================================================================
-- 10. C_Item.IsEquippedItem
--     spell.lua captures  local IsEquippedItem = C_Item and C_Item.IsEquippedItem
--     with no plain-global fallback.  Stub C_Item so that capture works on 3.3.5a
--     where C_Item is nil.  The underlying IsEquippedItem global has been
--     available since original WoW.
-- ==========================================================================
if not C_Item then
    C_Item = {}
end
if not C_Item.IsEquippedItem then
    C_Item.IsEquippedItem = IsEquippedItem or function() return false end
end

-- ==========================================================================
-- 11. C_UnitAuras.GetPlayerAuraBySpellID
--     util.lua line 17 captures:
--       local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
--     at file-load time. If C_UnitAuras is nil (3.3.5a), the local is nil and
--     GetPlayerAuraStacksBySpellID always returns nil,nil → stacks=0 → no overlay.
--
--     Provide the shim BEFORE util.lua loads by populating C_UnitAuras here.
--     Implementation: iterate UnitAura("player",...) and match by spell name
--     (derived from GetSpellInfo) since 3.3.5a's UnitAura does not return
--     spellId at the expected Cata+ position (10th value vs 11th in WotLK).
--
--     Fields returned match the AuraData table fields used by util.lua:
--       aura.applications  → stack count (count from UnitAura)
--       aura.auraInstanceID → nil (not available on 3.3.5a)
--       aura.duration       → duration from UnitAura
--       aura.expirationTime → expirationTime from UnitAura
-- ==========================================================================
if not C_UnitAuras then
    C_UnitAuras = {}
end
if not C_UnitAuras.GetPlayerAuraBySpellID then
    C_UnitAuras.GetPlayerAuraBySpellID = function(spellID)
        -- If CLEU has ever seen an aura event for this spell ID (SPELL_AURA_APPLIED,
        -- _DOSE, or _REMOVED), the CLEU cache is authoritative.  Do NOT fall back
        -- to UnitAura name-scan: on 3.3.5a multiple spell IDs can share the same
        -- spell name (e.g. Molten Core ranks 47383/71162/71165 all show "Molten Core"
        -- under UnitAura), so a name-scan would incorrectly activate unrelated buckets
        -- and cause extra overlays and flicker.
        if _SAO_SeenSpells and _SAO_SeenSpells[spellID] then
            local cached = _SAO_AuraCache and _SAO_AuraCache[spellID]
            if cached then
                return {
                    applications   = cached,
                    auraInstanceID = nil,
                    duration       = nil,
                    expirationTime = nil,
                }
            end
            return nil  -- spell was seen by CLEU and is currently absent
        end

        -- Spell was never seen in CLEU (e.g. triggered by a different mechanic,
        -- or server doesn't send CLEU for it).  Fall back to UnitAura name-scan,
        -- BUT only if no other spell ID with the same name has already been claimed
        -- by the CLEU path.  This prevents the name-scan from returning results for
        -- ranks of a same-named buff (e.g. Molten Core 47383/71162) when the server
        -- only fires CLEU for one of them (e.g. 71165).
        local spellName = GetSpellInfo(spellID)
        if not spellName then return nil end
        -- Check if a sibling spell ID (same name) is already CLEU-tracked.
        if _SAO_SeenSpells then
            for seenID, _ in pairs(_SAO_SeenSpells) do
                if seenID ~= spellID and GetSpellInfo(seenID) == spellName then
                    -- Another spell ID has the same name and was seen via CLEU;
                    -- don't use the UnitAura name-scan for this ID.
                    return nil
                end
            end
        end
        for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
            for i = 1, 40 do
                local name, _, _, count, _, duration, expirationTime = UnitAura("player", i, filter)
                if not name then break end
                if name == spellName then
                    return {
                        -- On 3.3.5a, UnitAura returns count=0 for a single-application
                        -- buff (count=0 means "no stack number displayed", not "0 stacks").
                        -- In Lua, 0 is truthy, so  "count or 1"  evaluates to 0 when
                        -- count=0, which is wrong.  Use an explicit >0 guard instead.
                        applications   = (count ~= nil and count > 0) and count or 1,
                        auraInstanceID = nil,
                        duration       = duration,
                        expirationTime = expirationTime,
                    }
                end
            end
        end
        -- UnitAura not yet updated: fall back to CLEU cache as last resort.
        local cached = _SAO_AuraCache and _SAO_AuraCache[spellID]
        if cached then
            return {
                applications   = cached,
                auraInstanceID = nil,
                duration       = nil,
                expirationTime = nil,
            }
        end
        return nil
    end
end

-- ==========================================================================
-- 12. GetSpellPowerCost  (C_Spell.GetSpellPowerCost / legacy global)
--     The C_Spell table doesn't exist in 3.3.5a and neither does the legacy
--     global GetSpellPowerCost (it was added later).  Provide a shim that
--     reads the cost from GetSpellInfo and returns the expected table format,
--     so the  for _, cost in ipairs(SAO:GetSpellPowerCost(id) or {})  loop
--     in actionusable.lua works correctly.
-- ==========================================================================
if not GetSpellPowerCost then
    -- Map numeric powerType (from GetSpellInfo) to the string name the
    -- action-usable code looks for.
    local _powerTypeNames = {
        [0]  = "MANA",
        [1]  = "RAGE",
        [2]  = "FOCUS",
        [3]  = "ENERGY",
        [4]  = "COMBO_POINTS",
        [5]  = "RUNES",
        [6]  = "RUNIC_POWER",
        [7]  = "SOUL_SHARDS",
    }
    function GetSpellPowerCost(spellID)
        local _, _, _, cost, _, powerType = GetSpellInfo(spellID)
        if not cost or cost == 0 then return {} end
        local name = _powerTypeNames[powerType] or "UNKNOWN"
        return {{ name = name, cost = cost }}
    end
end

-- ==========================================================================
-- 13. CreateColor  (Legion+)
--     The options panel uses CreateColor() to build dimmed color objects that
--     are passed to WrapTextInColor.  Provide a minimal shim returning a table
--     with the r/g/b fields our WrapTextInColor shim reads.
-- ==========================================================================
if not CreateColor then
    function CreateColor(r, g, b, a)
        return { r = r or 0, g = g or 0, b = b or 0, a = a or 1 }
    end
end

-- ==========================================================================
-- 14. frame.Text / frame.Low / frame.High for OptionsSliderTemplate and
--     InterfaceOptionsCheckButtonTemplate  (parentKey feature is Cata+)
--
--     Modern WoW XML uses  parentKey="Text"  so that child regions are
--     reachable as  frame.Text  regardless of whether the parent is named.
--     In 3.3.5a the children are named  $parentText / $parentLow / $parentHigh
--     and accessible only via the global  _G[parentName.."Text"]  for named
--     parents.  For unnamed frames (dynamically created checkboxes) there is
--     no global, so we fall back to scanning frame:GetRegions().
--
--     Two-part fix:
--     A) ADDON_LOADED handler: after SpellActivationOverlay's XML is parsed,
--        populate .Text/.Low/.High on every known named slider/checkbox so
--        they are ready before VARIABLES_LOADED calls OptionsPanel_Init.--        Also wraps SpellActivationOverlay_OnEvent to capture CLEU args for
--        the CombatLogGetCurrentEventInfo shim defined in section 2.--     B) CreateFrame wrapper: for anonymous (name=nil) checkboxes that are
--        created dynamically in classoptions.lua / glowoptions.lua.
-- ==========================================================================

-- Part A: named XML frames
do
    -- SetEnabled(bool) was added in Cataclysm. 3.3.5a only has Enable()/Disable().
    local function _ensureSetEnabled(f)
        if f and not f.SetEnabled then
            f.SetEnabled = function(self, enabled)
                if enabled then self:Enable() else self:Disable() end
            end
        end
    end

    local _compatFrame = CreateFrame("Frame")
    _compatFrame:RegisterEvent("ADDON_LOADED")
    _compatFrame:SetScript("OnEvent", function(self, event, addonName)
        if addonName ~= "SpellActivationOverlay" then return end
        self:UnregisterAllEvents()

        local prefix = "SpellActivationOverlayOptionsPanel"

        -- Sliders: .Text, .Low, .High
        local sliders = {
            "SpellAlertOpacitySlider",
            "SpellAlertScaleSlider",
            "SpellAlertOffsetSlider",
            "SpellAlertTimerSlider",
            "SpellAlertSoundSlider",
        }
        for _, suffix in ipairs(sliders) do
            local f = _G[prefix .. suffix]
            if f then
                f.Text = f.Text or _G[prefix .. suffix .. "Text"]
                f.Low  = f.Low  or _G[prefix .. suffix .. "Low"]
                f.High = f.High or _G[prefix .. suffix .. "High"]
            end
        end

        -- Checkboxes: .Text
        local checkboxes = {
            "GlowingButtons",
            "SpellAlertDebugButton",
            "SpellAlertReportButton",
            "SpellAlertResponsiveButton",
            "SpellAlertAskDisableGameAlertButton",
            "DisableConditionButton",
        }
        for _, suffix in ipairs(checkboxes) do
            local f = _G[prefix .. suffix]
            if f then
                f.Text = f.Text or _G[prefix .. suffix .. "Text"]
                _ensureSetEnabled(f)
            end
        end

        -- The opacity slider OnValueChanged script calls :SetEnabled on the
        -- test button (a UIPanelButtonTemplate Button, not a CheckButton).
        _ensureSetEnabled(_G[prefix .. "SpellAlertTestButton"])

        -- SetShown(bool) polyfill for XML-created frames (Cata+; 3.3.5a only has Show/Hide).
        -- SpellActivationOverlayContainerFrame is defined in XML, so the CreateFrame
        -- wrapper never fires for it — patch it here instead.
        local containerFrame = _G["SpellActivationOverlayContainerFrame"]
        if containerFrame and not containerFrame.SetShown then
            containerFrame.SetShown = function(self, shown)
                if shown then self:Show() else self:Hide() end
            end
        end
    end)
end

-- Part B: anonymous Lua-created frames
do
    local _origCreateFrame = CreateFrame
    CreateFrame = function(frameType, frameName, parent, template, ...)
        local frame = _origCreateFrame(frameType, frameName, parent, template, ...)

        -- SetShown(bool) polyfill for all frames (Cata+; 3.3.5a has only Show/Hide)
        if not frame.SetShown then
            frame.SetShown = function(self, shown)
                if shown then self:Show() else self:Hide() end
            end
        end

        -- SetEnabled(bool) polyfill for all Button / CheckButton frames
        local ft = frameType and frameType:upper() or ""
        if (ft == "BUTTON" or ft == "CHECKBUTTON") and not frame.SetEnabled then
            frame.SetEnabled = function(self, enabled)
                if enabled then self:Enable() else self:Disable() end
            end
        end

        if not template or frame.Text then
            return frame
        end

        local isSlider   = template:find("OptionsSliderTemplate",              1, true)
        local isCheckbox = template:find("InterfaceOptionsCheckButtonTemplate", 1, true)
        local isOverlay  = template:find("SpellActivationOverlayAddonTemplate", 1, true)

        if not isSlider and not isCheckbox and not isOverlay then
            return frame
        end

        -- Overlay template: patch SetShown onto the mask/combat Texture children
        -- so that overlay.mask:SetShown(useTimer) works on 3.3.5a.
        if isOverlay then
            local function _addSetShown(obj)
                if obj and not obj.SetShown then
                    obj.SetShown = function(self, shown)
                        if shown then self:Show() else self:Hide() end
                    end
                end
            end
            _addSetShown(frame.mask)
            _addSetShown(frame.combat)

            -- Disable the looping pulse Scale animation on 3.3.5a.
            -- The looping Scale animation on the overlay frame causes a brief
            -- alpha/scale glitch at each loop boundary on the 3.3.5a client,
            -- producing the "flash to whole screen" artifact.  Stubbing Play
            -- prevents the pulse from starting; the overlay still appears and
            -- fades in correctly via animIn.
            if frame.pulse then
                frame.pulse.Play  = function() end
                frame.pulse.Stop  = function() end
                frame.pulse.Pause = function() end
            end
            return frame
        end

        -- Named frame: children are globally accessible as frameName.."Text" etc.
        if frameName then
            if isSlider then
                frame.Text = frame.Text or _G[frameName .. "Text"]
                frame.Low  = frame.Low  or _G[frameName .. "Low"]
                frame.High = frame.High or _G[frameName .. "High"]
            end
            if isCheckbox then
                frame.Text = frame.Text or _G[frameName .. "Text"]
            end
        end

        -- Unnamed frame: scan regions for the first FontString ($parentText)
        if not frame.Text then
            for _, region in ipairs({ frame:GetRegions() }) do
                if region.GetObjectType and region:GetObjectType() == "FontString" then
                    frame.Text = region
                    break
                end
            end
        end

        return frame
    end
end

-- ==========================================================================
-- 15. GetFileIDFromPath  (MoP+)
--     texname.lua:MarkTexture() uses this to verify that a texture file
--     actually exists on disk.  On 3.3.5a the function is absent; provide a
--     stub that always returns a truthy value so the  "Missing file"  error
--     branch is never taken.  (Textures ship with the addon so the check is
--     not needed on the original client.)
-- ==========================================================================
if not GetFileIDFromPath then
    function GetFileIDFromPath(path)
        return path  -- truthy: suppresses the "Missing file" error path
    end
end

-- ==========================================================================
-- 15b. C_SpecializationInfo  (MoP+)
--      util.lua captures several functions as local upvalues at load time:
--        local GetNumSpecializationsForClassID = C_SpecializationInfo and ...
--        local GetSpecializationInfo           = C_SpecializationInfo and ...
--        GetTalentInfo = C_SpecializationInfo and C_SpecializationInfo.GetTalentInfo or GetTalentInfo
--      On 3.3.5a, C_SpecializationInfo is nil so all upvalues are nil.
--
--      In WotLK, "specs" are the three talent trees.  Map them:
--        GetSpecializationInfo(i)            → wraps GetTalentTabInfo(i),
--                                              returns (id, name, desc, icon, role, stat)
--                                              so that select(2,...) gives the tree name.
--        GetNumSpecializationsForClassID(id) → returns GetNumTalentTabs()
--        GetTalentInfo kept as the 3.3.5a global (already correct shape).
--
--      Also shim UnitClassBase(unit) → classFilename, classID, which is used
--      by GetNbSpecs() as select(2, UnitClassBase("player")) for the classID.
-- ==========================================================================
if not C_SpecializationInfo then
    C_SpecializationInfo = {}
end
if not C_SpecializationInfo.GetSpecializationInfo then
    C_SpecializationInfo.GetSpecializationInfo = function(specIndex)
        if not GetTalentTabInfo then return nil end
        -- GetTalentTabInfo returns: name, icon, pointsSpent, background, previewPoints, isHighlighted
        local name, icon, pointsSpent = GetTalentTabInfo(specIndex)
        if not name then return nil end
        -- Return shape: specID, name, description, icon, role, primaryStat, pointsSpent
        -- select(7,...) in GetTotalPointsInTree expects pointsSpent as the 7th value.
        return specIndex, name, "", icon or "", "DAMAGER", 0, pointsSpent or 0
    end
end
if not C_SpecializationInfo.GetNumSpecializationsForClassID then
    C_SpecializationInfo.GetNumSpecializationsForClassID = function(_classID)
        return GetNumTalentTabs and GetNumTalentTabs() or 3
    end
end

if not UnitClassBase then
    function UnitClassBase(unit)
        -- UnitClass returns: localizedName, classFilename, classID
        local _, classFilename, classID = UnitClass(unit)
        return classFilename, classID
    end
end

-- ==========================================================================
-- 16b. GetSpellBookItemName  (Cataclysm / patch 4.0.1+)
--      util.lua:GetHomonymSpellIDs() captures this as a local upvalue at
--      load time.  In 3.3.5a the equivalent function is GetSpellName(), and
--      the spell ID that the addon expects as the 3rd return value comes from
--      GetSpellBookItemInfo().
--      Shim: GetSpellBookItemName(index, bookType) → name, rank, id
-- ==========================================================================
if not GetSpellBookItemName then
    function GetSpellBookItemName(index, bookType)
        local name, rank = GetSpellName(index, bookType)
        if not name then return nil end
        local id
        if GetSpellBookItemInfo then
            -- Available on real WotLK 3.3.5a clients
            local _, spellID = GetSpellBookItemInfo(index, bookType)
            id = spellID
        elseif GetSpellLink then
            -- Fallback: parse the spell ID out of the hyperlink.
            -- WotLK link format: |cff71d5ff|Hspell:SPELLID|h[Name]|h|r
            local link = GetSpellLink(index, bookType)
            if link then
                id = tonumber(link:match("|Hspell:(%d+)|h"))
            end
        end
        -- id may still be nil on extremely stripped-down servers; callers
        -- table.insert nil which Lua silently ignores (no-op), so this is safe.
        return name, rank, id
    end
end

-- ==========================================================================
-- 16. StanceBarFrame.StanceButtons
--     glow.lua iterates StanceBarFrame.StanceButtons to hook Priest shadowform
--     stance button glows.  In the original 3.3.5a client the buttons are only
--     accessible as global StanceButton1/2/... but NOT as a table on the frame.
--     Populate the table from those globals once the UI is fully loaded.
-- ==========================================================================
do
    local function _setupStanceButtons()
        if StanceBarFrame and not StanceBarFrame.StanceButtons then
            local btns = {}
            for i = 1, 10 do
                local btn = _G["StanceButton" .. i]
                if btn then btns[i] = btn end
            end
            StanceBarFrame.StanceButtons = btns
        end
    end
    local _stanceFrame = CreateFrame("Frame")
    _stanceFrame:RegisterEvent("PLAYER_LOGIN")
    _stanceFrame:SetScript("OnEvent", function(self)
        _setupStanceButtons()
        self:UnregisterAllEvents()
    end)
end

-- ==========================================================================
-- 17. UNIT_AURA fallback for Wrath legacy mode
--     The AURASTACKS legacy handler relies solely on CLEU.  On some private
--     servers the CLEU dstGUID may not match UnitGUID("player") (e.g. when
--     the server sends a player GUID with a different prefix).  Register a
--     UNIT_AURA handler here that calls CheckManuallyAllBuckets() so that
--     aura changes are always caught even if the CLEU comparison misses.
-- ==========================================================================
do
    local _unitAuraFrame = CreateFrame("Frame")
    _unitAuraFrame:RegisterEvent("UNIT_AURA")
    _unitAuraFrame:SetScript("OnEvent", function(self, event, unit)
        if unit ~= "player" then return end
        -- Defer slightly so UnitAura is fully updated before we query it.
        C_Timer.NewTimer(0.05, function()
            if SAO and SAO.CheckManuallyAllBuckets and SAO.TRIGGER_AURA then
                SAO:CheckManuallyAllBuckets(SAO.TRIGGER_AURA)
            end
        end)
    end)
end

-- ==========================================================================
-- 18. Debug utilities  (/saodebug on|off, /saodump)
--     Type /saodebug on  to enable verbose CLEU prints for aura events.
--     Type /saodump      to print the current state of every bucket that
--                        requires SAO.TRIGGER_AURA.
-- ==========================================================================
_SAO_Debug335 = false  -- set true by /saodebug on
SLASH_SAODEBUG1 = "/saodebug"
SlashCmdList["SAODEBUG"] = function(msg)
    if msg == "on" then
        _SAO_Debug335 = true
        print("|cffFFFF00[SAO335]|r Debug mode ON – CLEU aura events will be printed.")
    elseif msg == "off" then
        _SAO_Debug335 = false
        print("|cffFFFF00[SAO335]|r Debug mode OFF.")
    else
        print("|cffFFFF00[SAO335]|r Usage: /saodebug on|off")
    end
end

SLASH_SAODUMP1 = "/saodump"
SlashCmdList["SAODUMP"] = function()
    if not SAO then print("|cffFF4040[SAO335]|r SAO not ready."); return end
    print("|cffFFFF00[SAO335]|r === SAO bucket dump ===")
    print("  IsWrath="..tostring(SAO.IsWrath())
        .."  IsRetail="..tostring(SAO.IsRetail())
        .."  LEGACY="..tostring(SAO.AURASTACKS and SAO.AURASTACKS.LEGACY))
    local count = 0
    for id, bucket in pairs(SAO.RegisteredBucketsBySpellID or {}) do
        if type(id) == "number" then
            count = count + 1
            local trig = bucket.trigger
            print(string.format("  [%d] %s  required=0x%X  informed=0x%X  currentHash=%s  displayedHash=%s  stackAgnostic=%s",
                id, tostring(bucket.name),
                trig and trig.required or 0,
                trig and trig.informed or 0,
                tostring(bucket.currentHash),
                tostring(bucket.displayedHash),
                tostring(bucket.stackAgnostic)))
            local auraResult = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
                and C_UnitAuras.GetPlayerAuraBySpellID(id)
            print(string.format("    GetPlayerAuraBySpellID(%d) = %s  cache=%s",
                id,
                auraResult and ("apps="..tostring(auraResult.applications)) or "nil",
                tostring(_SAO_AuraCache and _SAO_AuraCache[id])))
        end
    end
    if count == 0 then
        print("  (no buckets registered)")
    end
    -- Check GUIDs
    print("  UnitGUID('player')="..tostring(UnitGUID("player")))
    -- Print ContainerFrame visibility
    local cf = _G["SpellActivationOverlayContainerFrame"]
    local af = _G["SpellActivationOverlayAddonFrame"]
    print("  ContainerFrame shown="..tostring(cf and cf:IsShown())
        .."  AddonFrame alpha="..tostring(af and af:GetAlpha()))
    -- Print DB state
    local db = SpellActivationOverlayDB
    print("  DB alert.enabled="..tostring(db and db.alert and db.alert.enabled)
        .."  opacity="..tostring(db and db.alert and db.alert.opacity))
    print("|cffFFFF00[SAO335]|r === end dump ===")
end

-- ==========================================================================
-- 20. LibCustomGlow-1.0 ShowOverlayGlow / HideOverlayGlow aliases
--     glow.lua uses LibCustomGlow-1.0 (LCG) as the button-glow engine when
--     ElvUI is detected (version < 13).  SAO calls LCG.ShowOverlayGlow() and
--     LCG.HideOverlayGlow(), but LibCustomGlow-1.0 only defines the API as
--     ButtonGlow_Start(frame, ...) / ButtonGlow_Stop(frame).
--     Patch the library table at PLAYER_LOGIN (after all addons are loaded)
--     so the expected method names exist before any LAB callback fires.
-- ==========================================================================
do
    local _lcgPatchFrame = CreateFrame("Frame")
    _lcgPatchFrame:RegisterEvent("PLAYER_LOGIN")
    _lcgPatchFrame:SetScript("OnEvent", function(self)
        self:UnregisterAllEvents()
        if not LibStub then return end
        local LCG = LibStub("LibCustomGlow-1.0", true)
        if not LCG then return end
        if not LCG.ShowOverlayGlow and LCG.ButtonGlow_Start then
            LCG.ShowOverlayGlow = LCG.ButtonGlow_Start
        end
        if not LCG.HideOverlayGlow and LCG.ButtonGlow_Stop then
            LCG.HideOverlayGlow = LCG.ButtonGlow_Stop
        end
    end)
end

-- ==========================================================================
-- 19. PLAYER_LOGIN substitute for LOADING_SCREEN_DISABLED
--     LOADING_SCREEN_DISABLED was added in Cataclysm.  On the 3.3.5a client
--     it never fires, so SAO.LOADING_SCREEN_DISABLED (which calls
--     RegisterPendingEffectsAfterPlayerLoggedIn) is never invoked.  All
--     effects remain in the pending list and RegisteredBucketsBySpellID
--     stays empty → no overlays ever appear.
--
--     PLAYER_LOGIN fires on every client and is already registered by
--     SpellActivationOverlay_OnLoad via SAO:RegisterEventHandler.  Define
--     SAO.PLAYER_LOGIN here (before InitializeEventDispatcher runs) so that
--     it is picked up by the event dispatcher and calls the same logic.
--     The guard inside LOADING_SCREEN_DISABLED prevents double-registration
--     if the server also fires LOADING_SCREEN_DISABLED.
-- ==========================================================================
SAO.PLAYER_LOGIN = function(self, ...)
    if SAO.LOADING_SCREEN_DISABLED then
        SAO.LOADING_SCREEN_DISABLED(self, ...)
    end
    -- Permanently disable the "dim out of combat" fade system on 3.3.5a.
    -- SpellActivationOverlayAddonFrame normally fades in when overlays appear
    -- (combatAnimIn: alpha 0.5→1 over 5s) and fades out when leaving combat.
    -- On 3.3.5a this causes a visible darkening-then-brightening flash every
    -- time an overlay is shown out of combat.  SetForceAlpha1(true) fixes the
    -- parent frame at alpha=1 and disables both combat animations entirely.
    if SpellActivationOverlayFrame_SetForceAlpha1 then
        SpellActivationOverlayFrame_SetForceAlpha1(true)
    end
end

-- ==========================================================================
-- 21. LibButtonGlow-1.0 – 3.3.5a animation compatibility
--
--     LBG uses Animation:SetTarget(region), Animation:SetFromAlpha/SetToAlpha
--     and Cooldown:GetCooldownDuration() which are all Cata+ additions.
--     Because CreateOverlayGlow is a private local closure we cannot patch it
--     from outside the library.  Instead we replace the two public API
--     functions (lib.ShowOverlayGlow / lib.HideOverlayGlow) entirely with an
--     implementation that uses plain OnUpdate-based alpha/texcoord animation
--     requiring nothing beyond the WotLK 3.3.5a frame API.
--
--     Visual result: a golden outer-glow ring plus marching-ants border that
--     fade in when a proc is active and fade out when it ends — identical to
--     the original intent but animated with OnUpdate instead of the Cata
--     AnimationGroup:CreateAnimation SetTarget path.
-- ==========================================================================
do
    local _lbgCompatFrame = CreateFrame("Frame")
    _lbgCompatFrame:RegisterEvent("PLAYER_LOGIN")
    _lbgCompatFrame:SetScript("OnEvent", function(self, event)
        self:UnregisterAllEvents()

        if not LibStub then return end
        local LBG = LibStub("LibButtonGlow-1.0", true)
        if not LBG then return end

        -- Prefer delegating to LibCustomGlow-1.0.ButtonGlow_Start/Stop.
        -- LCG ships with WeakAuras and uses an OnUpdate-based animation system
        -- that works on 3.3.5a without any Cata+ animation API calls.
        -- Using LCG avoids needing IconAlert texture files in the SAO folder.
        -- NOTE: Must run at PLAYER_LOGIN, not ADDON_LOADED, because WeakAuras
        -- (W > S alphabetically) loads AFTER SpellActivationOverlay, so LCG is
        -- not yet registered in LibStub at SpellActivationOverlay's ADDON_LOADED.
        local LCG = LibStub("LibCustomGlow-1.0", true)
        if LCG and LCG.ButtonGlow_Start and LCG.ButtonGlow_Stop then
            LBG.ShowOverlayGlow = function(frame)
                LCG.ButtonGlow_Start(frame)
            end
            LBG.HideOverlayGlow = function(frame)
                LCG.ButtonGlow_Stop(frame)
            end
            LBG.unusedOverlays = {}
            return
        end

        -- Fallback when LCG is unavailable: custom OnUpdate-based glow.
        -- Uses IconAlert textures bundled with SAO (copied from LCG into
        -- SpellActivationOverlay/textures/ during the 3.3.5a backport).
        local ICON_ALERT      = [[Interface\AddOns\SpellActivationOverlay\textures\IconAlert]]
        local ICON_ALERT_ANTS = [[Interface\AddOns\SpellActivationOverlay\textures\IconAlertAnts]]

        local _pool  = {}
        local _count = 0
        local FADE_SPEED = 4   -- alpha / second  → 0.25 s full fade

        local function OnOverlayUpdate(self, elapsed)
            -- Animate ants marching (scrolls texture coords through 22 frames
            -- on a 256×256 sheet with 48×48 cells at 0.01 s per cell).
            if self.ants:GetAlpha() > 0 then
                AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
            end

            if not self._fading then return end

            local da = elapsed * FADE_SPEED
            if self._fadeDir > 0 then
                self._alpha = math.min(1, self._alpha + da)
                self.outerGlow:SetAlpha(self._alpha * 0.85)
                self.ants:SetAlpha(self._alpha)
                if self._alpha >= 1 then self._fading = false end
            else
                self._alpha = math.max(0, self._alpha - da)
                self.outerGlow:SetAlpha(self._alpha * 0.85)
                self.ants:SetAlpha(self._alpha)
                if self._alpha <= 0 then
                    self._fading = false
                    local parent = self:GetParent()
                    self:Hide()
                    self:SetParent(UIParent)
                    if parent then parent.__LBGoverlay = nil end
                    table.insert(_pool, self)
                end
            end
        end

        local function CreateGlowOverlay()
            _count = _count + 1
            local name = "SAO335BtnGlow" .. _count
            local ov = CreateFrame("Frame", name, UIParent)

            local outer = ov:CreateTexture(name .. "Outer", "ARTWORK")
            outer:SetPoint("CENTER")
            outer:SetAlpha(0)
            outer:SetBlendMode("ADD")
            outer:SetTexture(ICON_ALERT)
            outer:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
            ov.outerGlow = outer

            local ants = ov:CreateTexture(name .. "Ants", "OVERLAY")
            ants:SetPoint("CENTER")
            ants:SetAlpha(0)
            ants:SetBlendMode("ADD")
            ants:SetTexture(ICON_ALERT_ANTS)
            ov.ants = ants

            ov._alpha   = 0
            ov._fading  = false
            ov._fadeDir = 1

            ov:SetScript("OnUpdate", OnOverlayUpdate)
            ov:Hide()
            return ov
        end

        local function GetGlowOverlay()
            return table.remove(_pool) or CreateGlowOverlay()
        end

        LBG.ShowOverlayGlow = function(frame)
            if frame.__LBGoverlay then
                local ov = frame.__LBGoverlay
                ov._fadeDir = 1
                ov._fading  = true
            else
                local ov = GetGlowOverlay()
                local w, h = frame:GetSize()
                ov:SetParent(frame)
                ov:SetFrameLevel(frame:GetFrameLevel() + 5)
                ov:ClearAllPoints()
                ov:SetPoint("CENTER", frame, "CENTER")
                ov:SetSize(w * 1.4, h * 1.4)
                ov.outerGlow:SetSize(w * 1.4, h * 1.4)
                ov.ants:SetSize(w * 0.85, h * 0.85)
                ov._alpha   = 0
                ov._fadeDir = 1
                ov._fading  = true
                ov:Show()
                frame.__LBGoverlay = ov
            end
        end

        LBG.HideOverlayGlow = function(frame)
            if frame.__LBGoverlay then
                frame.__LBGoverlay._fadeDir = -1
                frame.__LBGoverlay._fading  = true
            end
        end

        -- Discard any pre-existing original LBG overlays that would crash
        -- because they were built with SetTarget-based animation groups.
        LBG.unusedOverlays = {}
    end)
end

