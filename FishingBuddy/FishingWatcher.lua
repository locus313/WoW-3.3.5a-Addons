-- Display the fish you're catching and/or have caught in a live display

FishingBuddy.WatchFrame = {};

local MAX_FISHINGWATCH_LINES = 1;
local WATCHDRAGGER_SHOW_DELAY = 0.5;

local WATCHDRAGGER_FADE_TIME = 0.15;

local zmto = FishingBuddy.ZoneMarkerTo;
local zmex = FishingBuddy.ZoneMarkerEx;

local ZoneFishingTime = 0;
local TotalTimeFishing = 0;

local Crayon = LibStub("LibCrayon-3.0");
local FL = LibStub("LibFishing-1.0");
local LT = LibStub("LibTourist-3.0");

local WatcherOptions = {
   ["WatchFishies"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCH_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCH_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1 },
   ["WatchCurrentSkill"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCHSKILL_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCHSKILL_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1,
      ["deps"] = { ["WatchFishies"] = "d" } },
   ["WatchOnlyWhenFishing"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCHONLY_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCHONLY_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1,
      ["deps"] = { ["WatchFishies"] = "d" } },
   ["WatchCurrentZone"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCHZONE_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCHZONE_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0,
      ["deps"] = { ["WatchFishies"] = "d" } },
   ["WatchFishPercent"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCHPERCENT_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCHPERCENT_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 1,
      ["deps"] = { ["WatchFishies"] = "d" } },
   ["WatchElapsedTime"] = {
      ["text"] = FBConstants.CONFIG_FISHWATCHTIME_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHWATCHTIME_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["default"] = 0,
      ["deps"] = { ["WatchFishies"] = "d" } },
};

local function PlaceDraggerFrame()
   local where = FishingBuddy.GetSetting("WatcherLocation");
   if ( not where ) then
      where = {};
      where.x = 0;
      where.y = -384;
   end
   FishingWatchDrag:ClearAllPoints();
   FishingWatchDrag:SetPoint("TOPLEFT", "UIParent", "TOPLEFT",
                                  where.x, where.y);
end

local function PanelTemplates_TabResize_Copy(tab, padding, absoluteSize, maxWidth, absoluteTextSize)
	local tabName = tab:GetName();
	
	local buttonMiddle = getglobal(tabName.."Middle");
	local buttonMiddleDisabled = getglobal(tabName.."MiddleDisabled");
	local sideWidths = 2 * getglobal(tabName.."Left"):GetWidth();
	local tabText = getglobal(tab:GetName().."Text");
	local width, tabWidth;
	local textWidth;
	if ( absoluteTextSize ) then
		textWidth = absoluteTextSize;
	else
		textWidth = tabText:GetWidth();
	end
	-- If there's an absolute size specified then use it
	if ( absoluteSize ) then
		if ( absoluteSize < sideWidths) then
			width = 1;
			tabWidth = sideWidths
		else
			width = absoluteSize - sideWidths;
			tabWidth = absoluteSize
		end
		tabText:SetWidth(width);
	else
		-- Otherwise try to use padding
		if ( padding ) then
			width = textWidth + padding;
		else
			width = textWidth + 24;
		end
		-- If greater than the maxWidth then cap it
		if ( maxWidth and width > maxWidth ) then
			if ( padding ) then
				width = maxWidth + padding;
			else
				width = maxWidth + 24;
			end
			tabText:SetWidth(width);
		else
			tabText:SetWidth(0);
		end
		tabWidth = width + sideWidths;
	end
	
	if ( buttonMiddle ) then
		buttonMiddle:SetWidth(width);
	end
	if ( buttonMiddleDisabled ) then
		buttonMiddleDisabled:SetWidth(width);
	end
	
	tab:SetWidth(tabWidth);
	local highlightTexture = getglobal(tabName.."HighlightTexture");
	if ( highlightTexture ) then
		highlightTexture:SetWidth(tabWidth);
	end
end

local function SizeDraggerFrame()
   local width = FishingWatchFrame:GetWidth();
   local height = FishingWatchFrame:GetHeight();
   FishingWatchDrag:SetHeight(height);
   FishingWatchDrag:SetWidth(width);
end

local function ShowDraggerFrame()
   if ( not FishingWatchDrag:IsVisible() ) then
      SizeDraggerFrame();
      FishingWatchTab:SetText(FBConstants.NAME);
      PanelTemplates_TabResize_Copy(FishingWatchTab, 10);
      FishingWatchTab:Show();
      FishingWatchDrag:Show();
      UIFrameFadeIn(FishingWatchDrag, WATCHDRAGGER_FADE_TIME, 0, 0.15);
      UIFrameFadeIn(FishingWatchTab, WATCHDRAGGER_FADE_TIME, 0, 1.0);
   end
end

local function HideDraggerFrame(save)
   if ( FishingWatchDrag:IsVisible() ) then
      if ( save ) then
         local qx = UIParent:GetLeft()
         local qy = UIParent:GetTop();
         local wx = FishingWatchDrag:GetLeft()
         local wy = FishingWatchDrag:GetTop();
         local where;
         if ( wx and wy ) then
            where = {};
            where.x = wx - qx;
            where.y = wy - qy;
         end
         FishingBuddy.SetSetting("WatcherLocation", where);
      end
      UIFrameFadeOut(FishingWatchDrag, WATCHDRAGGER_FADE_TIME, 0.15, 0);
      UIFrameFadeOut(FishingWatchTab, WATCHDRAGGER_FADE_TIME, 1.0, 0);
      FishingWatchDrag:Hide();
      FishingWatchTab:Hide();
   end
end

local function ResetWatcherFrame(update)
   PlaceDraggerFrame();
   FishingWatchTab:Show();
   FishingWatchDrag:Show();
   FishingWatchDrag:ClearAllPoints();
   FishingWatchDrag:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
   HideDraggerFrame(true);
   if ( update ) then
      FishingBuddy.WatchUpdate();
   end
end

FishingBuddy.ShowDraggerFrame = ShowDraggerFrame;
FishingBuddy.HideDraggerFrame = HideDraggerFrame;
FishingBuddy.PlaceDraggerFrame = PlaceDraggerFrame;
FishingBuddy.ResetWatcherFrame = ResetWatcherFrame;

FishingBuddy.Commands[FBConstants.WATCHER] = {};
FishingBuddy.Commands[FBConstants.WATCHER].help = FBConstants.WATCHER_HELP;
FishingBuddy.Commands[FBConstants.WATCHER].func =
   function(what)
      if ( what and ( what == FBConstants.RESET ) ) then
         ResetWatcherFrame(true);
         return true;
      end
   end;

local function HandleZoneChange()
   if ( not FishingBuddy.IsLoaded() ) then
      return;
   end
   FishingBuddy.currentFishies = {};
   FishingBuddy.WatchUpdate();
   TotalTimeFishing = TotalTimeFishing + ZoneFishingTime;
   ZoneFishingTime = 0;
end

-- keep track of what's going on
local caughtSoFar = 0;
local lastSkillCheck = 0;
local lastSkillMax = 0;
local WatchEvents = {};
WatchEvents["ZONE_CHANGED"] = HandleZoneChange;
WatchEvents["ZONE_CHANGED_INDOORS"] = HandleZoneChange;
WatchEvents["ZONE_CHANGED_NEW_AREA"] = HandleZoneChange;

WatchEvents["SKILL_LINES_CHANGED"] = function()
   if ( FishingBuddy.GetSettingBool("WatchCurrentSkill") ) then
      FishingBuddy.WatchUpdate();
   end
end

WatchEvents["SPELLCAST_STOP"] = function()
   if ( FishingWatchFrame:IsVisible() ) then
      -- update the skill line if we have one
      if ( FishingBuddy.GetSettingBool("WatchCurrentSkill") ) then
         FishingBuddy.WatchUpdate();
      end
   end
end

WatchEvents[FBConstants.ADD_FISHIE_EVT] = function()
   if ( FishingWatchFrame:IsVisible() ) then
      caughtSoFar = caughtSoFar + 1;
      FishingBuddy.WatchUpdate();
   end
end

WatchEvents[FBConstants.OPT_UPDATE_EVT] = function(changed)
   FishingBuddy.WatchUpdate();
end

WatchEvents["VARIABLES_LOADED"] = function()
   caughtSoFar = FishingBuddy.GetSetting("CaughtSoFar");
   TotalTimeFishing = FishingBuddy.GetSetting("TotalTimeFishing");
   ZoneFishingTime = 0;
   lastSkillCheck, _, lastSkillMax = FL:GetCurrentSkill();

   -- Make everything draw at least once
   ShowDraggerFrame();
   HideDraggerFrame();
   
   FishingBuddy.OptionsFrame.HandleOptions("Watcher", "Interface\\Icons\\INV_Misc_Fish_02", WatcherOptions);
end

WatchEvents[FBConstants.FISHING_ENABLED_EVT] = function()
   FishingBuddy.WatchUpdate();
end

WatchEvents[FBConstants.FISHING_DISABLED_EVT] = function(started)
   ZoneFishingTime = ZoneFishingTime + GetTime() - started;
end

WatchEvents[FBConstants.LEAVING_EVT] = function()
   FishingBuddy.SetSetting("CaughtSoFar", caughtSoFar);
   FishingBuddy.SetSetting("TotalTimeFishing", TotalTimeFishing + ZoneFishingTime);
end

-- fix old data
local function UpdateUnknownZone(zone, subzone, zidx, sidx)
   local uzidx = FishingBuddy.GetZoneIndex(UNKNOWN);
   if ( uzidx ) then
      local fh = FishingBuddy.FishingHoles;
      local uidx = zmto(uzidx,0);
      local count = FishingBuddy.SubZones[uidx];
      if ( count ) then
         for s=1,count,1 do
            uidx = zmto(uzidx, s);
            if ( fh[uidx] ) then
               local uszone = FishingBuddy.SubZones[uidx];
               if ( uszone == subzone ) then
                  for k,v in pairs(fh[uidx]) do
                     if ( fh[sidx][k] ) then
                        fh[sidx][k] = fh[sidx][k] + v;
                     else
                        fh[sidx][k] = v;
                     end
                  end
                  for k,_ in pairs(fh[uidx]) do
                     fh[uidx][k] = nil;
                  end
               end
            end
         end
      end
   end
end

local function Fix0(i)
   if ( i < 10 ) then
      return "0"..i;
   else
      return i;
   end
end

local function DisplayedTime(elapsed)
   local t = math.floor(elapsed);
   local mod = math.fmod;
   local seconds = mod(t, 60);
   t = math.floor(t / 60);
   local minutes = mod(t, 60);
   local hours = math.floor(t / 60);
   return Fix0(hours)..":"..Fix0(minutes)..":"..Fix0(seconds);
end

local fishingWatchMaxWidth;
local function SetEntry(index, text)
   local name = "FishingWatchLine"..index;
   entry = getglobal(name);
   if ( not entry ) then
      local first = getglobal("FishingWatchLine1");
      entry = FishingWatchFrame:CreateFontString(name, "BACKGROUND", "FishingWatchFontTemplate");
      entry:SetJustifyH("LEFT");
      entry:SetHeight(first:GetHeight());
      entry:SetPoint("TOPLEFT", "FishingWatchLine"..(index-1), "BOTTOMLEFT");
      local fontFile, fontSize, fontFlags = first:GetFont();
	  entry:SetFont(fontFile, fontSize, fontFlags);
      MAX_FISHINGWATCH_LINES = MAX_FISHINGWATCH_LINES + 1;
   end
   entry:SetText(text);
   local tempWidth = entry:GetWidth();
   if ( not fishingWatchMaxWidth or tempWidth > fishingWatchMaxWidth ) then
      fishingWatchMaxWidth = tempWidth;
   end
   entry:Show();
end

local fishshown = nil;
-- Fish watcher functions
local function WatchUpdate(justTime)
   local noshow = (not FishingBuddy.GetSettingBool("WatchFishies")) or
      (FishingBuddy.GetSettingBool("WatchOnlyWhenFishing") and not FL:IsFishingPole());

   local reset = FishingBuddy.GetSetting("ResetWatcher");
   if ( not reset or reset < 1 ) then
      ResetWatcherFrame(false);
      FishingBuddy.SetSetting("ResetWatcher", 1);
   end

   local zone, subzone = FishingBuddy.GetZoneInfo();
   if ( zone == UNKNOWN ) then
      return;
   end

   local zidx, sidx = FishingBuddy.AddZoneIndex(zone, subzone);

   UpdateUnknownZone(zone, subzone, zidx, sidx);

   if ( noshow ) then
      HideDraggerFrame();
      FishingWatchFrame:Hide();
      for i=1, MAX_FISHINGWATCH_LINES, 1 do
         local line = getglobal("FishingWatchLine"..i);
         line:Hide();
      end
      FishingBuddy_WatchTimeFrame:Hide();
      fishshown = nil;
      return;
   end

   if ( not FishingWatchFrame:IsShown() ) then
      PlaceDraggerFrame();
      FishingWatchFrame:Show();
   end

   local IsCountedFish = FishingBuddy.API.IsCountedFish;
   local IsQuestFish = FishingBuddy.API.IsQuestFish;
   local current = FishingBuddy.currentFishies;
   local ff = FishingBuddy_Info["Fishies"];
   local tempWidth;
   local index = 1;
   local start = 1;
   local dopercent = FishingBuddy.GetSettingBool("WatchFishPercent");
   local entry, line;

   fishingWatchMaxWidth = 0;
   if ( FishingBuddy.GetSettingBool("WatchElapsedTime") ) then
      local StartedFishing = FishingBuddy.StartedFishing;
      if ( StartedFishing ) then
         local elapsed = math.floor(ZoneFishingTime + GetTime() - StartedFishing);
         local text = FBConstants.ELAPSED..": "..DisplayedTime(elapsed).."/"..DisplayedTime(math.floor(elapsed + TotalTimeFishing));
         SetEntry(index, text);
         FishingBuddy_WatchTimeFrame:Show();
         if ( justTime and fishshown ) then
            return;
         end
         index = index + 1;
      end
   else
      FishingBuddy_WatchTimeFrame:Hide();
   end
   
   local skill, mods, skillmax = FL:GetCurrentSkill();
   local zoneskill, playerskill = FL:GetFishingSkillLine(false, true);
   local totskill = skill + mods;
   if ( FishingBuddy.GetSettingBool("WatchCurrentZone") ) then
      SetEntry(index, zoneskill);
      index = index + 1;
   end

   local basetexture = "INV_Misc_Coin";
   local goldtexture = "_17";
   local silvertexture = "_18";
   local coppertexture = "_19";
   local fishsort = {};
   local totalCount = 0;
   local totalCurrent = 0;
   local gotDiffs = false;
   local goldcoins = { ["count"] = 0, ["current"] = 0, ["text"] = FBConstants.GOLD_COIN, ["calc"] = 1 };
   local silvercoins = { ["count"] = 0, ["current"] = 0, ["text"] = FBConstants.SILVER_COIN, ["calc"] = 1 };
   local coppercoins = { ["count"] = 0, ["current"] = 0, ["text"] = FBConstants.COPPER_COIN, ["calc"] = 1 };
   local missed = { ["count"] = 0, ["current"] = 0, ["text"] = SPELL_FAILED_TRY_AGAIN, ["quality"] = 0, ["calc"] = 1, ["skipped"] = 1 };

   local idx = zmto(zidx, sidx);
   local fz = FishingBuddy.FishingHoles;
   if ( fz and fz[idx] ) then
      local loc = GetLocale();
      for fishid in pairs(fz[idx]) do
         local info = {};
         if ( not FishingBuddy_Info["HiddenFishies"][fishid] ) then
            info.text = ff[fishid][loc];
         end
         info.quality = ff[fishid].quality or 0;
         local itemTexture = ff[fishid].texture;
         local n = fz[idx][fishid];
         if (string.find(itemTexture, basetexture)) then
            if (string.find(itemTexture, goldtexture)) then
               info = goldcoins;
            elseif (string.find(itemTexture, silvertexture)) then
               info = silvercoins;
            elseif (string.find(itemTexture, coppertexture)) then
               info = coppercoins;
            end
            info.count = info.count + n;
            totalCount = totalCount + n;
            if ( current[idx] ) then
               local c = (current[idx][fishid] or 0);
               info.current = info.current + c;
               totalCurrent = totalCurrent + c;
            end
         elseif (FL:IsMissedFish(fishid)) then
            missed.count = missed.count + n;
            if ( current[idx] ) then
               local c = (current[idx][fishid] or 0);
               missed.current = missed.current + c;
            end
            info = missed;
         else
            info.count = n;
            if ( current[idx] ) then
               info.current = current[idx][fishid] or 0;
            else
               info.current = 0;
            end
            if ( IsCountedFish(fishid) ) then
               totalCount = totalCount + info.count;
               totalCurrent = totalCurrent + info.current;
            else
               info.skipped = 1;
               info.quest = IsQuestFish(fishid);
            end
         end
         if ( info.current and info.current > 0 and info.current ~= info.count ) then
            gotDiffs = true;
         end

         if ( not info.calc ) then
            tinsert(fishsort, info);
         end
      end
--   if ( totalCount == 0 and totalCurrent == 0 ) then
--      return;
--   end
      FishingBuddy.FishSort(fishsort);
      if (coppercoins.count > 0) then
         tinsert(fishsort, coppercoins);
      end
      if (silvercoins.count > 0) then
         tinsert(fishsort, silvercoins);
      end
      if (goldcoins.count > 0) then
         tinsert(fishsort, goldcoins);
      end
      if (missed.count > 0) then
         tinsert(fishsort, missed);
      end
   end

   local totalpart = ": "..totalCount;
   if ( gotDiffs ) then
      line = FBConstants.TOTALS..totalpart.." "..Crayon:Green("("..totalCurrent..")");
   else
      line = FBConstants.TOTAL..totalpart;
   end
   if ( FishingBuddy.GetSettingBool("WatchCurrentSkill") ) then
      line = line..Crayon:White(" | ")..CHAT_MSG_SKILL..": "..playerskill;
      local needed;
      lastSkillCheck, caughtSoFar, needed = FL:GetSkillUpInfo(lastSkillCheck, caughtSoFar);
      if ( needed ) then
         line = line.." ("..caughtSoFar.."/~"..needed..")";
      end
   end
   SetEntry(index, line);
   index = index + 1;
   
   local white = "|cff"..Crayon.COLOR_HEX_WHITE;
   local silver = "|cff"..Crayon.COLOR_HEX_SILVER;
   for j=1,table.getn(fishsort),1 do
      local info = fishsort[j];
      local fishie = info.text;
      if ( fishie ) then
         fishie = FishingBuddy.StripRaw(fishie);
         local fishietext = fishie;
         local amount = info.count;
         if ( info.skipped ) then
            if ( info.quest ) then
               fishietext = fishietext.." ("..amount..")";
            else
               fishietext = Crayon:Copper(fishietext.." ("..amount..")");
            end
         else
            if ( info.quality and ITEM_QUALITY_COLORS[info.quality] ) then
               fishietext = ITEM_QUALITY_COLORS[info.quality].hex..fishietext.."|r ";
            else
               fishietext = Crayon:Red(fishietext);
            end

            local color1, color2;
            if ( gotDiffs ) then
               color1 = silver;
               color2 = white;
            else
               color1 = white;
            end
            local numbers = white.."(".."|r"..color1..amount;
            if ( dopercent ) then
               local percent = format("%.1f", ( amount / totalCount ) * 100);
               numbers = numbers.." : "..percent.."%";
            end
            if ( gotDiffs ) then
               numbers = numbers..", |r";
               amount = info.current;
               local diffs = amount;
               if ( dopercent ) then
                  local percent = format("%.1f", ( amount / totalCurrent ) * 100);
                  diffs = diffs.." : "..percent.."%";
               end
               numbers = numbers..color2..diffs.."|r";
            else
               numbers = numbers.."|r";
            end
            fishietext = fishietext..numbers..white..")|r";
         end
         SetEntry(index, fishietext);
         index = index + 1;
      end
   end

   for i=index, MAX_FISHINGWATCH_LINES, 1 do
      local line = getglobal("FishingWatchLine"..i);
      line:Hide();
   end
   FishingWatchFrame:SetHeight((index - 1) * 13);
   FishingWatchFrame:SetWidth(fishingWatchMaxWidth + 10);
   SizeDraggerFrame();
end
FishingBuddy.WatchUpdate = WatchUpdate;

FishingBuddy.WatchFrame.OnLoad = function(self)
   self:ClearAllPoints();
   self:SetPoint("TOPLEFT", "FishingWatchDrag", "TOPLEFT", 0, 0);

   FishingBuddy.API.RegisterHandlers(WatchEvents);
end

local isDragging = nil;
local hover;
FishingBuddy.WatchFrame.OnUpdate = function(self, elapsed)
   if ( FishingWatchFrame:IsVisible() ) then
      if ( isDragging ) then
         return;
      end
      if ( MouseIsOver(FishingWatchTab) or MouseIsOver(FishingWatchDrag) ) then
         local xPos, yPos = GetCursorPosition();
         if ( hover ) then
            if ( hover.xPos == xPos and hover.yPos == yPos ) then
               hover.hoverTime = hover.hoverTime + elapsed;
            else
               hover.hoverTime = 0;
               hover.xPos = xPos;
               hover.yPos = yPos;
            end
         else
            hover = {};
            hover.hoverTime = 0;
            hover.xPos = xPos;
            hover.yPos = yPos;
         end
         if ( hover.hoverTime > WATCHDRAGGER_SHOW_DELAY ) then
            ShowDraggerFrame();
         end
      else
         HideDraggerFrame(true);
         hover = nil;
      end
   elseif ( hover ) then
      HideDraggerFrame(true);
      hover = nil;
   end
end

FishingBuddy.WatchFrame.OnDragStart = function(self)
   isDragging = true;
   FishingWatchDrag:StartMoving();
end

FishingBuddy.WatchFrame.OnDragStop = function(self)
   FishingWatchDrag:StopMovingOrSizing();
   isDragging = nil;
end

local function HiddenFishToggle(id)
   if ( FishingBuddy_Info["HiddenFishies"][id] ) then
      FishingBuddy_Info["HiddenFishies"][id] = nil;
   else
      FishingBuddy_Info["HiddenFishies"][id] = true;
   end;
   FishingBuddy.WatchUpdate();
end

-- save some memory by keeping one copy of each one
local WatcherToggleFunctions = {};
-- let's use closures
local function WatcherMakeToggle(fishid)
   if ( not WatcherToggleFunctions[fishid] ) then
      local id = fishid;
      WatcherToggleFunctions[fishid] = function() HiddenFishToggle(id); end;
   end
   return WatcherToggleFunctions[fishid];
end
FishingBuddy.WatchFrame.MakeToggle = WatcherMakeToggle;

local function WatchMenu_Initialize()
   local zidx, sidx = FishingBuddy.GetZoneIndex();
   local idx = zmto(zidx, sidx);
   local fz = FishingBuddy.FishingHoles;
   if ( fz and fz[idx] ) then
      local ff = FishingBuddy_Info["Fishies"];
      for fishid in pairs(fz[idx]) do
         info = {};
         info.text = ff[fishid][loc];
         info.func = WatcherMakeToggle(fishid);
         info.checked = ( not FishingBuddy_Info["HiddenFishies"][fishid] );
         info.keepShownOnClick = 1;
         UIDropDownMenu_AddButton(info);
      end
   end
end

FishingBuddy.WatchFrame.OnClick = function(self)
-- we need to be smarter about the things we filter (trash, coins, etc.)
   if ( false ) then
      local menu = getglobal("FishingBuddyWatcherMenu");
      UIDropDownMenu_Initialize(menu, WatchMenu_Initialize, "MENU");
      ToggleDropDownMenu(1, nil, menu, "FishingWatchTab", 10, 10);
   end
end
