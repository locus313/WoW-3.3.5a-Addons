--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 3.1.16 (<%codename%>)
	Revision: $Id: GatherMiniIcon.lua 879 2010-09-19 12:08:21Z kandoko $

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

	Minimap icon
]]
Gatherer_RegisterRevision("$URL: http://svn.norganna.org/gatherer/trunk/Gatherer/GatherMiniIcon.lua $", "$Rev: 879 $")


local miniIcon = CreateFrame("Button", "Gatherer_MinimapOptionsButton", Minimap);
Gatherer.MiniIcon = miniIcon

miniIcon:SetToplevel(true)
miniIcon:SetMovable(true)
miniIcon:SetFrameStrata("LOW")
miniIcon:SetWidth(33)
miniIcon:SetHeight(33)
miniIcon:SetPoint("RIGHT", Minimap, "LEFT", 0,0)
miniIcon:Show()
miniIcon.icon = miniIcon:CreateTexture("", "BACKGROUND")
miniIcon.icon:SetTexture("Interface\\AddOns\\Gatherer\\Skin\\GatherOrb")
miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
miniIcon.icon:SetWidth(17)
miniIcon.icon:SetHeight(17)
miniIcon.icon:SetPoint("CENTER", miniIcon, "CENTER", 0,0)
miniIcon.mask = miniIcon:CreateTexture("", "OVERLAY")
miniIcon.mask:SetTexCoord(0.0, 0.6, 0.0, 0.6)
miniIcon.mask:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
miniIcon.mask:SetAllPoints(true)


local function mouseDown()
	miniIcon.icon:SetTexCoord(0, 1, 0, 1)
end
local function mouseUp()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end

local moving = false
local function dragStart()
	moving = true
end
local function dragStop()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	moving = false
end

local function click(obj, button)
	if (button == "LeftButton") then
		local dtype = "minimap.enable"
		if (IsModifierKeyDown()) then
			dtype = "plugin.gatherer_hud.enable"
		end
		local cur = Gatherer.Config.GetSetting(dtype)
		Gatherer.Config.SetSetting(dtype, not cur)
	elseif (button == "RightButton") then
		if (IsModifierKeyDown()) then
			Gatherer.Config.ToggleOptions()
		else
			Gatherer.Report.Toggle()
		end
	end
end

local function reposition(angle)
	if (not Gatherer.Config.GetSetting("miniicon.enable")) then
		miniIcon:Hide()
		return
	end
	miniIcon:Show()
	if (not angle) then angle = Gatherer.Config.GetSetting("miniicon.angle") or 0.5
	else Gatherer.Config.SetSetting("miniicon.angle", angle) end
	angle = angle
	local distance = Gatherer.Config.GetSetting("miniicon.distance")

	local width,height = Minimap:GetWidth()/2, Minimap:GetHeight()/2
	width = width+distance
	height = height+distance

	local iconX, iconY
	iconX = width * sin(angle)
	iconY = height * cos(angle)

	miniIcon:ClearAllPoints()
	miniIcon:SetPoint("CENTER", Minimap, "CENTER", iconX, iconY)
end
miniIcon.Reposition = reposition

local function update()
	if moving then
		local curX, curY = GetCursorPosition()
		local miniX, miniY = Minimap:GetCenter()
		miniX = miniX * Minimap:GetEffectiveScale()
		miniY = miniY * Minimap:GetEffectiveScale()

		local relX = miniX - curX
		local relY = miniY - curY
		local angle = math.deg(math.atan2(relX, relY)) + 180

		reposition(angle)
	end
end

miniIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
miniIcon:RegisterForDrag("LeftButton")
miniIcon:SetScript("OnMouseDown", mouseDown)
miniIcon:SetScript("OnMouseUp", mouseUp)
miniIcon:SetScript("OnDragStart", dragStart)
miniIcon:SetScript("OnDragStop", dragStop)
miniIcon:SetScript("OnClick", click)
miniIcon:SetScript("OnUpdate", update)

local sideIcon
--moved into a function so we can delay LDB creation until after saved variables have been loaded.
function miniIcon.CreateLDB()
	if LibStub then
		local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if LibDataBroker then
			local Desaturated = not Gatherer.Config.GetSetting("minimap.enable") --we want the opposite boolean of the enabled state
			sideIcon = LibDataBroker:NewDataObject("Gatherer", {
						type = "launcher",
						icon = "Interface\\AddOns\\Gatherer\\Skin\\GatherOrb",
						OnClick = function(self, button)
							click(self, button)
						end,
						--this is a special method for slidebar. Sets the inital button saturation state. true = desaturated
						iconDesaturated = Desaturated
					})
					
			function sideIcon:OnTooltipShow()
				self:AddLine("Gatherer",  1,1,0.5, 1)
				self:AddLine("Gatherer is an addon that allows you to remember your gathering locations and view them on either or all of your main map, your minimap, or in an onscreen display HUD. It also allows you to share your finds with your guild, raid or your friends",  1,1,0.5, 1)
				self:AddLine("|cff1fb3ff".."Click|r to toggle display of nodes.",  1,1,0.5, 1 )
				self:AddLine("|cff1fb3ff".."Shift-Click|r to toggle HUD display.", 1,1,0.5, 1 )
				self:AddLine("|cff1fb3ff".."Right-Click|r to view the gather report.",  1,1,0.5, 1)
				self:AddLine("|cff1fb3ff".."Shift-Right-Click|r to edit the configuration.",  1,1,0.5, 1)
			end
			function sideIcon:OnEnter()
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
				GameTooltip:ClearLines()
				sideIcon.OnTooltipShow(GameTooltip)
				GameTooltip:Show()
			end
			function sideIcon:OnLeave()
				GameTooltip:Hide()
			end
		end
	end
end

function miniIcon.Update()
	local enabled = Gatherer.Config.GetSetting("minimap.enable")
	miniIcon.icon:SetDesaturated(not enabled)
	--this will allow gatherer to desaturate its icon, only on slidebar.
	if sideIcon and sideIcon.button and sideIcon.button.icon then
		sideIcon.button.icon:SetDesaturated(not enabled)
	end
end
