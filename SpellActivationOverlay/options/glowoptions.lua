local AddonName,SAO=...
local Module="option"
function SAO.AddGlowingOption(self,talentID,spellID,glowID,talentSubText,spellSubText,variants,hash,alwaysHideTalentText)
local talentText=talentID and self:GetTalentText(talentID)
if (talentID and not talentText) or (not self:IsFakeSpell(glowID) and not self:DoesSpellExist(glowID))then
if talentID and not talentText then
SAO:Debug(Module, "Skipping glowing option of talentID "..tostring(talentID).." because the spell does not exist")
end
if not self:IsFakeSpell(glowID) and not self:DoesSpellExist(glowID)then
SAO:Debug(Module, "Skipping glowing option of glowID "..tostring(glowID).." because the spell does not exist (and is not a fake spell)")
end
return
end
local className=self.CurrentClass.Intrinsics[1]
local classFile=self.CurrentClass.Intrinsics[2]
local applyTextFunc=function(self)
local retryApplyText
local enabled=self:IsEnabled()
local text=""
if talentID and talentID~=glowID and not alwaysHideTalentText then
text=text.." "..talentText
if type(talentSubText)=='function' then
local evalTalentSubText=talentSubText()
if type(evalTalentSubText)=='string' then
text=text.." ("..evalTalentSubText..")"
else
retryApplyText=evalTalentSubText
end
elseif type(talentSubText)=='string' then
text=text.." ("..talentSubText..")"
end
text=text.." +"
elseif talentID and talentID==glowID and talentSubText and not alwaysHideTalentText then
SAO:Debug(Module, "Glowing option of glowID "..tostring(glowID).." has talent sub-text '"..talentSubText.."' but the text will be discarded because talentID matches glowID")
end
local spellIconAndText=SAO:GetSpellIconAndText(glowID)
text=text.." "..spellIconAndText
if spellSubText then
text=text.." ("..spellSubText..")"
end
if type(hash)=='string' then
local hashCalculator=SAO.Hash:new()
hashCalculator:fromString(hash)
local humanReadableHash=hashCalculator:toHumanReadableString()
if humanReadableHash then
text=text .. " ("..humanReadableHash..")"
end
end
self.Text:SetText(text)
if (enabled)then
self.Text:SetTextColor(1,1,1)
else
self.Text:SetTextColor(0.5,0.5,0.5)
end
return retryApplyText
end
local testFunc=function(start)
local fakeOffset=42000000
if (start)then
self:AddGlow(fakeOffset+spellID,{SAO:GetSpellName(glowID)})
else
self:RemoveGlow(fakeOffset+spellID)
end
end
self:AddOption("glow",spellID,glowID,type(variants)=='table' and variants.values,applyTextFunc,testFunc,{frame=SpellActivationOverlayOptionsPanelGlowingButtons,xOffset=16,yOffset=2})
end
function SAO.AddGlowingLink(self,srcOption,dstOption)
return self:AddOptionLink("glow",srcOption,dstOption)
end
function SAO.GetGlowingOptions(self,spellID)
return self:GetOptions("glow",spellID)
end
