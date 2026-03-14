-- FishingBuddy
--
-- Everything you wanted support for in your fishing endeavors

local Crayon = LibStub("LibCrayon-3.0");
local FL = LibStub("LibFishing-1.0");
local BL = LibStub("LibBabble-Zone-3.0"):GetBaseLookupTable();
local BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
local BZR = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable();
local LT = LibStub("LibTourist-3.0");

-- Information for the stylin' fisherman
local POLES = {
   ["Fishing Pole"] = "6256:0:0:0",
   ["Strong Fishing Pole"] = "6365:0:0:0",
   ["Darkwood Fishing Pole"] = "6366:0:0:0",
   ["Big Iron Fishing Pole"] = "6367:0:0:0",
   ["Blump Family Fishing Pole"] = "12225:0:0:0",
   ["Nat Pagle's Extreme Angler FC-5000"] = "19022:0:0:0",
   ["Arcanite Fishing Pole"] = "19970:0:0:0",
   ["Seth's Graphite Fishing Pole"] = "25978:0:0:0",
   ["Nat's Lucky Fishing Pole"] = "45858:0:0:0",
   ["Mastercraft Kalu'ak Fishing Pole"] = "44050:0:0:0",
   ["Bone Fishing Pole"] = "45991:0:0:0",
   ["Jeweled Fishing Pole"] = "45992:0:0:0",
-- yeah, so you can't really use these (for now :-)
   ["Dwarven Fishing Pole"] = "3567:0:0:0",
   ["Goblin Fishing Pole"] = "4598:0:0:0",
   ["Nat Pagle's Fish Terminator"] = "19944:0:0:0",
}

local FISHINGLURES = {
   {  ["id"] = 34832,
      ["n"] = "Captain Rumsey's Lager",           -- 25 for 10 mins
      ["b"] = 10,
      ["s"] = 1,
      ["d"] = 3,
      ["u"] = 1,
   },
   {  ["id"] = 6529,
      ["n"] = "Shiny Bauble",                     -- 25 for 10 mins
      ["b"] = 25,
      ["s"] = 1,
      ["d"] = 10,
   },
   {  ["id"] = 6811,
      ["n"] = "Aquadynamic Fish Lens",            -- 50 for 10 mins
      ["b"] = 50,
      ["s"] = 50,
      ["d"] = 10,
   },
   {  ["id"] = 6530,
      ["n"] = "Nightcrawlers",                    -- 50 for 10 mins
      ["b"] = 50,
      ["s"] = 50,
      ["d"] = 10,
   },
   {  ["id"] = 33820,
      ["n"] = "Weather-Beaten Fishing Hat",       -- 75 for 10 minutes
      ["b"] = 75,
      ["s"] = 1,
      ["d"] = 10,
      ["w"] = true,
   },
   {  ["id"] = 7307,
      ["n"] = "Flesh Eating Worm",                -- 75 for 10 mins
      ["b"] = 75,
      ["s"] = 100,
      ["d"] = 10,
   },
   {  ["id"] = 6532,
      ["n"] = "Bright Baubles",                   -- 75 for 10 mins
      ["b"] = 75,
      ["s"] = 100,
      ["d"] = 10,
   },
   {  ["id"] = 34861,
      ["n"] = "Sharpened Fish Hook",              -- 100 for 10 minutes
      ["b"] = 100,
      ["s"] = 100,
      ["d"] = 10,
   },
   {  ["id"] = 6533,
      ["n"] = "Aquadynamic Fish Attractor",       -- 100 for 10 minutes
      ["b"] = 100,
      ["s"] = 100,
      ["d"] = 10,
   },
   {  ["id"] = 46006,
      ["n"] = "Glow Worm",       		 		  -- 100 for 60 minutes
      ["b"] = 100,
      ["s"] = 100,
      ["d"] = 60,
   },
}

local GeneralOptions = {
   ["ShowNewFishies"] = {
      ["text"] = FBConstants.CONFIG_SHOWNEWFISHIES_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_SHOWNEWFISHIES_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1 },
   ["TurnOffPVP"] = {
      ["text"] = FBConstants.CONFIG_TURNOFFPVP_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_TURNOFFPVP_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0 },
   ["SortByPercent"] = {
      ["text"] = FBConstants.CONFIG_SORTBYPERCENT_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_SORTBYPERCENT_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1 },
   ["EnhanceFishingSounds"] = {
      ["text"] = FBConstants.CONFIG_ENHANCESOUNDS_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_ENHANCESOUNDS_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0 },
   ["BackgroundSounds"] = {
      ["text"] = FBConstants.CONFIG_BGSOUNDS_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_BGSOUNDS_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0,
      ["deps"] = { ["EnhanceFishingSounds"] = "d" }, },
   ["MinimapButtonVisible"] = {
      ["text"] = FBConstants.CONFIG_MINIMAPBUTTON_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_MINIMAPBUTTON_INFO,
      ["v"] = 1,
      ["default"] = 1, },
   ["MinimapPosSlider"] = {
      ["tooltip"] = FBConstants.MINIMAPBUTTONPLACEMENTTOOLTIP,
      ["deps"] = { ["MinimapButtonVisible"] = "d", },
      ["button"] = "FishingBuddyOption_MinimapPosSlider",
      ["margin"] = { 12, 8 }, },
   ["MinimapRadSlider"] = {
      ["tooltip"] = FBConstants.MINIMAPBUTTONRADIUSTOOLTIP,
      ["deps"] = { ["MinimapButtonVisible"] = "d", },
      ["button"] = "FishingBuddyOption_MinimapRadSlider",
      ["margin"] = { 12, 8 }, },
};

local CastingOptions = {
   ["EasyCast"] = {
      ["text"] = FBConstants.CONFIG_EASYCAST_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_EASYCAST_INFO,
      ["layoutright"] = "EasyCastKeys",
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0 },
   ["EasyLures"] = {
      ["text"] = FBConstants.CONFIG_EASYLURES_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_EASYLURES_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["deps"] = { ["EasyCast"] = "d" },
      ["default"] = 0 },
   ["AlwaysLure"] = {
      ["text"] = FBConstants.CONFIG_ALWAYSLURE_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_ALWAYSLURE_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["primary"] = "EasyCast",
      ["deps"] = { ["EasyCast"] = "d", ["EasyLures"] = "d" },
      ["default"] = 0 },
   ["AutoLoot"] = {
      ["text"] = FBConstants.CONFIG_AUTOLOOT_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_AUTOLOOT_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["deps"] = { ["EasyCast"] = "d" },
      ["default"] = 0 },
   ["UseAction"] = {
      ["text"] = FBConstants.CONFIG_USEACTION_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_USEACTION_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["deps"] = { ["EasyCast"] = "d" },
      ["default"] = 0 },
   ["WatchBobber"] = {
      ["text"] = FBConstants.CONFIG_WATCHBOBBER_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_WATCHBOBBER_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["deps"] = { ["EasyCast"] = "d" },
      ["default"] = 1 },
   ["ContestSupport"] = {
      ["text"] = FBConstants.CONFIG_CONTESTS_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_CONTESTS_INFO,
      ["v"] = 1,
      ["default"] = 0 },
   ["STVTimer"] = {
      ["text"] = FBConstants.CONFIG_STVTIMER_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_STVTIMER_INFO,
      ["v"] = 1,
      ["default"] = 0,
      ["deps"] = { ["ContestSupport"] = "d" }
   },
   ["DerbyTimer"] = {
      ["text"] = FBConstants.CONFIG_DERBYTIMER_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_DERBYTIMER_INFO,
      ["v"] = 1,
      ["default"] = 0,
      ["deps"] = { ["ContestSupport"] = "d" }
   },
   ["STVPoolsOnly"] = {
      ["text"] = FBConstants.CONFIG_STVPOOLSONLY_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_STVPOOLSONLY_INFO,
      ["v"] = 1,
      ["default"] = 0,
      ["primary"] = "ContestSupport",
      ["deps"] = { ["ContestSupport"] = "d", ["EasyCast"] = "d" }
   },
   ["ShowPools"] = {
      ["text"] = FBConstants.CONFIG_SHOWPOOLS_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_SHOWPOOLS_INFO,
      ["v"] = 1,
      ["default"] = 1,
      ["primary"] = "ContestSupport",
      ["deps"] = { ["ContestSupport"] = "d" }
   },
   ["EasyCastKeys"] = {
      ["default"] = FBConstants.KEYS_NONE,
      ["button"] = "FishingBuddyOption_EasyCastKeys",
      ["deps"] = { ["EasyCast"] = "h" },
      ["setup"] =
         function()
            local gs = FishingBuddy.GetSetting;
            FishingBuddyOption_EasyCastKeys:SetKeyValue("EasyCastKeys", gs("EasyCastKeys"));
         end,
   },
};

local InvisibleOptions = {
   -- options not directly manipulatable from the UI
   ["TooltipInfo"] = {
      ["text"] = FBConstants.CONFIG_TOOLTIPS_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_TOOLTIPS_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0 },
   ["GroupByLocation"] = {
      ["default"] = 1,
   },
   -- bar switching
   ["ClickToSwitch"] = {
      ["default"] = 1,
   },
   ["MinimapClickToSwitch"] = {
      ["default"] = 0,
   },
   ["EnhanceSound_SFXVolume"] = {
      ["default"] = 1.0,
   },
   ["EnhanceSound_MasterVolume"] = {
      ["default"] = 1.0,
   },
   ["EnhanceSound_MusicVolume"] = {
      ["default"] = 0.0,
   },
   ["EnhanceSound_AmbienceVolume"] = {
      ["default"] = 0.0,
   },
   ["EnhanceMapWaterSounds"] = {
      ["default"] = 0,
   },
   ["EnhanceSound_EnableSoundWhenGameIsInBG"] = {
      ["default"] = 1.0,
   },
   ["MinimapButtonPosition"] = {
      ["default"] = FBConstants.DEFAULT_MINIMAP_POSITION,
   },
   ["MinimapButtonRadius"] = {
      ["default"] = FBConstants.DEFAULT_MINIMAP_RADIUS,
   },
   ["CaughtSoFar"] = {
      ["default"] = 0,
   },
   ["TotalTimeFishing"] = {
      ["default"] = 1,
   },
   ["FishDebug"] = {
      ["default"] = 0,
   },
}

-- default FishingBuddy option handlers
FishingBuddy.BaseGetSetting = function(setting)
   if ( not FishingBuddy_Player or
        not FishingBuddy_Player["Settings"] ) then
      return;
   end
   local val = FishingBuddy_Player["Settings"][setting];
   if ( val == nil and FishingBuddy.GetDefault ) then
      val = FishingBuddy.GetDefault(setting);
   end
   return val;
end

FishingBuddy.BaseSetSetting = function(setting, value)
   if ( FishingBuddy_Player and setting ) then
      local val = nil;
      if ( FishingBuddy.GetDefault ) then
         val = FishingBuddy.GetDefault(setting);
      end
      if ( val == value ) then
         FishingBuddy_Player["Settings"][setting] = nil;
      else
         FishingBuddy_Player["Settings"][setting] = value;
      end
   end
end

FishingBuddy.ByFishie = nil;
FishingBuddy.SortedFishies = nil;

FishingBuddy.SavedToggleMinimap = nil;

FishingBuddy.StartedFishing = nil;

local CastingNow = false;
local IsLooting = false;
local OverrideOn = false;

local AddingLure = false;
local LureState = 0;
local DoEscaped = nil;
local DoLure = nil;
local LastLure = nil;
local LastUsed = nil;
local Recasting = 0;

local gotSetupDone = false;
local playerName = nil;
local realmName = nil;

FishingBuddy.currentFishies = {};

local function GetKey()
   local key = FishingBuddy_Info["FishingBuddyKey"];
   if ( not key ) then
      -- This was removed in 3.1, lets just assume we have enough randomness already
      -- math.randomseed(time());
      -- generate a random key to identify this instance of the plugin
      local n = 16 + random(4) + random(4);
      key = "";
      for idx=1,n do
         key = key .. string.char(64+math.random(26));
      end
      FishingBuddy_Info["FishingBuddyKey"] = key;
   end
   return key;
end
FishingBuddy.API.GetKey = GetKey;

local function CheckForeignKey(foreignKey, foreignDate, saveKey)
   if ( not FishingBuddy_Info["ForeignKeys"] ) then
      FishingBuddy_Info["ForeignKeys"] = {};
   end
   if ( saveKey ) then
      FishingBuddy_Info["ForeignKeys"][foreignKey] = foreignDate;
      return;
   end
   if ( not FishingBuddy_Info["ForeignKeys"][foreignKey] ) then
      FishingBuddy_Info["ForeignKeys"][foreignKey] = foreignDate;
      return true;
   end
   return ( FishingBuddy_Info["ForeignKeys"][foreignKey] < foreignDate );
end
FishingBuddy.API.CheckForeignKey = CheckForeignKey;

local function ResetKey()
   FishingBuddy_Info["FishingBuddyKey"] = nil;
   local key = GetKey();
   if (FB_MergeDatabase) then
      FB_MergeDatabase.key = key;
   end
   FishingBuddy.Message("Key reset.");
   return key;
end
FishingBuddy.ResetKey = ResetKey;

-- handle zone markers
local function zmto(zidx, sidx)
   if ( not zidx ) then
      return 0;
   end
   if ( not sidx ) then
      sidx = 0;
   end
   return zidx*1000 + sidx;
end
FishingBuddy.ZoneMarkerTo = zmto;

local function zmex(packed)
   local sidx = math.fmod(packed, 1000);
   return math.floor(packed/1000), sidx;
end
FishingBuddy.ZoneMarkerEx = zmex;

-- event handling
local function IsFakeEvent(evt)
   return FBConstants.FBEvents[evt];
end

local handlerframe = CreateFrame("Frame");
local reg_events = {};
local event_handlers = {};

local function AddHandler(evt, func)
   if ( not event_handlers[evt] ) then
      event_handlers[evt] = {};
   end
   tinsert(event_handlers[evt], func);
end

local function RemoveHandler(evt, func)
   if ( event_handlers[evt] ) then
      local jdx;
      for idx,f in ipairs(event_handlers[evt]) do
         if ( f == func ) then
            jdx = idx;
         end
      end
      if ( jdx) then
         table.remove(event_handlers[evt], jdx);
      end
   end
end

local function RegisterHandlers(handlers)
   for evt,info in pairs(handlers) do
      local func, fake;
      if ( not event_handlers[evt] ) then
         event_handlers[evt] = {};
      end
      if ( type(info) == "function" ) then
         func = info;
         fake = IsFakeEvent(evt);
      else
         func = info.func;
         if ( IsFakeEvent(evt) ) then
            fake = true;
         else
            fake = info.fake;
         end
      end
      tinsert(event_handlers[evt], func);
      if ( not fake ) then
         -- register the event, if we haven't already
         if ( FishingBuddy.StartedFishing and not reg_events[evt] ) then
            handlerframe:RegisterEvent(evt);
         end
         reg_events[evt] = 1;
      end
   end
end
FishingBuddy.API.RegisterHandlers = RegisterHandlers;
FishingBuddy.API.GetHandlers = function(what) return event_handlers[what]; end;

-- handle dynamic event registration
local function EventRegistration(reg)
   for evt,t in pairs(reg_events) do
      if ( reg ) then
         handlerframe:RegisterEvent(evt);
      else
         handlerframe:UnregisterEvent(evt);
      end
   end
end

local function RunHandlers(what, ...)
   local eh = FishingBuddy.API.GetHandlers(what);
   if ( eh ) then
      for idx,func in pairs(eh) do
         func(...);
      end
   end
end
FishingBuddy.RunHandlers = RunHandlers;

-- we 
handlerframe:SetScript("OnEvent", function(self, event, ...)
   RunHandlers(event, ...);
   RunHandlers("*", ...);
end)

-- look at tooltips
local function LastTooltipText()
   return FL:GetLastTooltipText();
end
FishingBuddy.LastTooltipText = LastTooltipText;

local function ClearTooltipText()
   FL:ClearLastTooltipText();
end
FishingBuddy.ClearTooltipText = ClearTooltipText; 

-- build a list of zones where a given fish can be found
local function FishZoneList(fishid)
   if ( FishingBuddy.ByFishie[fishid] ) then
      local slist = {};
      for idx,count in pairs(FishingBuddy.ByFishie[fishid]) do
         local zidx, sidx = zmex(idx);
         if ( sidx > 0 ) then
            slist[idx] = 1;
         end
      end
      local names = {};
      for idx,_ in pairs(slist) do
         tinsert(names, FishingBuddy.SubZones[idx]);
      end
      table.sort(names);
      return FishingBuddy.EnglishList(names);
   end
   -- return nil;
end

-- handle option keys for enabling casting
local key_actions = {
   [FBConstants.KEYS_NONE] = function() return true; end,
   [FBConstants.KEYS_SHIFT] = function() return IsShiftKeyDown(); end,
   [FBConstants.KEYS_CTRL] = function() return IsControlKeyDown(); end,
   [FBConstants.KEYS_ALT] = function() return IsAltKeyDown(); end,
}
local function CastingKeys()
   local setting = FishingBuddy.GetSetting("EasyCastKeys");
   if ( setting and key_actions[setting] ) then
      return key_actions[setting]();
   else
      return true;
   end
end

-- handle the vagaries of zones and subzones
local function GetZoneInfo()
   local zone = GetRealZoneText();
   local subzone = GetSubZoneText();
   if ( not zone or zone == "" ) then
      zone = UNKNOWN;
   end
   if ( not subzone or subzone == "" ) then
      subzone = zone;
   end
   return zone, subzone;
end
FishingBuddy.GetZoneInfo = GetZoneInfo;

local zonemapping;
local subzonemapping;

local function DumpMappings(both)
   FishingBuddy.Debug("Zone mapping");
   FishingBuddy.Dump(zonemapping);
   if ( both ) then
      FishingBuddy.Debug("SubZone mapping");
      FishingBuddy.Dump(subzonemapping);
   end
end
FishingBuddy.DumpMappings = DumpMappings;

local function ResetMappings()
   zonemapping = nil;
   subzonemapping = nil;
end
FishingBuddy.ResetMappings = ResetMappings;

local function initmappings()
   if ( not zonemapping ) then
      zonemapping = {};
      subzonemapping = {};
      for zidx,z in pairs(FishingBuddy_Info["ZoneIndex"]) do
         zonemapping[z] = zidx;
         local zidm = zmto(zidx,0);
         local count = FishingBuddy.SubZones[zidm];
         if ( count and count > 0 ) then
            subzonemapping[zidx] = {};
            for s=1,count,1 do
               zidm = zmto(zidx, s);
               local sz = FishingBuddy.SubZones[zidm];
               subzonemapping[zidx][sz] = s;
            end
         end
      end
   end
end

local function GetZoneIndex(zone, subzone, marker)
   initmappings();
   if ( not zone ) then
      zone, subzone = GetZoneInfo();
   end
   if ( zone and not BL[zone] ) then
      zone = BZR[zone];
   end
   if (not zone) then
      zone = UNKNOWN;
   end
   local zidx = zonemapping[zone];
   if ( not zidx ) then
      return;
   end
   if ( not subzonemapping[zidx] ) then
      subzonemapping[zidx] = {};
   end
   if ( not subzone or not subzonemapping[zidx][subzone] ) then
      if ( marker ) then
         return zmto(zidx, 0);
      else
         return zidx;
      end
   end
   -- subzone = BZR[subzone];
   if ( marker ) then
      return zmto(zidx, subzonemapping[zidx][subzone]);
   else
      return zidx, subzonemapping[zidx][subzone];
   end
end
FishingBuddy.GetZoneIndex = GetZoneIndex;

local function AddZoneIndex(zone, subzone, marker)
   if ( not zone ) then
      zone, subzone = GetZoneInfo();
   end
   if ( type(zone) ~= "string" ) then
      FishingBuddy.Debug("AddZoneIndex "..zone);
   end
   local zidx, sidx = GetZoneIndex(zone, subzone);
   local loczone;
   if ( BL[zone] ) then
      loczone = BZ[zone];
   else
      loczone = zone;
      zone = BZR[zone];
   end
   if (not zone) then
      zone = UNKNOWN;
   end
   if ( not zidx ) then
      tinsert(FishingBuddy_Info["ZoneIndex"], zone);
      zidx = table.getn(FishingBuddy_Info["ZoneIndex"]);
      zonemapping[zone] = zidx;
      -- keep sort helpers up to date
      if ( FishingBuddy.SortedZones ) then
         tinsert(FishingBuddy.SortedZones, loczone);
         table.sort(FishingBuddy.SortedZones);
      end
   end
   local zidm = zmto(zidx, 0);
   if ( not subzone ) then
      if ( marker ) then
         return zidm;
      else
         return zidx;
      end
   end
   -- subzone = BZR[subzone];
   if ( not subzonemapping[zidx] ) then
      subzonemapping[zidx] = {};
   end
   local newsubzone = false;
   if ( not subzonemapping[zidx][subzone] ) then
      newsubzone = true;
      sidx = FishingBuddy.SubZones[zidm];
      if ( not sidx ) then
         sidx = 1;
      else
         sidx = sidx + 1;
      end
      FishingBuddy.SubZones[zidm] = sidx;
      local sidm = zmto(zidx, sidx);
      FishingBuddy.SubZones[sidm] = subzone;
      subzonemapping[zidx][subzone] = sidx;
   end
   -- keep sort helpers up to date
   if ( newsubzone ) then
      if ( not FishingBuddy.SortedByZone[loczone] ) then
         FishingBuddy.SortedByZone[loczone] = {};
      end
      tinsert(FishingBuddy.SortedByZone[loczone], subzone);
      table.sort(FishingBuddy.SortedByZone[loczone]);

      if ( not FishingBuddy.UniqueSubZones[subzone] ) then
         FishingBuddy.UniqueSubZones[subzone] = 1;
         tinsert(FishingBuddy.SortedSubZones, subzone);
         table.sort(FishingBuddy.SortedSubZones);
      end

      if ( not FishingBuddy.SubZoneMap[subzone] ) then
         FishingBuddy.SubZoneMap[subzone] = {};
      end
      local sidm = zmto(zidx, sidx);
      FishingBuddy.SubZoneMap[subzone][sidm] = 1;
   end
   if ( marker ) then
      return zmto(zidx, subzonemapping[zidx][subzone]);
   else
      return zidx, subzonemapping[zidx][subzone];
   end
end
FishingBuddy.AddZoneIndex = AddZoneIndex;

local function SetFishingLevel(skillcheck, zone, subzone, fishid)
   if ( not zone ) then
      zone, subzone = GetZoneInfo();
   end
   local idx = AddZoneIndex(zone, subzone, true);
   local fs = FishingBuddy.FishingSkill;
   if ( not fs[idx] ) then
      fs[idx] = 0;
   end
   local skill, mods, _ = FL:GetCurrentSkill();
   if ( not skillcheck ) then
      skillcheck = skill + mods;
   end
   if ( skillcheck > 0 ) then
      if ( not fs[idx] or skillcheck < fs[idx] ) then
         fs[idx] = skillcheck;
      end
      if ( fishid ) then
         if ( not FishingBuddy_Info["Fishies"][fishid].level or
              skillcheck < FishingBuddy_Info["Fishies"][fishid].level ) then
            FishingBuddy_Info["Fishies"][fishid].level = skillcheck;
            FishingBuddy_Info["Fishies"][fishid].skill = skill;
            FishingBuddy_Info["Fishies"][fishid].mods = mods;
         end
      end
   end
   return skill + mods;
end

local CurLoc = GetLocale();
local function AddFishie(color, id, name, zone, subzone, texture, quantity, quality, level, it, st)
   if ( id and not FishingBuddy_Info["Fishies"][id] ) then
      if ( not color ) then
         local _,_,_,hex = GetItemQualityColor(quality);
         _,_,color = string.find(hex, "|c(%a+)");
      end
      FishingBuddy_Info["Fishies"][id] = { };
      FishingBuddy_Info["Fishies"][id][CurLoc] = name;
      FishingBuddy_Info["Fishies"][id].texture = texture;
      FishingBuddy_Info["Fishies"][id].quality = quality;
      if ( color ~= "ffffffff" ) then
         FishingBuddy_Info["Fishies"][id].color = color;
      end
      if ( FishingBuddy.SortedFishies ) then
         tinsert(FishingBuddy.SortedFishies, { text = name, id = id });
         FishingBuddy.FishSort(FishingBuddy.SortedFishies, true);
      end
   end
   if ( name and not FishingBuddy_Info["Fishies"][id][CurLoc] ) then
      FishingBuddy_Info["Fishies"][id][CurLoc] = name;
   end
   -- Currently, only quest items have matching itemType and subType values
   if ( it and st ) then
      FishingBuddy_Info["Fishies"][id].quest = (it == st);
   end

   if ( not zone ) then
      zone = UNKNOWN;
   end
   if ( not subzone ) then
      subzone = zone;
   end
   local zidx, sidx = AddZoneIndex(zone, subzone);
   local idx = zmto(zidx, sidx);

   local ft = FishingBuddy.FishTotals;
   local totidx = zmto(zidx, 0);
   if( not ft[totidx] ) then
      ft[totidx] = quantity;
   else
      ft[totidx] = ft[totidx] + quantity;
   end
   if( not ft[idx] ) then
      ft[idx] = quantity;
   else
      ft[idx] = ft[idx] + quantity;
   end

   if ( not FishingBuddy.currentFishies[idx] ) then
      FishingBuddy.currentFishies[idx] = {};
   end
   if ( not FishingBuddy.currentFishies[idx][id] ) then
      FishingBuddy.currentFishies[idx][id] = quantity;
   else
      FishingBuddy.currentFishies[idx][id] = FishingBuddy.currentFishies[idx][id] + quantity;
   end

   local fh = FishingBuddy.FishingHoles;
   if ( not fh[idx] ) then
      fh[idx] = {};
   end
   if ( not fh[idx][id] ) then
      fh[idx][id] = quantity;
      if ( FishingBuddy.GetSettingBool("ShowNewFishies") ) then
         FishingBuddy.Print(FBConstants.ADDFISHIEMSG, name, subzone);
      end
   else
      fh[idx][id] = fh[idx][id] + quantity;
   end

   if ( FishingBuddy.ByFishie ) then
      if ( not FishingBuddy.ByFishie[id] ) then
         FishingBuddy.ByFishie[id] = {};
      end
      if ( not FishingBuddy.ByFishie[id][idx] ) then
         FishingBuddy.ByFishie[id][idx] = quantity;
      else
         FishingBuddy.ByFishie[id][idx] = FishingBuddy.ByFishie[id][idx] + quantity;
      end
   end

   if ( level ) then
      if ( not FishingBuddy_Info["Fishies"][id].level or
              level < FishingBuddy_Info["Fishies"][id].level ) then
         FishingBuddy_Info["Fishies"][id].level = level;
      else
         level = FishingBuddy_Info["Fishies"][id].level;
      end
   end
   RunHandlers(FBConstants.ADD_FISHIE_EVT, id, name, zone, subzone, texture, quantity, quality, level, idx);
end
FishingBuddy.AddFishie = AddFishie;

FishingBuddy.API.IsFishingPole = function()
   return FL:IsFishingPole();
end

-- we should collect these, but then they would be in the cache
local QuestItems = {};
QuestItems[6717] = {
   ["enUS"] = "Gaffer Jack",
   ["deDE"] = "Klemm-Muffen",
   ["esES"] = "Mecanismo eléctrico",
   ["frFR"] = "Rouage électrique",
};
QuestItems[6718] = {
   ["enUS"] = "Electropeller",
   ["deDE"] = "Elektropeller",
   ["esES"] = "Electromuelle",
   ["frFR"] = "Electropeller",
};
QuestItems[16970] = {
   ["enUS"] = "Misty Reed Mahi Mahi",
   ["deDE"] = "Nebelschilf-Mahi-Mahi",
   ["frFR"] = "Mahi Mahi de Brumejonc",
};
QuestItems[16968] = {
   ["enUS"] = "Sar'theris Striker",
   ["deDE"] = "Sar'theris-Barsch",
   ["frFR"] = "Frappeur Sar'theris",
};
QuestItems[16969] = {
   ["enUS"] = "Savage Coast Blue Sailfin",
   ["deDE"] = "Blauwimpel von der ungezähmten Küste",
   ["frFR"] = "Sailfin bleu de la Côte sauvage",
};
QuestItems[16967] = {
   ["enUS"] = "Feralas Ahi",
   ["frFR"] = "Ahi de Feralas",
};
QuestItems[34865] = {
   ["enUS"] = "Blackfin Darter",
};
QuestItems[45328] = {
   ["enUS"] = "Bloated Monsterbelly",
};
FishingBuddy.QuestItems = QuestItems;

-- User interface handling
local function IsRareFish(id, forced)
   -- always skip extravaganza fish
   if ( FishingBuddy.Extravaganza.Fish[id] ) then
      return true;
   end
   return ( not forced and QuestItems[id] );
end

local function IsQuestFish(id)
   if ( FishingBuddy_Info["Fishies"][id].quest or QuestItems[id] ) then
      return true;
   end
   -- return nil;
end
FishingBuddy.API.IsQuestFish = IsQuestFish;

FishingBuddy.API.IsCountedFish = function(id)
   id = tonumber(id);
   if ( IsQuestFish(id) or IsRareFish(id) or FL:IsMissedFish(id) ) then
      return false;
   end
   if ( id == 40199 ) then
      return false; -- Pygmy Suckerfish
   end
   return true;
end

-- Get an array of all the lures we have in our inventory, sorted by
-- cost, then bonus
-- We'll want to use the cheapest ones we can until our fish don't get
-- away from us

local useinventory = {};
local lureinventory = {};
local function InventoryLures()
   local rawskill, mods, _ = FL:GetCurrentSkill();
   --local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
   --if ( FL:IsFishingPole() and hmhe and LastLure ) then
   --   mods = mods - LastLure.b;
   --end
   useinventory  = {};
   lureinventory  = {};
   for _,lure in ipairs(FISHINGLURES) do
      local id = lure.id;
      local count = GetItemCount(id);
      -- does this lure have to be "worn"
      if ( count > 0 ) then
         if ( lure.u ) then
            tinsert(useinventory, lure);
         elseif ( lure.s <= rawskill ) then
            if ( not lure.w or FL:IsWorn(id)) then
               tinsert(lureinventory, lure);
            end
         end
         -- get the name so we can check enchants
         lure.n,_,_,_,_,_,_,_,_,_ = GetItemInfo(id);
      end
   end
 end

FishingBuddy.DumpLures = function()
   FishingBuddy.Debug("lureinventory: "..#lureinventory);
   for s=1,#lureinventory,1 do
      FishingBuddy.Debug("  "..lureinventory[s].id);
   end
   FishingBuddy.Debug("LureInventory: "..#useinventory);
   for s=1,#useinventory,1 do
      FishingBuddy.Debug("  "..useinventory[s].id);
   end
   FishingBuddy.Debug("FISHINGLURES: "..#FISHINGLURES);
   for _,lure in ipairs(FISHINGLURES) do
      FishingBuddy.Debug("  "..lure.id.." "..lure.n);
   end
end

local function ResetFBButton()
   if (OverrideOn) then
      FB_FishingButton:Hide();
      ClearOverrideBindings(FB_FishingButton);
      OverrideOn = false;
   end
end

local function PostCastUpdate()
   local stop = true;
   if ( not InCombatLockdown() ) then
      ResetFBButton();
      if ( AddingLure ) then
         local sp, rk, dn, ic, st, et = UnitCastingInfo("player");
         if ( not sp or (dn and dn ~= LastLure.n) ) then
            AddingLure = false;
            InventoryLures();
         else
            stop = false;
         end
      end
      if ( stop ) then
         FishingBuddy_PostCastUpdateFrame:Hide();
      end
   end
end
FishingBuddy.PostCastUpdate = PostCastUpdate;

local function HideAwayAll(self, button, down)
   if ( OverrideOn ) then
      FishingBuddy_PostCastUpdateFrame:Show();
   end
end

-- create a secure button to activate fishing
local function CreateFishingButton()
   local btn = CreateFrame("Button", "FB_FishingButton", UIParent, "SecureActionButtonTemplate");
   btn:SetPoint("LEFT", UIParent, "RIGHT", 10000, 0);
   btn:SetFrameStrata("LOW");
   btn:EnableMouse(true);
   btn:RegisterForClicks("RightButtonUp");
   btn:Hide();
   btn:SetScript("PostClick", HideAwayAll);
end

local function InvokeFishing()
   local _, name = FL:GetFishingSkillInfo();
   local findid = FL:GetFishingActionBarID();   
   if ( not FishingBuddy.GetSettingBool("UseAction") or findid == nil ) then
     FB_FishingButton:SetAttribute("type", "spell");
     FB_FishingButton:SetAttribute("spell", name);
     FB_FishingButton:SetAttribute("action", nil);
   else
     FB_FishingButton:SetAttribute("type", "action");
     FB_FishingButton:SetAttribute("action", findid);
     FB_FishingButton:SetAttribute("spell", nil);
   end
   FB_FishingButton:SetAttribute("item", nil);
   FB_FishingButton:SetAttribute("target-slot", nil);
end

local function InvokeLuring(id)
   FB_FishingButton:SetAttribute("type", "item");
   FB_FishingButton:SetAttribute("item", "item:"..id);
   local slot = GetInventorySlotInfo("MainHandSlot");
   FB_FishingButton:SetAttribute("target-slot", slot);
   FB_FishingButton:SetAttribute("spell", nil);
   FB_FishingButton:SetAttribute("action", nil);
end

local function HasBuff(buffName)
    local name, _, _, _, _, _, _, _, _ = UnitBuff("player", buffName);
    return name ~= nil;
end

local function FindNextLure(b, state)
   local n = table.getn(lureinventory);
   for s=state+1,n,1 do
      if ( lureinventory[s] ) then
         local startTime, _, _ = GetItemCooldown(lureinventory[s].id);
         if ( startTime == 0 ) then
            if ( not b or lureinventory[s].b > b ) then 
               return s;
            end
         end
      end
   end
   -- return nil;
end

local function FindBestLure(b, state)
   local zone, subzone = GetZoneInfo();
   local level = LT:GetFishingLevel(zone);
   if ( level ) then
      local rank, modifier, skillmax = FL:GetCurrentSkill();
      local skill = rank + modifier;
      level = level + 95;		-- for no lost fish
      if ( skill < level ) then
         -- if drinking will work, then we're done
         if ( #useinventory > 0 ) then
            if ( not LastUsed or not HasBuff(LastUsed.n) ) then
               local id = useinventory[1].id;
               if ( not HasBuff(useinventory[1].n) ) then
                  if ( level <= (skill + useinventory[1].b) ) then
                     return nil;
                  end
               end
            end
         end
         local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
         if ( LastLure and hmhe ) then
            skill = skill - LastLure.b;
         end
         local n = table.getn(lureinventory);
         for s=state+1,n,1 do
            if ( lureinventory[s] ) then
               local startTime, _, _ = GetItemCooldown(lureinventory[s].id);
               local bonus = lureinventory[s].b;
               if ( startTime == 0 and level <= (skill + bonus) ) then
                  if ( not b or bonus > b ) then 
                     return s;
                  end
               end
            end
         end
      end
      -- return nil;
   else
      return FindNextLure(b, state);
   end
   -- return nil;
end

local function UpdateLure()
   local GSB = FishingBuddy.GetSettingBool;
-- drink first, then apply a lure if we need to
   if ( GSB("FishingFluff") and GSB("DrinkHeavily")) then
      -- Drink, drink, drink
      if ( #useinventory > 0 ) then
         if ( not LastUsed or not HasBuff(LastUsed.n) ) then
            local id = useinventory[1].id;
            if ( not HasBuff(useinventory[1].n) ) then
               LastUsed = useinventory[1];
               InvokeLuring(LastUsed.id);
               return true;
            end
         end
      end
   end

   if ( GSB("EasyLures") ) then
      local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
      if ( DoEscaped ) then
         -- if no lure now, apply this one
         -- if we applied one, apply the next biggest one, or stop if there
         -- is nothing better
         if ( table.getn(lureinventory) > 0 ) then
            if ( LastLure and hmhe ) then
               local b = LastLure.b;
               LureState = FindBestLure(b, LureState);
               if ( LureState ) then
                  DoLure = lureinventory[LureState];
               else
                  DoLure = nil;
                  LureState = 0;
               end
            else
               LureState = 1;
               DoLure = lureinventory[LureState];
            end
         end
         DoEscaped = nil;
      elseif ( GSB("AlwaysLure") ) then
         if ( not hmhe ) then
            LureState = FindBestLure(nil, LureState);
            if ( LureState ) then
               DoLure = lureinventory[LureState];
            else
               DoLure = nil;
               LureState = 0;
            end
         end
      end
      if ( DoLure ) then
         -- if the pole has an enchantment, we can assume it's got a lure on it (so far, anyway)
         -- remove the main hand enchantment (since it's a fishing pole, we know what it is)
         local startTime, duration, enable = GetItemCooldown(DoLure.id);
         if (startTime == 0) then
            AddingLure = true;
            LastLure = DoLure;
            InvokeLuring(DoLure.id);
            DoLure = nil;
            return true;
         end
      end
   end
   return false;
end

local CaptureEvents = {};
CaptureEvents["LOOT_OPENED"] = function()
   IsLooting = true;
   if ( IsFishingLoot()) then
      local zone, subzone = GetZoneInfo();
      for index = 1, GetNumLootItems(), 1 do
         if (LootSlotIsItem(index)) then
-- lootIcon, lootName, lootQuantity, rarity, locked = GetLootSlotInfo(index)
-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,itemEquipLoc, itemTexture = GetItemInfo(itemID or "itemString" or "itemName" or "itemLink") ;
            local texture, fishie, quantity, quality = GetLootSlotInfo(index);
            local link = GetLootSlotLink(index);
            local nm,_,_,_,it,st,_,el,_,il = FL:GetItemInfo(link);
            local color, id, name = FL:SplitFishLink(link);
            AddFishie(color, id, name, zone, subzone, texture, quantity, quality, nil, it, st);
            SetFishingLevel(nil, zone, subzone, id);
            if (quality == 0 and FL:IsMissedFish(id)) then
               DoEscaped = 1;
            end
         end
      end
      ClearTooltipText();
      FL:ExtendDoubleClick();
      LureState = 0;
   end
end

CaptureEvents["LOOT_CLOSED"] = function()
   IsLooting = false;
   FL:ExtendDoubleClick();
end

StatusEvents = {};
StatusEvents["SPELLS_CHANGED"] = function()
   -- Fishing might have moved, go look again
   FL:GetFishingSkillInfo(true);
   InventoryLures();
end

StatusEvents["SKILL_LINES_CHANGED"] = function()
   InventoryLures();
end

StatusEvents["UNIT_SPELLCAST_START"] = function(arg1)
   if ( arg1 == "player" ) then
      Recasting = 0;
   end
end

StatusEvents["ACTIONBAR_SLOT_CHANGED"] = function()
   FL:GetFishingActionBarID(true);
end

-- See if this fixes the "combat while fishing" bug
StatusEvents["PLAYER_REGEN_DISABLED"] = function()
   ResetFBButton();
end

StatusEvents["PLAYER_REGEN_ENABLED"] = function()
   ResetFBButton();
end

StatusEvents["UNIT_AURA"] = function(arg1)
   if ( arg1 == "player" ) then
      local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
      if ( not hmhe ) then
         LastLure = nil;
      end
   end
end

local fishingace_loaded = nil;
local function IsFishingAceLoaded()
   if ( fishingace_loaded == nil ) then
      _, _, _, fishingace_loaded, _, _, _ = GetAddOnInfo("FishingAce");
      if ( not fishingace_loaded ) then
         fishingace_loaded = false;
      end
   end
   if ( fishingace_loaded ) then
      return FishingAce:IsActive();
   end
   -- return nil;
end

local function NormalHijackCheck()
   if ( not IsLooting and not AddingLure and not InCombatLockdown() and not IsFishingAceLoaded() and
       FishingBuddy.GetSettingBool("EasyCast") and CastingKeys() and FL:IsFishingPole() ) then
      return true;
   end
end
FishingBuddy.NormalHijackCheck = NormalHijackCheck;

local HijackCheck = NormalHijackCheck;
local function SetHijackCheck(func)
   if ( not func ) then
      func = NormalHijackCheck;
   end
   HijackCheck = func;
end
FishingBuddy.SetHijackCheck = SetHijackCheck;

local function CentralCasting()
   -- put on a lure if we need to
   if ( not UpdateLure() ) then
      if ( not FL:GetLastTooltipText() or not FL:OnFishingBobber() ) then
          -- watch for fishing holes
         FL:SaveTooltipText();
      end
      InvokeFishing();
   end
   SetOverrideBindingClick(FB_FishingButton, true, "BUTTON2", "FB_FishingButton");
   OverrideOn = true;
   lastClickTime = nil;
end

local SavedWFOnMouseDown;

-- handle mouse up and mouse down in the WorldFrame so that we can steal
-- the hardware events to implement 'Easy Cast'
-- Thanks to the Cosmos team for figuring this one out -- I didn't realize
-- that the mouse handler in the WorldFrame got everything first!
local function WF_OnMouseDown(...)
   -- Only steal 'right clicks' (self is arg #1!)
   local button = select(2, ...);
   if ( button == "RightButton" and HijackCheck() ) then
      if ( FL:CheckForDoubleClick() ) then
          -- We're stealing the mouse-up event, make sure we exit MouseLook
         if ( IsMouselooking() ) then
            MouselookStop();
         end
         CentralCasting();
      end
   end
   if ( SavedWFOnMouseDown ) then
      SavedWFOnMouseDown(...);
   end
end

local function SafeHookMethod(object, method, newmethod)
   local oldValue = object[method];
   if ( oldValue ~= getglobal(newmethod) ) then
      object[method] = newmethod;
      return true;
   end
   return false;
end

local function SafeHookScript(frame, handlername, newscript)
   local oldValue = frame:GetScript(handlername);
   frame:SetScript(handlername, newscript);
   return oldValue;
end

-- override the error message method (need an object as the first arg)
local function UIError_AddMessage( o, msg, a, r, g, b, hold )
   if ( msg and FL:IsFishingPole() and FishingBuddy.GetSettingBool("EasyLures") ) then
      -- if the fish gets away, try adding a lure
      if ( msg == ERR_FISH_ESCAPED ) then
         DoEscaped = 1; -- doesn't happen after 3.1
      elseif ( msg == SPELL_FAILED_LOW_CASTLEVEL ) then
      -- put on the biggest lure we can find
         LureState = table.getn(lureinventory);
         DoLure = lureinventory[LureState];
      else
         local needed = string.match(msg, FBConstants.SPELL_FAILED_FISHING_TOO_LOW);
         if ( needed ) then
         -- record the required level for here
            SetFishingLevel(tonumber(needed));
            local skill, mods = FL:GetCurrentSkill();
            if ( LastLure ) then
               local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
               if ( hmhe ) then
                  mods = mods - LastLure.b;
               end
            end
            skill = skill + mods;
            -- get the first lure big enough to get us where we want
            -- try for no misses first, then try for fishing at all
            -- if we can't get there, don't waste a lure
            -- FindNextLure looks for a bonus bigger than the one we're asking for
            -- so ask for one less than we really want
            DoLure = FindNextLure(needed - skill + 94, 0);
            if ( not DoLure ) then
               DoLure = FindNextLure(needed - skill - 1, 0);
            end
         end
      end
   end
   --Call the original
   local obj = SavedAddMessage.obj;
   local method = SavedAddMessage.method;
   return method( obj, msg, a, r, g, b, hold );
end

FishingBuddy.GetFishie = function(fishid)
   local fi = FishingBuddy_Info["Fishies"][fishid];
   if( fi ) then
      return string.format("%d:0:0:0:0:0:0:0", fishid),
             fi.texture,
             fi.color,
             fi.quantity,
             fi.quality,
             fi[CurLoc],
             fi.quest;
   end
end

FishingBuddy.GetFishieRaw = function(fishid)
   local fi = FishingBuddy_Info["Fishies"][fishid];
   if( fi ) then
      return fishid,
             fi.texture,
             fi.color,
             fi.quantity,
             fi.quality,
             fi[CurLoc],
             fi.quest;
   end
end

-- do everything we think is necessary when we start fishing
-- even if we didn't do the switch to a fishing pole
local resetClickToMove = nil;
local resetAutoLoot = nil;
local function StartFishingMode()
   if ( not FishingBuddy.StartedFishing ) then
      -- Disable Click-to-Move if we're fishing
      if ( GetCVar("autointeract") == "1" ) then
         resetClickToMove = true;
         SetCVar("autointeract", "0");
      end
      if ( FishingBuddy.GetSettingBool("AutoLoot") ) then
         if ( GetCVar("autoLootDefault") ~= "1" ) then
            resetAutoLoot = true;
            SetCVar("autoLootDefault", "1");
         end
      end
      FishingBuddy.EnhanceFishingSounds(true);
      EventRegistration(true);
      LureState = 0;   -- start with the cheapest lure
      local hmhe,_,_,_,_,_ = GetWeaponEnchantInfo();
      if ( not hmhe ) then
         LastLure = nil;
      end
      FishingBuddy.StartedFishing = GetTime();
      RunHandlers(FBConstants.FISHING_ENABLED_EVT);
   end
   -- we get invoked when items get equipped as well
   InventoryLures();
end

local function StopFishingMode()
   if ( FishingBuddy.StartedFishing ) then
      FishingBuddy.EnhanceFishingSounds(false);
      FishingBuddy.WatchUpdate();
      EventRegistration(false);
      RunHandlers(FBConstants.FISHING_DISABLED_EVT, FishingBuddy.StartedFishing);
      FishingBuddy.StartedFishing = nil;
   end
   if ( resetClickToMove ) then
      -- Re-enable Click-to-Move if we changed it
      SetCVar("autointeract", "1");
      resetClickToMove = nil;
   end
   if ( resetAutoLoot ) then
      SetCVar("autoLootDefault", "0");
      resetAutoLoot = nil;
   end
end

local function FishingMode()
   if ( FL:IsFishingPole() ) then
      StartFishingMode();
   else
      StopFishingMode();
   end
end
FishingBuddy.API.FishingMode = FishingMode;

FishingBuddy.IsSwitchClick = function(setting)
   if ( not setting ) then
      setting = "ClickToSwitch";
   end
   local a = IsShiftKeyDown();
   local b = FishingBuddy.GetSettingBool(setting);
   return ( (a and (not b)) or ((not a) and b) );
end

FishingBuddy.TrapUIErrors = function()
   local temp = {};
   temp.obj= UIErrorsFrame;
   temp.method = UIErrorsFrame["AddMessage"];
   if ( SafeHookMethod(UIErrorsFrame, "AddMessage", UIError_AddMessage) ) then
      SavedAddMessage = temp;
   end
end

local function TrapWorldMouse()
   if ( WorldFrame.OnMouseDown ) then
      hooksecurefunc(WorldFrame, "OnMouseDown", WF_OnMouseDown) 
   else
      SavedWFOnMouseDown = SafeHookScript(WorldFrame, "OnMouseDown", WF_OnMouseDown);
   end
end
FishingBuddy.TrapWorldMouse = TrapWorldMouse;

local function OptionsUpdate(changed)
   FL:WatchBobber(FishingBuddy.GetSettingBool("WatchBobber"));
   RunHandlers(FBConstants.OPT_UPDATE_EVT, changed);
end
FishingBuddy.OptionsUpdate = OptionsUpdate;

FishingBuddy.Commands[FBConstants.UPDATEDB] = {};
FishingBuddy.Commands[FBConstants.UPDATEDB].help = FBConstants.UPDATEDB_HELP;
FishingBuddy.Commands[FBConstants.UPDATEDB].func =
   function(what)
      local ff = FishingBuddy_Info["Fishies"];
      local forced;
      if ( what and what == FBConstants.FORCE ) then
         forced = true;
      end
      FishingBuddyTooltip:SetOwner(FishingBuddyFrame, "ANCHOR_RIGHT");
      FishingBuddyTooltip:Show();
      local count = 0;
      for id,info in pairs(ff) do
         local item = id..":0:0:0";
         if ( forced or not FL:IsLinkableItem(item) or not info.name ) then
            if ( not IsRareFish(id, forced) ) then
               local link = "item:"..item;
               -- fetch the data (may disconnect)
               FishingBuddy.Debug(link);
               FishingBuddyTooltip:SetHyperlink(link);
               -- now that we have it in our cache, get the name
               local nm,li,ra,ml,it,st,sc,el,tx,il = FL:GetItemInfo(link);
               if ( nm ) then
                  count = count + 1;
                  FishingBuddy_Info["Fishies"][id][CurLoc] = nm;
                  FishingBuddy_Info["Fishies"][id].quest = (it == st);
               end
            end
         end
      end
      FishingBuddy.Print(FBConstants.UPDATEDB_MSG, count);
      return true;
   end;

FishingBuddy.Commands[FBConstants.CURRENT] = {};
FishingBuddy.Commands[FBConstants.CURRENT].help = FBConstants.CURRENT_HELP;
FishingBuddy.Commands[FBConstants.CURRENT].func =
   function(what)
      if ( what and what == FBConstants.RESET) then
         FishingBuddy.currentFishies = {};
         FishingMode();
         return true;
      end
   end;

local function nextarg(msg, pattern)
   if ( not msg or not pattern ) then
      return nil, nil;
   end
   local s,e = string.find(msg, pattern);
   if ( s ) then
      local word = strsub(msg, s, e);
      msg = strsub(msg, e+1);
      return word, msg;
   end
   return nil, msg;
end

FishingBuddy.Command = function(msg)
   if ( not msg ) then
      return;
   end
   if ( FishingBuddy.IsLoaded() ) then
      -- collect arguments (whee, lua string manipulation)
      local cmd;
      cmd, msg = nextarg(msg, "[%w]+");

      -- the empty string gives us no args at all
      if ( not cmd ) then
         -- toggle window
         if ( FishingBuddyFrame:IsVisible() ) then
            HideUIPanel(FishingBuddyFrame);
         else
            ShowUIPanel(FishingBuddyFrame);
         end
      elseif ( cmd == FBConstants.HELP or cmd == "help" ) then
         FishingBuddy.Output(FBConstants.WINDOW_TITLE);
         if ( not FBConstants.HELPMSG ) then
            FBConstants.HELPMSG = { "@PRE_HELP" };
            for cmd,info in pairs(FishingBuddy.Commands) do
               tinsert(FBConstants.HELPMSG, info.help);
            end
            tinsert(FBConstants.HELPMSG, "@POST_HELP");
            FL:FixupEntry(FBConstants, "HELPMSG")
         end
         FishingBuddy.PrintHelp(FBConstants.HELPMSG);
      else
         local command = FishingBuddy.Commands[cmd];
         if ( command ) then
            local args = {};
            local goodargs = true;
            if ( command.args ) then
               for _,pat in pairs(command.args) do
                  local w, msg = nextarg(msg, pat);
                  if ( not w ) then
                     goodargs = false;
                     break;
                  end
                  tinsert(args, w);
               end
            else
               local a;
               while ( msg ) do
                  a, msg = nextarg(msg, "[%w]+");
                  if ( not a ) then
                     break;
                  end
                  tinsert(args, a);
               end
            end
            if ( not goodargs or not command.func(unpack(args)) ) then
               if ( command.help ) then
                  FishingBuddy.PrintHelp(command.help);
               else
                  FishingBuddy.Debug("command failed");
               end
            end
         else
            FishingBuddy.Command("help");
         end
      end
   else
      FishingBuddy.Error(FBConstants.FAILEDINIT);
   end
end

FishingBuddy.TooltipBody = function(hintcheck)
   local text = FBConstants.DESCRIPTION1.."\n"..FBConstants.DESCRIPTION2;
   if ( hintcheck ) then
      local hint = FBConstants.TOOLTIP_HINT.." ";
      if (FishingBuddy.GetSettingBool(hintcheck)) then
         hint = hint..FBConstants.TOOLTIP_HINTSWITCH;
      else
         hint = hint..FBConstants.TOOLTIP_HINTTOGGLE;
      end
      text = text.."\n"..Crayon:Green(hint);
   end
   return text;
end

local IsZoning;
local ZoneEvents;
local function TrackZoneEvents(evt)
   if ( IsZoning ) then
      if ( not ZoneEvents ) then
         ZoneEvents = {};
      end
      if ( ZoneEvents[evt] ) then
         ZoneEvents[evt] = ZoneEvents[evt] + 1;
      else
         ZoneEvents[evt] = 1;
      end
   end
end

local function DumpZoneEvents()
   FishingBuddy.Dump(ZoneEvents);
   ZoneEvents = nil;
end

FishingBuddy.OnEvent = function(self, event, ...)
--   local line = event;
--   for idx=1,select("#",...) do
--      line = line.." '"..select(idx,...).."'";
--   end
--   FishingBuddy.Debug(line);
   local arg1 = ...;

-- TrackZoneEvents(event);
   if ( event == "PLAYER_EQUIPMENT_CHANGED" or
       event == "ITEM_LOCK_CHANGED" or event == "WEAR_EQUIPMENT_SET") then
      FishingMode();
   elseif ( event == "PLAYER_LOGIN" ) then
      playerName = UnitName("player");
      realmName = GetRealmName();
      CreateFishingButton();
      -- sort ascending bonus and ascending time
      table.sort(FISHINGLURES,
         function(a,b)
            if ( a.b == b.b ) then
               return a.d < b.d;
            else
               return a.b < b.b;
            end
         end);
      RunHandlers(FBConstants.LOGIN_EVT);
   elseif ( event == "PLAYER_LOGOUT" ) then
      -- reset the fishing sounds, if we need to
      RunHandlers(FBConstants.LOGOUT_EVT);
      StopFishingMode();
      FishingBuddy.SavePlayerInfo();
   elseif ( event == "SPELLS_CHANGED" ) then
      -- need to wait until here, since some things depend on the name of the fishing skill
      FishingMode();
      -- only do this the first time
      self:UnregisterEvent("SPELLS_CHANGED");
   elseif ( event == "VARIABLES_LOADED" ) then
      local _, name = FL:GetFishingSkillInfo();
      FishingBuddy.Initialize();
      FishingBuddy.OptionsFrame.HandleOptions(GENERAL, "Interface\\Icons\\Ability_Kick", GeneralOptions);
      FishingBuddy.OptionsFrame.HandleOptions(name, "Interface\\Icons\\INV_Fishingpole_02", CastingOptions);
      FishingBuddy.OptionsFrame.HandleOptions(nil, nil, InvisibleOptions);
      FishingBuddy.OptionsUpdate();
      
      self:UnregisterEvent("VARIABLES_LOADED");
   elseif ( event == "PLAYER_ENTERING_WORLD" ) then
      IsZoning = nil;
--    DumpZoneEvents();
      EventRegistration(true);
      self:RegisterEvent("ITEM_LOCK_CHANGED");
      self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
   elseif ( event == "PLAYER_LEAVING_WORLD") then
      RunHandlers(FBConstants.LEAVING_EVT);
      IsZoning = 1;
      EventRegistration(false);
      self:UnregisterEvent("ITEM_LOCK_CHANGED");
      self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED");
   end
   FishingBuddy.Extravaganza.IsTime(true);
   RunHandlers(event, ...);
   RunHandlers("*", ...);
end

FishingBuddy.OnLoad = function(self)
   self:RegisterEvent("PLAYER_ENTERING_WORLD");
   self:RegisterEvent("PLAYER_LEAVING_WORLD");

   self:RegisterEvent("PLAYER_LOGIN");
   self:RegisterEvent("PLAYER_LOGOUT");
   self:RegisterEvent("SPELLS_CHANGED");
   self:RegisterEvent("VARIABLES_LOADED");
   
   -- Handle item lock separately to reduce churn during world load
   -- self:RegisterEvent("ITEM_LOCK_CHANGED");
   -- self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
   self:RegisterEvent("WEAR_EQUIPMENT_SET");

   self:SetScript("OnEvent", FishingBuddy.OnEvent);

   RegisterHandlers(CaptureEvents);
   RegisterHandlers(StatusEvents);

   -- Set up command
   SlashCmdList["fishingbuddy"] = FishingBuddy.Command;
   SLASH_fishingbuddy1 = "/fishingbuddy";
   SLASH_fishingbuddy2 = "/fb";
   
   FishingBuddy.Output(FBConstants.WINDOW_TITLE.." loaded");
end

-- allow other parts of the code to watch for events when not fishing
FishingBuddy.RegisterEvent = function(event, handler)
   FishingBuddyRoot:RegisterEvent(event);
   AddHandler(event, handler);
end

FishingBuddy.UnregisterEvent = function(event, handler)
   FishingBuddyRoot:UnregisterEvent(event);
   RemoveHandler(event, handler);
   if ( event_handlers[event] and table.getn(event_handlers[event]) == 0 ) then
      event_handlers[event] = nil;
      FishingBuddyRoot:UnregisterEvent(event);
      if (reg_events[event]) then
         reg_events[event] = nil;
         handlerframe:UnregisterEvent(event);
      end
   end
end

FishingBuddy.PrintHelp = function(tab)
   if ( tab ) then
      if ( type(tab) == "table" ) then
         for _,line in pairs(tab) do
            FishingBuddy.PrintHelp(line);
         end
      else
         -- check for a reference to another help item
         local _,_,w = string.find(tab, "^@([A-Z0-9_]+)$");
         if ( w ) then
            FishingBuddy.PrintHelp(FBConstants[w]);
         else
            FishingBuddy.Output(tab);
         end
      end
   end
end

local efsv = nil;
FishingBuddy.EnhanceFishingSounds = function(enhance)
   if ( FishingBuddy.GetSettingBool("EnhanceFishingSounds") ) then
      if ( enhance ) then
         local mv = tonumber(GetCVar("Sound_MasterVolume"));
         local mu = tonumber(GetCVar("Sound_MusicVolume"));
         local av = tonumber(GetCVar("Sound_AmbienceVolume"));
         local sv = tonumber(GetCVar("Sound_SFXVolume"));
         local sb = tonumber(GetCVar("Sound_EnableSoundWhenGameIsInBG")); 

         if ( not efsv ) then
         -- collect the current value
            efsv = {};
            efsv["Sound_MasterVolume"] = mv;
            efsv["Sound_MusicVolume"] = mu;
            efsv["Sound_AmbienceVolume"] = av;
            efsv["Sound_SFXVolume"] = sv;
            efsv["Sound_EnableSoundWhenGameIsInBG"] = sb;
            -- turn 'em off!
            for setting in pairs(efsv) do
               local value = FishingBuddy.GetSetting("Enhance"..setting);
               SetCVar(setting, value);
            end
         end
      else
         if ( efsv ) then
            for setting, value in pairs(efsv) do
               SetCVar(setting, value);
            end
            efsv = nil;
         end
      end
   end
end

FishingBuddy.FishSort = function(tab, forcename)
   if ( forcename or not FishingBuddy.GetSettingBool("SortByPercent") ) then
      table.sort(tab, function(a,b) return (a.index and b.index and a.index<b.index) or
                                           (a.text and b.text and a.text<b.text); end);
   else
      table.sort(tab, function(a,b) return a.count and b.count and b.count<a.count; end);
   end
end

local function nocase (s)
   s = string.gsub(s, "%a", function (c)
                               return string.format("[%s%s]", string.lower(c),
                                     string.upper(c))
                            end)
   return s
end

FishingBuddy.StripRaw = function(fishie)
   if ( fishie ) then
      local raw = nocase(FBConstants.RAW);
      local s,e = string.find(fishie, raw.." ");
      if ( s ) then
         if ( s > 1 ) then
            fishie = string.sub(fishie, 1, s-1)..string.sub(fishie, e+1);
         else
            fishie = string.sub(fishie, e+1);
         end
      else
         s,e = string.find(fishie, " "..raw);
         if ( s ) then
            fishie = string.sub(fishie, 1, s-1)..string.sub(fishie, e+1);
         end
      end
      return fishie;
   end
   -- this means an import failed somewhere
   return UNKNOWN;
end

FishingBuddy.ToggleDropDownMenu = function(level, value, menu, anchor, xOffset, yOffset)
   ToggleDropDownMenu(level, value, menu, anchor, xOffset, yOffset);
   if (not level) then
      level = 1;
   end
   local anchorName;
   if ( type(anchor) == "string" ) then
      anchorName = anchor;
   else
      anchorName = anchor:GetName();
   end
   local frame = getglobal("DropDownList"..level);
   local uiScale = UIParent:GetScale()
   if ( frame:GetRight() > ( GetScreenWidth()*uiScale ) ) then
      if ( anchorName == "cursor" ) then
         if ( not xOffset ) then
            xOffset = 0;
         end
         if ( not yOffset ) then
            yOffset = 0;
         end
         local cursorX, cursorY = GetCursorPosition();
         xOffset = -cursorX + xOffset;
         yOffset = cursorY + yOffset;
      else
         if ( not xOffset or not yOffset ) then
            xOffset = 8;
            yOffset = 22;
         end
      end
      frame:ClearAllPoints();
      frame:SetPoint("TOPRIGHT", anchorName, "BOTTOMLEFT", -xOffset, yOffset);
   end
   if ( frame:GetBottom() < 0 ) then
      frame:ClearAllPoints();
      frame:SetPoint("BOTTOMRIGHT", anchorName, "BOTTOMLEFT", -xOffset, yOffset);
   end
end

FishingBuddy.EnglishList = function(list, conjunction)
   if ( list ) then
      local n = table.getn(list);
      local str = "";
      for idx=1,n do
         local name = list[idx];
         if ( idx == 1 ) then
            str = name;
         elseif ( idx == n ) then
            str = str .. ", ";
            if ( conjunction ) then
               str = str .. conjunction;
            else
               str = str .. "and";
            end
               str = str .. " " .. name;
         else
            str = str .. ", " .. name;
         end
      end
      return str;
   end
end

FishingBuddy.UIError = function(msg)
   -- Okay, this check is probably not necessary...
   if ( UIErrorsFrame ) then
      UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
   else
      FishingBuddy.Error(msg);
   end
end

FishingBuddy.Testing = function(line)
   if ( not FishingBuddy_Info["Testing"] ) then
      FishingBuddy_Info["Testing"] = {};
   end
   tinsert(FishingBuddy_Info["Testing"], line);
end

FishingBuddy.Commands["poles"] = {};
FishingBuddy.Commands["poles"].func =
   function()
      local _,_,_,_,fp_itemtype,fp_subtype,_,_,_,_ = FL:GetItemInfo(6256);
      FishingBuddy.Debug("'"..fp_itemtype.."' '"..fp_subtype.."'");
      for name,item in pairs(POLES) do
         local link = "item:"..item;
         if ( not FL:IsLinkableItem(item) ) then
            FishingBuddy.Debug(link);
            -- fetch the data (may disconnect)
            FishingBuddyTooltip:SetHyperlink(link);
         end
         -- now that we have it in our cache, get the name
         local nm,li,ra,ml,it,st,sc,el,tx,il = FL:GetItemInfo(link);
         if ( nm ) then
            FishingBuddy.Debug("    '"..it.."' '"..st.."'");
         end
      end
      return true;
   end
