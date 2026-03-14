MobInfo-2 is a World of Warcraft AddOn that provides you with useful additional information about Mobs (ie. opponents/monsters). It adds new information to the game's Tooltip whenever you hover with your mouse over a mob. It also adds a numeric display of the Mobs health and mana (current and max) to the Mob target frame. MobInfo-2 is the continuation of the now abandoned "MobInfo" by Dizzarian combined with the original "MobHealth2" by Wyv. 

[[ IMPORTANT NOTE FOR DEVELOPERS OF OTHER ADDONS:           ]]
[[ Please read the informatin in "ReadMe_MobInfo_API.txt" ! ]]


*****************************
***     MobInfo-2 Data    ***
*****************************
MobInfo collects data whenever you fight a Mob. It starts off with an empty database, which fills up automatically the more you fight and play. The data it collects is used for enhancing the game tooltip and the game target frame. It is also available to other AddOns (mostly the mob/target health values).

NEW FEATURE: The MobInfo database has become searchable. You can do a search for the 12 most profitable Mobs. You will find the "Search" button on the "Database" page of the options dialog.


******************************************
*** Extra Information For Game Tooltip ***
******************************************
The extra information available to show on the game tooltip is:

Class - class of mob
Health - current and total health of the mob
Mana - current and total mana of the mob
Damage - min/max damage range of Mob against you (stored per char)
DPS - your DPS (damage per second) against the Mob (stored per char)
Kills - number of times you have killed the mob (stored per char)
Total Looted - number of times you have looted the mob
Empty Loots - number of times you found empty loot on the mob
XP - actual LAST xp amount you gained from the mob
# to Level - number of kills of this mob neede to gain a level
Quality - the quality of items that are dropped by the mob
Cloth drops - the number of times cloth has dropped on the mob
Avg Coin Drop - average amount of money dropped by the mob
Avg Item Value - average vendor value of items dropped by mob
Total Mob Value - total sum of avg coin drop and avg item value

Note that MobInfo offers a "Combined Mode" where the data of Mobs with the same name that only differ in level gets combined (added up) into one tooltip. This mode can be enabled through the options dialog


***************************************
*** Target Frame Health/Mana Values ***
***************************************
MobInfo can display the numeric and percentage values for your current targets health and mana right on the target frame (formerly known as MobHealth functionality). This display is highly configurable through the MobInfo options dialog (position, font, size, etc).


******************************
*** MobInfo Options Dialog ***
******************************
Type "/mi2" or "/mobinfo2" on the chat prompt to open the MobInfo options dialog. This dialog gives you full interactive control over EVERYTHING that MobInfo can do. All options take immediate effect. Simply try them all out. Decent defaults get set when you start MobInfo for the first time. Note that the 3 main categories "Tooltip", "Mob Health/Mana", and "Database Maintenance" have separate dedicated options pages within the options dialog.

Note that everything in the options dialog has an associated help text that explains to you what the option does. The help texts are shown automatically as a tooltip.


*******************************************
*** How to Backup your MobInfo database ***
*******************************************
It is very IMPORTANT to make occasional (even better: regular) backups of your MobInfo database. I have received several reports of users where due to whatever likely or unlikely incident the original MobInfo database got lost or erased or erased or currupted. It is unlikely and happens only very rarely, but when it happens your only chance to recover is to have a backup of the MobInfo database.

The entire MobInfo database is contained within this onr file:
   World of Warcraft\WTF\Account\<your_account_name>\SavedVariables\MobInfo.lua

First of all please logout of WoW. This automagically saves all current AddOn data to disk. Then make a copy of the database file (the one specified above) to a save location. To restore the backed up data simply copy the backup file back to the original location.

Side note: this is also the file that you must pass on if you want to give your MobInfo database to someone else. Which of course means it is also the file you receive when someone else gives you their MobInfo database.


**********************************************
*** IMPORT of an External MobInfo Database ***
**********************************************
MobInfo can import externally supplied MobInfo databases. This can be a database from a friend of yours or a database that you have downloaded somewhere. WARNING : the database that you import MUST be from someone who uses exactly the same WoW localization as you do (ie. the same WoW client language). Importing a MobInfo database rom someone using a different WoW language will NOT work and might destroy your own database.

First of all before importing data you should make a backup of your own database. This is explained above in the chapter "How to Backup your MobInfo database". It never hurts to be able to restore your original data in case you are unhappy with the import result. 

Here are the detailed import instructions:

1) Close your WoW client

2) Backup your MobInfo database as explained above

3) Rename the database file that you want to import from "MobInfo.lua" to "MI2_Import.lua"

4) Copy the file "MI2_Import.lua" into this folder:
\World of Warcraft\Interface\AddOns\MobInfo\
(that is the folder where the AddOn has been installed)

5) Start WoW and login with one of your chars

6) Open the MobInfo options (enter "/mi2" at the chat prompt) and go to the "Database" options page. Near the bottom of the page you should now see whether the AddOn has found valid data to be imported. If you did everything correctly the "Import" button should be clickable.

7) Choose whether you want to import only unknown Mobs, otherwise all Mobs will get imported. If a Mob already exists in your database and you choose to import it the data of the new Mob will get added to the data of the existing Mob. Now click the Import button to star the database import operation. In your normal chat window you will see a summary of the import results.

8) Logout to cause WoW to save your now extended MobInfo database file. You should now delete the file "MI2_Import.lua". It is no longer needed and it will waste memory as long as it exists.

TIP : use the "import only unknown Mobs" if you know that there is a large amount of overlap between your current database and the imported database. For instance if you import data from the same source again (because he released a newer version).

TIP2 : You can also use this Import feature to import databases of the "MobHealth" AddOn. Use the instructions exactly as listed above, but in step 2 rename "MobHealth.lua" (the MobHealth database file from "savedvariables" folder) to "MI2_Import.lua".


***-----------------------------------------------***
***-----------------------------------------------***
      F. A. Q. - Frequently Asked Questions
***-----------------------------------------------***
***-----------------------------------------------***


******************************************************
** Where do the Mob health values come from ?
******************************************************
WoW itself does not allow AddOns to see the numeric health value of a Mob or other players. Instead WoW reports only a percentage value. To obtain a real maximum health value this value must be calculated, or more correctly approximated. That iss what MobInfo does. In order to do this you must fight the creature. During the fight the damage you do is reported as actual damage points. The current health of the Mob is reported as percentage values. From these values MobInfo calculates how much damage you are causing per percent change in health. The damage done per percent times 100 is the Mobs maximum health.

The method described above for approximating a Mobs health was first developed by "Telo" for his AddOn "MobHealth". It was then refined by "Wyv" for his own AddOn "MobHealth2". The MobInfo implementation stil is based on the same basic principle but uses a drastically improved mathematical approach.


******************************************************************
** How do I change tooltip position or tooltip popup behaviour ?
******************************************************************
MobInfo only adds information to the tooltip, but it does not modify where or how the tooltip appears. To change this there are a large number of real good tooltip controll AddOns available. I can't list them all here, but some of the better and more popular ones are: TipBuddy (http://ui.worldofwar.net/ui.php?id=607), AF Tooltip Extreme (http://ui.worldofwar.net/ui.php?id=2416), or TooltipsKhaos (part of Cosmos compilation: http://www.cosmosui.org/).


******************************************************************
** Why is there a vendor sell value table in MobInfo ?
** What does MobInfo do with its vendor sell value table for items ?
******************************************************************
MobInfo has always had an excellent and very extensive built-in vendor sell value table. This table was used for calculating mob loot value. Otherwise MobInfo would be unable to know the value of the loot items found on a Mob.

As of MobInfo 3.20 I have added the option that you can also use the vendor sell value table for showing the vendor sell value of items in the item tooltip. You can enable this on the MobInfo tooltip options page. Since this simply (re)uses the table thats already there for a second good purposes it was an easy and neat little feature to add.

When compared to special price or item data collecting AddOns there is one disadvantage to the MobInfo solution. MobInfo does not update its table in game. Personally I do not consider this important or necessary because vendor prices in game are rather static and the table is very extensive (some 11.000 prices). In fact the table within MobInfo is a combination of the tables found in: Auctioneer, PriceMaster, and WoW-Econ.

About once every half year I update the MobInfo table with the most up-to-date prices and add vendor prices for new items that have been found.



***-----------------------------------------------***
***-----------------------------------------------***
             MobInfo-2 Version History
***-----------------------------------------------***
***-----------------------------------------------***
3.75
  * changed: version is now repository keyword in developer working copy
  * updated: changelog

3.74
  * fixed: Fixed change for 3.2 PTR to work on 3.3 and above as well :-/

3.73
  * fixed: added changes for 3.2 PTR based on GetBuildInfo()

3.72
  * fixed: scroll error in search frame

3.71
  * fixed: added an old module into the system to tie it all together while I attempt to track down the bug.

3.70
  * fixed: A host of errors caused by the newest patch which resulted in cascading errors.  WoW now provides MobHealth info so I am slowly weaning the modules off of the calculated data.  This could cause random errors but I have yet to see any.  I am doing it this way to get a working mod out quicker and to avoid rewriting the entire thing.

3.61
  * fixed: kills for Mobs that give no XP were not being counted  
  * conversion support for "DropRate" data removed
  
3.60
  * updated to be compatible with WoW 2.40
  * fixed: Mob class not being shown correctly (thanks to Zergreth for heads up and the fix)
  * fixed: health values from Beast Lore will no longer get lost
  * fixed: show BeastLore extra info correctly in MobInfo tooltip
  * fixed: nil bug on line 304 when using CowTip			  

3.52
  * updated the MobInfo built-in item price table
  * show NPC profession in NPC tooltip
  * use unit interaction color (green, yellow, red) for MobInfo tooltip frame	  

3.51
  * fixed a nil bug when hovering over items in item search result
  * fixed : search result sort by item count did not sort correctly
  * fixed a bug causing NPCs to get added to the MobInfo database
  * improved search speed when searching for items
  * do not show class for NPCs
	  
3.50
  * support 4 new skinning loot items
  * show the MobInfo tooltip also for NPCs
  * new search page option: max times looted
  * MobInfo built-in search page now searches in the background without blocking	 		  
  * attempted to fix the bug where the looting rights line for corpses was not shown in the MobInfo tooltip
  * fixed nil bug when opening soft-shelled clam
	  

Known Problems / Limitations:
  * several localisations do not work and must be updated: TW, PL
  * localisations that urgently require updates: FR, ES


(for previous version info or any questions regarding MobInfo-2 please visit http://www.dizzarian.com/forums/viewforum.php?f=16)

