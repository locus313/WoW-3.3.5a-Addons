--   
-- zhTW Chinese Traditional Localisation for MobInfo
--
-- created by 艾娜羅沙@奧妮克希亞
-- updated by Coppermurky@暗影之月
-- updated for v3.46 by Avai@亞雷戈斯
--

if ( MI2_Locale == "zhTW" or MI2_Locale == "zhCN" ) then

MI2_SpellSchools		= { ["祕法"]="ar", ["火焰"]="fi", ["冰霜"]="fr", ["暗影"]="sh", ["神聖"]="ho", ["自然"]="na" } 

MI_TXT_WELCOME			= "歡迎使用MobInfo！";
MI_DESCRIPTION			= "增加怪物的詳細相關資訊到提示訊息視窗，並且在目標狀態欄顯示估計的生命/法力資料。";
MI_TXT_GENERAL_OPTIONS		= "這個選項頁面可控制 MobInfo 的主要功能. 其它的選項頁面則是針對各個功能做進一步的設定."

MI_TXT_GOLD			= "金";
MI_TXT_SILVER			= "銀";
MI_TXT_COPPER			= "銅";

MI_TXT_OPEN			= "開啟"
MI_TXT_COMBINED			= "已合併等級："
MI_TXT_MOB_DB_SIZE		= "MobInfo資料庫大小："
MI_TXT_HEALTH_DB_SIZE		= "生命力資料庫大小："
MI_TXT_PLAYER_DB_SIZE		= "玩家生命力資料庫大小："
MI_TXT_ITEM_DB_SIZE		= "物品資料庫大小："
MI_TXT_CUR_TARGET		= "目前目標："
MI_TXT_MH_DISABLED		= "MobInfo 警告：發現MobHealth插件。本插件內建的MobHealth功能已停用，請刪除獨立的MobHealth插件，以啟用本插件的全部功能。"
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n 單獨停用MobHealth並不會失去資料。\n\n好處是：血量/魔法位置可調整，並可調整顯示字體和大小")
MI_TXT_CLR_ALL_CONFIRM		= "你確認要執行以下刪除動作嗎？"
MI_TXT_SEARCH_LEVEL		= "怪物等級："
MI_TXT_SEARCH_MOBTYPE		= "怪物類型："
MI_TXT_SEARCH_LOOTS		= "怪物已拾取："
MI_TXT_TRIM_DOWN_CONFIRM	= "警告：這是一個直接永久性的資料刪除動作。你真的想刪除沒有被選取到的那些資料嗎？"
MI_TXT_CLAM_MEAT		= "蚌肉"
MI_TXT_SHOWING			= "顯示列表："
MI_TXT_DROPPED_BY		= "掉落："
MI_TXT_IMMUNE			= "免疫:"
MI_TXT_RESIST			= "抵抗:"
MI_TXT_DEL_SEARCH_CONFIRM	= "你是否真的要自資料庫中，刪除搜尋結果中的%d筆怪物的資料？"
MI_TXT_WRONG_LOC		= "錯誤：MobInfo資料庫的語系和WOW程式本身的語系不一致。在解決這問題之前，MobInfo資料庫是沒有用的。"
MI_TXT_WRONG_DBVER		= "錯誤：MobInfo資料庫不相容於目前的版本.\n\nMobInfo必須要先刪除舊有的資料檔案."
MI_TXT_PRICE			= "商人買入價"
MI_TXT_TOOLTIP_MOVE		= "要移動工具提示錨點\n只要利用滑鼠拖拉的方式拉到你想要的位置即可."
MI_TXT_ITEMFILTER		= "拾取物品過濾"

MI2_CHAT_MOBRUNS		= "想要轉身逃跑"
MI2_TXT_MOBRUNS			= "*逃跑*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG		= "開啟MobInfo選項"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "怪物提示訊息內容"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "怪物血量選項"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "資料庫選項"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]	= "生命力"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "法力值"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "搜尋選項"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "匯入外部資料"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "物品提示訊息選項"
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "MobInfo工具提示模板"


---------------------------
-- Tooltip Options/Content
---------------------------

MI_TXT_HEALTH		= "生命力"
MI_HLP_HEALTH		= "顯示生命力資訊 (目前/最大)"
MI_TXT_MANA		= "法力值"
MI_HLP_MANA		= "顯示法力/怒氣/精力資訊 (目前/最大)"
MI_TXT_KILLS		= "殺死數"
MI_HLP_KILLS		= "顯示你殺死此怪的次數\n這個數目依照角色不同\n而分別儲存"
MI_TXT_LOOTS		= "拾取次數"
MI_HLP_LOOTS		= "顯示此怪捨取的次數"
MI_TXT_COINS		= "平均金錢掉落"
MI_HLP_COINS		= "顯示此怪平均掉錢數\n此為顯示捨取後平均所得到的金額\n(但不包括捨取時金額為0的次數)"
MI_TXT_ITEMVAL		= "平均物品價值"
MI_HLP_ITEMVAL		= "顯示掉落物品的平均價值\n此為顯示掉落物品的平均價值\n(但不包括物品價值為0的次數)"
MI_TXT_MOBVAL		= "怪物總價值"
MI_HLP_MOBVAL		= "顯示此怪的平均總價值\n此為顯示捨取後所得到的金額\n以及掉落物品的平均價值"
MI_TXT_XP		= "經驗"
MI_HLP_XP		= "顯示殺死此怪所得到的經驗值.\n(不顯示灰色怪物的經驗值)"
MI_TXT_TO_LEVEL		= "升級還需..."
MI_HLP_TO_LEVEL		= "顯示到升級前還需殺死多少與目前同樣的怪物.\n(不顯示灰色怪物的數目)"
MI_TXT_EMPTY_LOOTS	= "空捨取數"
MI_HLP_EMPTY_LOOTS	= "顯示空屍數目 (數目/百分比)\n此為顯示你捨取了多少內無寶物的\n空屍體數目"
MI_TXT_CLOTH_DROP	= "布料掉落"
MI_HLP_CLOTH_DROP	= "顯示怪物掉落布料的資訊"
MI_TXT_CLASS		= "職業"
MI_HLP_CLASS		= "顯示怪物的職業"
MI_TXT_DAMAGE		= "傷害+DPS"
MI_HLP_DAMAGE		= "顯示怪物所能造成的傷害 (最小/最大) 和 DPS (每秒傷害率)\n各個角色的傷害值以及DPS為分開儲存.\n雖然DPS的更新會有些慢, 但會在每一次的戰鬥中\n都會進行計算"
MI_TXT_QUALITY		= "品質"
MI_OPT_QUALITY		= "掉落物品的品質"
MI_HLP_QUALITY		= "顯示捨取品質的次數及百分比\n此設定為計算撿取的物品等級和次數\n如撿捨到空屍則不予計算.\n百分比則是顯示每一種物品等級撿取的比率"
MI_TXT_LOCATION		= "地點: "
MI_HELP_LOCATION	= "顯示怪物現身的地點\n要使用這個設定必需啟用記錄地點選項"
MI_TXT_LOWHEALTH	= "轉身逃跑偵測"
MI_HELP_LOWHEALTH	= "偵測會轉身逃跑的怪物\n這個偵測訊息將會以紅字表示在工具提示內"
MI_TXT_RESISTS		= "抗性"
MI_OPT_RESISTS		= "抗性和免疫"
MI_HELP_RESISTS		= "依照怪物本身法術的能力來顯示\n抗性和免疫的資訊"
MI_TXT_ITEMLIST		= "基本捨取物品清單"
MI_HELP_ITEMLIST	= "顯示基本捨取物品的名稱及數量\n所謂基本捨取物品為除了布料或皮革以外的物品統稱.\n要使用這個設定必需啟用記錄捨取物品選項"
MI_TXT_CLOTHSKIN	= "布料和皮革捨取"
MI_HELP_CLOTHSKIN	= "顯示捨取的布料和皮革的名稱及數量\n要使用這個設定必需啟用記錄捨取物品選項"
MI_TXT_IMMUN		= "免疫"
MI_HELP_IMMUN		= "偵測具有免疫的怪物"

--------------------
-- General Options
--------------------
MI2_OPTIONS = {};

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
			{ text = "記錄怪物並保存詳細怪物資訊"; 
			help = "此功能可讓你啟用或停用記錄詳細怪物的資訊\n儲存的記錄可以用於顯示在工具提示中, 或是\n用於MobInfo的搜尋工具裡.\n並且你可以從這些資料得知物品掉落的資訊.\n\n備註: 怪物生命力及法力的記錄在此項停用時仍會進行." }

MI2_OPTIONS["MI2_OptShowMobInfo"] = 
			{ text = "在MobInfo工具提示顯示怪物資訊"; 
			help = "啟用工具提示顯示怪物資訊.\n使用這個選項來設定你要在工具提示上顯示\n哪些怪物資料." }

MI2_OPTIONS["MI2_OptUseGameTT"] = 
			{ text = "使用遊戲工具提示替代MobInfo工具提示"; 
			help = "預設MobInfo使用自定的工具提示框架設定,\n啟用此項來使用遊戲內建工具提示以取代MobInfo工具提示框架設定." }

MI2_OPTIONS["MI2_OptShowItemInfo"] = 
			{ text = "在物品工具提示顯示進階資訊"; 
			help = "啟用這個選項將會在工具提示中顯示物品資訊.\n你可以在工具提示選項中你可以設定\n你要顯示的資訊項目."; }

MI2_OPTIONS["MI2_OptShowTargetInfo"] = 
			{ text = "在目標框架顯示怪物資訊 (生命力/法力/其它)"; 
			help = "在目標框架中顯示目標的生命力/法力等等的數值.\n(只有在沒有安裝任何UnitFrame插件才有作用)\n你可以在目標選項頁面中設定顯示的位置." }

MI2_OPTIONS["MI2_OptShowMMButton"] = 
			{ text = "顯示小地圖按鈕"; 
			help = "在小地圖小顯示/隱藏MobInfo按鈕" }

MI2_OPTIONS["MI2_OptMMButtonPos"] = 
			{ text = "小地圖按鈕位置"; 
			help = "使用移動條變更MobInfo按鈕在小地圖上的位置" }


--------------------
-- Other Options
--------------------

MI2_OPTIONS["MI2_OptShowIGrey"] = 
			{ text = ""; 
			help = "在工具提示中顯示灰色物品" }

MI2_OPTIONS["MI2_OptShowIWhite"] = 
			{ text = ""; 
			help = "在工具提示中顯示白色物品" }

MI2_OPTIONS["MI2_OptShowIGreen"] = 
			{ text = ""; 
			help = "在工具提示中顯示綠色物品" }

MI2_OPTIONS["MI2_OptShowIBlue"] = 
			{ text = ""; 
			help = "在工具提示中顯示藍色物品" }

MI2_OPTIONS["MI2_OptShowIPurple"] = 
			{ text = ""; 
			help = "在工具提示中顯示紫色物品" }

MI2_OPTIONS["MI2_OptMouseTooltip"] = 
			{ text = "在鼠標上顯示工具提示"; 
			help = "在鼠標上顯示MobInfo的工具提示\n並且會隨著鼠標而移動." }

MI2_OPTIONS["MI2_OptHideAnchor"] = 
			{ text = "隱藏工具提示錨點"; 
			help = "隱藏MobInfo工具提示上的'MI'錨點." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
			{ text = "合併怪物資訊"; 
			help = "在工具提示合併怪物等級資訊." }

MI2_OPTIONS["MI2_OptSmallFont"] = 
			{ text = "使用小字體"; 
			help = "工具提示使用小字體" }

MI2_OPTIONS["MI2_OptTooltipMode"] = 
			{ text = "工具提示位置"; 
			help = "設定工具提示視窗的位置."; choice1 = "左上"; choice2 = "左下"; choice3 = "右上 "; choice4 = "右下"; choice5="Center Above"; choice6="Center Below" }

MI2_OPTIONS["MI2_OptCompactMode"] =
			{ text = "雙列工具提示"; 
			help = "用雙列工具提示視窗顯示怪物資訊.\n工具提示視窗會變得更寬\n但有一定的限制." }

MI2_OPTIONS["MI2_OptOtherTooltip"] =
			{ text = "關閉其它工具提示"; 
			help = "當工具提示顯示怪物資訊時關閉其它的提示訊息." }

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
			{ text = "最小"; 
			help = "搜尋怪物時的最小等級限制"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
			{ text = "最大"; 
			help = "搜尋怪物時的最大等級限制(必須< 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
			{ text = "普通"; 
			help = "在搜尋結果中包含普通怪物"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
			{ text = "精英"; 
			help = "在搜尋結果中包含精英怪"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
			{ text = "首領"; 
			help = "在搜尋結果中包含首領級別的怪物"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
			{ text = "最小"; 
			help = "搜尋結果中的怪物，必須「拾取其物品」過的最小次數"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
			{ text = "最大"; 
			help = "搜尋結果中的怪物，必須「拾取其物品」過的最小次數"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
			{ text = "怪物名稱"; 
			help = "想要搜尋的怪物的部分，或者完整名稱"; 
			info = '空白時，不限制搜尋全部的物品。輸入"*"搜尋全部物品'; }  

MI2_OPTIONS["MI2_OptSearchItemName"] = 
			{ text = "物品名稱"; 
			help = "想要搜尋的物品部分或者完整名稱";
			info = '空白時將會搜尋所有物品名稱'; }	

MI2_OPTIONS["MI2_OptSortByValue"] = 
			{ text = "按數值分類"; 
			help = "分類搜尋結果按怪物值"; 
			info = '按你能夠對怪物造成的傷害值，來尋找它們。'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
			{ text = "按物品數分類"; 
			help = "分類搜尋結果按物品數列表"; 
			info = '按怪物掉落指定物品的品質分類尋找到的怪物。'; }

MI2_OPTIONS["MI2_OptItemTooltip"] = 
			{ text = "物品資訊欄顯示掉落怪物"; 
			help = "在物品的提示資訊中，顯示掉落該物品的怪物名稱"; 
			info = "在提示資訊中顯示可掉落滑鼠所指物品的所有怪物。\n每行顯示該怪物掉落的物品數量及占總數的百分比。" }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
			{ text = "顯示商店售價"; 
			help = "在物品的提示資訊中，顯示該物品的商店售出價格" }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
			{ text = "整合相同怪物"; help = "對同樣名字的怪物合併計算"; 
			info = "整合模式會合併計算相同名字，但不同等級的怪物。\n啟用後將使得不同等級但是同一名字的怪物，其資料顯示一致。" }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
			{ text = "按住ALT顯示怪物資訊"; 
			help = "只有按下ALT才會在提示框顯示怪物資訊"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
			{ text = ""; 
			help = "設置提示資訊裏顯示的拾取物品的過濾條件";
			info = "只在提示資訊中顯示那些包含過濾文本的物品。\n例如輸入'布'將只顯示物品名稱包含'布'的物品。\n不輸入任何文字查看所有物品。" }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
			{ text = "永久儲存玩家生命力"; 
			help = "永久儲存在PVP戰鬥中獲得的玩家生命力資料。";
			info = "一般情況下PVP戰鬥結束\n後玩家生命力資料將被丟棄，這\n個選項允許你記錄該資料。" }

MI2_OPTIONS["MI2_OptAllOn"] = 
			{ text = "顯示全開"; 
			help = "將所有的顯示選項打開"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
			{ text = "顯示全關"; 
			help = "將所有的顯示選項關閉"; }

MI2_OPTIONS["MI2_OptDefault"] = 
			{ text = "預設"; 
			help = "顯示預設的怪物資訊"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
			{ text = "完成"; 
			help = "關閉 MobInfo 選項對話方塊"; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
			{ text = "顯示生命力"; 
			help = "在目標框顯示生命力"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
			{ text = "顯示法力值"; 
			help = "在目標框顯示法力值"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
			{ text = "顯示百分比"; 
			help = "在目標框顯示生命力百分比"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
			{ text = "顯示百分比"; 
			help = "在目標框顯示法力值百分比"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
			{ text = "水平位置"; 
			help = "調整生命力的水平位置"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
			{ text = "垂直位置"; 
			help = "調整生命力的垂直位置"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
			{ text = "水平位置"; 
			help = "調整法力值的水平位置"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
			{ text = "垂直位置"; 
			help = "調整法力值的垂直位置"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
			{ text = "字體"; 
			help = "設定生命/法力值的顯示字體";
			choice1= "數值字體"; choice2="遊戲字體"; choice3="物品資訊字體" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
			{ text = "字體大小"; 
			help = "設定生命/法力值的顯示字體大小。"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
			{ text = "清除目前目標資料"; 
			help = "清除目前目標的資料。"; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
			{ text = "清除怪物資料"; 
			help = "清除全部怪物資訊資料。"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
			{ text = "清除生命力資料"; 
			help = "清除全部怪物生命力資料。"; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
			{ text = "清除玩家資料"; 
			help = "清除全部玩家生命力資料。"; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
			{ text = "記錄以下品質的掉落物品資料:"; 
			help = "開啟後記錄所有MobInfo所能記的怪物相關資料。";
			info = "你可以選擇想記錄的物品的品質等級。"; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
			{ text = "記錄角色相關的怪物資料"; 
			help = "開啟後記錄所有和玩家角色有關的怪物資訊。";
			info = "開啟或關閉保存以下資料：\n擊殺次數、最大／最小傷害、DPS (每秒傷害值)\n\n這些資料將依玩家角色分開儲存。\n這幾個資料只能同時設定為『儲存』或『不儲存』。"; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
			{ text = "記錄抵抗和免疫資料"; 
			help = "記錄怪物對各種性質的法術的抵抗和免疫的資料。";
			info = "記錄怪物對各種屬性法術的抵抗和免疫的統計資料。"; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
			{ text = ""; 
			help = "記錄指定品質(含)更好的物品詳細資訊。"; 
			choice1 = "灰色以及更好"; choice2="白色以及更好"; choice3="綠色以及更好" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
			{ text = "最佳化怪物資料庫大小"; 
			help = "移除過剩的資料，以最佳化怪物資料庫大小。";
			info = "過剩的資料是指資料庫裡，未被設定為需要記錄的全部資料。"; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
			{ text = "開始匯入"; 
			help = "匯入外部資料到你自己的怪物資料庫";
			info = "注意：請仔細詳讀匯入步驟的指示！\n一定要在匯入前，先備份自己的資料庫，以免造成資料永久遺失！"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
			{ text = "刪除"; 
			help = "自資料庫中，刪除所有在搜尋結果中的怪物資料。";
			info = "警告：本步驟是沒辦法復原的，\n使用前請小心！\n建議在刪除這些資料前，先備份自己的資料庫。"; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
			{ text = "只匯入目前還未知的怪物資料"; 
			help = "匯入目前在你的資料庫中，還沒有記錄的資料";
			info = "開啟這個選項可以預防現在已存在的資料，被匯入的資料蓋掉，\n只有目前未知(新的)資料會匯入資料庫。\n如此可以確保原資料的一致性。"; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
			{ text = "怪物列表"; 
			help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
			{ text = "物品列表"; 
			help = ""; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] = 
			{ text = "提示資訊選項"; 
			help = "設定在提示資訊裏面，顯示的怪物資訊選項"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] = 
			{ text = "生命/法力值"; 
			help = "設置目標框中顯示生命/法力值的選項"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] = 
			{ text = "資料庫"; 
			help = "資料庫管理選項"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
			{ text = "搜尋"; 
			help = "搜尋資料庫"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
			{ text = "一般"; 
			help = "MobInfo插件的一般選項"; }

end
