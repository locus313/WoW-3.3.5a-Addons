-- Advanced Trade Skill Window v0.7.8
-- copyright 2006-2009 by Rene Schneider (Slarti on EU-Blackhand)

-- language file

-- German and English Language by myself
-- French Language by Nilyn (EU Dalaran Alliance Server)
-- Español por Jsr1976-Fili
-- zhCN and zhTW by Diablohu@è½»é£Žä¹‹è¯­ http://www.dreamgen.cn

ATSW_VERSION = "ATSW v0.7.8 - by Slarti on EU-Blackhand";

if(GetLocale()=="deDE") then
	ATSW_SORTBYHEADERS = "nach Kategorien sortieren";
	ATSW_SORTBYNAMES = "nach Namen sortieren";
	ATSW_SORTBYDIFFICULTY = "nach Schwierigkeit sortieren";
	ATSW_CUSTOMSORTING = "eigene Sortierung";
	ATSW_QUEUE = "Queue";
	ATSW_QUEUEALL = "Alle in Q";
	ATSW_DELETELETTER = "L";
	ATSW_STARTQUEUE = "Queue abarbeiten";
	ATSW_STOPQUEUE = "Abarbeitung stoppen";
	ATSW_DELETEQUEUE = "Queue leeren";
	ATSW_ITEMSMISSING1 = "Leider fehlen zur Herstellung von ";
	ATSW_ITEMSMISSING2 = " folgende Items:";
	ATSW_FILTERLABEL = "Filter:";
	ATSW_REAGENTLIST1 = "Zur Herstellung von 1x ";
	ATSW_REAGENTLIST2 = " werden folgende Reagenzien ben\195\182tigt:";
	ATSW_REAGENTFRAMETITLE = "Zur Abarbeitung der Queue werden folgende Reagenzien ben\195\182tigt:";
	ATSW_REAGENTBUTTON = "Reagenzien";
	ATSW_REAGENTFRAME_CH1 = "Inv.";
	ATSW_REAGENTFRAME_CH2 = "Bank";
	ATSW_REAGENTFRAME_CH3 = "Twink";
	ATSW_REAGENTFRAME_CH4 = "H\195\164ndler";
	ATSW_ALTLIST1 = "Die folgenden Twinks besitzen '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " im Inventar von ";
	ATSW_ALTLIST4 = " in der Bank von ";
	ATSW_OPTIONS_TITLE = "ATSW-Optionen";
	ATSWOFIB_TEXT = "Items in eigener Bank bei der Berechnung der\nherstellbaren Items ber\195\188cksichtigen";
	ATSW_OPTIONSBUTTON = "Optionen";
	ATSWOFUCB_TEXT = "Anzeige einer Gesamtzahl produzierbarer Items, die alles\nim Folgenden gew\195\164hlte ber\195\188cksichtigt";
	ATSWOFSCB_TEXT = "Anzeige von mit Inventarinhalt herstellbaren Items und einer\nGesamtzahl, die alles im Folgenden gew\195\164hlte ber\195\188cksichtigt";
	ATSWOFTB_TEXT = "Rezept-Tooltips anzeigen";
	ATSWOFIA_TEXT = "Items im Inventar und der Bank von Twinks bei der\nBerechnung der herstellbaren Items ber\195\188cksichtigen";
	ATSWOFIM_TEXT = "Bei H\195\164ndlern kaufbare Items bei der Berechnung\nder herstellbaren Items ber\195\188cksichtigen";
	ATSW_BUYREAGENTBUTTON = "Die m\195\182glichen Reagenzien bei aktuellem H\195\164ndler kaufen";
	ATSWOFAB_TEXT = "Beim Ansprechen eines H\195\164ndlers automatisch\nalles f\195\188r die Queue n\195\182tige einkaufen";
	ATSW_AUTOBUYMESSAGE = "ATSW hat automatisch folgende Items gekauft:";
	ATSW_TOOLTIP_PRODUCABLE = " hiervon sind mit dem aktuellen Inventarinhalt herstellbar"
	ATSW_TOOLTIP_NECESSARY = "Zur Herstellung eines Exemplars wird ben\195\182tigt:";
	ATSW_TOOLTIP_BUYABLE = " (k\195\164uflich)";
	ATSW_TOOLTIP_LEGEND = "(Items im Inventar / Items in Bank / Items auf Twinks)";
	ATSW_CONTINUEQUEUE = "Queue fortsetzen";
	ATSW_ABORTQUEUE = "Abbrechen";
	ATSWCF_TITLE = "Queue-Abarbeitung fortsetzen?";
	ATSWCF_TEXT = "Leider ist seit Patch 1.10 eine manuelle Eingabe n\195\182tig, um Items herstellen zu k\195\182nnen. Durch Klick auf 'Fortsetzen' lieferst du diese Eingabe und die Queue-Abarbeitung kann fortgesetzt werden.";
	ATSWCF_TITLE2 = "Als n\195\164chstes wird produziert:";
	ATSW_CSBUTTON = "editieren";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "Dieser H\195\164ndler verkauft n\195\182tige Reagenzien!";
	ATSW_AUTOBUYBUTTON_TEXT = "Reagenzien kaufen";
	ATSW_SHOPPINGLISTFRAMETITLE = "Einkaufsliste f\195\188r die derzeit in allen gespeicherten ATSW-Queues befindlichen Items:";
	ATSWOFSLB_TEXT = "Einkaufsliste im Auktionsfenster anzeigen";
	ATSW_ENCHANT = "Verzaubern";
	ATSW_ACTIVATIONMESSAGE = "ATSW wurde f\195\188r den aktuellen Tradeskill";
	ATSW_ACTIVATED = "aktiviert";
	ATSW_DEACTIVATED = "deaktiviert";
	ATSW_SCAN_MINLEVEL = "Ben\195\182tigt Stufe (%d+)";
	ATSW_QUEUESDELETED = "alle gespeicherten Queues wurden gel\195\182scht";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Klicke hier, um die Einkaufsliste zu verstecken. Klicke mit gedr\195\188ckter Shift-Taste, um alle ATSW-Queues zu l\195\182schen.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - Reagenzien f\195\188r Queue";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "Auf den folgenden Charakteren sind derzeit Items in der ATSW-Queue:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "keine Queues gefunden";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "auf ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "auf anderen Twinks";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "beim H\195\164ndler";
	ATSW_GETFROMBANK = "Reagenzien von Bank holen";
	ATSWOFRLB_TEXT = "Reagenzienliste in Bank automatisch \195\182ffnen wenn Queues\ngespeichert sind.";
	ATSWOFNRLB_TEXT = "Kompakte Rezeptlinks statt mehrzeiliger Links verwenden";

	atsw_blacklist = {
		[1] = "Leichtes Leder",
		[2] = "Mittleres Leder",
		[3] = "Schweres Leder",
		[4] = "Dickes Leder",
		[5] = "Unverw\195\188stliches Leder",
		[6] = "Knotenhautleder",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - Rezept-Sortierungs-Editor";
	ATSWCS_TRADESKILLISTTITLE = "unkategorisierte Rezepte";
	ATSWCS_CATEGORYLISTTITLE = "kategorisierte Rezepte";
	ATSWCS_ADDCATEGORY = "neue Kategorie";
	ATSWCS_NOTHINGINCATEGORY = "< Kategorie ist leer >";
	ATSWCS_UNCATEGORIZED = "unkategorisiert";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW-Rezeptscan";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW scannt nun deine Rezepte, um deren Daten vom Server in den lokalen Cache zu \195\188bertragen";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "initialisiere...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "\195\156berspringen";
	ATSW_SCAN_DELAY_FRAME_ABORT = "Abbrechen";

	ATSW_ONLYCREATABLE = "Material vorhanden";

elseif (GetLocale()=="frFR") then
	ATSW_SORTBYHEADERS = "Classer par Cat\195\169gories";
	ATSW_SORTBYNAMES = "Classer par noms";
	ATSW_SORTBYDIFFICULTY = "Classer par difficult\195\169es";
	ATSW_CUSTOMSORTING = "Classement perso";
	ATSW_QUEUE = "En file";
	ATSW_QUEUEALL = "Tous en file";
	ATSW_DELETELETTER = "X";
	ATSW_STARTQUEUE = "Lancer la file";
	ATSW_STOPQUEUE = "Stopper la file";
	ATSW_DELETEQUEUE = "Vider la file";
	ATSW_ITEMSMISSING1 = "Vous avez besoin des objets suivants pour produire ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "Filtre:";
	ATSW_REAGENTLIST1 = "Pour produire 1x ";
	ATSW_REAGENTLIST2 = " les composants suivants sont n\195\169cessaires:";
	ATSW_REAGENTFRAMETITLE = "Les Composants suivants sont n\195\169cessaires pour produire la file:";
	ATSW_REAGENTBUTTON = "Composant";
	ATSW_REAGENTFRAME_CH1 = "Inv.";
	ATSW_REAGENTFRAME_CH2 = "Banque";
	ATSW_REAGENTFRAME_CH3 = "Alts";
	ATSW_REAGENTFRAME_CH4 = "Marchand";
	ATSW_ALTLIST1 = "Vos alts suivants possedent:";
	ATSW_ALTLIST2 = ":";
	ATSW_ALTLIST3 = " dans l'inventaire de ";
	ATSW_ALTLIST4 = " dans la banque de ";
	ATSW_OPTIONS_TITLE = "Options ATSW";
	ATSWOFIB_TEXT = "Consid\195\169rer les Composants de votre banque dans le calcul\nde votre production maximale";
	ATSWOFIA_TEXT = "Consid\195\169rer les composants presents dans l'inventaire et\nbanque de vos alts dans le calcul de votre\nproduction maximale";
	ATSWOFIM_TEXT = "Consid\195\169rer les composants achetablent aux marchands dans\nle calcul de votre production maximale";
	ATSWOFUCB_TEXT = "Afficher un total unique des objets produisables suivant les\noptions ci dessous";
	ATSWOFSCB_TEXT = "Afficher un 1er total des objets produisables suivant les\ncomposants de votre inventaire et un autre\ntotal suivant les options ci dessous";
	ATSWOFTB_TEXT = "Activer la bulle d'info au passage de la sourie";
	ATSW_OPTIONSBUTTON = "Options";
	ATSW_BUYREAGENTBUTTON = "Acheter les composants depuis le marchand actuellement selectionn\195\169";
	ATSWOFAB_TEXT = "Acheter automatiquement les composants n\195\169cessaires\npour la file d'attente en cours en parlant aux marchands";
	ATSW_AUTOBUYMESSAGE = "ATSW a automatiquement achet\195\169 les articles suivants:";
	ATSW_TOOLTIP_PRODUCABLE = " Peuvent etre produit depuis les composants de votre inventaire";
	ATSW_TOOLTIP_NECESSARY = "Pour en produire un, les composants suivants sont n\195\169cessaires:";
	ATSW_TOOLTIP_BUYABLE = " (Achetable)";
	ATSW_TOOLTIP_LEGEND = "(Objet dans l'inventaire / dans la banque / sur les alts)";
	ATSW_CONTINUEQUEUE = "Continuer";
	ATSW_ABORTQUEUE = "Arreter";
	ATSWCF_TITLE = "Continuer la file en cours?";
	ATSWCF_TEXT = "Depuis la maj 1.10, un clic sur un bouton est n\195\169cessaire pour pouvoir produire des articles. En cliquant sur 'Continuer', vous assurez cette action et le traitement de file d'attente peut continuer.";
	ATSWCF_TITLE2 = "L'objet suivant dans la file d'attente est:";
	ATSW_CSBUTTON = "Editer";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "Ce Marchant vend les composants que vous avez besoin!";
	ATSW_AUTOBUYBUTTON_TEXT = "Acheter les Composants";
	ATSW_SHOPPINGLISTFRAMETITLE = "Liste d'achat pour vos cr\195\168ations :";
	ATSWOFSLB_TEXT = "Afficher la liste d'achat dans l'hotel de vente";
	ATSW_ENCHANT = "Enchantement";
	ATSW_ACTIVATIONMESSAGE = "ATSW Activ\195\168";
	ATSW_ACTIVATED = "Activer pour ce m\195\168tier";
	ATSW_DEACTIVATED = "D\195\168activer pour ce m\195\168tier";
	ATSW_SCAN_MINLEVEL = "Niveau (%d+) requis";
	ATSW_QUEUESDELETED = "Liste d'attente \195\168ffacer";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - Composant pour la liste d'attente";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "Le personnage suivant a une liste d'attente:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "Pas de liste d'attente";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "sur ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "sur autre personnage";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "au marchant";
	ATSW_GETFROMBANK = "Obtenir composant de la banque";
	ATSWOFRLB_TEXT = "Ouvrir automatiquement la liste de composant a la banque\ns'il y a les files d'attente sauv\195\168es sur un quelconque\nde vos personnages.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "Cuir l\195\169ger",
		[2] = "Cuir moyen",
		[3] = "Cuir lourd",
		[4] = "Cuir \195\169pais",
		[5] = "Cuir robuste",
		[6] = "Cuir granuleux",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - Editeur de Classement personnel";
	ATSWCS_TRADESKILLISTTITLE = "Recettes non class\195\169es";
	ATSWCS_CATEGORYLISTTITLE = "Recettes class\195\169es";
	ATSWCS_ADDCATEGORY = "Nouvelle Cat\195\169gorie";
	ATSWCS_NOTHINGINCATEGORY = "< Vide >";
	ATSWCS_UNCATEGORIZED = "Non Class\195\169";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW Cherche des Recettes";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW scanne le serveur pour maj votre BDD de recette";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "Initialisation...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "Passer";
	ATSW_SCAN_DELAY_FRAME_ABORT = "Annuler";

elseif(GetLocale()=="esES") then
	ATSW_SORTBYHEADERS = "Por Categorias";
	ATSW_SORTBYNAMES = "Por Nombres";
	ATSW_SORTBYDIFFICULTY = "Por Dificultad";
	ATSW_CUSTOMSORTING = "Personalizado";
	ATSW_QUEUE = "Cola";
	ATSW_QUEUEALL = "Todo a Cola";
	ATSW_DELETELETTER = "B";
	ATSW_STARTQUEUE = "Procesa Cola";
	ATSW_STOPQUEUE = "Parar Proceso";
	ATSW_DELETEQUEUE = "Vacia Cola";
	ATSW_ITEMSMISSING1 = "Necesitas los siguientes ingredientes para producir ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "Filtro:";
	ATSW_REAGENTLIST1 = "Para producir 1x ";
	ATSW_REAGENTLIST2 = " hacen falta los siguientes ingredientes:";
	ATSW_REAGENTFRAMETITLE = "The following reagents are needed to process the queue:";
	ATSW_REAGENTBUTTON = "Ingredientes";
	ATSW_REAGENTFRAME_CH1 = "Inv.";
	ATSW_REAGENTFRAME_CH2 = "Banco";
	ATSW_REAGENTFRAME_CH3 = "Alt";
	ATSW_REAGENTFRAME_CH4 = "Mercader";
	ATSW_ALTLIST1 = "Los siguientes alts poseen '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " en el inventario de ";
	ATSW_ALTLIST4 = " en el banco de ";
	ATSW_OPTIONS_TITLE = "ATSW Optcones";
	ATSWOFIB_TEXT = "Consideramos objetos en el banco a todos aquellos que calculando\nsu n\195\186mero producen otros";
	ATSWOFIA_TEXT = "Consideramos objetos en tu inventario y banco de tus\npersonajes alternativos a aquellos que calculando su\nn\195\186mero producen otros";
	ATSWOFIM_TEXT = "Consideramos objetos adquiriblesa aquellos que calculando su\nn\195\186mero producen otros";
	ATSWOFUCB_TEXT = "Muestra solamente una cuenta total de objetos produciblesconsiderando\nlas siguientes opciones";
	ATSWOFSCB_TEXT = "Muestra el n\195\186mero de objetos producibles con contenidos del inv.\ny el n\195\186 creable considerando las siguientes opciones";
	ATSWOFTB_TEXT = "Activa Cuadro de di\195\161logo de recetas";
	ATSW_OPTIONSBUTTON = "Opciones";
	ATSW_BUYREAGENTBUTTON = "Compra ingredientes del mercader seleccionado";
	ATSWOFAB_TEXT = "Automaticamente compra to lo posible u necesario\npara la cola actual cuando hables con vendedores";
	ATSW_AUTOBUYMESSAGE = "ATSW ha comprado automaticamente los siguientes objetos:";
	ATSW_TOOLTIP_PRODUCABLE = " puede ser producido con los ingredientes del inventario"
	ATSW_TOOLTIP_NECESSARY = "PAra producir uno de estos, se necesitan los siguientes ingredientes:";
	ATSW_TOOLTIP_BUYABLE = " (adquirible)";
	ATSW_TOOLTIP_LEGEND = "(obj. en inventario / obj. en banco / obj. en alts)";
	ATSW_CONTINUEQUEUE = "Continua";
	ATSW_ABORTQUEUE = "Aborta";
	ATSWCF_TITLE = "Continua procesando cola?";
	ATSWCF_TEXT = "DEsde el parche, es necesario pulsar un bo\195\179n para poder producir objetos. Pinchando en 'Continua', haces esta acci\195\179n y el proceso de la cola puede continuar.";
	ATSWCF_TITLE2 = "El siguiente objeto en la cola es:";
	ATSW_CSBUTTON = "Edita";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "Este mercader vende ingredientes que necesitas!";
	ATSW_AUTOBUYBUTTON_TEXT = "Compra Ingredientes";
	ATSW_SHOPPINGLISTFRAMETITLE = "Lista de compra que necesitas para producir los objetos de la cola:";
	ATSWOFSLB_TEXT = "Mustra la lista de la compra en Casa de Subastas";
	ATSW_ENCHANT = "Encantamiento";
	ATSW_ACTIVATIONMESSAGE = "ATSW ha sido";
	ATSW_ACTIVATED = "activado para la siguiente habilidad comercial";
	ATSW_DEACTIVATED = "desactivado para la siguiente habilidad comercial";
	ATSW_SCAN_MINLEVEL = "^Requiere Nivel (%d+)";
	ATSW_QUEUESDELETED = "all saved queues have been deleted";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - Reagents for queues";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "The following characters currently have queued items:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "no queues found";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "on ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "on other alts";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "at the merchant";
	ATSW_GETFROMBANK = "Get reagents from bank";
	ATSWOFRLB_TEXT = "Automatically open reagent list in bank if there are\nsaved queues on any of your characters.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "Cuero Ligero",
		[2] = "Cuero Medio",
		[3] = "Cuero Pesado",
		[4] = "Cuero Grueso",
		[5] = "Cuero Rugoso",
		[6] = "Cuero de pellejo nudoso",
	};

	ATSWCS_TITLE = "Edito de Clasificaci\195\179n de Recetas de ATSW";
	ATSWCS_TRADESKILLISTTITLE = "Sin Categoria";
	ATSWCS_CATEGORYLISTTITLE = "Con Categoria";
	ATSWCS_ADDCATEGORY = "Nueva Categoria";
	ATSWCS_NOTHINGINCATEGORY = "< vacio >";
	ATSWCS_UNCATEGORIZED = "Sin Categoria";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW recipe scan";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW is now scanning your recipes to get them from the server into your local cache";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "initializing...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "Skip this";
	ATSW_SCAN_DELAY_FRAME_ABORT = "Abort";

	ATSW_ONLYCREATABLE = "materials available";

elseif (GetLocale()=="zhCN") then
-- by Diablohu@è½»é£Žä¹‹è¯­
-- http://www.dreamgen.cn
	ATSW_SORTBYHEADERS = "æŒ‰åˆ†ç±»æŽ’åº";
	ATSW_SORTBYNAMES = "æŒ‰åç§°æŽ’åº";
	ATSW_SORTBYDIFFICULTY = "æŒ‰åˆ¶ä½œéš¾åº¦æŽ’åº";
	ATSW_CUSTOMSORTING = "æŒ‰è‡ªå®šä¹‰åˆ†ç±»";
	ATSW_QUEUE = "åˆ—é˜Ÿ";
	ATSW_QUEUEALL = "åˆ—é˜Ÿæ‰€æœ‰";
	ATSW_DELETELETTER = "åˆ ";
	ATSW_STARTQUEUE = "å¼€å§‹åˆ¶é€ ";
	ATSW_STOPQUEUE = "åœæ­¢åˆ¶é€ ";
	ATSW_DELETEQUEUE = "æ¸…ç©ºé˜Ÿåˆ—";
	ATSW_ITEMSMISSING1 = "åˆ¶é€ ";
	ATSW_ITEMSMISSING2 = "ç¼ºå°‘çš„ææ–™ï¼š";
	ATSW_FILTERLABEL = "æœç´¢:";
	ATSW_REAGENTLIST1 = "åˆ¶é€ ";
	ATSW_REAGENTLIST2 = "æ‰€éœ€ææ–™ï¼š";
	ATSW_REAGENTFRAMETITLE = "åˆ¶é€ é˜Ÿåˆ—ä¸­ç‰©å“æ‰€éœ€ææ–™";
	ATSW_REAGENTBUTTON = "ææ–™";
	ATSW_REAGENTFRAME_CH1 = "èƒŒåŒ…";
	ATSW_REAGENTFRAME_CH2 = "é“¶è¡Œ";
	ATSW_REAGENTFRAME_CH3 = "å¦è§’è‰²";
	ATSW_REAGENTFRAME_CH4 = "å¯è´­ä¹°";
	ATSW_ALTLIST1 = "ä»¥ä¸‹è§’è‰²æ‹¥æœ‰'";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " (èƒŒåŒ…) ";
	ATSW_ALTLIST4 = " (é“¶è¡Œ) ";
	ATSW_OPTIONS_TITLE = "ATSW è®¾ç½®";
	ATSWOFIB_TEXT = "è€ƒè™‘é“¶è¡Œä¸­çš„ææ–™";
	ATSWOFIA_TEXT = "è€ƒè™‘å…¶ä»–è§’è‰²ä¸ŠèƒŒåŒ…å’Œé“¶è¡Œä¸­çš„ææ–™";
	ATSWOFIM_TEXT = "è€ƒè™‘å¯è´­ä¹°çš„ææ–™";
	ATSWOFUCB_TEXT = "æ˜¾ç¤ºé‡‡ç”¨ä»¥ä¸‹è®¾ç½®çš„å¯åˆ¶é€ æ•°";
	ATSWOFSCB_TEXT = "æ˜¾ç¤ºç”±èƒŒåŒ…ä¸­çš„åŽŸæ–™å¯åˆ¶é€ æ•°å’Œé‡‡ç”¨ä»¥ä¸‹è®¾ç½®\nçš„å¯åˆ¶é€ æ•°";
	ATSWOFTB_TEXT = "å¼€å¯é…æ–¹è¯´æ˜Ž";
	ATSW_OPTIONSBUTTON = "è®¾ç½®";
	ATSW_BUYREAGENTBUTTON = "ä»Žå½“å‰å•†äººå¤„è´­ä¹°ææ–™";
	ATSWOFAB_TEXT = "å½“ä¸Žå•†äººå¯¹è¯æ—¶è‡ªåŠ¨è´­ä¹°æ‰€éœ€ææ–™";
	ATSW_AUTOBUYMESSAGE = "ATSW å·²è‡ªåŠ¨è´­ä¹°å¦‚ä¸‹ç‰©å“:";
	ATSW_TOOLTIP_PRODUCABLE = "ä¸ªå¯ç”±èƒŒåŒ…ä¸­çš„ææ–™åˆ¶é€ "
	ATSW_TOOLTIP_NECESSARY = "åˆ¶ä½œ1ä»¶æ­¤ç‰©å“æ‰€éœ€ææ–™:";
	ATSW_TOOLTIP_BUYABLE = " (å¯è´­ä¹°)";
	ATSW_TOOLTIP_LEGEND = "(èƒŒåŒ…ä¸­çš„æ•°é‡ / é“¶è¡Œä¸­çš„æ•°é‡ / å…¶ä»–è§’è‰²ä¸Šçš„æ•°é‡)";
	ATSW_CONTINUEQUEUE = "ç»§ç»­åˆ¶é€ ";
	ATSW_ABORTQUEUE = "åœæ­¢åˆ¶é€ ";
	ATSWCF_TITLE = "æ˜¯å¦ç»§ç»­ï¼Ÿ";
	ATSWCF_TEXT = "1.10ç‰ˆæœ¬åŽï¼Œåˆ¶ä½œç‰©å“éœ€è¦ä¸€æ¬¡é¼ æ ‡ç‚¹å‡»ã€‚å•å‡»â€œç¡®å®šâ€ä»¥ç»§ç»­ã€‚";
	ATSWCF_TITLE2 = "é˜Ÿåˆ—ä¸­ä¸‹ä¸€ä»¶ç‰©å“ä¸º:";
	ATSW_CSBUTTON = "ç¼–è¾‘åˆ†ç±»";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "è¯¥å•†äººå‡ºå”®ä½ æ‰€éœ€çš„ææ–™ï¼";
	ATSW_AUTOBUYBUTTON_TEXT = "è´­ä¹°ææ–™";
	ATSW_SHOPPINGLISTFRAMETITLE = "è´­ç‰©æ¸…å• - åˆ¶ä½œé˜Ÿåˆ—ä¸­ç‰©å“æ‰€ç¼ºå°‘çš„ææ–™";
	ATSWOFSLB_TEXT = "åœ¨æ‹å–è¡Œä¸­æ˜¾ç¤ºè´­ç‰©æ¸…å•";
	ATSW_ENCHANT = "é™„é­”";
	ATSW_ACTIVATIONMESSAGE = "ATSW å·²";
	ATSW_ACTIVATED = "é’ˆå¯¹å½“å‰å•†ä¸šæŠ€èƒ½å¼€å¯";
	ATSW_DEACTIVATED = "é’ˆå¯¹å½“å‰å•†ä¸šæŠ€èƒ½å…³é—­";
	ATSW_SCAN_MINLEVEL = "^éœ€è¦ç­‰çº§ (%d+)";
	ATSW_QUEUESDELETED = "å·²æ¸…ç©ºæ‰€æœ‰é˜Ÿåˆ—";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - ææ–™è¡¨";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "ä»¥ä¸‹è§’è‰²ç›®å‰æ‹¥æœ‰éœ€è¦çš„ææ–™ï¼š";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "æ— é˜Ÿåˆ—";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "åœ¨ ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "åœ¨å…¶ä»–è§’è‰²";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "å¯è´­ä¹°";
	ATSW_GETFROMBANK = "ä»Žé“¶è¡Œä¸­å–å‡ºææ–™";
	ATSWOFRLB_TEXT = "å¦‚æžœä»»æ„è§’è‰²çš„åˆ¶é€ é˜Ÿåˆ—ä¸­å­˜æœ‰é˜Ÿåˆ—ï¼Œåœ¨è®¿é—®é“¶è¡Œæ—¶è‡ªåŠ¨\næ‰“å¼€ææ–™åˆ—è¡¨ã€‚";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "è½»çš®",
		[2] = "ä¸­çš®",
		[3] = "é‡çš®",
		[4] = "åŽšçš®",
		[5] = "ç¡¬ç”²çš®",
		[6] = "å¢ƒå¤–çš®",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - è‡ªå®šä¹‰åˆ†ç±»ç¼–è¾‘å™¨";
	ATSWCS_TRADESKILLISTTITLE = "æœªåˆ†ç±»";
	ATSWCS_CATEGORYLISTTITLE = "å·²åˆ†ç±»";
	ATSWCS_ADDCATEGORY = "æ–°å»ºåˆ†ç±»";
	ATSWCS_NOTHINGINCATEGORY = "< ç©º >";
	ATSWCS_UNCATEGORIZED = "æœªåˆ†ç±»";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW é…æ–¹æ‰«æ";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW æ­£åœ¨æ‰«ææ‚¨çš„é…æ–¹ä»¥å°†å…¶ä»ŽæœåŠ¡å™¨ä¿å­˜å…¥æœ¬åœ°ç¼“å­˜ä¸­";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "åˆå§‹åŒ–...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "è·³è¿‡";
	ATSW_SCAN_DELAY_FRAME_ABORT = "åœæ­¢";

	ATSW_ONLYCREATABLE = "materials available";

elseif (GetLocale()=="zhTW") then
-- æœˆé‡Žå…”@èªžé¢¨
	ATSW_SORTBYHEADERS = "æŒ‰ç…§åˆ†é¡žæŽ’åº";
	ATSW_SORTBYNAMES = "æŒ‰ç…§åå­—æŽ’åº";
	ATSW_SORTBYDIFFICULTY = "æŒ‰ç…§é›£åº¦æŽ’åº";
	ATSW_CUSTOMSORTING = "è‡ªè¨‚æŽ’åº";
	ATSW_QUEUE = "æŽ’ç¨‹";
	ATSW_QUEUEALL = "å…¨éƒ¨æŽ’ç¨‹";
	ATSW_DELETELETTER = "åˆª";
	ATSW_STARTQUEUE = "è™•ç†æŽ’ç¨‹";
	ATSW_STOPQUEUE = "åœæ­¢è™•ç†";
	ATSW_DELETEQUEUE = "æ¸…é™¤æŽ’ç¨‹";
	ATSW_ITEMSMISSING1 = "éœ€è¦ä¸‹åˆ—ç‰©å“æ‰èƒ½è£½ä½œ ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "éŽæ¿¾:";
	ATSW_REAGENTLIST1 = "ç‚ºäº†è£½ä½œ 1x ";
	ATSW_REAGENTLIST2 = " éœ€è¦ä¸‹åˆ—ææ–™:";
	ATSW_REAGENTFRAMETITLE = "éœ€è¦ä¸‹åˆ—ææ–™æ‰èƒ½è™•ç†æŽ’ç¨‹:";
	ATSW_REAGENTBUTTON = "ææ–™";
	ATSW_REAGENTFRAME_CH1 = "åŒ…åŒ…";
	ATSW_REAGENTFRAME_CH2 = "éŠ€è¡Œ";
	ATSW_REAGENTFRAME_CH3 = "å…¶ä»–è§’è‰²";
	ATSW_REAGENTFRAME_CH4 = "å•†äºº";
	ATSW_ALTLIST1 = "ä»¥ä¸‹è§’è‰²æ“æœ‰ '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " æ­¤è§’è‰²çš„åŒ…åŒ… ";
	ATSW_ALTLIST4 = " æ­¤è§’è‰²çš„éŠ€è¡Œ ";
	ATSW_OPTIONS_TITLE = "ATSW é¸é …";
	ATSWOFIB_TEXT = "è¨ˆç®—å¯è£½ä½œçš„ç‰©å“æ•¸é‡æ™‚\nå°‡ä½ éŠ€è¡Œè£¡çš„ç‰©å“ç´å…¥è€ƒæ…®";
	ATSWOFIA_TEXT = "è¨ˆç®—å¯è£½ä½œçš„ç‰©å“æ•¸é‡æ™‚\nå°‡ä½ å…¶ä»–è§’è‰²çš„éŠ€è¡Œå’ŒåŒ…åŒ…è£¡çš„ç‰©å“ç´å…¥è€ƒæ…®";
	ATSWOFIM_TEXT = "è¨ˆç®—å¯è£½ä½œçš„ç‰©å“æ•¸é‡æ™‚\nå°‡å¯å¾žå•†åº—è³¼è²·çš„ç‰©å“ç´å…¥è€ƒæ…®";
	ATSWOFUCB_TEXT = "åªé¡¯ç¤ºç¸½å…±å¯è£½ä½œçš„ç‰©å“çš„æ•¸é‡,\næŒ‰ç…§ä¸‹åˆ—è¦å‰‡";
	ATSWOFSCB_TEXT = "é¡¯ç¤ºåŒ…åŒ…è£¡ç¾æœ‰ææ–™å¯è£½ä½œçš„ç‰©å“çš„æ•¸é‡,\nå†æŒ‰ç…§ä¸‹åˆ—è¦å‰‡é¡¯ç¤ºå¦ä¸€å€‹æ•¸é‡";
	ATSWOFTB_TEXT = "é–‹å•Ÿé…æ–¹å°æç¤º";
	ATSW_OPTIONSBUTTON = "é¸é …";
	ATSW_BUYREAGENTBUTTON = "å‘ç›®å‰é¸ä¸­çš„å•†äººè³¼è²·ææ–™";
	ATSWOFAB_TEXT = "å°å•†äººèªªè©±æ™‚,\nè‡ªå‹•å‘å•†äººè³¼è²·å¯ä»¥è²·åˆ°çš„æž—æ–™";
	ATSW_AUTOBUYMESSAGE = "ATSW å·²ç¶“è‡ªå‹•è³¼è²·äº†ä¸‹åˆ—ç‰©å“:";
	ATSW_TOOLTIP_PRODUCABLE = "å¯åˆ©ç”¨åŒ…åŒ…è£¡ç¾æœ‰çš„ææ–™è£½ä½œçš„æ•¸é‡: "
	ATSW_TOOLTIP_NECESSARY = "æƒ³è£½ä½œçš„è©±, éœ€è¦ä»¥ä¸‹ææ–™:";
	ATSW_TOOLTIP_BUYABLE = " (å¯ä»¥ç”¨è²·çš„)";
	ATSW_TOOLTIP_LEGEND = "(åŒ…åŒ…è£¡æœ‰å¹¾å€‹ / éŠ€è¡Œè£¡æœ‰å¹¾å€‹ / å…¶ä»–è§’è‰²æœ‰å¹¾å€‹)";
	ATSW_CONTINUEQUEUE = "ç¹¼çºŒæŽ’ç¨‹";
	ATSW_ABORTQUEUE = "æ”¾æ£„";
	ATSWCF_TITLE = "è¦ç¹¼çºŒæŽ’ç¨‹å—Ž?";
	ATSWCF_TEXT = "å¾ž patch 1.10 èµ·, è¦é»žä¸€ä¸‹æŒ‰éˆ•æ‰èƒ½è£½ä½œç‰©å“. æŒ‰ä¸€ä¸‹ã€Œç¹¼çºŒã€å°±å¯ä»¥æŽ¥è‘—è£½ä½œç‰©å“.";
	ATSWCF_TITLE2 = "æŽ’ç¨‹è£¡ä¸‹ä¸€å€‹è¦è£½ä½œçš„ç‰©å“:";
	ATSW_CSBUTTON = "ç·¨è¼¯";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "é€™ä½å•†äººæœ‰ä½ éœ€è¦çš„ææ–™";
	ATSW_AUTOBUYBUTTON_TEXT = "è³¼è²·ææ–™";
	ATSW_SHOPPINGLISTFRAMETITLE = "ä»¥ä¸‹æ˜¯è£½ä½œ ATSW æŽ’ç¨‹è£¡æ‰€æœ‰çš„ç‰©å“éœ€è¦çš„ææ–™çš„è³¼ç‰©æ¸…å–®:";
	ATSWOFSLB_TEXT = "åœ¨æ‹è³£å ´è£¡é¡¯ç¤ºè³¼ç‰©æ¸…å–®";
	ATSW_ENCHANT = "é™„é­”";
	ATSW_ACTIVATIONMESSAGE = "ATSW å·²ç¶“";
	ATSW_ACTIVATED = "ç‚ºç›®å‰çš„äº¤æ˜“æŠ€èƒ½å•Ÿå‹•";
	ATSW_DEACTIVATED = "ç‚ºç›®å‰çš„äº¤æ˜“æŠ€èƒ½å–æ¶ˆ";
	ATSW_SCAN_MINLEVEL = "^éœ€è¦ç­‰ç´š (%d+)";
	ATSW_QUEUESDELETED = "æ‰€æœ‰å„²å­˜çš„æŽ’ç¨‹å·²ç¶“åˆªé™¤";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - æŽ’ç¨‹éœ€è¦çš„ææ–™";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "ä»¥ä¸‹è§’è‰²ç›®å‰æ“æœ‰æŽ’ç¨‹çš„ç‰©å“:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "æ²’æœ‰æŽ’ç¨‹";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "åœ¨ ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "åœ¨å…¶ä»–è§’è‰²";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "åœ¨å•†äºº";
	ATSW_GETFROMBANK = "å¾žéŠ€è¡Œå–å¾—ææ–™";
	ATSWOFRLB_TEXT = "å¦‚æžœä½ ä»»ä½•ä¸€å€‹è§’è‰²æœ‰å„²å­˜æŽ’ç¨‹,\nåœ¨éŠ€è¡Œæ™‚è‡ªå‹•é–‹å•Ÿææ–™æ¸…å–®.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "è¼•çš®",
		[2] = "ä¸­çš®",
		[3] = "é‡çš®",
		[4] = "åŽšçš®",
		[5] = "ç¡¬ç”²çš®",
		[6] = "å¢ƒå¤–çš®é©",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - é…æ–¹æŽ’åˆ—ç·¨è¼¯å™¨";
	ATSWCS_TRADESKILLISTTITLE = "æœªåˆ†é¡žçš„é…æ–¹";
	ATSWCS_CATEGORYLISTTITLE = "å·²åˆ†é¡žçš„é…æ–¹";
	ATSWCS_ADDCATEGORY = "æ–°é¡žåˆ¥";
	ATSWCS_NOTHINGINCATEGORY = "< ç©º >";
	ATSWCS_UNCATEGORIZED = "æœªåˆ†é¡ž";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW é…æ–¹æŽƒæ";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW æ­£åœ¨å¾žä¼ºæœå™¨å–å¾—æ‚¨çš„é…æ–¹ä¸¦å­˜å…¥æœ¬æ©Ÿå¿«å–ä¸­";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "åˆå§‹åŒ–...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "ç•¥éŽ";
	ATSW_SCAN_DELAY_FRAME_ABORT = "æ”¾æ£„";

	ATSW_ONLYCREATABLE = "materials available";
else
	ATSW_SORTBYHEADERS = "Order by Categories";
	ATSW_SORTBYNAMES = "Order by Names";
	ATSW_SORTBYDIFFICULTY = "Order by Difficulty";
	ATSW_CUSTOMSORTING = "Custom Sorting";
	ATSW_QUEUE = "Queue";
	ATSW_QUEUEALL = "Queue all";
	ATSW_DELETELETTER = "D";
	ATSW_STARTQUEUE = "Process Queue";
	ATSW_STOPQUEUE = "Stop Processing";
	ATSW_DELETEQUEUE = "Empty Queue";
	ATSW_ITEMSMISSING1 = "You need the following items to produce ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "Filter:";
	ATSW_REAGENTLIST1 = "To produce 1x ";
	ATSW_REAGENTLIST2 = " the following reagents are needed:";
	ATSW_REAGENTFRAMETITLE = "The following reagents are needed to process the queue:";
	ATSW_REAGENTBUTTON = "Reagents";
	ATSW_REAGENTFRAME_CH1 = "Inv.";
	ATSW_REAGENTFRAME_CH2 = "Bank";
	ATSW_REAGENTFRAME_CH3 = "Alt";
	ATSW_REAGENTFRAME_CH4 = "Merchant";
	ATSW_ALTLIST1 = "The following alts own '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " in the inventory of ";
	ATSW_ALTLIST4 = " in the bank of ";
	ATSW_OPTIONS_TITLE = "ATSW Options";
	ATSWOFIB_TEXT = "Consider items in your bank when calculating the number\nof producable items";
	ATSWOFIA_TEXT = "Consider items in the inventory and in the bank of your\nalternative characters when calculating the number\nof producable items";
	ATSWOFIM_TEXT = "Consider buyable items when calculating the number\nof producable items";
	ATSWOFUCB_TEXT = "Display only one total count of producable items considering\nthe following options";
	ATSWOFSCB_TEXT = "Display the number of items producable with inv. conntents\nand the number creatable considering the following options";
	ATSWOFTB_TEXT = "Enable recipe tooltips";
	ATSW_OPTIONSBUTTON = "Options";
	ATSW_BUYREAGENTBUTTON = "Buy reagents from the currently selected merchant";
	ATSWOFAB_TEXT = "Automatically buy anything possible and necessary\nfor the current queue when speaking to vendors";
	ATSW_AUTOBUYMESSAGE = "ATSW has automatically bought the following items:";
	ATSW_TOOLTIP_PRODUCABLE = " can be produced with the reagents in your inventory"
	ATSW_TOOLTIP_NECESSARY = "To produce one of these, the following reagents are needed:";
	ATSW_TOOLTIP_BUYABLE = " (buyable)";
	ATSW_TOOLTIP_LEGEND = "(items in inventory / items on bank / items on alts)";
	ATSW_CONTINUEQUEUE = "Continue queue";
	ATSW_ABORTQUEUE = "Abort";
	ATSWCF_TITLE = "Continue queue processing?";
	ATSWCF_TEXT = "Since patch 1.10, a click on a button is necessary to be able to produce items. By clicking on 'Continue', you supply this action and the queue processing can continue.";
	ATSWCF_TITLE2 = "The next item in the queue is:";
	ATSW_CSBUTTON = "Edit";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "This merchant sells reagents you need!";
	ATSW_AUTOBUYBUTTON_TEXT = "Buy Reagents";
	ATSW_SHOPPINGLISTFRAMETITLE = "Shopping list of reagents you need to produce the items in all saved ATSW queues:";
	ATSWOFSLB_TEXT = "Display shopping list at the auction house";
	ATSW_ENCHANT = "Enchant";
	ATSW_ACTIVATIONMESSAGE = "ATSW has been";
	ATSW_ACTIVATED = "enabled for the current tradeskill";
	ATSW_DEACTIVATED = "disabled for the current tradeskill";
	ATSW_SCAN_MINLEVEL = "^Requires Level (%d+)";
	ATSW_QUEUESDELETED = "all saved queues have been deleted";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - Reagents for queues";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "The following characters currently have queued items:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "no queues found";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "on ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "on other alts";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "at the merchant";
	ATSW_GETFROMBANK = "Get reagents from bank";
	ATSWOFRLB_TEXT = "Automatically open reagent list in bank if there are\nsaved queues on any of your characters.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "Light Leather",
		[2] = "Medium Leather",
		[3] = "Heavy Leather",
		[4] = "Thick Leather",
		[5] = "Rugged Leather",
		[6] = "Knothide Leather",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - Recipe Sorting Editor";
	ATSWCS_TRADESKILLISTTITLE = "Uncategorized Recipes";
	ATSWCS_CATEGORYLISTTITLE = "Categorized Recipes";
	ATSWCS_ADDCATEGORY = "New Category";
	ATSWCS_NOTHINGINCATEGORY = "< empty >";
	ATSWCS_UNCATEGORIZED = "Uncategorized";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW recipe scan";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW is now scanning your recipes to get them from the server into your local cache";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "initializing...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "Skip this";
	ATSW_SCAN_DELAY_FRAME_ABORT = "Abort";

	ATSW_ONLYCREATABLE = "materials available";
end