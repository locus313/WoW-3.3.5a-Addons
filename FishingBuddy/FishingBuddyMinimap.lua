-- Minimap Button Handling

FishingBuddy.Minimap = {};

FishingBuddy.Minimap.Button_OnLoad = function(self)
   self:SetFrameLevel(self:GetFrameLevel()+1)
   self:RegisterForDrag("LeftButton");
   self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
--   self:RegisterEvent("VARIABLES_LOADED");
end

FishingBuddy.Minimap.Button_OnClick = function(self, button, down)
   if ( button == "RightButton" ) then
      if ( IsAltKeyDown() ) then
         ToggleFishingBuddyFrame("FishingOptionsFrame");
      else
         -- Toggle menu
         local menu = getglobal("FishingBuddyMinimapMenu");
         UIDropDownMenu_Initialize(menu, FishingBuddy.Minimap.Menu_Initialize, "MENU");
         menu.point = "TOPRIGHT";
         menu.relativePoint = "CENTER";
         ToggleDropDownMenu(1, nil, menu, "FishingBuddyMinimapButton", 0, 0);
      end
   elseif ( FishingBuddy.IsSwitchClick("MinimapClickToSwitch") ) then
      FishingBuddy.Command(FBConstants.SWITCH);
   else
      FishingBuddy.Command("");
   end
end

local function BeingDragged()
   -- Thanks to Gello for this code
   local xpos,ypos = GetCursorPosition();
   local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();

   xpos = xmin-xpos/UIParent:GetScale()+80;
   ypos = ypos/UIParent:GetScale()-ymin-80;

   local ang = math.deg(math.atan2(ypos,xpos));
   if ( ang < 0 ) then
      ang = ang + 360;
   end
   FishingBuddy.SetSetting("MinimapButtonPosition", ang);
   FishingBuddyMinimapButton_MoveButton();
end

FishingBuddy.Minimap.Button_OnDragStart = function(self, button)
   self:SetScript("OnUpdate", BeingDragged);
end

FishingBuddy.Minimap.Button_OnDragStop = function(self, button)
   self:SetScript("OnUpdate", nil);
end

FishingBuddyMinimapButton_MoveButton = function()
   if ( FishingBuddy.IsLoaded() ) then
      local where = FishingBuddy.GetSetting("MinimapButtonPosition");
      local radius = FishingBuddy.GetSetting("MinimapButtonRadius");
      FishingBuddyMinimapFrame:ClearAllPoints();
      FishingBuddyMinimapFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT",
					 52 - (radius * cos(where)),
					 (radius * sin(where)) - 52);
   end
end

local function UpdateMinimap()
   FishingBuddyMinimapButton_MoveButton();
   if ( FishingBuddy.GetSettingBool("MinimapButtonVisible") and
        Minimap:IsVisible() ) then
      FishingBuddyMinimapButton:EnableMouse(true);
      FishingBuddyMinimapButton:Show();
      FishingBuddyMinimapFrame:Show();
   else
      FishingBuddyMinimapButton:EnableMouse(false);
      FishingBuddyMinimapButton:Hide();
      FishingBuddyMinimapFrame:Hide();
   end
end

FishingBuddy.Minimap.Button_OnEvent = function(self, event, ...)
end

FishingBuddy.Minimap.Button_OnEnter = function(self)
   if ( GameTooltip.fbmmbfinished ) then
      return;
   end
   GameTooltip.fbmmbfinished = 1;
   GameTooltip:SetOwner(FishingBuddyMinimapFrame, "ANCHOR_LEFT");
   GameTooltip:AddLine(FBConstants.NAME);
   local text = FishingBuddy.TooltipBody("MinimapClickToSwitch");
   GameTooltip:AddLine(text,.8,.8,.8,1);
   GameTooltip:Show();
end

FishingBuddy.Minimap.Button_OnLeave = function(self)
   GameTooltip:Hide();
   GameTooltip.fbmmbfinished = nil;
end

function FishingBuddy_ToggleMinimap()
   if ( FishingBuddy.SavedToggleMinimap ) then
      FishingBuddy.SavedToggleMinimap();
   end
   UpdateMinimap();
end

FishingBuddy.Minimap.Menu_Initialize = function()
   FishingBuddy.MakeDropDown(FBConstants.CLICKTOSWITCH_ONOFF, "MinimapClickToSwitch");
end

local MinimapEvents = {};
MinimapEvents["VARIABLES_LOADED"] = UpdateMinimap;

MinimapEvents[FBConstants.OPT_UPDATE_EVT] = UpdateMinimap;

FishingBuddy.Minimap.OnLoad = function(self)
   FishingBuddy.API.RegisterHandlers(MinimapEvents);
end

FishingBuddy.Minimap.OnEvent = function(self, event, ...)
end

local function Slider_OnLoad(self, info)
   self.info = info;
   self.textfield = getglobal(info.name.."Text");
   getglobal(info.name.."High"):SetText();
   getglobal(info.name.."Low"):SetText();
   self:SetWidth(130);
   self:SetHeight(17);
   self:SetMinMaxValues(info.min, info.max);
   self:SetValueStep(1);
end

local function Slider_OnShow(self)
   local where = FishingBuddy.GetSetting(self.info.setting);
   if (where) then
      self:SetValue(where);
      self.textfield:SetText(string.format(self.info.format, where));
   end
end

local function Slider_OnValueChanged(self)
   local where = self:GetValue();
   self.textfield:SetText(string.format(self.info.format, where));
   FishingBuddy.SetSetting(self.info.setting, where);
   FishingBuddyMinimapButton_MoveButton();
end

local sliders = {
   { ["name"] = "MinimapPosSlider",
     ["format"] = FBConstants.MINIMAPBUTTONPLACEMENT.." - %d\194\176",
     ["min"] = 0,
     ["max"] = 360,
     ["rightextra"] = 32,
     ["setting"] = "MinimapButtonPosition",
   },
   { ["name"] = "MinimapRadSlider",
     ["format"] = FBConstants.MINIMAPBUTTONRADIUS.." - %d",
     ["min"] = 80,
     ["max"] = 150,
     ["rightextra"] = 32,
     ["setting"] = "MinimapButtonRadius", },
};

for _,info in ipairs(sliders) do
   info.name = "FishingBuddyOption_"..info.name;
   local s = CreateFrame("Slider", info.name, nil, "OptionsSliderTemplate");
   Slider_OnLoad(s, info);
   s:SetScript("OnShow", Slider_OnShow);
   s:SetScript("OnValueChanged", Slider_OnValueChanged);
end
