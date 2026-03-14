-- Random fun things to do while fishing
--
-- Turn on the fish finder
-- Change your title to "Salty"
-- Bring out a "fishing buddy"

local FL = LibStub("LibFishing-1.0");

local SALTY_TITLE = 51;
local PETSETTING = "FishingBuddy";
local ALLZOMGPETS = "GreatAndSmall";

-- Pet menu constants
local PET_NONE = 0;
local PET_RANDOM = 1;
local PET_MENUOFF = 4;

-- the spell ids for the fishing pets
-- are these as unique as the critter ids? Should be...
local FishingPets = {};
FishingPets[33050] = -1; -- Magical Crawdad
FishingPets[46425] = -1; -- Snarly
FishingPets[46426] = -1; -- Chuck
FishingPets[43697] = -1; -- Toothy
FishingPets[43698] = -1; -- Muckbreath
FishingPets[59250] = -1; -- Giant Sewer Rat
FishingPets[62561] = -1; -- Strand Crawler

-- Debugging
FishingBuddy.FishingPets = FishingPets;

-- wrap settings
local FBGetSetting = FishingBuddy.GetSetting;
local FBGetSettingBool = FishingBuddy.GetSettingBool;

local function GetSettingBool(setting)
   if (FBGetSettingBool("FishingFluff")) then
      return FBGetSettingBool(setting);
   end
   -- return nil;
end

local function GetSetting(setting)
   if (FBGetSettingBool("FishingFluff")) then
      return FBGetSetting(setting);
   end
   -- return nil;
end

local havepet = 0;
local ourpets = {};
local petmap = {};

local function FindCurrentPet()
   for sid,id in pairs(FishingPets) do
      FishingPets[sid] = -1;
   end
   havepet = 0;
   local n = GetNumCompanions("CRITTER");
   local pet = 0;
   local getall = GetSettingBool(ALLZOMGPETS);
   ourpets = {};
   petmap = {};
   for id=1,n do
      local _, _, cSpellID, _, here = GetCompanionInfo("CRITTER", id);
      if ( here ) then
         pet = id;
      end
      local fishy = nil;
      if ( FishingPets[cSpellID] ) then
         FishingPets[cSpellID] = id;
         fishy = true;
      end
      if (getall or fishy) then
         havepet = 1;
         tinsert(ourpets, cSpellID);
         petmap[cSpellID] = id;
      end
   end
   return pet;
end

local function PetMenuSelected()
   FindCurrentPet();
   if ( havepet == 1 ) then
      local show = PET_MENUOFF;
      local first = nil;
      local pet = GetSetting(PETSETTING);
      local cName;
      if ( pet ~= PET_RANDOM and not petmap[pet] ) then
         pet = PET_NONE;
      end
      if ( pet == PET_NONE ) then
         cName = NONE;
         show = 3;
      elseif ( pet == PET_RANDOM ) then
         cName = FBConstants.RANDOM;
         show = 4;
      else
         local petid;
         for _,sid in pairs(ourpets) do
            if ( sid == pet ) then
               petid = petmap[sid];
               break;
            end
            show = show + 1;
         end
         _, cName, _, _, _ = GetCompanionInfo("CRITTER", petid);
      end
      UIDropDownMenu_SetText(FishingFluffPetMenu, cName);
      UIDropDownMenu_SetSelectedValue(FishingFluffPetMenu, show);
   end
end

local function PetMenuConstant(text, value, picked)
   local info = {};
   local v = value;
   info.text = text;
   info.func = function() FishingBuddy.SetSetting(PETSETTING, v); PetMenuSelected(); end;
   info.checked = ( picked == value );
   UIDropDownMenu_AddButton(info);
end

local function PetMenuSetup()
   FindCurrentPet();
   local picked = GetSetting(PETSETTING);
   FishingBuddy.MakeDropDownEntry(FBConstants.ALLZOMGPETS, ALLZOMGPETS, nil, PetMenuSelected);
   FishingBuddy.MakeDropDownSep();
   PetMenuConstant(NONE, PET_NONE, picked);
   PetMenuConstant(FBConstants.RANDOM, PET_RANDOM, picked);
   for _,sid in pairs(ourpets) do
      local id = petmap[sid];
      local cID, cName, cSpellID, icon, here = GetCompanionInfo("CRITTER", id);
      local info = {};
      info.text = cName;
      info.func = function() FishingBuddy.SetSetting(PETSETTING, cSpellID); PetMenuSelected(); end;
      info.checked = ( picked == cSpellID );
      UIDropDownMenu_AddButton(info);
   end
end

local FluffEvents = {};

local resetID = nil;
local resetPVP = nil;
local resetPet = nil;

FluffEvents[FBConstants.FISHING_ENABLED_EVT] = function()
   if ( FishingBuddy.GetSettingBool("FishingFluff")) then
      resetID = nil;
      resetPVP = nil;
      resetPet = nil;
      if ( GetSettingBool("FindFish") ) then
         local findid = FL:GetFindFishID();
         if ( findid ) then
            resetID = FL:GetTrackingID();
            if ( resetID == findid ) then
               resetID = nil;
            else
               SetTracking(findid);
            end
         end
      end
      if ( GetSettingBool("TurnOffPVP") ) then
         if (1 == GetPVPDesired() ) then
            resetPVP = true;
            SetPVP(0);
         end
      end
      if ( not (IsFlying() or IsMounted()) ) then
         local nowpet = FishingBuddy.GetSetting(PETSETTING);
         local pet = nowpet;
         if ( pet == PET_RANDOM and #ourpets > 1 ) then
            local idx = random(1, #ourpets);
            pet = ourpets[idx];
         elseif ( pet ~= PET_NONE) then
            pet = FindCurrentPet();
         end
         if ( pet ~= nowpet and petmap[pet] ) then
            resetPet = nowpet;
            CallCompanion("CRITTER", petmap[pet]);
         end
      end
   end
end

FluffEvents[FBConstants.FISHING_DISABLED_EVT] = function(started)
   if ( resetID ) then
      SetTracking(resetID);
      resetID = nil;
   end
   if ( resetPVP ) then
      SetPVP(1);
      resetPVP = nil;
   end
   if ( resetPet ) then
      if ( not (IsFlying() or IsMounted()) ) then
         if ( petmap[resetPet] ) then
            CallCompanion("CRITTER", petmap[resetPet]);
         else
            DismissCompanion("CRITTER");
         end
      end
      resetPet = nil;
   end
end

local FluffOptions = {
   ["FishingFluff"] = {
      ["text"] = FBConstants.CONFIG_FISHINGFLUFF_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FISHINGFLUFF_INFO,
      ["v"] = 1,
      ["default"] = 1 },
   ["FindFish"] = {
      ["text"] = FBConstants.CONFIG_FINDFISH_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_FINDFISH_INFO,
      ["v"] = 1,
      ["deps"] = { ["FishingFluff"] = "d" },
      ["default"] = 1 },
   ["FishingBuddy"] = {
      ["tooltip"] = FBConstants.CONFIG_FISHINGBUDDY_INFO,
      ["setup"] = PetMenuSelected,
      ["visible"] =
         function()
            return havepet;
         end,
      ["button"] = "FishingFluffPetMenuHolder",
      ["deps"] = { ["FishingFluff"] = "h" },
      ["default"] = 0 },
   ["DrinkHeavily"] = {
      ["text"] = FBConstants.CONFIG_DRINKHEAVILY_ONOFF,
      ["tooltip"] = FBConstants.CONFIG_DRINKHEAVILY_INFO,
      ["v"] = 1,
      ["m"] = 1,
      ["deps"] = { ["FishingFluff"] = "d" },
      ["default"] = 1 },
};

local InvisibleOptions = {
   -- options not directly manipulatable from the UI
   [PETSETTING] = {
      ["default"] = 0 },
   [ALLZOMGPETS] = {
      ["default"] = 0 },
};

FluffEvents["VARIABLES_LOADED"] = function(started)
   local pet = FishingBuddy.GetSetting(PETSETTING);
   FindCurrentPet();
   if ( pet ~= PET_RANDOM and not petmap[pet] ) then
      FishingBuddy.SetSetting(PETSETTING, PET_NONE); -- No pet
      FishingBuddy.SetSetting(ALLZOMGPETS, 0);
   end

   FishingBuddy.OptionsFrame.HandleOptions(GENERAL, nil, FluffOptions);
   FishingBuddy.OptionsFrame.HandleOptions(nil, nil, InvisibleOptions);
   local f = CreateFrame("FRAME", "FishingFluffPetMenuHolder");
   local menu = CreateFrame("FRAME", "FishingFluffPetMenu", f, "FishingBuddyDropDownMenuTemplate");
   menu:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2);
   UIDropDownMenu_Initialize(menu, PetMenuSetup);
   local label = getglobal("FishingFluffPetMenuLabel");
   label:SetText(PET_TYPE_PET..": ");
   UIDropDownMenu_SetWidth(menu, 120);
   f:SetWidth(menu:GetWidth() + label:GetWidth() - 8);
   f:SetHeight(menu:GetHeight() + label:GetHeight());
   PetMenuSelected();
end


FishingBuddy.API.RegisterHandlers(FluffEvents);
