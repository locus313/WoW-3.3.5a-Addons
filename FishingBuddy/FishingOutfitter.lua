-- Interface with the Outfitter addon by mundocani

if ( Outfitter_OnLoad ) then

local FL = LibStub("LibFishing-1.0");

local function OutfitterSwitch(outfitName)
   -- this uses a static string of "Fishing" *not* the translation
   local vOut, vCat, vInd = Outfitter:FindOutfitByStatID("Fishing");
   if ( vOut ) then
      local wasPole = FL:IsFishingPole();
      if ( wasPole ) then
         Outfitter:RemoveOutfit(vOut);
      else
         vOut.Disabled = nil;
         Outfitter:WearOutfit(vOut, vCat);
      end
      Outfitter:Update(true);
      -- return true if we're expecting to have a pole equipped
      return (not wasPole);
   end
end

local function CleanOutDuplicates(vName)
   local count = 0;
   for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
      for vOutfitIndex, vOutfit in pairs(vOutfits) do
         if ( vOutfit.Name == vName ) then
            count = count + 1;
         end
      end
   end
   if ( count > 1 ) then
      -- nuke all of the outfits named 'Fishing Buddy' since they're
      -- likely wrong, so that we can create a new 'good' one
      local vOut,_,_ = Outfitter:FindOutfitByName(vName);
      while ( vOut ) do
         Outfitter_DeleteOutfit(vOut);
         vOut,_,_ = Outfitter:FindOutfitByName(vName);
      end
   end
end

local function WaitForOutfitter()
   if ( Outfitter and Outfitter:IsInitialized() ) then
      FishingOutfitterFrame:Hide();
      local vName = "Fishing Buddy";
      CleanOutDuplicates(vName);
      -- create the default fishing outfit, if it doesn't exist
      local vOut,_,_ = Outfitter:FindOutfitByStatID("Fishing");
      if ( not vOut ) then
         vOut = Outfitter:GenerateSmartOutfit(vName, "Fishing", OutfitterItemList_GetEquippableItems(true));
         if ( vOut ) then
            local vCategoryID = Outfitter:AddOutfit(vOut);
            -- we're done
         end
      end
   end
end
FishingBuddy.OutfitManager.WaitForOutfitter = WaitForOutfitter;

local outfitterOutfitDone = false;
local function OutfitterInitialize()
   if ( not outfitterOutfitDone ) then
      outfitterOutfitDone = true;
      FishingOutfitterFrame:Show();
   end
end

-- calculate scores based on Outfitter
local function StylePoints(outfit)
   local isp = FishingBuddy.OutfitManager.ItemStylePoints;
   local points = 0;
   if ( outfit )then
      for slot in pairs(outfit.Items) do
         points = points + isp(outfit.Items[slot].Code,
                               outfit.Items[slot].EnchantCode);
      end
   end
   return points;
end

local function BonusPoints(outfit, vStatID)
   local points = 0;
   if ( outfit )then
      for slot in pairs(outfit.Items) do
         if ( outfit.Items[slot][vStatID] ) then
            points = points + outfit.Items[slot][vStatID];
         end
         -- Fishing Enchantment
         if ( outfit.Items[slot].EnchantCode == 846 ) then
            points = points + 2;
         end
         -- Enternium Fishing Line
         if ( outfit.Items[slot].EnchantCode == 2603 ) then
            points = points + 5;
         end
      end
   end
   return points;
end

-- Outfitter patches ( not needed in 1.2)
if ( not Outfitter_FindOutfitByStatID ) then
   Outfitter_FindOutfitByStatID = function(pStatID)
      if not pStatID or pStatID == "" then
         return nil;
      end

      for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
         for vOutfitIndex, vOutfit in pairs(vOutfits) do
            if vOutfit.StatID and vOutfit.StatID == pStatID then
               return vOutfit, vCategoryID, vOutfitIndex;
            end
         end
      end

      -- return nil, nil, nil;
   end
end

local Saved_OutfitterItem_OnEnter = Outfitter.Item_OnEnter;
local function Patch_OutfitterItem_OnEnter(pItem)
   Saved_OutfitterItem_OnEnter(pItem);
   if ( not pItem.isCategoryItem ) then
      local vOutfit = Outfitter_GetOutfitFromListItem(pItem);
      if ( vOutfit and vOutfit.StatID == "Fishing" ) then
         local vDescription;
         local bp = BonusPoints(vOutfit, "Fishing");
         if ( bp >= 0 ) then
            bp = "+"..bp;
         else
            bp = 0 - bp;
            bp = "-"..bp;
         end
         bp = Outfitter_cFishingStatName.." "..bp;
         local sp = StylePoints(vOutfit);
         local pstring;
         if ( points == 1 ) then
            pstring = FBConstants.POINT;
         else
            pstring = FBConstants.POINTS;
         end
         vDescription = string.format(FBConstants.CONFIG_OUTFITTER_TEXT,
                                      bp, sp)..pstring;
         GameTooltip_AddNewbieTip(this, vOutfit.Name, 1.0, 1.0, 1.0, vDescription, 1);
      end
   end
end
-- point to our new function so we get our own tooltip
Outfitter.Item_OnEnter = Patch_OutfitterItem_OnEnter;

local wasfishing = false;
local OutfitterEvents = {};
OutfitterEvents["PLAYER_REGEN_DISABLE"] = function()
   if ( FL:IsFishingPole() ) then
      local vOut,_,_ = Outfitter_FindOutfitByStatID("Fishing");
      Outfitter_RemoveOutfit(vOut);
   end
end

FishingBuddy.OutfitManager.RegisterManager("Outfitter",
                                              OutfitterInitialize,
                                              function(useme) end,
                                              OutfitterSwitch);


end;	-- If Outfitter_OnLoad
