-- 
-- German Localisation for MobInfo
--
-- created by Skeeve
--

if ( MI2_Locale == "deDE" ) then
--if ( false ) then

MI2_SpellSchools = { Arkan="ar", Feuer="fi", Frost="fr", Schatten="sh", Heilig="ho", Natur="na" }

MI_TXT_WELCOME			= "Wilkommen bei MobInfo"
MI_DESCRIPTION			= "Erweitert den Tooltip um Gegnerinformationen und erg\195\164nzt das Zielfenster um Gesundheit/Mana";
MI_TXT_GENERAL_OPTIONS	= "Diese Optionsseite steuert die Haupt-Funktionen von MobInfo. Auf den folgenden Optionsseiten k\195\182nnen die einzelnen Features im Detail konfiguriert werden."

MI_TXT_GOLD   = " Gold";
MI_TXT_SILVER = " Silber";
MI_TXT_COPPER = " Kupfer";

MI_TXT_OPEN				= "\195\150ffnen"
MI_TXT_COMBINED			= "Zusammengefasst: "
MI_TXT_MOB_DB_SIZE		= "MobInfo Datenbank Gr\195\182\195\159e:  "
MI_TXT_HEALTH_DB_SIZE	= "Mob HP Datenbank Gr\195\182\195\159e:  "
MI_TXT_PLAYER_DB_SIZE	= "Spieler HP Datenbank Gr\195\182\195\159e:  "
MI_TXT_ITEM_DB_SIZE		= "Gegenst\195\164nde Datenbank Gr\195\182\195\159e:  "
MI_TXT_CUR_TARGET		= "Aktuelles Ziel: "
MI_TXT_MH_DISABLED		= "MobInfo WARNUNG: Separates MobHealth AddOn gefunden. Die interne MobHealth Funktionalit\195\164t ist deaktiviert bis das separate MobHealth AddOn entfernt wird."
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\nEs gehen KEINE Daten verloren wenn das separate MobHealth deaktiviert wird.\n\nVorteile des Entfernens: Gesundheit und Mana Anzeige, optional mit Prozentangabe, Font und Gr\195\150\195\159e einstellbar.")
MI_TXT_CLR_ALL_CONFIRM	= "M\195\182chten Sie wirklich die folgende L\195\182schoperation durchf\195\188hren: "
MI_TXT_SEARCH_LEVEL		= "Mob Level:"
MI_TXT_SEARCH_MOBTYPE	= "Mob Typ:"
MI_TXT_SEARCH_LOOTS		= "Mob Looted:"
MI_TXT_TRIM_DOWN_CONFIRM = "ACHTUNG: Das L\195\182schen ist unwiederruflich. Wollen Sie wirklich alle nicht zum Speichern ausgew\195\164hlten Mob Daten l\195\182schen ?."
MI_TXT_CLAM_MEAT		= "uschelfleisch"
MI_TXT_SHOWING			= "Liste Zeigt: "
MI_TXT_DROPPED_BY		= "Beute von: "
MI_TXT_IMMUNE			= "Immun:"
MI_TXT_RESIST			= "Resistenz:"
MI_TXT_DEL_SEARCH_CONFIRM = "M\195\182chten Sie wirklich alle %d Mobs in der Suchergebnisliste aus der MobInfo Datenbank L\195\182SCHEN ?"
MI_TXT_WRONG_LOC		= "FEHLER : Lokalisierung (ie. Sprache) der MobInfo Datenbank ist inkompatibel mit dem WoW-Client. MobInfo Datenbank ist unbrauchbar und muss ersetzt werden."
MI_TXT_WRONG_DBVER		= "FEHLER : Die MobInfo Datenbank is zu alt f\195\188r diese Version von MobInfo\n\nMobInfo muss alle Deine alten Mob Daten l\195\182schen."
MI_TXT_PRICE			= "H\195\164ndler Preis f\195\188r "
MI_TXT_TOOLTIP_MOVE		= "Der Tooltip Anker kann durch einfaches\nClick&Ziehen an eine neue Position verschoben werden"
MI_TXT_ITEMFILTER		= "Item Filter"

MI2_CHAT_MOBRUNS = "versucht zu fl\195\188chten"
MI2_TXT_MOBRUNS = "*fl\195\188chtet*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG	= "MobInfo Optionen \195\150ffnen"

MI2_FRAME_TEXTS = {}
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "Mob Tooltip Inhalt"
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "MobHealth Optionen"
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Databank Optionen"
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Gesundheitswert"
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Manawert"
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Search Options"
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Externe MobInfo Datenbank Importieren"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Item Tooltip Optionen"
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "MobInfo Tooltip Layout"
MI2_FRAME_TEXTS["MI2_FrmLootList"]			= "Loot Items Options"

---------------------------
-- Tooltip Options/Content
---------------------------

MI_TXT_HEALTH		= "Leben"
MI_HLP_HEALTH		= "Lebenspunkte des Gegners (aktuell/max)"
MI_TXT_MANA			= "Mana"
MI_HLP_MANA			= "Mana / Energie / Wut des Gegners (aktuell/max)"
MI_TXT_KILLS		= "T\195\182ten"
MI_HLP_KILLS		= "Anzahl get\195\182tet wird pro Char separat gez\195\164hlt."
MI_TXT_LOOTS		= "Pl\195\188ndern"
MI_HLP_LOOTS		= "Wie oft Du diesen Gegner gepl\195\188ndert hast"
MI_TXT_COINS		= "W-Geld"
MI_HLP_COINS		= "Geldmenge die dieser Gegner im Mittel als Beute gibt\nDie Gesamtgeldbeute wird pro Gegner aufaddiert und\ndurch die Anzahl gepl\195\188ndert dividiert\n(wird nicht angezeigt wenn 0)"
MI_TXT_ITEMVAL		= "W-Items"
MI_HLP_ITEMVAL		= "Gemittelter Wert der Beute Gegenst\195\164nde dieses Gegners\nDer Wert aller Beute Gegenst\195\164nde wird pro Gegner \naufaddiert und durch die Anzahl gepl\195\188ndert dividiert\n(wird nicht angezeigt wenn 0)"
MI_TXT_MOBVAL		= "Wert"
MI_HLP_MOBVAL		= "Gemittelter Gesamtwert des Gegners (Geld+Gegenst\195\164nde)\nDies ist die Summe aus gemitteltem Geldwert und\n gemitteltem Gegenstandswert"
MI_TXT_XP			= "XP"
MI_HLP_XP			= "Die zuletzt vom Gegner erhaltenen Erfahrungspunkte\nEntspricht exakt den bei letzten Kill von diesem\nGegner erhaltenen Erfahrungspunkte\n(wird nicht f\195\188r graue Gegner angezeigt)"
MI_TXT_TO_LEVEL		= "# bis L"
MI_HLP_TO_LEVEL		= "Anzahl bis Level"; help = "Anzahl zu t\195\182tender Gegner bis Levelaufstieg\nZeigt, wie oft dieser Gegner get\195\182tet werden m\195\188sste,\num im Level aufzusteigen\n(wird nicht f\195\188r graue Gegner angezeigt)"
MI_TXT_EMPTY_LOOTS	= "Leer"
MI_HLP_EMPTY_LOOTS	= "Die leeren Loots f\195\188r diesen Gegner (Anzahl/Prozent)\nWird hochgez\195\164hlt wenn das Pl\195\188nderfenster des\nget\195\182teten Gegners leer ist"
MI_TXT_CLOTH_DROP	= "Stoff"
MI_HLP_CLOTH_DROP	= "Wie oft der Gegner Stoff als Beute gegeben hat"
MI_TXT_CLASS		= "Klasse"
MI_HLP_CLASS		= "Klasseninfo zum Gegner"
MI_TXT_DAMAGE		= "Schaden"
MI_HLP_DAMAGE		= "Schadensbereich des Gegner (Min/Max) und DPS (Damage Pro Sekunde)\nSchadensbereich und DPS werden pro Char separat berechnet.\nDPS langsam aber stetig mit jedem Kampf aktualisiert"
MI_TXT_QUALITY		= "Items"
MI_HLP_QUALITY		= "Qualit\195\164t der von diesem Gegner erhaltenen Gegenst\195\164nde\nZ\195\164hlt separat die erhaltenen Gegenst\195\164nde f\195\188r jede der\n5 Qualit\195\164tsstufen. Stufen ohne Gegenst\195\164nde werden nicht\nangezeigt. Die Prozentangabe entspricht der Wahrscheinlichkeit,\n als Loot einen Gegenstand der entsprechenden Kategorie zu erhalten"
MI_OPT_QUALITY		= "Loot Items Zusammenfassung"
MI_TXT_LOCATION		= "Ort"
MI_HELP_LOCATION	= "Ort anzeigen, an dem der Mob zuletzt gesehen wurde\nDie Speicherung von Mob Aufenthaltsorten MUSS aktiviert sein"
MI_TXT_LOWHEALTH	= "Warnen bei fl\195\188chtenden Mobs"
MI_HELP_LOWHEALTH	= "Warnen vor Mobs die bei niederiger Gesundheit fl\195\188chten\nDie Warnung besteht aus einer roten Meldung, die nur bei\nfl\195\188chtenden Mobs im Tooltip angezeigt wird"
MI_OPT_RESISTS		= "Resistenzen und Immunit\195\164ten"
MI_TXT_RESISTS		= "Resist"
MI_TXT_IMMUN		= "Immun"
MI_HELP_RESISTS		= "Zeigt im Tooltip Resistenzen und Immunit\195\164ten\nRecorded data about the Mobs elemental spell school\nresistances or immunities is added to the tooltip"
MI_TXT_ITEMLIST		= "Normale Loot Gegenst\195\164nde"
MI_HELP_ITEMLIST	= "Namen und Mengen der normalen Loot Gegenst\195\164nde anzeigen\nNormale Loot Gegenst\195\164nde sind alle Gegenst\195\164nde ausser Stoff und K\195\188rschnerei Loot.\nDie Speicherung von Loot Gegenst\195\164nde MUSS aktiviert sein"
MI_TXT_CLOTHSKIN	= "Stoff und K\195\188rschnerei Loot"
MI_HELP_CLOTHSKIN	= "Namen und Mengen zu Stoff und K\195\188rschnerei Loot anzeigen\nDie Speicherung von Loot Gegenst\195\164nde MUSS aktiviert sein"



--------------------
-- General Options
--------------------
MI2_OPTIONS = {};
    
MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Aufzeichnen und Speichern detailierter Mob Informationen";
help = "Diese Option Aktiviert oder Deaktiviert das Aufzeichnen detailierter\nInformationen \195\188ber alle Mobs, denen Ihr im Spiel begegnet, oder die\nIhr t\195\182tet. Diese Daten k\195\182nnen im Mob Tooltip angezeigt werden und\nerm\195\182glichen das gezielte Suchen nach Mobs. Ausserdem kann zu jedem\nLoot Item eine 'Wird gedroppt von' Liste generiert werden\n\nDeaktiviere diese Option wenn Du nicht m\195\182chtest, das MobInfo Daten zu\nMobs in seiner Datenbank speichert. Das Deaktivieren des Speicherns\nl\195\182scht nicht automatisch schon bestehenden Daten. Die Datenbank\nOptionsseite erm\195\182glicht das L\195\182schen der Datenbanken." }

MI2_OPTIONS["MI2_OptShowMobInfo"] = 
{ text = "Anzeigen von Mob Informationen im Tooltip"; 
help = "Aktiviert das Darstellen von Mob Informationen im MobInfo Tooltip.\nAuf der Tooltips Optionsseite kann im Detail eingestellt werden,\nwelche Informationen angezeigt werden sollen.\nDeaktiviere diese Option wenn Du Mob Informationen oder den\nMob Tooltip nicht sehen m\195\182chtest" }

MI2_OPTIONS["MI2_OptUseGameTT"] = 
{ text = "Anstelle des MobInfo-Tooltip verwende den Game-Tooltip"; 
help = "MobInfo beinhaltet ein eigenes optimiertes und frei platzierbares\nTooltip Fenster. Dies ist per default aktiv.\nAktivieren dieser Option verwendet statt dessen den WoW eignen Tooltip\nf\195\188r die Darstellung der Mob Informationen. Dies deaktiviert den MobInfo\neigenen Tooltip." }

MI2_OPTIONS["MI2_OptShowItemInfo"] = 
{ text = "Anzeigen zus\195\164tzlicher Item Informationen im Item Tooltip"; 
help = "Aktiviert das Anzeigen zus\195\164tzlicher Informationen im Item Tooltip.\nAuf der Tooltips Optionsseite kann im Detail eingestellt werden,\nwelche Informationen angezeigt werden sollen. Deaktiviere diese\nOption wenn Du nicht m\195\182chtest, das MobInfo dem Item Tooltip etwas\nhinzuf\195\188gt." }

MI2_OPTIONS["MI2_OptShowTargetInfo"] = 
{ text = "Zeigen Mob Infos im Zielportr\195\164t (HP/Mana/etc)"; 
help = "Zeige Informationen wie HP oder Mana Werte im Zielportr\195\164t.\n(funktioniert nur wenn kein sog. Unit-Frame AddOn installiert ist)\nWeitere Optionen befinden sich auf der 'Zielportr\195\164t' Optionsseite.\n\nDeaktiviere diese Option wenn Du nicht m\195\182chtest, dass MobInfo im\nZielportr\195\164t Informationen anzeigt." }

MI2_OPTIONS["MI2_OptShowMMButton"] = 
{ text = "Zeige Minimap Button"; 
help = "Aktiviert / Deaktiviert den MobInfo Minimap Button." }

MI2_OPTIONS["MI2_OptMMButtonPos"] = 
{ text = "Minimap Button Position"; 
help = "Verwende den Slider um die Position des MobInfo Minimap Button zu \195\164ndern." }


--------------------
-- Other Options
--------------------

MI2_OPTIONS["MI2_OptShowIGrey"] = 
{ text = ""; help = "Zeige graue (Plunder) Loot Items im Tooltip" }

MI2_OPTIONS["MI2_OptShowIWhite"] = 
{ text = ""; help = "Zeige weisse (gew\195\182hnliche) Loot Items im Tooltip" }

MI2_OPTIONS["MI2_OptShowIGreen"] = 
{ text = ""; help = "Zeige gr\195\188ne (ungew\195\182hnliche) Loot Items im Tooltip" }

MI2_OPTIONS["MI2_OptShowIBlue"] = 
{ text = ""; help = "Zeige blaue (seltene) Loot Items im Tooltip" }

MI2_OPTIONS["MI2_OptShowIPurple"] = 
{ text = ""; help = "Zeige lila (epische) Loot Items im Tooltip" }

MI2_OPTIONS["MI2_OptMouseTooltip"] = 
{ text = "Positioniere Tooltip bei Maus"; help = "Der MobInfo Tooltip erscheint automatisch an der Mauszeigerposition\nund bewegt sich zusammen mit der Maus." }

MI2_OPTIONS["MI2_OptHideAnchor"] = 
{ text = "Verberge Tooltip Anker"; help = "Verbirgt den kleinen 'MI' Tooltip Anker.\nDer Anker ist nur sichtbar, wenn diese Option deaktiviert ist\noder wenn das MobInfo Optionsfenster ge\195\182ffnet ist." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
{ text = "Zusammengefasst Info"; help = "Zusammengefasste Level im Tooltip anzeigen\nZeigt an, welche Mob Level zusammengefasst wurden.\nKann nur angezeigt werden wenn zusammenfassen aktiviert ist." }

MI2_OPTIONS["MI2_OptSmallFont"] = 
{ text = "Verwende kleineren Font"; help = "Verwende einen kleineren Font f\195\188r die Texte im Mob Tooltip" }

MI2_OPTIONS["MI2_OptTooltipMode"] = 
{ text = "Tooltip Position"; help = "Position der MobInfo Tooltip Informationen\nrelativ zum Tooltip Anker";
choice1="Rechts Oben"; choice2="Rechts Unten"; choice3="Links Oben"; choice4="Links Unten"; choice5="Mitte Oben"; choice6="Mitte Unten" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Zwei Spalten Tooltip"; help = "Zeigt die Mob Infos im Tooltip im kompakten 2 Spalten Layout.\nDer Tooltip wird dadurch etwas breiter, aber auch deutlich k\195\188rzer.\nDie Gesamtbreite ist begrenzt. Zu breite Informationen werden\neinzeilig dargestellt." }

MI2_OPTIONS["MI2_OptOtherTooltip"] =
{ text = "Verberge zweiten Tooltip"; help = "Verbirgt den zweiten Tooltip whenn Mob Informationen im\nMobInfo Tooltip angezeigt werden." }

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
{ text = "Min"; help = "Minimaler mob level f\195\188r Suche"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "Maximaler mob level f\195\188r Suche (muss < 66 sein)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normal"; help = "Normale Mobs in Suchergebnis aufnehmen"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Elite"; help = "Elite Mobs in Suchergebnis aufnehmen"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Boss"; help = "Boss Mobs in Suchergebnis aufnehmen"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "Minimale Anzahl gelooted f\195\188r Suche"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
{ text = "Max"; help = "Maximale Anzahl gelooted f\195\188r Suche"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Mob Name"; help = "teilweiser oder vollst\195\164ndiger Mob Name f\195\188r Suche";
info = 'Feld leer lassen um nicht nach Namen zu suchen'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Item Name"; help = "Teilweiser oder vollst\195\164ndiger Gegenstandsname f\195\188r Suche";
info = 'Feld leer lassen um Suche nicht auf Gegenst\195\164nden einzuschr\195\164nken.\n"*" eingeben um alle Gegenst\195\164nde auszuw\195\164hlen.'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Sortiere: Profit"; help = "Sortieren des Suchergebnis nach Mob Profit";
info = 'Sortiert die Mobs im Suchergebnis danach, welchen Profit sie abwerfen.'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Sortiere: Anzahl Items"; help = "Sortieren des Suchergebnis nach Anzahl Items";
info = 'Sortiert die Mobs im Suchergebnis danach, wieviele der angegebenen Items sie abwerfen.'; }

MI2_OPTIONS["MI2_OptItemTooltip"] = 
{ text = "Mobs im Item Tooltip auflisten"; help = "Im Tooltip zu Items die Mobs auflisten, die den Gegenstand droppen.";
info = "Aufgelistet wird jeweils der Name des Mobs und die Anzahl der Drops." }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
{ text = "Zeige H\195\164ndler Verkaufspreis"; help = "Zeige H\195\164ndler Verkaufspreis im Item Tooltip" }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
{ text = "Gleiche Mobs Zusammenfassen"; help = "Zusammenfassen der Daten f\195\188r Gegner gleichen Namens";
info = "Die Daten von Gegner die sich nur im Level unterscheiden\n werden kombiniert und gemeinsam angezeigt. Ein entsprechender\nHinweis erscheint im Tooltip." }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
{ text = "MobInfo nur wenn ALT gedr\195\188ckt"; help = "Gegnerinfo nur bei gedr\195\188ckter ALT Taste im Tooltip"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = ""; help = "Setzen des Filtertext f\195\188r Loot Item Anzeige in Tooltips.";
info = "Zeigt nur die Loot Items im Tooltip, deren Name den Filtertext\nenth\195\164lt. Wird z.B. 'Stoff' eingegeben so werden nur die\nLoot Items angezeigt, deren Name 'Stoff' enth\195\164lt.\nBei leerem Filtertext werden immer alle Loot Items angezeigt." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Gesundheitswerte von Spielern permanent speichern"; help = "Permanente Speicherung der Gesundheitswerte anderer Spieler aus PvP K\195\164mpfen";
info = "Normalerweise werden die Gesundheitswerte anderer Spieler nach Beendigugn einer\nSession gel\195\182scht. Diese Option aktiviert die permanente Speicherung dieser Daten." }

MI2_OPTIONS["MI2_OptAllOn"] = 
{ text = "Alles ein"; help = "Schaltet alle Tooltip Infos ein"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
{ text = "Alles Aus"; help = "Schaltet alle Tooltip Infos aus"; }

MI2_OPTIONS["MI2_OptDefault"] = 
{ text = "Default"; help = "Zeigt eine typische Auswahl n\195\188tzlicher Tooltip Infos"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
{ text = "Schlie\195\159en"; help = "MobInfo Optionsfenster schliessen";}

MI2_OPTIONS["MI2_OptTargetHealth"] = 
{ text = "Wert anzeigen"; help = "Anzeigen des Gesundheitswertes im Zielfenster"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
{ text = "Wert anzeigen"; help = "Anzeigen des Manawertes im Zielfenster"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
{ text = "Prozent anzeigen"; help = "Prozenzangabe zum Gesundheitswert hinzuf\195\188gen"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
{ text = "Prozent anzeigen"; help = "Prozenzangabe zum Manawert hinzuf\195\188gen"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
{ text = "Horizontale Position"; help = "Einstellen der horizontalen Position des Gesundheitswertes"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
{ text = "Vertikale Position"; help = "Einstellen der vertikalen Position des Gesundheitswertes"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
{ text = "Horizontale Position"; help = "Einstellen der horizontalen Position des Manawertes"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
{ text = "Vertikale Position"; help = "Einstellen der vertikalen Position des Manawertes"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
{ text = "Schriftart"; help = "Schriftart f\195\188r Darstellung des Gesundheits- und Manawertes";
	  choice1 = "NumberFont"; choice2 = "GameFont"; choice3 = "ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
{ text = "Schriftgr\195\182\195\159e"; help = "Schriftgr\195\182\195\159e f\195\188r Darstellung des Gesundheits- und Manawertes"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
{ text = "Ziel Daten L\195\182schen"; help = "Alle Daten zum aktuellen Ziel aus den Datenbanken l\195\182schen"; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Datenbank L\195\182schen"; help = "Inhalt der Mob Info Datenbank vollst\195\164ndig l\195\182schen"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Datenbank L\195\182schen"; help = "Inhalt der Mob HP Datenbank vollst\195\164ndig l\195\182schen"; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Datenbank L\195\182schen"; help = "Inhalt der Spieler HP Datenbank vollst\195\164ndig l\195\182schen"; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Daten zu Loot Gegenst\195\164nde speichern :"; help = "Speichern detailierte Daten zu den gelooteten Gegenst\195\164nde";
info = "Du kannst die Qualit\195\164t der zu speichernden Gegenst\195\164nde ausw\195\164hlen."; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Speichern aller Spielerbezogenen Mob Daten"; help = "Speichern aller auf die Spielfigur bezogenen Mob Daten.";
info = "Aktiviert die Speicherung der folgenden Daten:\nAnzahl get\195\182tet, min/max Schaden, DPS (Schaden pro Sekunde), Mob XP\n\nDiese Daten werden pro Spielfigur gespeichert und k\195\182nnen nur\ngemeinsam ein/ausgeschaltet werden."; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Speichern der Daten zu Resistenzen und Immunit\195\164ten"; help = "Speichert Daten zu den magischen Resistenzen und Immunit\195\164ten eines Mobs.";
info = "Separat pro Magieart wird gez\195\164hlt, wieviele Spells gegen das Monster\nerfolgreich waren und wievielen wiederstanden wurde."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = ""; help = "Speichern der Loot Details f\195\188r diese und Bessere Gegenst\195\164nde.";
choice1 = "Grau & Besser"; choice2 = "Weis & Besser"; choice3 = "Gr\195\188n & Besser";  }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "Mob Datenbank Minimieren"; help = "Minimiert die Gr\195\182\195\159e der Mob Datenbank durch L\195\182schen unn\195\182tiger Daten.";
info = "Als unn\195\182tige Daten gelten alle Mob Daten die nicht zum Speichern ausgew\195\164hlt sind."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Import Starten"; help = "Importieren einer externen Mob Datenbank in die eigene Mob Datenbank";
info = "WICHTIG: vorher die Anleitung zum Import lesen !\nVorher UNBEDINGT die eigene Datenbank sichern !"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "L\195\182SCHEN"; help = "L\195\182scht aller Mobs der Suchergebnisliste aus der MobInfo Datenbank";
info = "ACHTUNG: Diese Operation l\195\164sst sich nicht r\195\188ckg\195\164ngig machen.\nBitte mit Vorsich verwenden\nVor dem L\195\182\195\159schen empfiehlt sich ein Backup der MobInfo Datenbank"; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Nur neue Mobs Importieren"; help = "Importiere nur Mobs die es in der eigenen Datenbank noch nicht gibt";
info = "Durch aktivieren dieser Option wir verhindert, dass die Daten\nexistierender Mobs ver\195\164ndert werden. Nur unbekannte Mobs werden\nimportiert. Diese Option erm\195\182glicht das problemlose importieren\nvon teilweise gleichen Datenbanken."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Mob List"; help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Items List"; help = ""; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] = 
{ text = "Tooltips"; help = "Optionen die Umfang und Aussehen des ToolTips bestimmen."; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] = 
{ text = "Zielportr\195\164t"; help = "Optionen die Aussehen und Position der Gesundheits-\nund Manadarstellung im Zielfenster bestimmen"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] = 
{ text = "Datenbank"; help = "Datenbank Management Optionen"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
{ text = "Suchen"; help = "In der Mob Datenbank suchen"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
{ text = "Allgemein"; help = "Allgemeine MobInfo AddOn Optionen"; }

end
