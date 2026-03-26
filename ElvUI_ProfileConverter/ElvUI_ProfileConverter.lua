local _G = _G
local _, ns = ...

local LibBase64 = LibStub("LibBase64-1.0-ElvUI")
local LibDeflate = LibStub("LibDeflate")
local LibCompress = LibStub("LibCompress")
local ElvUIPlugin = LibStub("LibElvUIPlugin-1.0")

ns = LibStub("AceAddon-3.0"):NewAddon("ElvUI Profile Converter")

function ns:Convert(dataString)
   if strfind(dataString, '!E1!') then
      return "Error: Input already uses a new format."
   end
   if not LibBase64:IsBase64(dataString) then
      return "Error: Input doesn't look like a correct profile."
   end

   local decodedData = LibBase64:Decode(dataString)
   local decompressedData, decompressedMessage = LibCompress:Decompress(decodedData)

   if not decompressedData then
      return format("Error decompressing data: %s.", decompressedMessage)
   end

   local compressedData = LibDeflate:CompressDeflate(decompressedData, {level = 5})
   local profileExport = LibDeflate:EncodeForPrint(compressedData)

   return "!E1!"..profileExport
end

function ns:OnInitialize()
   ns.status = ""

   local optionsTable = {
      type = "group",
      name = "Profile Converter",
      order = 66,
      args = {
        convert = {
          name = "Paste the old profile into the editbox below:",
          type = "input",
          width = "full",
          multiline = 40,
          set = function(_, val) ns.status = ns:Convert(val) end,
          get = function(_) return ns.status end
        }
      }
    }

    ElvUIPlugin:RegisterPlugin("ElvUI_ProfileConverter", function()
      _G.ElvUI[1].Options.args.profileconverter = optionsTable
   end)
end
