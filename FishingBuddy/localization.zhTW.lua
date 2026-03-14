-- Translation for zhTW   by Indra from Eastern.Stories an old old old TW mud. 06/20/2007
-- 在下只翻譯了FishingBuddy 的部份.
-- Outfitter 的部份留待能人接續, 個人習慣使用Itemrack
-- Translation for zhTW , WOW version 2.3.0  Fish Buddy EBA0.9.3i  by Indra    
-- Special thanks translating advice from "Whocare" on "bahamut" a gamer forum of influence in Taiwan 11/24/2007

-- Update translation for 0.9.7 beta3 05/03/2009

FishingTranslations["zhTW"] = {
   NAME = "釣魚助手",

   DESCRIPTION1 = "追蹤過去漁獲",
   DESCRIPTION2 = "及管理你的魚具",
 
--   DESCRIPTION = "追蹤過去漁獲及管理你的魚具",    除錯發現 Descript1 2 都是有作用的. XD

   -- Tab labels and tooltips
   LOCATIONS_INFO = "顯示漁獲地點資訊",
   LOCATIONS_TAB = "地點",
   OPTIONS_INFO = "設定#NAME#選項",
   OPTIONS_TAB = "選項",

   POINT = "point",
   POINTS = "點",

   RAW = "Raw",
   FISH = "Fish",

   BOBBER_NAME = "釣魚浮標",
   FISHINGSKILL = "釣魚",

-- 以下為/fb命令參數,勿更動      
   HELP = "help",
   SWITCH = "switch",
   UPDATEDB = "updatedb",
   FORCE = "force",
-- 以上為/fb命令參數,勿更動   

   OUTFITS = "服裝",
   ELAPSED = "歷時",
   TOTAL = "全部",
   TOTALS = "全數",
   
   SCHOOL = "魚群",  -- e.g. 'Oily Blackmouth School'
   FLOATING_WRECKAGE = "漂浮殘骸",
   FLOATING_DEBRIS = "漂浮的碎片",
   ELEM_WATER = "元素之水",
   OIL_SPILL = "油井",

   GOLD_COIN = "金幣",
   SILVER_COIN = "銀幣",
   COPPER_COIN = "銅幣",
   
   LAGER = "蘭姆西船長的淡啤酒&",

-- 以下為/fb命令參數,勿更動
   ADD = "add",
   REPLACE = "replace",
   UPDATE = "update",
   CURRENT = "current",
   RESET = "reset",
   CLEANUP = "cleanup",
   CHECK = "check",
   NOW = "now",
-- 以上為/fb命令參數,勿更動   

   NOREALM = "不明地區",

-- 以下為/fb命令參數,勿更動
   WATCHER = "watcher",
   WATCHER_LOCK = "lock",
   WATCHER_UNLOCK = "unlock",
    
   WEEKLY = "weekly",
   HOURLY = "hourly",
-- 以上為/fb命令參數,勿更動      
   
--   BROADCAST_LABEL_TEXT = "視窗顯示";
--   BROADCAST_DUMP_TEXT = "阻擋";
--   BROADCAST_RECV_TEXT = "接受";

   OFFSET_LABEL_TEXT = "變換量:";

   KEYS_LABEL_TEXT = "輔助鍵",
   KEYS_NONE_TEXT = "無",
   KEYS_SHIFT_TEXT = "Shift",    -- shift 鍵
   KEYS_CTRL_TEXT = "Control",   -- control 鍵
   KEYS_ALT_TEXT = "Alt",        -- alt 鍵   

   SHOWFISHIES = "魚種",
   SHOWFISHIES_INFO = "以魚種顯示漁獲紀錄",

   SHOWLOCATIONS = "漁場",
   SHOWLOCATIONS_INFO = "以地點顯示漁獲紀錄",

-- Option names and tooltips
   CONFIG_SHOWNEWFISHIES_ONOFF   = "顯示新魚獲",
   CONFIG_SHOWNEWFISHIES_INFO    = "在交談視窗顯示該地點之新魚獲",
   CONFIG_FISHWATCH_ONOFF        = "魚獲監視器",
   CONFIG_FISHWATCH_INFO	 	 = "開啟該地點之魚獲監視視窗",
   CONFIG_FISHWATCHTIME_ONOFF    = "顯示經過時間",
   CONFIG_FISHWATCHTIME_INFO     = "顯示你拿起魚竿到現在經過的時間",
   CONFIG_FISHWATCHONLY_ONOFF    = "釣魚時開啟",
   CONFIG_FISHWATCHONLY_INFO	 = "只有在釣魚(手持釣竿)時開啟魚獲監視視窗",
   CONFIG_FISHWATCHSKILL_ONOFF   = "目前技能",
   CONFIG_FISHWATCHSKILL_INFO	 = "在監視器上顯示你目前釣魚技能及釣魚技能加成，括號內為技能要提升時(已經成功次數/估計所需的成功次數)",
   CONFIG_FISHWATCHZONE_ONOFF    = "目前區域",
   CONFIG_FISHWATCHZONE_INFO	 = "顯示所在漁場的區域及子區域名稱",
   CONFIG_FISHWATCHPERCENT_ONOFF = "顯示百分比",
   CONFIG_FISHWATCHPERCENT_INFO	 = "顯示該魚種占總魚獲的百分比",
   CONFIG_EASYCAST_ONOFF	 = "簡易拋竿",
   CONFIG_EASYCAST_INFO		 = "勾選後, 右鍵連點兩下拋竿",
   CONFIG_AUTOLOOT_ONOFF	 = "自動拾取",
   CONFIG_AUTOLOOT_INFO	     = "勾選後, 釣到魚後自動從物品欄中拾取",
   CONFIG_USEACTION_ONOFF	 = "使用快捷列",
   CONFIG_USEACTION_INFO	 = "勾選後, #NAME# 將使用快捷列上的按鍵拋竿",
   CONFIG_EASYLURES_ONOFF	 = "簡易上餌",
   CONFIG_EASYLURES_INFO	 = "勾選後, 若魚竿未上餌, 拋竿時自動安裝魚餌",
   CONFIG_ALWAYSLURE_ONOFF   = "Always Lure",
   CONFIG_ALWAYSLURE_INFO    = "If enabled, put a lure on every time the pole doesn't have one",   
   CONFIG_SHOWLOCATIONZONES_ONOFF	= "顯示區域",
   CONFIG_SHOWLOCATIONZONES_INFO	= "同時顯示區域及子區域",
   CONFIG_SORTBYPERCENT_ONOFF	= "魚獲數排序",
   CONFIG_SORTBYPERCENT_INFO	= "以魚獲數量排序而不是以名稱排序",
   CONFIG_STVTIMER_ONOFF		= "釣魚大賽計時器",
   CONFIG_STVTIMER_INFO		 = "勾選後, 顯示釣魚大賽計時及截止時間倒數",
   CONFIG_STVPOOLSONLY_ONOFF	= "魚群拋竿",
   CONFIG_STVPOOLSONLY_INFO	 = "勾選後, 游標在魚群上才會進行自動拋竿",
   CONFIG_TOOLTIPS_ONOFF	 = "物品提示顯示釣魚資訊",
   CONFIG_TOOLTIPS_INFO	     = "勾選後, 物品提示中會顯示該魚種的魚獲資訊",
   CONFIG_ONLYMINE_ONOFF	 = "僅用專用魚竿",
   CONFIG_ONLYMINE_INFO		 = "勾選後,簡易拋竿功能將只會檢查玩家持用釣魚裝設定的魚竿,來決定是否拋竿",
   CONFIG_TURNOFFPVP_ONOFF   = "關閉PVP",
   CONFIG_TURNOFFPVP_INFO    = "勾選後,當裝備魚竿時會關閉PVP(仍需要時間消除PVP標記)",
   CONFIG_BGSOUNDS_ONOFF     = "背景音效",
   CONFIG_BGSOUNDS_INFO      = "勾選後,魔獸世界在背景執行時音效會被打開",
   CONFIG_FINDFISH_ONOFF     = "尋找魚點",
   CONFIG_FINDFISH_INFO      = "勾選後,換上釣魚裝備時自動開啟「尋找魚點」技能",
      
   CONFIG_OUTFITTER_TEXT      = "裝備技能加成: %s\r\nDraznar給的造型分數: %d ",   

   CLICKTOSWITCH_ONOFF	        = "點擊切換",
   CLICKTOSWITCH_INFO	        = "勾選後,按左鍵點擊切換釣魚裝;未勾選則打開#NAME#視窗",   
      
   LEFTCLICKTODRAG = "按左鍵-拖動視窗",
   RIGHTCLICKFORMENU = "按右鍵-開選項",
   WATCHERCLICKHELP = "#LEFTCLICKTODRAG#\n#RIGHTCLICKFORMENU#",

   MINIMAPBUTTONPLACEMENT = "小地圖按鈕角度",
   MINIMAPBUTTONPLACEMENTTOOLTIP = "讓你可以移動#NAME#圖示在小地圖上的角度",
   MINIMAPBUTTONRADIUS = "小地圖按鈕距離",
   MINIMAPBUTTONRADIUSTOOLTIP = "讓你可以移動#NAME#圖示在小地圖上的距離",
   CONFIG_MINIMAPBUTTON_ONOFF	= "顯示小地圖按鈕",
   CONFIG_MINIMAPBUTTON_INFO	= "在小地圖上顯示#NAME#的圖示",

   CONFIG_ENHANCESOUNDS_ONOFF      = "增強釣魚音效",
   CONFIG_ENHANCESOUNDS_INFO       = "勾選後, 強化魚標跳動時減低低環境音效",

   HIDEINWATCHER = "在監視器上顯示該種魚獲",   
   
   -- messages
   COMPATIBLE_SWITCHER = "找不到可用的釣魚裝切換UI",
   TOOMANYFISHERMEN = "你安裝了好幾個簡易拋竿模組",
   FAILEDINIT = "未正確初始化",
   ADDFISHIEMSG = "新增漁獲 %s 至 %s.",
   ADDSCHOOLMSG = "新增漁群 '%s' 至 %s.",
   NODATAMSG = "無可用的漁獲資料",
   CLEANUP_NONEMSG = "無殘存的舊設定",
   CLEANUP_WILLMSG = "保留 |c#RED#%s|r: %s 的舊設定",
   CLEANUP_DONEMSG = "移除 |c#RED#%s|r: %s 的舊設定",
   CLEANUP_NOOLDMSG = "角色 |c#GREEN#%s|r 沒有舊設定",
   NONEAVAILABLE_MSG = "無得取用",
   UPDATEDB_MSG = "更新 %d 魚種名稱",   

   MINIMUMSKILL = "最低技能: %d",
   NOTLINKABLE = "<物品無法連結>",
   CAUGHTTHISMANY = "補獲:",
   CAUGHTTHISTOTAL = "總數:",
   FISHTYPES = "魚種: %d",
   CAUGHT_IN_ZONES = "魚場: %s",

   DASH = " -- ",
   FISHCAUGHT = "%d %s",
   
   EXTRAVAGANZA = "釣魚大賽在",
   
   TIMETOGO = "%s %d:%02d 之後開始",
   TIMELEFT = "%s %d:%02d 之後結束",
   
   FATLADYSINGS = "|c#RED#釣魚大賽結束|r (還%d:%02d截止)",
   -- Figgle Bassbait yells: We have a winner! NAME is the Master Angler!   
   RIGGLE_BASSBAIT = "^林格·巴斯貝特 .*: .*! (.*) .*!$",

   STVZONENAME = "荊棘谷",

   TOOLTIP_HINT = "提示：",
   TOOLTIP_HINTSWITCH = "點擊切換裝備",
   TOOLTIP_HINTTOGGLE = "點擊顯示#NAME#介面",

   -- Key binding support
   BINDING_HEADER_FISHINGBUDDY_BINDINGS = "#NAME#",
   BINDING_NAME_FISHINGBUDDY_TOGGLE = "切換#NAME#介面",
   BINDING_NAME_FISHINGBUDDY_SWITCH = "切換釣魚裝備",
   BINDING_NAME_FISHINGBUDDY_GOFISHING = "著裝釣魚",

   BINDING_NAME_TOGGLEFISHINGBUDDY_LOC = "切換#NAME#地點頁",
   BINDING_NAME_TOGGLEFISHINGBUDDY_OPT = "切換#NAME#選項頁",
};

FishingTranslations["zhTW"].SWITCH_HELP = {
      "|c#GREEN#/fb #SWITCH#|r",
      "    穿/脫漁具 (如果有安裝OutfitDisplayFrame 或Outfitter的話)",
};
FishingTranslations["zhTW"].WATCHER_HELP = {
      "|c#GREEN#/fb #WATCHER#|r [|c#GREEN##WATCHER_LOCK#|r or |c#GREEN##WATCHER_UNLOCK#|r or |c#GREEN##RESET#|r]",
      "    解鎖/鎖定/重置釣魚監視器的位置",
};
FishingTranslations["zhTW"].CURRENT_HELP = {
   "|c#GREEN#/fb #CURRENT# #RESET#|r",
   "    重置這次釣魚期間的監視器記錄",
};
FishingTranslations["zhTW"].UPDATEDB_HELP = {
   "|c#GREEN#/fb #UPDATEDB# [#FORCE#]|r",
   "    嘗試尋找所有我不知道的魚類名稱",
   "    嘗試跳過 '稀有' 魚類可能會使你斷線",
   "    -- '#FORCE#' 選項可以跳過檢測",
};
FishingTranslations["zhTW"].CLEANUP_HELP = {
      "|c#GREEN#/fb #CLEANUP#|r [|c#GREEN##CHECK#|r or |c#GREEN##NOW#|r]",
      "    清除舊設定, |c#GREEN##CHECK#|r 列出有哪些舊有",
      "    的設定可以用 |c#GREEN##NOW#|r指令移除.",
};

FishingTranslations["zhTW"].PRE_HELP = {
      "你可以使用 |c#GREEN#/fishingbuddy|r 或 |c#GREEN#/fb|r 來執行所有命令",
      "|c#GREEN#/fb|r: 執行釣魚助手,開啟釣魚助手視窗",
      "|c#GREEN#/fb #HELP#|r: 顯示本協助畫面",
};
FishingTranslations["zhTW"].POST_HELP = {
      "你可以在\"選項\"的\"按鍵設定\"裡面設定開啟#NAME#視窗及切換釣魚裝的按鍵",
};
