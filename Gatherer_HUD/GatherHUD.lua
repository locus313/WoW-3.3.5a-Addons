--[[
--	Gatherer Addon for World of Warcraft(tm).
--	HUD Plugin Module
--	Version: 3.1.16 (<%codename%>)
--	Revision: $Id: GatherHUD.lua 890 2010-10-18 03:12:50Z Esamynn $
--
--	License:
--	This program is free software; you can redistribute it and/or
--	modify it under the terms of the GNU General Public License
--	as published by the Free Software Foundation; either version 2
--	of the License, or (at your option) any later version.
--
--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--	GNU General Public License for more details.
--
--	You should have received a copy of the GNU General Public License
--	along with this program(see GPL.txt); if not, write to the Free Software
--	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
--
--	Note:
--		This AddOn's source code is specifically designed to work with
--		World of Warcraft's interpreted AddOn system.
--		You have an implicit licence to use this AddOn with these facilities
--		since that is it's designated purpose as per:
--		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

local routes_active = 0

if Routes then
	routes_active = 1
end

local Astrolabe = DongleStub(Gatherer.AstrolabeVersion)

local matrix = {
	perspective = 800,
	current  = { 1, 0, 0, 0, 1, 0, 0, 0, 1 },
	applying = { 1, 0, 0, 0, 1, 0, 0, 0, 1 },
	temp     = { 1, 0, 0, 0, 1, 0, 0, 0, 1 },
}

function matrix.identity()
	matrix.current[1] = 1;		matrix.current[2] = 0;		matrix.current[3] = 0;
	matrix.current[4] = 0;		matrix.current[5] = 1;		matrix.current[6] = 0;
	matrix.current[7] = 0;		matrix.current[8] = 0;		matrix.current[9] = 1;
end
function matrix.rotation_x(rx)
	matrix.applying[1] =             1; matrix.applying[2] =             0; matrix.applying[3] =             0;
	matrix.applying[4] =             0; matrix.applying[5] =  math.cos(rx); matrix.applying[6] =  math.sin(rx);
	matrix.applying[7] =             0; matrix.applying[8] = -math.sin(rx); matrix.applying[9] =  math.cos(rx);
	matrix.multiply()
end
function matrix.rotation_y(ry)
	matrix.applying[1] =  math.cos(ry); matrix.applying[2] =             0; matrix.applying[3] = -math.sin(ry);
	matrix.applying[4] =             0; matrix.applying[5] =             1; matrix.applying[6] =             0;
	matrix.applying[7] =  math.sin(ry); matrix.applying[8] =             0; matrix.applying[9] =  math.cos(ry);
	matrix.multiply()
end
function matrix.rotation_z(rz)
	matrix.applying[1] =  math.cos(rz); matrix.applying[2] =  math.sin(rz); matrix.applying[3] =             0;
	matrix.applying[4] =  math.sin(rz); matrix.applying[5] = -math.cos(rz); matrix.applying[6] =             0;
	matrix.applying[7] =             0; matrix.applying[8] =             0; matrix.applying[9] =             1;
	matrix.multiply()
end

-- note that this matrix multiply is set up backwards. It's writen as B*A instead of A*B (which is different in matricies)
-- the other way to view this is that it moves worldspace rather than objectspace
function matrix.multiply()
	matrix.temp[1] = matrix.current[1]*matrix.applying[1] + matrix.current[2]*matrix.applying[4] + matrix.current[3]*matrix.applying[7];
	matrix.temp[2] = matrix.current[1]*matrix.applying[2] + matrix.current[2]*matrix.applying[5] + matrix.current[3]*matrix.applying[8];
	matrix.temp[3] = matrix.current[1]*matrix.applying[3] + matrix.current[2]*matrix.applying[6] + matrix.current[3]*matrix.applying[9];

	matrix.temp[4] = matrix.current[4]*matrix.applying[1] + matrix.current[5]*matrix.applying[4] + matrix.current[6]*matrix.applying[7];
	matrix.temp[5] = matrix.current[4]*matrix.applying[2] + matrix.current[5]*matrix.applying[5] + matrix.current[6]*matrix.applying[8];
	matrix.temp[6] = matrix.current[4]*matrix.applying[3] + matrix.current[5]*matrix.applying[6] + matrix.current[6]*matrix.applying[9];

	matrix.temp[7] = matrix.current[7]*matrix.applying[1] + matrix.current[8]*matrix.applying[4] + matrix.current[9]*matrix.applying[7];
	matrix.temp[8] = matrix.current[7]*matrix.applying[2] + matrix.current[8]*matrix.applying[5] + matrix.current[9]*matrix.applying[8];
	matrix.temp[9] = matrix.current[7]*matrix.applying[3] + matrix.current[8]*matrix.applying[6] + matrix.current[9]*matrix.applying[9];

	matrix.current[1] = matrix.temp[1];		matrix.current[2] = matrix.temp[2];		matrix.current[3] = matrix.temp[3];
	matrix.current[4] = matrix.temp[4];		matrix.current[5] = matrix.temp[5];		matrix.current[6] = matrix.temp[6];
	matrix.current[7] = matrix.temp[7];		matrix.current[8] = matrix.temp[8];		matrix.current[9] = matrix.temp[9];
end

function matrix.multiply_2d(pointx, pointy, pointz)
	local x, y, z, scale
	x = pointx*matrix.current[1] + pointy*matrix.current[2] -- + point.z*matrix.current[3]
	y = pointx*matrix.current[4] + pointy*matrix.current[5] -- + point.z*matrix.current[6]
	z = pointx*matrix.current[7] + pointy*matrix.current[8] -- + point.z*matrix.current[9]
	scale = matrix.perspective / (-z + matrix.perspective)
	x = x * scale
	y = y * scale
	return x, y, scale
end


local lib = {}
Gatherer_HUD = lib

local private = {
	curNode = 0,
	maxNode = 0,
	nodes = {},
	heat = {},
	party_members = {},
	gridres = 250,	 -- grid units
	elapsed = 0,
	xScale = 0,
	yScale = 0,
	zScale = 0,
}
lib.Private = private

local get = Gatherer.Config.GetSetting

local frame

function lib.Load( self )
	frame = self
	lib.Frame = frame
	frame.me = Gatherer_Hud_Center
	frame.base = Gatherer_Hud_Base
	frame.heat = Gatherer_Hud_Heat
	frame.compass = CreateFrame("FRAME","Gatherer_Hud_Compass",UIParent)
	frame.compass:SetAllPoints()

	frame:RegisterEvent("PLAYER_ENTER_COMBAT")
	frame:RegisterEvent("PLAYER_LEAVE_COMBAT")
end

function lib.ProcessGameEvent( event )
	if event == "PLAYER_ENTER_COMBAT" then
		private.inCombat = 1;

	elseif event == "PLAYER_LEAVE_COMBAT" then
		private.inCombat = nil;

	end
end

function lib.UpdateStruture()
	local tpy = get("plugin.gatherer_hud.radius")/get("plugin.gatherer_hud.yards")
	
	if not (get("plugin.gatherer_hud.enable") and get("minimap.enable")) or private.hidden then
		frame:Hide()
	else
		frame:Show()
	end
	
	frame:SetPoint("CENTER", UIParent, "CENTER", get("plugin.gatherer_hud.offset.horizontal"), get("plugin.gatherer_hud.offset.vertical"))
	frame:SetWidth(get("plugin.gatherer_hud.radius")*2)
	frame:SetHeight(get("plugin.gatherer_hud.radius")*2)
	frame:SetAlpha(get("plugin.gatherer_hud.alpha")/100)
	local strata = get("plugin.gatherer_hud.strata")
	if (strata == 1) then
		frame:SetFrameStrata("BACKGROUND")
	elseif (strata == 2) then
		frame:SetFrameStrata("LOW")
	elseif (strata == 3) then
		frame:SetFrameStrata("MEDIUM")
	else
		frame:SetFrameStrata("HIGH")
	end
	
	frame.me:SetWidth(tpy*132)
	frame.me:SetHeight(tpy*132*(get("plugin.gatherer_hud.angle")/100)) -- adjusted later durring update
	if (get("plugin.gatherer_hud.center.enable")) then
		local color = get("plugin.gatherer_hud.center.color")
		local r, g, b, a = strsplit(",", tostring(color) or "0,0,0,1")
		r = tonumber(r) or 0
		g = tonumber(g) or 0
		b = tonumber(b) or 0
		a = tonumber(a) or 0
		frame.me:SetVertexColor(r,g,b,a)
		frame.me:Show()
	else
		frame.me:Hide()
	end
	
	frame.base:SetWidth(get("plugin.gatherer_hud.radius")*2.2)
	frame.base:SetHeight(get("plugin.gatherer_hud.radius")*2.2*(get("plugin.gatherer_hud.angle")/100)) -- adjusted later durring update
	if (get("plugin.gatherer_hud.base.enable")) then
		local color = get("plugin.gatherer_hud.base.color")
		local r, g, b, a = strsplit(",", tostring(color) or "0,0,0,1")
		r = tonumber(r) or 0
		g = tonumber(g) or 0
		b = tonumber(b) or 0
		a = tonumber(a) or 0
		frame.base:SetVertexColor(r,g,b,a)
		frame.base:Show()
	else
		frame.base:Hide()
	end
	
	if not get("plugin.gatherer_hud.heat.enable") then frame.heat:Hide()
	else frame.heat:Show() end
	
	local color = get("plugin.gatherer_hud.heat.color")
	local r, g, b, a = strsplit(",", tostring(color) or "0,0,0,1")
	a = tonumber(a) or 0.7 
	frame.heat:SetAlpha(a)

	local _, xScale, yScale = Astrolabe:ComputeDistance(pc, pz, 0, 0, pc, pz, 1, 1)
	local zScale, _, _		= Astrolabe:ComputeDistance(pc, 0,  0, 0, pc,  1, 0, 0)

	private.xScale = xScale
	private.yScale = yScale
	private.zScale = zScale
	

	if (private.started) then
		lib.Render()
	end
end

function lib.BeginUpdate()
	private.curNode = 0
end

local Gatherer_GetNodeTexture = Gatherer.Util.GetNodeTexture

function lib.PlaceIcon(n, c, z, x, y)
	local tex, trim = Gatherer_GetNodeTexture(n) -- Gatherer.Util.GetNodeTexture
	
	local nodeId = private.curNode+1
	private.curNode = nodeId
	
	local node = private.nodes[nodeId]
	if (not node) then
		node = {}
		node.tex = frame:CreateTexture("GatherHudNode"..nodeId)
		node.tex:SetWidth(get("plugin.gatherer_hud.iconsize"))
		node.tex:SetHeight(get("plugin.gatherer_hud.iconsize"))
		node.tex:Show();

		private.nodes[nodeId] = node
		if nodeId > private.maxNode then
	 private.maxNode = nodeId
		end
	end
	
	node.tex:SetTexture(tex)
	node.c = c
	node.z = z
	node.x = x
	node.y = y
end


-- Note: uses hard coded spell ids for Flight Form and Swift Flight Form
local apiIsMounted = IsMounted
local IsMounted;
local isDruid = (select(2, UnitClass("player")) == "DRUID")
if ( isDruid ) then
	local ff = (GetSpellInfo(33943));
	local sff = (GetSpellInfo(40120))
	IsMounted = function()
		return apiIsMounted() or UnitAura("player", ff) or UnitAura("player", sff)
	end
else
	IsMounted = apiIsMounted;
end

-- /run LibSwagData.heat = Gatherer_HUD.Private.zoneGrid
-- /run Gatherer_HUD.Private.zoneGrid = LibSwagData.heat
private.zoneGrid = {}
function lib.Render()
	local hide = false
	if not (get("plugin.gatherer_hud.enable") and get("minimap.enable")) then hide=true
	elseif get("plugin.gatherer_hud.hide.flying") and IsFlying() then hide=true
	elseif get("plugin.gatherer_hud.hide.inside") and IsIndoors() then hide=true
	elseif get("plugin.gatherer_hud.hide.mounted") and IsMounted() then hide=true
	elseif get("plugin.gatherer_hud.hide.walking") and not IsMounted() then hide=true
	elseif get("plugin.gatherer_hud.hide.resting") and IsResting() then hide=true
	elseif get("plugin.gatherer_hud.hide.stealth") and IsStealthed() then hide=true
	elseif get("plugin.gatherer_hud.hide.swimming") and IsSwimming() then hide=true
	elseif get("plugin.gatherer_hud.hide.combat") and ( private.inCombat or
																		UnitAffectingCombat("target") or
																			UnitAffectingCombat("player") or
																			UnitAffectingCombat("pet")
																	) then hide=true
	elseif get("plugin.gatherer_hud.hide.target") and ( (UnitCanAttack("target", "player") or
							UnitIsEnemy("target", "player")) and
							 not UnitIsDead("target")
							) then hide=true
	end

	if hide then
		private.hidden = true
		frame:Hide()
		return
	end
	private.hidden = nil
	frame:Show()
	
	local d, d_squared, dx, dy, node, pct, angle, facing, newangle, newsize, newalpha
	local pc, pz, px, py = unpack(Astrolabe.LastPlayerPosition);

	local point, scale

	local _, xScale, yScale = Astrolabe:ComputeDistance(pc, pz, 0, 0, pc, pz, 1, 1)
	local zScale, _, _		= Astrolabe:ComputeDistance(pc, 0,  0, 0, pc,  1, 0, 0)

	private.xScale = xScale
	private.yScale = yScale
	private.zScale = zScale
	
	local gridres = private.gridres
	local gridressquare = gridres * gridres
	local maxunits = gridressquare + gridres + 1
	
	if (not private.zoneGrid[pc..pz]) then
		private.zoneGrid[pc..pz] = {}
		local grid = private.zoneGrid[pc..pz]
		for i = 1, maxunits + 1 do
	 grid[i] = 0
		end
	end


	-- Add "heat" to current map
	local now = time()
	local grid = private.zoneGrid[pc..pz]
	if not (UnitIsDeadOrGhost("player") or UnitOnTaxi("player")) then
		local zpos = (math.floor(px*gridres) + math.floor(py*gridres)*gridres) + 1
		grid[zpos] = now
	end
	
	if (private.curNode == 0) then
		frame:Hide()
		return
	elseif (not frame:IsVisible()) then
		frame:Show()
	end
	
	-- Get the ratio of texcels to yards
	local radius = get("plugin.gatherer_hud.radius")
	local maxYards = get("plugin.gatherer_hud.yards")
	local maxYardsSquare = maxYards * maxYards
	local angle = get("plugin.gatherer_hud.angle") / 90
	local size = get("plugin.gatherer_hud.iconsize")
	local fadeAt = get("plugin.gatherer_hud.fade") / 100
	local ratio = radius / maxYards -- texcels/yard
	local minFadeAt = maxYards * fadeAt
	local minFadeAtSquare = minFadeAt * minFadeAt

	local perspective = get("plugin.gatherer_hud.perspective") / 2.5
	matrix.perspective = (perspective * perspective) * 800
	
	facing = GetPlayerFacing();
	
	-- rotation matrix
	-- rotate plane
	matrix.identity()
	matrix.rotation_x((1 - angle) * math.pi / 2)
	
	-- set up stuff that won't be effected by rotation of the character
	local radius = get("plugin.gatherer_hud.radius")*1.1
	local x1, y1, _ = matrix.multiply_2d(-radius, -radius, 0)
	local x2, y2, _ = matrix.multiply_2d( radius,  radius, 0)

	local center_y = ((y1 + y2) / 2)
	frame.base:SetPoint("CENTER", frame, "CENTER", 0, center_y)
	frame.base:SetWidth(x2 - x1)
	frame.base:SetHeight(y2 - y1)

	local _, aspect, _ = matrix.multiply_2d(0, 1, 0)
	frame.me:SetHeight((radius/maxYards)*132*aspect)

	-- rotate around character
	matrix.rotation_z(-facing)


	---- compass
	--if (get("plugin.gatherer_hud.compass.enable")) then 
	--	compass_size = get("plugin.gatherer_hud.compass.size")
	--	
	--	local x1, y1, _ = matrix.multiply_2d(-compass_size, -compass_size, 0)
	--	local x2, y2, _ = matrix.multiply_2d( compass_size, -compass_size, 0)
	--	local x3, y3, _ = matrix.multiply_2d(-compass_size,  compass_size, 0)
	--	local x4, y4, _ = matrix.multiply_2d( compass_size,  compass_size, 0)
	--
	--	if not private.compass then
	--		private.compass = frame.compass:CreateTexture("GatherHudCompass")
	--		private.compass:SetTexture("Interface\\AddOns\\Gatherer_HUD\\Icons\\Other\\Compass.blp")
	--		
	--		private.compass:SetAlpha(newalpha)
	--		private.compass:SetVertexColor(r, g, b)
	--		private.compass:ClearAllPoints()
	--		private.compass:SetPoint("CENTER", frame, "CENTER", dx, dy)
	--		private.compass:SetWidth(partysize * scale)
	--		private.compass:SetHeight(partysize * scale)
	--		if not private.compass:IsVisible() then
	--			private.compass:Show()
	--		else
	--			private.compass:Hide()
	--		end
	--	end
	--else
	--	private.compass.Hide()
	--end

	---- party blips
	for i, node in ipairs(private.party_members) do
		node:Hide()
	end
	if (get("plugin.gatherer_hud.party.enable")) then
		local n_members = GetNumPartyMembers()
		if n_members > 0 then
			local color = get("plugin.gatherer_hud.party.color")
			local r, g, b, a = strsplit(",", tostring(color) or "0,0,0,1")
			r = tonumber(r) or 0
			g = tonumber(g) or 0
			b = tonumber(b) or 0
			local partysize = get("plugin.gatherer_hud.party.size")
		
			local n
			for n = 1, n_members do
				local member_c, member_z, member_x, member_y = Astrolabe:GetUnitPosition("party"..n, false)
		
				if member_x and member_y then
					dx = (member_x - px) * private.xScale
					dy = (member_y - py) * private.yScale
					
					d_squared = dx*dx + dy*dy
					
					if (d_squared < maxYardsSquare) then
						if (d_squared > minFadeAtSquare) then
							pct = 1 - ((math.sqrt(d_squared) - minFadeAt) / (maxYards - minFadeAt))
						else
							pct = 1
						end
						
						node = private.party_members[n]
						if not node then
							node = frame.compass:CreateTexture("GatherHudParty"..n)
							node:SetTexture("Interface\\AddOns\\Gatherer_HUD\\Icons\\Blip.blp")
							private.party_members[n] = node
						end
						
						newalpha = pct
						
						-- So now, we need to work out the icon position
						dx, dy, scale = matrix.multiply_2d(dx * ratio, dy * ratio, 0)
						
						node:SetAlpha(newalpha)
						node:SetVertexColor(r, g, b)
						node:ClearAllPoints()
						node:SetPoint("CENTER", frame, "CENTER", dx, dy)
						node:SetWidth(partysize * scale)
						node:SetHeight(partysize * scale)
						if not node:IsVisible() then
							node:Show()
						elseif node:IsVisible() then
							node:Hide()
						end
					end
				end
			end
		end
	end
		

	-- gatherer nodes
	for i = 1, private.curNode do
		node = private.nodes[i]
		-- d/dx/dy = distance in yards in the radius/x/y dimensions
		--d, dx, dy = Astrolabe:ComputeDistance(pc, pz, px, py, node.c, node.z, node.x, node.y);

		--
		--if d and dx and dy then
		--angle = math.atan2(dx, -dy)
		--newangle = angle + facing
		
		--dx = d * math.sin(newangle);

		--dy = d * math.cos(newangle);



		dx = (node.x - px) * private.xScale
		dy = (node.y - py) * private.yScale
		
		d_squared = dx*dx + dy*dy
		
		if (d_squared < maxYardsSquare) then
			if (d_squared > minFadeAtSquare) then
				pct = 1 - ((math.sqrt(d_squared) - minFadeAt) / (maxYards - minFadeAt))
			else
				pct = 1
			end
			
			newalpha = pct
			
			-- So now, we need to work out the icon position
			dx, dy, scale = matrix.multiply_2d(dx * ratio, dy * ratio, 0)
			
			node.tex:SetAlpha(newalpha)
			node.tex:ClearAllPoints()
			node.tex:SetPoint("CENTER", frame, "CENTER", dx, dy)
			node.tex:SetWidth(size * scale)
			node.tex:SetHeight(size * scale)
			if not node.tex:IsVisible() then
				node.tex:Show()
			end
		elseif node.tex:IsVisible() then
			node.tex:Hide()
		end
		--end
	end
	for i = private.curNode+1, private.maxNode do
		node = private.nodes[i]
		if node.tex:IsVisible() then
			node.tex:Hide()
		end
	end
	
	local pos = 1
	if (get("plugin.gatherer_hud.heat.enable")) then
		local color = get("plugin.gatherer_hud.heat.color")
		local r, g, b, a = strsplit(",", tostring(color) or "0,0,0,1")
		r = tonumber(r) or 0
		g = tonumber(g) or 0
		b = tonumber(b) or 0
		
		local maxExtentX = maxYards/private.xScale
		local maxExtentY = maxYards/private.yScale
			
		local px_minus_maxExtentX = px - maxExtentX
		local px_plus_maxExtentX = px + maxExtentX
		local py_minus_maxExtentY = py - maxExtentY
		local py_plus_maxExtentY = py + maxExtentY
			
		
		local delta, gridTime, percent, gx, gy
		local heatTime = get("plugin.gatherer_hud.heat.cooldown")
		if (get("plugin.gatherer_hud.heat.nevercooldown")) then
				 heatTime = 1000000000
		end
		local heatTrailSize = get("plugin.gatherer_hud.heat.size") + 20
		local size = heatTrailSize * ratio
		
		for i=1, maxunits do
			gridTime = grid[i]
			delta = now - gridTime
			
			if (delta < heatTime) then
				gx = (i%gridres) / gridres
				gy = (i-gx)/gridressquare
				-- Eliminate as many "not possible" matches as early as we can by working out
				-- the "boxed" area
				if (
					 gx > px_minus_maxExtentX and gx < px_plus_maxExtentX and
						 gy > py_minus_maxExtentY and gy < py_plus_maxExtentY
				 ) then
					-- Since we are doing so many computations in this loop, we cannot 
					-- afford to call astrolabe to calculate the distances.
					--d, dx, dy = Astrolabe:ComputeDistance(pc, pz, px, py, pc, pz, gx, gy)
					-- We must do it ourself.
					dx = (gx - px) * private.xScale
					dy = (gy - py) * private.yScale
					
					d_squared = dx*dx + dy*dy
					
					if (d_squared < maxYardsSquare) then
						if (d_squared > minFadeAtSquare) then
							pct = 1 - ((math.sqrt(d_squared) - minFadeAt) / (maxYards - minFadeAt))
						else
							pct = 1
						end
												
						node = private.heat[pos]
						if not node then
							node = frame.heat:CreateTexture("GatherHudHeat"..pos)
							node:SetTexture("Interface\\AddOns\\Gatherer_HUD\\HudShape")
							private.heat[pos] = node
						end
						node:SetVertexColor(r, g, b)
						pos = pos + 1
						
						pct = pct * (1 - (delta / heatTime))
						
						newalpha = pct
						
						-- So now, we need to work out the icon position
						dx, dy, scale = matrix.multiply_2d(dx * ratio,  dy * ratio, 0)
						
						node:SetAlpha(newalpha)
						node:ClearAllPoints()
						node:SetPoint("CENTER", frame, "CENTER", dx, dy)
						node:SetWidth(size * scale)
						node:SetHeight(size * scale * aspect)
						if not node:IsVisible() then
							node:Show()
						end
					end
				end
			end
		end
	end
	
	while private.heat[pos] do
		if private.heat[pos]:IsVisible() then
			private.heat[pos]:Hide()
		end
		pos = pos + 1
	end
end

function Gatherer_HUD.RunUpdate(delay)
	private.elapsed = private.elapsed + delay
	local rate = GetFramerate()
	
	if not private.started then
		if private.elapsed < 30 and rate < 5 then return end
		private.started = true
	end
	
	-- Get our update interval dynamically based off frame rate
	if not private.interval then
		private.interval = 1
	end

	local min_fullframerate = get("plugin.gatherer_hud.min_fullframerate")

	local interval = 0
	if rate > min_fullframerate or min_fullframerate == 0 then 
		private.interval = 0
	else
		if     (rate > (min_fullframerate/4)) then interval = rate/2
		elseif (rate > (min_fullframerate/8)) then interval = rate/4
		elseif (rate > (min_fullframerate/12)) then interval = 1
		elseif (rate > (min_fullframerate/16)) then interval = 0.5
		else interval = 0.01 end
		
		private.interval = ((private.interval * 100) + interval) / 101
	end
	
	-- Render if interval is great enough
	if private.interval == 0 or private.elapsed > 1/private.interval then
		private.elapsed = 0
		lib.Render()
	end
end
