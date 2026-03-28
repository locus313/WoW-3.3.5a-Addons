local AddonName,SAO=...
local Module="effect"
local registeredEffects={}
local registeredEffectsByName={}
local pendingEffects={}
local AKAs={}
local hasPlayerLoggedIn=false
local function doesUseName(useNameProp)
if useNameProp==nil then
return SAO.IsProject(SAO.CATA_AND_ONWARD)==false
else
return useNameProp==true
end
end
local function copyOption(option)
if type(option)=='table' then
local optionCopy={}
for k,v in pairs(option)do
optionCopy[k]=v
end
return optionCopy
else
return option
end
end
local function mergeOption(option1,option2)
if option2==nil then -- nil means "unspecified"
return copyOption(option1)
end
if option2==false then -- false means "no options,please"
return false
end
if option2==true then -- true means "I specify that yes I want an option,but not specifying which params exactly"
if type(option1)=='table' then
return copyOption(option1)
end
return true
end
if type(option2)~='table' then
SAO:Error(Module, "Merging options with invalid values "..tostring(option1).." vs. "..tostring(option2))
return copyOption(option2)
end
if type(option1)~='table' then
return copyOption(option2)
end
local combined={}
for k,v in pairs(option1)do
combined[k]=v
end
for k,v in pairs(option2)do
combined[k]=v
end
return combined
end
local function getValueOrDefault(value,default)
if value~=nil then
return value
else
return default
end
end
local ConditionBuilders={}
SAO.ConditionBuilder={
register=function(self,nativeVar,humanReadableVar,defaultValue,hashSetter,description,checker,nativeToHash)
local builder={
nativeVar=nativeVar,
humanReadableVar=humanReadableVar,
hashSetter=hashSetter,
defaultValue=defaultValue,
description=description,
checker=checker,
nativeToHash=nativeToHash,
}
self.__index=nil
setmetatable(builder,self)
self.__index=self
ConditionBuilders[nativeVar]=builder
end,
getHumanReadableValue=function(self,config,default)
local value=config[self.humanReadableVar]
if value==nil then
value=default[self.humanReadableVar]
end
if type(value)~='nil' and not self.checker(value)then
SAO:Error(Module, "Building condition with invalid "..self.description.." "..tostring(value))
end
return value
end,
getNativeValue=function(self,object)
local value=object[self.nativeVar]
if value==nil then
value=self.defaultValue
end
if type(value)~='nil' and not self.checker(value)then
SAO:Error(Module, "Using invalid "..self.description.." "..tostring(value))
end
return value
end,
setHashValue=function(self,hash,value)
hash[self.hashSetter](hash,self.nativeToHash(value))
end,
}
local function getCondition(config,default,triggers)
local condition={}
for _,builder in pairs(ConditionBuilders)do
if triggers[builder.nativeVar] then
local value=builder:getHumanReadableValue(config,default)
condition[builder.nativeVar]=value
end
end
return condition
end
local function getHash(condition,triggers)
local hash=SAO.Hash:new()
for trigger,enabled in pairs(triggers)do
if enabled then
local builder=ConditionBuilders[trigger]
local value=builder:getNativeValue(condition or {})
builder:setHashValue(hash,value)
end
end
return hash
end
local function addOneOverlay(overlays,overlayConfig,project,default,triggers)
local condition=getCondition(overlayConfig,default,triggers)
local texture=overlayConfig.texture or default.texture
if type(texture)~='string' then
SAO:Error(Module, "Adding Overlay with invalid texture "..tostring(texture))
end
local position=overlayConfig.position or default.position
if type(position)~='string' then
SAO:Error(Module, "Adding Overlay with invalid position "..tostring(position))
end
local option=overlayConfig.option
if option==nil then option=default.option; end
if option~=nil and type(option)~='boolean' and type(option)~='table' then
SAO:Error(Module, "Adding Overlay with invalid option "..tostring(option))
end
local color=overlayConfig.color or default.color
local overlay={
project=project,
condition=condition,
hash=getHash(condition,triggers).hash,
texture=texture,
position=position,
level=overlayConfig.level or default.level,
scale=overlayConfig.scale or default.scale,
color=color and {color[1],color[2],color[3]} or nil,
pulse=getValueOrDefault(overlayConfig.pulse,default.pulse),
option=mergeOption(default.option,overlayConfig.option),
}
table.insert(overlays,overlay)
end
local function addOneButton(buttons,buttonConfig,project,default,triggers)
local condition
if type(buttonConfig)=='table' then
local spellID=buttonConfig.spellID or default.spellID
if spellID~=nil and type(spellID)~='number' then
SAO:Error(Module, "Adding Button with invalid spellID "..tostring(spellID))
end
local option=buttonConfig.option
if option==nil then option=default.option; end
if option~=nil and type(option)~='boolean' and type(option)~='table' then
SAO:Error(Module, "Adding Button with invalid option "..tostring(option))
end
condition=getCondition(buttonConfig,default,triggers)
else
condition=getCondition({},default,triggers)
end
local button={
project=project,
condition=condition,
hash=getHash(condition,triggers).hash,
}
if type(buttonConfig)=='number' then
button.spellID=buttonConfig
button.useName=default.useName
button.option=copyOption(default.option)
elseif type(buttonConfig)=='table' then
button.spellID=buttonConfig.spellID or default.spellID
button.useName=getValueOrDefault(buttonConfig.useName,default.useName)
button.option=mergeOption(default.option,buttonConfig.option)
else
SAO:Error(Module, "Adding Button with invalid value "..tostring(buttonConfig))
end
table.insert(buttons,button)
end
local function addOneHandler(handlers,handlerConfig,project,default,triggers)
local handler={
project=project,
onRegister=handlerConfig.onRegister or default.onRegister,
onRepeat=handlerConfig.onRepeat or default.onRepeat,
onAboutToApplyHash=handlerConfig.onAboutToApplyHash or default.onAboutToApplyHash,
onVariableChanged=handlerConfig.onVariableChanged or default.onVariableChanged,
}
table.insert(handlers,handler)
end
local function importListOf(effect,props,keyOne,keyMany,addOneFunc)
if type(props)~='table' then
return
end
local addOneWithChecks=function(items,itemConfig,project,default,triggers)
project=type(itemConfig)=='table' and itemConfig.project or project
if type(project)=='number' and not SAO.IsProject(project)then
return
end
if not default then
default={}
end
addOneFunc(items,itemConfig,project,default,triggers)
end
effect[keyMany]={}
if props[keyOne] then
addOneWithChecks(effect[keyMany],props[keyOne],nil,nil,effect.triggers)
end
local default=props[keyMany] and props[keyMany].default or nil
for key,config in pairs(props[keyMany] or {})do
if key~="default" then
if type(key)=='number' and key >=SAO.ERA then
if type(config)=='table' and config[1] then
for _,subConfig in ipairs(config)do
addOneWithChecks(effect[keyMany],subConfig,key,config.default or default,effect.triggers)
end
else
addOneWithChecks(effect[keyMany],config,key,default,effect.triggers)
end
else
addOneWithChecks(effect[keyMany],config,nil,default,effect.triggers)
end
end
end
end
local function importOverlays(effect,props)
importListOf(effect,props, "overlay", "overlays",addOneOverlay)
end
local function importButtons(effect,props)
importListOf(effect,props, "button", "buttons",addOneButton)
end
local function importHandlers(effect,props)
importListOf(effect,props, "handler", "handlers",addOneHandler)
end
local function importCounterButton(effect,props)
local condition=getCondition({actionUsable=true},props,effect.triggers)
local hash=getHash(condition,effect.triggers).hash
local button={
condition=condition,
hash=hash,
}
if type(props)=='table' then
button.useName=doesUseName(props.useName)
button.option=copyOption(props.buttonOption)
else
button.useName=doesUseName()
end
effect.buttons={button}
end
local function createGeneric(effect,props)
if type(props)~='table' then
SAO:Error(Module, "Creating a generic effect for "..tostring(effect.name).." requires a 'props' table")
end
importOverlays(effect,props)
importButtons(effect,props)
importHandlers(effect,props)
return effect
end
local function createAura(effect,props)
if type(props)~='table' then
SAO:Error(Module, "Creating an aura for "..tostring(effect.name).." requires a 'props' table")
end
importOverlays(effect,props)
importButtons(effect,props)
importHandlers(effect,props)
return effect
end
local function createCounter(effect,props)
importOverlays(effect,props)
importCounterButton(effect,props)
importHandlers(effect,props)
return effect
end
local function createExecute(effect,props)
if type(props)~='table' then
SAO:Error(Module, "Creating an execute effect for "..tostring(effect.name).." requires a 'props' table")
end
importOverlays(effect,props)
importButtons(effect,props)
importHandlers(effect,props)
return effect
end
local function createNativeSAO(effect,props)
if type(props)~='table' then
SAO:Error(Module, "Creating a native SAO effect for "..tostring(effect.name).." requires a 'props' table")
end
importOverlays(effect,props)
importButtons(effect,props)
importHandlers(effect,props)
return effect
end
local function addAKA(effectName,akaSpellID)
AKAs[akaSpellID]=effectName
end
local function RegisterNativeEffectNow(self,effect)
local bucket,created=self.BucketManager:getOrCreateBucket(effect.name,effect.spellID)
if not created then
self:Warn(Module, "Overwriting bucket "..bucket.description)
end
for name,enabled in pairs(effect.triggers)do
if enabled then
bucket.trigger:require(SAO.TriggerFlags[name])
end
end
bucket:reset()
for _,overlay in ipairs(effect.overlays or {})do
if not overlay.project or self.IsProject(overlay.project)then
local spellID=overlay.spellID or effect.spellID
local texture=overlay.texture
local position=overlay.position
local level=overlay.level
local scale=overlay.scale or 1
local color=overlay.color and {overlay.color[1],overlay.color[2],overlay.color[3]} or {255,255,255}
local autoPulse=type(overlay.pulse)=='function' and overlay.pulse or overlay.pulse~=false
local combatOnly=overlay.combatOnly==true or effect.combatOnly==true
local overlayPod={
stacks=nil,
spellID=spellID,
texture=SAO.TexName[texture],
position=position,
level=level,
scale=scale,
color=color,
autoPulse=autoPulse,
combatOnly=combatOnly,
}
local hash=self.Hash:new(overlay.hash)
self.BucketManager:addEffectOverlay(bucket,hash,overlayPod,combatOnly)
end
end
for _,button in ipairs(effect.buttons or {})do
if not button.project or self.IsProject(button.project)then
local spellID=button.spellID or effect.spellID
local useName=doesUseName(button.useName)
local combatOnly=effect.combatOnly==true
local spellToAdd
if useName then
local spellName=SAO:GetSpellName(spellID)
if not spellName then
self:Warn(Module, "Registering effect "..effect.name.." for button with unknown spellID "..tostring(spellID))
spellToAdd=spellID
end
spellToAdd=spellName
else
spellToAdd=spellID
end
self:RegisterGlowID(spellToAdd)
local hash=self.Hash:new(button.hash)
self.BucketManager:addEffectButton(bucket,hash,spellToAdd,combatOnly)
end
end
for _,var in pairs(SAO.Variables)do
local triggerName=var.trigger.name
local dependencyName=var.import.dependency and var.import.dependency.name
if effect[dependencyName] and effect.triggers[triggerName] then
var.import.dependency.prepareBucket(bucket,effect[dependencyName])
end
end
for _,handler in ipairs(effect.handlers or {})do
if type(handler)~='table' then
self:Warn(Module, "Registering handler of wrong type "..type(handler).." for effect "..tostring(effect.name))
elseif not handler.project or self.IsProject(handler.project)then
if type(handler.onRegister)=='function' then
handler.onRegister(bucket)
end
if type(handler.onRepeat)=='function' then
C_Timer.NewTicker(1,function()
handler.onRepeat(bucket)
end)
end
if type(handler.onAboutToApplyHash)=='function' then
bucket.onAboutToApplyHash=handler.onAboutToApplyHash
end
if type(handler.onVariableChanged)=='table' then
bucket.onVariableChanged=bucket.onVariableChanged or {}
for varName,func in pairs(handler.onVariableChanged)do
bucket.onVariableChanged[varName]=func
end
end
end
end
table.insert(registeredEffects,effect)
if registeredEffectsByName[effect.name] then
self:Warn(Module, "Registering multiple effects with same name "..tostring(effect.name))
end
registeredEffectsByName[effect.name]=effect
end
function SAO:RegisterNativeEffect(effect)
for _,akaSpellID in ipairs(effect.aka or {})do
addAKA(effect.name,akaSpellID)
end
if not self.IsProject(effect.project)then
return
end
if hasPlayerLoggedIn then
RegisterNativeEffectNow(self,effect)
local bucket=self:GetBucketByName(effect.name)
if bucket then
bucket.trigger:manualCheckAll()
end
else
table.insert(pendingEffects,effect)
end
end
function SAO:RegisterPendingEffectsAfterPlayerLoggedIn()
if hasPlayerLoggedIn then
SAO:Debug(Module, "Received PLAYER_LOGIN twice in the same session")
end
hasPlayerLoggedIn=true
for _,effect in ipairs(pendingEffects)do
RegisterNativeEffectNow(self,effect)
end
pendingEffects={}
end
function SAO:AreEffectsInitialized()
return hasPlayerLoggedIn
end
function SAO:AddEffectOptions()
for _,effect in ipairs(registeredEffects)do
local talent=effect.talent
local skipOptions=effect.minor==true
for _,overlay in ipairs((not skipOptions) and effect.overlays or {})do
if overlay.option~=false and (not overlay.project or self.IsProject(overlay.project))then
local buff=overlay.spellID or effect.spellID
if type(overlay.option)=='table' then
local setupHash=type(overlay.option.setupHash)=='string' and overlay.option.setupHash or self:HashNameFromHashNumber(overlay.hash)
local testHash=type(overlay.option.testHash)=='string' and overlay.option.testHash or setupHash
local subText=overlay.option.subText
local variants=overlay.option.variants
if type(subText)=='function' then
subText=subText()
end
if type(variants)=='function' then
variants=variants()
end
self:AddOverlayOption(talent,buff,setupHash,subText,variants,testHash)
else
local setupHash=self:HashNameFromHashNumber(overlay.hash)
self:AddOverlayOption(talent,buff,setupHash)
end
end
end
for _,button in ipairs((not skipOptions) and effect.buttons or {})do
if button.option~=false and (not button.project or self.IsProject(button.project))then
local buff=effect.spellID
local spellID=button.spellID or effect.spellID
if type(button.option)=='table' then
local talentSubText=button.option.talentSubText
local spellSubText=button.option.spellSubText
local variants=button.option.variants
local hashName=self.Hash:new(button.hash):toString()
local alwaysHideTalentText=button.option.hideTalentText
if type(talentSubText)=='function' then
talentSubText=talentSubText()
end
if type(spellSubText)=='function' then
spellSubText=spellSubText()
end
if type(variants)=='function' then
variants=variants()
end
self:AddGlowingOption(talent,buff,spellID,talentSubText,spellSubText,variants,hashName,alwaysHideTalentText)
else
local hashName=self.Hash:new(button.hash):toString()
self:AddGlowingOption(talent,buff,spellID,nil,nil,nil,hashName,nil)
end
end
end
end
end
local EffectClassConstructors={
["generic"]=createGeneric,
["aura"]=createAura,
["counter"]=createCounter,
["execute"]=createExecute,
["native"]=createNativeSAO,
}
function SAO:CreateEffect(name,project,spellID,class,props,register)
if not self.IsProject(project)then
return
end
if type(spellID)=='table' then
for spellProject,projectedSpellID in pairs(spellID)do
if type(spellProject)~='number' or spellProject < SAO.ERA or type(projectedSpellID)~='number' or projectedSpellID <=0 then
self:Error(Module, "Creating effect "..name.." with invalid spellProject "..tostring(spellProject).." or spellID "..tostring(projectedSpellID).." or both")
return nil
end
if self.IsProject(spellProject)then
spellID=projectedSpellID
break
end
end
end
local aka={}
if props and props.aka~=nil then
if type(props.aka)=='number' then
tinsert(aka,props.aka)
else
for key,akaSpellID in pairs(props.aka)do
if type(key)~='number' then
self:Error(Module, "Creating effect "..name.." with invalid a.k.a. key "..tostring(key))
return nil
elseif key < SAO.ERA then
tinsert(aka,akaSpellID)
elseif self.IsProject(key)then
if type(akaSpellID)=='number' then
tinsert(aka,akaSpellID)
elseif type(akaSpellID)=='table' then
for _,akaSpellIDSpellID in ipairs(akaSpellID)do
if type(akaSpellIDSpellID)~='number' then
self:Error(Module, "Creating effect "..name.." with invalid a.k.a. spellID "..tostring(akaSpellIDSpellID))
return nil
end
tinsert(aka,akaSpellIDSpellID)
end
else
self:Error(Module, "Creating effect "..name.." with invalid a.k.a. spellID "..tostring(akaSpellID))
return nil
end
end
end
end
end
local effect={
name=name,
project=project,
spellID=spellID,
aka=aka,
combatOnly=type(props)=='table' and props.combatOnly,
minor=type(props)=='table' and props.minor,
triggers={},
}
for _,var in pairs(SAO.Variables)do
SAO.VariableImporter:importTrigger(var.trigger.flag,effect,props,class)
end
local effectConstructor=EffectClassConstructors[class]
if type(effectConstructor)=='function' then
effectConstructor(effect,props)
else
self:Error(Module, "Creating effect "..name.." with unknown class '"..tostring(class).."'")
return nil
end
if (not effect.overlays or #effect.overlays==0) and (not effect.buttons or #effect.buttons==0)then
self:Warn(Module, "Creating effect "..name.." with no overlays and no buttons")
end
if register==nil or register==true then
self:RegisterNativeEffect(effect)
end
return effect
end
function SAO:CreateLinkedEffects(name,project,spellIDs,class,props,register)
if not self.IsProject(project)then
return nil
end
local wasMinor
local minorProps
if type(props)=='table' then
wasMinor=props.minor
minorProps=props
if type(wasMinor)=='boolean' then
self:Error(Module, "Effect link group "..tostring(name).." uses a minor flag; it will be overriden")
end
else
minorProps={}
end
local lastSpell=spellIDs[#spellIDs]
minorProps.minor=false
local lastEffect=self:CreateEffect(name.."_link_max",project,lastSpell,class,minorProps,false)
if not lastEffect then
self:Error(Module, "Failed to create main effect for an effect link group of "..tostring(name))
minorProps.minor=wasMinor
return nil
end
minorProps.minor=true
local hasOverlay=type(props)=='table' and (props.overlay or props.overlays)
local hasButton=type(props)=='table' and (props.button or props.buttons)
local effects={}
for i,spell in ipairs(spellIDs)do
if spell~=lastSpell then
if hasOverlay then
self:AddOverlayLink(lastSpell,spell)
end
if hasButton then
self:AddGlowingLink(lastSpell,spell)
end
local effect=self:CreateEffect(name.."_link_"..i,project,spell,class,minorProps,false)
if effect then
table.insert(effects,effect)
end
end
end
table.insert(effects,lastEffect)
if register==nil or register==true then
for _,effect in ipairs(effects)do
self:RegisterNativeEffect(effect)
end
end
minorProps.minor=wasMinor
return effects
end
function SAO:IsAka(spellID)
return AKAs[spellID]~=nil
end
