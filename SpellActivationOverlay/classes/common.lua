local AddonName,SAO=...
SAO.Class={}
SAO.Class["__SHARED"]={
["Register"]=function(self)
local useLeapOfFaith=function(spellID,classFile)
local classColor={255*RAID_CLASS_COLORS[classFile].r,255*RAID_CLASS_COLORS[classFile].g,255*RAID_CLASS_COLORS[classFile].b}
local fromClass=self:FromClass(classFile)
SAO:CreateEffect(
"leap_of_faith_"..classFile:lower(),
SAO.MOP_AND_ONWARD,
spellID,
"aura",
{
overlay={
texture="genericarc_06",position="Left + Right (Flipped)",
level=9,
scale=1.25,
color=classColor,
option={subText=fromClass} -- Options texts "From:" help identify the effect is shared
},
}
)
end
useLeapOfFaith(92572, "PRIEST")
useLeapOfFaith(110724, "DRUID")
end,
["LoadOptions"]=function(self)
end,
}