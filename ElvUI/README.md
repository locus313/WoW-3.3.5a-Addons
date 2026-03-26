# ElvUI — Modifications

## Auctioneer Scan Button Overlap Fix

**File:** `Modules/Skins/Blizzard/AuctionHouse.lua`

### Problem

When using ElvUI alongside the Auctioneer addon, the scan control buttons (Stop / Play / Pause / GetAll) added by `Auc-Util-ScanButton` to the Auction House Browse tab overlapped with the "Level:" text label repositioned by ElvUI's AH skin.

- Auctioneer anchors its button container at `TOPLEFT(180, -15)` on `AuctionFrameBrowse` with a height of 18 px, occupying approximately `y: -15` to `y: -33`.
- ElvUI placed `BrowseLevelText` with its `BOTTOMLEFT` at `y = -31`, putting the label's top edge at ~`y = -18` — directly overlapping the buttons.

### Fix

`BrowseLevelText` was moved down and the gap to `BrowseMinLevel` tightened so everything still fits above the sort-tab row:

| Element | Before | After |
|---|---|---|
| `BrowseLevelText` BOTTOMLEFT y | `-31` | `-48` |
| `BrowseMinLevel` y offset from label | `-6` | `-1` |
| `BrowseNameText` TOPLEFT y | `-19` | `-32` |
| `BrowseResetButton` TOPLEFT y | `-59` | `-72` |
| `IsUsableCheckButton` | default | `LEFT of BrowseDropDown RIGHT, offset (8, 5)` |
| `ShowOnPlayerCheckButton` | default | `LEFT of IsUsableCheckButton RIGHT, offset (80, 0)` |
| `BrowsePrevPageButton` | `TOPLEFT(636, -28)` | `60px gap to left of BrowseNextPageButton` |
| `BrowseNextPageButton` | `TOPRIGHT(72, -28)` | `RIGHT of BrowseCloseButton LEFT +60px` |
