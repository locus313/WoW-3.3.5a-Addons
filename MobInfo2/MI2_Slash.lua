--
-- MI2_Slash.lua
--
-- Handle all slash commands and the actions performed by slash commands.
-- All option dialog settings use slash commands for performing their
-- actions.
--
-- Note: version history now located in ReadMe.txt
--

local MI2_DeleteMode = ""

-- defaults for all MobInfo config options
local MI2_TTDefaults = {
	ShowHealth=1, ShowMana=0, ShowXp=1, ShowNo2lev=1, ShowKills=0, ShowLoots=1, ShowTotal=1, 
	ShowCoin=0, ShowIV=0, ShowEmpty=0, ShowLowHpAction=1, ShowCloth=1, ShowDamage=1,
	ShowDps=1, ShowLocation=1, ShowQuality=1, ShowResists=1, ShowImmuns=1, ShowItems=1,
	ShowClothSkin=1, ShowIGrey=0, ShowIWhite=1, ShowIGreen=1, ShowIBlue=1, ShowIPurple=1 } 


-----------------------------------------------------------------------------
-- MI2_SlashAction_Default()
--
-- Default tooltip content settings
--
function MI2_SlashAction_Default()
	local idx, def
	for idx,def in pairs(MI2_TTDefaults) do
		MobInfoConfig[idx] = def
	end
end -- MI2_SlashAction_Default


-----------------------------------------------------------------------------
-- MI2_SlashAction_AllOn()
--
-- Show all tooltip content
--
function MI2_SlashAction_AllOn()
	local idx,def
	for idx,def in pairs(MI2_TTDefaults) do
		MobInfoConfig[idx] = 1
	end
end -- MI2_SlashAction_AllOn


-----------------------------------------------------------------------------
-- MI2_SlashAction_AllOff()
--
-- Show no extra info in tooltip
--
function MI2_SlashAction_AllOff()
	local idx,def
	for idx,def in pairs(MI2_TTDefaults) do
		MobInfoConfig[idx] = 0
	end
end -- MI2_SlashAction_AllOff


-----------------------------------------------------------------------------
-- MI2_RegisterWithAddonManagers()
--
-- Register MobInfo with the KHAOS AddOn manager. This is a very simple
-- registration that merely creates a button to open the MobInfo options
-- dialog.
--
-- Register MobInfo with the myAddons manager.
--
-- Register with the EARTH AddOn manager.
--
function MI2_RegisterWithAddonManagers()

	-- register with myAddons manager
	if ( myAddOnsFrame_Register ) then
		local mobInfo2Details = {
		name = "MobInfo",
		version = miVersionNo,
		author = "Skeeve & Dizzarian",
		website = "http://www.dizzarian.com/forums/viewforum.php?f=16",
		category = MYADDONS_CATEGORY_OTHERS,
		optionsframe = "MI2_OptionsFrame"
		}
		myAddOnsFrame_Register( mobInfo2Details )
	end

	-- register with EARTH manager (mainly for Cosmos support)
	if EarthFeature_AddButton then
		EarthFeature_AddButton(
			{
				id = "MobInfo",
				name = "MobInfo",
				subtext = "v"..miVersionNo,
				tooltip = MI_DESCRIPTION,
				icon = "Interface\\CharacterFrame\\TemporaryPortrait-Monster",
				callback = function(state) MI2_SlashParse("") end
			}
		)
		if not MobInfoConfig.ShowMMButton then MobInfoConfig.ShowMMButton = 0 end

	-- register with KHAOS (only if EARTH not found)
	elseif Khaos then
		Khaos.registerOptionSet(
			"tooltip",
			{
				id = "MobInfoOptionSet",
				text = "MobInfo",
				helptext = MI_DESCRIPTION,
				difficulty = 1,
				callback = function(state) end,
				default = true,
				options = {
					{
						id = "MobInfoOptionsHeader",
						type = K_HEADER,
						difficulty = 1,
						text = MI_TXT_WELCOME,
						helptext = MI_DESCRIPTION
					},
					{
						id = "MobInfoOptionsButton",
						type = K_BUTTON,
						difficulty = 1,
						text = "MobInfo",
						helptext = "",
						callback = function(state) MI2_SlashParse("") end,
						feedback = function(state) end,
						setup = { buttonText = MI_TXT_OPEN }
					}
				}
			}
		)
		if not MobInfoConfig.ShowMMButton then MobInfoConfig.ShowMMButton = 0 end
	end
end  -- MI2_RegisterWithAddonManagers()


-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearTarget()
--
-- Clear MobInfo and MobHealth data for current target.
--
function MI2_SlashAction_ClearTarget()
	local index = MI2_Target.mobIndex
	if index then
		MI2_MobHealth_ClearTargetData()
		MI2_DeleteMobData( index )
		MI2_Target = {}
		MI2_OnTargetChanged()
		MI2_DbOptionsFrameOnShow()
		chattext( "data for target "..MI_Green..index..MI_White.." has been deleted" )
	end
end  -- MI2_SlashAction_ClearTarget()


-----------------------------------------------------------------------------
-- MI2_Slash_ClearDbConfirmed()
--
-- Clear database handler : clear specific database if reqzested and 
-- confirmed by user.
--
local function MI2_Slash_ClearDbConfirmed()
	if MI2_DeleteMode == "MobDb" then
		local curZoneName = MI2_ZoneTable[MI2_CurZone]
		MI2_DeleteAllMobData()
		MI2_ZoneTable[MI2_CurZone] = curZoneName
		MobInfoConfig.ImportSignature = ""
	elseif MI2_DeleteMode == "HealthDb" then
		MI2_MobHealth_Reset()
	elseif MI2_DeleteMode == "PlayerDb" then
		MobHealthPlayerDB = {}
	end
	chattext( "database deleted: "..MI2_DeleteMode )
	MI2_Target = {}
	MI2_OnTargetChanged()
	MI2_DbOptionsFrameOnShow()
	collectgarbage( "collect" )
end  -- MI2_Slash_ClearDbConfirmed()


-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearHealthDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
--
function MI2_SlashAction_ClearHealthDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearDbConfirmed
	MI2_DeleteMode = "HealthDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end  -- MI2_SlashAction_ClearHealthDb()


-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearPlayerDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
--
function MI2_SlashAction_ClearPlayerDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearDbConfirmed
	MI2_DeleteMode = "PlayerDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end  -- MI2_SlashAction_ClearPlayerDb()


-----------------------------------------------------------------------------
-- MI2_SlashAction_ClearMobDb()
--
-- Clear entire contents of MobInfo and MobHealth databases.
-- Ask for confirmation before performing the clear operation.
--
function MI2_SlashAction_ClearMobDb()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_CLR_ALL_CONFIRM.."'"..MI2_OPTIONS[this:GetName()].help.."' ?"
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_ClearDbConfirmed
	MI2_DeleteMode = "MobDb"
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end  -- MI2_SlashAction_ClearMobDb()


-----------------------------------------------------------------------------
-- MI2_Slash_TrimDownConfirmed()
--
-- Trim down the contents of the mob info database by removing all data
-- that is not set as being recorded. This function is called when the
-- user confirms the delete confirmation.
--
local function MI2_Slash_TrimDownConfirmed()
	-- loop through database and check each record
	-- remove all fields within the record where recording of the field is disabled
	for idx, mobInfo in pairs(MobInfoDB) do
		if  MobInfoConfig.SaveBasicInfo == 0 then
			mobInfo.bi = nil
			mobInfo.ml = nil
		end
		if  MobInfoConfig.SaveQualityData == 0 then
			mobInfo.qi = nil
		end
		if  MobInfoConfig.SaveItems == 0 then
			mobInfo.il = nil
		end
		if  MobInfoConfig.SaveResist == 0 then
			mobInfo.re = nil
		end
		if  MobInfoConfig.SaveCharData == 0 then
			MI2_RemoveCharData( mobInfo )
		end
	end

	if  MobInfoConfig.SaveItems == 0 then
		MI2_ItemNameTable = {}
	end

	-- char table can be deleted when not saving char specific data
	if  MobInfoConfig.SaveCharData == 0 then
		MI2_CharTable = { charCount = 0 }
	end

	-- force a cleanup after trimming down
	MI2_ClearMobCache()
	MI2_CheckAndCleanDatabases()
	collectgarbage( "collect" )

	MI2_DbOptionsFrameOnShow()
end -- MI2_Slash_TrimDownConfirmed()


-----------------------------------------------------------------------------
-- MI2_SlashAction_TrimDownMobData()
--
-- Trim down the contents of the mob info database by removing all data
-- that is not set as being recorded. Ask for a confirmation before
-- actually deleting anything.
--
function MI2_SlashAction_TrimDownMobData()
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = MI_TXT_TRIM_DOWN_CONFIRM
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_Slash_TrimDownConfirmed
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end  -- MI2_SlashAction_TrimDownMobData()


-----------------------------------------------------------------------------
-- MI2_UpdateMob()
--
-- Update a specific existing mob by adding to it the given new Mob data.
--
local function MI2_UpdateMob( mobIndex, newMobInfo )
	local existingMobInfo = MobInfoDB[mobIndex]
	local existingMobData, newMobData = {}, {}
	MI2_GetMobDataFromMobInfo( existingMobInfo, existingMobData )
	MI2_GetMobDataFromMobInfo( newMobInfo, newMobData )
	MI2_AddTwoMobs( existingMobData, newMobData )
	MI2_StoreAllMobData( existingMobData, nil, nil, MI2_PlayerName, mobIndex )
end -- MI2_UpdateMob()

-----------------------------------------------------------------------------
-- MI2_AdaptImportLocation()
--
-- Adapt the location info of an imported Mob. This is only necessary for
-- Mobs in instances, because instances are not available in the WoW
-- zone tables.
--
local function MI2_AdaptImportLocation( mobInfo, importZoneTable )
	-- decode mob location information
	local mobData = {}
	MI2_DecodeMobLocation( mobInfo, mobData )
	local loc = mobData.location
	if not loc or not loc.z then return end

	-- find correct zone name
	local zone = mobData.location.z
	local zoneName = importZoneTable[zone]

	-- update the mobs location info
	if zoneName and zoneName ~= "" then
		MI2_SetNewZone( zoneName )
		importZoneTable[MI2_CurZone] = zoneName
		mobInfo.ml = (loc.x1 or "").."/"..(loc.y1 or "").."/"..(loc.x2 or "").."/"..(loc.y2 or "").."//"..MI2_CurZone
	else
		mobInfo.ml = nil
	end
end -- MI2_AdaptImportLocation()


-----------------------------------------------------------------------------
-- MI2_SlashAction_ImportMobData()
--
-- Import externally supplied MobInfo database into own database.
--
function MI2_SlashAction_ImportMobData()
	local newMobs, updatedMobs, newHealth, newItems = 0, 0, 0, 0
	local mobIndex, mobInfo, healthInfo
	local oldCurZone = MI2_CurZone

	chattext( " starting external database import ...." )

	-- import loot items into main loot item database
	for itemId, itemInfo in pairs(MI2_ItemNameTable_Import) do
		if not MI2_ItemNameTable[itemId] then
			MI2_ItemNameTable[itemId] = itemInfo
			newItems = newItems + 1
		end
	end

	-- import health data into main Mob health database
	for mobIndex, newHealthData in pairs(MobHealthDB_Import) do
	    local oldHealthData = MobHealthDB[mobIndex]
		if not oldHealthData then
			MobHealthDB[mobIndex] = newHealthData
			newHealth = newHealth + 1
		else
		    local _, oldPct = MI2_HpDecode( oldHealthData )
		    local _, newPct = MI2_HpDecode( newHealthData )
		    if newPct and oldPct and newPct > 90 and newPct > oldPct then
				MobHealthDB[mobIndex] = newHealthData
				newHealth = newHealth + 1
		    end
		end
	end

	-- swap name/id in zone name table
	if MI2_ZoneTable_Import.cnt then
		local zoneName, zoneId
		local newTable = {}
		MI2_ZoneTable_Import.cnt = nil
		for zoneName, zoneId in pairs(MI2_ZoneTable_Import) do
			newTable[zoneId] = zoneName
		end
		MI2_ZoneTable_Import = newTable
	end

	-- import Mobs into main Mob database
	for mobIndex, mobInfo in pairs(MobInfoDB_Import) do
		MI2_RemoveCharData( mobInfo )
		MI2_AdaptImportLocation( mobInfo, MI2_ZoneTable_Import )
		if MobInfoDB[mobIndex] then
			updatedMobs = updatedMobs + 1
			if MobInfoConfig.ImportOnlyNew == 0 then
				-- import Mob that already exists
				MI2_UpdateMob( mobIndex, mobInfo )
			end
		else
			-- import unknown Mob
			MobInfoDB[mobIndex] = mobInfo
			newMobs = newMobs + 1
		end
	end

	-- update item cross reference table after import
	if MobInfoConfig.ImportOnlyNew == 0 then
		MI2_BuildXRefItemTable()
	end

	-- restore current zone ID after import
	MI2_CurZone = oldCurZone

	chattext( " imported "..newMobs.." new Mobs" )
	chattext( " imported "..newHealth.." new health values" )
	chattext( " imported "..newItems.." new loot items" )
	if MobInfoConfig.ImportOnlyNew == 0 then
		chattext( " updated data for "..updatedMobs.." existing Mobs" )
	else
		chattext( " did NOT update data for "..updatedMobs.." existing Mobs" )
	end

	-- update database options frame
	MobInfoConfig.ImportSignature = MI2_Import_Signature
	MI2_DbOptionsFrameOnShow()
end  -- MI2_SlashAction_ImportMobData()


-----------------------------------------------------------------------------
-- MI2_SlashAction_DeleteSearch()
--
-- Delete all Mobs in the search result list from the MobInfo database.
-- This function will ask for confirmation before deleting.
--
function MI2_SlashAction_DeleteSearch()
	local confirmationText = string.format( MI_TXT_DEL_SEARCH_CONFIRM, MI2_NumMobsFound )
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].text = confirmationText
	StaticPopupDialogs["MOBINFO_CONFIRMATION"].OnAccept = MI2_DeleteSearchResultMobs
	local dialog = StaticPopup_Show( "MOBINFO_CONFIRMATION", "")
end -- MI2_SlashAction_DeleteSearch()


-----------------------------------------------------------------------------
-- MI2_SlashInit()
--
-- Add all Slash Commands
--
function MI2_SlashInit()
	SlashCmdList["MOBINFO"] = MI2_SlashParse
	SLASH_MOBINFO1 = "/mobinfo" 
	SLASH_MOBINFO2 = "/mobinfo2" 
	SLASH_MOBINFO3 = "/mi2" 
end  -- MI2_SlashInit()


-----------------------------------------------------------------------------
-- MI2_SlashParse()
--
-- Parses the msg entered as a slash command. This function is also used
-- for the internal purpose of setting all options in the options dialog.
-- When used by the options dialog there is no need to actually update the
-- dialog, which is indicated by the "updateOptions" parameter.
--
function MI2_SlashParse( msg )
	-- extract option name and option argument from message string
	local _, _, cmd, param = string.find( string.lower(msg), "([%w_]*)[ ]*([-%w]*)") 
	
	-- handle all simple commands that dont require parsing right here
	-- handle show/hide of options dialog first of all
	if  not cmd  or  cmd == ""  or  cmd == "config"  then
		if MI2_OptionsFrame:IsVisible() then
			MI2_OptionsFrame:Hide()
		else
			MI2_OptionsFrame:Show()
		end
		return
	elseif cmd == 'version' then
		chattext( ' MobInfo-2 Version '..miVersionNo )
		return
	elseif cmd == 'update' and MI2_UpdatePrices then
		MI2_UpdatePrices()
		return
	elseif cmd == 'help' then
		chattext( ' Usage: enter /mobinfo2 or /mi2 to open interface' )
		chattext( ' for AddOn help go to '..MI_LightGreen..'http://www.dizzarian.com/forums/viewforum.php?f=16' )
		return
	end

	-- search for the option data structure matching the command
	local optionName, optionData
	for idx, val in pairs(MI2_OPTIONS) do
		local lower_opt = string.lower( idx )
		local optionCommand = string.sub(lower_opt, 8)
		if cmd == lower_opt or cmd == optionCommand then
			optionName = string.sub(idx, 8)
			optionData = val
			break
		end
	end

	-- now call the option handler for the more complex commands
	if  optionData  then
		MI2_OptionParse( optionName, optionData, param )
	end
end -- of MI2_SlashParse()


-----------------------------------------------------------------------------
-- MI2_OptionParse()
--
-- Parses the more complex option toggle/set commands. There are 4
-- categories of options:
--   * options that can toggle between an on and off state
--   * options that represent a numeric value
--   * options that represent a text
--   * options that activate a special functionality represented by a
--     handler function that must correspond to a specific naming convention
--
function MI2_OptionParse( optionName, optionData, param )
	-- handle the option according to its option type: its either a
	-- switch being toggleg, a value being set, or a special action
	if optionData.val then
		-- it is a slider setting a value
		-- get new option value from parameter and set it
		local optValue = tonumber( param ) or 0
		MobInfoConfig[optionName] = optValue
		if  updateOptions  then
			chattext( optionData.text.." : "..MI_Green..optValue )
		end

	elseif optionData.txt then
		-- it is a text based option
		MobInfoConfig[optionName] = param
		if  updateOptions  then
			chattext( optionData.text.." : "..MI_Green..param )
		end

	elseif  MobInfoConfig[optionName]  then
		-- it is a switch toggle option:
		-- get current option value and toggle it to the opposite state (On<->Off)
		local valTxt = { val0 = "-OFF-",  val1 = "-ON-" }
		local optValue = MobInfoConfig[ optionName ]
		optValue = 1 - optValue  -- toggle option
		MobInfoConfig[optionName] = optValue
		if optionData.text and optionData.text ~= "" then
			chattext( optionData.text.." : "..MI_Green..valTxt["val"..optValue] )
		end

		-- some toggle switches control recording options which in turn controls events
		MI2_InitializeEventTable()
	else
		-- special action commands have a corresponding handler function
		local actionHandlerName = "MI2_SlashAction_"..optionName
		local actionHandler = getglobal( actionHandlerName )
		if  actionHandler  then
			actionHandler()
			updateOptions = true -- for AllOn, AllOff, etc.
		end
	end

	-- update position and visibility of minimap button
	-- (80/80 is circle radius, 50/52 is circle center)
	if optionName == "MMButtonPos" then
		local pos = MobInfoConfig.MMButtonPos
		MI2_MinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT",50 - (80 * cos(pos)), (80 * sin(pos)) - 52 )
	end
	if MobInfoConfig.ShowMMButton == 1 then
		MI2_MinimapButton:Show()
	else
		MI2_MinimapButton:Hide()
	end

	-- update everything that might depend on config actions
	MI2_MobHealth_SetPos()
	MI2_UpdateOptions()
	MI2_SetupTooltip()
end  -- MI2_OptionParse()
