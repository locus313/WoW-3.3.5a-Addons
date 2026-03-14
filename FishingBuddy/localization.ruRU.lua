-- Russian translation by StingerSoft


FishingTranslations["ruRU"] = {
   NAME = "Fishing Buddy",
   
   -- we can (should?) translate everything below here
   DESCRIPTION1 = "Отслеживает какую рыбу и где вы поймали",
   DESCRIPTION2 = "и помогает управлять вашим рыболовским снарежением.",

   -- Tab labels and tooltips
   LOCATIONS_INFO = "Отображает, где вы поймали рыбу по зоне или типу рыбы",
   LOCATIONS_TAB = "Расположение",
   OPTIONS_INFO = "Настройки #NAME#",
   OPTIONS_TAB = "Настройки",

   POINT = "очко",
   POINTS = "очков",

   RAW = "сырой",
   FISH = "Рыба",
   RANDOM = "Случайно",

   BOBBER_NAME = "Поплавок",
   FISHINGSKILL = "Рыбная ловля",
   HELP = "help",
   SWITCH = "switch",
   UPDATEDB = "updatedb",
   FORCE = "force",

   OUTFITS = "Снаряжение",
   ELAPSED = "Пройденно",
   TOTAL = "Всего",
   TOTALS = "Общее",
   
   SCHOOL = "косяк",  -- e.g. 'Oily Blackmouth School'
   FLOATING_WRECKAGE = "Плавающие обломки",
   FLOATING_DEBRIS = "Плавающий мусор",
   ELEM_WATER = "Первородная вода",
   OIL_SPILL = "Нефтяное пятно",

   GOLD_COIN = "Золотые монеты",
   SILVER_COIN = "Серебряные монеты",
   COPPER_COIN = "Медные монеты",
   
   LAGER = "Светлое пиво капитана Ромси",

   ADD = "add", -- добавить
   REPLACE = "replace", -- заменить
   UPDATE = "update", -- обновить
   CURRENT = "current", -- текущий
   RESET = "reset", -- сбросить
   CLEANUP = "cleanup", -- очистить
   CHECK = "check", -- проверить
   NOW = "now", -- сейчас
   TIMER = "timer", --таймер
   CAST = "cast", --применение

   NOREALM = "неизвестный сервер",

   WATCHER = "watcher", -- наблюдатель
   WATCHER_LOCK = "lock", -- блокировать
   WATCHER_UNLOCK = "unlock", -- разблокировать

   WEEKLY = "weekly", -- еженедельно
   HOURLY = "hourly", -- ежечасно

   OFFSET_LABEL_TEXT = "Смещение:";

   KEYS_LABEL_TEXT = "Клавиша:",
   KEYS_NONE_TEXT = "Нету",
   KEYS_SHIFT_TEXT = "Shift",
   KEYS_CTRL_TEXT = "Control",
   KEYS_ALT_TEXT = "Alt",

   SHOWFISHIES = "Рыба",
   SHOWFISHIES_INFO = "Показать весь ваш улов, сгруппированный по названию рыбы.",

   SHOWLOCATIONS = "Локации",
   SHOWLOCATIONS_INFO = "Показать весь ваш улов, отсортированно по зоне ловли.",
   
   ALLZOMGPETS = "+ все питомцы",

   -- Option names and tooltips
   CONFIG_SHOWNEWFISHIES_ONOFF   = "Новая рыбв",
   CONFIG_SHOWNEWFISHIES_INFO    = "Выводит сообщение в окно чата, когда вы поймали новую рыбы в текущем месте.",
   CONFIG_FISHWATCH_ONOFF        = "Наблюдатель",
   CONFIG_FISHWATCH_INFO	 	 = "Отображать текстовый фрейм с информацией о пойманных рыбках в текущем месте.",
   CONFIG_FISHWATCHTIME_ONOFF    = "Сколько времени я рыбачу?",
   CONFIG_FISHWATCHTIME_INFO     = "Показывать время, прошедшее с того момента, как вы взяли в руки удочку",
   CONFIG_FISHWATCHONLY_ONOFF    = "Только во время рыбалки",
   CONFIG_FISHWATCHONLY_INFO	 = "Наблюдатель будет активен только во время рыбалки",
   CONFIG_FISHWATCHSKILL_ONOFF   = "Текущий навык",
   CONFIG_FISHWATCHSKILL_INFO	 = "Показывать текущий уровень навыка и его модификаторы.",
   CONFIG_FISHWATCHZONE_ONOFF    = "Текущая зона",
   CONFIG_FISHWATCHZONE_INFO	 = "Показывать текущую локацию.",
   CONFIG_FISHWATCHPERCENT_ONOFF = "В процентах",
   CONFIG_FISHWATCHPERCENT_INFO	 = "Отображать проценты для каждой рыбки в наблюдателе.",
   CONFIG_EASYCAST_ONOFF	 = "Простая ловля",
   CONFIG_EASYCAST_INFO		 = "Закидывать удочку по двойному-правому-клику.",
   CONFIG_AUTOLOOT_ONOFF	 = "Авто сбор",
   CONFIG_AUTOLOOT_INFO	     = "Автоматически собирать всю пойманную рыбу.",
   CONFIG_USEACTION_ONOFF	 = "Действия",
   CONFIG_USEACTION_INFO	 = "#NAME# будет пытаться использовать кнопку на панели для рыбалки.",
   CONFIG_EASYLURES_ONOFF	 = "Авто-наживка",
   CONFIG_EASYLURES_INFO	 = "Наживка будет автоматически применяться к вашей удочке, если это необходимо, конечно.",
   CONFIG_ALWAYSLURE_ONOFF   = "Всегда наживлять",
   CONFIG_ALWAYSLURE_INFO    = "Наживка будет применяться всегда, если на удочке нет никакой наживки.",
   CONFIG_SHOWLOCATIONZONES_ONOFF	= "Зоны",
   CONFIG_SHOWLOCATIONZONES_INFO	= "Показывать зоны и подзоны.",
   CONFIG_SORTBYPERCENT_ONOFF = "Сорт по улову",
   CONFIG_SORTBYPERCENT_INFO  = "Упорядочить информацию об улове по его количеству, а не по алфавиту.",
   CONFIG_STVTIMER_ONOFF     = "Таймер Рыбомания",
   CONFIG_STVTIMER_INFO	     = "Показывать время, оставшееся до старта Рыбомании или время, оставшееся до его завершения.",
   CONFIG_STVPOOLSONLY_ONOFF = "Забрасывать только в водоёмы",
   CONFIG_STVPOOLSONLY_INFO	 = "Простая ловля будет применяться только тогда, когда курсор находится над водоёмом.",
   CONFIG_TOOLTIPS_ONOFF     = "Информация о рыбе в подсказках",
   CONFIG_TOOLTIPS_INFO      = "Показывать информацию о выловленной рыбе в подсказках предметов.",
   CONFIG_ONLYMINE_ONOFF     = "Одеть только удочку",
   CONFIG_ONLYMINE_INFO	     = "Если включено, во время простой ловли будет проверяться ваше снаряжение только на наличие удочки.",
   CONFIG_TURNOFFPVP_ONOFF   = "Отключить ПвП",
   CONFIG_TURNOFFPVP_INFO    = "Если у вас одета удочка, возможности PVP отключается.",
   CONFIG_BGSOUNDS_ONOFF     = "Фоновой звук",
   CONFIG_BGSOUNDS_INFO      = "Включение фонового звука, вто время как WoW свёрнут.",
   
   CONFIG_FISHINGFLUFF_ONOFF = "Fishing Fun",
   CONFIG_FISHINGFLUFF_INFO  = "Enable all sorts of fun while you fish",
   CONFIG_FINDFISH_ONOFF     = "Поиск рыбы",
   CONFIG_FINDFISH_INFO      = "Включает способность 'Поиск рыбы', когда вы одеваетесь на рыбалку",
   CONFIG_DRINKHEAVILY_ONOFF = "Drink Lager",
   CONFIG_DRINKHEAVILY_INFO  = "If enabled, drink #LAGER# whenever you're fishing and 'dry'.",
   CONFIG_FISHINGBUDDY_ONOFF = "Fishing Buddy",
   CONFIG_FISHINGBUDDY_INFO  = "Bring out that special buddy while you fish.",
   
   CONFIG_WATCHBOBBER_ONOFF  = "Следить за поплавком",
   CONFIG_WATCHBOBBER_INFO   = "Если включено, #NAME# не будет забрасывать попловок водоём, если курсор мыши наведен/зависает над поплавком.",
   
   CONFIG_OUTFITTER_TEXT     = "Бонус от снарежения: %s\r\nСчет (в стиле Draznar'а): %d ",

   CLICKTOSWITCH_ONOFF	        = "Клик для смени набора",
   CLICKTOSWITCH_INFO	        = "Левый клик будет переключать выбранный набор экипировки, вместо того, чтобы открывать главное окно #NAME#.",

   LEFTCLICKTODRAG = "[Левый-клик] - перемещение",
   RIGHTCLICKFORMENU = "[Правый-клик] - меню",
   WATCHERCLICKHELP = "#LEFTCLICKTODRAG#\n#RIGHTCLICKFORMENU#",

   MINIMAPBUTTONPLACEMENT = "Размещение",
   MINIMAPBUTTONPLACEMENTTOOLTIP = "Позволяет перемещать иконку #NAME# у мини-карты",
   MINIMAPBUTTONRADIUS = "Расстояние",
   MINIMAPBUTTONRADIUSTOOLTIP = "Определяет как долеко может быть расположена иконка #NAME# у мини-карты",
   CONFIG_MINIMAPBUTTON_ONOFF	= "Иконка у мини карты",
   CONFIG_MINIMAPBUTTON_INFO	= "Показывать иконку #NAME# у мини карте.",

   CONFIG_ENHANCESOUNDS_ONOFF      = "Повысить громкость",
   CONFIG_ENHANCESOUNDS_INFO       = "Во время рыбалки, #NAME# увеличит громкость звука до максимума и уменьшит громкость звука окружающей среды до минимума.",

   HIDEINWATCHER = "Показывать эту рыбу в наблюдателе",

   -- messages
   COMPATIBLE_SWITCHER = "Не найдено подходящего снаряжения.",
   TOOMANYFISHERMEN = "У вас установлен другой аддон для простой ловли.",
   FAILEDINIT = "Инициализация выполнена с ошибками.",
   ADDFISHIEMSG = "добавлено: %s, к локации %s.",
   ADDSCHOOLMSG = "добавлено: '%s', к локации %s.",
   NODATAMSG = "Не обнаружено данных.",
   CLEANUP_NONEMSG = "Старых настроек не обнаружено.",
   CLEANUP_WILLMSG = "Обнаружены старые настройки для |c#RED#%s|r: %s.",
   CLEANUP_DONEMSG = "Старые настройки удалены для |c#RED#%s|r: %s.",
   CLEANUP_NOOLDMSG = "Не обнаружено старых настроек у игрока |c#GREEN#%s|r.",
   NONEAVAILABLE_MSG = "Недоступно",
   UPDATEDB_MSG = "Обновлено название рыбы: %d.",

   MINIMUMSKILL = "Минимальный навык: %d",
   NOTLINKABLE = "<Создание ссылки невозможно>",
   CAUGHTTHISMANY = "Поймано:",
   CAUGHTTHISTOTAL = "Всего:",
   FISHTYPES = "Типы рыб: %d",
   CAUGHT_IN_ZONES = "Поймано в: %s",

   DASH = " -- ",
   FISHCAUGHT = "%d %s",
   TIMETOGO = "Начало Рыбомании через %d:%02d",
   TIMELEFT = "Конец Рыбомании через %d:%02d",
   FATLADYSINGS = "|c#RED#Окончание Рыбомании|r (осталось %d:%02d)",
   
   RIGGLE_BASSBAIT = "^Риггл Мормыш кричит: У нас есть победитель!s+(%a+)s+Лучший удильщик!",

   STVZONENAME = "Тернистая долина",

   TOOLTIP_HINT = "Cовет:",
   TOOLTIP_HINTSWITCH = "кликните, чтобы переключить набор снаряжения",
   TOOLTIP_HINTTOGGLE = "кликните, чтобы открыть окно #NAME#.",

   -- Key binding support
   BINDING_HEADER_FISHINGBUDDY_BINDINGS = "#NAME#",
   BINDING_NAME_FISHINGBUDDY_TOGGLE = "Переключение окна #NAME#",
   BINDING_NAME_FISHINGBUDDY_SWITCH = "Переключение наборов снаряжения",
   BINDING_NAME_FISHINGBUDDY_GOFISHING = "Экипироваться и начать рыбалку",

   BINDING_NAME_TOGGLEFISHINGBUDDY_LOC = "Переключение окна локаций #NAME#",
   BINDING_NAME_TOGGLEFISHINGBUDDY_OPT = "Переключение окна опций #NAME#",
};

FishingTranslations["ruRU"].SWITCH_HELP = {
      "|c#GREEN#/fb #SWITCH#|r",
      "    переключение между набора снаряжения (если доступны OutfitDisplayFrame или Outfitter)",
};
FishingTranslations["ruRU"].WATCHER_HELP = {
      "|c#GREEN#/fb #WATCHER#|r [|c#GREEN##WATCHER_LOCK#|r or |c#GREEN##WATCHER_UNLOCK#|r or |c#GREEN##RESET#|r]",
      "    unlock - разблокировать окно наблюдателя для его перемещения,",
      "    lock - блокировать, reset - установить позицию по-умолчанию",
};
FishingTranslations["ruRU"].CURRENT_HELP = {
   "|c#GREEN#/fb #CURRENT# #RESET#|r",
   "    Сбросить количество пойманной рыбы в этой сессии.",
};
FishingTranslations["ruRU"].UPDATEDB_HELP = {
   "|c#GREEN#/fb #UPDATEDB# [#FORCE#]|r",
   "    Попробовать найти названия рыб, которые ещё не известны #NAME#.",
   "    Во время поиска не проверяются 'редкие' рыбы, которые могут",
   "    привести к отключения от сервера -- используйте опцию '#FORCE#' для их принудительной проверки.",
};
FishingTranslations["ruRU"].CLEANUP_HELP = {
      "|c#GREEN#/fb #CLEANUP#|r [|c#GREEN##CHECK#|r or |c#GREEN##NOW#|r]",
      "    Очистка старых настроек. |c#GREEN##CHECK#|r - выдать список настроек,",
      "    которые будут удалены опцией |c#GREEN##NOW#|r.",
};
FishingTranslations["ruRU"].TIMERRESET_HELP = {
      "|c#GREEN#/fb #TIMER# #RESET#|r",
      "    Reset the location of the Extravaganza timer by moving it to",
      "    the middle of the screen.",
};
FishingTranslations["ruRU"].CASTHELP = {
      "|c#GREEN#/fb #CAST#|r",
      "    Scriptable cast, just like a double-click, usable from a macro.",
};

FishingTranslations["ruRU"].PRE_HELP = {
      "Вы можете использовать команды |c#GREEN#/fishingbuddy|r или |c#GREEN#/fb|r для всех команд.",
      "|c#GREEN#/fb|r: переключение главного окна Fishing Buddy",
      "|c#GREEN#/fb #HELP#|r: показать это сообщение",
};
FishingTranslations["ruRU"].POST_HELP = {
      "Вы можете назначить клавиши для аддона в окне \"Назначение клавиш\"",
};

