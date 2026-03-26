local _G = _G
local _, ns = ...

local LibBase64 = LibStub("LibBase64-1.0-ElvUI")
local LibDeflate = LibStub("LibDeflate")
local LibCompress = LibStub("LibCompress")
local ElvUIPlugin = LibStub("LibElvUIPlugin-1.0")

ns = LibStub("AceAddon-3.0"):NewAddon("ElvUI Profile Converter")

function ns:Convert(dataString)
   if LibBase64:IsBase64(dataString) then
      return "Error: Input already uses an old format."
   end
   if not strfind(dataString, '!E1!') then
      return "Error: Input doesn't look like a correct profile."
   end

   local data = gsub(dataString, '^'..'!E1!', '')
   local decodedData = LibDeflate:DecodeForPrint(data)
   local decompressed = LibDeflate:DecompressDeflate(decodedData)

   if not decompressed then
      return format("Error decompressing data: %s.")
   end

   local compressedData = LibCompress:Compress(decompressed)
   local profileExport = LibBase64:Encode(compressedData)

   return profileExport
end

function ns:OnInitialize()
   ns.status = ""

   local optionsTable = {
      type = "group",
      name = "Profile Converter",
      order = 66,
      args = {
        convert = {
          name = "Paste the wago profile into the editbox below:",
          type = "input",
          width = "full",
          multiline = 38,
          set = function(_, val) ns.status = ns:Convert(val) end,
          get = function(_) return ns.status end
        }
      }
    }

    ElvUIPlugin:RegisterPlugin("ElvUI_ProfileConverter", function()
      _G.ElvUI[1].Options.args.profileconverter = optionsTable
   end)
end
