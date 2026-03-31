# DejaClassicStats — WoW 3.3.5a Backport

Original addon by Dejablue, Kakjens, loudsoul.  
This folder contains a backport of version `30400r10` to the WoW 3.3.5a (WotLK) client.

---

## Backport Changes

### DejaClassicStats.toc
- Changed `## Interface: 30400` → `## Interface: 30300`

---

### DejaClassicStats.lua

**CR_ constant fallbacks**
- Added fallback definitions at the top of the file for `CR_RESILIENCE_CRIT_TAKEN` (= 25) and `CR_DEFENSE_SKILL` (= 2), which are not defined as named globals in the 3.3.5a FrameXML.

**`GetAddOnMetadata`**
- Already available in 3.3.5a; no change needed.

**`GetClassColor` → `RAID_CLASS_COLORS`**
- `GetClassColor` does not exist in 3.3.5a.
- Replaced with a lookup from `RAID_CLASS_COLORS[classFilename]`.

**`SetColorTexture` → `SetTexture`**
- `SetColorTexture` does not exist in 3.3.5a.
- Replaced all active calls with `SetTexture(r, g, b, a)`.

**`SetShown` → `Show`/`Hide`**
- `SetShown` does not exist in 3.3.5a (added in Cataclysm).
- Replaced all uses in the `OnScrollRangeChanged` handler with explicit `Show()`/`Hide()` calls.

**ScrollBar `.ScrollBar` property**
- `UIPanelScrollFrameTemplate` in 3.3.5a registers the scrollbar as a global (`DCS_StatScrollFrameScrollBar`) but does not populate `.ScrollBar` on the frame object.
- Added `DCS_StatScrollFrame.ScrollBar = DCS_StatScrollFrameScrollBar` immediately after frame creation.

**`C_Timer.NewTimer` → OnUpdate-based timer**
- `C_Timer` does not exist in 3.3.5a.
- Replaced the rotation button hide-delay timer with a persistent `OnUpdate` frame accumulating elapsed time.

**`hideDCSRB` forward declaration**
- `hideDCSRB` was declared as a `local function` *after* an `OnUpdate` closure that called it, resulting in a nil global lookup at runtime.
- Added `local hideDCSRB` forward declaration before the timer frame, and changed the definition to `hideDCSRB = function(...)` to assign to the upvalue.

**`MovementSpeed` — `GetUnitSpeed` return values**
- In 3.3.5a, `GetUnitSpeed` returns only one value (current speed in yards/sec). Later versions returned `currentSpeed, runSpeed, flightSpeed, swimSpeed`.
- Simplified the function to use `currentSpeed` directly (7 yards/sec = 100% base run speed).

**Stat tooltip format strings — undefined `TooltipLine2`/`TooltipLine3`**
- Several combat rating functions (`RangedCrit`, `HitModifier`, `MeleeHaste`, `RangedHitModifier`, `RangedHaste`, `SpellHitModifier`, `SpellHaste`) referenced `TooltipLine2` and/or `TooltipLine3` in their `return` statements but only had those variables defined in commented-out lines.
- Replaced undefined references with `""`.

**`CR_HIT_*_TOOLTIP` / `CR_EXPERTISE_TOOLTIP` format calls**
- `format(CR_HIT_MELEE_TOOLTIP, ...)`, `format(CR_HIT_RANGED_TOOLTIP, ...)`, `format(CR_HIT_SPELL_TOOLTIP, ...)`, and `format(CR_EXPERTISE_TOOLTIP, ...)` were called with the wrong number of arguments for 3.3.5a's format strings.
- Replaced with safe inline tooltip strings.

**`Resilience()` function**
- `STAT_RESILIENCE`, `RESILIENCE_TOOLTIP` may be nil or have a different format specifier count in some 3.3.5a builds.
- Added nil guards and wrapped the `format` call in `pcall`.

---

### DCSDuraRepair.lua

**`SetColorTexture` → `SetTexture`**
- Replaced all active `SetColorTexture` calls in the durability bar, mean texture, and item color overlay functions.

**`SetObeyStepOnDrag`**
- Does not exist in 3.3.5a. Removed the call (commented out).

**`C_Item.GetItemQualityByID` → `GetItemInfo`**
- Replaced with `select(3, GetItemInfo(itemLink))` which returns the quality value in 3.3.5a.

**`Item:CreateFromEquipmentSlot` / `item:GetCurrentItemLevel` / `item:GetItemQuality` → `GetItemInfo`**
- The `Item` mixin does not exist in 3.3.5a.
- `attempt_ilvl`: replaced with `GetInventoryItemLink` + `GetItemInfo`, with an OnUpdate-based retry when item data hasn't loaded yet.
- Enchant display: replaced `item:GetItemQuality()` with the quality return value from `GetItemInfo`.

**`C_Timer.After` → OnUpdate-based delay**
- `C_Timer` does not exist in 3.3.5a.
- Replaced the `C_Timer.After(0.25, DCS_Item_Level_Center)` call in the `PLAYER_EQUIPMENT_CHANGED` handler with an inline OnUpdate frame accumulator.

**`DCS_Item_RepairCostBottom` — GameTooltip creation**
- Was creating an anonymous `CreateFrame("GameTooltip")` (no name, no `SetOwner`) inside the item loop on every call. This fails in 3.3.5a.
- Replaced with a single persistent named tooltip (`DCS_RepairScanTooltip`) created once on first use with proper `SetOwner`. Also added a nil guard on the repair cost result.

**`DCSScanTooltip` (enchant scan tooltip)**
- Was created with a fixed global name inside a function called on every equipment change. Re-registering the same global name errors in 3.3.5a.
- Lifted to module level as a single persistent frame.

**`ENCHANTED_TOOLTIP_LINE` nil guard**
- Added `ENCHANTED_TOOLTIP_LINE and` guard in case the global is absent.

---

### DCSExpand.lua

**`TradeSkillFrame`, `CraftFrame`, `PlayerTalentFrame` nil guards**
- These frames are lazily loaded and may not exist when the character frame first opens.
- Added `frame and frame:IsVisible()` nil guards in the `PaperDollFrame:HookScript("OnShow", ...)` callback and the `OnHide` callback.

**`LoadAddOn` result guard**
- Added `if _G[v.."Frame"] == nil then return end` after each `LoadAddOn` call, since `LoadAddOn` can silently fail if the addon file isn't present in the 3.3.5a client.

---

### DejaClassicStats.lua (continued)

**`DCS_TalentArtFrames` — nil `DCS_TalentSpec` guard**
- `DCS_GetTalents()` calls `GetTalentTabInfo()` to determine which talent tree is Primary/Offense/Defense. On login or before talent data is fully loaded, `GetTalentTabInfo` may return nil/empty, leaving the spec index variables nil.
- `DCS_TalentArtFrames` would then attempt to concatenate a nil value into an `Interface\\TALENTFRAME\\...` texture path, causing a runtime error.
- Added `if not DCS_TalentSpec then return end` at the top of `DCS_TalentArtFrames` to skip texture creation when talent data is unavailable.
