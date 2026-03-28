local AddonName,SAO=...
function SAO.CreateTextureVariants(self,auraID,optionIndex,values)
local textureFunc=function()
return self.TexName[self:GetOverlayOptions(auraID)[optionIndex]]
end
local textureTestFunc=function(cb,sb)
if (cb:GetChecked())then
return nil
else
local sbText=sb and UIDropDownMenu_GetText(sb)
for _,obj in ipairs(values)do
if (obj.text==sbText or obj.text==sbText:gsub(":127:127:127|t",":255:255:255|t"))then
return self.TexName[obj.value]
end
end
return nil
end
end
local variants={
variantType='texture',
textureFunc=textureFunc,
textureTestFunc=textureTestFunc,
values=values,
}
return variants
end
function SAO.TextureVariantValue(self,texture,horizontal,suffix)
local text
if (horizontal)then
text="|T"..self.TexName[texture]..":16:32:0:0:256:128:16:240:16:112:255:255:255|t"
else
text="|T"..self.TexName[texture]..":16:16:0:0:128:256:16:112:80:176:255:255:255|t"
end
if (suffix)then
text=(text or "").." "..suffix
end
local width=horizontal and 6 or 3
if (suffix)then
width=width+1+strlenutf8(suffix)
end
return {
value=texture,
text=text or texture,
width=width,
}
end
function SAO.CreateStringVariants(self,optionType,optionID,optionSubID,values)
local getOption=function()
if optionType=="glow" then
return self:GetGlowingOptions(optionID)[optionSubID]
else
return self:GetOverlayOptions(optionID)[optionSubID]
end
end
local variants={
variantType='string',
getOption=getOption,
values=values,
}
return variants
end
function SAO.StringVariantValue(self,items,valuePrefix,getTextFunc)
local text=""
local value=""
if #items==1 then
value=tostring(items[1])
text=self:OnlyFor(getTextFunc(items[1]))
elseif #items > 1 then
for _,item in ipairs(items)do
value=value=="" and tostring(item) or value.."/"..tostring(item)
text=text..", "..getTextFunc(item)
end
text=text:sub(3)
end
local width=ceil(strlenutf8(text)*0.4)
return {
value=valuePrefix..value,
text=text,
width=width,
}
end
function SAO.SpecVariantValue(self,specs)
return self:StringVariantValue(specs, "spec:",
function(spec)
return SAO:GetSpecName(spec)
end)
end
function SAO.SpellVariantValue(self,spellIDs)
return self:StringVariantValue(spellIDs, "spell:",
function(spellID)
return SAO:GetSpellName(spellID)
end)
end
local ClassStance={
["DRUID"]={
5487,
1066,
768,
783,
24858,
},
["ROGUE"]={
1784,
},
["PALADIN"]={
465,
7294,
19746,
19876,
19888,
19891,
32223,
},
["PRIEST"]={
15473,
},
["WARRIOR"]={
2457,
71,
2458,
},
}
function SAO.StanceVariantValue(self,stances)
local classFile=self.CurrentClass and self.CurrentClass.Intrinsics[2] or select(2,UnitClass("player"))
return self:StringVariantValue(stances, "stance:",
function(stance)
if ClassStance[classFile] and ClassStance[classFile][stance] then
return SAO:GetSpellName(ClassStance[classFile][stance])
end
return UNKNOWN
end)
end
function SAO.CooldownVariantValue(self,cooldowns)
return self:StringVariantValue(cooldowns, "cd:",
function(cooldown)
if cooldown=="on" then
return string.format("%s %s",COMBATLOG_HIGHLIGHT_ABILITY,ON_COOLDOWN)
elseif cooldown=="off" then
return string.format("%s %s",COMBATLOG_HIGHLIGHT_ABILITY,AVAILABLE)
end
return UNKNOWN
end)
end
