-- Interface with the Blizz Equipment Manager

local FL = LibStub("LibFishing-1.0");

local slotmap = {
   ["INVTYPE_AMMO"] = { 0 },
   ["INVTYPE_HEAD"] = { 1 },
   ["INVTYPE_NECK"] = { 2 },
   ["INVTYPE_SHOULDER"] = { 3 },
   ["INVTYPE_BODY"] = { 4 },
   ["INVTYPE_CHEST"] = { 5 },
   ["INVTYPE_ROBE"] = { 5 },
   ["INVTYPE_WAIST"] = { 6 },
   ["INVTYPE_LEGS"] = { 7 },
   ["INVTYPE_FEET"] = { 8 },
   ["INVTYPE_WRIST"] = { 9 },
   ["INVTYPE_HAND"] = { 10 },
   ["INVTYPE_FINGER"] = { 11,12 },
   ["INVTYPE_TRINKET"] = { 13,14 },
   ["INVTYPE_CLOAK"] = { 15 },
   ["INVTYPE_WEAPON"] = { 16,17 },
   ["INVTYPE_SHIELD"] = { 17 },
   ["INVTYPE_2HWEAPON"] = { 16 },
   ["INVTYPE_WEAPONMAINHAND"] = { 16 },
   ["INVTYPE_WEAPONOFFHAND"] = { 17 },
   ["INVTYPE_HOLDABLE"] = { 17 },
   ["INVTYPE_RANGED"] = { 18 },
   ["INVTYPE_THROWN"] = { 18 },
   ["INVTYPE_RANGEDRIGHT"] = { 18 },
   ["INVTYPE_RELIC"] = { 18 },
   ["INVTYPE_TABARD"] = { 19 },
   ["INVTYPE_BAG"] = { 20,21,22,23 },
   ["INVTYPE_QUIVER"] = { 20,21,22,23 }, 
   [""] = { },
};

local function tonil(s)
   return s or "nil";
end

local lastOutfit;

local gearframe = CreateFrame("Frame");
gearframe:Hide();
gearframe:SetScript("OnUpdate", function(self)
   if ( self.state == 0 ) then
      if ( FL:IsFishingPole() ) then
         local icon, idxm1 = GetEquipmentSetInfoByName(self.name);
         if ( not icon ) then
            -- find the fishing icon
            local iconIndex = 1;
            for index=1,GetNumMacroIcons() do
               if ( FBConstants.FISHINGTEXTURE == GetMacroItemIconInfo(index) ) then
                  iconIndex = index;
               end
            end
            -- save the set
            SaveEquipmentSet(self.name, iconIndex);
         end
      end
      self.state = 1;
   elseif ( self.state == 1 ) then
      -- reset slot ignore flags
      EquipmentManagerClearIgnoredSlotsForSave();
      EquipmentManager_EquipSet("FB_TEMP_OUTFIT");
      self.state = 2;
   elseif ( self.state == 2 ) then
      if ( not FL:IsFishingPole() ) then
         local icon , idxm1 = GetEquipmentSetInfoByName("FB_TEMP_OUTFIT");
         if ( icon ) then
            DeleteEquipmentSet(idxm1+1);
         end
         self.state = 3;
      end
   elseif ( self.state == 3 ) then
      local icon, idxm1 = GetEquipmentSetInfoByName("FB_TEMP_OUTFIT");
      if ( not icon ) then
         self.state = 4;
      end
   else
      self:Hide();
   end
end)

local function PrepGearFrame(name)
   gearframe.name = name;
   gearframe.state = 0;
   gearframe:Show();
end

local function GearManagerInitialize()
   local _, name = FL:GetFishingSkillInfo();
   if ( name ) then
      local icon, idxm1 = GetEquipmentSetInfoByName(name);
      if ( not icon ) then
         -- Let's build a fishing outfit
         -- but we actually have to equip the items for this to work
         SaveEquipmentSet("FB_TEMP_OUTFIT", 1);
         for slot=1,19 do
            EquipmentManagerIgnoreSlotForSave(slot);
         end
         local ibp = FishingBuddy.OutfitManager.ItemBonusPoints;
         -- find fishing gear
         -- no affinity, check all bags
         local outfit = {};
         for bagID=NUM_BAG_SLOTS,BACKPACK_CONTAINER,-1 do
            -- Make sure this isn't a quiver, those won't hold shit
            local freeSlots, bagType = GetContainerNumFreeSlots(bagID);
            if ( bagType == 0 ) then
               for slotID=1,GetContainerNumSlots(bagID) do
                  local link = GetContainerItemLink(bagID, slotID);
                  if ( link ) then
                     local _, flink, _ = FL:SplitLink(link);
                     local b = ibp(flink);
                     if ( b > 0 ) then
                        local _, _, _, _, _, _, _, _, loc, _ = GetItemInfo(link);
                        local found = false;
                        for idx,slot in pairs(slotmap[loc]) do
                           if ( not found ) then
                              local le = GetInventoryItemLink("player", slot);
                              if ( le ) then
                                 _,le, _ = FL:SplitLink(le);
                                 local be = ibp(le);
                                 if (b > be ) then
                                    found = true;
                                    EquipItemByName("item:"..flink, slot);
                                    EquipmentManagerUnignoreSlotForSave(slot);
                                 end
                              end
                           end
                        end
                     end
                  end
               end  -- for slots
            end -- if this is a bag than can hold anything
         end  -- for bags
         -- let's save this puppy
         PrepGearFrame(name);
      end
   end
end

local function GearManagerSwitch(outfitName)
   if ( FL:IsFishingPole() ) then
      local name;
      local set = GearManagerDialog.selectedSet;
      if ( set ) then
         name = set.name;
      else
         name, _, _ = GetEquipmentSetInfo(1);
      end
      EquipmentManager_EquipSet(name)
   else
      local _, name = FL:GetFishingSkillInfo();
      local icon, idxm1 = GetEquipmentSetInfoByName(name);
      if ( icon ) then
          EquipmentManager_EquipSet(name);
          return true;
      end
   end
   -- return nil;
end

local function OutfitPoints(outfit)
   local sp = 0;
   local bp = 0;
   if ( outfit )then
      local isp = FishingBuddy.OutfitManager.ItemStylePoints;
      local ibp = FishingBuddy.OutfitManager.ItemBonusPoints;
      local items = GetEquipmentSetLocations(outfit);
      for slot,loc in pairs(items) do
         local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(loc);
         local link;
         if ( not bags ) then -- and (player or bank) 
            link = GetInventoryItemLink("player", slot);
         else -- bags
            link = GetContainerItemLink(bag, slot);
         end
         if ( link ) then
            _, link, _ = FL:SplitLink(link);
            sp = sp + isp(link);
            bp = bp + ibp(link);
         end
      end
   end
   return bp, sp;
end

local Saved_GearSetButton_OnEnter = GearSetButton_OnEnter;
local function Patch_GearSetButton_OnEnter(self)
   Saved_GearSetButton_OnEnter(self);
   local _, name = FL:GetFishingSkillInfo();
   if ( self.name and self.name == name ) then
      local bp, sp = OutfitPoints(name)
      if ( bp >= 0 ) then
         bp = "+"..bp;
      else
         bp = 0 - bp;
         bp = "-"..bp;
      end
      bp = name.." "..bp;
      local pstring;
      if ( points == 1 ) then
         pstring = FBConstants.POINT;
      else
         pstring = FBConstants.POINTS;
      end
      GameTooltip:AddDoubleLine(SKILL..": "..bp, "Draznar: "..sp, 1, 1, 1, 1, 1, 1);
      GameTooltip:Show();
   end
end
-- point to our new function so we get our own tooltip
GearSetButton_OnEnter = Patch_GearSetButton_OnEnter;

FishingBuddy.OutfitManager.RegisterManager(EQUIPMENT_MANAGER,
                                              GearManagerInitialize,
                                              function(useme) end,
                                              GearManagerSwitch);
