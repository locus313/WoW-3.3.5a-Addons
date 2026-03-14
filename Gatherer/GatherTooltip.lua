--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 3.1.16 (<%codename%>)
	Revision: $Id: GatherTooltip.lua 876 2010-09-18 23:41:23Z Esamynn $

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:  
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat

	Tooltip functions
]]
Gatherer_RegisterRevision("$URL: http://svn.norganna.org/gatherer/trunk/Gatherer/GatherTooltip.lua $", "$Rev: 876 $")

local _tr = Gatherer.Locale.Tr
local _trC = Gatherer.Locale.TrClient
local _trL = Gatherer.Locale.TrLocale

setmetatable(Gatherer.Tooltip, {__index = getfenv(0)})
setfenv(1, Gatherer.Tooltip)

function AddDropRates( tooltip, nodeId, cont, zone, maxDropsToShow )
	if not ( maxDropsToShow ) then maxDropsToShow = 5 end
-- the following lines replace the commented out section for the momment so that all
-- drop rates are shown with worldwide data
	local total = Gatherer.DropRates.GetDropsTotal(nodeId)
	cont = nil
	zone = nil
--[[
	local total = Gatherer.DropRates.GetDropsTotal(nodeId, cont, zone)
	if not ( total and (total > 0) ) then
		total = Gatherer.DropRates.GetDropsTotal(nodeId)
		cont = nil
		zone = nil
	end
]]
	if ( total and (total > 0) ) then
		tooltip:AddLine(_tr("NOTE_OVERALLDROPS"))
		local numLeft = 0
		for i, item, count in Gatherer.DropRates.ObjectDrops(nodeId, cont, zone, "DESC") do
			local itemName, itemLink, itemRarity, _, _, _, _, _, _, invTexture = GetItemInfo(item)
			if ( itemName and (i <= maxDropsToShow) ) then
				tooltip:AddDoubleLine(itemLink, string.format("x%0.2f", count/total))
				tooltip:AddTexture(invTexture)
			else
				numLeft = numLeft + 1
			end
		end
		if ( numLeft > 0 ) then
			tooltip:AddLine(_tr("NOTE_ADDITIONAL", numLeft))
		end
	end
end


-- Hijack the game tooltips for ore and herb nodes so that we can add the
-- required skill level to the information displayed

function Gatherer.GameTooltip_OnShow ()

		if GameTooltip:NumLines() ~= 2 then return end

		local line = {}
		for n = 1, 2 do
		  local left = _G["GameTooltipTextLeft"..n]
		  local right = _G["GameTooltipTextRight"..n]
		  if not left or not left:IsShown() then return end
		  if right and right:IsShown() then return end
		  table.insert(line, left)
		end
		
		local requires = line[2]:GetText()
		local profession = requires:match("^Requires%s(%a+)$")
		if not profession
		or profession ~= "Mining" and profession ~= "Herbalism" then return end
		
		local nodeName = line[1]:GetText()
		local nodeID = Gatherer.Nodes.Names[nodeName]
		if not nodeID then return end
		
		local category = Gatherer.Categories.ObjectCategories[nodeID]
		if not category then return end
		
		local skill = Gatherer.Constants.SkillLevel[category]
		if not skill then return end
		
		local width = line[2]:GetStringWidth()
		line[2]:SetText(requires.." "..skill)
		width = line[2]:GetStringWidth() - width
		if width > 0 then GameTooltip:SetWidth(GameTooltip:GetWidth() + width) end

end

GameTooltip:HookScript("OnShow", Gatherer.GameTooltip_OnShow)