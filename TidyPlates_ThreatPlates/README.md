# TidyPlates_ThreatPlates — WoW 3.3.5a Backport

This document describes all changes made to backport TidyPlates_ThreatPlates v11.2.13
to the WoW 3.3.5a (Wrath of the Lich King) client.

---

## Environment

| Property | Value |
|---|---|
| Target client | WoW 3.3.5a (build 12340) |
| Interface version | 30300 |
| Lua version | 5.1 |
| Server | WoW 3.3.5a private server |

Key Lua 5.1 quirk: `xpcall(f, handler, ...)` does **not** forward extra arguments to
`f`. This breaks AceAddon's `safecall`, which passes `self` as the first extra arg.
A polyfill in `Compat335.lua` Section 0 wraps `xpcall` to fix this.

---

## New File: `Compat335.lua`

A single polyfill file loaded as the **first** entry in the TOC. It shims all modern
WoW APIs that the addon uses but that do not exist in 3.3.5a. Every section is wrapped
in an existence guard (`if not X then ... end`) so it is safe even if a compatibility
layer on the server already provides part of the API.

| Section | What it provides |
|---|---|
| **0** | `xpcall` Lua 5.1 arg-forwarding fix — probe detects the bug, wraps the global with a closure-based forwarder |
| **1a** | `BackdropTemplateMixin` nil probe — `pcall`-tests whether `"BackdropTemplate"` is a registered XML template; if not (some servers expose the mixin global but not the template), sets `BackdropTemplateMixin = nil` so Init.lua propagates `Addon.BackdropTemplate = nil` |
| **1** | `WOW_PROJECT_*` constants, `LE_EXPANSION_*` constants, `GetClassicExpansionLevel()` → returns WotLK value |
| **2** | `Lerp`, `UnitEffectiveLevel`, `UnitIsTapDenied`, `UnitNameplateShowsWidgetsOnly`, `UnitSelectionColor`, `GetPhysicalScreenSize`, `GetSpecializationInfo` / `GetSpecialization` / `GetNumSpecializations`, `GetCurrentRegion` / `GetCurrentRegionName` |
| **3** | `CreateColor(r,g,b,a)` — returns a table with `GenerateHexColor()`, `GetRGB()`, `GetRGBA()` |
| **4** | `C_CVar` namespace — wraps legacy `GetCVar` / `SetCVar` / `GetCVarDefault`; `RegisterCVar` no-op |
| **5** | `C_Timer.After` and `C_Timer.NewTimer` — implemented with an OnUpdate frame |
| **6** | `C_PvP = { IsSoloShuffle=false, IsInBrawl=false }` |
| **7** | `NamePlateDriverFrame` empty stub |
| **8** | `CombatLogGetCurrentEventInfo()` — captures CLEU varargs, inserts nil at position 3 (subevent column) for API compatibility |
| **9** | `Enum = {}` + full `Enum.PowerType` table with all power type values |
| **10** | `C_FriendList` namespace — delegates to legacy globals (`GetFriendInfo`, `GetNumFriends`, etc.) |
| **11** | `CreateTexturePool` and `CreateFramePool` — full pool implementations |
| **12** | `C_NamePlate` — full implementation with frame scanning every 0.1 s and synthetic event firing |
| **13** | `C_QuestLog` — maps to legacy `GetNumQuestLogEntries`, `GetQuestLogTitle` scan; no-ops for write methods |
| **14** | `C_UIWidgetManager = { GetStatusBarWidgetVisualizationInfo = function() return nil end }` |
| **15** | `BNGetNumFriends` → `0,0`; `BNGetGameAccountInfo`, `BNGetFriendInfo`, `BNGetFriendInfoByID` → nil |
| **16** | `UnitIsOwnerOrControllerOfUnit` — checks `UnitIsUnit` and pet relationship |
| **17** | `PixelUtil = { SetPoint, SetWidth, SetHeight, SetSize }` — delegates to plain frame methods |
| **18** | `RegisterAddonMessagePrefix` → no-op stub; `Ambiguate(name, ctx)` → returns name unchanged |

---

## Modified Files

### `TidyPlates_ThreatPlates.toc`
- Changed `## Interface:` from the retail value to **30300**
- Removed `## AddonCompartmentFunc` (Dragonflight-only metadata key)
- Added `Compat335.lua` as the **first** file entry so polyfills load before everything else

---

### `TidyPlatesInternal/TidyPlatesCore.lua`
- Soft-target events (`UNIT_TARGET` soft-target variant, etc.) wrapped in `if IS_MAINLINE then` guard
- `RegisterEvent` loop wrapped in `pcall` to skip events unknown to the 3.3.5a client
- `CVAR_NameplateOccludedAlphaMult` initialisation now uses `or 0.6` default in case `GetAsNumber` returns nil for that CVar
- **All ~14 unit-event handlers** (`UNIT_NAME_UPDATE`, `UNIT_TARGET`, `UNIT_HEALTH`, `UNIT_MAXHEALTH`, `UNIT_THREAT_LIST_UPDATE`, all `UNIT_SPELLCAST_*` variants, `UNIT_ABSORB_AMOUNT_CHANGED`, `UNIT_HEAL_ABSORB_AMOUNT_CHANGED`) had their unit-id guard extended from:
  ```lua
  if IGNORED_UNITIDS[unitid] or UnitIsUnit(...) then
  ```
  to:
  ```lua
  if not unitid or IGNORED_UNITIDS[unitid] or UnitIsUnit(...) then
  ```
  This prevents `UnitIsUnit` from receiving nil arguments when the server fires events with no unit-id.

---

### `CVarsManager.lua`
- The entire `nameplateShowOnlyNames` block in `CVars:Initialize` wrapped in `if Addon.IS_MAINLINE then` — this CVar does not exist in 3.3.5a
- `SetConsoleVariable` call guarded with `if GetCVar(cvar) ~= nil then` to skip unknown CVars
- `CVars:SetToDefault`, `CVars:RestoreFromProfile`, `CVars:SetToDefaultProtected`, `CVars:OverwriteProtected` — all `SetCVar` calls guarded with `if GetCVar(cvar) ~= nil`
- `CVars:GetAsNumber` — added early return `if value == nil then return nil end` before the string-format conversion (unknown CVars return nil from `GetCVar`)

---

### `Libs/AceComm-3.0/ChatThrottleLib.lua`
- `SendAddonMessage` and `SendAddonMessageLogged` — changed bare `C_ChatInfo.SendAddonMessage` call to:
  ```lua
  _G.C_ChatInfo and _G.C_ChatInfo.SendAddonMessage or _G.SendAddonMessage
  ```
  Falls back to the legacy `SendAddonMessage` global, which exists in 3.3.5a.

---

### `Libs/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua`
- Main dialog `CreateFrame` call wrapped in `pcall`; on failure falls back to a plain frame + manual `SetBackdrop`
- `SetFixedFrameStrata` and `SetFixedFrameLevel` calls guarded with `if frame.SetFixedFrameStrata then`
- `SetPropagateKeyboardInput` guarded with `if frame.SetPropagateKeyboardInput then`
- Button texture `FileID` integers replaced with relative file-path strings
- `GetNormalTexture()` / `GetHighlightTexture()` / `GetPushedTexture()` / `GetDisabledTexture()` return values nil-checked before use

---

### `Libs/LibCustomGlow-1.0/LibCustomGlow-1.0.lua`
- `CreateScaleAnim` and `CreateAlphaAnim`: `scale:SetChildKey` / `alpha:SetChildKey` wrapped in `if anim.SetChildKey then`
- Five inline `SetChildKey` calls (`alphaRepeat`, `flipbookRepeat`, `flipbookStartAlphaIn`, `flipbookStart`, `flipbookStartAlphaOut`) all guarded the same way
- `GlowMaskPool.createFunc`: wrapped `CreateMaskTexture` call in `if parent.CreateMaskTexture then`; returns a dummy no-op table on 3.3.5a
- Texture pool resetter and PixelGlow: `GetNumMaskTextures` loop and `AddMaskTexture` call guarded

---

### `Libs/AceGUI-3.0/widgets/` (9 files, 15 occurrences)

All `CreateFrame(..., "BackdropTemplate")` calls had `, "BackdropTemplate"` stripped because the XML template is not registered in 3.3.5a (some servers expose `BackdropTemplateMixin` globally but not the template node):

| File | Occurrences fixed |
|---|---|
| `AceGUIContainer-Frame.lua` | 2 (main frame + status bar) |
| `AceGUIContainer-DropDownGroup.lua` | 1 |
| `AceGUIContainer-InlineGroup.lua` | 1 |
| `AceGUIContainer-TabGroup.lua` | 1 |
| `AceGUIContainer-TreeGroup.lua` | 3 (tree frame, dragger, border) |
| `AceGUIWidget-DropDown.lua` | 2 (pullout frame + scrollbar slider — had dynamic name variables, fixed manually) |
| `AceGUIWidget-Keybinding.lua` | 1 |
| `AceGUIWidget-MultiLineEditBox.lua` | 1 |
| `AceGUIWidget-Slider.lua` | 2 (slider frame + edit box) |

---

### `Elements/Fonts.lua`
- `BackupSystemFont`: added nil guard — when `font_instance` is nil (e.g. `SystemFont_NamePlate` doesn't exist on 3.3.5a), returns a fallback table `{ Typeface="Fonts\\FRIZQT__.TTF", Size=10, flags="" }`

---

### `Widgets/TargetArtWidget.lua`
- All `CreateMaskTexture`, `SetAtlas`, `AddMaskTexture`, and mask `SetPoint` / `SetAllPoints` calls moved inside `if soft_target_icon_frame.CreateMaskTexture then` guard — `CreateMaskTexture` was introduced in Legion and does not exist in 3.3.5a

---

## Summary of API Gaps Addressed

| Missing API / behaviour | Root cause | Solution |
|---|---|---|
| `xpcall` drops extra args | Lua 5.1 | Compat335 Section 0: wrapper polyfill |
| `"BackdropTemplate"` XML node absent | Some servers register the mixin but not the template | Compat335 Section 1a: pcall probe nils the mixin; AceGUI widgets strip the arg |
| `WOW_PROJECT_*` / `LE_EXPANSION_*` constants | Dragonflight additions | Compat335 Section 1 |
| Many `Unit*` helpers | Legion+ additions | Compat335 Section 2 |
| `CreateColor` | Legion+ | Compat335 Section 3 |
| `C_CVar` namespace | Shadowlands+ | Compat335 Section 4 |
| `C_Timer` | Cata+ | Compat335 Section 5 |
| `C_PvP` | BfA+ | Compat335 Section 6 |
| `NamePlateDriverFrame` | Legion+ | Compat335 Section 7 |
| `CombatLogGetCurrentEventInfo` | BfA+ | Compat335 Section 8 |
| `Enum.PowerType` | Legion+ | Compat335 Section 9 |
| `C_FriendList` | BfA+ | Compat335 Section 10 |
| `CreateTexturePool` / `CreateFramePool` | Legion+ | Compat335 Section 11 |
| `C_NamePlate` | Legion+ | Compat335 Section 12 |
| `C_QuestLog` | Shadowlands+ | Compat335 Section 13 |
| `C_UIWidgetManager` | BfA+ | Compat335 Section 14 |
| Battle.net APIs (`BNGet*`) | Private server has no Battle.net | Compat335 Section 15 |
| `UnitIsOwnerOrControllerOfUnit` | Legion+ | Compat335 Section 16 |
| `PixelUtil` | Legion+ | Compat335 Section 17 |
| `RegisterAddonMessagePrefix` / `Ambiguate` | Cata+ / MoP+ | Compat335 Section 18 |
| `nameplateShowOnlyNames` CVar | Dragonflight-only CVar | CVarsManager: IS_MAINLINE guard |
| Unknown CVar nil crash | `GetCVar` returns nil for absent CVars | CVarsManager: existence checks + nil return |
| `C_ChatInfo.SendAddonMessage` absent | Pre-Cata used global `SendAddonMessage` | ChatThrottleLib: existence-checked fallback |
| `DialogBorderOpaqueTemplate` XML absent | Modern UI template | AceConfigDialog: pcall + SetBackdrop fallback |
| `SetChildKey` on animations | BfA+ animation API | LibCustomGlow: 7× nil guards |
| `CreateMaskTexture` absent | Legion+ API | LibCustomGlow + TargetArtWidget: guards |
| `SystemFont_NamePlate` nil | Modern-only font object | Fonts.lua: nil guard with fallback |
| `UnitIsUnit(unit, nil)` crash | Server fires events with nil unitid | TidyPlatesCore: `not unitid` pre-check in all handlers |
