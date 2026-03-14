-- default to American English

FishingTranslations = {};
FishingTranslations["enUS"] = {
   NAME = "Fishing Buddy",
   
   -- these are translated automatically when loaded
   DESCRIPTION = "#DESCRIPTION1# #DESCRIPTION2#",
   WINDOW_TITLE = "#NAME# v#VERSION#",

   -- we can (should?) translate everything below here
   DESCRIPTION1 = "Keep track of the fish you've caught",
   DESCRIPTION2 = "and manage your fishing gear.",

   -- Tab labels and tooltips
   LOCATIONS_INFO = "Shows where you've caught fish by either Area or Fish Type",
   LOCATIONS_TAB = "Locations",
   OPTIONS_INFO = "Set #NAME# options",
   OPTIONS_TAB = "Options",

   POINT = "point",
   POINTS = "points",

   RAW = "Raw",
   FISH = "Fish",
   RANDOM = "Random",

   BOBBER_NAME = "Fishing Bobber",
   FISHINGSKILL = "Fishing",
   HELP = "help",
   SWITCH = "switch",
   UPDATEDB = "updatedb",
   FORCE = "force",

   OUTFITS = "Outfits",
   ELAPSED = "Elapsed",
   TOTAL = "Total",
   TOTALS = "Totals",

   SCHOOL = "School",  -- e.g. 'Oily Blackmouth School'
   FLOATING_WRECKAGE = "Floating Wreckage",
   FLOATING_DEBRIS = "Floating Debris",
   ELEM_WATER = "Elemental Water",
   OIL_SPILL = "Oil Spill",

   GOLD_COIN = "Gold coin",
   SILVER_COIN = "Silver coin",
   COPPER_COIN = "Copper coin",

   LAGER = "Captain Rumsey's Lager",
   
   ADD = "add",
   REPLACE = "replace",
   UPDATE = "update",
   CURRENT = "current",
   RESET = "reset",
   CLEANUP = "cleanup",
   CHECK = "check",
   NOW = "now",
   TIMER = "timer",
   CAST = "cast",

   NOREALM = "unknown realm",

   WATCHER = "watcher",
   WATCHER_LOCK = "lock",
   WATCHER_UNLOCK = "unlock",

   WEEKLY = "weekly",
   HOURLY = "hourly",

   OFFSET_LABEL_TEXT = "Offset:";

   KEYS_LABEL_TEXT = "Modifiers:",
   KEYS_NONE_TEXT = "None",
   KEYS_SHIFT_TEXT = "Shift",
   KEYS_CTRL_TEXT = "Control",
   KEYS_ALT_TEXT = "Alt",

   SHOWFISHIES = "Show fish",
   SHOWFISHIES_INFO = "Display fishing history grouped by fish type.",

   SHOWLOCATIONS = "Locations",
   SHOWLOCATIONS_INFO = "Display fishing history grouped by area caught.",

   ALLZOMGPETS = "Include all pets",

   -- Option names and tooltips
   CONFIG_SHOWNEWFISHIES_ONOFF   = "Show new fish",
   CONFIG_SHOWNEWFISHIES_INFO    = "Display a message in the chat area when a new fish for the current location is caught.",
   CONFIG_FISHWATCH_ONOFF        = "Fish watcher",
   CONFIG_FISHWATCH_INFO	 	 = "Display a text overlay with the fish caught in the current location.",
   CONFIG_FISHWATCHTIME_ONOFF    = "Show elapsed time",
   CONFIG_FISHWATCHTIME_INFO     = "Display the amount of time since you last equipped a fishing pole",
   CONFIG_FISHWATCHONLY_ONOFF    = "Only while fishing",
   CONFIG_FISHWATCHONLY_INFO	 = "Only show the Fish Watcher when we're actually fishing",
   CONFIG_FISHWATCHSKILL_ONOFF   = "Current skill",
   CONFIG_FISHWATCHSKILL_INFO	 = "Display the current fishing skill and mods in the fish watch area.",
   CONFIG_FISHWATCHZONE_ONOFF    = "Current zone",
   CONFIG_FISHWATCHZONE_INFO	 = "Display the current zone in the fish watch area.",
   CONFIG_FISHWATCHPERCENT_ONOFF = "Show percentages",
   CONFIG_FISHWATCHPERCENT_INFO	 = "Display the percentage of each kind of fish on the watch display",
   CONFIG_EASYCAST_ONOFF	 = "Easy Cast",
   CONFIG_EASYCAST_INFO		 = "Enable double-right-click casting.",
   CONFIG_AUTOLOOT_ONOFF	 = "Auto Loot",
   CONFIG_AUTOLOOT_INFO	     = "If enabled, automatic looting is turned on while fishing.",
   CONFIG_USEACTION_ONOFF	 = "Use Action",
   CONFIG_USEACTION_INFO	 = "If enabled, #NAME# will look for an action bar button to use for casting.",
   CONFIG_EASYLURES_ONOFF	 = "Easy Lures",
   CONFIG_EASYLURES_INFO	 = "If enabled, a lure will applied to your fishing pole before you start fishing, whenever you need one.",
   CONFIG_ALWAYSLURE_ONOFF   = "Always Lure",
   CONFIG_ALWAYSLURE_INFO    = "If enabled, put a lure on every time the pole doesn't have one",
   CONFIG_SHOWLOCATIONZONES_ONOFF	= "Show Zones",
   CONFIG_SHOWLOCATIONZONES_INFO	= "Display both zones and subzones.",
   CONFIG_SORTBYPERCENT_ONOFF = "Sort by number caught",
   CONFIG_SORTBYPERCENT_INFO  = "Order displays by the number of fish caught instead of by name.",
   CONFIG_TOOLTIPS_ONOFF     = "Show fishing info in tooltips",
   CONFIG_TOOLTIPS_INFO      = "If enabled, information about caught fish will be displayed in item tooltips.",
   CONFIG_ONLYMINE_ONOFF     = "Outfit Pole Only",
   CONFIG_ONLYMINE_INFO	     = "If enabled, easy cast will only check for your outfit's fishing pole (i.e. it won't search all possible poles for a match).",
   CONFIG_TURNOFFPVP_ONOFF   = "Turn off PVP",
   CONFIG_TURNOFFPVP_INFO    = "If enabled, PVP will be turned off while a fishing pole is equipped.",
   CONFIG_BGSOUNDS_ONOFF     = "Background sound",
   CONFIG_BGSOUNDS_INFO      = "If enabled, sound will be enabled while WoW is in the background",

   CONFIG_FISHINGFLUFF_ONOFF = "Fishing Fun",
   CONFIG_FISHINGFLUFF_INFO  = "Enable all sorts of fun while you fish",
   CONFIG_FINDFISH_ONOFF     = "Find Fish",
   CONFIG_FINDFISH_INFO      = "Turn on the 'Find Fish' ability when dressed to fish",
   CONFIG_DRINKHEAVILY_ONOFF = "Drink Lager",
   CONFIG_DRINKHEAVILY_INFO  = "If enabled, drink #LAGER# whenever you're fishing and 'dry'.",
   CONFIG_FISHINGBUDDY_ONOFF = "Fishing Buddy",
   CONFIG_FISHINGBUDDY_INFO  = "Bring out that special buddy while you fish.",
   
   CONFIG_WATCHBOBBER_ONOFF  = "Watch bobber",
   CONFIG_WATCHBOBBER_INFO   = "If enabled, #NAME# will not cast if the cursor is over the Fishing Bobber",
   
   CONFIG_CONTESTS_ONOFF     = "Fishing contest support",
   CONFIG_CONTESTS_INFO      = "Display timers for fishing contests",
   
   CONFIG_STVTIMER_ONOFF     = "Extravaganza timer",
   CONFIG_STVTIMER_INFO	     = "If enabled, display a countdown timer for the start of the Fishing Extravaganza and a countdown of the time left.",
   CONFIG_STVPOOLSONLY_ONOFF = "Only cast in pools",
   CONFIG_STVPOOLSONLY_INFO	 = "If enabled, easy cast will only be enabled if the cursor is over a fishing hole.",
   CONFIG_DERBYTIMER_ONOFF   = "Derby timer",
   CONFIG_DERBYTIMER_INFO	 = "If enabled, display a countdown timer for the start of the Kalu'ak Fishing Derby and a countdown of the time left.",
   CONFIG_SHOWPOOLS_ONOFF    = "Show pools",
   CONFIG_SHOWPOOLS_INFO     = "If enabled, known pool locations will be displaye don the minimap",
   
   CONFIG_OUTFITTER_TEXT     = "Outfit skill bonus: %s\r\nDraznar's style score: %d ",

   CLICKTOSWITCH_ONOFF	        = "Click to switch",
   CLICKTOSWITCH_INFO	        = "If enabled, a left click switches outfits, otherwise it brings up the Fishing Buddy window.",

   LEFTCLICKTODRAG = "Left-click to drag",
   RIGHTCLICKFORMENU = "Right-click for menu",
   WATCHERCLICKHELP = "#LEFTCLICKTODRAG#\n#RIGHTCLICKFORMENU#",

   MINIMAPBUTTONPLACEMENT = "Placement",
   MINIMAPBUTTONPLACEMENTTOOLTIP = "Allows you to move the #NAME# icon around the minimap",
   MINIMAPBUTTONRADIUS = "Distance",
   MINIMAPBUTTONRADIUSTOOLTIP = "Determines how far from the minimap the #NAME# icon should be",
   CONFIG_MINIMAPBUTTON_ONOFF	= "Display minimap icon",
   CONFIG_MINIMAPBUTTON_INFO	= "Display a #NAME# icon on the minimap.",

   CONFIG_ENHANCESOUNDS_ONOFF      = "Enhance fishing sounds",
   CONFIG_ENHANCESOUNDS_INFO       = "When enabled, maximize sound volume and minimize ambient volume to make the bobber noise more noticeable while fishing.",

   HIDEINWATCHER = "Display this fish in the watcher",

   -- messages
   COMPATIBLE_SWITCHER = "No compatible outfit switcher found.",
   TOOMANYFISHERMEN = "You have more than one easy cast mod installed.",
   FAILEDINIT = "Did not initialize correctly.",
   ADDFISHIEMSG = "Adding %s to location %s.",
   ADDSCHOOLMSG = "Adding '%s' to location %s.",
   NODATAMSG = "No fishing data available.",
   CLEANUP_NONEMSG = "No old settings remain.",
   CLEANUP_WILLMSG = "Old settings remaining for |c#RED#%s|r: %s.",
   CLEANUP_DONEMSG = "Old settings removed for |c#RED#%s|r: %s.",
   CLEANUP_NOOLDMSG = "There are no old settings for player |c#GREEN#%s|r.",
   NONEAVAILABLE_MSG = "None available",
   UPDATEDB_MSG = "Updated %d fish names.",

   MINIMUMSKILL = "Minimum skill: %d",
   NOTLINKABLE = "<Item is not linkable>",
   CAUGHTTHISMANY = "Caught:",
   CAUGHTTHISTOTAL = "Total:",
   FISHTYPES = "Fish types: %d",
   CAUGHT_IN_ZONES = "Caught in: %s",

   DASH = " -- ",
   FISHCAUGHT = "%d %s",
   
   EXTRAVAGANZA = "Extravaganza",
   DERBY = "Derby",
   
   TIMETOGO = "%s starts in %d:%02d",
   TIMELEFT = "%s ends in %d:%02d",
   
   FATLADYSINGS = "|c#RED#Extravaganza is over|r (%d:%02d left)",
   -- Figgle Bassbait yells: We have a winner! NAME is the Master Angler!
   RIGGLE_BASSBAIT = "^Riggle Bassbait yells: We have a winner!\s+(%a+)\s+is the Master Angler!",

   STVZONENAME = "Stranglethorn Vale",

   TOOLTIP_HINT = "Hint:",
   TOOLTIP_HINTSWITCH = "click to switch outfits",
   TOOLTIP_HINTTOGGLE = "click to show the #NAME# window.",

   -- Key binding support
   BINDING_HEADER_FISHINGBUDDY_BINDINGS = "#NAME#",
   BINDING_NAME_FISHINGBUDDY_TOGGLE = "Toggle #NAME# Window",
   BINDING_NAME_FISHINGBUDDY_SWITCH = "Switch Fishing Outfit",
   BINDING_NAME_FISHINGBUDDY_GOFISHING = "Suit up and go fishing",

   BINDING_NAME_TOGGLEFISHINGBUDDY_LOC = "Toggle #NAME# Locations Pane",
   BINDING_NAME_TOGGLEFISHINGBUDDY_OPT = "Toggle #NAME# Options Pane",
};

FishingTranslations["enUS"].SWITCH_HELP = {
      "|c#GREEN#/fb #SWITCH#|r",
      "    swap outfits (if OutfitDisplayFrame or Outfitter is available)",
};
FishingTranslations["enUS"].WATCHER_HELP = {
      "|c#GREEN#/fb #WATCHER#|r [|c#GREEN##WATCHER_LOCK#|r or |c#GREEN##WATCHER_UNLOCK#|r or |c#GREEN##RESET#|r]",
      "    Unlock the watcher to move the window,",
      "    lock to stop, reset to reset",
};
FishingTranslations["enUS"].CURRENT_HELP = {
   "|c#GREEN#/fb #CURRENT# #RESET#|r",
   "    Reset the fish caught during the current session.",
};
FishingTranslations["enUS"].UPDATEDB_HELP = {
   "|c#GREEN#/fb #UPDATEDB# [#FORCE#]|r",
   "    Try and find the names of all the fish we don't know already.",
   "    An attempt is made to skip 'rare' fish that may disconnect you",
   "    from the server -- use the '#FORCE#' option to override the check.",
};
FishingTranslations["enUS"].CLEANUP_HELP = {
      "|c#GREEN#/fb #CLEANUP#|r [|c#GREEN##CHECK#|r or |c#GREEN##NOW#|r]",
      "    Clean up old settings. |c#GREEN##CHECK#|r lists which",
      "    settings will be removed by |c#GREEN##NOW#|r.",
};
FishingTranslations["enUS"].TIMERRESET_HELP = {
      "|c#GREEN#/fb #TIMER# #RESET#|r",
      "    Reset the location of the Extravaganza timer by moving it to",
      "    the middle of the screen.",
};
FishingTranslations["enUS"].CASTHELP = {
      "|c#GREEN#/fb #CAST#|r",
      "    Scriptable cast, just like a double-click, usable from a macro.",
};

FishingTranslations["enUS"].PRE_HELP = {
      "You can use |c#GREEN#/fishingbuddy|r or |c#GREEN#/fb|r for all commands",
      "|c#GREEN#/fb|r: by itself, toggle the Fishing Buddy window",
      "|c#GREEN#/fb #HELP#|r: display this message",
};
FishingTranslations["enUS"].POST_HELP = {
      "You can bind both the window toggle and the outfit",
      " switch command to keys in the \"Key Bindings\" window.",
};
