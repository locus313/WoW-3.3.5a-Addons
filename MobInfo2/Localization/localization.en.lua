-- 
-- Default English Localisation for MobInfo
--
-- created by Stephan Wilms 
--


MI2_Locale = GetLocale()

if ( MI2_Locale == "enUS" or MI2_Locale == "enGB" ) then
--if ( MI2_Locale == "deDE" ) then

MI2_SpellSchools = { Arcane="ar", Fire="fi", Frost="fr", Shadow="sh", Holy="ho", Nature="na" }

MI_TXT_WELCOME          = "Welcome to MobInfo"
MI_DESCRIPTION			= "adds information about mobs to the tooltip and adds health/mana info to the target frame"
MI_TXT_GENERAL_OPTIONS	= "This Options Page controls the main functions of the MobInfo AddOn. The other options pages allow configuring the details for each feature."

MI_TXT_GOLD   = " Gold"
MI_TXT_SILVER = " Silver"
MI_TXT_COPPER = " Copper"

MI_TXT_OPEN				= "Open"
MI_TXT_COMBINED			= "Combined: "
MI_TXT_MOB_DB_SIZE		= "MobInfo Database Size:  "
MI_TXT_HEALTH_DB_SIZE	= "Health Database Size:  "
MI_TXT_PLAYER_DB_SIZE	= "Player Health Database Size:  "
MI_TXT_ITEM_DB_SIZE		= "Item Database Size:  "
MI_TXT_CUR_TARGET		= "Current Target:  "
MI_TXT_MH_DISABLED		= "MobInfo WARNING: Separate MobHealth AddOn found. The internal MobHealth functionality is disabled until the separate MobHealth AddOn is removed."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n You will NOT loose your data when disabling separate MobHealth.\n\nBenefits: movable health/mana display with percentage support and adjustable font and size")
MI_TXT_CLR_ALL_CONFIRM	= "Do you really want to perform the following delete operation: "
MI_TXT_SEARCH_LEVEL		= "Mob Level:"
MI_TXT_SEARCH_MOBTYPE	= "Mob Type:"
MI_TXT_SEARCH_LOOTS		= "Mob Looted:"
MI_TXT_TRIM_DOWN_CONFIRM = "WARNING: this is an immediate permanent delete. Do you really want to delete all mob data not selected as being recorded."
MI_TXT_CLAM_MEAT		= "Clam Meat"
MI_TXT_SHOWING			= "List Shows: "
MI_TXT_DROPPED_BY		= "Dropped By "
MI_TXT_IMMUNE			= "Immune:"
MI_TXT_RESIST			= "Resist:"
MI_TXT_DEL_SEARCH_CONFIRM = "Do you really want to DELETE the %d Mobs in the search result list from the MobInfo database ?"
MI_TXT_WRONG_LOC		= "ERROR : MobInfo database locale is incompatible with your WoW client locale. MobInfo database is unusable until fixed."
MI_TXT_WRONG_DBVER		= "ERROR : Your MobInfo database is too old and not compatible with this version of MobInfo.\n\nMobInfo must delete all your old Mob data."
MI_TXT_PRICE			= "Vendor Price for "
MI_TXT_TOOLTIP_MOVE		= "To move the tooltip anchor simply\nclick&drag it to a new location on screen"
MI_TXT_ITEMFILTER		= "Item Filter"

MI2_CHAT_MOBRUNS = "attempts to run"
MI2_TXT_MOBRUNS = "*runs*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG	= "Open MobInfo Options"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "Mob Tooltip Content"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Mob Health Options"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Database Options"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Health Value"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Mana Value"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Search Options"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Import External MobInfo Database"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Item Tooltip Options"
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "MobInfo Tooltip Layout"


---------------------------
-- Tooltip Options/Content
---------------------------

MI_TXT_HEALTH		= "Health"
MI_HLP_HEALTH		= "Show Mob health info (current/max)"
MI_TXT_MANA			= "Mana"
MI_HLP_MANA			= "Show Mob mana/rage/energy info (current/max)"
MI_TXT_KILLS		= "Kills"
MI_HLP_KILLS		= "Show number of times you killed the Mob\nThe kill count is calculated and stored\nseparately per char"
MI_TXT_LOOTS		= "Loots"
MI_HLP_LOOTS		= "Show number of times a Mob has been looted"
MI_TXT_COINS		= "V-Coins"
MI_HLP_COINS		= "Show average coin drop per Mob\nThe total coin value is accumulated and divided\nby the looted counter.\n(does not get shown if coin count is 0)"
MI_TXT_ITEMVAL		= "V-Items"
MI_HLP_ITEMVAL		= "Show average item value per Mob\nThe total item value is accumulated and divided\nby the looted counter.\n(does not get shown if item value is 0)"
MI_TXT_MOBVAL		= "Value"
MI_HLP_MOBVAL		= "Show total average Mob value\nThis is the sum of average coin drop and \naverage item value"
MI_TXT_XP			= "XP"
MI_HLP_XP			= "Show number of experience points this Mob gives\nThis is the actual last XP value that the Mob \ngave you. \n(not shown for Mobs that are grey to you)"
MI_TXT_TO_LEVEL		= "# to L"
MI_HLP_TO_LEVEL		= "Show number of kills needed to level\nThis tells you how often you must kill the \nsame Mob you just killed to reach the next level\n(not shown for Mobs that are grey to you)"
MI_TXT_EMPTY_LOOTS	= "Empty"
MI_HLP_EMPTY_LOOTS	= "Show number of empty corpses found (num/percent)\nThis counter gets incremented when you open\n a corpse that has no loot"
MI_TXT_CLOTH_DROP	= "Cloth"
MI_HLP_CLOTH_DROP	= "Show how often the Mob has given cloth loot"
MI_TXT_CLASS		= "Class"
MI_HLP_CLASS		= "Show Mob class info"
MI_TXT_DAMAGE		= "Damage"
MI_HLP_DAMAGE		= "Show Mob damage range (Min/Max) and DPS (damage per second)\nDamage range and DPS is calculated and storedseparately per char.\nDPS updates slowly but progressively with each fight"
MI_TXT_QUALITY		= "Items"
MI_OPT_QUALITY		= "Loot Items Summary"
MI_HLP_QUALITY		= "Show loot quality counters and percentage\nThis counts how many items out of the 5 rarity categories\nthe Mob has given as loot. Categories with 0 drops dont\nget shown. The percentage is the persent chance to get\nan item of the specific rarety from the monster as loot"
MI_TXT_LOCATION		= "Loc"
MI_HELP_LOCATION	= "Show the location where the Mob can be found\nRecording location data must be ENABLED for this to work"
MI_TXT_LOWHEALTH	= "Runaway Mob Indicator"
MI_HELP_LOWHEALTH	= "Show indicator for Mobs that run when low on health\nThe indicator is a red message line that gets shown\nin the tooltip for the runaway Mobs only"
MI_OPT_RESISTS		= "Resists and Immunities"
MI_TXT_RESISTS		= "Resist"
MI_TXT_IMMUN		= "Immun"
MI_HELP_RESISTS		= "Show resistances and immunities in ToolTip\nRecorded data about the Mobs elemental spell school\nresistances or immunities is added to the tooltip"
MI_TXT_ITEMLIST		= "Basic Loot Item List"
MI_HELP_ITEMLIST	= "Show the names and amount of all basic loot items\nBasic loot items are all loot items except for cloth and skinning loot.\nRecording loot item data must be ENABLED for this to work"
MI_TXT_CLOTHSKIN	= "Cloth and Skinning Loot"
MI_HELP_CLOTHSKIN	= "Show names and amount of all cloth and skinning loot items\nRecording loot item data must be ENABLED for this to work"


--------------------
-- General Options
--------------------
MI2_OPTIONS = {};

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Record and Store Detailed Information About Mobs";
help = "This option enables or disabled the resording of detailed data\nabout the Mobs that you meet and kill in game. This data can be\nused to show mob details in the tooltip, or to search for Mobs\nusing the MobInfo search tool. The data also allows showing detailed\n'Dropped By' info for items.\n\nUse the Database options page to for setting detailed recording\noptions and to maintain your databases.\n\nDisable this option if you do not want MobInfo to record and store\nMob data in the MobInfo database. Disabling the recording will not\n delete your current database. To delete your databases go to the\ndatabase options page." }

MI2_OPTIONS["MI2_OptShowMobInfo"] = 
{ text = "Show Mob Information in the Tooltip"; 
help = "Activates the showing of Mob information in the MobInfo Tooltip.\nUse the Tooltip options page to choose what information to show.\nDisable this option if you do not want to see Mob information\nor the MobInfo tooltip." }

MI2_OPTIONS["MI2_OptUseGameTT"] = 
{ text = "Instead of MobInfo-Tooltip use the Game-Tooltip"; 
help = "MobInfo features its very own optimally layouted movable tooltip window,\nwhich is used by default.\nActivating this option uses the Game-Tooltip\ninstead of the MobInfo tooltip window for showing the Mob information.\nThis will disable the MobInfo tooltip window." }

MI2_OPTIONS["MI2_OptShowItemInfo"] = 
{ text = "Show Additional Item Information in the Item Tooltip"; 
help = "Activates the showing of item information in the iem Tooltip.\nUse the Tooltip options page to choose what information to show.\nDisable this option if you do not want MobInfo to add anything\nto the item tooltip." }

MI2_OPTIONS["MI2_OptShowTargetInfo"] = 
{ text = "Show Mob Info in Target Frame (Health/Mana/etc)"; 
help = "Show info like Health or Mana values in the Mob Target Frame.\n(this works only when not using a so called unit frame AddOn)\nUse the Target options page to configure what to show where.\n\nDisable this option if you do not want MobInfo to show information\nin the mob target frame." }

MI2_OPTIONS["MI2_OptShowMMButton"] = 
{ text = "Show Minimap Button"; 
help = "Show / Hide the MobInfo minimap button" }

MI2_OPTIONS["MI2_OptMMButtonPos"] = 
{ text = "Minimap Button Position"; 
help = "Use the slider to change the position of the MobInfo minimap button" }


--------------------
-- Other Options
--------------------

MI2_OPTIONS["MI2_OptShowIGrey"] = 
{ text = ""; help = "Show grey (poor) loot items in the tooltip" }

MI2_OPTIONS["MI2_OptShowIWhite"] = 
{ text = ""; help = "Show white (common) loot items in the tooltip" }

MI2_OPTIONS["MI2_OptShowIGreen"] = 
{ text = ""; help = "Show green (uncommon) loot items in the tooltip" }

MI2_OPTIONS["MI2_OptShowIBlue"] = 
{ text = ""; help = "Show blue (rare) loot items in the tooltip" }

MI2_OPTIONS["MI2_OptShowIPurple"] = 
{ text = ""; help = "Show purple (epic) loot items in the tooltip" }

MI2_OPTIONS["MI2_OptMouseTooltip"] = 
{ text = "Show Tooltip at Mouse"; help = "MobInfo tooltip shows up at mouse cursor position\nand follows mouse movement while visible." }

MI2_OPTIONS["MI2_OptHideAnchor"] = 
{ text = "Hide Tooltip Anchor"; help = "Hides the little 'MI' anchor for the MobInfo Tooltip.\nThe anchor will become visible when the options dialog\nis open and when the hide anchor option is disabled." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
{ text = "Combined Mobs Info"; help = "Show combined mode message in tooltip\nShow a mesage in the tooltip indicating that combined mode\nis active and listing all mob levels that have been combined\ninto one tooltip." }

MI2_OPTIONS["MI2_OptSmallFont"] = 
{ text = "Use smaller font"; help = "Use a smaller font for the texts in the Mob Tooltip" }

MI2_OPTIONS["MI2_OptTooltipMode"] = 
{ text = "Tooltip Position"; help = "Position of the MobInfo Tooltip information\nrelative to the Tooltip Anchor";
choice1="Top Left"; choice2="Bottom Left"; choice3="Top Right"; choice4="Bottom Right"; choice5="Center Above"; choice6="Center Below" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Two Column Tooltip"; help = "Show the Mob infos in a more compact two column layout.\nThe tooltip will be somewhat wider, but considerably shorter.\nThe total width is limited. Infos that are too wide will be\nshown on a separate single line." }

MI2_OPTIONS["MI2_OptOtherTooltip"] =
{ text = "Hide the other Tooltip"; help = "Hides the other tooltip when showing Mob information\nin the MobInfo tooltip." }

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
{ text = "Min"; help = "minimum mob level for search options"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "maximum mob level for search options (must be < 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normal"; help = "include Normal type mobs in search result"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Elite"; help = "include Elite type mobs in search result"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Boss"; help = "include Boss type mobs in search result"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "minimum number of times the Mob must have been looted"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
{ text = "Max"; help = "maximum number of times the Mob must have been looted"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Mob Name"; help = "partial or complete mob name to search for";
info = 'Leave empty to not retrict search to specific items\nEntering "*" selects all items.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Item Name"; help = "partial or complete item name to search for";
info = 'leave empty to search for all item names'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Sort by Profit"; help = "Sort search result list by mob profit";
info = 'Sort the mobs by the profit you can make from killing them.'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Sort by Item Count"; help = "Sort search result list by item count";
info = 'Sort the Mobs by how many of the specified item(s) they drop.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "List Mobs in Item Tooltip"; help = "Display names of Mobs dropping an item in item tooltip";
info = "List the names of all Mobs that drop a hovered item\nin the item tooltip. For each item list the amount\ndropped by the Mob along with percentage." }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
{ text = "Show Vendor Sell Price"; help = "Show vendor sell price for item in item tooltip" }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
{ text = "Combine Same Mobs"; help = "Combine data for Mob with same name";
info = "Combined mode will accumulate the data for Mobs with\nthe same name but different level. When enabled a\nindicator gets displayed in the tooltip" }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
{ text = "Press ALT Key for Mob Info"; help = "Only Show MobInfo in tooltip when ALT key is pressed"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = ""; help = "Set filtering expression for loot item display in tooltips";
info = "Display only those loot items in the Mob tooltip that include\nthe filter text. E.g. entering 'cloth' will show only items with\n'cloth' in the item name.\nEnter nothing to see all items." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Save player health data permanently"; help = "Permanently store player health data from PvP battles.";
info = "Normally player health data from PvP fights is discarded after\na session. Setting this option allows you to retain that data." }

MI2_OPTIONS["MI2_OptAllOn"] = 
{ text = "All ON"; help = "Switch all MobInfo show options to ON"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
{ text = "All OFF"; help = "Switch all MobInfo show options to OFF"; }

MI2_OPTIONS["MI2_OptDefault"] = 
{ text = "Default"; help = "Show a default set of useful Mob info"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
{ text = "Close"; help = "Close MobInfo options dialog"; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
{ text = "Show Health Value"; help = "Show health value in target frame"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
{ text = "Show Mana Value"; help = "Show mana value in target frame"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
{ text = "Show Percent"; help = "Add percentage to health in target frame"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
{ text = "Show Percent"; help = "Add percentage to mana in target frame"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
{ text = "Horizontal Position"; help = "Adjust horizontal position of health in target frame"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
{ text = "Vertical Position"; help = "Adjust vertical position of health in target frame"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
{ text = "Horizontal Position"; help = "Adjust horizontal position of mana in target frame"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
{ text = "Vertical Position"; help = "Adjust vertical position of mana in target frame"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
{ text = "Font"; help = "Set font for health/mana values in target frame";
choice1= "NumberFont"; choice2="GameFont"; choice3="ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
{ text = "Font Size"; help = "Set font size for health/mana values in target frame"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
{ text = "Delete Target Data"; help = "Delete data for current target from databases."; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of mob info database."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of mob health database."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Delete Database"; help = "Delete entire contents of player health database."; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Record Mob loot item data for quality:"; help = "Turn this on to record loot item details for all Mobs.";
info = "You can choose the quality level of items to be recorded."; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Record character specific Mob data"; help = "Record all Mob data that is character specific.";
info = "This will enable or disable saving of the following data:\nnumber of kills, min/max damage, DPS (damage per sec), Mob XP\n\nThis data is saved separately for each character. Saving it can\nonly be enabled/disabled for the entire set of 4 values"; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Record data about Resistances & Immunities"; help = "Record data about a Mobs resistances and immunities to spell schools.";
info = "For spell schools MobInfo records how many spells per school\nhit successfully versus how many are resisted."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = ""; help = "Record loot item details for selected quality and better.";
choice1 = "Grey & Better"; choice2="White & Better"; choice3="Green & Better" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "Minimize Mob Database Size"; help = "Minimize Mob database size by removing surplus data.";
info = "Surplus data is all data within the database that is not marked as\nbeing recorded."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Start the Import"; help = "Import an external Mob Database into your own Mob Database";
info = "IMPORTANT: please read the import instructions !\nALWAYS backup your own Mob database BEFORE import !"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "DELETE"; help = "Deletes all Mobs in the search result list from the MobInfo database.";
info = "WARNING: this operation can not be undone.\nPlease use with care !\nYou might want to backup your MobInfo database before deleting Mobs."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Import only unknown Mobs"; help = "Import only Mobs that do not exist in your own database";
info = "Activating this option prevents that the data of existing Mobs\nis modified. Only unknown (ie. new) Mobs will get imported. This\nallows importing partially overlapping database without causing\nconsistency problems."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Mob List"; help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Items List"; help = ""; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] = 
{ text = "Tooltip"; help = "Set options for displaying mob info in tooltip"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] = 
{ text = "Target Frame"; help = "Set options for displaying health/mana in target frame"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] = 
{ text = "Database"; help = "Database management options"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
{ text = "Search"; help = "Search through the Database"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
{ text = "General"; help = "General options for the MobInfo AddOn"; }

end
