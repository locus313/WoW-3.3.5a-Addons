--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 3.1.16 (<%codename%>)
	Revision: $Id: GatherPlugins.lua 891 2010-10-18 05:06:32Z Esamynn $

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

	Plugin Registration
]]
Gatherer_RegisterRevision("$URL: http://svn.norganna.org/gatherer/trunk/Gatherer/GatherPlugins.lua $", "$Rev: 891 $")

local metatable = { __index = getfenv(0) }
setmetatable( Gatherer.Plugins, metatable )
setfenv(1, Gatherer.Plugins)

Data = {}
Registrations = {}
ConfigUpdateFunctions = {}
Commands = {}

local setting = Gatherer.Config.GetSetting

function LoadPluginData()
	for i = 1, GetNumAddOns() do
		local tabName = GetAddOnMetadata(i, "X-Gatherer-Plugin-Name")
		if ( tabName ) then
			local cmdName = (GetAddOnMetadata(i, "X-Gatherer-Command-Name") or tabName):lower():gsub("%s+", "")
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
			name = name:lower()
			Data[name] = {
				tabName = tabName,
				name = name,
				title = title,
				notes = notes,
			}
			Commands[cmdName] = {
				name = name;
			}
			local enabled = setting("plugin."..name..".enable")
			if ( enabled ) then
				LoadAddOn(i)
			end
		end
	end
end

function RegisterPlugin( name, settingDefaults, makeConfig, configUpdate )
	name = name:lower()
	local data = Data[name]
	if ( data ) then
		Registrations[name] = {
			name = name,
			defaults = settingDefaults,
			makeConfig = makeConfig,
		}
		if ( Gatherer.Config.Gui ) then
			makeConfig(Gatherer.Config.Gui)
		end
		if ( type(configUpdate) == "function" ) then
			ConfigUpdateFunctions[name] = configUpdate
		end
	end
end

function LoadPlugin( name )
	name = name:lower()
	if ( Data[name] and not Registrations[name] ) then
		EnableAddOn(name)
		LoadAddOn(name)
	end
end

local Print = Gatherer.Util.ChatPrint
local function PrintUsageLine( plugin, cmd, ... )
	Gatherer.Command.PrintUsageLine("plugin " .. plugin .. " " .. cmd, ...)
end

function ProcessCommands( pluginCmdName, cmd, ... )
	local GetSetting = Gatherer.Config.GetSetting
	local SetSetting = Gatherer.Config.SetSetting
	if ( pluginCmdName == "help" or pluginCmdName == "" or pluginCmdName == nil ) then
		Print("Usage:")
		for cmd, details in pairs(Commands) do
			local pluginStatus = GetSetting("plugin."..details.name..".enable") and "on" or "off"
			PrintUsageLine(cmd, "on||off||toggle", pluginStatus, "turns the " .. Data[details.name].tabName .. " on and off")
		end
	
	elseif ( Commands[pluginCmdName] ) then
		local details = Commands[pluginCmdName]
		local p1, p2 = ...
		local enabled = Gatherer.Command.parseOnOff(cmd)
		if ( enabled ~= nil ) then
			if ( enabled == true ) then
				SetSetting("plugin."..details.name..".enable", true)
				Print("Turned " .. Data[details.name].tabName .. " on")
			
			elseif ( enabled == false ) then
				SetSetting("plugin."..details.name..".enable", false)
				Print("Turned " .. Data[details.name].tabName .. " off")
			
			end
		
		elseif ( cmd == "toggle" ) then
			if ( GetSetting("plugin."..details.name..".enable") ) then
				ProcessCommands(pluginCmdName, "off")
			else
				ProcessCommands(pluginCmdName, "on")
			end
		
		else
			
		
		end
	
	end
end
