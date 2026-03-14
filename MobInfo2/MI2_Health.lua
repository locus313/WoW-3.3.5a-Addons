--
-- MI2_Health.lua
--
-- Mob health callculation module of MobInfo-2 AddOn
--
-- Mob health is calculated from the damage that a mob receives
-- in relation to the changes in mob health percentage. Damage
-- is observed through the WoW "UnitCombat" event, Health is
-- observed through the WoW "UnitHealth" event.
--
-- This module now implements a totally new health calculation
-- algorithm with an inctredible acuracy.
--


-- remember previous font type and font size
local lOldFontId = 0
local lOldFontSize = 0

local MI2_HpPctList, MI2_HpDmg, MI2_HpData


-----------------------------------------------------------------------------
-- MI2_HpDecode()
--
function MI2_HpDecode( hpData )
	local _,_, pts, pct = string.find(hpData, "^(%d+)/(%d+)$")
	pts = tonumber( pts )
	pct = tonumber( pct )
	return pts, pct
end  -- MI2_HpDecode()


-----------------------------------------------------------------------------
-- external	functions for macros / scripts
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- MobHealth_GetTargetCurHP()
--
-- Return current health points	value for the current target as	an integer
-- value. Return nil if	there is no	current	target.
--
-- Example:
--	 local targetCurrentHealth = MobHealth_GetTargetCurHP()
--	 if	 targetCurrentHealth  then
--		.......
--	 end
--
function MobHealth_GetTargetCurHP()
	return MI2_Target.curHealth
end	 --	of MobHealth_GetTargetCurHP()


-----------------------------------------------------------------------------
-- MobHealth_GetTargetMaxHP()
--
-- Return maximum health points	value for the current target as	an integer
-- value. Return nil if	there is no	current	target.
--
-- Example:
--	 local targetMaxHealth = MobHealth_GetTargetMaxHP()
--	 if	 targetMaxHealth  then
--		.......
--	 end
--
function MobHealth_GetTargetMaxHP()
	return MI2_Target.maxHealth
end	 --	of MobHealth_GetTargetMaxHP()


-----------------------------------------------------------------------------
-- MobHealth_PPP( index	)
--
-- Return the Points-Per-Percent (PPP) value for a Mob identified by its index.
-- The index is	the	concatination of the Mob name and the Mob level	(see
-- example below). 0 is	returned if	the	PPP	value is not available for
-- the given index.	The	example	also shows how to calculate	the	actual
-- health points from the health percentage	and	the	PPP	value
--
-- Example:
--	  local	name  =	UnitName("target")
--	  local	level =	UnitLevel("target")
--	  local	index =	name..":"..level
--	  local	ppp	= MobHealth_PPP( index )
--	  local	healthPercent =	UnitHealth("target")
--	  local	curHealth =	floor(	healthPercent *	ppp	+ 0.5)
--	  local	maxHealth =	floor(	100	* ppp +	0.5)
--
function MobHealth_PPP( index )
	if	index and MobHealthDB[index]  then
		local pts, pct = MI2_HpDecode( MobHealthDB[index] )
		if pts and pct and pct ~= 0 then
			return pts / pct
		end
	end
	return 0
end

function MI2_GetHealth_PPP( index )
	if	index then
		local pts, pct
		if MobHealthDB[index]  then
			pts, pct = MI2_HpDecode( MobHealthDB[index] )
		elseif MobHealthPlayerDB[index]  then
			pts, pct = MI2_HpDecode( MobHealthPlayerDB[index] )
		end
		if pts and pct and pct ~= 0 then
			return pts / pct
		end
	end
	return 0
end


-----------------------------------------------------------------------------
-- end of external functions for macros / scripts
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- MI2_HpGet()
--
local function MI2_HpGet( database, index )
	if not database[index] then return nil,0 end

	local pts, pct = MI2_HpDecode( database[index] )

	local quality
	if pct == 200 then
	    quality = 3
	    pts = pts / 2
	elseif pct == 100 then
	    quality = 2
	elseif pct and pts then
	    quality = 1
	    pts = floor(pts * 100 / pct + 0.5)
	else
		return nil,0
	end

	return pts, quality
end  -- MI2_HpGet()


-----------------------------------------------------------------------------
-- MI2_HpSet()
--
local function MI2_HpSet( database, index, hpMax, quality )
	local pct, pts
	hpMax = floor(hpMax + 0.51)
	if quality == 3 then
		pct = 200
		pts = hpMax * 2
	elseif quality == 2 then
		pct = 100
		pts = hpMax
	else
		pct = 50
		pts = floor(hpMax / 2 + 0.51)
	end
--midebug( "writing HP to DB: new=["..pts.."/"..pct.."], old=["..(database[index] or "nil").."], hpm="..hpMax..", q="..quality, 1 )
	database[index] = pts.."/"..pct
end  -- MI2_HpSet()


-----------------------------------------------------------------------------
-- MI2_HpSetNewTarget()
--
-- Update the health/mana display for the target frame because the target
-- has changed.
--
function MI2_HpSetNewTarget()
	MI2_Target.unitHealth = UnitHealth("target")
	MI2_HpData = { totalDmg=0, newQuality=0 }
	if MI2_Target.unitHealth > 0 and MI2_Target.healthDB then
		MI2_HpDmg = {}
		MI2_HpPctList = {}

		-- read max hp from database
		MI2_HpData.dbMax, MI2_HpData.dbQuality = MI2_HpGet( MI2_Target.healthDB, MI2_Target.index )

		-- initialise health calculation and show health in target frame
		MI2_Target.showHealth = 1
		if MI2_Target.unitHealth == 100 then
			tinsert( MI2_HpPctList, {100,0} )
			MI2_HpData.newQuality = 2
		else
			MI2_HpData.newQuality = 1
		end
		MI2_RecordTargetHealth( MI2_Target.unitHealth )
	else
		MobHealth_Display()
	end
end -- MI2_HpSetNewTarget()


-----------------------------------------------------------------------------
-- MobHealth_Display()
--
-- display the values and percentage for health	/ mana in target frame
--
function MobHealth_Display( )
	-- nothing to do if showing is disabled
	if MobInfoConfig.ShowTargetInfo ~= 1 then return end

	-- create health and percent text if showing is enabled
	local healthText, manaText
	if  MobInfoConfig.TargetHealth == 1 and MI2_Target.maxHealth then
	    if MI2_HpData.dbQuality == 3 then
			healthText = string.format("%d // %d", MI2_Target.curHealth, MI2_Target.maxHealth )
		else
			healthText = string.format("%d / %d", MI2_Target.curHealth, MI2_Target.maxHealth )
		end
	end

	local health = MI2_Target.unitHealth or 0
	if	MobInfoConfig.HealthPercent	== 1 and health > 0 then
		if healthText then
			healthText = healthText..string.format(" (%d%%)", health )
		else
			healthText = string.format("%d%%", health )
		end
	end

	-- create mana text based on mana show flags
	local maxmana =	UnitManaMax("target")
	if maxmana > 0 then
		local mana = UnitMana("target")
		if MobInfoConfig.TargetMana == 1 then
			manaText = string.format("%d / %d", mana, maxmana )
		end
		if MobInfoConfig.ManaPercent == 1 then
			if manaText then
				manaText = manaText..string.format(" (%d%%)", floor(100.0 * mana / maxmana))
			else
				manaText = string.format("%d%%", floor(100.0 * mana / maxmana))
			end
		end
	end

	MI2_MobHealthText:SetText( healthText or "" )
	MI2_MobManaText:SetText( manaText or "" )
end	 --	MobHealth_Display()


-----------------------------------------------------------------------------
-- MI2_MobHealth_SetFont()
--
-- set new font	for	display	of health /	mana in	target frame
--
local function MI2_MobHealth_SetFont( fontId, fontSize )
	local fontName

	if fontId ~= lOldFontId or fontSize ~= lOldFontSize then
		lOldFontId = fontId
		lOldFontSize = fontSize

		-- select font name	to use
		if	fontId == 1	 then
			fontName = "Fonts\\ARIALN.TTF"  -- NumberFontNormal
		elseif	fontId == 2	 then
			fontName = "Fonts\\FRIZQT__.TTF"	 --	GameFontNormal
		else
			fontName = "Fonts\\MORPHEUS.TTF"	 --	ItemTextFontNormal
		end

		-- set font	for	health and mana	text
		MI2_MobHealthText:SetFont( fontName, fontSize )
		MI2_MobManaText:SetFont( fontName, fontSize )
	end

end	 --	of MI2_MobHealth_SetFont()


-----------------------------------------------------------------------------
-- MI2_MobHealth_SetPos()
--
-- set position	and	font for mob health/mana texts
--
function MI2_MobHealth_SetPos( )
	local font

	-- set poition for health	and	mana text
	MI2_MobHealthText:SetPoint( "TOP", "TargetFrameHealthBar", "BOTTOM", MobInfoConfig.HealthPosX, MobInfoConfig.HealthPosY )
	MI2_MobManaText:SetPoint( "TOP", "TargetFrameManaBar", "BOTTOM", MobInfoConfig.ManaPosX, MobInfoConfig.ManaPosY )

	-- update	font ID	and	font size
	MI2_MobHealth_SetFont( MobInfoConfig.TargetFont, MobInfoConfig.TargetFontSize )

	-- update visibility of target frame info
	if MobInfoConfig.ShowTargetInfo == 1 and MobInfoConfig.DisableHealth ~= 2 then
		MI2_MobHealthFrame:Show()
	else
		MI2_MobHealthFrame:Hide()
	end

	-- redisplay health / mana values
	MobHealth_Display()
end	 --	of MI2_MobHealth_SetPos()


-----------------------------------------------------------------------------
-- MI2_MobHealth_Reset()
--
function MI2_MobHealth_Reset()
	MI2_MobHealth_ClearTargetData()
	MobHealthDB	= {}
	MobHealthPlayerDB =	{}
end


-----------------------------------------------------------------------------
-- MI2_SaveTargetHealthData()
--
-- Save health data for current target in health database
--
function MI2_SaveTargetHealthData( updateOnly )
	-- nothing to do if there is no health data
	if MI2_HpData == nil then return end
	
    local newHpMax = MI2_HpData.newMax
    local newQuality = MI2_HpData.newQuality

	if newHpMax and newQuality and newQuality >= MI2_HpData.dbQuality then
	    if MI2_HpData.pct and MI2_HpData.pct < 10 then newQuality = 1 end
		if newQuality == MI2_HpData.dbQuality and newQuality < 3 then
		    local delta = newHpMax / 100 + 1
		    if MI2_HpData.dbQuality == 1 or abs(MI2_HpData.dbMax - newHpMax) > delta then
				newHpMax = (MI2_HpData.dbMax + newHpMax) / 2
			else
   			    newHpMax = max(MI2_HpData.dbMax, newHpMax)
			end
		end
		MI2_HpSet( MI2_Target.healthDB, MI2_Target.index, newHpMax, newQuality )
	end
end -- MI2_SaveTargetHealthData()


-----------------------------------------------------------------------------
-- MI2_MobHealth_ClearTargetData()
--
-- Clear mob health data for current target
--
function MI2_MobHealth_ClearTargetData()
	if MI2_Target.index then
		MI2_Target.healthDB[MI2_Target.index] = nil
		MI2_Target = {}
		MobHealth_Display()
		MI2_HpData = nil
	end
end  -- MI2_MobHealth_ClearTargetData()


-----------------------------------------------------------------------------
-- MI2_CalculateHp()
--
-- This function implements the new algorithm for calculating
-- a Mobs maximum health points.
--
local function MI2_CalculateHp()
	local numDmg = getn( MI2_HpDmg )
	local numPct = getn( MI2_HpPctList )
	if numPct < 2 or numDmg < 2 then return end

	local firstPct = MI2_HpPctList[1][1]
	local lastPct = MI2_HpPctList[numPct][1]
	local deltaPct = firstPct - lastPct
	local dmg1 = MI2_HpDmg[MI2_HpPctList[numPct][2]]
	local dmg2 = (MI2_HpDmg[MI2_HpPctList[numPct][2]+1] or dmg1)
	local hpm1 = dmg1 * 100 / deltaPct
	local hpm2 = dmg2 * 100 / deltaPct
	MI2_HpData.pct = deltaPct

	local hpm1Count = 0
	local hpm2Count = 0
	local hpm1Delta = (hpm1 / 50) + 1
	local hpm2Delta = (hpm2 / 50) + 1
	for i=2,(numPct-1) do
		local dmg = MI2_HpDmg[MI2_HpPctList[i][2]]
		if dmg then
			local pct = MI2_HpPctList[i][1]
			local hpm = dmg * 100 / (firstPct - pct)
			if abs(hpm-hpm1) < hpm1Delta then hpm1Count = hpm1Count + 1 end
			if abs(hpm-hpm2) < hpm2Delta then hpm2Count = hpm2Count + 1 end
		end
	end

	local hpm, hpmCount, hpmDelta
	if hpm2Count > hpm1Count then
		hpm = hpm2
		hpmCount = hpm2Count
		hpmDelta = hpm2Delta
 	else
		hpm = hpm1
		hpmCount = hpm1Count
		hpmDelta = hpm1Delta
    end

    if not MI2_HpData.maxCount or hpmCount >= MI2_HpData.maxCount then
        MI2_HpData.maxCount = hpmCount
		if MI2_HpData.newMax and abs(hpm-MI2_HpData.newMax) < hpmDelta then
			MI2_HpData.newMax = max( hpm, MI2_HpData.newMax )
		else
			MI2_HpData.newMax = hpm
		end
	end
end --MI2_CalculateHp()


-----------------------------------------------------------------------------
-- MI2_RecordTargetCombat()
--
function MI2_RecordTargetCombat( damage, isHeal )
	if isHeal then
		MI2_HpData.totalDmg = max( (MI2_HpData.totalDmg-damage), 0 )
	else
		MI2_HpData.totalDmg = MI2_HpData.totalDmg + damage
	end
	if MI2_HpData.totalDmg > 0 then
		tinsert( MI2_HpDmg, MI2_HpData.totalDmg )
		if MI2_HpData.pctAdded then
			MI2_CalculateHp()
			MI2_HpData.pctAdded = nil
		end
	end
end


-----------------------------------------------------------------------------
-- MI2_RecordTargetHealth()
--
function MI2_RecordTargetHealth( health )
	if not MI2_HpData.dbQuality then return end -- can happen when there is no healthDB

	MI2_Target.unitHealth = UnitHealth("target")

	-- check if BeastLore effect is active or not
	local unitHpMax = UnitHealthMax("target")
	if unitHpMax ~= 100 then
		MI2_HpData.newMax = unitHpMax
		MI2_HpData.newQuality = 3
		MI2_HpData.pctAdded = nil
		MI2_Target.unitHealth = floor(100.0 * health / MI2_HpData.newMax + 0.5)
		MI2_Target.curHealth = health
		MI2_Target.maxHealth = unitHpMax
	else
		if MI2_HpData.newQuality < 3 and health > 1 and health < 100 then
			tinsert( MI2_HpPctList, {health,getn(MI2_HpDmg)} )
			MI2_HpData.pctAdded = true
		end
		local hpMax = (MI2_HpData.newMax or MI2_HpData.dbMax)
		if hpMax then
			if MI2_HpData.dbQuality < 2 or not MI2_Target.maxHealth then
				MI2_Target.maxHealth = floor(hpMax + 0.5)
				if MI2_HpData.dbQuality < 1 then
				    MI2_SaveTargetHealthData( true )
				end
			end
			MI2_Target.curHealth = floor((MI2_Target.maxHealth * health) / 100 + 0.5)
		end
	end

	MobHealth_Display()
end
