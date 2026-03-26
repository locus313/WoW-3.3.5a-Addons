# Enchantrix v5.9.4960 — WoW 3.3.5a Fix Notes

---

## File Modified

| File | Change |
|---|---|
| `EnxMiniIcon.lua` | Fixed `sideIcon` proxy being overwritten when SlideBar is absent || `EnxMiniIcon.lua` | Hide native `miniIcon` when LDB icon is active to avoid duplicate icons |
---

## Bug: `attempt to call field 'OnTooltipShow' (a nil value)` on hover

**File:** `EnxMiniIcon.lua` line 178  
**Trigger:** Hovering over the Enchantrix minimap icon when SlideBar is not loaded.

### Root Cause

`EnxMiniIcon.lua` sets up the LDB data object in two stages:

1. If `LibDataBroker` is available, `sideIcon` is assigned the LDB proxy object,
   and `OnTooltipShow` / `OnEnter` / `OnLeave` are defined as methods on it.
2. A subsequent `if sideIcon and SlideBar then ... else` block was intended to
   add a `SlideBar.AddButton` integration. However, the `else` branch
   unconditionally ran `sideIcon = {}`, **replacing the LDB proxy** with an
   empty table.

On setups where `SlideBar` is not loaded (but `LibDataBroker` is), the condition
`sideIcon and SlideBar` is falsy — so the `else` branch fired and wiped the
proxy. When the minimap icon was hovered, the `OnEnter` closure called
`sideIcon.OnTooltipShow(GameTooltip)` on the now-empty table, causing:

```
attempt to call field 'OnTooltipShow' (a nil value)
```

### Fix

Changed the `else` branch to only initialise `sideIcon` as an empty table if it
was never assigned (i.e. LibDataBroker was not available):

```lua
-- Before:
else
    sideIcon = {}          -- unconditionally destroys LDB proxy
    function sideIcon.Update() end
end

-- After:
else
    if not sideIcon then sideIcon = {} end   -- only reset if never set
    function sideIcon.Update() end
end
```
---

## Bug: Duplicate icon — native miniIcon visible alongside LDB/HidingBar icon

**File:** `EnxMiniIcon.lua`  
**Symptom:** When HidingBar (or any LDB display) shows the Enchantrix icon, the
original native minimap icon (`miniIcon`) also remains visible next to the minimap.

### Root Cause

Enchantrix creates two independent icons:

1. **`miniIcon`** — a raw `Button` frame parented to `Minimap`, shown/hidden via
   the `miniicon.enable` setting.
2. **`sideIcon`** — a LibDataBroker data object, picked up by LibDBIcon /
   HidingBar as the standard minimap button.

There was no code to suppress `miniIcon` when `sideIcon` was successfully
created. Both ended up visible simultaneously.

### Fix

When `LibDataBroker` is available and `sideIcon` is created, immediately hide
`miniIcon` and override its `Reposition` function to keep it hidden, preventing
the settings system from re-showing it:

```lua
miniIcon:Hide()
miniIcon.Reposition = function() miniIcon:Hide() end
```