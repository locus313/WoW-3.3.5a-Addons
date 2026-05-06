# Comix — WoW 3.3.5a Back-port

**Original addon:** [bkader/Comix-WotLK](https://github.com/bkader/Comix-WotLK)
**Interface:** 30300 (WotLK 3.3.5a)
**Version:** 1.0.0

Comix plays sounds and comic-book pop-up images when you crit, die, get rezzed, change zones,
cast certain abilities, and more. This version has been patched for the 3.3.5a client and
includes a new NPC-click sound feature.

---

## Files Changed

| File | Change type |
|---|---|
| `Core.lua` | Bug fixes + new feature |
| `Options.lua` | New option added |
| `Locales/enUS.lua` | New locale strings |

---

## Summary of all fixes

| # | Severity | Description |
|---|---|---|
| 1 | Bug | `ToggleEvent` OR-logic: last flag always won, could unregister events still needed |
| 2 | Bug | Jump hook registered on every settings change — sound fired N times per jump after N option toggles |
| 3 | Bug | Screen shake: `WorldFrame` never restored to original position after shake ends |
| 4 | Bug | "Finish Him" `finishSound` sub-toggle in options had no effect — sound always played |
| 5 | Bug | `DongPic` accumulated extra anchor points on frame reuse — images appeared in wrong positions |
| 6 | Bug | `COMBAT_LOG_EVENT_UNFILTERED` missing `battleSound`/`critHeal` flags — those features went silent if `critical`/`overkill`/`killCount` were all off |
| 7 | Bug | Objection handler registered via `specialSound` flag instead of `objection` — objections never fired when only `specialSound` was disabled |
| 8 | Bug | `scale` option key mismatched `maxScale` profile key — Scale slider was broken and had no range bounds |
| 9 | Bug | `ZONE_CHANGED_NEW_AREA` not registered when only `specialSound` was on — instance "Underground Lair" sound never played |
| 10 | Bug | `critGap` stored as string by AceGUI input widget, compared as number — Lua 5.1 error when Critical Gap was enabled |
| 11 | Bug | `SWING_DAMAGE` crit used `ImageFrostCt` (11) instead of `ImagePhysicalCt` (12) as the random range for Physical images |
| 12 | Bug | `critGap` being `false` (empty input) still compared with `<` — Lua 5.1 error on all three crit-gap checks |
| 13 | Bug | `demoSound` image and sound only triggered when `abilitySound` was also on |
| 14 | Bug | Direct `DongPic` calls (Demo Shout, Battle Shout, iron-man crit) bypassed the `images` toggle — images showed even when disabled |
| 15 | Bug | Overkill check never fired — 3.3.5a combat log uses `-1` for "no overkill", so `amount - (-1)` passed the size test but the ratio was always negative |
| 16 | Bug | `critPercent` slider had no effect — both crit blocks hardcoded `random(1,100) <= 100` instead of using the profile value |
| 17 | Bug | `UNIT_SPELLCAST_SENT` had no unit filter — party members casting Death Grip etc. triggered your own sounds |
| 18 | Bug | Heal crit blocks also hardcoded `random(1,100) <= 100`, ignoring `critPercent` |
| 19 | Bug | Zone sound debounce dead code — `elseif < 30` branch was always taken (< 15 implies < 30), making effective debounce 15 s not 30 s |
| 20 | Bug | `overkillGap` slider had no effect — ratio check hardcoded `0.75` instead of `db.profile.overkillGap / 100` in both overkill blocks |
| 21 | Bug | `objectionPublic` toggle was dead code — else branch in `CHAT_MSG_TEXT_EMOTE` was empty; non-party objections never played regardless of setting |
| 22 | Crash | `animSpeed` slider allowed min of 0 — `frame:SetScale(0)` crashes the WoW 3.3.5a client; min raised to 0.1 |
| 23 | Bug | Animation status=1 (hold-at-peak) condition was always true — `scales[i] >= maxScale * 0.4` is always satisfied since scale was just set to `maxScale`, so the hold phase was skipped every time; replaced with a 0.15 s timer |
| 24 | Bug | `critPercent` range widget missing `min`/`max`/`step` — AceConfigDialog-3.0 requires these; the slider was non-functional without them; added `min=1, max=100, step=1` |
| 25 | Bug | `strfind` calls not using plain matching — `L["detects a hint of drama."]` contains a `.` Lua pattern wildcard; all `strfind` calls now pass `true` as the 4th argument for plain string matching |
| 26 | Bug | `MessageSender` duplicate `else` branch did same as `elseif` — non-command, non-numeric inputs were sent to `CHANNEL` with a string as channel ID (silently dropped by WoW); branch removed |
| 27 | Bug | `KillCount` dead guard — `self.killCountPlayed = false` immediately followed by `if not self.killCountPlayed` is always true; removed the redundant flag and flattened the block |
| 28 | Bug | `self.worldFramePoints` collected in `OnEnable` but never read anywhere — removed the dead collection loop |
| 29 | Crash | Shake divide-by-zero — `102 - shakeIntensity - shakeOffset` reaches 0 at legal slider values (e.g. intensity=100, offset=2); clamped denominator to a minimum of 1 |
| 30 | Bug | `table_len` helper defined in `LoaddaShit` closure but never called — removed |
| 31 | Feature | NPC-click sounds: targeting Mr. Bigglesworth or Muffin Man Moser now plays a sound |
| 32 | Bug | Jump counter was session-only — `jumpCount` moved to `db.profile` so it persists across relogs/reloads; new slash commands `/comix showjump`, `/comix clearjump`, `/comix reportjump` |
| 33 | Feature | Hug counter: `/hug` emotes are counted and persisted to `ComixDB`; new slash commands `/comix showhug`, `/comix clearhug`, `/comix reporthug` |

---

## Changes

### `Core.lua`

#### Bug fix — `ToggleEvent` OR-logic

`ToggleEvent` is called to register or unregister an event whenever `ApplySettings` runs.
Several events are shared by multiple feature flags (e.g. `COMBAT_LOG_EVENT_UNFILTERED` is used
by `critical`, `overkill`, and `killCount`). The original loop evaluated each flag in order and
wrote the result unconditionally, so the **last** flag always won. If `killCount` was `false`
but `critical` was `true`, the event would still be unregistered.

**Before:**

```lua
function Comix:ToggleEvent(event, ...)
    for i = 1, select("#", ...) do
        if self.db.profile[select(i, ...)] == true then
            self:RegisterEvent(event)
        else
            self:UnregisterEvent(event)
        end
    end
end
```

**After:**

```lua
function Comix:ToggleEvent(event, ...)
    local shouldRegister = false
    for i = 1, select("#", ...) do
        if self.db.profile[select(i, ...)] == true then
            shouldRegister = true
            break
        end
    end
    if shouldRegister then
        self:RegisterEvent(event)
    else
        self:UnregisterEvent(event)
    end
end
```

The event is now registered if *any* of the listed settings is enabled, and only unregistered
when *all* of them are disabled.

---

#### Bug fix — jump hook double-registration

`hooksecurefunc("JumpOrAscendStart", jumpOrAscendStart)` was called inside `ApplySettings`,
which runs every time a setting is changed in the options panel. Each call appended another
copy of the hook, so after toggling a setting 10 times the jump counter and boing sound would
fire 10+ times per jump.

**Before:**

```lua
-- jump sound
hooksecurefunc("JumpOrAscendStart", jumpOrAscendStart)
```

**After:**

```lua
-- jump sound (hooked once; hooksecurefunc chains on each call)
if not self.jumpHooked then
    hooksecurefunc("JumpOrAscendStart", jumpOrAscendStart)
    self.jumpHooked = true
end
```

---

#### New feature — NPC click sounds

When you target a special NPC the addon now plays a fitting sound. The NPC-to-sound mapping
is a plain Lua table (`self.NPCSounds`) built in `LoaddaShit`, making it easy to add more
entries. Two NPCs are wired up by default:

| NPC | Location | Sound file |
|---|---|---|
| Mr. Bigglesworth | Naxxramas | `Special/dr_evil.ogg` |
| Muffin Man Moser | Shattrath City (Lower City) | `Special/muffinman.ogg` |

Both sound files were already present in `Media/Sounds/Special/` but were never triggered.

The `PLAYER_TARGET_CHANGED` event handler (already registered for the "Finish Him" feature)
was updated to perform the NPC lookup:

```lua
function Comix:PLAYER_TARGET_CHANGED()
    self.finishTarget = (UnitExists("target") ~= nil)

    if self.db.profile.npcSound and UnitExists("target") and not UnitIsPlayer("target") then
        local npcSound = self.NPCSounds and self.NPCSounds[UnitName("target")]
        if npcSound then
            self:DongSound("customcomixsound", npcSound)
        end
    end
end
```

`PLAYER_TARGET_CHANGED` is already registered whenever either `finish` or `npcSound` is
enabled (the `ToggleEvent` call was updated accordingly).

To add more NPCs, extend the table in `LoaddaShit`:

```lua
self.NPCSounds = {
    ["Mr. Bigglesworth"] = self.Sounds.Special[5],   -- dr_evil.ogg
    ["Muffin Man Moser"] = self.Sounds.Special[10],  -- muffinman.ogg
    ["Your NPC Name"]    = self.Sounds.Special[7],   -- allyourbase.ogg, etc.
}
```

Use the exact English NPC name as it appears in-game (check with `/tar NPC Name`).

---

#### Bug fix — screen shake leaves `WorldFrame` offset

When the shake duration expired, the `OnUpdate` handler called `self:Hide()` immediately —
but never restored `WorldFrame` to its original position first. The screen stayed permanently
shifted by whatever random pixel offset happened to be active on the final tick.

**Before:**

```lua
if elapsed >= Comix.db.profile.shakeDuration or ... then
    self:Hide()
```

**After:**

```lua
if elapsed >= Comix.db.profile.shakeDuration or ... then
    -- Restore WorldFrame to its original position before hiding.
    WorldFrame:ClearAllPoints()
    for i = 1, #self.originalPoints do
        local v = self.originalPoints[i]
        WorldFrame:SetPoint(v[1], v[2], v[3], v[4], v[5])
    end
    self:Hide()
```

---

#### Bug fix — "Finish Him" `finishSound` sub-toggle had no effect

The `UNIT_HEALTH` handler played the "Finish Him" sound unconditionally whenever the target
dropped below the configured health threshold, completely ignoring the `finishSound` sub-toggle
in the options panel. Unchecking "Sound" under the Finish Him group did nothing.

**Before:**

```lua
self.finishTarget = false
self:DongSound(self.Sounds.Special, 12)
```

**After:**

```lua
self.finishTarget = false
if self.db.profile.finishSound then
    self:DongSound(self.Sounds.Special, 12)
end
```

---

#### Bug fix — `DongPic` accumulated anchor points on frame reuse

The addon cycles through 5 frames in round-robin to display pop-up images. Each call to
`DongPic` called `SetPoint` to position the frame but never called `ClearAllPoints` first.
On the second time a given frame was reused it had two anchor points, on the third it had
three, and so on. WoW resolves conflicting anchors in undefined ways, so images increasingly
appeared in the wrong position the longer a session ran.

**Before:**

```lua
self.frames[self.currentFrame]:SetPoint("CENTER", xCoords, yCoords)
```

**After:**

```lua
self.frames[self.currentFrame]:ClearAllPoints()
self.frames[self.currentFrame]:SetPoint("CENTER", xCoords, yCoords)
```

---

#### Bug fix — `COMBAT_LOG_EVENT_UNFILTERED` missing flags for `battleSound` and `critHeal`

The `COMBAT_LOG_EVENT_UNFILTERED` handler processes five distinct features:
`critical`, `overkill`, `killCount`, `battleSound`, and `critHeal`/`critHealFlash`. However
the `ToggleEvent` call only listed the first three. If all three of those were disabled in
the options panel, the event was unregistered — silently killing Battle Shout sounds and
heal-crit images/sounds even though their own toggles were still on.

**Before:**

```lua
self:ToggleEvent("COMBAT_LOG_EVENT_UNFILTERED", "critical", "overkill", "killCount")
```

**After:**

```lua
self:ToggleEvent("COMBAT_LOG_EVENT_UNFILTERED", "critical", "overkill", "killCount", "battleSound", "critHeal")
```

---

#### Bug fix — Objection handler registered via wrong flag

`CHAT_MSG_TEXT_EMOTE` (the event that carries emote text and is used for the Objection
feature) was registered and unregistered based on the `specialSound` flag instead of
`objection`. This meant:

- Disabling `specialSound` silently broke Objections.
- Disabling `objection` in the UI did **not** unregister the event.

This was subsequently superseded by the hug counter change below.

---

#### Feature — Hug counter

The hug counter must count `/hug` emotes regardless of whether objections or special sounds
are enabled. The `CHAT_MSG_TEXT_EMOTE` event is therefore now **always registered**
(unconditionally via `RegisterEvent`) rather than gated behind `ToggleEvent`.

The handler checks whether the emote sender is the player and whether the emote text contains
`"hug"` (plain match), then increments `db.profile.hugCount`.

**Before:**

```lua
self:ToggleEvent("CHAT_MSG_TEXT_EMOTE", "objection", "specialSound")
```

**After:**

```lua
self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")  -- objections, bad-joke/drama, hug counter
```

New slash commands added to `Commad_Comix`:

| Command | Action |
|---|---|
| `/comix showhug` | Print lifetime hug count to chat |
| `/comix reporthug` | Broadcast hug count via SAY |
| `/comix clearhug` | Reset hug count to 0 |

---

#### Bug fix — Jump counter not persisted

The original `jumpOrAscendStart` hook incremented a transient field (`self.jumpCount`) that
lived only in memory and was lost on every relog or UI reload. The counter was therefore
never actually lifetime-persistent despite the intent.

**Before:**

```lua
Comix.jumpCount = (Comix.jumpCount or 0) + 1
```

**After:**

```lua
Comix.db.profile.jumpCount = Comix.db.profile.jumpCount + 1
```

The default value `jumpCount = 0` is now declared in `Comix.defaults.profile` so AceDB
initialises it on first load. Three slash commands expose the counter:

| Command | Action |
|---|---|
| `/comix showjump` | Print lifetime jump count to chat |
| `/comix reportjump` | Broadcast jump count via SAY |
| `/comix clearjump` | Reset jump count to 0 |

---

### `Options.lua`

Added a **NPC Sounds** toggle in the "Other Options" section. Defaults to enabled.
Controls whether targeting special NPCs plays a sound.

Added `jumpCount = 0` and `hugCount = 0` to the default profile. Both counters are
persisted in `ComixDB` SavedVariables and survive relogs and UI reloads.

#### Bug fix — `scale` option key mismatched `maxScale` profile key

The Scale slider in the options panel used the key `"scale"`, reading and writing
`db.profile.scale` (which doesn't exist). The animation code reads `db.profile.maxScale`.
The slider was therefore completely non-functional — adjusting it had no visible effect.
Additionally the `range` widget had no `min`/`max`/`step` defined, which causes
AceConfigDialog-3.0 to default to 0–100 with no step, producing unusable values.

**Fixed:** gave the widget explicit `get`/`set` accessors pointing at `maxScale`, and added
`min = 0.5, max = 4, step = 0.1` bounds.

#### Bug fix — `critGap` stored as string, compared as number

The Critical Gap field uses `type = "input"`, which means AceGUI stores whatever the user
types as a plain string. The handler then compares it against a damage number:

```lua
if self.db.profile.critGapEnabled and amount < self.db.profile.critGap then
```

In Lua 5.1, comparing a number to a string with `<` throws a runtime error. The error would
silently disable the entire `COMBAT_LOG_EVENT_UNFILTERED` handler for the rest of the
session (Lua errors inside AceEvent handlers are caught but the handler stops executing).

**Fixed:** added explicit `get`/`set` overrides on the option that call `tostring()`/`tonumber()`
so the profile always holds a number (or `false` for empty input).

#### Bug fix — `ZONE_CHANGED_NEW_AREA` not registered when only `specialSound` is on

Inside `ZONE_CHANGED_NEW_AREA`, when entering a party/raid instance the addon plays the
"Underground Lair" special sound if `specialSound` is enabled, otherwise it falls back to a
zone sound. However, the event was only registered via `ToggleEvent("ZONE_CHANGED_NEW_AREA",
"zoneSound")`. If `zoneSound` was disabled but `specialSound` was on, the event was never
registered and the instance entrance sound never played.

**Before:**

```lua
self:ToggleEvent("ZONE_CHANGED_NEW_AREA", "zoneSound")
```

**After:**

```lua
self:ToggleEvent("ZONE_CHANGED_NEW_AREA", "zoneSound", "specialSound")
```

---

### `Locales/enUS.lua`

Added locale strings for:

- NPC Sounds option label and description.
- Hug counter messages: `"Hug counter reset."` and `"%s has hugged %d times."`.

---

## Known Limitations

- NPC name matching uses `UnitName("target")`, which returns the localized name on
  non-English clients. The `self.NPCSounds` table keys must match the localized names if
  you play on a non-English realm.
