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
- Fixed popup not appearing in party (non-raid) groups: `get_raid_players()` only queried the raid roster via `GetRaidRosterInfo`, which returns `nil` for all slots when not in a raid. It now falls back to party unit tokens (`party1`–`party4`) when not in a raid.

## Bugs
Because this project is quite new, there can be hidden bugs in the code.

To report bugs specific to the WotLK 3.3.5a version, please open an issue in this repository: https://github.com/locus313/WoW-3.3.5a-Addons/issues

For issues with the original addon, you can also use the CurseForge issue tracker: https://www.curseforge.com/wow/addons/soulstone-watcher/issues/create
