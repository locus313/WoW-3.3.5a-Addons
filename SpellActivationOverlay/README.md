# SpellActivationOverlay — WoW 3.3.5a Backport

This is a backport of **SpellActivationOverlay v2.7.2** to the original WoW 3.3.5a client (private / legacy servers).

The original addon is maintained by [Vinny/Ennvina](https://www.curseforge.com/wow/addons/spellactivationoverlay) and supports Era, Season of Discovery, TBC Classic, Wrath Classic, Cataclysm Classic, Mists Classic, and Retail. This backport targets the original 3.3.5a binary, which lacks many APIs added after Wrath Classic's original release.

---

## Files Changed

### `SpellActivationOverlay.toc`
- **Interface version** changed from `30405, 38000` to `30300` (original WoTLK client).
- **`components\Compat335.lua`** added as the very first file to load, so all shims are in place before any other addon code runs.

### `components/Compat335.lua` *(new file)*
Provides sixteen individually-guarded API compatibility shims. Each shim is wrapped in `if not X then` so it never overwrites an API that the server/client already provides. Safe to run on any client.

| # | Shim | Reason |
|---|------|--------|
| 1 | `WOW_PROJECT_*` constants + `WOW_PROJECT_ID` | 3.3.5a private servers don't define these. Set so `SAO.IsWrath()` returns `true` and the addon follows Wrath code paths throughout. |
| 2 | `CombatLogGetCurrentEventInfo` | Added in Cataclysm. In 3.3.5a the `COMBAT_LOG_EVENT_UNFILTERED` payload is passed as arguments directly to the event handler. A dedicated frame is registered for `COMBAT_LOG_EVENT_UNFILTERED` at Compat335.lua top-level (before SpellActivationOverlay's XML is parsed), so it fires first in registration order and stores the CLEU args. `CombatLogGetCurrentEventInfo` is unconditionally overridden to return those args via `unpack`, so it works correctly regardless of any stub another addon (e.g. WeakAuras) may have installed. |
| 3 | `WrapTextInColorCode`, `WrapTextInColor`, color globals | Added in Cataclysm. Used extensively by `util.lua` for `SAO:Error/Warn/Info` log messages. Also defines `RED_FONT_COLOR`, `WARNING_FONT_COLOR`, `LIGHTBLUE_FONT_COLOR`, and `GREEN_FONT_COLOR` fallbacks used by `tr.lua`. |
| 4 | `C_Timer` (full `NewTimer` + `NewTicker`) | Not present in 3.3.5a. Implemented via a Frame `OnUpdate` driver. Both return an object with a `Cancel()` method, matching the modern API contract. Used by `display.lua`, `glow.lua`, `effect.lua`, `variables/actionusable.lua`, and `variables/talent.lua`. |
| 5 | `strlenutf8` | Not guaranteed on all 3.3.5a builds. Used in `options/InterfaceOptionsPanels.lua` to estimate button pixel width. |
| 6 | `BNET_FRIEND_ZONE_WOW_CLASSIC`, `BNET_FRIEND_TOOLTIP_WOW_CLASSIC`, `KBASE_RECENTLY_UPDATED` | Localization globals absent on 3.3.5a. Used in the options panel build-info display. |
| 6 | `RACE_CLASS_ONLY`, `STACKS`, `CALENDAR_TOOLTIP_DATE_RANGE`, `HEALTH_COST_PCT`, `FROM` | GlobalStrings added in Cataclysm that are absent on 3.3.5a. Used in `tr.lua` (`OnlyFor`, `NbStacks`, `ExecuteBelow`, `FromClass`). Missing values caused a `bad argument #2 to 'format' (string expected, got nil)` crash. |
| 7 | `GetNumClasses`, `GetClassInfo` | Added in Cataclysm. `tr.lua:FromClass()` iterates over all classes to map a `classFile` string to its localised display name. Shim provides the 10 Wrath classes, preferring `LOCALIZED_CLASS_NAMES_MALE` (present on 3.3.5a) for correct localisation. |
| 8 | `GetClassColor` 4th return value | On 3.3.5a `GetClassColor` returns only `r, g, b`. The addon calls `select(4, GetClassColor(classFile))` expecting a hex string. The original function is wrapped to always produce the 4th value. |
| 9 | `C_Item.IsEquippedItem` | `components/util.lua` captures `local IsEquippedItem = C_Item and C_Item.IsEquippedItem`. `C_Item` is `nil` on 3.3.5a so the capture would yield `nil`. Stub `C_Item` table is provided, delegating to the native `IsEquippedItem` global. |
| 10 | `C_UnitAuras.GetPlayerAuraBySpellID` | `components/util.lua` captures `local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID` at load time. `C_UnitAuras` is nil on 3.3.5a so the local is nil, meaning `SAO:GetPlayerAuraStacksBySpellID` always returns `nil` → stacks=0 → no overlay fires (e.g. Molten Core warlock proc needs stacks≥1). The shim iterates `UnitAura("player",…)` and matches by spell name via `GetSpellInfo`, since 3.3.5a's `UnitAura` does not return `spellId` at the Cata+ position. Returns `{applications, auraInstanceID=nil, duration, expirationTime}`. |
| 11 | `GetSpellPowerCost` | Neither `C_Spell.GetSpellPowerCost` nor the legacy global exist on the 3.3.5a client. A shim is provided that derives cost information from `GetSpellInfo()` and returns the `{name, cost}` table format that `variables/actionusable.lua` expects. |
| 11 | `CreateColor` | Added in Legion. Used in `options/InterfaceOptionsPanels.lua` to create dimmed class-color objects for the per-class option labels. |
| 12 | `frame.Text` / `frame.Low` / `frame.High` + `Button:SetEnabled(bool)` + `frame:SetShown(bool)` | Three Cataclysm+ APIs missing in 3.3.5a. **`.Text`/`.Low`/`.High`**: modern XML uses `parentKey="Text"` so children are reachable as `frame.Text`; in 3.3.5a they are named `$parentText` and only accessible via `_G[frameName.."Text"]`. **`SetEnabled(bool)`**: 3.3.5a only has `Enable()`/`Disable()`. **`SetShown(bool)`**: 3.3.5a only has `Show()`/`Hide()`. Three-part fix: **(A)** an `ADDON_LOADED` handler that populates `.Text`/`.Low`/`.High` on the five named XML sliders and six named XML checkboxes, adds `SetEnabled` to the test button and all named checkboxes, and patches `SetShown` onto `SpellActivationOverlayContainerFrame` (XML-defined, bypasses the Lua wrapper); **(B)** a `CreateFrame` wrapper that adds `SetShown` to every frame, `SetEnabled` to every `Button`/`CheckButton`, and for `SpellActivationOverlayAddonTemplate` instances also injects `SetShown` onto `frame.mask` and `frame.combat` (the Texture children that `overlay.mask:SetShown(useTimer)` targets); **(C)** the same wrapper handles anonymous (name=nil) checkboxes from `classoptions.lua`/`glowoptions.lua`, using `frame:GetRegions()` to find the `$parentText` FontString child. |
| 13 | `GetFileIDFromPath` | Added in Mists of Pandaria. `textures/texname.lua:MarkTexture()` calls it to verify that a texture file exists on disk. On 3.3.5a the function is absent; a stub returning a truthy value is provided so the `"Missing file"` error branch is never hit (all textures ship with the addon). |
| 13b | `GetSpellBookItemName` | Added in Cataclysm (patch 4.0.1), replacing the pre-Cataclysm `GetSpellName()`. `components/util.lua:GetHomonymSpellIDs()` captures it as a local upvalue and uses it to enumerate the spellbook. The 3.3.5a shim calls `GetSpellName(index, bookType)` for the name/rank, `GetSpellBookItemInfo` for the spell ID (with a `GetSpellLink` hyperlink-parse fallback for servers that lack that too). |
| 13c | `C_SpecializationInfo` + `UnitClassBase` | `C_SpecializationInfo` (MoP+) is captured as local upvalues in `util.lua` at load time. On 3.3.5a all three captures (`GetSpecializationInfo`, `GetNumSpecializationsForClassID`, `GetTalentInfo`) would be nil, causing errors in `GetSpecName` and `GetNbSpecs`. The shim maps WotLK's talent-tree API: `GetSpecializationInfo(i)` wraps `GetTalentTabInfo(i)` returning `(id, name, desc, icon, role, stat)`; `GetNumSpecializationsForClassID` wraps `GetNumTalentTabs()`. `UnitClassBase(unit)` (Cata+) is also shimmed to return `classFilename, classID` using 3.3.5a's `UnitClass`. |
| 14 | `StanceBarFrame.StanceButtons` | `components/glow.lua` iterates `StanceBarFrame.StanceButtons` to hook stance button glows (Priest Shadowform). On 3.3.5a the buttons exist as globals `StanceButton1`…`StanceButton10` but are not stored as a table on the frame. A `PLAYER_LOGIN` handler populates `StanceBarFrame.StanceButtons` from those globals at login. |
| 15 | `UNIT_AURA` fallback trigger | On some 3.3.5a private servers the `COMBAT_LOG_EVENT_UNFILTERED` `dstGUID` may not match `UnitGUID("player")` exactly (different GUID prefix format), causing the CLEU aura-stack accounting in `components/aurastacks.lua` to silently skip player buffs. A dedicated `UNIT_AURA` frame is registered; on every player-unit aura change it schedules `SAO:CheckManuallyAllBuckets(SAO.TRIGGER_AURA)` 50 ms later (so `UnitAura` is fully updated) as a second, always-reliable trigger that fires regardless of CLEU accuracy. |
| 16 | Debug utilities (`/saodebug`, `/saodump`) | Two slash commands are provided to diagnose overlay issues in-game. **`/saodebug on\|off`** toggles verbose prints in the `COMBAT_LOG_EVENT_UNFILTERED` handler — each aura-related subevent prints the `spellId` and current `_auraCache` value. **`/saodump`** prints the state of every TRIGGER_AURA bucket (name, `required`/`informed` trigger flags, `currentHash`, `displayedHash`, `stackAgnostic`), the result of `GetPlayerAuraBySpellID` and the raw cache value for each, the player GUID, and the visibility/alpha of `SpellActivationOverlayContainerFrame` and `SpellActivationOverlayAddonFrame`. |
| 17 | `PLAYER_LOGIN` substitute for `LOADING_SCREEN_DISABLED` | `LOADING_SCREEN_DISABLED` was added in Cataclysm and never fires on a 3.3.5a client. The addon waits for it before calling `RegisterPendingEffectsAfterPlayerLoggedIn()`, so all effects remain in the pending list and `RegisteredBucketsBySpellID` stays empty — no overlays ever appear, regardless of aura events. `SAO.PLAYER_LOGIN` is defined in Compat335.lua before `InitializeEventDispatcher()` runs; since the addon already registers the `PLAYER_LOGIN` event in `SpellActivationOverlay_OnLoad`, the dispatcher picks it up automatically. The handler calls `SAO.LOADING_SCREEN_DISABLED` which is guarded against double-registration, so it is harmless if a server does fire `LOADING_SCREEN_DISABLED` too. Also permanently sets `SpellActivationOverlayFrame_SetForceAlpha1(true)` to disable the combat dim/fade system — on 3.3.5a this caused a visible brightness flash every time an overlay appeared out of combat. |
| 20 | `LCG.ShowOverlayGlow` / `LCG.HideOverlayGlow` aliases | `LibCustomGlow-1.0` (shipped with WeakAuras) only exposes `ButtonGlow_Start(frame)` / `ButtonGlow_Stop(frame)`, but `glow.lua` calls `LCG.ShowOverlayGlow` / `LCG.HideOverlayGlow`. The two names are aliased at `PLAYER_LOGIN` (after all addons are loaded) when LCG is registered in LibStub. |
| 21 | `LibButtonGlow-1.0` — full `ShowOverlayGlow` / `HideOverlayGlow` replacement | LBG internally uses `Animation:SetTarget(region)`, `Animation:SetFromAlpha/SetToAlpha`, and `Cooldown:GetCooldownDuration()` — all Cataclysm+ additions absent on 3.3.5a. Because the overlay-create logic is a private local closure the entire public API (`ShowOverlayGlow` / `HideOverlayGlow`) is replaced at `PLAYER_LOGIN`. Prefers delegating to `LibCustomGlow-1.0.ButtonGlow_Start/Stop` when WeakAuras is loaded (LCG uses an `OnUpdate`-based animation that works on 3.3.5a). Falls back to a custom `OnUpdate`-based glow using `IconAlert.blp` / `IconAlertAnts.blp` bundled in `SpellActivationOverlay/textures/`. Pre-existing LBG overlay objects that would crash are discarded by clearing `LBG.unusedOverlays`. |

### `textures/IconAlert.blp` and `textures/IconAlertAnts.blp` *(new files)*
- Copied from `WeakAuras/Libs/LibCustomGlow-1.0/` during the backport. Required by the Section 21 fallback glow path when WeakAuras is not loaded. `IconAlert.blp` (golden outer-glow ring, ~44 KB) and `IconAlertAnts.blp` (marching-ants border, ~88 KB) are rendered using `SetBlendMode("ADD")` with `OnUpdate`-driven alpha and texture-coordinate animation.

### `SpellActivationOverlay.xml`
- Both `<MaskTexture>` elements replaced with `<Texture>` elements. `MaskTexture` is a Cataclysm+ XML element that the 3.3.5a client does not recognise (it crashes with *"Couldn't find inherited node"*).
  - `parentKey="mask"` — drives the spell-alert timer countdown shrink animation. All Lua references (`overlay.mask`, `overlay.mask.timeoutX/Y/XY`) remain intact; the visual mask clipping effect is cosmetically lost but the animation timers still fire correctly.
  - `parentKey="combat"` — drives the out-of-combat fade for combat-only auras. All Lua references (`overlay.combat`, `overlay.combat.animIn/Out`) remain intact.
- Both textures are set `hidden="true"` since on 3.3.5a they render as plain visible textures rather than masks.

### `SpellActivationOverlay.lua`
- **Spell overlay blend mode** — added `overlay.texture:SetBlendMode("ADD")` immediately after `overlay.texture:SetTexture(texturePath)` in `ShowOverlay`. The overlay textures (e.g. `generictop_01.blp`) use a black background; without `ADD` blend mode the entire rectangle renders as a solid-coloured box instead of a transparent glow effect. This caused a visible green or coloured rectangle over the screen on 3.3.5a.

- **`SpellActivationOverlayTexture_OnFadeOutFinished`**: replaced `anim:GetRegionParent()` with a guarded fallback:
  ```lua
  local overlay = anim.GetRegionParent and anim:GetRegionParent()
                  or anim:GetParent():GetParent()
  ```
  `GetRegionParent()` does not exist on Animation objects in 3.3.5a. The fallback traverses `Alpha → AnimationGroup → Frame` which is the correct parent chain.

---

## Known Limitations

- **Spell-alert timer countdown bar** — the shrinking mask effect (showing remaining buff duration) is not visible because `MaskTexture` clipping is unavailable. Overlays still appear and disappear at the correct times.
- **Combat-only aura fade** — the out-of-combat dimming animation for combat-only auras runs but has no mask-clip effect; the auras remain fully rendered regardless of combat state.
- `C_Engraving`, `C_SpecializationInfo` — these modern namespaces are referenced only behind `and` guards and evaluate to `nil` gracefully on 3.3.5a. Season of Discovery rune engraving features are simply inactive.

## Known Issues (Unresolved)

### Green box on action bar button glows

When a proc triggers an action bar button glow (e.g. the button for a proc'd ability should light up with a golden ring), a solid green rectangle may appear instead of the intended glow animation.

**Root cause:** On 3.3.5a, any `SetTexture()` call that resolves to a missing or unreadable path renders as a solid green placeholder rectangle. The Section 21 fallback glow path (used when WeakAuras is not loaded) creates overlay frames with textures pointing to `Interface\AddOns\SpellActivationOverlay\textures\IconAlert` and `IconAlertAnts`. Despite both `.blp` files being present on disk, the green box persists — suggesting either a texture-load issue with the bundled files, a blend-mode interaction, or the fallback path not activating correctly.

**Workaround:** Load WeakAuras alongside SpellActivationOverlay. When WeakAuras is present at `PLAYER_LOGIN`, Section 21 delegates to `LibCustomGlow-1.0.ButtonGlow_Start/Stop`, which is confirmed working on 3.3.5a. The green box only appears when WeakAuras is absent.

---

## Installation

Copy the `SpellActivationOverlay` folder into your `Interface/AddOns/` directory. No other addons are required.
