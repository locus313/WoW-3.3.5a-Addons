-- Handle all the option settings

local function copytable(tab)
   local t = {};
   for k,v in pairs(tab) do
      if ( type(v) == "table" ) then
         t[k] = copytable(v);
      else
         t[k] =v;
      end
   end
   return t;
end

local FBOptionsTable = {};

local function FindOptionInfo (setting)
   for _,info in pairs(FBOptionsTable) do
      if ( info.options[setting] ) then
         return info;
      end
   end
   -- return nil;
end

local function GetDefault(setting)
   local info = FindOptionInfo(setting);
   if ( info ) then
      local opt = info.options[setting];
      if ( opt ) then
         if ( opt.check and opt.checkfail ) then
            if ( not opt.check() ) then
               return opt.checkfail;
            end
         end
         return opt.default;
      end
   end
   -- return nil;
end
FishingBuddy.GetDefault = GetDefault;

local function GetSetting(setting)
   local val = nil;
   if ( setting ) then
      local info = FindOptionInfo(setting);
      if ( info ) then
         val = info.getter(setting);
         if ( val == nil ) then
            val = GetDefault(setting);
         end
      else
         val = FishingBuddy.BaseGetSetting(setting);
      end
   end
   return val;
end
FishingBuddy.GetSetting = GetSetting;

local function GetSettingBool(setting)
   local val = GetSetting(setting);
   return val == 1;
end
FishingBuddy.GetSettingBool = GetSettingBool;

local function SetSetting(setting, value)
   if ( setting ) then
      local info = FindOptionInfo(setting);
      if ( info ) then
         local val = GetDefault(setting);
         if ( val == value ) then
            info.setter(setting, nil);
         else
            info.setter(setting, value);
         end
      else
         FishingBuddy.BaseSetSetting(setting, value);
      end
   end
end
FishingBuddy.SetSetting = SetSetting;

-- display all the option settings
FishingBuddy.OptionsFrame = {};

local function ParentValue(button)
   local value = 1;
   if ( button.parents ) then
      for _,b in pairs(button.parents) do
         if ( b.checkbox and not b:GetChecked() ) then
            value = nil;
         end
      end
   end
   return value;
end

local function CheckBox_Able(button, value)
   if ( not button ) then
      return;
   end
   if ( not value ) then
      value = ParentValue(button);
   end
   local color;
   if ( value ) then
      if (button.checkbox) then
         button:Enable();
      end
      color = NORMAL_FONT_COLOR;
   else
      if ( button.checkbox ) then
         button:Disable();
      end
      color = GRAY_FONT_COLOR;
   end
   local text = getglobal(button:GetName().."Text");
   if ( text ) then
      text:SetTextColor(color.r, color.g, color.b);
   end
end

local function hideOrDisable(what, value, button)
   local value = ParentValue(button);
   if ( what == "d" ) then
      CheckBox_Able(button, value);
   elseif ( what == "h" ) then
       button:Hide();
       if ( value == 1 ) then
         if ( not button.visible or button.visible() == 1 ) then
            button:Show();
         end
      end
   end
end

local function CheckButton_HandleDeps(parent, button)
   if ( button.deps ) then
      local value = ((parent == 1) and (not button.checkbox or button:GetChecked() ~= nil));
      for button,what in pairs(button.deps) do
         hideOrDisable(what, value, button);
         CheckButton_HandleDeps(value, button);
      end
   end
end

local function CheckButton_OnShow(button)
   button:SetChecked(GetSetting(button.name));
end
FishingBuddy.CheckButton_OnShow = CheckButton_OnShow;

local function CheckButton_OnClick(button, quiet)
   if ( not button ) then
      return;
   end
   local value = 1;
   if ( button.checkbox) then
      if ( not button:GetChecked() ) then
         value = 0;
      end
      if ( not quiet ) then
         if ( value ) then
            PlaySound("igMainMenuOptionCheckBoxOn");
         else
            PlaySound("igMainMenuOptionCheckBoxOff");
         end
      end
   end
   SetSetting(button.name, value);
   FishingBuddy.OptionsUpdate();
   if ( button.update ) then
      button.update(button);
   end
   CheckButton_HandleDeps(value, button);
end
FishingBuddy.CheckButton_OnClick = CheckButton_OnClick;

local optionbuttons = {};
local optionmap = {};

local function processdeps(button, deps)
   for n,what in pairs(deps) do
      local b = optionmap[n];
      if ( b ) then
         if ( not b.deps ) then
            b.deps = {};
         end
         b.deps[button] = what;
         if ( not button.parents ) then
            button.parents = {};
         end
         tinsert(button.parents, b);
      end
   end
end

local function dolayout(deps)
   table.sort(deps, function(a,b)
      if ( a.custom ) then
         return false;
      else
         return a.width < b.width;
      end
   end);
   local order = {};
   local used = {};
   for idx=1,#deps do
      local b = deps[idx];
      if (b.deps and not used[b.name] ) then
         used[b.name] = 1;
         tinsert(order, idx);
         for d,_ in pairs(b.deps) do
            for jdx=1,#deps do
               if ( not used[d.name] and deps[jdx].name == d.name) then
                  used[d.name] = 1;
                  tinsert(order, jdx);
               end
            end
         end
      end
   end
   for idx=1,#deps do
      local b = deps[idx];
      if ( not used[b.name] ) then
         tinsert(order, idx);
      end
   end
   return order;
end

local function Setup(options, nomap)
   FishingOptionsFrame.groupoptions = options;
   
-- Clear out all the stuff we put on the old buttons
   for name,button in pairs(optionmap) do
      button.name = nil;
      button.width = 0;
      button.slider = 0;
      button.update = nil;
      button.text = "";
      button.tooltipText = nil;
      button.primary = nil;
      button.deps = nil;
      button.right = nil;
      button.layoutright = nil;
      button.margin = nil;
      button.visible = nil;
      button.adjacent = nil;
      button.parents = nil;
      CheckBox_Able(button, 0);
      button:ClearAllPoints();
      if (button.checkbox) then
         button:SetHitRectInsets(0, -100, 0, 0);
      end
      button.custom = nil;
      button:Hide();
   end
   optionmap = {};
   
   local lastbutton = nil;
   local primaries = {};
   local index = 1;
   for name,option in pairs(options) do
      local button = nil;
      if ( option.button ) then
         button = getglobal(option.button);
         if ( button ) then
            button.custom = 1;
            button.checkbox = (button:GetObjectType() == "CheckButton");
            if ( not nomap ) then
               button:ClearAllPoints();
               button:SetParent(FishingOptionsFrame);
            end
            if ( option.v ) then
               button:SetScript("OnShow", CheckButton_OnShow);
               button:SetScript("OnClick", CheckButton_OnClick);
            end
         end
      elseif ( option.v ) then
         button = optionbuttons[index];
         if ( not button ) then
            button = CreateFrame(
               "CheckButton", "FishingBuddyOption"..index,
               FishingOptionsFrame, "OptionsSmallCheckButtonTemplate");
            -- override OnShow and OnClick
            button:SetScript("OnShow", CheckButton_OnShow);
            button:SetScript("OnClick", CheckButton_OnClick);
            -- use default OnEnter and OnLeave
         end
         optionbuttons[index] = button;
         button.checkbox = 1;
      end
      if ( button ) then
         if ( not nomap ) then
            optionmap[name] = button;
         end
         local enable = true;
         button.name = name;
         button.layoutright = option.layoutright;
         button.margin = option.margin;
         button.name = name;
         button.update = option.update;
         button.visible = option.visible;
         button.width = button:GetWidth();
         if ( option.text ) then
            button.text = option.text;
            local text = getglobal(button:GetName().."Text");
            if (text) then
               text:SetText(option.text);
               button.width = button.width + text:GetWidth();
            end
         else
            button.text = "";
         end
         if ( button.checkbox ) then
            button:SetChecked(GetSetting(name));
         end
         button.tooltipText = option.tooltip;
         -- hack for sliders (why?)
         if (button:GetObjectType() == "Slider") then
            button.slider = 16;
         else
            button.slider = 0;
         end
         if ( option.setup ) then
            option.setup(button);
         end
         index = index + 1;
      end
   end
   for name,option in pairs(options) do
      local button = optionmap[name];
      if ( button ) then
         if ( option.deps ) then
            button.primary = option.primary;
            processdeps(button, option.deps);
         else
            tinsert(primaries, name);
         end
      end
   end
   local lastoff = 0;
   local lastbutton = nil;
   for _,name in pairs(primaries) do
      local button = optionmap[name];
      if ( not lastbutton ) then
         button:SetPoint("TOPLEFT", 32, -82);
      else
         local yoff = 2;
         if ( button.margin ) then
            yoff = yoff - button.margin[1];
         end
         if ( lastbutton.margin ) then
            yoff = yoff - lastbutton.margin[2];
         end
         button:SetPoint("TOPLEFT", lastbutton, "BOTTOMLEFT", lastoff, yoff);
      end
      lastbutton = button;
      lastoff = 0;
      if ( button.deps ) then
         local deps = {};
         for b,n in pairs(button.deps) do
            if ( optionmap[b.name] and (not b.primary or b.primary == name) and b.name ~= button.layoutright) then
               tinsert(deps, b);
            end
         end
         local order = dolayout(deps);
         local maxwidth = 0;
         for iorder,index in ipairs(order) do
            local colbut = deps[index];
            if ( colbut ) then
               if ( (iorder % 2) == 1 ) then
                  local yoff = 2;
                  if ( colbut.margin ) then
                     yoff = yoff - colbut.margin[1];
                  end
                  if ( lastbutton.margin ) then
                     yoff = yoff - lastbutton.margin[2];
                  end
                  colbut:SetPoint("TOPLEFT", lastbutton, "BOTTOMLEFT", 16+lastoff, yoff);
                  lastbutton = colbut;
                  lastoff = -16;
               else
                  colbut.adjacent = lastbutton;
                  colbut:SetPoint("TOP", lastbutton, "TOP", 0, 0);
                  if ( not colbut.custom and colbut.width > maxwidth ) then
                     maxwidth = colbut.width;
                  end
                  colbut.right = 1;
               end
            end
         end
         for index=1,#deps do
            local colbut = deps[index];
            if (colbut.right) then
               if ( colbut.checkbox ) then
                  colbut:SetPoint("RIGHT", FishingOptionsFrame, "RIGHT", -32-maxwidth, 0);
                  colbut:SetHitRectInsets(0, -maxwidth, 0, 0);
               else
                  colbut:SetPoint("LEFT", FishingOptionsFrame, "RIGHT", -32-colbut.width-colbut.slider, 0);
               end
            end
         end
      end
      if ( button.layoutright ) then
          local toright = optionmap[button.layoutright];
          if (toright) then
             toright:ClearAllPoints();
             toright:SetPoint("CENTER", button, "CENTER", 0, 0);
             toright:SetPoint("RIGHT", FishingOptionsFrame, "RIGHT", -32, 0);
          end
      end
   end
end

-- handle option panel tabs
local tabbuttons = {};
local tabmap = {};

local function showallbuttons()
   -- now that we've collected all of the dependencies, handle them
   for name,button in pairs(optionmap) do
      local button = optionmap[name];
      if ( button ) then
         local showit = 1;
         if ( button.visible ) then
            showit = button.visible();
         end
         if ( showit ) then
            button:Show();
         else
            button:Hide();
         end
      end
   end
   for name,button in pairs(optionmap) do
      if ( not button.parents ) then
         CheckButton_HandleDeps(1, button);
      end
   end
end

local function OptionTab_OnClick(self, button)
   local name = self.name;
   if ( FishingOptionsFrame.selected ~= name ) then
      local lasttab = tabmap[FishingOptionsFrame.selected];
      if ( lasttab ) then
         lasttab:SetChecked(nil);
         FishingBuddy.OptionsUpdate();
      end
      FishingOptionsFrame.selected = name;
      Setup(FBOptionsTable[name].options);
      showallbuttons();
   end
   tabmap[name]:SetChecked(1);
end

local function PositionTab(tab, prevtab)
   tab:ClearAllPoints();
   if ( prevtab ) then
      tab:SetPoint("TOPLEFT", prevtab, "BOTTOMLEFT", 0, -17);
   else
      tab:SetPoint("TOPLEFT", FishingOptionsFrame, "TOPRIGHT", -32, -65);
   end
   tab:Show();
end

local function UpdateTabs()
   local prevtab = nil;
   local lasttab = nil;
   for index,tab in ipairs(tabbuttons) do
      local name = tab.name;
      local handler = FBOptionsTable[name];
      if ( handler.first and handler.visible ) then
         PositionTab(tab);
         prevtab = tab;
      end
      if ( handler.last and handler.visible ) then
         lasttab = tab;
      end
   end
   for index,tab in ipairs(tabbuttons) do
      local name = tab.name;
      local handler = FBOptionsTable[name];
      if ( handler.visible ) then
         if ( not handler.first and not handler.last ) then
            PositionTab(tab, prevtab);
            prevtab = tab;
          end
      else
         tab:Hide();
      end
   end
   if ( lasttab ) then
      PositionTab(lasttab, prevtab);
   end
end

local INV_MISC_QUESTIONMARK = "Interface\\Icons\\INV_Misc_QuestionMark";
local function HandleOptions(name, icon, options, setter, getter)
   local index = #tabbuttons + 1;
   local handler = {};
   local maketab = (name ~= nil);
   if ( not name ) then
      name = "FBHIDDEN";
      handler.index = 0;
      -- handle option buttons that show up outside of option frames
      Setup(options, 1);
   end
   if ( name == GENERAL ) then
      handler.first = true;
   elseif (name == GUILD_BANK_TAB_INFO ) then
      handler.last = true;
   end
   handler.name = name;
   handler.icon = icon or INV_MISC_QUESTIONMARK;
   handler.options = copytable(options);
   handler.setter = setter or FishingBuddy.BaseSetSetting;
   handler.getter = getter or FishingBuddy.BaseGetSetting;
   handler.visible = maketab;
   if ( FBOptionsTable[name] ) then
      for name,info in pairs(FBOptionsTable[name].options) do
         handler.options[name] = copytable(info);
      end
      handler.index = FBOptionsTable[name].index;
   end
   FBOptionsTable[name] = handler;

   -- just handle the setting and getting if no name supplied
   if ( maketab ) then
      local optiontab = tabmap[name];
      if ( not optiontab ) then
         optiontab = CreateFrame(
                  "CheckButton", "FishingBuddyOptionTab"..index,
                  FishingOptionsFrame, "SpellBookSkillLineTabTemplate");
         optiontab:SetScript("OnClick", OptionTab_OnClick);
         optiontab.name = name;
         optiontab.tooltip = name;
         optiontab:SetNormalTexture(handler.icon);
         tinsert(tabbuttons, optiontab);
         tabmap[name] = optiontab;
         handler.index = index;
      end
   end
end
FishingBuddy.OptionsFrame.HandleOptions = HandleOptions;

local function HideOptionsTab(name)
   if ( FBOptionsTable[name] and FBOptionsTable[name].visible ) then
      FBOptionsTable[name].visible = nil;
      UpdateTabs();
   end
end
FishingBuddy.HideOptionsTab = HideOptionsTab;

local function ShowOptionsTab(name)
   if ( FBOptionsTable[name] and not FBOptionsTable[name].visible ) then
      FBOptionsTable[name].visible = true;
      UpdateTabs();
   end
end
FishingBuddy.ShowOptionsTab = ShowOptionsTab;

local function OptionsFrame_OnShow(self)
   UpdateTabs();
   showallbuttons();
   local selected = FishingOptionsFrame.selected;
   local first = nil;
   for name,handler in pairs(FBOptionsTable) do
      if ( handler.visible ) then
         if ( not first or handler.first ) then
            first = name;
         end
      else
         if ( selected == name ) then
            selected = nil;
         end
      end
   end
   if ( not selected and first ) then
      selected = first;
   end
   for name,tab in pairs(tabmap) do
      if ( selected == name ) then
         if ( not tab:GetChecked() ) then
            OptionTab_OnClick(tab);
         end
      else
         tab:SetChecked(nil);
      end
   end
   FishingOptionsFrame.selected = selected;
end

local function OptionsFrame_OnHide(self)
   for _,tab in pairs(tabmap) do
      tab:Hide();
   end
   FishingBuddy.OptionsUpdate();
end

-- Drop-down menu support
local function ToggleSetting(setting)
   local value = GetSetting(setting);
   if ( not value ) then
      value = 0;
   end
   SetSetting(setting, 1 - value);
   FishingBuddy.OptionsUpdate(true);
end
FishingBuddy.ToggleSetting = ToggleSetting;

-- save some memory by keeping one copy of each one
local ToggleFunctions = {};
-- let's use closures
local function MakeToggle(name, callme)
   if ( not ToggleFunctions[name] ) then
      local n = name;
      local c = callme;
      ToggleFunctions[name] = function() ToggleSetting(n); if (c) then c() end; end;
   end
   return ToggleFunctions[name];
end
FishingBuddy.MakeToggle = MakeToggle;

local function MakeDropDownEntry(switchText, switchSetting, keepShowing, callMe)
   info = {};
   info.text = switchText;
   info.func = MakeToggle(switchSetting, callMe);
   info.checked = FishingBuddy.GetSettingBool(switchSetting);
   info.keepShownOnClick = keepShowing;
   UIDropDownMenu_AddButton(info);
end
FishingBuddy.MakeDropDownEntry = MakeDropDownEntry;

local function MakeDropDownSep()
   info = {};
   info.disabled = 1;
   UIDropDownMenu_AddButton(info);
end
FishingBuddy.MakeDropDownSep = MakeDropDownSep;

FishingBuddy.MakeDropDown = function(switchText, switchSetting)
   local info;
   -- If no outfit frame, we can't switch outfits...
   if ( FishingBuddy.OutfitManager.HasManager() ) then
      MakeDropDownEntry(switchText, switchSetting, 1);
      MakeDropDownSep();
   end

   for _,info in pairs(FBOptionsTable) do
      for name,option in pairs(info.options) do
         if ( option.m ) then
            local addthis = true;
            if ( option.check ) then
               addthis = option.check();
            end
            if ( addthis ) then
               info = {};
               info.text = option.text;
               info.func = MakeToggle(name);
               info.checked = FishingBuddy.GetSettingBool(name);
               info.keepShownOnClick = 1;
               UIDropDownMenu_AddButton(info);
            end
         end
      end
   end
end

FishingBuddy.GetOptionList = function()
   local options = {};
   for _,info in pairs(FBOptionsTable) do
      for name,option in pairs(info.options) do
         options[name] = option;
      end
   end
   return options;
end

-- Create the options frame, unmanaged -- we get managed specially later
local f = FishingBuddy.CreateManagedFrame("FishingOptionsFrame");
f:SetScript("OnShow", OptionsFrame_OnShow);
f:SetScript("OnHide", OptionsFrame_OnHide);
