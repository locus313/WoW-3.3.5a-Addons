--
-- MI2_Config.lua
--
-- Configuration dialog related module of the MobInfo AddOn
--

MI2_OPTIONS["MI2_OptShowClass"] 	= { text=MI_TXT_CLASS; help=MI_HLP_CLASS }
MI2_OPTIONS["MI2_OptShowHealth"]	= { data="healthText"; text=MI_TXT_HEALTH; help=MI_HLP_HEALTH }
MI2_OPTIONS["MI2_OptShowMana"] 		= { data="manaText"; text=MI_TXT_MANA; help=MI_HLP_MANA }
MI2_OPTIONS["MI2_OptShowKills"]		= { data="kills"; text=MI_TXT_KILLS; help=MI_HLP_KILLS }
MI2_OPTIONS["MI2_OptShowLoots"] 	= { data="loots"; text=MI_TXT_LOOTS; help=MI_HLP_LOOTS }
MI2_OPTIONS["MI2_OptShowCoin"] 		= { data="avgCV"; t=1; text=MI_TXT_COINS; help=MI_HLP_COINS }
MI2_OPTIONS["MI2_OptShowIV"] 		= { data="avgIV"; t=1; text=MI_TXT_ITEMVAL; help=MI_HLP_ITEMVAL }
MI2_OPTIONS["MI2_OptShowTotal"] 	= { data="avgTV"; t=1; text=MI_TXT_MOBVAL; help=MI_HLP_MOBVAL }
MI2_OPTIONS["MI2_OptShowXp"] 		= { data="xp"; text=MI_TXT_XP; help=MI_HLP_XP }
MI2_OPTIONS["MI2_OptShowNo2lev"] 	= { data="mob2Level"; text=MI_TXT_TO_LEVEL; help=MI_HLP_TO_LEVEL }
MI2_OPTIONS["MI2_OptShowEmpty"] 	= { data="emptyLoots"; text=MI_TXT_EMPTY_LOOTS; help=MI_HLP_EMPTY_LOOTS }
MI2_OPTIONS["MI2_OptShowCloth"] 	= { data="clothCount"; text=MI_TXT_CLOTH_DROP; help=MI_HLP_CLOTH_DROP }
MI2_OPTIONS["MI2_OptShowDamage"] 	= { data="dmgText"; t=2; text=MI_TXT_DAMAGE; help=MI_HLP_DAMAGE }
MI2_OPTIONS["MI2_OptShowDps"] 		= { data="dps"; text="DPS"; help=MI_HLP_DPS }
MI2_OPTIONS["MI2_OptShowLocation"]	= { data="loc"; t=3; text=MI_TXT_LOCATION; help=MI_HELP_LOCATION }
MI2_OPTIONS["MI2_OptShowQuality"]	= { data="qualityStr"; opt=MI_OPT_QUALITY; text=MI_TXT_QUALITY; help=MI_HLP_QUALITY }
MI2_OPTIONS["MI2_OptShowLowHpAction"] = { text=MI_TXT_LOWHEALTH; help=MI_HELP_LOWHEALTH }
MI2_OPTIONS["MI2_OptShowResists"]	= { data="resStr"; opt=MI_OPT_RESISTS; text=MI_TXT_RESISTS; help=MI_HELP_RESISTS }
MI2_OPTIONS["MI2_OptShowImmuns"]	= { data="immStr"; text=MI_TXT_IMMUN; help="" }
MI2_OPTIONS["MI2_OptShowItems"]		= { text=MI_TXT_ITEMLIST; help=MI_HELP_ITEMLIST } 
MI2_OPTIONS["MI2_OptShowClothSkin"]	= { text=MI_TXT_CLOTHSKIN; help=MI_HELP_CLOTHSKIN }


-----------------------------------------------------------------------------
-- MI2_OptionsFrameOnLoad()
--
-- This "OnLoad" event handler for the options dialog installs the
-- ESC key handler.
--
function MI2_OptionsFrameOnLoad()
	tinsert(UISpecialFrames, "MI2_OptionsFrame") -- Esc Closes Options Frame
	UIPanelWindows["MI2_OptionsFrame"] = {area = "center", pushable = 0}

	PanelTemplates_SetNumTabs( MI2_OptionsTabFrame, 5 )
	MI2_OptionsTabFrame.selectedTab = 5
	PanelTemplates_UpdateTabs( MI2_OptionsTabFrame )

	MI2_TxtOptionsTitle:SetText( "MobInfo "..miVersionNo )
	
--	MI2_OptShowCombined:Disable()
--	MI2_OptShowCombinedText:SetTextColor( 0.5,0.5,0.5 )

	MI2_MainOptionsFrame = MI2_OptionsTabFrame
end  -- MI2_OptionsFrameOnLoad()


-----------------------------------------------------------------------------
-- MI2_UpdateOptions()
--
-- Update state of all options in options dialog with correct values from
-- data structure "MobInfoConfig".
--
function MI2_UpdateOptions()
	if MobInfoConfig.ShowMobInfo == 1 then
		MI2_OptUseGameTT:Enable()
		MI2_OptUseGameTTText:SetTextColor( 1.0,0.8,0.0 )
	else
		MI2_OptUseGameTT:Disable()
		MI2_OptUseGameTTText:SetTextColor( 0.5,0.5,0.5 )
	end

	local index, value
	for index, value in pairs(MI2_OPTIONS) do
		local option = string.sub(index,8)
		local control = getglobal(index)
		if  control and MobInfoConfig[option] then
			if value.dd then
				-- do nothing for dropdowns
			elseif value.val then
				control:SetValue( MobInfoConfig[option] )
			elseif value.txt then
				control:SetText( MobInfoConfig[option] )
			elseif control.SetChecked then
				control:SetChecked( MobInfoConfig[option] )
			end
		end
	end
end  -- MI2_UpdateOptions()


-----------------------------------------------------------------------------
-- MI2_ShowOptionHelpTooltip()
--
-- Show help text for current hovered option in options dialog
-- in the game tooltip window.
--
function MI2_ShowOptionHelpTooltip()
	GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )
	GameTooltip:SetText( MI_White..MI2_OPTIONS[this:GetName()].text )
	  
	GameTooltip:AddLine(MI_Gold..MI2_OPTIONS[this:GetName()].help)
	if MI2_OPTIONS[this:GetName()].info then
		GameTooltip:AddLine(MI_Gold..MI2_OPTIONS[this:GetName()].info)
	end
	GameTooltip:Show()
end -- of MI2_ShowOptionHelpTooltip()


-----------------------------------------------------------------------------
-- MI2_OptionsFrameOnShow()
--
-- Show help text for current hovered option in options dialog
-- in the game tooltip window.
--
function MI2_OptionsFrameOnShow()
	MI2_UpdateOptions()
	MI2_TooltipAnchor:SetFrameStrata( "HIGH" )
	MI2_UpdateAnchor()
end  -- MI2_OptionsFrameOnShow()


function miConfig_OnMouseDown()
	if arg1 == "LeftButton" then
		this:StartMoving()
	end
end


function miConfig_OnMouseUp()
	if arg1 == "LeftButton" then
		this:StopMovingOrSizing()
	end
end


function MI2_DoneButton_OnClick()
	HideUIPanel(MI2_OptionsFrame)
	if MYADDONS_ACTIVE_OPTIONSFRAME then
		if (MYADDONS_ACTIVE_OPTIONSFRAME == this) then
			ShowUIPanel(myAddOnsFrame)
		end
	end
end

-----------------------------------------------------------------------------
-- MI2_TabButton_OnClick()
--
-- Event handler: one of the options dialog TABs has been clicked.
-- Show the corresponding options frame and hide all other option frames.
--
function MI2_TabButton_OnClick( self )
	PanelTemplates_Tab_OnClick( self, MI2_OptionsTabFrame )
	local selected = MI2_OptionsTabFrame.selectedTab

	-- choose special information frame if mob health has been disabled
	local healthFrame = MI2_TargetOptionsFrame
	if  MobInfoConfig.DisableHealth == 2  then
		healthFrame = MI2_FrmHealthDisabledInfo
	end

	if  selected == 1  then
		MI2_TooltipOptionsFrame:Show()
	else
		MI2_TooltipOptionsFrame:Hide()
	end
	if  selected == 2  then
		healthFrame:Show()
	else
		healthFrame:Hide()
	end
	if  selected == 3  then
		MI2_DatabaseOptionsFrame:Show()
	else
		MI2_DatabaseOptionsFrame:Hide()
	end
	if  selected == 4  then
		MI2_SearchOptionsFrame:Show()
	else
		MI2_SearchOptionsFrame:Hide()
	end
	if  selected == 5  then
		MI2_GeneralOptionsFrame:Show()
	else
		MI2_GeneralOptionsFrame:Hide()
	end
end


-----------------------------------------------------------------------------
-- MI2_OptTargetFont_OnClick()
--
-- Event handler: one of the choices in the font selection box has been
-- clicked. Store it as a config option.
--
function MI2_OptTargetFont_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID( MI2_OptTargetFont )
	UIDropDownMenu_SetSelectedID( MI2_OptTargetFont, this:GetID())
	if  oldID ~= this:GetID()  then
		MobInfoConfig.TargetFont = this:GetID()
		MI2_MobHealth_SetPos()
	end
end  -- MI2_OptTargetFont_OnClick()


-----------------------------------------------------------------------------
-- MI2_OptItemsQuality_OnClick()
--
-- Event handler: one of the choices in the items quality dropdown has been
-- clicked. Store it as a config option.
--
function MI2_OptItemsQuality_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID( MI2_OptItemsQuality )
	UIDropDownMenu_SetSelectedID( MI2_OptItemsQuality, this:GetID())
	if  oldID ~= this:GetID()  then
		MobInfoConfig.ItemsQuality = this:GetID()
	end
end  -- MI2_OptItemsQuality_OnClick()


-----------------------------------------------------------------------------
-- MI2_OptTooltipMode_OnClick()
--
-- Event handler: one of the choices in the tooltip mode dropdown has been
-- clicked. Store it as a config option.
--
function MI2_OptTooltipMode_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID( MI2_OptTooltipMode )
	UIDropDownMenu_SetSelectedID( MI2_OptTooltipMode, this:GetID())
	if  oldID ~= this:GetID()  then
		MobInfoConfig.TooltipMode = this:GetID()
	end
	MI2_SetupTooltip()
end  -- MI2_OptTooltipMode_OnClick()


-----------------------------------------------------------------------------
-- MI2_DropDown_Initialize()
--
-- Initialize a dropdown list with entries that are retrieved from the
-- localization info.
--
function MI2_DropDown_Initialize()
	if string.sub(this:GetName(),-6) ~= "Button" then return end
	
	local dropDownName = string.sub(this:GetName(),1,-7)
	local choice = MI2_OPTIONS[dropDownName].choice1
	local count = 1

	while choice do
		local info = { text = choice, value = count, func = getglobal(dropDownName.."_OnClick") }
		UIDropDownMenu_AddButton( info )
		count = count + 1
		choice = MI2_OPTIONS[dropDownName]["choice"..count] 
	end
end  -- MI2_DropDown_Initialize()


-----------------------------------------------------------------------------
-- MI2_DropDown_OnShow()
--
-- Event handler: show a drop down list
-- Ensure that current selection is shown correctly.
--
function MI2_DropDown_OnShow(self)
	local frameName = self:GetName()
	local itemName = string.sub(frameName, 8)
	local text=MI2_OPTIONS[frameName]["choice"..MobInfoConfig[itemName]]

	UIDropDownMenu_SetSelectedID( self, MobInfoConfig[itemName] )
	UIDropDownMenu_SetText( self, text ) 
end  -- MI2_DropDown_OnShow()


-----------------------------------------------------------------------------
-- MI2_DbOptionsFrameOnShow()
--
--
function MI2_DbOptionsFrameOnShow()
	local mobDbSize, healthDbSize, playerDbSize, itemDbSize = 0, 0, 0, 0

	-- count and diplay size of MobInfo database
	for index in pairs(MobInfoDB) do  mobDbSize = mobDbSize + 1  end
	MI2_TxtMobDbSize:SetText( MI_TXT_MOB_DB_SIZE..MI_White..(mobDbSize-1) )

	-- count and diplay size of MobHealth database
	for index in pairs(MobHealthDB) do  healthDbSize = healthDbSize + 1  end
	MI2_TxtHealthDbSize:SetText( MI_TXT_HEALTH_DB_SIZE..MI_White..healthDbSize )

	-- count and diplay size of MobHealthPlayer database
	for index in pairs(MobHealthPlayerDB) do  playerDbSize = playerDbSize + 1  end
	MI2_TxtPlayerDbSize:SetText( MI_TXT_PLAYER_DB_SIZE..MI_White..playerDbSize )

	-- count and diplay size of MI2_ItemNameTable database
--	for  index in MI2_ItemNameTable  do  itemDbSize = itemDbSize + 1  end
--	MI2_TxtItemDbSize:SetText( MI_TXT_ITEM_DB_SIZE..MI_White..itemDbSize )

	-- update mob index display and state of "clear mob" button
	if MI2_Target.mobIndex and MobInfoDB[MI2_Target.mobIndex] then
		MI2_OptClearTarget:Enable()
		MI2_TxtTargetIndex:SetText( MI_TXT_CUR_TARGET..MI_White..MI2_Target.mobIndex )
	else
		MI2_OptClearTarget:Disable()
		MI2_TxtTargetIndex:SetText( MI_TXT_CUR_TARGET..MI_White.."---" )
	end

	-- update import status
	if MI2_Import_Status then
		if MobInfoConfig.ImportSignature == MI2_Import_Signature then
			MI2_OptImportMobData:Disable()
			MI2_TxtImportStatus:SetText( "Status: <data already imported ("..MI2_Import_Status..")>" )
		elseif MI2_Import_Status == "BADVER" then
			MI2_OptImportMobData:Disable()
			MI2_TxtImportStatus:SetText( "Status: <import database too old for import>" )
		elseif MI2_Import_Status == "BADLOC" then
			MI2_OptImportMobData:Disable()
			MI2_TxtImportStatus:SetText( "Status: <import database has wrong language (locale)>" )
		else
			MI2_OptImportMobData:Enable()
			MI2_TxtImportStatus:SetText( "Status: "..MI2_Import_Status.." available for import" )
		end
	else
		MI2_OptImportMobData:Disable()
		MI2_TxtImportStatus:SetText( "Status: <no import data>" )
	end
end  -- MI2_DbOptionsFrameOnShow()

