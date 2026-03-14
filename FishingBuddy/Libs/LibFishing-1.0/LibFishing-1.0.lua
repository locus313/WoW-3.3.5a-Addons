--[[
Name: FishLib-1.0
Author(s): Sutorix <sutorix@hotmail.com>
Description: A library with common routines used by FishingBuddy and addons.
--]]

local MAJOR_VERSION = "LibFishing-1.0"
local MINOR_VERSION = 3

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local FishLib, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not FishLib then
	return
end

local WOW = {};
function FishLib:WOWVersion()
   return WOW.major, WOW.minor, WOW.dot;
end

if ( GetBuildInfo ) then
   local v, b, d = GetBuildInfo();
   WOW.build = b;
   WOW.date = d;
   local s,e,maj,min,dot = string.find(v, "(%d+).(%d+).(%d+)");
   WOW.major = tonumber(maj);
   WOW.minor = tonumber(min);
   WOW.dot = tonumber(dot);
else
   WOW.major = 1;
   WOW.minor = 9;
   WOW.dot = 0;
end

local bobber = {};
bobber["enUS"] = "Fishing Bobber";
bobber["esES"] = "Anzuelo";
bobber["esMX"] = "Anzuelo";
bobber["deDE"] = "Blinker";
bobber["frFR"] = "Fishing Bobber"; -- ned a translation for this...
bobber["ruRU"] = "Поплавок";
bobber["zhTW"] = "釣魚浮標";
bobber["zhCN"] = "垂钓水花";

local locale = GetLocale();
if ( bobber[locale] ) then
   FishLib.BOBBER_NAME = bobber[locale];
else
   FishLib.BOBBER_NAME = bobber["enUS"];
end

local Crayon = LibStub("LibCrayon-3.0");
local LT = LibStub("LibTourist-3.0");

local function FixupThis(target, tag, what)
   if ( type(what) == "table" ) then
      for idx,str in pairs(what) do
         what[idx] = FixupThis(target, tag, str);
      end
      return what;
   elseif ( type(what) == "string" ) then
      local pattern = "#([A-Z0-9_]+)#";
      local s,e,w = string.find(what, pattern);
      while ( w ) do
         if ( type(target[w]) == "string" ) then
            local s1 = strsub(what, 1, s-1);
            local s2 = strsub(what, e+1);
            what = s1..target[w]..s2;
            s,e,w = string.find(what, pattern);
         elseif ( Crayon and Crayon["COLOR_HEX_"..w] ) then
            local s1 = strsub(what, 1, s-1);
            local s2 = strsub(what, e+1);
            what = s1.."ff"..Crayon["COLOR_HEX_"..w]..s2;
            s,e,w = string.find(what, pattern);
         else
            -- stop if we can't find something to replace it with
            w = nil;
         end
      end
      return what;
   end
   -- do nothing
   return what;
end

function FishLib:FixupEntry(constants, tag)
   FixupThis(constants, tag, constants[tag]);
end

local function FixupStrings(source, target)
   local translation = source["enUS"];
   for tag,_ in pairs(translation) do
      target[tag] = FixupThis(target, tag, target[tag]);
   end
end

local function FixupBindings(source, target)
   local translation = source["enUS"];
   for tag,str in pairs(translation) do      
      if ( string.find(tag, "^BINDING") ) then
         setglobal(tag, target[tag]);
         target[tag] = nil;
      end
   end
end

local missing = {};
local function LoadTranslation(source, lang, target, record)
   local translation = source[lang];
   if ( translation ) then
      for tag,value in pairs(translation) do
         if ( not target[tag] ) then
            target[tag] = value;
            if ( record ) then
               missing[tag] = 1;
            end
         end
      end
   end
end

function FishLib:Translate(addon, source, target, record)
   local locale = GetLocale();
   --locale = "deDE";
   target.VERSION = GetAddOnMetadata(addon, "Version");
   LoadTranslation(source, locale, target);
   if ( locale ~= "enUS" ) then
      LoadTranslation(source, "enUS", target, record);
   end
   FixupStrings(source, target);
   FixupBindings(source, target);
end

function FishLib:tonil(val, tostr)
   if ( not val ) then
      return "nil";
   else
      if ( tostr ) then
         return ""..val;
      else
         return val;
      end
   end
end

local itempattern = "|c(%x+)|Hitem:(%d+)(:%d+):%d+:%d+:%d+:%d+:[-]?%d+:[-]?%d+:[-]?%d+|h%[(.*)%]|h|r";
function FishLib:SplitLink(link)
   if ( link ) then
      local _,_, color, id, item, name = string.find(link, itempattern);
      return color, id..item, name;
   end
end

function FishLib:SplitFishLink(link)
   if ( link ) then
      local _,_, color, id, item, name = string.find(link, itempattern);
      return color, tonumber(id), name;
   end
end

function FishLib:GetItemInfo(link)
-- name, link, rarity, itemlevel, minlevel, itemtype
-- subtype, stackcount, equiploc, texture
   local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link);
   return itemName, itemLink, itemRarity, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemLevel, itemSellPrice;
end

function FishLib:IsLinkableItem(item)
   local link = "item:"..item;
   local n,l,_,_,_,_,_,_ = self:GetItemInfo(link);
   return ( n and l );
end

function FishLib:ChatLink(item, name, color)
   if( item and name and ChatFrameEditBox:IsVisible() ) then
      if ( not color ) then
         color = Crayon.COLOR_HEX_WHITE;
      elseif ( Crayon["COLOR_HEX_"..color] ) then
         color = Crayon["COLOR_HEX_"..color];
      end
      if ( string.len(color) == 6) then
         color = "ff"..color;
      end
      local link = "|c"..color.."|Hitem:"..item.."|h["..name.."]|h|r";
      ChatFrameEditBox:Insert(link);
   end
end

local fp_itemtype = nil;
local fp_subtype = nil;
local mainhand = nil;

function FishLib:GetPoleType()
   if ( not fp_itemtype ) then
      _,_,_,_,fp_itemtype,fp_subtype,_,_,_,_ = self:GetItemInfo(6256);
      if ( not fp_itemtype ) then
         -- make sure it's in our cache
         GameTooltip:SetHyperlink("item:6256");
         GameTooltip:Show();
         GameTooltip:Hide();
         _,_,_,_,fp_itemtype,fp_subtype,_,_,_,_ = self:GetItemInfo(6256);
      end
   end
   return fp_itemtype, fp_subtupe;
end

function FishLib:IsFishingPool(text)
   if ( not text ) then
      text = self:GetTooltipText();
   end
   if ( text ) then
      local check = string.lower(text);
      for _,info in pairs(self.SCHOOLS) do
         local name = string.lower(info.name);
         if ( string.find(check, name) ) then
            return info;
         end
      end
      if ( string.find(check, self.SCHOOL) ) then
         return { name = text, kind = self.SCHOOL_FISH } ;
      end
   end
   -- return nil;
end

function FishLib:IsFishingPole(itemLink)
   if (not itemLink) then
      -- Get the main hand item texture
      if (not mainhand) then
         mainhand = GetInventorySlotInfo("MainHandSlot");
      end
      itemLink = GetInventoryItemLink("player", mainhand);
   end
   if ( itemLink ) then
      local _,_,_,_,itemtype,subtype,_,_,itemTexture,_ = self:GetItemInfo(itemLink);
      self:GetPoleType();
      if ( not fp_itemtype and itemTexture ) then
          -- If there is infact an item in the main hand, and it's texture
          -- that matches the fishing pole texture, then we have a fishing pole
          itemTexture = string.lower(itemTexture);
          if ( string.find(itemTexture, "inv_fishingpole") or
               string.find(itemTexture, "fishing_journeymanfisher") ) then
             local _, id, _ = self:SplitFishLink(itemLink);
             -- Make sure it's not "Nat Pagle's Fish Terminator"
             if ( id ~= 19944) then
                fp_itemtype = itemtype;
                fp_subtype = subtype;
                return true;
             end
          end
      else
         return (itemtype == fp_itemtype) and (subtype == fp_subtype);
      end
   end
   return false;
end

function FishLib:IsWorn(itemid)
   for slot=1,19 do
      local link = GetInventoryItemLink("player", slot);
      if ( link ) then
         local _, id, _ = self:SplitFishLink(link);
         if ( itemid == id ) then
            return true;
         end
      end
   end
   -- return nil
end

-- fish tracking skill
function FishLib:GetTrackingID(tex)
   if ( not tex ) then
      tex = GetTrackingTexture();
   end
   for id=1,GetNumTrackingTypes() do
      local _, texture, _, _ = GetTrackingInfo(id);
      if ( texture == tex) then
         return id;
      end
   end
   -- return nil;
end

local FINDFISHTEXTURE = "Interface\\Icons\\INV_Misc_Fish_02";
function FishLib:GetFindFishID()
   if ( not self.FindFishID ) then
      self.FindFishID = self:GetTrackingID(FINDFISHTEXTURE);
   end
   return self.FindFishID;
end

-- in case the addon is smarter than us
function FishLib:SetBobberName(name)
   self.BOBBER_NAME = name;
end

function FishLib:GetBobberName()
   return self.BOBBER_NAME;
end

function FishLib:GetTooltipText()
   if ( GameTooltip:IsVisible() ) then
      local text = getglobal("GameTooltipTextLeft1");
      if ( text ) then
         return text:GetText();
      end
   end
   -- return nil;
end

function FishLib:SaveTooltipText()
   self.lastTooltipText = self:GetTooltipText();
   return self.lastTooltipText;
end

function FishLib:GetLastTooltipText()
   return self.lastTooltipText;
end

function FishLib:ClearLastTooltipText()
   self.lastTooltipText = nil;
end

function FishLib:OnFishingBobber()
   if ( GameTooltip:IsVisible() and not UIFrameIsFading(GameTooltip) ) then
      local text = self:GetTooltipText();
      if ( text ) then
         -- let a partial match work (for translations)
         return ( text and string.find(text, self.BOBBER_NAME ) );
      end
   end
   return false;
end

local ACTIONDOUBLEWAIT = 0.4;
local MINACTIONDOUBLECLICK = 0.05;

FishLib.watchBobber = true;
function FishLib:WatchBobber(flag)
   self.watchBobber = flag;
end

-- look for double clicks
function FishLib:CheckForDoubleClick()
   if ( self.lastClickTime ) then
      local pressTime = GetTime();
      local doubleTime = pressTime - self.lastClickTime;
      if ( doubleTime < ACTIONDOUBLEWAIT and doubleTime > MINACTIONDOUBLECLICK ) then
         if ( not self.watchBobber or not self:OnFishingBobber() ) then
            return true;
         end
      end
   end
   self.lastClickTime = GetTime();
   if ( self:OnFishingBobber() ) then
      GameTooltip:Hide();
   end
   return false;
end

function FishLib:ExtendDoubleClick()
   if ( self.lastClickTime ) then
      self.lastClickTime = self.lastClickTime + ACTIONDOUBLEWAIT/2;
   end
end

-- support finding the fishing skill
function FishLib:FindSpellID(thisone)
   local id = 1;
   local spellTexture = GetSpellTexture(id, BOOKTYPE_SPELL);
   while (spellTexture) do
      if (spellTexture and spellTexture == thisone) then
                return id;
      end
      id = id + 1;
      spellTexture = GetSpellTexture(id, BOOKTYPE_SPELL);
   end
   return nil;
end


local skillname = {};
skillname["enUS"] = "Fishing";
skillname["esES"] = "Pesca";
skillname["esMX"] = "Pesca";
skillname["deDE"] = "Angeln";
skillname["frFR"] = "P\195\170che";
skillname["ruRU"] = "Рыбная ловля";
skillname["zhTW"] = "釣魚";
skillname["zhCN"] = "釣魚";

local FISHINGTEXTURE = "Interface\\Icons\\Trade_Fishing";
function FishLib:GetFishingSkillInfo(force)
   if ( force or not self.SpellID or not self.SkillName) then
      self.SpellID = self:FindSpellID(FISHINGTEXTURE);
      self.SkillName = nil;
   end
   if ( self.SpellID and not SkillName ) then
      self.SkillName = GetSpellName(self.SpellID, BOOKTYPE_SPELL);
   end
   local sname = self.SkillName;
   if ( not sname ) then
      sname = skillname[GetLocale()] or skillname["enUS"];
   end
   return self.SpellID, sname;
end

-- get our current fishing skill level
local lastSkillIndex = nil;
function FishLib:GetCurrentSkill()
   local _,fsn = self:GetFishingSkillInfo();
   if ( self.lastSkillIndex ) then
      local name, _, _, rank, _, modifier, skillmax = GetSkillLineInfo(self.lastSkillIndex);
      if ( name == fsn )then
         return rank, modifier, skillmax;
      end
   end
   local n = GetNumSkillLines();
   for i=1,n do
      local name, _, _, rank, _, modifier, skillmax = GetSkillLineInfo(i);
      if ( name == fsn ) then
         self.lastSkillIndex = i;
         return rank, modifier, skillmax;
      end
   end
   return 0, 0, 0;
end

function FishLib:GetZoneInfo()
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

-- return a nicely formatted line about the local zone skill and yours
function FishLib:GetFishingSkillLine(join, withzone, caughtSoFar)
   local part1 = "";
   local part2 = "";
   local skill, mods, skillmax = self:GetCurrentSkill();
   local totskill = skill + mods;
   local zone, subzone = self:GetZoneInfo();
   local level = LT:GetFishingLevel(zone);
   if ( withzone ) then
      part1 = zone.." : "..subzone.. " ";
   end
   if ( level ) then
       if ( level > 0 ) then
         local perc = totskill/(level+95); -- no get aways
         if (perc > 1.0) then
            perc = 1.0;
         end
         part1 = part1.."|cff"..Crayon:GetThresholdHexColor(perc*perc)..level.." ("..math.floor(perc*perc*100).."%)|r";
      else
         -- need to translate this on our own
	      part1 = part1..Crayon:Red(NONE_KEY);
      end
   else
      part1 = Crayon:Red(UNKNOWN);
   end
   -- have some more details if we've got a pole equipped
   if ( self:IsFishingPole() ) then
      part2 = Crayon:Green(skill.."+"..mods).." "..Crayon:Silver("["..totskill.."]");
   end
   if ( join ) then
      if (part1 ~= "" and part2 ~= "" ) then
         part1 = part1..Crayon:White(" | ")..part2;
         part2 = "";
      end
   end
   return part1, part2;
end

function FishLib:GetSkillUpInfo(lastSkillCheck, caughtSoFar)
   local skill, mods, skillmax = self:GetCurrentSkill();
   if ( skillmax and skill < skillmax ) then
      -- guess high instead of low on how many more we need
      local needed = math.ceil((skill - 75) / 25);
      if ( needed < 1 ) then
         needed = 1;
      end
      if ( not lastSkillCheck or lastSkillCheck ~= skill ) then
         caughtSoFar = 0;
         lastSkillCheck = skill;
      end
      return lastSkillCheck, caughtSoFar, needed;
   end
   return lastSkillCheck, caughtSoFar, nil;
end

function FishLib:GetFishingActionBarID(force)
   if ( force or not self.ActionBarID ) then
      for slot=1,72 do
         if ( HasAction(slot) and not IsAttackAction(slot) ) then
            local t,_,_ = GetActionInfo(slot);
            if ( t == "spell" ) then
               local tex = GetActionTexture(slot);
               if ( tex and tex == FISHINGTEXTURE ) then
                  self.ActionBarID = slot;
                  break;
               end
            end
         end
      end
   end
   return self.ActionBarId;
end

-- handle classes of fish
local MissedFishItems = {};
MissedFishItems[45190] = "Driftwood";
MissedFishItems[45200] = "Sickly Fish";
MissedFishItems[45194] = "Tangled Fishing Line";
MissedFishItems[45196] = "Tattered Cloth";
MissedFishItems[45198] = "Weeds";
MissedFishItems[45195] = "Empty Rum Bottle";
MissedFishItems[45199] = "Old Boot";
MissedFishItems[45201] = "Rock";
MissedFishItems[45197] = "Tree Branch";
MissedFishItems[45202] = "Water Snail";
MissedFishItems[45188] = "Withered Kelp";
MissedFishItems[45189] = "Torn Sail";
MissedFishItems[45191] = "Empty Clam";

function FishLib:IsMissedFish(id)
   if ( MissedFishItems[id] ) then
      return true;
   end
   -- return nil;
end

-- utility functions
local function SplitColor(color)
   if ( color ) then
      if ( type(color) == "table" ) then
         for i,c in pairs(color) do
            color[i] = SplitColor(c);
         end
      elseif ( type(color) == "string" ) then
         local a = tonumber(string.sub(color,1,2),16);
         local r = tonumber(string.sub(color,3,4),16);
         local g = tonumber(string.sub(color,5,6),16);
         local b = tonumber(string.sub(color,7,8),16);
         color = { a = a, r = r, g = g, b = b };
      end
   end
   return color;
end

local function AddTooltipLine(l)
   if ( type(l) == "table" ) then
      -- either { t, c } or {{t1, c1}, {t2, c2}}
      if ( type(l[1]) == "table" ) then
         local c1 = SplitColor(l[1][2]) or {};
         local c2 = SplitColor(l[2][2]) or {};
         GameTooltip:AddDoubleLine(l[1][1], l[2][1],
                                   c1.r, c1.g, c1.b,
                                   c2.r, c2.g, c2.b);
      else
         local c = SplitColor(l[2]) or {};
         GameTooltip:AddLine(l[1], c.r, c.g, c.b, 1);
      end
   else
      GameTooltip:AddLine(l,nil,nil,nil,1);
   end
end

function FishLib:AddTooltip(text)
   local c = color or {{}, {}};
   if ( text ) then
      if ( type(text) == "table" ) then
         for _,l in pairs(text) do
            AddTooltipLine(l);
         end
      else
         -- AddTooltipLine(text, color);
         GameTooltip:AddLine(text,nil,nil,nil,1);
      end
   end
end

function FishLib:FindChatWindow(name)
   local frame;
   for i = 1, NUM_CHAT_WINDOWS do
      local tab = getglobal("ChatFrame" .. i .. "Tab");
      if (tab:GetText() == name) then
         return getglobal("ChatFrame" .. i), frametab;
      end
   end
   -- return nil, nil;
end

function FishLib:GetChatWindow(name)
   local frame, frametab = self:FindChatWindow(name);
   if ( frame ) then
      if( not frametab:IsVisible() ) then 
         frametab:Show(); 
      end
      return frame, frametab;
   else
      -- this doesn't return anything, so we have to assume we
      -- can call again to find it
      FCF_OpenNewWindow(name);
      frame, frametab = self:FindChatWindow(name);
      if ( frame ) then
         FCF_SetLocked(frame, true, false);
         ChatFrame_RemoveAllMessageGroups(frame);
         return frame, frametab;
      end
   end
   -- if we didn't find our frame, something bad has happened, so
   -- let's just use the default chat frame
   return DEFAULT_CHAT_FRAME, nil;
end

-- Pool types
FishLib.SCHOOL_FISH = 0;
FishLib.SCHOOL_WRECKAGE = 1;
FishLib.SCHOOL_DEBRIS = 2;
FishLib.SCHOOL_WATER = 3;
FishLib.SCHOOL_TASTY = 4;
FishLib.SCHOOL_OIL = 5;
FishLib.SCHOOL_CHURNING = 6;
FishLib.SCHOOL_FLOTSAM = 7;

local FLTrans = {};

function FLTrans:Setup(lang, school, ...)
   self[lang] = {};
   -- as long as string.lower breaks all UTF-8 equially, this should still work
   self[lang].SCHOOL = string.lower(school);
   local n = select("#", ...);
   local schools = {};
   for idx=1,n,2 do
      local name, kind = select(idx, ...);
      tinsert(schools, { name = name, kind = kind });
   end
   self[lang].SCHOOLS = schools;
end

FLTrans:Setup("enUS", "school",
   "Floating Wreckage", FishLib.SCHOOL_WRECKAGE,
   "Patch of Elemental Water", FishLib.SCHOOL_WATER,
   "Floating Debris", FishLib.SCHOOL_DEBRIS,
   "Oil Spill", FishLib.SCHOOL_OIL,
   "Stonescale Eel Swarm", FishLib.SCHOOL_FISH,
   "Muddy Churning Water", FishLib.SCHOOL_CHURNING,
   "Pure Water", FishLib.SCHOOL_WATER,
   "Steam Pump Flotsam", FishLib.SCHOOL_FLOTSAM,
   "School of Tastyfish", FishLib.SCHOOL_TASTY);

FLTrans:Setup("koKR", "떼",
   "표류하는 잔해", FishLib.SCHOOL_WRECKAGE, --  Floating Wreckage
   "정기가 흐르는 물 웅덩이", FishLib.SCHOOL_WATER, --  Patch of Elemental Water
   "표류하는 파편", FishLib.SCHOOL_DEBRIS, --  Floating Debris
   "떠다니는 기름", FishLib.SCHOOL_OIL, --  Oil Spill
   "거품이는 진흙탕물", FishLib.SCHOOL_CHURNING, --  Muddy Churning Water
   "깨끗한 물", FishLib.SCHOOL_WATER, --  Pure Water
   "증기 양수기 표류물", FishLib.SCHOOL_FLOTSAM, --  Steam Pump Flotsam
   "맛둥어 떼", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FLTrans:Setup("deDE", "schwarm",
   "Treibende Wrackteile", FishLib.SCHOOL_WRECKAGE, --  Floating Wreckage
   "Stelle mit Elementarwasser", FishLib.SCHOOL_WATER, --  Patch of Elemental Water
   "Schwimmende Trümmer", FishLib.SCHOOL_DEBRIS, --  Floating Debris
   "Ölfleck", FishLib.SCHOOL_OIL,  --  Oil Spill
   "Schlammiges aufgewühltes Gewässer", FishLib.SCHOOL_CHURNING, --  Muddy Churning Water
   "Reines Wasser", FishLib.SCHOOL_WATER, --  Pure Water
   "Treibgut der Dampfpumpe", FishLib.SCHOOL_FLOTSAM, --  Steam Pump Flotsam
   "Leckerfischschwarm", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FLTrans:Setup("frFR", "banc",
   "Débris flottants", FishLib.SCHOOL_WRECKAGE, --  Floating Wreckage
   "Remous d'eau élémentaire", FishLib.SCHOOL_WATER, --  Patch of Elemental Water
   "Débris flottant", FishLib.SCHOOL_DEBRIS, --  Floating Debris
   "Nappe de pétrole", FishLib.SCHOOL_OIL, --  Oil Spill
   "Eaux troubles et agitées", FishLib.SCHOOL_CHURNING, --  Muddy Churning Water
   "Eau pure", FishLib.SCHOOL_WATER, --  Pure Water
   "Détritus de la pompe à vapeur", FishLib.SCHOOL_FLOTSAM, --  Steam Pump Flotsam
   "Banc de courbine", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FLTrans:Setup("esES", "banco",
   "Restos de un naufragio", FishLib.SCHOOL_WRECKAGE,   --  Floating Wreckage
   "Restos flotando", FishLib.SCHOOL_DEBRIS,    --  Floating Debris
   "Vertido de petr\195\179leo", FishLib.SCHOOL_OIL,   --  Oil Spill
   "Agua pura", FishLib.SCHOOL_WATER, --  Pure Water
   "Restos flotantes de bomba de vapor", FishLib.SCHOOL_FLOTSAM, --  Steam Pump Flotsam
   "Banco de pezricos", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FLTrans:Setup("zhCN", "鱼群",
   "漂浮的残骸", FishLib.SCHOOL_WRECKAGE, --  Floating Wreckage
   "元素之水", FishLib.SCHOOL_WATER, --  Patch of Elemental Water
   "漂浮的碎片", FishLib.SCHOOL_DEBRIS, --  Floating Debris
   "油井", FishLib.SCHOOL_OIL, --  Oil Spill
   "石鳞鳗群", FishLib.SCHOOL_FISH, --  Stonescale Eel Swarm
   "混浊的水", FishLib.SCHOOL_CHURNING, --  Muddy Churning Water
   "纯水", FishLib.SCHOOL_WATER,             --  Pure Water
   "蒸汽泵废料", FishLib.SCHOOL_FLOTSAM, --  Steam Pump Flotsam
   "可口鱼", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FLTrans:Setup("zhTW", "群",
   "漂浮的殘骸", FishLib.SCHOOL_WRECKAGE, --  Floating Wreckage
   "元素之水", FishLib.SCHOOL_WATER, --  Patch of Elemental Water
   "漂浮的碎片", FishLib.SCHOOL_DEBRIS, --  Floating Debris
   "油井", FishLib.SCHOOL_OIL, --  Oil Spill
   "混濁的水", FishLib.SCHOOL_CHURNING, --  Muddy Churning Water
   "純水", FishLib.SCHOOL_WATER,             --  Pure Water
   "蒸汽幫浦漂浮殘骸", FishLib.SCHOOL_FLOTSAM,  --  Steam Pump Flotsam
   "斑點可口魚魚群", FishLib.SCHOOL_TASTY); -- School of Tastyfish

FishLib:Translate("LibFishing", FLTrans, FishLib);
FLTrans = nil;
