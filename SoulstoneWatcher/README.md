# Soulstone Watcher
This addon will help you to keep track of soulstone's in your party/raid. Therefore your tank can use an resurrection in an instance without any delay or your healer can use it after a wipe for the Mass Resurrection.
You decide if a healer or tank will be checked and receives the buff.

## Features 
- Automatically checks if healer or tank soul are stored
- Able to set your main target for party and raid
- Print missing soulstone to player
- Popup buttons to cast the soulstone on a target (only for warlock)
- Send message to party/raid when a new soul is stored (only for warlock)

## Features Classic WotLK (3.3.5a)
- Able to bind your soulstone item (rank) to the cast bars
- Print if soulstone is ready (not on cooldown)
- Popup buttons to cast the soulstone on a target
- Send message to party/raid/say when a new soul is stored

## WotLK 3.3.5a Compatibility (v1.0.8)
The following changes were made to ensure compatibility with the WotLK 3.3.5a client:
- Replaced `C_Container.GetItemCooldown()` with `GetItemCooldown()` (C_Container namespace does not exist in WotLK)
- Replaced `C_ChatInfo.SendAddonMessage()` with `SendAddonMessage()` (C_ChatInfo namespace does not exist in WotLK)
- Removed `RegisterAddonMessagePrefix()` call (introduced in Cataclysm, not available in WotLK)
- Changed addon message broadcast channel from `"YELL"` to `"RAID"` (YELL is not a valid addon message channel)
- Replaced `GROUP_JOINED` event with `PARTY_MEMBERS_CHANGED` (GROUP_JOINED does not exist in WotLK)
- Rewrote `UNIT_SPELLCAST_SENT`/`UNIT_SPELLCAST_SUCCEEDED` handler to use WotLK event signatures `(unit, spellName, rank, target)` instead of modern cast GUIDs and spell IDs
- Removed duplicate erroneous `UIDropDownMenu_Initialize` call referencing undefined `WPDropDownDemo_Menu`
- Updated TOC interface version to `30300`
- Fixed popup not appearing during ready check: `GetItemCooldown` was hardcoded to item ID `5232` (Minor Soulstone) instead of using the configured soulstone item. If that item wasn't in the player's bags, `GetItemCooldown` returned `nil`, causing `duration == 0` to evaluate to `false` and the popup block to never execute.
- Fixed "Soulstone Main Target" option missing: replaced the unimplemented text input with a dynamic dropdown that populates with current party/raid members when opened. Healer classes (Priest, Druid, Paladin, Shaman) are listed first with a `(Healer)` label; the selection is saved to `SoulstoneWatcherConfig.main_target` and that player is placed first in the cast button list when the popup appears.
- Fixed duplicate frame names: all five cast buttons (`castButton1`–`castButton4`, `castButtonClear`) were created with the same name `"myButton"`, causing WoW global namespace conflicts. Each button now has a unique name (`SWCastButton1`–`SWCastButton4`, `SWCastButtonClear`).
- Fixed options panel frame name: `"Soulstone Watcher"` (with a space) is not a valid WoW global frame name; renamed to `"SoulstoneWatcherOptionsPanel"`.
- Fixed nil concatenation crash: if `UNIT_SPELLCAST_SUCCEEDED` fires for Soulstone Resurrection before a `UNIT_SPELLCAST_SENT` is received, `castTargetPlayer` would be `nil`, causing a Lua runtime error. An early-return nil guard was added.
- Fixed cast button unit targeting: `SecureActionButtonTemplate` requires a valid WoW unit token (`"raid1"`, `"party2"`, `"player"`, etc.) for its `"unit"` attribute — not a player name string. Added a `getUnitToken(name)` helper that resolves a player name to the correct unit token before setting the attribute, so clicking a cast button correctly targets the intended player.
- Removed `SecureActionButtonTemplate` from `castButtonClear`: this button only hides the cast buttons and used `SetScript("OnClick")`, which conflicts with WoW's secure template protection model. It now uses only `UIPanelButtonTemplate`.
- Fixed ready check event registration: `triggerEventFrame` was declared as a local variable inside `load_options()`, causing it to potentially be garbage collected and preventing the `READY_CHECK` event from firing properly. The frame is now declared at module scope and initialized only once, with `UnregisterAllEvents()` called before re-registering events to avoid duplicates. This ensures the ready check prompt appears consistently during raid ready checks.
- Fixed cast buttons not appearing during ready check: the `OnEvent` handler was gated behind a cooldown check, so if the soulstone was on cooldown the cast buttons were never shown. Cast buttons now always appear on `READY_CHECK` and `PARTY_MEMBERS_CHANGED` events regardless of cooldown; the "soulstone is ready" print message is still only shown when the cooldown has expired.
- Fixed prompt not appearing when joining a Dungeon Finder (RDF) group: `PARTY_MEMBERS_CHANGED` fires before the loading screen begins, so the notification was printed but then wiped from chat by the loading screen transition. Now `PLAYER_ENTERING_WORLD` is also registered when `enable_at_join` is enabled. The event is guarded so it only triggers when the player is actually in a group, preventing it from firing on normal login/logout.

## Bugs
Because this project is quite new, there can be hidden bugs in the code.

To report bugs specific to the WotLK 3.3.5a version, please open an issue in this repository: https://github.com/locus313/WoW-3.3.5a-Addons/issues

For issues with the original addon, you can also use the CurseForge issue tracker: https://www.curseforge.com/wow/addons/soulstone-watcher/issues/create
