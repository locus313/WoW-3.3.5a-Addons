local AddonName,SAO=...
local Module="shutdown"
local InterfaceOptionsFrame_OpenToCategory=InterfaceOptionsFrame_OpenToCategory
if Settings and Settings.RegisterCanvasLayoutCategory then
InterfaceOptionsFrame_OpenToCategory=function(categoryIDOrFrame)
if type(categoryIDOrFrame)=="table" then
local categoryID=categoryIDOrFrame.name
return Settings.OpenToCategory(categoryID)
else
return Settings.OpenToCategory(categoryIDOrFrame)
end
end
end
local Categories={
UNSUPPORTED_CLASS={
Priority=0,
Get=function()
return {
Reason=SAO:unsupportedClass(),
Button=nil,
DisableCondition=nil,
}
end,
},
DISABLED_CLASS={
Priority=1,
Get=function()
return {
Reason=SAO:disabledClass():gsub(" %%s", ""):gsub("%%s",""):gsub(" :%)", ""),
Button=nil,
DisableCondition=nil,
}
end,
},
SAO_INSTALLED={
Priority=2,
Get=function()
return {
Reason=SAO:becauseOf("Spell".."ActivationOverlay"),
Button={
ShowIf=function()
return _G["Spell".."ActivationOverlayDB"]~=nil
end,
Text=SAO:openIt("Spell".."ActivationOverlay"),
OnClick=function()
InterfaceOptionsFrame_OpenToCategory(_G["Spell".."ActivationOverlayOptionsPanel"])
end
},
DisableCondition={
ShowIf=function()
return SpellActivationOverlayDB~=nil
end,
Text=SAO:disableWhenInstalled("Spell".."ActivationOverlay"),
OnValueChanged=function(self,checked)
SpellActivationOverlayDB.disableIfSAO=checked
end,
IsDisabled=function()
return SpellActivationOverlayDB.disableIfSAO==true or SpellActivationOverlayDB.disableIfSAO==nil
end,
}
}
end,
},
NECROSIS_INSTALLED={
Priority=3,
Get=function()
return {
Reason=SAO:becauseOf("|CFFFF00FFNe|CFFFF50FFcr|CFFFF99FFos|CFFFFC4FFis|CFFFFFFFF"),-- "Necrosis",with colors
Button={
ShowIf=function()
return NecrosisSpellActivationOverlayOptionsPanel~=nil
end,
Text=SAO:openIt("Necrosis Spell Activations"),
OnClick=function()
InterfaceOptionsFrame_OpenToCategory(NecrosisSpellActivationOverlayOptionsPanel)
end
},
DisableCondition={
ShowIf=function()
return NecrosisConfig~=nil
end,
Text=SAO:disableWhenInstalled("Necrosis"),
OnValueChanged=function(self,checked)
SpellActivationOverlayDB.disableIfNecrosis=checked
end,
IsDisabled=function()
return SpellActivationOverlayDB.disableIfNecrosis==true
end,
},
}
end,
},
}
local Shutdown={
TriggeredCategories={},
CurrentCategory=nil,
}
function Shutdown:IsAddonDisabled()
local category=self.CurrentCategory
if not category then
return false
end
if not category.DisableCondition then
return true
end
return category.DisableCondition.IsDisabled()
end
function Shutdown:GetCategory()
return self.CurrentCategory
end
function Shutdown:EnableCategory(name)
local rawCategory=Categories[name]
if not rawCategory then
SAO:Error(Module, "Unknown shutdown category",name)
end
if tContains(self.TriggeredCategories,name)then
SAO:Debug(Module, "Re-enabling shutdown category",name)
return
end
tinsert(self.TriggeredCategories,name)
SAO:Debug(Module, "Enabling shutdown category",name)
if self.CurrentCategory and self.CurrentCategory.Priority < rawCategory.Priority then
return
end
local category=rawCategory.Get()
category.Name=name
category.Priority=rawCategory.Priority
self.CurrentCategory=category
end
SAO.Shutdown=Shutdown
