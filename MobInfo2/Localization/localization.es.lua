--
-- Spanish localization for MobInfo
--
-- original version by an anonymous benefactor
-- updates kindly submitted by FILI
-- updates kindly submitted by AlbertQ
-- updates kindly submitted by maqjav

if ( MI2_Locale == "esES" ) then
--if ( MI2_Locale == "deDE" ) then

MI2_SpellSchools = { Arcana="ar", Fuego="fi", Frost="fr", Sombra="sh", Holy="ho", Naturaleza="na" }

MI_TXT_WELCOME          = "Bienvenido a MobInfo";
MI_DESCRIPTION = "Añade información sobre las criaturas en la ventana de descripción e información sobre la salud y el maná en el marco del objetivo";
MI_TXT_GENERAL_OPTIONS	= "Está página de opciones controla las funciones principales de MobInfo. Las otras páginas de configuración permiten configurar los detalles de cada característica del addon."

MI_TXT_GOLD   = " Oro";
MI_TXT_SILVER = " Plata";
MI_TXT_COPPER = " Bronce";

MI_TXT_OPEN				= "Abrir";
MI_TXT_COMBINED			= "Combinado: ";
MI_TXT_MOB_DB_SIZE		= "Tamaño BD de MobInfo:  ";
MI_TXT_HEALTH_DB_SIZE	= "Tamaño BD de Salud:  ";
MI_TXT_PLAYER_DB_SIZE	= "Tamaño BD de Salud del Jugador:  ";
MI_TXT_ITEM_DB_SIZE		= "Tamaño BD de objetos:  ";
MI_TXT_CUR_TARGET		= "Objetivo actual:  ";
MI_TXT_MH_DISABLED		= "MobInfo ADVERTENCIA: Encontrado el AddOn MobHealth independiente. El MobHealth interno se desactivará hasta que se borre el MobHealth independiente.";
MI_TXT_MH_DISABLED2		= (MI_TXT_MH_DISABLED.."\n\n No vas a perder tus datos por activar MobHealth.\n\nBeneficios: ventana de salud/maná desplazable además de un tipo de fuente modificable");
MI_TXT_CLR_ALL_CONFIRM	= "¿Realmente quieres realizar la siguiente operación de borrado?: ";
MI_TXT_SEARCH_LEVEL		= "Nivel Mob:";
MI_TXT_SEARCH_MOBTYPE	= "Tipo de Mob:";
MI_TXT_SEARCH_LOOTS		= "Saqueo Mob:";
MI_TXT_TRIM_DOWN_CONFIRM = "ADVERTENCIA: esto es un borrado inmediato y permanente. ¿Realmente quieres realizar el borrado?"
MI_TXT_CLAM_MEAT		= "Carne de Almeja"
MI_TXT_SHOWING			= "Muestra lista: "
MI_TXT_DROPPED_BY		= "Saqueado por "
MI_TXT_IMMUNE			= "Inmune:"
MI_TXT_RESIST			= "Resiste:"
MI_TXT_DEL_SEARCH_CONFIRM = "¿Realmente quieres ELIMINAR las %d criaturas encontradas en la bússqueda de la base de datos de MobInfo ?"
MI_TXT_WRONG_LOC		= "ERROR : El idioma de la base de datos de MobInfo no es compatible con el idioma de tu cliente de WoW. No podrás usar la base de datos hasta que lo corrijas."
MI_TXT_WRONG_DBVER		= "ERROR : Tu base de datos de MobInfo es demasiado vieja y no es compatible con esta versión de MobInfo.\n\nMobInfo tiene que eliminar todos los datos antiguos."
MI_TXT_PRICE			= "Precio en vendedor "
MI_TXT_TOOLTIP_MOVE		= "Para cambiar la posición haz click y\narrastra hasta la nueva posición"
MI_TXT_ITEMFILTER		= "Filtrar objetos"

MI2_CHAT_MOBRUNS = "intentos de huida"
MI2_TXT_MOBRUNS = "*huidas*"

BINDING_HEADER_MI2HEADER	= "MobInfo"
BINDING_NAME_MI2CONFIG	= "Abrir opciones de MobInfo"

MI2_FRAME_TEXTS = {};
MI2_FRAME_TEXTS["MI2_FrmTooltipContent"]	= "Opciones ventana de la criatura";
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]		= "Opciones de MobHealth";
MI2_FRAME_TEXTS["MI2_FrmDatabaseOptions"]	= "Opciones de la base de datos";
MI2_FRAME_TEXTS["MI2_FrmHealthValueOptions"]= "Valor de Salud";
MI2_FRAME_TEXTS["MI2_FrmManaValueOptions"]	= "Valor de Maná";
MI2_FRAME_TEXTS["MI2_FrmSearchOptions"]		= "Opciones de búsqueda";
MI2_FRAME_TEXTS["MI2_FrmImportDatabase"]	= "Importar base de datos externa de MobInfo"
MI2_FRAME_TEXTS["MI2_FrmItemTooltip"]		= "Opciones ventana del Objeto";
MI2_FRAME_TEXTS["MI2_FrmTooltipLayout"]		= "Diseño ventana de MobInfo"


---------------------------
-- Tooltip Options/Content
---------------------------

MI_TXT_HEALTH		= "Vida"
MI_HLP_HEALTH		= "Muestra información de la vida de la criatura (actual/max)"
MI_TXT_MANA			= "Maná"
MI_HLP_MANA			= "Muestra información de maná/rabia/energía de la criatura (actual/max)"
MI_TXT_KILLS		= "Muertes"
MI_HLP_KILLS		= "Muestra el número de veces que matastaste a la criatura\nLa cuenta de muertes se calcula y almacena\npor personaje"
MI_TXT_LOOTS		= "Saqueos"
MI_HLP_LOOTS		= "Muestra el número de veces que una criatura ha sido saqueada"
MI_TXT_COINS		= "V-Dinero"
MI_HLP_COINS		= "Muestra la mejor cantidad de monedas arrojada por un Mob\nEl valor total de monedas es acumulado y dividido\npor el contador de saqueos.\n(no se muestra si el valor de moneda es 0)"
MI_TXT_ITEMVAL		= "V-Objeto"
MI_HLP_ITEMVAL		= "Muestra el mayor valor de objetos soltados por la criatura\nEl valor total de objetos es acumulable por el contador de saqueo.\n(no se muestra con valor 0)"
MI_TXT_MOBVAL		= "Valor"
MI_HLP_MOBVAL		= "Muestra el mayor valor total de la criatura\nEsta es la suma del dinero y\nel valor de objetos"
MI_TXT_XP			= "Exp"
MI_HLP_XP			= "Muestra el número de puntos de experiencia que obtuviste de la última criatura que matastes.\nNo se muestra la experiencia de criaturas que son grises para ti."
MI_TXT_TO_LEVEL		= "# Nivel"
MI_HLP_TO_LEVEL		= "Muestra el número de muertes necesarias para subir un nivel\nEste te indica cuantas veces tienes que matar al\nmismo Mob recien matado para alcanzar el siguiente nivel\n(no se muestran los Mobs que son grises para ti)"
MI_TXT_EMPTY_LOOTS	= "Vacíos"
MI_HLP_EMPTY_LOOTS	= "Muestra el número de cuerpos vacíos encontrados (núm/porcentaje)\nEste contador se incrementa cuando abres\n un cuerpo que no tiene nada"
MI_TXT_CLOTH_DROP	= "Telas"
MI_HLP_CLOTH_DROP	= "Muestra cuantas veces has obtenido telas en el saqueo"
MI_TXT_CLASS		= "Clase"
MI_HLP_CLASS		= "Muestra la clase de la criatura"
MI_TXT_DAMAGE		= "Daño"
MI_HLP_DAMAGE		= "Muestra rango de daño (Min/Max) y DPS (daño por segundo) de la criatura.\nRango de daño y DPS se calcula y almacena por personaje.\nDPS se actualizan y guardan después de cada pelea"
MI_TXT_QUALITY		= "Objeto"
MI_HLP_QUALITY		= "Muestra la calidad del saqueo y porcentaje\nEsto cuenta cuantos objetos de las 5 categorias de calidad\nte ha dado un Mob al saquearlo. Categorias con 0 arrojado no\nse muestran. El porcentaje es la posibilidad de conseguir\nun objeto de un monstruo de la rareza específica como saqueo"
MI_OPT_QUALITY		= "Recuento de objetos saqueados"
MI_TXT_LOCATION		= "Lugar"
MI_HELP_LOCATION	= "Muestra la localización de donde se encuentra la criatura.\nGuardar datos debe ser ACTIVADO para que funcione"
MI_TXT_LOWHEALTH	= "Indicador de criaturas que huyen"
MI_HELP_LOWHEALTH	= "Muestra un indicador con las criaturas que huyen cuando les queda poca vida\nEl indicador es un mensaje (línea en rojo) que se muestra\nen la ventana de la criatura que huye"
MI_OPT_RESISTS		= "Resistencias e inmunidades"
MI_TXT_RESISTS		= "Resistencia"
MI_TXT_IMMUN		= "Immunidad"
MI_HELP_RESISTS		= "Muestra las resistencias e inmunidades en la ventana\nLos datos almacenados sobre las resistencias ó inmunidades\nde la escuela de magia elemental del enemigo\nson añadidos a la ventana de descripción"
MI_TXT_ITEMLIST		= "Lista de objetos básicos"
MI_HELP_ITEMLIST	= "Muestra el nombre y la cantidad de los objetos básicos saqueados\nLos objetos básicos son todos menos los de peletería y sastrería\nGuardar datos de objetos squeados, debe estar ACTIVADO para que funcione"
MI_TXT_CLOTHSKIN	= "Telas y pieles saqueadas"
MI_HELP_CLOTHSKIN	= "Muestra nombres y cantidad de telas y pieles saqueadas\nGuardar datos de objetos squeados, debe estar ACTIVADO para que funcione"


--------------------
-- General Options
--------------------
MI2_OPTIONS = {};

MI2_OPTIONS["MI2_OptSaveBasicInfo"] = 
{ text = "Captura y almacena información detallada de las criaturas";
help = "Activa o desactiva la captura de información detallada\nsobre las criaturas que descubres y matas en el juego. Esta información\npuede mostrarse en la ventana de descripción, o se puede usar para buscar\ncriaturas en la herramienta de búsqueda. Los datos también pueden mostrarse\njunto con la información de un objeto 'Soltado por'.\n\nDesactiva esta opción si no quieres que MobInfo captura y almacene\ninformación. Solo la salud/maná de la criatura siempre será calculada\ny almacenada incluso si desactivas esta opción." }

MI2_OPTIONS["MI2_OptShowMobInfo"] = 
{ text = "Muestra información de la criatura en la ventana de MobInfo"; 
help = "Muestra información de la criatura en la ventana de MobInfo.\nUtiliza la página de opciones de la ventana para elegir que información quieres mostrar.\nDesactiva esta opción si no quieres ver dicha información\no la ventanita de MobInfo." }

MI2_OPTIONS["MI2_OptUseGameTT"] = 
{ text = "Utiliza la ventana del juego en lugar de la ventana de MobInfo"; 
help = "La ventana de MobInfo tiene un diseño óptimo y desplazable,\ny se activa predeterminadamente.\nActivando esta opción utilizarás la ventana del juego\nen lugar de la ventana de MobInfo para mostrar la información de las criaturas." }

MI2_OPTIONS["MI2_OptShowItemInfo"] = 
{ text = "Muestra información adicional en la ventana de un objeto"; 
help = "Muestra información adicional en la ventana de un objeto.\nUtiliza la página de opciones de la ventana para elegir que información mostrar.\nDesactiva esta opción si no quieres que MobInfo añada mas datos\na la ventana del objeto."; }

MI2_OPTIONS["MI2_OptShowTargetInfo"] = 
{ text = "Muestra información en la ventana del objetivo (Salud,Maná...)"; 
help = "Muestra información como la cantidad de Vida o Mana en la ventana del objetivo.\n(solo funciona si no utilizas ningún Addon que afecte a los marcos)\nUtiliza la página de opciones de objetivo marcado para configurar que mostrar.\n\nDesactiva esta opción si no quieres que MobInfo muestre mas información en la ventana de un objetivo." }

MI2_OPTIONS["MI2_OptShowMMButton"] = 
{ text = "Muestra botón del minimapa"; 
help = "Muestra / Esconde el botón de MobInfo en el minimapa" }

MI2_OPTIONS["MI2_OptMMButtonPos"] = 
{ text = "Posición del botón del minimapa"; 
help = "Utiliza el desplazador para cambiar la posición del botón de MobInfo en el minimapa" }


--------------------
-- Other Options
--------------------

MI2_OPTIONS["MI2_OptShowIGrey"] = 
{ text = ""; help = "Muestra objetos grises (pobres) en la ventana de descripción" }

MI2_OPTIONS["MI2_OptShowIWhite"] = 
{ text = ""; help = "Muestra objetos blancos (comunes) en la ventana de descripción" }

MI2_OPTIONS["MI2_OptShowIGreen"] = 
{ text = "n"; help = "Muestra objetos verdes (no comunes) en la ventana de descripción" }

MI2_OPTIONS["MI2_OptShowIBlue"] = 
{ text = ""; help = "Muestra objetos azules (raros) en la ventana de descripción" }

MI2_OPTIONS["MI2_OptShowIPurple"] = 
{ text = ""; help = "Muestra objetos morados (épicos) en la ventana de descripción" }

MI2_OPTIONS["MI2_OptMouseTooltip"] = 
{ text = "Muestra la ventana en el cursor"; help = "La ventana de MobInfo se muestra justo en la posición del cursor del ratón\ny sigue sus movimientos mientras este visible." }

MI2_OPTIONS["MI2_OptHideAnchor"] = 
{ text = "Esconder la ventana fija"; help = "Esconde la pequeña ventana 'MI' de MobInfo.\nEsta ventanita se volverá visible cuando el dialogo de opciones\nse abra y cuando esta opción este desactivada." }

MI2_OPTIONS["MI2_OptShowCombined"] = 
{ text = "Mostrar modo combinado"; help = "Muestra el mensaje modo combinado en la ventana\nMuestra un mensaje en la ventana indicando que el modo combinado\nestá activado y está listando todos los niveles de las criaturas que se han\ncombinado en una única ventana." }

MI2_OPTIONS["MI2_OptSmallFont"] = 
{ text = "Utilizar tipo de letra pequeño"; help = "Utiliza un tipo de letra mas pequeño para los textos de las ventanas" }

MI2_OPTIONS["MI2_OptTooltipMode"] = 
{ text = "Posición de la ventana"; help = "Posición de la ventana de información de MobInfo\nrelativa a la ventanita 'MI'";
choice1="Arriba-izquierda"; choice2="Abajo-izquierda"; choice3="Arriba-derecha"; choice4="Abajo-derecha"; choice5="Arriba-centro"; choice6="Abajo-centro" }

MI2_OPTIONS["MI2_OptCompactMode"] =
{ text = "Ventana en dos columnas"; help = "Muestra la información de las criaturas en una ventana mas compacta de dos columnas.\nLa ventana será de algún modo un poco mas ancha, pero considerablemente mas corta.\nLa anchura total está limitada. Las descripciones que sean demasiado anchas\nse mostrarán en una línea separada." }

MI2_OPTIONS["MI2_OptOtherTooltip"] =
{ text = "Ocultar ventaja del juego"; help = "Esconde la ventana del juego cuando se muestra la información\nde la criatura, en la ventana de MobInfo." }

MI2_OPTIONS["MI2_OptSearchMinLevel"] = 
{ text = "Min"; help = "Nivel mínimo de la criatura para las opciones de búsqueda"; }

MI2_OPTIONS["MI2_OptSearchMaxLevel"] = 
{ text = "Max"; help = "Nivel máximo de la criatura para las opciones de búsqueda (debe ser < 66)"; }

MI2_OPTIONS["MI2_OptSearchNormal"] = 
{ text = "Normales"; help = "Incluye criaturas de tipo normal en los resultados de la búsqueda"; }

MI2_OPTIONS["MI2_OptSearchElite"] = 
{ text = "Élites"; help = "Incluye criaturas de tipo élite en los resultados de la búsqueda"; }

MI2_OPTIONS["MI2_OptSearchBoss"] = 
{ text = "Jefes"; help = "Incluye criaturas jefe en los resultados de la búsqueda"; }

MI2_OPTIONS["MI2_OptSearchMinLoots"] = 
{ text = "Min"; help = "Número mínimo de veces que se debe saquear una criatura"; }

MI2_OPTIONS["MI2_OptSearchMaxLoots"] = 
{ text = "Max"; help = "Número máximo de veces que se debe saquear una criatura"; }

MI2_OPTIONS["MI2_OptSearchMobName"] = 
{ text = "Criatura"; help = "Nombre completo o parcial para buscar";
info = 'Déjalo vacío para no restringir la búsqueda a objetos específicos\nIntroduciendo "*" selecciona todos los objetos.'; }

MI2_OPTIONS["MI2_OptSearchItemName"] = 
{ text = "Objetos"; help = "Nombre completo o parcial del objeto a buscar";
info = 'Déjalo vacío para buscar todos los nombres de objetos'; }

MI2_OPTIONS["MI2_OptSortByValue"] = 
{ text = "Por recompensa"; help = "Clasifica los resultados de búsqueda por recompensa";
info = 'Clasifica las criaturas por el provecho que puedes sacar de ellos matándolos.'; }

MI2_OPTIONS["MI2_OptSortByItem"] = 
{ text = "Por objetos"; help = "Clasifica los resultados de búsqueda por número de veces que se cuenta el objeto";
info = 'Clasifica las criaturas por cuantas veces ha dado el objeto(s) especificado(s).'; }

MI2_OPTIONS["MI2_OptItemTooltip"] = 
{ text = "Mostrar criaturas en la ventana"; help = "Muestra los nombres de las criaturas que soltaron dicho objeto en la ventana de descripción";
info = "Muestra el nombre de todas las criaturas que han arrojado dicho objetos\nen la ventana de descripción del objeto. Por cada objeto lista la cantidad\narrojada por la criatura con porcentajes." }

MI2_OPTIONS["MI2_OptShowItemPrice"] =
{ text = "Mostrar Precio del objeto"; help = "Muestra el precio de venta a un vendedor de un objeto en la ventana de descripción" }

MI2_OPTIONS["MI2_OptCombinedMode"] = 
{ text = "Combinar criaturas iguales"; help = "Combina datos para criaturas con el mismo nombre";
info = "El modo combinar mezclará información de las criaturas\nque tengan el mismo nombre pero diferente nivel. Cuando está activo un\nse muestra con un indicador en la ventana de descripción de la criatura" }

MI2_OPTIONS["MI2_OptKeypressMode"] = 
{ text = "Presionar ALT para MobInfo"; help = "Solo se mostrarán datos del MobInfo en la ventana de descripción cuando pulses la tecla ALT"; }

MI2_OPTIONS["MI2_OptItemFilter"] = 
{ text = ""; help = "Establece expresiones de filtrado de objetos saqueados, en la ventana de descripción";
info = "Muestra solo los objetos saqueados cuyo nombre incluye el texto del filtro.\nP.E. si ponemos 'mono' solo se monstrarán los objetos en cuyo nombre sale está palabra.\nPara mostrar todos dejar vacio." }

MI2_OPTIONS["MI2_OptSavePlayerHp"] = 
{ text = "Guardar datos de salud de pjs permanentemente"; help = "Guarda permanentemente la salud de los jugadores en batallas JcJ.";
info = "Normalmente los datos sobre la salud de un son eliminadas después de\nuna batalla. Ajustando esta opcion te permite guardar los datos." }

MI2_OPTIONS["MI2_OptAllOn"] = 
{ text = "Todo ON"; help = "Activa todas las opciones MobInfo"; }

MI2_OPTIONS["MI2_OptAllOff"] = 
{ text = "Todo OFF"; help = "Desactiva todas las opciones de MobInfo"; }

MI2_OPTIONS["MI2_OptDefault"] = 
{ text = "Por defecto"; help = "Establece las opciones por defecto"; }

MI2_OPTIONS["MI2_OptBtnDone"] = 
{ text = "Cerrar"; help = "Cierra el diálogo de opciones de MobInfo"; }

MI2_OPTIONS["MI2_OptTargetHealth"] = 
{ text = "Mostrar valor de vida"; help = "Muestra el valor de la vida en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptTargetMana"] = 
{ text = "Mostrar valor de maná"; help = "Muestra el valor de maná en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptHealthPercent"] = 
{ text = "Mostrar porcentaje"; help = "Agrega un porcentaje de la vida en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptManaPercent"] = 
{ text = "Mostrar porcentaje"; help = "Agrega un porcentaje de maná en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptHealthPosX"] = 
{ text = "Posición horizontal"; help = "Ajusta la posición horizontal de la vida en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptHealthPosY"] = 
{ text = "Posición vertical"; help = "Ajusta la posición vertical de la vida en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptManaPosX"] = 
{ text = "Posición horizontal"; help = "Ajusta la posición horizontal del maná en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptManaPosY"] = 
{ text = "Posición vertical"; help = "Ajusta la posición vertical del maná en la ventana del objetivo"; }

MI2_OPTIONS["MI2_OptTargetFont"] = 
{ text = "Tipo de letra"; help = "Establece el tipo de letra de los valores vida/maná";
choice1= "Fuente números"; choice2="Fuente juego"; choice3="Fuente texto objetos" }

MI2_OPTIONS["MI2_OptTargetFontSize"] = 
{ text = "Tamaño del texto"; help = "Fija el tamaño de la letra en los valores vida/maná"; }

MI2_OPTIONS["MI2_OptClearTarget"] = 
{ text = "Borrar datos del objetivo"; help = "Borra los datos del objetivo actual de la base de datos."; }

MI2_OPTIONS["MI2_OptClearMobDb"] = 
{ text = "Purgar base de datos"; help = "Borra todos los datos (descripciones) sobre criaturas de la base de datos"; }

MI2_OPTIONS["MI2_OptClearHealthDb"] = 
{ text = "Purgar base de datos"; help = "Borra todos los datos (vida) sobre criaturas de la base de datos."; }

MI2_OPTIONS["MI2_OptClearPlayerDb"] = 
{ text = "Purgar base de datos"; help = "Borrar todos los datos sobre la vida de otros jugadores."; }

MI2_OPTIONS["MI2_OptSaveItems"] = 
{ text = "Guardar saqueos por su calidad:"; help = "Guardar detalles de todos los objetos saqueados.";
info = "Puedes elegir el nivel de la calidad de objetos a capturar"; }

MI2_OPTIONS["MI2_OptSaveCharData"] = 
{ text = "Guardar datos de un pj específico"; help = "Guarda todos los datos de una criatura en concreto.";
info = "Con esto activas o desactivas el guardado de los siguientes datos:\nnúmero de muertes, daño mín/máx, DPS (daño por seg.)\n\nEstos datos se capturan por cada personaje. Salvar solo puede\nactivarse/desactivarse para cada grupo completo de 4 valores"; }

MI2_OPTIONS["MI2_OptSaveResist"] = 
{ text = "Guarda datos resisten. e inmunidad."; help = "Guarda datos sobre las resistencias e inmunidades de los enemigos a diferentes magias.";
info = "MobInfo captura que hechizos y de que tipo\nhan impactado con éxito y cuantos cuantos han sido resistidos."; }

MI2_OPTIONS["MI2_OptItemsQuality"] = 
{ text = "Calidad de los objetos"; help = "Guarda datos de los objeto con la calidad seleccionada o mejor.";
choice1 = "Gris y mejor"; choice2="Blanco y mejor"; choice3="Verde y mejor" }

MI2_OPTIONS["MI2_OptTrimDownMobData"] = 
{ text = "Reducir tamaño de base de datos"; help = "Reduce el tamaño de la base de datos borrando datos sin importancia";
info = "Datos sin importancia son todos los datos\nque no marcas para guardarse."; }

MI2_OPTIONS["MI2_OptImportMobData"] = 
{ text = "Comienza la importación"; help = "Importa una base de datos externa";
info = "IMPORTANTE: ¡por favor lee las instrucciones de importación!\n¡ SIEMPRE haz una copia de seguridad de tu base de datos ANTES de importar una nueva!"; }

MI2_OPTIONS["MI2_OptDeleteSearch"] = 
{ text = "BORRAR"; help = "Borra todas las criaturas listadas en el resultado de la búsqueda de tu base de datos.";
info = "ADVERTENCIA: esta operación no se puede deshacer.¡Por favor usala con cuidado!\nDeberías hacer una copia de seguridad de tu base de datos antes de borrarla por completo."; }

MI2_OPTIONS["MI2_OptImportOnlyNew"] = 
{ text = "Importa solo criaturas desconocidas"; help = "Importa solo las criaturas que no existen en tu base de datos";
info = "Activando esta opción previene que la información de las criaturas existentes\nsea modificada. Solo las criaturas desconocidas serán importadas.\nPermite importar sobreponiendo parcialmente la base de datos\nsin causar problemas de consitencia."; }

MI2_OPTIONS["MI2_SearchResultFrameTab1"] = 
{ text = "Lista criaturas"; help = "Muestra la lista de criaturas"; }

MI2_OPTIONS["MI2_SearchResultFrameTab2"] = 
{ text = "Lista objetos"; help = "Muestra la lista de objetos"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab1"] = 
{ text = "Ventanas"; help = "Fija las opciones para mostrar datos de MobInfo en las ventanas de descripción"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab2"] = 
{ text = "Salud/Maná"; help = "Fija opciones para mostrar la vida/maná en la ventana de descripción"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab3"] = 
{ text = "Base de datos"; help = "Opciones de la base de datos"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab4"] = 
{ text = "Buscar"; help = "Busca en la base de datos"; }

MI2_OPTIONS["MI2_OptionsTabFrameTab5"] = 
{ text = "General"; help = "Opciones generales de MobInfo"; }

end
