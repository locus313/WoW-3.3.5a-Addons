# ACP (Addon Control Panel) — ElvUI Skin Support

## Files Changed

| File | Change Type |
|---|---|
| `ElvUISkin.lua` | Created |
| `ACP.toc` | Modified |

## ElvUISkin.lua — ElvUI visual integration

**Root cause:** ACP's window used the stock Blizzard `HelpFrame` border art and `UIPanelButtonTemplate`
buttons, which look out of place next to an ElvUI-skinned interface.

**Change:** Added `ElvUISkin.lua`, which reskins the ACP window to match ElvUI's flat, dark theme
(borders, buttons, checkboxes, dropdown, and scroll area) using ElvUI's public `Skins` module API
(`S:HandleButton`, `S:HandleCheckBox`, `S:HandleCloseButton`, `S:HandleDropDownBox`, `frame:SetTemplate`).
`ACP.toc` now lists `## OptionalDeps: ElvUI` so, when ElvUI is enabled, it loads first and its
`ElvUI` global/`Skins` module are guaranteed to exist before this file runs.

**Why:** The file bails out immediately via `if not IsAddOnLoaded("ElvUI") then return end`, so ACP
keeps its original Blizzard look when ElvUI isn't installed — this is a pure visual add-on, not a
compatibility shim. Skinning is deferred to `PLAYER_LOGIN` because ElvUI doesn't populate `E.media`
(colors/textures) or finish initializing until then, even though both addons' files load earlier.

Follow-up fixes after the first pass:

- The per-row "Enabled" checkbox is 32x32 (larger than ElvUI's usual ~16-20px checkboxes). Left at
  full size, ElvUI's gold "checked" texture filled the whole 32px box and overlapped neighboring
  16px-tall rows, merging into one solid gold bar down the list. A one-time resize wasn't enough:
  `ACP:AddonList_OnShow()` (ACP.lua ~1579) explicitly resets each checkbox back to 32x32 (or 16x16
  for nested/indented entries) on every list refresh and scroll. Fixed by `hooksecurefunc`-ing
  `ACP:AddonList_OnShow` to re-clamp every checkbox back down to 20px after each refresh.
- ACP injects an "AddOns" button into the Escape menu (`GameMenuButtonAddOns` in `ACP.xml`).
  ElvUI's own game-menu skin (`Blizzard/Misc.lua`) only knows about Blizzard's stock menu buttons,
  so this button was left unskinned next to the others. Fixed by calling `S:HandleButton()` on it
  ourselves.
- The bottom-row buttons (Sets / Disable All / Enable All / ReloadUI / Close) didn't match the
  ElvUI-skinned Interface Options buttons. They now copy their size and font from
  `InterfaceOptionsFrameOkay` at runtime (falling back to Blizzard's 96x22 default), with Sets kept
  narrower at 48px. ACP.xml spaced these buttons for 80px widths, so they're re-anchored in a chain
  from each frame corner with a 3px gap (like Interface Options) to avoid overlapping.
- Even at identical sizes, the buttons still rendered much larger than Okay/Cancel. The root
  cause: `ACP_AddonList` is defined in `ACP.xml` with no parent, so it ignores the scale ElvUI sets
  on `UIParent` (measured in-game: Okay button effective scale 0.68, ACP 1.0). The whole window,
  including its fonts and borders, was drawn about 1.47x larger than everything else. Fixed by
  calling `ACP_AddonList:SetParent(UIParent)` while skinning, which also keeps ElvUI's
  pixel-perfect borders correct.

## Known Limitations

- The per-row "Security" (signed-addon badge) and "Collapse" (expand/arrow) icon buttons are left
  unskinned to preserve their meaningful icon textures; ElvUI's `S:HandleButton` would otherwise
  blank out `NormalTexture`.
- The addon list's `FauxScrollFrame` has no real scrollbar widget (mouse-wheel only); its decorative
  track art is stripped rather than replaced with an ElvUI-style scrollbar.
