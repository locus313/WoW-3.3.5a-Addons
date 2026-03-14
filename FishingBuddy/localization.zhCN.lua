-- Translation for zhCN   by  biAji 

-- FishingTranslations = {};
FishingTranslations["zhCN"] = {
   NAME = "钓鱼助手",

   DESCRIPTION1 = "追踪钓鱼资料、",
   DESCRIPTION2 = "管理钓鱼装备",

   -- Tab labels and tooltips
   LOCATIONS_INFO = "根据区域及鱼的种类显示曾经的钓鱼地点",
   LOCATIONS_TAB = "地点",
   OPTIONS_INFO = "设置#NAME#选项",
   OPTIONS_TAB = "选项",

   POINT = "point",
   POINTS = "points",

   RAW = "Raw",
   FISH = "Fish",

   BOBBER_NAME = "垂钓水花",
   FISHINGSKILL = "Fishing",

   SCHOOL = "School",  -- e.g. 'Oily Blackmouth School'
   FLOATING_WRECKAGE = "Floating Wreckage",
   FLOATING_DEBRIS = "Floating Debris",
   ELEM_WATER = "元素之水",
   OIL_SPILL = "Oil Spill",

   LAGER = "拉姆瑟船长的特酿啤酒",
  
   OFFSET_LABEL_TEXT = "偏移：";

   KEYS_LABEL_TEXT = "辅助键",
   KEYS_NONE_TEXT = "无",

   SHOWFISHIES = "显示鱼种",
   SHOWFISHIES_INFO = "根据鱼种显示钓鱼记录",

   SHOWLOCATIONS = "地点",
   SHOWLOCATIONS_INFO = "根据地区显示钓鱼记录",

   -- Option names and tooltips
   CONFIG_SHOWNEWFISHIES_ONOFF   = "显示新鱼",
   CONFIG_SHOWNEWFISHIES_INFO    = "在聊天窗口显示目前所在地区钓到新鱼种",
   CONFIG_FISHWATCH_ONOFF        = "钓鱼监视器",
   CONFIG_FISHWATCH_INFO	 	 = "显示目前位置的钓鱼信息",
   CONFIG_FISHWATCHONLY_ONOFF    = "钓鱼时开启",
   CONFIG_FISHWATCHONLY_INFO	 = "仅钓鱼过程中开启",
   CONFIG_FISHWATCHSKILL_ONOFF   = "当前技能级别",
   CONFIG_FISHWATCHSKILL_INFO	 = "在钓鱼监视器中显示当前钓鱼技能级别及附加技能点",
   CONFIG_FISHWATCHZONE_ONOFF    = "当前区域",
   CONFIG_FISHWATCHZONE_INFO	 = "在钓鱼监视器中显示当前区域名称",
   CONFIG_FISHWATCHPERCENT_ONOFF = "显示百分比",
   CONFIG_FISHWATCHPERCENT_INFO	 = "在钓鱼监视器中显示每种鱼所占的百分比",
   CONFIG_SUITUPFIRST_ONOFF      = "职业换装",
   CONFIG_SUITUPFIRST_INFO       = "当绑定键被按下时，换上钓鱼套装",
   CONFIG_EASYCAST_ONOFF	 = "随心抛杆",
   CONFIG_EASYCAST_INFO		 = "启用右键双击抛杆",
   CONFIG_AUTOLOOT_ONOFF	 = "自动拾取",
   CONFIG_AUTOLOOT_INFO	     = "启用时，自动拾取垂钓物品",
   CONFIG_EASYLURES_ONOFF	 = "简易上饵",
   CONFIG_EASYLURES_INFO	 = "启用后，开始钓鱼时将自动上饵",
   --CONFIG_ONLYMINE_ONOFF	 = "Outfit Pole Only",
   --CONFIG_ONLYMINE_INFO		 = "If enabled, easy cast will only check for your outfit's fishing pole (i.e. it won't search all possible poles for a match).",
   CONFIG_SHOWLOCATIONZONES_ONOFF	= "显示区域",
   CONFIG_SHOWLOCATIONZONES_INFO	= "同时显示区域及子区域",
   CONFIG_SORTBYPERCENT_ONOFF	= "按钓鱼数排序",
   CONFIG_SORTBYPERCENT_INFO	= "按照捕获鱼的数量排序",
   CONFIG_STVTIMER_ONOFF		= "钓鱼大赛计时器",
   CONFIG_STVTIMER_INFO		= "启用时，提示大赛开始时间及大赛结束时间的倒数",
   CONFIG_STVPOOLSONLY_ONOFF	= "仅在鱼群抛杆",
   CONFIG_STVPOOLSONLY_INFO	= "启用后，仅当鼠标位于鱼群上时，才自动抛杆",
   CONFIG_TOOLTIPS_ONOFF	= "在提示框中显示垂钓信息",
   CONFIG_TOOLTIPS_INFO	= "启用后，将在物品栏中显示此鱼的垂钓信息",

   CONFIG_OUTFITTER_TEXT      = "钓鱼装备加成：%s\r\nDraznar's style score: %d ",

   CLICKTOSWITCH_ONOFF	        = "点击换装",
   CLICKTOSWITCH_INFO	        = "启用时，单击开关换装，否则显示钓鱼助手窗口。",

   LEFTCLICKTODRAG = "左键点击拖曳",
   RIGHTCLICKFORMENU = "右键点击显示目录",
   WATCHERCLICKHELP = "#LEFTCLICKTODRAG#\n#RIGHTCLICKFORMENU#",

   MINIMAPBUTTONPLACEMENT = "按钮位置",
   MINIMAPBUTTONPLACEMENTTOOLTIP = "允许在小地图上移动#NAME#图标的位置",
   CONFIG_MINIMAPBUTTON_ONOFF	= "显示小地图图标",
   CONFIG_MINIMAPBUTTON_INFO	= "在小地图旁显示#NAME#图标",

   CONFIG_ENHANCESOUNDS_ONOFF      = "增强钓鱼音效",
   CONFIG_ENHANCESOUNDS_INFO       = "启用时，最大化声音的同时最小化环境音效，以突出上钩时水花声音",

   -- messages
   COMPATIBLE_SWITCHER = "未发现合适的装备。",
   TOOMANYFISHERMEN = "你启用了两种以上的简易垂钓配置。",
   FAILEDINIT = "初始化错误。",
   ADDFISHIEMSG = "添加 %s 至地点 %s。",
   ADDSCHOOLMSG = "添加 '%s' 至地点 %s。",
   NODATAMSG = "不存在钓鱼信息。",
   CLEANUP_NONEMSG = "不存在以前的配置。",
   CLEANUP_WILLMSG = "存在 |c#RED#%s|r: %s 的配置信息。",
   CLEANUP_DONEMSG = "移除 |c#RED#%s|r: %s 的配置。",
   CLEANUP_NOOLDMSG = "不存在 |c#GREEN#%s|r 的配置",
   NONEAVAILABLE_MSG = "不存在",
   UPDATEDB_MSG = "更新 %d 鱼名称。",

   MINIMUMSKILL = "最低技能需求：%d",
   NOTLINKABLE = "<物品无法连接>",
   CAUGHTTHISMANY = "捕获：",
   CAUGHTTHISTOTAL = "合计：",
   FISHTYPES = "鱼种：%d",
   CAUGHT_IN_ZONES = "垂钓于：%s",

   DASH = " -- ",
   FISHCAUGHT = "%d %s",
   
   EXTRAVAGANZA = "钓鱼大赛将在",
   
   TIMETOGO = "%s %d:%02d 开始",
   TIMELEFT = "%s %d:%02d 结束",
   FATLADYSINGS = "|c#RED#钓鱼大赛结束|r (尚余%d:%02d)",
   RIGGLE_BASSBAIT = "^Riggle Bassbait .*: .*! (.*) .*!$",

   STVZONENAME = "荆棘谷",

   TOOLTIP_HINT = "提示：",
   TOOLTIP_HINTSWITCH = "点击切换装备",
   TOOLTIP_HINTTOGGLE = "点击显示#NAME#窗口",

   -- Key binding support
   BINDING_HEADER_FISHINGBUDDY_BINDINGS = "#NAME#",
   BINDING_NAME_FISHINGBUDDY_TOGGLE = "切换#NAME#窗口",
   BINDING_NAME_FISHINGBUDDY_SWITCH = "切换钓鱼装备",
   BINDING_NAME_FISHINGBUDDY_GOFISHING = "换装上阵！",

   BINDING_NAME_TOGGLEFISHINGBUDDY_LOC = "切换#NAME#地点面板",
   BINDING_NAME_TOGGLEFISHINGBUDDY_OPT = "切换#NAME#选项面板",
};

FishingTranslations["zhCN"].SWITCH_HELP = {
      "|c#GREEN#/fb #SWITCH#|r",
      "    穿/脱渔装 (如果安装了OutfitDisplayFrame或Outfitter插件)",
};
FishingTranslations["zhCN"].WATCHER_HELP = {
   "|c#GREEN#/fb #WATCHER#|r [|c#GREEN##WATCHER_LOCK#|r or |c#GREEN##WATCHER_UNLOCK#|r or |c#GREEN##RESET#|r]",
   "    解锁钓鱼监视器以便移动，",
   "    锁定停止移动，重置则进行重置。"
};
FishingTranslations["zhCN"].CURRENT_HELP = {
   "|c#GREEN#/fb #CURRENT# #RESET#|r",
   "    重置此次钓鱼周期的记录",
};
FishingTranslations["zhCN"].UPDATEDB_HELP = {
   "|c#GREEN#/fb #UPDATEDB# [#FORCE#]|r",
   "    尝试发现所有我不知道的鱼的名称。",
   "    如果尝试跳过 '稀有' 鱼种可能会使你掉线",
   "    -- 使用'#FORCE#'选项来跳过检测",
};
FishingTranslations["zhCN"].CLEANUP_HELP = {
      "|c#GREEN#/fb #CLEANUP#|r [|c#GREEN#f#CHECK#|r or |c#GREEN##NOW#|r]",
      "    清除旧配置。 |c#GREEN##CHECK#|r 显示那些配置将被 |c#GREEN##NOW#|r 移除。",
};
FishingTranslations["zhCN"].PRE_HELP = {
      "你可以用 |c#GREEN#/fishingbuddy|r 或 |c#GREEN#/fb|r 命令使用所有功能",
      "仅用 |c#GREEN#/fb|r 时，切换显示钓鱼助手窗口",
      "|c#GREEN#/fb #HELP#|r 显示此帮助。",
};
FishingTranslations["zhCN"].POST_HELP = {
      "你可以在\"按键绑定\"窗口，将窗口切换或换装命令",
      "绑定于指定键。",
};
