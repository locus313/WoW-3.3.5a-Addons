--
-- MI2_Tooltip.lua
--
-- Tooltip handling functions for the MobInfo AddOn.
--

local MI2_FontHeight, MI2_MaxTextWidth, MI2_MaxValWidth, MI2_OffsetX, MI2_OffsetY, MI2_Anchor, MI2_CowFade
local MI2_TooltipOptions = {}
local MI2_MaxNumLines = 20
local MI2_MaxNumItems = 20
local MI2_IsMoving = 0
local MI2_HideTimer, MI2_Tick, MI2_Skip = 0, 0, 0


-----------------------------------------------------------------------------
-- MI2_InitializeTooltip()
--
-- One time initialization of tooltip, will be called from event "VARIABLES_LOADED"
--
function MI2_InitializeTooltip()
	MI2_TooltipFrame:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
									edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
									tile = true, tileSize = 24, edgeSize = 12, 
									insets = { left=4, right=4, top=4, bottom=4 } } )
	MI2_TooltipFrame:SetBackdropColor( 0, 0, 0, 0.8 )
	MI2_TooltipFrame:SetBackdropBorderColor( 0.5, 0, 0, 1 )

	MI2_TooltipFrame:SetClampedToScreen( true )

	for idx=1,MI2_MaxNumLines do
		local text = getglobal( "MI2TT_Text"..idx )
		local val = getglobal( "MI2TT_Val"..idx )
		text.val = val
	end
	MI2_UpdateAnchor()
end


-----------------------------------------------------------------------------
-- MI2_UpdateAnchor()
--
-- Update visibility of tooltip anchor based on whether optiosn window is
-- open and how the show anchor flag is set.
--
function MI2_UpdateAnchor()
	local showAnchor = MI2_OptionsFrame:IsVisible() == 1 or (MobInfoConfig.HideAnchor == 0 and MobInfoConfig.UseGameTT == 0) 
	if showAnchor then
		MI2_TooltipAnchor:Show()
	else
		MI2_TooltipAnchor:Hide()
	end

	-- set tooltip anchoring position
	MI2_TooltipFrame:ClearAllPoints()
	if MobInfoConfig.TooltipMode == 1 then
		MI2_TooltipFrame:SetPoint( "BOTTOMLEFT", MI2_TooltipAnchor, "TOPLEFT" )
	elseif MobInfoConfig.TooltipMode == 2 then
		MI2_TooltipFrame:SetPoint( "TOPLEFT", MI2_TooltipAnchor, "BOTTOMLEFT" )
	elseif MobInfoConfig.TooltipMode == 3 then
		MI2_TooltipFrame:SetPoint( "BOTTOMRIGHT", MI2_TooltipAnchor, "TOPRIGHT" )
	elseif MobInfoConfig.TooltipMode == 5 then
		MI2_TooltipFrame:SetPoint( "BOTTOM", MI2_TooltipAnchor, "TOP" )
	elseif MobInfoConfig.TooltipMode == 6 then
		MI2_TooltipFrame:SetPoint( "TOP", MI2_TooltipAnchor, "BOTTOM" )
	else
		MI2_TooltipFrame:SetPoint( "TOPRIGHT", MI2_TooltipAnchor, "BOTTOMRIGHT" )
	end
end -- MI2_UpdateAnchor


-----------------------------------------------------------------------------
-- MI2_TooltipAnchorOnEnter()
--
function MI2_TooltipAnchorOnEnter()
	if MI2_MouseoverIndex and MobInfoConfig.UseGameTT == 0 then
		MI2_IsMoving = 0
		MI2_HideTimer = 9
		MI2_UpdateAnchor()
		MI2_TooltipFrame:SetAlpha(1)
		MI2_TooltipFrame:Show()
	end
end -- MI2_TooltipAnchorOnEnter


-----------------------------------------------------------------------------
-- MI2_TooltipAnchorOnLeave()
--
function MI2_TooltipAnchorOnLeave()
	MI2_HideTimer = 1.4
end -- MI2_TooltipAnchorOnLeave


-----------------------------------------------------------------------------
-- MI2_SetupTooltip()
--
-- Basic setup of tooltip after changing a tooltip configuration option.
--
function MI2_SetupTooltip()
	MI2_TooltipFrame:Hide()
	MI2_MouseoverIndex = nil

	-- initialise the extra tooltip entries
	MI2_OptShowDps:SetChecked( MI2_OptShowDamage:GetChecked() )
	MI2_OptShowImmuns:SetChecked( MI2_OptShowResists:GetChecked() )

	-- build list of tooltip options to be displayed in the tooltip	
	MI2_TooltipOptions = {}
	local children = { MI2_FrmTooltipContent:GetChildren() }
	for idx, child in pairs(children) do
	    local opt = MI2_OPTIONS[child:GetName()]
		if child.GetChecked and child:GetChecked() and opt.data then
			table.insert( MI2_TooltipOptions, opt )
		end
	end

	-- set tooltip font size
	ttfont = GameFontNormal
	if MobInfoConfig.SmallFont == 1 then
		ttfont = GameFontNormalSmall
	end
	for idx=1,MI2_MaxNumLines do
		getglobal("MI2TT_Text"..idx):SetFontObject(ttfont)
		getglobal("MI2TT_Val"..idx):SetFontObject(ttfont)
	end
	for idx=1,MI2_MaxNumItems do
		getglobal("MI2TT_Item"..idx):SetFontObject(ttfont)
	end

	-- calculate font height and columns width limitations based on font
	local fontName, fontHeight, fontFlags = MI2TT_Text1:GetFont()
	MI2_FontHeight = fontHeight
	MI2TT_Text1:SetText( "AAAAAA" )
	MI2_MaxTextWidth = MI2TT_Text1:GetWidth()
	MI2_MaxValWidth = MI2_MaxTextWidth * 1.3

	if TipTac_Config then
		TipTac_Config.showTip = (MobInfoConfig.OtherTooltip == 0)
	end
end -- MI2_SetupTooltip


-----------------------------------------------------------------------------
-- MI2_StartTooltipMouseMove()
--
-- Initiate moving the mobinfo tooltip together with mouse movement. The
-- trick it to set the anchor correctly so that when "StartMoving()" is
-- called in "OnUpdate()" the tooltip is at exactly the right position.
--
local function MI2_StartTooltipMouseMove()
	MI2_TooltipFrame:ClearAllPoints()
	if MobInfoConfig.TooltipMode == 1 then
		MI2_Anchor = "BOTTOMLEFT"
		MI2_OffsetX, MI2_OffsetY = 10, 5
	elseif MobInfoConfig.TooltipMode == 2 then
		MI2_Anchor = "TOPLEFT"
		MI2_OffsetX, MI2_OffsetY = 20, -15
	elseif MobInfoConfig.TooltipMode == 3 then
		MI2_Anchor = "BOTTOMRIGHT"
		MI2_OffsetX, MI2_OffsetY = -10, 5
	elseif MobInfoConfig.TooltipMode == 4 then
		MI2_Anchor = "TOPRIGHT"
		MI2_OffsetX, MI2_OffsetY = -5, -15
	elseif MobInfoConfig.TooltipMode == 5 then
		MI2_Anchor = "BOTTOM"
		MI2_OffsetX, MI2_OffsetY = 5, 20
	elseif MobInfoConfig.TooltipMode == 6 then
		MI2_Anchor = "TOP"
		MI2_OffsetX, MI2_OffsetY = 5, -25
	end
	MI2_IsMoving = 1
end -- MI2_StartTooltipMouseMove


-----------------------------------------------------------------------------
-- MI2_UpdateTooltipHealth()
--
-- set position of MobInfo tooltip based on mouse position
--
local function MI2_MouseMove()
	-- calculate position and take into account UI scaling
	local scale = UIParent:GetEffectiveScale()
	local x,y = GetCursorPosition()
	x = (x + MI2_OffsetX) / scale
	y = (y + MI2_OffsetY) / scale
--midebug("ox="..MI2_OffsetX..", oy="..MI2_OffsetY..", a="..MI2_Anchor..", s="..scale)
	MI2_TooltipFrame:SetPoint( MI2_Anchor, UIParent, "BOTTOMLEFT", x, y )
end -- MI2_MouseMove

-----------------------------------------------------------------------------
-- MI2_UpdateTooltipHealth()
--
-- update health/mana shown within MobInfo tooltip while tooltip is shown
-- for the "mouseover" unit
--
local function MI2_UpdateTooltipHealth()
	if not UnitExists("mouseover") then return end
	local mobData = {}
	MI2_GetUnitBasedMobData( MI2_MouseoverIndex, mobData, "mouseover" )
	if MI2TT_Text1:GetText() == MI_TXT_HEALTH then
		MI2TT_Text1.val:SetText(mobData.healthText)
	end
	if MI2TT_Text2:GetText() == MI_TXT_MANA then
		MI2TT_Text1.val:SetText(mobData.healthText)
	end
end -- MI2_UpdateTooltipHealth


-----------------------------------------------------------------------------
-- MI2_TooltipOnUpdate()
--
-- OnUpdate is called periodically (about 20 times per second) by the WoW
-- client. This handler starts and stope moving the tooltip along with the
-- mouse, and also handles tooltip fadeout.
--
function MI2_TooltipOnUpdate( time )
	-- half second action ticker : use it to update health/mana in tooltip
	MI2_Tick = MI2_Tick + time
	if MI2_Tick > 0.5 then
		MI2_Tick = 0
		MI2_UpdateTooltipHealth()
		if MI2_IsMoving == 2 then
			MI2_HideTooltip()
		end
	end

	if MI2_IsMoving > 0 then
		MI2_MouseMove()
		if MI2_IsMoving == 1 and not UnitExists("mouseover") then
			MI2_Tick = 0.35
			MI2_IsMoving = 2
		end
	elseif  MI2_HideTimer < 4.0 then
		MI2_HideTimer = MI2_HideTimer - time
		if  MI2_HideTimer < 1.0 then
			MI2_TooltipFrame:SetAlpha( MI2_HideTimer )
			if MI2_HideTimer < 0.1 then
				MI2_HideTooltip()
			end
		end
	elseif not UnitExists("mouseover") and MI2_HideTimer < 6.0 then
		MI2_HideTimer = 1.4
	end
end -- MI2_TooltipOnUpdate


-----------------------------------------------------------------------------
-- MI2_TooltipMouseoverUnit()
--
function MI2_TooltipMouseoverUnit()
	if MobInfoConfig.ShowMobInfo == 0 then  return  end
	if MobInfoConfig.KeypressMode == 1 and not IsAltKeyDown() then  return  end
	--if  UnitIsPlayer("mouseover") or UnitIsFriend("player","mouseover") or not UnitCanAttack("player","mouseover") then  return  end
	if  UnitIsPlayer("mouseover") then  return  end
	local isMob = not(UnitIsPlayer("mouseover") or UnitIsFriend("player","mouseover") or not UnitCanAttack("player","mouseover"))
	MI2_CreateTooltip( UnitName("mouseover"), UnitLevel("mouseover"), "mouseover", isMob )
	MI2_HideTimer = 5
end


-----------------------------------------------------------------------------
-- MI2_EntryToString()
--
-- return the correct textual representation for a mob data item
-- conversions are performed depending on the type code of the data item
--
local function MI2_EntryToString( type, data, mobData, unit )
	local value = mobData[data]
	if type == 1 and value then
		return copper2text( value )
	elseif type == 2 and (mobData.minDamage or mobData.maxDamage) then
		return (mobData.minDamage or 0).."-"..(mobData.maxDamage or 0)
	elseif type == 3 and mobData.location then
		local loc = mobData.location
		if unit then
			return MI2_ZoneTable[loc.z]
		else
			local x = floor((loc.x1 + loc.x2)/2)
			local y = floor((loc.y1 + loc.y2)/2)
			return MI2_ZoneTable[loc.z].." ("..x.."/"..y..")"
		end
	elseif type == 4 then
		return mobData.ttItems[data]
	else
		return value
	end
end -- MI2_EntryToString


-----------------------------------------------------------------------------
-- MI2_UpdateGameTooltip()
--
-- Add info about Mob to the standard game tooltip
--
local function MI2_UpdateGameTooltip( mobData, mobName, unit )
	if not unit then
		GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )
		GameTooltip:ClearLines()
		GameTooltip:AddLine( mobData.levelInfo..mobName )
		GameTooltip:AddLine( " " )
	end

	if mobData.class then
		local txt = GameTooltipTextLeft2:GetText()
		if txt then
			GameTooltipTextLeft2:SetText( txt.." "..mobData.class )
		end
	end

	local opt, value, itemText
	for idx = 1, MI2_MaxNumLines do
		opt = MI2_TooltipOptions[idx]
		if opt then
			value = MI2_EntryToString( opt.t, opt.data, mobData, unit )
			if value then
				if opt.data == "qualityStr" or opt.data == "loc" then
					GameTooltip:AddLine( opt.text..": "..MI_White..value )
				else
					GameTooltip:AddDoubleLine( opt.text, MI_White..value )
				end
			end
		end
	end
	for idx = 1, MI2_MaxNumItems do
		itemText = MI2_EntryToString( 4, idx, mobData )
		if itemText then
			GameTooltip:AddLine( itemText )
		end
	end
	if GameTooltip:NumLines() > 1 and mobData.lowHpAction then
		GameTooltipTextLeft2:SetText( GameTooltipTextLeft2:GetText().." "..MI_LightRed..MI2_TXT_MOBRUNS )
	end
	GameTooltip:Show()
end -- MI2_UpdateGameTooltip


-----------------------------------------------------------------------------
-- MI2_FillTooltipWithData()
--
local function MI2_FillTooltipWithData( mobData, unit )
	local opt, value, entry, itemText

	-- fill in the extra tooltip info
	MI2TT_ExtraInfo1:SetText( mobData.extraInfo[1] or "" )
	MI2TT_ExtraInfo2:SetText( mobData.extraInfo[2] or "" )
	MI2TT_ExtraInfo3:SetText( mobData.extraInfo[3] or "" )
	MI2TT_ExtraInfo4:SetText( mobData.extraInfo[4] or "" )

	-- fill the columns
	local numEntries=0
	for idx = 1, MI2_MaxNumLines do
		opt = MI2_TooltipOptions[idx]
		if opt then
			value = MI2_EntryToString( opt.t, opt.data, mobData, unit )
			if value then
				numEntries = numEntries + 1
				entry = getglobal( "MI2TT_Text"..numEntries )
				entry:SetText( opt.text )
				entry.val:SetText( value )
				entry:Show()
				entry.val:Show()
			end
		end
	end

	-- hide all the unused tooltip columns
	for idx = numEntries+1, MI2_MaxNumLines do
		entry = getglobal( "MI2TT_Text"..idx )
		entry:Hide()
		entry.val:Hide()
	end

	-- fill the loot items lines
	for idx = 1, MI2_MaxNumItems do
		entry = getglobal( "MI2TT_Item"..idx )
		itemText = MI2_EntryToString( 4, idx, mobData )
		if itemText then
			entry:SetText( itemText )
			entry:Show()
		else
			entry:Hide()
		end
	end
	
	return numEntries
end -- MI2_FillTooltipWithData


-----------------------------------------------------------------------------
-- MI2_UpdateTooltip()
--
-- This will update the contents of the MobInfo Tooltip with the data for
-- a specific given Mob. It includes tooltip content layouting based on
-- the size of the entries
--
local function MI2_UpdateTooltip( mobData, mobName, unit )
	if MobInfoConfig.UseGameTT == 1 then return end

	-- set mob name/level/type/class
	MI2TT_MobLevel:SetText( mobData.levelInfo )
	MI2TT_MobName:SetText( mobName )
	MI2TT_MobName:SetTextColor( GameTooltip_UnitColor("mouseover") )
	MI2TT_ClassInfo:SetText( mobData.classInfo )
	local nameWidth = MI2TT_MobLevel:GetStringWidth() + MI2TT_MobName:GetStringWidth()
	local classWidth = MI2TT_ClassInfo:GetStringWidth()
	MI2_TooltipFrame:SetBackdropBorderColor( GameTooltip_UnitColor("mouseover") )

	numEntries = MI2_FillTooltipWithData( mobData, unit )

	-- arrange tooltip layout 
	local colWidth = {0,0,0,0,0,0}
	local ttHeight = MI2_FontHeight
	local right = false
	for idx = 1, numEntries do
		entry = getglobal( "MI2TT_Text"..idx )
		txtWidth = entry:GetStringWidth() 
		valWidth = entry.val:GetStringWidth()
		if right and valWidth < MI2_MaxValWidth then
			entry:SetPoint( "TOPLEFT", MI2TT_Col3, "TOPLEFT", 0, ttHeight )
			entry.val:SetPoint( "TOPLEFT", MI2TT_Col4, "TOPLEFT", 0, ttHeight )
			if txtWidth > colWidth[3] then colWidth[3] = txtWidth end
			if valWidth > colWidth[4] then colWidth[4] = valWidth end
			right = false
		else
			ttHeight = ttHeight - MI2_FontHeight
			entry:SetPoint( "TOPLEFT", MI2TT_Col1, "TOPLEFT", 0, ttHeight )
			entry.val:SetPoint( "TOPLEFT", MI2TT_Col2, "TOPLEFT", 0, ttHeight )
			right = valWidth < MI2_MaxValWidth and MobInfoConfig.CompactMode == 1
			if txtWidth > colWidth[1] then colWidth[1] = txtWidth end
			if right then
				if valWidth > colWidth[2] then colWidth[2] = valWidth end
			else
				if valWidth > colWidth[5] then colWidth[5] = valWidth end
			end
		end
	end

	-- align the tooltip columns
	-- use last extra info line for anchoring the mob data columns
	local numExtraLines = #mobData.extraInfo
	if numExtraLines > 0 then
		local above = getglobal("MI2TT_ExtraInfo"..numExtraLines)
		MI2TT_Col1:SetPoint( "TOPLEFT", above, "BOTTOMLEFT", 0, -2 )
	else
		MI2TT_Col1:SetPoint( "TOPLEFT", MI2TT_ClassInfo, "BOTTOMLEFT", 0, -2 )
	end
	MI2TT_Col2:SetPoint( "TOPLEFT", MI2TT_Col1, "TOPLEFT", colWidth[1], 0 )
	MI2TT_Col3:SetPoint( "TOPLEFT", MI2TT_Col2, "TOPLEFT", colWidth[2] + 4, 0 )
	MI2TT_Col4:SetPoint( "TOPLEFT", MI2TT_Col3, "TOPLEFT", colWidth[3], 0 )

	-- arrange loot items layout
	MI2TT_Item1:SetPoint( "TOPLEFT", MI2TT_Col1, "BOTTOMLEFT", 0, ttHeight - MI2_FontHeight )
	for idx = 1, MI2_MaxNumItems do
		entry = getglobal( "MI2TT_Item"..idx )
		if entry:IsShown() then
			ttHeight = ttHeight - MI2_FontHeight
			txtWidth = entry:GetStringWidth() 
			if txtWidth > colWidth[6] then colWidth[6] = txtWidth end
		end
	end

	-- set tooltip width and height
	ttHeight = -ttHeight + 26 + MI2_FontHeight + (numExtraLines * MI2_FontHeight)
	if mobData.classInfo then
		ttHeight = ttHeight + MI2_FontHeight
	end
	local ttWidth = colWidth[2] + colWidth[3] + colWidth[4]
	if colWidth[5] > ttWidth then ttWidth = colWidth[5] end
	ttWidth = ttWidth + colWidth[1]
	if colWidth[6] > ttWidth then ttWidth = colWidth[6] end
	if nameWidth > ttWidth then ttWidth = nameWidth end
	if classWidth > ttWidth then ttWidth = classWidth end
	ttWidth = ttWidth + 12

	MI2_TooltipFrame:SetWidth( ttWidth )
	MI2_TooltipFrame:SetHeight( ttHeight )
	MI2_TooltipFrame:SetAlpha(1)
	MI2_TooltipFrame:Show()
end -- MI2_UpdateTooltip


-----------------------------------------------------------------------------
-- MI2_CreateTooltip()
--
function MI2_CreateTooltip( name, level, unit, isMob )
	local mobIndex = name..":"..level
	local mobData = MI2_BuildTooltipMob( name, level, unit, isMob )
	if unit and isMob then
		MI2_RecordLocationAndType( mobIndex, mobData )
	end
	MI2_MouseoverIndex = mobIndex -- must be set after calling MI2_RecordLocationAndType

	MI2_HideTimer = 9.0
	if MobInfoConfig.UseGameTT == 1 then
		MI2_UpdateGameTooltip( mobData, name, unit )
	else
		--MI2_CowText = CowTip:IsModuleActive("Text")
		--CowTip:ToggleModuleActive("Text", false)

		-- hide other tooltip if requested
		if MobInfoConfig.OtherTooltip == 1 then
			-- special CowTip support
			if CowTip and unit then
				MI2_CowFade = CowTip.options.args.CowTip_Fade.child_get("units")
				CowTip.options.args.CowTip_Fade.child_set("units", "hide")
			end
			GameTooltip:Hide()
		end
		-- anchor MobInfo tooltip either at mouse or at anchor frame
		if MobInfoConfig.MouseTooltip == 1 and unit then
			MI2_StartTooltipMouseMove()
		else
			MI2_UpdateAnchor()
		end
		MI2_UpdateTooltip( mobData, name, unit )
	end
end -- MI2_CreateTooltip


-----------------------------------------------------------------------------
-- MI2_HideTooltip()
--
function MI2_HideTooltip()
	MI2_TooltipFrame:Hide()
	MI2_IsMoving = 0 
	GameTooltip:Hide()
	if MI2_CowFade then
		CowTip.options.args.CowTip_Fade.child_set("units", MI2_CowFade)
		MI2_CowFade = nil
	end
end -- MI2_HideTooltip()

