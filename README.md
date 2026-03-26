# WoW 3.3.5a Addons

A collection of World of Warcraft addons for the **Wrath of the Lich King 3.3.5a** client. Some of these addons have been back-ported from newer versions to ensure compatibility with the 3.3.5a client.

## Addons

### Standalone Addons

| Addon | Version | Description |
|-------|---------|-------------|
| [ACP](ACP/) | 3.2.0.118 | Addon Control Panel — adds an in-game addon manager via the Addons menu |
| [AdvancedTradeSkillWindow](AdvancedTradeSkillWindow/) | 0.7.8 | An improved trade skill window with filtering and sorting |
| [AuctionHouseDepositFixer](AuctionHouseDepositFixer/) | — | Corrects the deposit cost shown for items in the Auction House |
| [Bartender4](Bartender4/) | 4.4.2 | Fully customizable action bar addon |
| [Bistooltip](Bistooltip/) | 1.0.0-3.3.5a | Adds Best in Slot information to item tooltips |
| [Chronos](Chronos/) | — | Embeddable time-keeping and scheduling library used by other addons |
| [CrapAway](CrapAway/) | — | Automatically sells all gray (junk) items when a merchant window opens |
| [FeedbackUI](FeedbackUI/) | 2.0.6 | Sends feedback reports to a private server's database |
| [FishingBuddy](FishingBuddy/) | 0.9.8p1 | Assists with fishing: auto-equip fishing gear, fish info, and more |
| [GearScoreLite](GearScoreLite/) | 3x04 | Displays a gear score for players to quickly assess gear quality |
| [GTFO](GTFO/) | 2.5.3 | Plays an audio alert when you are standing in harmful AOE |
| [MobInfo2](MobInfo2/) | 3.75 | Adds detailed mob stats (health, mana, drops) to tooltips and target frame |
| [Omen](Omen/) | 3.0.9 | Lightweight, multi-target threat meter |
| [Postal](Postal/) | 3.3.2 | Enhanced mailbox with auto-open, bulk take, and more |
| [PowerAuras](PowerAuras/) | 3.0.0S | Displays configurable visual effects for buffs, debuffs, and game events |
| [QuestHelper](QuestHelper/) | 1.4.1 | Calculates an optimal questing route and overlays directions on the map |
| [Recount](Recount/) | — | Damage meter with graph-based display of DPS, HPS, and more |
| [SoulstoneWatcher](SoulstoneWatcher/) | 1.0.8 | Tracks active soulstones in your party/raid for quick battle-rez coordination |

### Auctioneer Suite (v5.9.4960)

A comprehensive auction house toolkit. All modules below are part of the same suite.

| Addon | Description |
|-------|-------------|
| [!Swatter](Swatter/) | Error-handling and debugging tool (loads first) |
| [Auc-Advanced](Auc-Advanced/) | Core Auctioneer module — item value tracking and auction management |
| [Auc-Filter-Basic](Auc-Filter-Basic/) | Filters Auctioneer data by quality, item level, and seller |
| [Auc-ScanData](Auc-ScanData/) | Lazy-loads the auction scan dataset to reduce memory on startup |
| [Auc-Stat-Histogram](Auc-Stat-Histogram/) | Statistics module using histogram-based price analysis |
| [Auc-Stat-iLevel](Auc-Stat-iLevel/) | Statistics module grouping data by item quality, type, and level |
| [Auc-Stat-Purchased](Auc-Stat-Purchased/) | Statistics module tracking historical purchase prices |
| [Auc-Stat-Simple](Auc-Stat-Simple/) | Simple exponential moving-average price statistics |
| [Auc-Stat-StdDev](Auc-Stat-StdDev/) | Standard-deviation statistics with outlier detection |
| [Auc-Util-FixAH](Auc-Util-FixAH/) | Workaround for the AH browse-frame paging bug |
| [BeanCounter](BeanCounter/) | Records auction transaction history (buys, sales, failures) |
| [Enchantrix](Enchantrix/) | Shows disenchant, prospect, and mill results in item tooltips |
| [Enchantrix-Barker](Enchantrix-Barker/) | Broadcasts your available enchants to Trade chat |
| [Informant](Informant/) | Adds vendor price, use info, and extended details to item tooltips |
| [SlideBar](SlideBar/) | Expanding minimap-side bar for addon icon placement (library) |
| [Stubby](Stubby/) | Event-based lazy-loader library for other Auctioneer modules |

### Bagnon Suite (v2.13.3)

A unified bag replacement addon. All modules below are part of the same suite.

| Addon | Version | Description |
|-------|---------|-------------|
| [Bagnon](Bagnon/) | 2.13.3 | Combines all bags into a single window; also shows bank and keyring |
| [Bagnon_Config](Bagnon_Config/) | — | GUI-based configuration panel for Bagnon |
| [Bagnon_Forever](Bagnon_Forever/) | — | Caches inventory data so offline characters' bags can be browsed |
| [Bagnon_GuildBank](Bagnon_GuildBank/) | 1.0.0 | Adds a single-window display for the guild bank |
| [Bagnon_Tooltips](Bagnon_Tooltips/) | — | Shows which of your characters own a given item in tooltips |

### DataStore Suite

| Addon | Version | Description |
|-------|---------|-------------|
| [DataStore](DataStore/) | 3.3.001 | Core data storage framework used by DataStore modules |
| [DataStore_Inventory](DataStore_Inventory/) | 3.3.002 | Stores inventory snapshots for all your characters |

### Details Suite

A detailed combat damage meter with optional plugin modules. **Details** is the core; all other modules are plugins.

| Addon | Description |
|-------|-------------|
| [Details](Details/) | Core damage meter — shows DPS, HPS, threat, and more |
| [Details_3DModelsPaths](Details_3DModelsPaths/) | Asset bundle of 3D model paths used for character display in rows |
| [Details_ChartViewer](Details_ChartViewer/) | Plugin — graphical chart viewer |
| [Details_DataStorage](Details_DataStorage/) | Plugin — stores combat log data for post-encounter review |
| [Details_DeathGraphs](Details_DeathGraphs/) | Plugin — advanced death logs with timeline view and wipe analysis |
| [Details_EncounterDetails](Details_EncounterDetails/) | Plugin — detailed encounter breakdown with phase-by-phase DPS and WeakAuras integration |
| [Details_SunderCount](Details_SunderCount/) | Plugin — tracks Sunder Armor usage across the raid |
| [Details_TimeLine](Details_TimeLine/) | Plugin — timeline of debuffs, cooldowns, and enemy casts |
| [Details_TinyThreat](Details_TinyThreat/) | Plugin — compact threat meter displayed within the Details window |

### Deadly Boss Mods (DBM)

Boss encounter timers and warnings. Requires **DBM-Core**; all other modules are encounter packs.

| Addon | Description |
|-------|-------------|
| [DBM-Core](DBM-Core/) | Core framework — required by all other DBM modules |
| [DBM-GUI](DBM-GUI/) | Options interface for DBM |
| [DBM-MC](DBM-MC/) | Molten Core |
| [DBM-BWL](DBM-BWL/) | Blackwing Lair |
| [DBM-AQ40](DBM-AQ40/) | Temple of Ahn'Qiraj |
| [DBM-ZG](DBM-ZG/) | Zul'Gurub |
| [DBM-Karazhan](DBM-Karazhan/) | Karazhan |
| [DBM-ZulAman](DBM-ZulAman/) | Zul'Aman |
| [DBM-BurningCrusade](DBM-BurningCrusade/) | Burning Crusade 25-man raids |
| [DBM-BlackTemple](DBM-BlackTemple/) | Black Temple |
| [DBM-Hyjal](DBM-Hyjal/) | Mount Hyjal |
| [DBM-Serpentshrine](DBM-Serpentshrine/) | Serpentshrine Cavern |
| [DBM-TheEye](DBM-TheEye/) | The Eye (Tempest Keep) |
| [DBM-Sunwell](DBM-Sunwell/) | Sunwell Plateau |
| [DBM-Outlands](DBM-Outlands/) | Outlands 5-man dungeons |
| [DBM-Party-BC](DBM-Party-BC/) | Burning Crusade 5-man dungeons |
| [DBM-Naxx](DBM-Naxx/) | Naxxramas |
| [DBM-Onyxia](DBM-Onyxia/) | Onyxia's Lair |
| [DBM-VoA](DBM-VoA/) | Vault of Archavon |
| [DBM-EyeOfEternity](DBM-EyeOfEternity/) | Eye of Eternity |
| [DBM-Ulduar](DBM-Ulduar/) | Ulduar |
| [DBM-Coliseum](DBM-Coliseum/) | Trial of the Crusader / Crusaders' Coliseum |
| [DBM-ChamberOfAspects](DBM-ChamberOfAspects/) | Chamber of Aspects (Obsidian Sanctum / Ruby Sanctum) |
| [DBM-Icecrown](DBM-Icecrown/) | Icecrown Citadel |
| [DBM-Party-WotLK](DBM-Party-WotLK/) | Wrath of the Lich King 5-man dungeons |
| [DBM-PvP](DBM-PvP/) | Battleground timers and events |
| [DBM-WorldEvents](DBM-WorldEvents/) | World event and holiday timers |

### ElvUI Suite (v6.09)

A comprehensive UI replacement. **ElvUI** is the core; the other modules are companions.

| Addon | Version | Description |
|-------|---------|-------------|
| [ElvUI](ElvUI/) | 6.09 | Full UI replacement — action bars, unit frames, nameplates, chat, and more |
| [ElvUI_OptionsUI](ElvUI_OptionsUI/) | 1.06 | In-game options and configuration panel for ElvUI |
| [ElvUI_ProfileConverter](ElvUI_ProfileConverter/) | 1.1.11 | Converts old profile exports to the current ElvUI format |
| [ElvUIBackport_ProfileConverter](ElvUIBackport_ProfileConverter/) | 1.1.1 | Converts modern (Wago) profile exports back to the 3.3.5 format |

### Gatherer Suite (v3.1.16)

| Addon | Description |
|-------|-------------|
| [Gatherer](Gatherer/) | Tracks gathering nodes (herbs, ore, treasure) on the minimap and world map |
| [Gatherer_HUD](Gatherer_HUD/) | Heads-Up Display overlay showing nearby gathering nodes |

### HidingBar Suite (v3.4.20)

| Addon | Description |
|-------|-------------|
| [HidingBar](HidingBar/) | Auto-hiding action bar that slides in/out on hover |
| [HidingBar_Options](HidingBar_Options/) | Configuration panel for HidingBar |

### Titan Panel Suite (v4.3.8.30300)

A modular info bar displayed along the top or bottom of the screen. Requires **Titan** (core).

| Addon | Description |
|-------|-------------|
| [Titan](Titan/) | Core Titan Panel framework |
| [TitanAmmo](TitanAmmo/) | Displays current ammo count |
| [TitanBag](TitanBag/) | Shows bag usage and free slot count |
| [TitanClock](TitanClock/) | Displays server and local time |
| [TitanCoords](TitanCoords/) | Shows current map coordinates and zone |
| [TitanGoldTracker](TitanGoldTracker/) | Tracks gold across all your characters per realm/faction |
| [TitanLootType](TitanLootType/) | Shows current loot method and instance difficulty |
| [TitanPerformance](TitanPerformance/) | Displays FPS and memory usage |
| [TitanRegen](TitanRegen/) | Shows mana/energy regeneration rates |
| [TitanRepair](TitanRepair/) | Displays equipment durability and estimated repair cost |
| [TitanVolume](TitanVolume/) | Quick sound volume control from the panel |
| [TitanXP](TitanXP/) | Tracks XP gain, session XP/hour, and time to level |

### WeakAuras Suite (v4.0.0)

A powerful, comprehensive aura and trigger display system. **WeakAuras** is the core; the other modules are companions.

| Addon | Version | Description |
|-------|---------|-------------|
| [WeakAuras](WeakAuras/) | 4.0.0 | Displays configurable graphics and text based on buffs, debuffs, cooldowns, and other triggers |
| [WeakAurasArchive](WeakAurasArchive/) | — | Archives and stores inactive aura configurations |
| [WeakAurasModelPaths](WeakAurasModelPaths/) | — | Asset bundle of 3D model paths used by WeakAuras displays |
| [WeakAurasOptions](WeakAurasOptions/) | 4.0.0 | Options and profile management UI for WeakAuras |

## Installation

1. Clone or download this repository.
2. Copy the desired addon folder(s) into your WoW AddOns directory:
   ```
   World of Warcraft\Interface\AddOns\
   ```
3. Launch WoW and enable the addon(s) in the AddOns menu on the character select screen.

> **Note:** Suite addons (Auctioneer, Bagnon, DBM, Titan Panel, etc.) require all their component folders to be present together.

## Back-ported Addons

These addons were originally written for a newer version of the WoW client and have been modified to work with 3.3.5a. See each addon's README for the specific changes made.

- **SoulstoneWatcher** — see [SoulstoneWatcher/README.md](SoulstoneWatcher/README.md) for compatibility notes.
- **Bistooltip** — version suffix `-3.3.5a` indicates a custom build for this client.
- **ElvUIBackport_ProfileConverter** — converts modern (Wago.io) ElvUI profile exports back to the 3.3.5-compatible format; see [ElvUIBackport_ProfileConverter/README.md](ElvUIBackport_ProfileConverter/README.md).
- **HidingBar** — back-ported from a newer client version; see [HidingBar/README.md](HidingBar/README.md) for compatibility notes.

## Contributing

If you back-port additional addons, add an entry to the appropriate table above and include a README in the addon folder documenting the changes made for 3.3.5a compatibility.
