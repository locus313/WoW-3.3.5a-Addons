----------------------
-- 
-- French Localisation for MobInfo
-- 
-- created by Sasmira ( Cosmos Team )
-- updated by Halrik (Curse forum user)
-- updated by Tieum (ui.worldofwar.net forum user)
--

if ( MI2_Locale == "frFR" ) then
--if ( MI2_Locale == "deDE" ) then

MI2_SpellSchools = { Arcanes="ar", Feu="fi", Givre="fr", Ombre="sh", ["Sacr\195\169"]="ho", Nature="na",
					 arcanes="ar", feu="fi", givre="fr", ombre="sh", ["sacr\195\169"]="ho", nature="na" }

MI_TXT_WELCOME = "Bienvenue dans MobInfo"
MI_DESCRIPTION = "Ajoute une pr\195\169cision d\'information sur un monstre dans la Tooltip";
MI_TXT_GENERAL_OPTIONS	= "This Options Page controls the main functions of the MobInfo AddOn. The other options pages allow configuring the details for each feature."

MI_TXT_GOLD = " Or";
MI_TXT_SILVER = " Argent";
MI_TXT_COPPER = " Cuivre";

MI_TXT_OPEN				= "Ouvrir";
MI_TXT_COMBINED			= "Fusion:";
MI_TXT_MOB_DB_SIZE		= "Taille des Data de MobInfo: ";
MI_TXT_HEALTH_DB_SIZE	= "Taille des Data de MobHealth: ";
MI_TXT_PLAYER_DB_SIZE	= "Taille des Data de PlayerHealth:  ";
MI_TXT_ITEM_DB_SIZE		= "Taille des Data Objets:  ";
MI_TXT_CUR_TARGET		= "Cible Courante: ";
MI_TXT_MH_DISABLED		= "AVERTISSEMENT MobInfo : Un addon MobHealth externe a \195\169t\195\169 trouv\195\169. Les fonctionnalit\195\169es du MobHealth interne ont \195\169t\195\169 d\195\169sactiv\195\169es tant que l\'addon externe n\'est pas supprim\195\169.";
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n Vous ne perdrez PAS vos donn\195\169es en d\195\169sactivant l\'addon MobHealth externe.\n\nAvantages : affichage sant\195\169/mana r\195\169glable avec support du pourcentage, polices et tailles r\195\169glables");
MI_TXT_CLR_ALL_CONFIRM	= "Voulez vous r\195\169ellement effectuer l\'op\195\169ration suivante de suppression: ";
MI_TXT_SEARCH_LEVEL		= "Niveau du Mob:";
MI_TXT_SEARCH_MOBTYPE	= "Type de monstre:";
MI_TXT_SEARCH_LOOTS		= "Mob Pill\195\169e:";
MI_TXT_TRIM_DOWN_CONFIRM = "ATTENTION: Ceci est une suppression imm\195\169diate et permanente. Voulez vous r\195\169ellement supprimer toutes les donn\195\169es des monstres non selectionn\195\169s comme \195\169tant enregistr\195\169s.";
MI_TXT_CLAM_MEAT		= "Viande de Palourde"
MI_TXT_SHOWING			= "Voir Liste: "
MI_TXT_DROPPED_BY		= "Obtenu sur: "
MI_TXT_IMMUNE			= "Immune:"
MI_TXT_RESIST			= "Resist:"
MI_TXT_DEL_SEARCH_CONFIRM = "Do you really want to DELETE the %d Mobs in the search result list from the MobInfo database ?"
MI_TXT_WRONG_LOC		= "ERROR : MobInfo database locale is incompatible with your WoW client locale. MobInfo database is unusable until fixed."
MI_TXT_WRONG_DBVER		= "ERROR : Your MobInfo database is too old and not compatible with this version of MobInfo.\n\nMobInfo must delete all your old Mob data."
MI_TXT_PRICE			= "Vendor Price for "
MI_TXT_TOOLTIP_MOVE		= "To move the tooltip anchor simply\nclick&drag it to a new location on screen"
MI_TXT_ITEMFILTER		= "Filtre d\'Objets"

MI2_CHAT_MOBRUNS = "essaie de s'enfuir"
MI2_TXT_MOBRUNS = "*s'enfuir*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG	= "Open MobInfo Options"

MI2_FRAME_TEXTS = {};
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "Options \195\160 voir dans la Tooltip";
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Options de Mob Health";
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Options de la DataBase";
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Valeur de la Vie";
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Valeur de la Mana";
MI2_FRAME_TEXTS["MI2_FrmSearchLevel"]		= "Niv. du Monstre";
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Import External MobInfo Database"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Options: Objet dans la Tooltip";
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "MobInfo Tooltip Layout"


---------------------------
-- Tooltip Options/Content
---------------------------

MI_TXT_HEALTH		= "Vie"
MI_HLP_HEALTH		= "Affiche la vie de la cible (en cours/max)"
MI_TXT_MANA			= "Mana"
MI_HLP_MANA			= "Affiche le mana/rage/\195\169nergie de la cible (en cours/max)"
MI_TXT_KILLS		= "Tu\195\169"
MI_HLP_KILLS		= "Affiche le nombre de fois que le m\195\170me monstre a \195\169t\195\169 tu\195\169\nle nombre de mort est calcul\195\169/stock\195\169 \ns\195\169par\195\169ment par personnage"
MI_TXT_LOOTS		= "Pill\195\169e"
MI_HLP_LOOTS		= "Affiche le nombre de fois que le monstre a \195\169t\195\169 pill\195\169e"
MI_TXT_COINS		= "V-Argent"
MI_HLP_COINS		= "Affiche la moyenne d\'Argent ramass\195\169e par monstre\nLa valeur totale est cumul\195\169e et divis\195\169e \npar le nombre de loot.\n(Ne s\'affiche pas si le compte est de z\195\169ro)"
MI_TXT_ITEMVAL		= "V-Objets"
MI_HLP_ITEMVAL		= "Affiche valeur moyenne des objets par monstre\nLa valeur totale est cumul\195\169e et divis\195\169e \npar le nombre de loot.\n(Ne s\'affiche pas si le compte est de z\195\169ro)"
MI_TXT_MOBVAL		= "Valeur"
MI_HLP_MOBVAL		= "Affiche la moyenne de la valeur totale des monstres\nMoyenne de la valeur totale \nde l\'Argent et des objets"
MI_TXT_XP			= "XP"
MI_HLP_XP			= "Affiche le nombre de point d\'exp\195\169rience qu\'un monstre donne\nActuellement la derni\195\168re valeur qui s\'affiche. \n(Ne s\'affiche pas lorsque les monstres sont gris pour vous)"
MI_TXT_TO_LEVEL		= "# pour L"
MI_HLP_TO_LEVEL		= "Affiche le nombre de monstres restant \195\160 tuer pour changer de niveau\nNe s\'affiche pas lorsque les monstres sont gris pour vous"
MI_TXT_EMPTY_LOOTS	= "Vides"
MI_HLP_EMPTY_LOOTS	= "Affiche le nombre de butin vides trouv\195\169s(nbre/%tage)\nLe compteur augmente lorsque vous ouvrez \n un corp sans butin"
MI_TXT_CLOTH_DROP	= "Tissu"
MI_HLP_CLOTH_DROP	= "Affiche le nombre de tissu ramass\195\169"
MI_TXT_CLASS		= "Classe"
MI_HLP_CLASS		= "Affiche la classe de la cible"
MI_TXT_DAMAGE		= "Dommage"
MI_HLP_DAMAGE		= "Affiche la zone d\'effet des dommages (Min/Max) + DPS (Damage per Second)\nLa zone d\'effet est calcul\195\169e/stock\195\169e s\195\169par\195\169ment par personnage"
MI_TXT_QUALITY		= "Objets"
MI_HLP_QUALITY		= "Affiche la qualit\195\169 du loot en nombre et pourcentage\nLe compteur indique la quantit\195\169 en fonction des 5 cat\195\169gories de raret\195\169"
MI_OPT_QUALITY		= "Loot Items Summary"
MI_TXT_LOCATION		= "Lieu"
MI_HELP_LOCATION	= "Affiche le Lieu ou vous pouvez trouver le monstre\nL\'enregistrement des donn\195\169es de Lieu doit \195\170tre ACTIF pour fonctionner"
MI_TXT_LOWHEALTH	= "Runaway Mob Indicator"
MI_HELP_LOWHEALTH	= "Show indicator for Mobs that run when low on health\nThe indicator is a red message line that gets shown\nin the tooltip for the runaway Mobs only"
MI_OPT_RESISTS		= "Resists and Immunities"
MI_TXT_RESISTS		= "Resist"
MI_TXT_IMMUN		= "Immun"
MI_HELP_RESISTS		= "Show resistances and immunities in ToolTip\nRecorded data about the Mobs elemental spell school\nresistances or immunities is added to the tooltip"
MI_TXT_ITEMLIST		= "D\195\169tail des Objets loot\195\169s"
MI_HELP_ITEMLIST	= "Affiche les noms et quantit\195\169s de tous les objets ramass\195\169s\nL\'enregistrement des donn\195\169es d\'Objet doit \195\170tre ACTIF pour fonctionner"
MI_TXT_CLOTHSKIN	= "Cloth and Skinning Loot"
MI_HELP_CLOTHSKIN	= "Show names and amount of all cloth and skinning loot items\nRecording loot item data must be ENABLED for this to work"


--------------------
-- General Options
--------------------
MI2_OPTIONS = {};

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

MI2_OPTIONS["MI2_OptShowCombined"] =
{ text = "Fusion des Infos"; help = "Regroupe les Informations des monstres dans la bulle d\'aide\nAffiche un message dans la bulle d\'aide, indiquant que le mode Regoup\195\169 est actif. \nIl liste tous les niveaux des monstres \nqui ont \195\169t\195\169 regroup\195\169 dans une seule bulle d\'aide." }

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
{ text = "Min"; help = "Niveau minimum du monstre pour les options de recherche"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "Niveau maximum du monstre pour les options de recherche (doit \195\170tre < 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normal"; help = "inclure le type Normal des monstres dans le r\195\169sultat de la recherche"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Elite"; help = "inclure le type Elite des monstres dans le r\195\169sultat de la recherche"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Boss"; help = "inclure le type Boss des monstres dans le r\195\169sultat de la recherche"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "Nombre de fois minimum que le monstre a \195\169t\195\169 pill\195\169"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
{ text = "Max"; help = "Nombre de fois maximum que le monstre a \195\169t\195\169 pill\195\169"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Nom: Monstre"; help = "Nom complet ou partiel du monstre pour la recherche";
info = 'Laisser vide restreint la recherche d\'objets sp\195\169cifiques\nEntrer "*" pour s\195\169lectionner tous les objets.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Nom: Objet"; help = "Nom complet ou partiel de l\'objet pour la recherche";
info = 'Laisser vide la recherche pour avoir tous les noms d\'objet'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Recherche par valeur"; help = "Recherche les 12 monstres les plus profitables";
info = 'Le classement des monstres est fait par valeur des objets plus un bonus pour les objets rares.\n"r"=rang, "v"= valeur totale, "q"=qualit\195\169 des objets'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Recherche par sorte d\'objet"; help = "Liste le r\195\169sultat de recherche par le nombre de sorte d\'objet";
info = 'Associe les monstres sur lequel le(s) objet(s) indiqu\195\169(s) est/sont ramass\195\169(s).'; }

MI2_OPTIONS["MI2_OptItemTooltip"] = 
{ text = "Liste: Mobs dans la Tooltip Objet"; help = "Affiche les noms des monstres qui droppent un objet dans la Tooltip d\'objet";
info = "Liste \195\160 la vol\195\169 dans la tooltip,\nle nom de tous les monstres sur lequel on trouve l\'objet ramass\195\169. Cr\195\169er une liste en pourcentage \ndu nombre de fois l\'objet ramass\195\169 sur le monstre." }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
{ text = "Show Vendor Sell Price"; help = "Show vendor sell price for item in item tooltip" }

MI2_OPTIONS["MI2_OptCombinedMode"] =
{ text = "Fusion des monstres identiques"; help = "Regroupe les donn\195\169es des monstres de m\195\170me nom";
info = "Regroupe les donn\195\169es des monstres de m\195\170me nom \nmais de niveaux diff\195\169rents dans la bulle d\'aide" }

MI2_OPTIONS["MI2_OptKeypressMode"] =
{ text = "ALT pour voir MobInfo"; help = "MobInfo s\'affiche uniquement dans la bulle d\'aide lorsque la touche ALT est press\195\169e"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = ""; help = "Configure un filtrage dans l\'affichage de la tooltip pour les objets ramass\195\169s";
info = "Affiche uniquement les objets ramass\195\169s dans la Tooltip des monstres qu\'inclu\n le filtre texte. E.g. entrer 'Tissu' affichera tous les objets avec\n'Tissu' dans le nom.\nNe rien rentrer pour voir tous les objets." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Sauver la vie des joueurs de mani\195\168re permanente."; help = "Sauve la vie des joueurs en bataille JcJ.";
info = "Habituellement, la vie des joueurs JcJ est effac\195\169e apr\195\168s\nchaque session. Cette option vous permet de garder ces donn\195\169es." }

MI2_OPTIONS["MI2_OptAllOn"] =
{ text = "Tous ON"; help = "Toutes les options de MobInfo sont activ\195\169es"; }

MI2_OPTIONS["MI2_OptAllOff"] =
{ text = "Tous OFF"; help = "Toutes les options de MobInfo sont d\195\169sactiv\195\169es"; }

MI2_OPTIONS["MI2_OptDefault"] =
{ text = "D\195\169faut"; help = "Affiche les options par d\195\169faut de MobInfo"; }

MI2_OPTIONS["MI2_OptBtnDone"] =
{ text = "Appliquer"; help = "Ferme la fen\195\170tre des Options de MobInfo"; }

MI2_OPTIONS["MI2_OptTargetHealth"] =
{ text = "Valeur de la Vie"; help = "Affiche la valeur de la vie dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptTargetMana"] =
{ text = "Valeur du Mana"; help = "Affiche la valeur du mana dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptHealthPercent"] =
{ text = "Vie en pourcentage"; help = "Ajoute la Vie en pourcentage dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptManaPercent"] =
{ text = "Mana en pourcentage"; help = "Ajoute le Mana en pourcentage dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptHealthPosX"] =
{ text = "Position Horizontale"; help = "Ajuste la Position Horizontale de la Vie dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptHealthPosY"] =
{ text = "Position Verticale"; help = "Ajuste la Position Verticale de la Vie dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptManaPosX"] =
{ text = "Position Horizontale"; help = "Ajuste la Position Horizontale du mana dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptManaPosY"] =
{ text = "Position Verticale"; help = "Ajuste la Position Verticale du mana dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptTargetFont"] =
{ text = "Police"; help = "Configure la police de caract\195\168re pour la valeur vie/mana dans la fen\195\170tre Cible";
  choice1 = "NumberFont"; choice2 = "GameFont"; choice3 = "ItemTextFont" }

MI2_OPTIONS["MI2_OptTargetFontSize"] =
{ text = "Taille de la Police"; help = "Configure taille de la police de caract\195\168re pour la valeur vie/mana dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptClearTarget"] =
{ text = "Suppr. Data Cible"; help = "Supprime le contenu de la Base donn\195\169es pour la cible courante"; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Suppr. Database"; help = "Supprime enti\195\168rement le contenu des informations sur les monstres de la Base de donn\195\169es."; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Suppr. Database"; help = "Supprime enti\195\168rement le contenu des informations de MobHealth de la Base de donn\195\169es."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Suppr. Database"; help = "Supprime enti\195\168rement le contenu des informations de PlayerHealth de la Base de donn\195\169es."; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Sauve: Data des Objets loot\195\169s"; help = "Activer cette fonction pour enregistrer le d\195\169tail des objets ramass\195\169s pour tous les monstres.";
info = "Cela enregistrera tous les objets: nom, qualit\195\169, quantit\195\169 totale.\nEnregistre seulement \195\160 partir des objets Communs (Blanc)."; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Sauvegarde de toutes les Data des Mobs sp\195\169cifiques"; help = "Sauvegarde toutes les donn\195\169es des mobs qui ont des caract\195\169ristiques sp\195\169cifiques.";
info = "Ceci activera ou d\195\169sactivera des donn\195\169es suivantes:\nnombre de morts, min/max dommage, DPS (dommage par sec), Mob XP\n\nCette donn\195\169e est sauvegard\195\169e s\195\169parement pour chaque personnage.\nLe sauver peut seulement \195\170tre Activer/D\195\169sactiver pour la configuration enti\195\168re de 4 valeurs"; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Speichern der Daten zu Resistenzen und Immunit\195\164ten"; help = "Speichert Daten zu den magischen Resistenzen und Immunit\195\164ten eines Mobs.";
info = "Separat pro Magieart wird gez\195\164hlt, wieviele Spells gegen das Monster\nerfolgreich waren und wievielen wiederstanden wurde."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = ""; help = "Enregistre le d\195\169tail des objets ramass\195\169s en s\195\169lectionnant la qualit\195\169 et plus.";
choice1 = "Gris & Plus"; choice2="Blanc & Plus"; choice3="Vert & Plus" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "R\195\169duire la taille: Database Mob"; help = "R\195\169duit la taille de la Base de donn\195\169es sur les monstres par suppression du surplus de donn\195\169es.";
	  info = "Les donn\195\169es en surplus sont toutes les donn\195\169es dans la base de donn\195\169es qui ne sont pas marqu\195\169es comme \195\169tant enregistr\195\169es."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Start the Import"; help = "Import an external Mob Database into your own Mob Database";
info = "IMPORTANT: please read the import instructions !\nALWAYS backup your own Mob database BEFORE import !"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "DELETE"; help = "Deletes all Mobs in the search result list from the MobInfo database.";
info = "WARNING: this operation can not be undone.\nPlease use carefully !\nYou might want to backup your MobInfo database before deleting Mobs."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Import only unknown Mobs"; help = "Import only Mobs that do not exist in your own database";
info = "Activating this option prevents that the data of existing Mobs\nis modified. Only unknown (ie. new) Mobs will get imported. This\nallows importing partially overlapping database without causing\nconsistency problems."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Liste Mob"; help = ""; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Liste Objets"; help = ""; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] =
{ text = "Tooltips"; help = "Configure les options d\'affichage des informations sur les monstres dans la bulle d\'aide"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] =
{ text = "Target Frame"; help = "Configure les options d\'affichage Vie/mana dans la fen\195\170tre Cible"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] =
{ text = "Database"; help = "Gestions des options des bases de donn\195\169es"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
{ text = "Recherche"; help = "Recherche par la base de donn\195\169es"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
{ text = "General"; help = "General options for the MobInfo AddOn"; }

end
