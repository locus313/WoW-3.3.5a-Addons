local FBFRAMES = {
   [1] = {
      ["frame"] = "FishingLocationsFrame",
      ["name"] = FBConstants.LOCATIONS_TAB,
      ["tooltip"] = FBConstants.LOCATIONS_INFO,
      ["toggle"] = "_LOC",
      ["first"] = 1,
   },
   [2] = {
      ["frame"] = "FishingOptionsFrame",
      ["name"] = FBConstants.OPTIONS_TAB,
      ["tooltip"] = FBConstants.OPTIONS_INFO,
      ["toggle"] = "_OPT",
      ["ultimate"] = 1,
   }
};

local FirstAmongTabs;
local UltimateTab;

local function GetFrameInfo(f)
   local n;
   if ( type(f) == "string" ) then
      n = f;
      f = getglobal(f);
   else
      n = f:GetName();
   end
   return f, n;
end

local TabFrames = {};
local next_frameid = 1;
local function CreateTabFrame(target, tabname)
   local id = next_frameid;
   local framename = string.format("FishingBuddyFrameTab%d", id);
   local frame = CreateFrame("Button", framename,
                             FishingBuddyFrame, "FishingBuddyTabButtonTemplate");
   TabFrames[id] = frame;

   frame:SetID(id);
   frame:SetText(tabname);
   frame.enabled = true;

   next_frameid = next_frameid + 1;

   return frame;
end

local lastTabFrame = nil;
local function UpdateTabFrame(tab)
   if ( tab.enabled ) then
      tab:SetWidth(0);
      PanelTemplates_TabResize(tab, 0);
      tab:Show();
      if ( lastTabFrame ) then
         tab:SetPoint("LEFT", lastTabFrame, "RIGHT", -18, 0);
      else
         tab:SetPoint("CENTER", FishingBuddyFrame, "BOTTOMLEFT", 55, 60);
      end
      lastTabFrame = tab;
   else
      if ( tab == currentTab ) then
         currentTab = lastFrame;
      end
      tab:Hide();
   end
   if ( tab.managedFrame ) then
      tab.managedFrame:Hide();
   end
end

local function ResetTabFrames()
   -- Tab Handling code
   PanelTemplates_SetNumTabs(FishingBuddyFrame, next_frameid-1);

   if ( FirstAmongTabs ) then
      UpdateTabFrame(FirstAmongTabs);
   end
   for id=1,next_frameid-1 do
      local tab = TabFrames[id];
      if ( not tab.first and not tab.ultimate ) then
         UpdateTabFrame(tab);
      end
   end
   if ( UltimateTab ) then
      UpdateTabFrame(UltimateTab);
   end
   -- FishingOptionsFrame:SetPoint("LEFT", lastFrame, "RIGHT", -18, 0);
   lastTabFrame = nil;
   if ( not currentTab ) then
      currentTab = TabFrames[1].frame;
   end
   if ( currentTab ) then
      PanelTemplates_SetTab(FishingBuddyFrame, currentTab:GetID());
      currentTab:Show();
      if ( currentTab.managedFrame ) then
         currentTab.managedFrame:Show();
      end
   end
end

local ManagedFrames = {};
local function DisableSubFrame(target)
   local frame, frameName = GetFrameInfo(target);
   local tab = ManagedFrames[frameName];
   if ( tab and tab.enabled ) then
      tab.enabled = false;
      ResetTabFrames();
   end
end
FishingBuddy.DisableSubFrame = DisableSubFrame;

local function EnableSubFrame(target)
   local frame, frameName = GetFrameInfo(target);
   local tab = ManagedFrames[frameName];
   if ( tab ) then
      tab.enabled = true;
      ResetTabFrames();
   end
end
FishingBuddy.EnableSubFrame = EnableSubFrame;

local function AssignTabFrame(tabframe, target, id)
   local frame, frameName = GetFrameInfo(target);   
   ManagedFrames[frameName] = tabframe;
   tabframe:SetFrameLevel(frame:GetFrameLevel()+1);
   tabframe.managedFrame = frame;
   if ( id ) then
      tabframe:SetID(id);
      TabFrames[id] = tabframe;
   end
end

local function IsAssigned(target)
   local frame, frameName = GetFrameInfo(target);   
   return (ManagedFrames[frameName] ~= nil);
end

local function ShowSubFrame(target)
   local frame, frameName = GetFrameInfo(target);
   local ctab;
   for id=1,next_frameid-1 do
      local tab = TabFrames[id];
      if ( tab.enabled and tab.managedFrame ) then
         if ( tab.managedFrame == frame ) then
            ctab = tab;
         end
      end
   end
   if ( not ctab ) then
      ctab = TabFrames[1];
   end
   currentTab = ctab;
   ResetTabFrames();
end

local function MakeFrameTab(target, tabname, tooltip, toggle)
   local frame,_ = GetFrameInfo(target);
   local tab = CreateTabFrame(frame, tabname);
   if ( tooltip ) then
      tab.tooltip = tooltip;
   end
   if ( toggle ) then
      tab.toggle = "TOGGLEFISHINGBUDDY"..toggle;
   end
   return tab;
end

local function FindTab(frame)
   for id=1,next_frameid-1 do
      tab = TabFrames[id];
      if ( tab.managedFrame == frame ) then
         return tab;
      end
   end
-- return nil;
end

local function ManageFrame(target, tabname, tooltip, toggle)
   if ( not IsAssigned(target) ) then
      local frame, frameName = GetFrameInfo(target);
      local tabframe = MakeFrameTab(frame, tabname, tooltip, toggle);
      AssignTabFrame(tabframe, frame);
      EnableSubFrame(frameName);
   end
end
FishingBuddy.ManageFrame = ManageFrame;

local function CreateManagedFrame(framename, tabname, tooltip, toggle)
   local f = CreateFrame("FRAME", framename, FishingBuddyFrame, "FishingBuddySmallHeaderTemplate");
   f:SetWidth(384);
   f:SetHeight(512);
   f:SetAllPoints(FishingBuddyFrame);
   f:SetHitRectInsets(0, 30, 0, 75);
   if ( tabname ) then
      ManageFrame(f, tabname, tooltip, toggle);
   end
   return f;
end
FishingBuddy.CreateManagedFrame = CreateManagedFrame;

function ToggleFishingBuddyFrame(target)
   local frame, frameName = GetFrameInfo(target);
   local tab = FindTab(frame);
   if ( tab ) then
      currentTab = tab;
      if ( FishingBuddyFrame:IsVisible() ) then
         if ( frame:IsVisible() ) then
            HideUIPanel(FishingBuddyFrame);        
         end
      else
         ShowUIPanel(FishingBuddyFrame);
      end
      ResetTabFrames();
   end   
end

function FishingBuddyFrameTab_OnClick(self)
   currentTab = self;
   ResetTabFrames();
   PlaySound("igCharacterInfoTab");
end

function FishingBuddyFrame_OnLoad(self)
   -- Act like Blizzard windows
   UIPanelWindows["FishingBuddyFrame"] = { area = "left", pushable = 999 }; 
   -- Close with escape key
   tinsert(UISpecialFrames, "FishingBuddyFrame"); 

   FishingBuddyFramePortrait:SetTexture("Interface\\LootFrame\\FishingLoot-Icon");
   FishingBuddyNameText:SetText(FBConstants.WINDOW_TITLE);

   self:RegisterEvent("VARIABLES_LOADED");
end

function FishingBuddyFrame_OnEvent(self, event, ...)
   if ( event == "VARIABLES_LOADED" ) then
      -- set up mappings
      for idx,info in pairs(FBFRAMES) do
         local tf = MakeFrameTab(info.frame, info.name,
                                 info.tooltip, info.toggle);
         AssignTabFrame(tf, info.frame);
         EnableSubFrame(info.name);
         if ( info.first) then
            tf.first = true;
            FirstAmongTabs = tf;
         elseif ( info.ultimate ) then
            tf.ultimate = true;
            UltimateTab = tf;
         end
      end
      ShowSubFrame("FishingLocationsFrame");
   end
end

function FishingBuddyFrame_OnShow()
   FishingBuddy.RunHandlers(FBConstants.FRAME_SHOW_EVT);
   UpdateMicroButtons();
   ResetTabFrames();
end

function FishingBuddyFrame_OnHide()
   UpdateMicroButtons();
end
