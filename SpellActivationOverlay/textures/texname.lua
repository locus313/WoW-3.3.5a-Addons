local AddonName,SAO=...
local Module="texture"
local mapping=
{
["449486"]="Arcane Missiles",
["1027131"]="Arcane Missiles 1",
["1027132"]="Arcane Missiles 2",
["1027133"]="Arcane Missiles 3",
["450913"]="Art of War",
["460830"]="Backlash",
["801266"]="Backlash Green",
["1030393"]="Bandits Guile",
["510822"]="Berserk",
["511104"]="Blood Boil",
["449487"]="Blood Surge",
["449488"]="Brain Freeze",
["603338"]="Dark Tiger",
["461878"]="Dark Transformation",
["459313"]="Daybreak",
["2851787"]="Demonic Core",
["2888300"]="Demonic Core Green",
["511469"]="Denounce",
["1057288"]="Echo of the Elements",
["450914"]="Eclipse Moon",
["450915"]="Eclipse Sun",
["450916"]="Focus Fire",
["449489"]="Frozen Fingers",
["467696"]="Fulmination",
["460831"]="Fury of Stormrage",
["30000006"]="Fury of Stormrage Yellow",
["450917"]="GenericArc 01",
["450918"]="GenericArc 02",
["450919"]="GenericArc 03",
["450920"]="GenericArc 04",
["450921"]="GenericArc 05",
["450922"]="GenericArc 06",
["450923"]="GenericTop 01",
["450924"]="GenericTop 02",
["450925"]="Grand Crusader",
["459314"]="Hand of Light",
["2851788"]="High Tide",
["449490"]="Hot Streak",
["449491"]="Imp Empowerment",
["801267"]="Imp Empowerment Green",
["457658"]="Impact",
["458740"]="Killing Machine",
["450926"]="Lock and Load",
["1028136"]="Maelstrom Weapon 1",
["1028137"]="Maelstrom Weapon 2",
["1028138"]="Maelstrom Weapon 3",
["1028139"]="Maelstrom Weapon 4",
["450927"]="Maelstrom Weapon",-- This acts as a "Maelstrom Weapon 5" texture
["30000001"]="Maelstrom Weapon 6",
["30000002"]="Maelstrom Weapon 7",
["30000003"]="Maelstrom Weapon 8",
["30000004"]="Maelstrom Weapon 9",
["30000005"]="Maelstrom Weapon 10",
["450928"]="Master Marksman",
["458741"]="Molten Core",
["801268"]="Molten Core Green",
["1001511"]="Monk Blackout Kick",
["1028091"]="Monk Ox 2",
["1028092"]="Monk Ox 3",
["623950"]="Monk Ox",
["623951"]="Monk Serpent",
["1001512"]="Monk Tiger Palm",
["623952"]="Monk Tiger",
["450929"]="Nature's Grace",
["511105"]="Necropolis",
["449492"]="Nightfall",
["510823"]="Feral OmenOfClarity",
["898423"]="Predatory Swiftness",
["1518303"]="Predatory Swiftness Green",
["962497"]="Raging Blow",
["450930"]="Rime",
["469752"]="Serendipity",
["656728"]="Shadow Word Insanity",
["627609"]="Shadow of Death",
["463452"]="Shooting Stars",
["450931"]="Slice and Dice",
["424570"]="Spell Activation Overlay 0",
["449493"]="Sudden Death",
["450932"]="Sudden Doom",
["592058"]="Surge of Darkness",
["450933"]="Surge of Light",
["449494"]="Sword and Board",
["1029138"]="Thrill of the Hunt 1",
["1029139"]="Thrill of the Hunt 2",
["1029140"]="Thrill of the Hunt 3",
["774420"]="Tooth and Claw",
["627610"]="Ultimatum",
["603339"]="White Tiger",
}
SAO.TexName={}
SAO.TextureFilenameFromFullname={}
for retailTexture,classicTexture in pairs(mapping)do
local filename=classicTexture:gsub(" ", "_"):gsub("'", "")
local fullTextureName="Interface\\Addons\\SpellActivationOverlay\\textures\\"..filename
local retailNumber=tonumber(retailTexture,10)
if (
(SAO.IsCata() and retailNumber <=511469)
or
(SAO.IsMoP() and retailNumber <=898423)
) and
retailNumber~=450914 and retailNumber~=450915 then
fullTextureName=retailTexture
end
SAO.TexName[retailTexture]=fullTextureName
SAO.TexName[retailNumber]=fullTextureName
SAO.TexName[strlower(classicTexture)]=fullTextureName
SAO.TexName[strlower(classicTexture):gsub(" ", "_"):gsub("'", "")]=fullTextureName
SAO.TextureFilenameFromFullname[fullTextureName]=strlower(filename)
end
SAO.MarkedTextures={}
function SAO.MarkTexture(self,texName)
if not texName then return end
local pointedTexName=self.TexName[texName]
local fullTextureName
if pointedTexName then
self.MarkedTextures[pointedTexName]=true
fullTextureName=pointedTexName
elseif self.TextureFilenameFromFullname[texName] then
self.MarkedTextures[texName]=true
fullTextureName=texName
else
self:Error(Module, "Unknown texture "..texName)
end
if fullTextureName and
tostring(tonumber(fullTextureName,10))~=fullTextureName and
not GetFileIDFromPath(fullTextureName)
then
self:Error(Module, "Missing file for texture "..texName)
end
end
local function compareTextureNames(a,b)
local function splitString(str)
local segments={}
for segment in string.gmatch(str, "[^_]+")do
table.insert(segments,segment)
end
return segments
end
local function isNumber(segment)
return tonumber(segment)~=nil
end
local segmentsA=splitString(a)
local segmentsB=splitString(b)
for i=1,math.max(#segmentsA,#segmentsB)do
local segA=segmentsA[i] or ""
local segB=segmentsB[i] or ""
if segA==segB then
elseif segA=="" then
return true
elseif segB=="" then
return false
elseif isNumber(segA) and not isNumber(segB)then
return true
elseif not isNumber(segA) and isNumber(segB)then
return false
elseif isNumber(segA) and isNumber(segB)then
return tonumber(segA) < tonumber(segB)
else
return segA < segB
end
end
return false
end
function SAO_DB_ComputeUnmarkedTextures(output)
SAO_DB_AddMarkedTextures(false)
SpellActivationOverlayDB.dev.unmarked={native={},addon={}}
for fullTextureName,filename in pairs(SAO.TextureFilenameFromFullname)do
if availableTextures[filename] then
if not SAO.MarkedTextures[fullTextureName]
and (not SpellActivationOverlayDB.dev.marked
or (not SpellActivationOverlayDB.dev.marked.native[filename]
and not SpellActivationOverlayDB.dev.marked.addon[filename])
)
then
if type(tonumber(fullTextureName))=='number' then
SpellActivationOverlayDB.dev.unmarked.native[filename]=tonumber(fullTextureName)
else
SpellActivationOverlayDB.dev.unmarked.addon[filename]=fullTextureName
end
end
end
end
local excludeListSorted={}
for k,_ in pairs(SpellActivationOverlayDB.dev.unmarked.addon)do
tinsert(excludeListSorted,k)
end
table.sort(excludeListSorted,compareTextureNames)
SpellActivationOverlayDB.dev.unmarked.excludeList=excludeListSorted
if type(output)~='boolean' or output then
print("SAO_DB_ComputeUnmarkedTextures() "..WrapTextInColorCode("OK", "FF00FF00"))
local excludeListAsString=""
for _,v in ipairs(excludeListSorted)do
excludeListAsString=excludeListAsString .. v .. '\n'
end
SAO:DumpCopyableText("Files to exclude from package:",excludeListAsString)
end
return {unmarked=SpellActivationOverlayDB.dev.unmarked}
end
function SAO_DB_LookForTexture(fileDataID,output,saveToDev)
local f=CreateFrame("Frame",nil)
local tex=f:CreateTexture()
tex:SetPoint('CENTER',WorldFrame)
f:SetAllPoints(tex)
if saveToDev and SpellActivationOverlayDB.dev then
SpellActivationOverlayDB.dev.existing[fileDataID]=nil
end
f:SetScript('OnSizeChanged',function(self,width,height)
local isLoaded=width > 15 and height > 15
if saveToDev and SpellActivationOverlayDB.dev then
SpellActivationOverlayDB.dev.existing.id[fileDataID]=isLoaded
SpellActivationOverlayDB.dev.existing.remaining=SpellActivationOverlayDB.dev.existing.remaining-1
if SpellActivationOverlayDB.dev.existing.remaining==0 and (type(output)~='boolean' or output)then
print("SAO_DB_DetectExistingMarkedTextures() "..WrapTextInColorCode("Complete", "FF00FF00"))
end
end
if not saveToDev and (type(output)~='boolean' or output)then
if isLoaded then
SAO:Info(Module, "Texture "..tostring(fileDataID).." has been found in game files.")
else
SAO:Warn(Module, "Texture "..tostring(fileDataID).." has *not* been found in game files.")
end
end
f:Hide()
end)
tex:SetTexture(fileDataID)
tex:SetSize(0,0)
end
function SAO_DB_LookForAllTextures(output)
SAO_DB_AddMarkedTextures(false)
SpellActivationOverlayDB.dev.existing={remaining=0,id={}}
local fileDataIDs={}
for retailTexture in pairs(mapping)do
table.insert(fileDataIDs,tonumber(retailTexture,10))
end
SpellActivationOverlayDB.dev.existing.remaining=#fileDataIDs
for _,fileDataID in ipairs(fileDataIDs)do
SAO_DB_LookForTexture(fileDataID,output,true)
end
if type(output)~='boolean' or output then
print("SAO_DB_DetectExistingMarkedTextures() "..WrapTextInColorCode("Pending ("..#fileDataIDs..")...", "FFFFFF00"))
end
end
