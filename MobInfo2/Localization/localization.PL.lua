-- 
-- Default English Localisation for MobInfo
--
-- created by Stephan Wilms 
--

MI2_SpellSchools = { Arcane="ar", Fire="fi", Frost="fr", Shadow="sh", Holy="ho", Nature="na" }

MI_TXT_WELCOME			= "Witamy w MobInfo"
MI_DESCRIPTION			= "adds information about mobs to the tooltip and adds health/mana info to the target frame"
MI_TXT_GENERAL_OPTIONS	= "This Options Page controls the main functions of the MobInfo AddOn. The other options pages allow configuring the details for each feature."

MI_TXT_GOLD   = " Gold"
MI_TXT_SILVER = " Silver"
MI_TXT_COPPER = " Copper"

MI_TXT_OPEN				= "Otworz"
MI_TXT_CLASS			= "Klasa "
MI_TXT_HEALTH			= "Zycie "
MI_TXT_MANA				= "Mana "
MI_TXT_XP				= "XP "
MI_TXT_KILLS			= "Zabitych "
MI_TXT_DAMAGE			= "Obrazenia + [DPS] "
MI_TXT_LOOTS		= "Ilosc zlootowan "
MI_TXT_EMPTY_LOOTS		= "Puste looty "
MI_TXT_TO_LEVEL			= "# do levela"
MI_TXT_QUALITY			= "Jakosc "
MI_TXT_CLOTH_DROP		= "Dropy clothow "
MI_TXT_COINS		= "Sredni drop "
MI_TXT_ITEMVAL		= "Srednia cena przedmiotow "
MI_TXT_MOBVAL		= "Total Mob Value "
MI_TXT_COMBINED			= "Combined: "
MI_TXT_MOB_DB_SIZE		= "Wielkosc bazy danych MobInfo:  "
MI_TXT_HEALTH_DB_SIZE	= "Wielkosc bazy danych o zyciu:  "
MI_TXT_PLAYER_DB_SIZE	= "Wielkosc bazy danych o zyciu graczy:  "
MI_TXT_ITEM_DB_SIZE		= "Wielkosc bazy danych o przdmiotach:  "
MI_TXT_CUR_TARGET		= "Aktualny cel:  "
MI_TXT_MH_DISABLED		= "MobInfo WARNING: Separate MobHealth AddOn found. The internal MobHealth functionality is disabled until the separate MobHealth AddOn is removed."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n You will NOT loose your data when disabling separate MobHealth.\n\nBenefits: movable health/mana display with percentage support and adjustable font and size")
MI_TXT_CLR_ALL_CONFIRM		= "Do you really want to perform the following delete operation: "
MI_TXT_SEARCH_LEVEL		= "Poziom Moba:"
MI_TXT_SEARCH_MOBTYPE		= "Typ Moba:"
MI_TXT_SEARCH_LOOTS		= "Zlootowanych:"
MI_TXT_TRIM_DOWN_CONFIRM	= "OSTRZEZENIE: jest to natychmiastowe i permanentne kasowanie. Czy naprawde chcesz skasowac wszystkie nagrane informacje o wybranych mobach?"
MI_TXT_CLAM_MEAT		= "Clam Meat"
MI_TXT_SHOWING			= "Lista pokazuje: "
MI_TXT_DROPPED_BY		= "Rzucony przez "
MI_TXT_LOCATION			= "Lokacja: "
MI_TXT_IMMUNE			= "Niewrazliwy:"
MI_TXT_RESIST			= "Odporny:"
MI_TXT_DEL_SEARCH_CONFIRM 	= "Czy naprawde chce skasowac moby %d w wynikach wyszukiwania z bazy danych Mobinfo ?"
MI_TXT_WRONG_LOC		= "ERROR : MobInfo database locale is incompatible with your WoW client locale. MobInfo database is unusable until fixed."
MI_TXT_WRONG_DBVER		= "ERROR : Your MobInfo database is too old and not compatible with this version of MobInfo.\n\nMobInfo must delete all your old Mob data."
MI_TXT_PRICE			= "Cena u vendora dla "
MI_TXT_TOOLTIP_MOVE		= "To move the tooltip anchor simply\nclick&drag it to a new location on screen"
MI_TXT_ITEMFILTER		= "Filtr przedmiotow"

MI2_CHAT_MOBRUNS	= "Ucieka !"
MI2_TXT_MOBRUNS = "*Ucieka*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG		= "Otworz opcje MobInfo"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "Zawartosc w okienku informacji o mobie"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Opcje ustawien o zyciu moba"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Opcje Bazy danych"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]	= "Wartosc zycia"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Wartosc many"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Opcje wyszukiwania"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Importuj zewnetrzna baze danych o mobach"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Opcje okienka przedmiotow"
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "MobInfo Tooltip Layout"

MI2_OPTIONS = {};

--------------------
-- General Options
--------------------
MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Record and Store Detailed Information About Mobs";
help = "This option enables or disabled the resording of detailed data\nabout the Mobs that you meet and kill in game. This data can be\nused to show mob details in the tooltip, or to search for Mobs\nusing the MobInfo search tool. The data also allows showing detailed\n'Dropped By' info for items.\n\nDisable this option if you do not want MobInfo to record and store\nMob data in the MobInfo database. Note that (only) the Mob health\ndata will always be calculated and stored, even when disabling this\noptions." }

MI2_OPTIONS["MI2_OptShowMobInfo"] = 
{ text = "Show Mob Information in the MobInfo Tooltip"; 
help = "Activates the showing of Mob information in the MobInfo Tooltip.\nUse the Tooltip options page to choose what information to show.\nDisable this option if you do not want to see Mob information\nor the MobInfo tooltip." }

MI2_OPTIONS["MI2_OptUseGameTT"] = 
{ text = "Instead of MobInfo-Tooltip use the Game-Tooltip"; 
help = "MobInfo features its very own optimally layouted movable tooltip window,\nwhich is used by default.\nActivating this option uses the Game-Tooltip\ninstead of the MobInfo tooltip window for showing the Mob information.\nThis will disable the MobInfo tooltip window." }

MI2_OPTIONS["MI2_OptShowItemInfo"] = 
{ text = "Show Additional Item Information in the Item Tooltip"; 
help = "Activates the showing of item information in the iem Tooltip.\nUse the Tooltip options page to choose what information to show.\nDisable this option if you do not want MobInfo to add anything\nto the item tooltip."; }

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
{ text = "Min"; help = "Minimalny poziom moba do wyszukiwania"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "Maksymalny poziom moba przy wyszukiwaniu (musi byc < 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normal"; help = "Uwzglednia normalny typ mobow przy wyszukiwaniu"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Elite"; help = "Uwzglednia Elity przy wyszukiwaniu"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Boss"; help = "uwzglednia Bossow przy wyszkiwaniu"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "Minimalna ilosc zlootowanych mobow danego typu przy wyszukiwaniu"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
{ text = "Max"; help = "Maximalna ilosc zlootowanych mobow danego typu przy wyszukiwaniu"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Mob"; help = "Czesciowa lub calkowita nazwa moba do wyszukania";
info = 'Pozostaw puste aby nie ograniczac wyszkiwan do konkretnych przedmiotow\nWpisanie "*" wybiera wszystkie przedmioty.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Przedmiot"; help = "Czesciowa lub pelna nazwa przedmiotow do wyszukiwania";
info = 'Pozostaw puste do wyszukania wszystkich typow przedmiotow'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Sortuj wg. zysku"; help = "Sortuj wyniki wyszukiwania w zaleznosci do zysku";
info = 'Sortuje moby w zaleznosci od zysku na danych mobach.'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Sortuj wg. ilosci przedmiotow"; help = "Sortuje liste w zaleznosci od ilosci itemkow";
info = 'Sortuje liste Mobow w zaleznosci od ilosci itemkow jakie dropuje dany mob.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] =
{ text = "Lista mobow w okienku"; help = "Pokazuje nazwy mobow ktore rzucaja dany przedmiot";
info = "Pokazuje liste wszystkich mobow wyrzucajacych zaznaczony przedmiot\nw tooltipie przedmiotow. Dla kazdego przedmiotu pokazana jest ilosc\nrzutow przez moba wraz z procentami." }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
{ text = "Pokaz cene u vendora"; help = "Pokazuje cene sprzedazy u vendora w tooltipe itemkow" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Zwiezle okienko"; help = "Uruchamia zwiezly sposob wyswietlania informacji, po dwie wartosci na linijke";
info = "Taki tryb wskazuje skroty od nazw dla opisow.\nAby wylaczyc linijke w tooltipie nalezy wylaczyc obie wartosci." }

MI2_OPTIONS["MI2_OptShowClass"] = 
{ text = "Klasa moba"; help = "Pokazuje informacje o klasie moba"; }

MI2_OPTIONS["MI2_OptShowHealth"] = 
{ text = "Zycie"; help = "Pokazuje informacje o zyciu moba (aktualnym/calkowitym)"; }

MI2_OPTIONS["MI2_OptShowMana"] = 
{ text = "Mana"; help = "Pokazuje mane/ragea/energie moba (calkowita/maksymalna)"; }

MI2_OPTIONS["MI2_OptShowXp"] = 
{ text = "XP"; help = "Pokazuje ilosc XP jaki daje mob przy zabiciu.";
info = "Jest to ilosc XP jaka dal mob przy ostatnim zabiciu.\n(Nie pokazuje przy mobach ktore sa dla Ciebie szare)" }

MI2_OPTIONS["MI2_OptShowNo2lev"] = 
{ text = "Liczba do Levela"; help = "Pokazuje ilosc mobow jaka musisz zabic do lvla";
info = "Ta opcja mowi o tym jaka ilosc tych samych mobow\nmusisz zabic zeby dostac lvla level\n(Nie pokazuje przy mobach ktore sa dla Ciebie szare)" }

MI2_OPTIONS["MI2_OptShowDamage"] = 
{ text = "Obazenia / DPS"; help = "Pokazuje zakres obrazen (Min/Max) oraz DPS moba"; 
info = "Zakres damageu i DPSu jest przeliczany i zapisywany oddzielnie dla kazdej postaci.\nWartosc wskazywanego DPSu jest usprawniana przy kazdym kolejnym zabiciu moba." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
{ text = "Polaczone informacje o mobach"; help = "Pokazuje polaczone informacje  tooltipie";
info = "Pokazuje informacje w tooltipie ze ten tryb\njest aktywny i wskazuje wszystkie levele mobow ktore zostaly zlaczone\nw jeden tooltip." }

MI2_OPTIONS["MI2_OptShowKills"] = 
{ text = "Zabitych"; help = "Pokazuje ile razy dany mob zostal zabity";
info = "Ilosc zabic jest przeliczana i zapisywana\nodzielnie dla kazdej postaci." }

MI2_OPTIONS["MI2_OptShowLoots"] = 
{ text = "Zlootowanych"; help = "Pokazuje ile razy danym mob zostal zlootowany"; }

MI2_OPTIONS["MI2_OptShowCloth"] = 
{ text = "Tkaniny"; help = "Pokazuje jak czesto danym mob wyrzucil tkaniny \n(czyli linen, silk, wool cloth etc.)"; }

MI2_OPTIONS["MI2_OptShowEmpty"] = 
{ text = "Puste looty"; help = "Pokazuje ile razy mob nic nie wyrzucil (liczba/procent)";
info = "Ta liczba jest zwiekszana z kazdym\nbrakiem dropa przy probie lootowania." }

MI2_OPTIONS["MI2_OptShowTotal"] = 
{ text = "Calkowia wartosc"; help = "Pokazuje calkowita wartosc moba";
info = "Jest to suma przecietnego dropu kasy oraz\nprzecietnej ceny itemkow." }

MI2_OPTIONS["MI2_OptShowCoin"] = 
{ text = "Kasa"; help = "Pokazuje srednia ilosc kasy rzucana przez moba";
info = "Calkowita wartosc kasy jest zlaczona i podzielona\nprzez krotnosc zlootowan.\n(nie pokazuje kiedy mob nie rzuca kasy)" }

MI2_OPTIONS["MI2_OptShowIV"] = 
{ text = "Cena przedmitow"; help = "Pokazuje srednia cene przedmiotow wyrzuconych przez moba";
info = "Calkowita wartosc przedmiotow jest dodana i podzielona\nprzez liczbe lootowania.\n(nie jest pokazywana gdy wartosc przedmiotu jest rowna 0)" }

MI2_OPTIONS["MI2_OptShowQuality"] = 
{ text = "Przeglad jakosci"; help = "Pokazuje jakosc lootu i jego udzial procentowy";
info = "Liczy ile przedmiotow z 5 kategorii\nrzucil dany mob. Kategorie z brakiem dropu\nnie sa pokazywane. Wartosc procentowa jest to srednia szansa\nna drop przedmiotu z kazdej kategorii." }

MI2_OPTIONS["MI2_OptShowLocation"] = 
{ text = "Miejsce moba"; help = "Pokazuje miejsce gdzie mozna znalezsc danego moba";
info = "Aby ta opcja zadzialala opcja 'nagrywanie lokacji' musi zostac WLACZONA."; }

MI2_OPTIONS["MI2_OptShowItems"] = 
{ text = "Podstawowa lista przedmiotow"; help = "Pokazuje nazwe i ilosc zlootowanych zwyklych przedmiotow";
info = "Dotyczy to wszystkich rodzajow przedmiotow z wyjatkiem szmat i skor.\nNagrywanie informacji o loocie musi byc WLACZONE aby ta opcja dzialala"; }

MI2_OPTIONS["MI2_OptShowClothSkin"] = 
{ text = "Loot szmat i skor"; help = "Pokazuje ilosc i nazwy zlootowanych szmat i skor";
info = "Nagrywanie informacji o loocie musi byc WLACZONE aby ta opcja dzialala"; }

MI2_OPTIONS["MI2_OptShowResists"] = 
{ text = "Odpornosci/Niewrazliwosci"; help = "Pokazuje odpornosci oraz niewrazliwosci jakie posiada mob";
info = "Nagrywa dane o rodzaju czarow moba,\nodpornosciach lub niewrazliwosciach." }

MI2_OPTIONS["MI2_OptShowLowHpAction"] = 
{ text = "Sygnalizator o uciekinierach"; help = "Pokazuje dodatkowa informacje o mobach ktore uciekaja gdy sa bliskie smierci";
info = "Wskaznikiem jest czerwony tekst ktory pokazywany jest\nw tooltipie tylko przy mobach ktore uciekaja." }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
{ text = "Lacz te same moby"; help = "Laczy informacje o mobach z ta sama nazwa";
info = "Tryb polaczony bedzie gromadzil dane o mobach\no tej samej nazwie ale roznych poziomach. Gdu uruchomione\nwskaznik jest pokazywany w tooltipie" }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
{ text = "Klawisz ALT dla MobInfo"; help = "Pokazuje informacje MobInfo tylko po nacisnieciu klawiszu ALT"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = ""; help = "Dodaje opcji filtracji dla przedmiotow pokazywanych w tooltipie";
info = "Pokazuje w tooltipie tylko przedmioty ktore zawieraja tekst filtru\nNp. wpisanie 'cloth' bedzie pokazywal tylko przedmioty\nzawierajace nazwe 'cloth'.\nPozostaw puste dla pokazania wszystkiego." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Zapisz informacje o HP gracza"; help = "Zapisuje infromacje o zyciu gracza podczas walk PvP.";
info = "Domyslnie informacje o zyciu i manie gracza sa usuwane po zakonczeniu walki.\nWlacznie tej opcji pozwala na zachowanie tych informacji." }

MI2_OPTIONS["MI2_OptAllOn"] = 
{ text = "Pokaz"; help = "Pokazuje wszystkie informacje wyswietlane o mobach"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
{ text = "Ukryj"; help = "Ukrywa wszystkie informacje wyswietlane o mobach"; }

MI2_OPTIONS["MI2_OptDefault"] = 
{ text = "Domyslne"; help = "Pokazuje domyslne ustawienia Mobinfo"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
{ text = "Zamknij"; help = "Zamyka opcje Mobinfo"; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
{ text = "Pokaz ilosc HP"; help = "Pokazuje wartosc liczbowa zycia w okienku celu"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
{ text = "Pokaz ilosc MP"; help = "Pokazuje wartosc liczbowa many w okienku celu"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
{ text = "Pokaz procenty"; help = "Dodaje procentowa ilosc zycia w okienku celu"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
{ text = "Pokaz procenty"; help = "Dodaje procentowa ilosc many w okienku celu"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
{ text = "Pozycja w poziomie"; help = "Ta opcja zmienia poziome umiejscowienie\ninformacji o zyciu i manie w oknie celu"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
{ text = "Pozycja w pionie"; help = "Ta opcja zmienia pionowe umiejscowienie\ninformacji o zyciu i manie w oknie celu"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
{ text = "Pozycja w poziomie"; help = "Ta opcja zmienia poziome umiejscowienie\ninformacji o manie w oknie celu"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
{ text = "Pozycja w pionie"; help = "Ta opcja zmienia pionowe umiejscowienie\ninformacji o manie w oknie celu"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
{ text = "Rodzaj czcionki"; help = "Ustawia czcionke dla wartosci liczbowych zycia/many w okienku celu";
choice1= "Czcionka liczb"; choice2="Czcionka gry"; choice3="Czcionka tekstu" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
{ text = "Wielkosc czcionki"; help = "Ustawia wielkosc czcionki ilosci zycia/many w okienku celu"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
{ text = "Kasuj dane o celu"; help = "Kasuje dane dla danego celu z bazy danych."; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Kasuj Baze danych"; help = "Kasuje calkowita zawartosc bazy danych o mobach."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Kasuj Baze danych"; help = "Kasuje calkowita zawartosc bazy danych o zyciu mobow."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Kasuj Baze danych"; help = "Kasuje calkowita zawartosc bazy danych o zyciu graczy."; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Zapamietuj jakosci przedmiotow:"; help = "Wlacz aby detale o loocie przedmiotow rzuconych przez moba byly zapisywane.";
info = "Mozesz wybrac ktory rodzaj (jakosc) przedmiotow ma byc zapisywany."; }

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Zapisz podstawowe informacje"; help = "Zapisuje podstawowy zestaw informacji o mobach.";
info = "Podstawowe informacje to: typ moba, liczniki dla: lootu, pustych lootow, clothow, kasy,\nwartosci przedmiotow, jakosci przedmiotow"; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Zapisz charakterystyczne informacje"; help = "Zapisuje wszystkie informacje o Mobach ktore sa unikatowe dla kazdej postaci.";
info = "Ta opcja wlaczy/wylaczy zapisywanie informacji o:\nliczbe zabic, min/max obrazenia, DPS, XP za Moba\n\nTe dane sa zapisywane oddzielnie dla kazdej postaci. Zapisywanie can\nmoze byc tylko wlaczone/wylaczone dla zestawien 4 wartosci"; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Zapisz informacje o Odpornosciach i Niewrazliwosciach"; help = "Zapisuje informacje o odpornosciach i niewrazliwosciach mobow na poszczegolne szkoly czarow.";
info = "Dla kazdej szkoly czarow, MobInfo zapamietuje ile czarow na szkole\ntrafilo a ile zostalo odpartych."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = ""; help = "Zapisuj szczegoly o zebranych przedmiotach dla wybranej jakosci.";
choice1 = "Szare i Lepsze"; choice2="Biale i Lepsze"; choice3="Zielone i Lepsze" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "Minimalizuj wielkosc bazy danych"; help = "Miminalizuje rozmiar bazy danych poprzez usuniecie nadmiarowych informacji.";
info = "Dane nadmiarowe sa to wszystkei dane ktore nie zostaly zaznaczone jako 'do nagrywania'."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Importuj"; help = "Importuje zewnetrzna baze danych o mobach do twojego komputera";
info = "WAZNE: prosze przeczytaj instrukcje o imporcie !\nZAWSZE zrob kopie zapasowa swojej bazy danych PRZED importem !"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "KASUJ"; help = "Kasuje wszysktie moby znajdujacych sie na liscie wyszukiwania z bazy danych.";
info = "OSTRZEZENIE: tej operacji nie mozna cofnac.\nProsze uzywac z rozsadkiem !\nPowinienes zrobic kopie zapasowa bazy danych przed jej oczyszczeniem."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Importuj tylko nieznane moby"; help = "Importuje tylko moby ktore nie istnieja w bazie danych";
info = "Uruchomienie tej opcji zapobiega przed modyfikacja juz istniejacych danych.\nTylko nieznane (np. nowe) Moby zostana zimportowane. To\npozwala importowac czesciowe bazy danych nakladajac je na na siebie nie powodujac\nlogicznych problemow."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Lista mobow"; help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Lista itemow"; help = ""; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] = 
{ text = "Tooltip"; help = "Ustaw ta opcje aby wyswietlac informacje o mobach w tooltipie"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] = 
{ text = "Zycie/Mana"; help = "Opcje do ustawiania zycia/many w okienkach celu"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] = 
{ text = "Baza danych"; help = "Opcje zarzadzania baza danych"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
{ text = "Szukaj"; help = "Szukanie w bazie danych"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
{ text = "General"; help = "General options for the MobInfo AddOn"; }

