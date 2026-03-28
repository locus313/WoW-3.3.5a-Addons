local AddonName,SAO=...
local Module="hash"
local HashStringifierList={}
local HashStringifierMap={}
SAO.HashStringifier={
register=function(self,order,mask,key,toValue,fromValue,getHumanReadableKeyValue,optionIndexer)
local stringifier={
order=order,
mask=mask,
key=key,
toValue=toValue,
fromValue=fromValue,
getHumanReadableKeyValue=getHumanReadableKeyValue,
optionIndexer=optionIndexer,
}
self.__index=nil
setmetatable(stringifier,self)
self.__index=self
tinsert(HashStringifierList,stringifier)
table.sort(HashStringifierList,function(s1,s2) return s1.order < s2.order end)
HashStringifierMap[stringifier.key]=stringifier
end,
toKeyValue=function(self,hash)
if bit.band(hash.hash,self.mask)==0 then
return nil
end
local value=self.toValue(hash)
return self.key..'='..value
end,
fromKeyValue=function(self,hash,key,value)
if key~=self.key then
SAO:Error(Module, "Wrong stringifier called to convert key/value "..tostring(key).."="..tostring(value))
return false
end
return self.fromValue(hash,value)~=nil
end,
toHumanReadableString=function(self,hash)
if bit.band(hash.hash,self.mask)==0 then
return nil
end
return self.getHumanReadableKeyValue(hash)
end,
getOptionIndex=function(self,hash)
if bit.band(hash.hash,self.mask)==0 then
return 0
end
return self.optionIndexer(hash)
end,
}
SAO.Hash={
new=function(self,initialHash)
local hash={hash=initialHash or 0}
self.__index=nil
setmetatable(hash,self)
self.__index=self
return hash
end,
reset=function(self)
self.hash=0
end,
setMaskedHash=function(self,maskedHash,mask)
self.hash=bit.band(self.hash,bit.bnot(mask)) + maskedHash
end,
getMaskedHash=function(self,mask)
local maskedHash=bit.band(self.hash,mask)
if maskedHash==0 then
SAO:Debug(Module, "Cannot convert hash ("..tostring(self.hash)..") with mask "..tostring(mask))
return nil
end
return maskedHash
end,
toString=function(self)
local result=""
for _,stringifier in ipairs(HashStringifierList)do
local keyValue=stringifier:toKeyValue(self)
if keyValue then
if result=="" then
result=keyValue
else
result=result..";"..keyValue
end
end
end
return result
end,
fromString=function(self,str)
local hash=SAO.Hash:new()
for keyValue in str:gmatch("([^;]+)")do
local first,last=strfind(keyValue,'=')
if not first or not last then
SAO:Error(Module, "Wrong hash key/value "..tostring(keyValue))
return
end
local key,value=keyValue:sub(1,first-1),keyValue:sub(last+1)
local stringifier=HashStringifierMap[key]
if not stringifier then
SAO:Error(Module, "Unknown hash key "..tostring(key).." in key/value "..tostring(keyValue))
return
end
if not stringifier:fromKeyValue(hash,key,value)then
return
end
end
self.hash=hash.hash
end,
toHumanReadableString=function(self)
local answers={}
for _,stringifier in ipairs(HashStringifierList)do
local answer=stringifier:toHumanReadableString(self)
if answer then
tinsert(answers,answer)
end
end
if #answers > 0 then
return strjoin(", ",unpack(answers))
else
return nil
end
end,
toOptionIndex=function(self)
local prevIndex=0
for _,stringifier in ipairs(HashStringifierList)do
local index=stringifier:getOptionIndex(self)
if index~=0 then
if prevIndex~=0 then
return self:toString()
end
prevIndex=index
end
end
return prevIndex
end,
}
