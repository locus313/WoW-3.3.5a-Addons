local AddonName,SAO=...
local Module="aura"
local function promoteAura(aura)
aura.name=aura[1]
aura.stacks=aura[2]
aura.spellID=aura[3]
if aura[4] then
aura.overlay={
spellID=aura[3],
texture=aura[4],
position=aura[5],
scale=aura[6],
color={aura[7],aura[8],aura[9]},
autoPulse=aura[10],
combatOnly=aura[13],
}
end
if aura[11] then
aura.buttons=aura[11]
end
aura.combatOnly=aura[13]
end
function SAO.RegisterAura(self,name,stacks,spellID,texture,positions,scale,r,g,b,autoPulse,glowIDs,combatOnly)
if (type(texture)=='string')then
texture=self.TexName[texture]
end
local aura={name,stacks,spellID,texture,positions,scale,r,g,b,autoPulse,glowIDs,nil,combatOnly}
promoteAura(aura)
if (type(texture)=='string')then
self:MarkTexture(texture)
end
self:RegisterGlowIDs(glowIDs)
SAO.BucketManager:addAura(aura)
end
