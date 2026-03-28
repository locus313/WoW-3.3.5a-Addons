local AddonName,SAO=...
local Module="variable"
SAO.Variables={}
local function error(msg)
if SAO.Error then
SAO:Error(Module,msg)
else
print(WrapTextInColor("**SAO** -"..Module.."- "..msg,RED_FONT_COLOR))
end
end
local function check(var,member,expectedType)
if type(var)~='table' then
return
elseif type(expectedType)=='string' then
if not var[member] then
error("Variable does not define a "..tostring(member))
elseif type(var[member])~=expectedType then
error("Variable defines member "..tostring(member).." of type '"..type(var[member]).."' instead of '"..expectedType.."'")
end
else
for _,expType in ipairs(expectedType)do
if type(var[member])==expType then
return
end
end
error("Variable defines member "..tostring(member).." of type '"..type(var[member]).."' instead of '"..strjoin("' or '",unpack(expectedType)).."'")
end
end
local function getName(var)
return type(var)=='table' and type(var.hash)=='table' and tostring(var.hash.key) or "<unknown variable>"
end
SAO.Variable={
register=function(self,var)
SAO.TriggerNames[var.trigger.flag]=var.trigger.name
SAO.TriggerFlags[var.trigger.name]=var.trigger.flag
SAO.RegisteredBucketsByTrigger[var.trigger.flag]={}
SAO.TriggerManualChecks[var.trigger.flag]=var.bucket.fetchAndSet
SAO.Hash["has"..var.core]=function(hash) return bit.band(hash.hash,var.hash.mask)~=0 end
SAO.Hash["set"..var.core]=var.hash.setterFunc
SAO.Hash["get"..var.core]=var.hash.getterFunc
if var.hash.toAnyFunc then
SAO.Hash["toAny"..var.core]=var.hash.toAnyFunc
end
SAO.Bucket["set"..var.core]=function(bucket,value)
if bucket.currentState["current"..var.core]==value then
return
end
local oldValue=bucket.currentState["current"..var.core]
bucket.currentState["current"..var.core]=value
bucket.trigger:inform(var.trigger.flag)
bucket.hashCalculator["set"..var.core](bucket.hashCalculator,value,bucket)
if bucket.onVariableChanged and bucket.onVariableChanged[var.core] then
bucket.onVariableChanged[var.core](bucket.hashCalculator,oldValue,value,bucket)
end
if bucket.trigger:isFullyInformed()then
bucket:applyHash()
end
end
if var.import and var.import.dependency and var.import.dependency.prepareBucket then
SAO.Bucket["import"..var.core]=function(bucket,value)
var.import.dependency.prepareBucket(bucket,value)
bucket.trigger:manualCheck(var.trigger.flag)
end
end
SAO.HashStringifier:register(
var.order,
var.hash.mask,
var.hash.key,
var.hash.toValue,
var.hash.fromValue,
var.hash.getHumanReadableKeyValue,
var.hash.optionIndexer
)
SAO.ConditionBuilder:register(
var.condition.noeVar,
var.condition.hreVar,
var.condition.noeDefault,
"set"..var.core,
var.condition.description,
var.condition.checker,
var.condition.noeToHash
)
if type(var.event.isRequired)=='function' and var.event.isRequired()
or type(var.event.isRequired)=='boolean' and var.event.isRequired then
for _,eventName in ipairs(var.event.names or {})do
if var.event[eventName] then
if SAO.VariableEventProxy[eventName] then
tinsert(SAO.VariableEventProxy[eventName],var)
else
SAO.VariableEventProxy[eventName]={var}
end
end
end
end
SAO.VariableImporter[var.trigger.flag]=function(effect,props,class)
local ignoreClasses=var.import.classes and var.import.classes.ignore and var.import.classes.ignore
local forceClasses=var.import.classes and var.import.classes.force and var.import.classes.force
if type(ignoreClasses)=='string' and ignoreClasses==class
or type(ignoreClasses)=='table' and tContains(ignoreClasses,class)then
return
end
local triggerName=var.import.noeTrigger
if type(forceClasses)=='string' and forceClasses==class
or type(forceClasses)=='table' and tContains(forceClasses,class)then
effect.triggers[triggerName]=true
elseif type(props)~='table' then
effect.triggers[triggerName]=false
else
local propName=var.import.hreTrigger
if type(props[propName])=='boolean' then
effect.triggers[triggerName]=props[propName]
elseif type(props[propName])=='table' then
for project,prop in pairs(props[propName])do
if SAO.IsProject(project)then
effect.triggers[triggerName]=prop
break
end
end
else
effect.triggers[triggerName]=false
end
end
if not effect.triggers[triggerName] and var.trigger.name~="talent" then
return
end
local dependency=var.import.dependency
if dependency then
local depName,depType,depDefault=dependency.name,dependency.expectedType,dependency.default
if type(props)=='table' and type(props[depName])==depType then
effect[depName]=props[depName]
elseif type(props)=='table' and type(props[depName])=='table' then
for project,talent in pairs(props[depName])do
if SAO.IsProject(project)then
effect[depName]=talent
break
end
end
elseif type(props)~='table' or props[depName]==nil then
if type(depDefault)=='function' then
effect[depName]=depDefault(effect)
else
effect[depName]=depDefault
end
end
if effect[depName]==nil and depDefault~=nil then
SAO:Debug(Module, "Missing dependency "..tostring(depName).." for effect "..tostring(effect.name))
elseif type(effect[depName])~=depType and type(depDefault)==depType then
SAO:Debug(Module, "Wrong type for dependency "..tostring(depName).." of effect "..tostring(effect.name))
end
end
end
self.__index=nil
setmetatable(var,self)
self.__index=self
SAO.Variables[var.trigger.flag]=var
end
}
SAO.VariableState={
new=function(self,parent)
local state={parent=parent}
self.__index=nil
setmetatable(state,self)
self.__index=self
return state
end,
reset=function(self)
for _,var in pairs(SAO.Variables)do
if self.parent.trigger:reactsWith(var.trigger.flag)then
self["current"..var.core]=var.bucket.impossibleValue
end
end
end,
}
SAO.VariableImporter={
importTrigger=function(self,flag,effect,props,class)
if self[flag] then
self[flag](effect,props,class)
end
end,
}
SAO.VariableEventProxy={}
