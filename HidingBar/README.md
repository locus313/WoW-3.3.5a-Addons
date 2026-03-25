# HidingBar v3.4.20 — WoW 3.3.5a Backport Notes

This document describes every change made to backport HidingBar v3.4.20
(originally targeting modern WoW / Wrath Classic) to the 3.3.5a client
(interface version 30300, Lua 5.1).

---

## Files Modified

| File | Change type |
|---|---|
| `HidingBar.toc` | Interface version, added compat file |
| `HidingBar_Options/HidingBar_Options.toc` | Interface version, added compat file |
| `HidingBar/compat_335.lua` | **Created** — main polyfill shim |
| `HidingBar_Options/compat_335.lua` | **Created** — options UI polyfill shim |
| `HidingBar/HidingBar.lua` | Various runtime compat fixes |
| `HidingBar_Options/Config.lua` | Settings panel API rewrite |
| `HidingBar_Options/About.lua` | Settings panel API rewrite |
| `HidingBar_Options/templates.xml` | XML template cleanup |
| `libs/LibDBIcon-1.0/LibDBIcon-1.0.lua` | Animation / frame method guards |

---

## 1. TOC Files

**`HidingBar.toc`** and **`HidingBar_Options/HidingBar_Options.toc`**

- Changed `## Interface:` from the modern value to `30300`.
- Added `compat_335.lua` as the **first** listed file so all polyfills are in
  place before any addon code runs.

---

## 2. New File: `HidingBar/compat_335.lua`

A self-contained shim loaded first by the TOC. Provides:

### `securecallfunction`
Added after 3.3.5a; used by **CallbackHandler-1.0 v8** to fire callbacks with
taint protection. Polyfill simply calls the function directly:
```lua
if not securecallfunction then
    securecallfunction = function(func, ...) return func(...) end
end
```

### `C_Timer.After`
Absent in 3.3.5a. Polyfilled with an `OnUpdate`-based frame timer.

### `C_Texture.GetAtlasInfo`
Atlas system does not exist in 3.3.5a. Stub returns `nil`.

### `C_AddOns`
The `C_AddOns` namespace was added later. Aliases the legacy globals
(`GetAddOnMetadata`, `IsAddOnLoaded`, etc.).

### `GetPhysicalScreenSize`
Not present in 3.3.5a. Returns `GetScreenWidth(), GetScreenHeight()`.

### `BackdropTemplateMixin` / `CreateFromMixins`
Mixin system added post-3.3.5a. Stub empty table / shallow-copy helper.

### Frame method stubs (metatable patch)
The following methods were added to Frames/Buttons after 3.3.5a.
The shim patches them onto the frame metatable's `__index` table
(verified to work in 3.3.5a when `type(mt.__index) == "table"`):

| Method | Polyfill behaviour |
|---|---|
| `IsIgnoringParentScale` | returns `false` |
| `HasFixedFrameStrata` | returns `false` |
| `HasFixedFrameLevel` | returns `false` |
| `DoesClipChildren` | returns `false` |
| `SetClipsChildren` | no-op |
| `SetFixedFrameStrata` | no-op |
| `SetFixedFrameLevel` | no-op |
| `SetIgnoreParentScale` | no-op |
| `IsMouseMotionEnabled` | delegates to `IsMouseEnabled` |
| `IsMouseClickEnabled` | delegates to `IsMouseEnabled` |
| `SetMouseMotionEnabled` | delegates to `EnableMouse` |
| `SetMouseClickEnabled` | delegates to `EnableMouse` |
| `SetShown(frame, bool)` | calls `Show()` or `Hide()` |

### Texture method stubs (metatable patch)
`SetColorTexture`, `SetRotation`, `GetAtlas`, `SetAtlas` — patched onto the
Texture object metatable. `SetColorTexture` is emulated via `SetTexture` +
`SetVertexColor`.

### Animation method stubs (metatable patch)
Alpha / AnimationGroup animation objects **do** expose a Lua-table `__index`
in 3.3.5a, so these can be patched:

- `Alpha:SetFromAlpha` — no-op (animation fading unsupported)
- `Alpha:SetToAlpha` — no-op
- `Alpha:SetStartDelay` — no-op
- `AnimationGroup:SetToFinalAlpha` — no-op

---

## 3. New File: `HidingBar_Options/compat_335.lua`

Separate shim for the options UI. Provides:

### `SOUNDKIT` table
`PlaySound()` in 3.3.5a takes a raw numeric ID. The constants table was added
later. The shim maps the handful of sounds used by HidingBar Options.

### `HybridScrollFrame` API
3.3.5a has no `HybridScrollFrame`. The shim reimplements the entire
`HybridScrollFrame_GetOffset` / `HybridScrollFrame_Update` /
`HybridScrollFrame_CreateButtons` API on top of `FauxScrollFrame` semantics
(scroll bar `SetMinMaxValues` + manual offset tracking).

---

## 4. `HidingBar_Options/Config.lua` — Settings Panel

The modern addon uses `Settings.RegisterCanvasLayoutCategory` (added in
Dragonflight). In 3.3.5a it must use `InterfaceOptions_AddCategory`. The file
was rewritten accordingly:

- `Settings.RegisterCanvasLayoutCategory(...)` → `InterfaceOptions_AddCategory`
- `Settings.OpenToCategory(...)` → `InterfaceOptionsFrame_OpenToCategory`
- `ADDON_LOADED` + `UPDATE_BINDINGS` events replace the modern settings
  framework listeners.

---

## 5. `HidingBar_Options/About.lua`

Same Settings-API migration:
- Replaced `Settings.*` calls with `InterfaceOptions_AddCategory`.
- Removed Blizzard addon metadata API calls that don't exist in 3.3.5a.

---

## 6. `HidingBar/HidingBar.lua`

### 6a. `hb` instance stubs (top of file)
HidingBar calls many frame methods as `hb.METHOD(btn, ...)` (with `hb` as a
proxy object). Because metatable patching cannot be guaranteed to land before
`hb` is used, the same stubs from the compat shim are also set directly on the
`hb` frame instance at startup:

```
IsIgnoringParentScale, HasFixedFrameStrata, HasFixedFrameLevel,
DoesClipChildren, SetClipsChildren, SetFixedFrameStrata, SetFixedFrameLevel,
SetIgnoreParentScale, IsMouseMotionEnabled, IsMouseClickEnabled,
SetMouseMotionEnabled, SetMouseClickEnabled
```

### 6b. `xpcall` — Lua 5.1 limitation
WoW 3.3.5a uses Lua 5.1 where `xpcall(f, handler, arg1, ...)` extra arguments
are **silently ignored** (the feature was added in Lua 5.2).

```lua
-- Before:
xpcall(self.setProfile, geterrorhandler(), self)

-- After:
xpcall(function() hb:setProfile() end, geterrorhandler())
```

### 6c. `SetClipsChildren` guards
Three call sites (`setBtnSettings`, `setMBtnSettings`, `setClipButtons`) call
`btn:SetClipsChildren()`. Wrapped with an existence check:
```lua
if btn.SetClipsChildren then btn:SetClipsChildren(...) end
```

### 6d. `CreateAnimationGroup` hook — `getmetatable().__index` is a C function
HidingBar hooks `btn.CreateAnimationGroup` to intercept animation group
creation. The original hook tried to call the native method via
`getmetatable(self).__index.CreateAnimationGroup(self, ...)`.

In 3.3.5a `getmetatable(frame).__index` is a **C dispatcher function**, not a
Lua table — indexing it returns `nil`. Fixed with the "nil-the-hook, call
native, re-apply" pattern:
```lua
local function CreateAnimationGroup(self, ...)
    self.CreateAnimationGroup = nil          -- expose native
    local ag = self:CreateAnimationGroup(...)
    self.CreateAnimationGroup = CreateAnimationGroup  -- re-hook
    ag.Play = void
    return ag
end
```
The same pattern is applied to the `SetScript` hook.

### 6e. Animation `GetTarget` / `GetObjectType` guards
These methods were added after 3.3.5a. The `setHooks` loop that inspects
existing animation groups guards both calls:
```lua
local target   = animation.GetTarget      and animation:GetTarget()
local animType = animation.GetObjectType  and animation:GetObjectType()
```

### 6f. `Show` / `Hide` / `IsShown` hooks — `SetShown` recursion fix
HidingBar hooks `btn.Show`, `btn.Hide`, `btn.IsShown`, and `btn.SetShown` on
managed buttons. The original code:
- `Show(btn)` called `btn:SetShown(true)` → invokes HidingBar's own
  `SetShown(btn, true)` state tracker (correct by design).
- `IsShown(btn)` called `hb.SetShown(btn, show)` to physically show/hide the
  button via the native C method accessed through `hb`.

In 3.3.5a, native `Frame:SetShown` does not exist. Our compat polyfill fills it
in as `if show then self:Show() else self:Hide() end`. This caused a stack
overflow because:
`IsShown` → compat `SetShown` → `btn:Show()` → hooked `Show` → `btn:SetShown(true)` → compat `SetShown` → ... ∞

Fix: `IsShown` temporarily removes the `Show`/`Hide` instance overrides before
calling the native C-level method, then restores them:
```lua
local function IsShown(btn)
    local show = <...compute visibility...>
    btn.Show = nil
    btn.Hide = nil
    if show then btn:Show() else btn:Hide() end  -- hits native C method
    btn.Show = Show
    btn.Hide = Hide
    return show
end
```

### 6g. `self.drag:SetShown(not self.config.lock)`
One usage of `SetShown` on the bar drag handle that is not part of the hook
system. Replaced inline:
```lua
if not self.config.lock then self.drag:Show() else self.drag:Hide() end
```

---

## 7. `libs/LibDBIcon-1.0/LibDBIcon-1.0.lua`

### Animation method guards
`createButton()` creates an `Alpha` animation for the minimap button fade.
In 3.3.5a the animation object exists but these specific methods don't:

```lua
if animOut.SetFromAlpha    then animOut:SetFromAlpha(1) end
if animOut.SetToAlpha      then animOut:SetToAlpha(0) end
if animOut.SetStartDelay   then animOut:SetStartDelay(1) end
if button.fadeOut.SetToFinalAlpha then button.fadeOut:SetToFinalAlpha(true) end
```
Applied in both the initial `createButton` block and the "upgrade to v39" loop.

### `SetFixedFrameStrata` / `SetFixedFrameLevel` guards
These frame methods don't exist in 3.3.5a:
```lua
if button.SetFixedFrameStrata then button:SetFixedFrameStrata(true) end
if button.SetFixedFrameLevel  then button:SetFixedFrameLevel(true) end
```

---

## Summary of Root Causes

| Root cause | Affected APIs |
|---|---|
| Lua 5.1 — `xpcall` ignores extra args | `xpcall(f, h, arg)` |
| Frame `__index` is a C dispatcher, not a Lua table | `CreateAnimationGroup` hook, `SetScript` hook |
| APIs added post-3.3.5a (widget methods) | `SetShown`, `SetFixedFrameStrata`, `SetFixedFrameLevel`, `SetClipsChildren`, `SetIgnoreParentScale`, `HasFixedFrameStrata`, `HasFixedFrameLevel`, `DoesClipChildren`, `IsMouseMotionEnabled`, `IsMouseClickEnabled`, `SetMouseMotionEnabled`, `SetMouseClickEnabled` |
| APIs added post-3.3.5a (animation methods) | `SetFromAlpha`, `SetToAlpha`, `SetStartDelay`, `SetToFinalAlpha`, `GetTarget`, `GetObjectType` |
| APIs added post-3.3.5a (global/namespace) | `securecallfunction`, `C_Timer`, `C_Texture`, `C_AddOns`, `GetPhysicalScreenSize`, `BackdropTemplateMixin`, `CreateFromMixins`, `SOUNDKIT`, `HybridScrollFrame_*` |
| Settings framework replaced in Dragonflight | `Settings.RegisterCanvasLayoutCategory`, `Settings.OpenToCategory` |
