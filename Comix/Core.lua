local Comix = LibStub("AceAddon-3.0"):NewAddon("Comix", "AceEvent-3.0", "AceHook-3.0")
_G.Comix = Comix
Comix.callbacks = Comix.callbacks or LibStub("CallbackHandler-1.0"):New(Comix)

local L = LibStub("AceLocale-3.0"):GetLocale("Comix")
local ACD = LibStub("AceConfigDialog-3.0")
local random = math.random
local format = string.format
local ChatFrame = DEFAULT_CHAT_FRAME
local _
local lastZoneTime

function Comix:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ComixDB", self.defaults, "Default")

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Comix", self.options)
	self.optionsFrame = ACD:AddToBlizOptions("Comix", "Comix")
	ACD:SetDefaultSize("Comix", 415, 600)
end

do
	local lower, trim = string.lower, string.trim
	local SendChatMessage = SendChatMessage

	local cmds = {"say", "emote", "yell", "party", "guild", "officer", "raid", "rw", "bg", "afk", "dnd"}
	local function MessageSender(msg, link)
		local cmd, txt = msg:match("^(%S*)%s*(.-)$")
		local lang = GetDefaultLanguage("player")
		txt = gsub(txt, "~~", link)

		if tContains(cmds, cmd) then
			if cmd == "bg" then
				cmd = "battleground"
			elseif cmd == "rw" then
				cmd = "raid_warning"
			end
			SendChatMessage(txt, cmd:upper())
		elseif (tonumber(cmd) or 0) > 0 and tonumber(cmd) < 100 then
			SendChatMessage(txt, "CHANNEL", lang, cmd)
		end
	end

	local function Commad_Comix(cmd)
		cmd = trim(lower(cmd))
		if cmd == "create" then
			Comix:Print("Me Creates: Hello World")
			Comix:DongSound(Comix.Sounds.Special, random(1, Comix.SoundSpecialCt))
		elseif cmd == "hide" then
			Comix:Hide()
		elseif cmd == "pic" or cmd == "image" then
			Comix:CallPic(Comix.Images.Physical[random(1, Comix.ImagePhysicalCt)])
		elseif cmd == "special" or cmd == "specialpic" then
			Comix:CallPic(Comix.Images.Special[random(1, Comix.ImageSpecialCt)])
		elseif cmd == "clearjump" then
			Comix.db.profile.jumpCount = 0
			Comix:Print(L["Jump counter reset."])
		elseif cmd == "showjump" then
			Comix:Printf("[Jump Report]: %s", format(L["%s has jumped %d times."], Comix.userName, Comix.db.profile.jumpCount))
		elseif cmd == "reportjump" then
			SendChatMessage(format("[Comix] %s", format(L["%s has jumped %d times."], Comix.userName, Comix.db.profile.jumpCount)), "SAY")
		elseif cmd == "clearhug" then
			Comix.db.profile.hugCount = 0
			Comix:Print(L["Hug counter reset."])
		elseif cmd == "showhug" then
			Comix:Printf("[Hug Report]: %s", format(L["%s has hugged %d times."], Comix.userName, Comix.db.profile.hugCount))
		elseif cmd == "reporthug" then
			SendChatMessage(format("[Comix] %s", format(L["%s has hugged %d times."], Comix.userName, Comix.db.profile.hugCount)), "SAY")
		elseif cmd == "shake" then
			Comix:Shake(true)
		elseif cmd == "about" then
			Comix:Print("Author: \124cfff58cbaKader\124r (\124cff808080bkader#5341\124r)\nEmail: \124cff20ff20bkader@mail.com\124r\nWebsite: \124cff20ff20https://github.com/waddons/Comix-WotLK\124r")
		elseif cmd == "debug" then
			Comix.db.profile.debug = not Comix.db.profile.debug
		elseif cmd == "help" then
			Comix:Print("Usage:")
			print("\124cffffaeae/comix\124r \124cffffff33about\124r / \124cffffff33help\124r")
			print("\124cffffaeae/comix\124r \124cffffff33create\124r / \124cffffff33hide\124r")
			print("\124cffffaeae/comix\124r \124cffffff33pic\124r / \124cffffff33special\124r")
			print("\124cffffaeae/comix\124r \124cffffff33clearjump\124r / \124cffffff33showjump\124r / \124cffffff33reportjump\124r")
			print("\124cffffaeae/comix\124r \124cffffff33clearhug\124r / \124cffffff33showhug\124r / \124cffffff33reporthug\124r")
		else
			ACD:Open("Comix")
		end
	end

	local function Command_BadJoke()
		if UnitIsPlayer("target") and not UnitIsUnit("target", "player") then
			SendChatMessage(format(L["facepalms at %s's bad joke."], UnitName("target")), "EMOTE")
		else
			SendChatMessage(L["senses a bad joke."], "EMOTE")
		end
	end

	local function Command_Fail(msg)
		MessageSender(msg, "\124cff71d5ff\124Hspell:65311\124h[Supermassive Fail]\124h\124r")
	end

	local function Command_Awesome(msg)
		MessageSender(msg, "\124cff71d5ff\124Hspell:58783\124h[Pure Awesome]\124h\124r")
	end

	local function Command_Drama()
		SendChatMessage(L["detects a hint of drama."], "EMOTE")
	end

	function Comix:OnEnable()
		self.currentFrame = 1

		self:CreateFrames()
		self:LoaddaShit()

		-- self:DongSound(self.Sounds.Zone, random(1, self.SoundZoneCt))

		SlashCmdList.COMIX = Commad_Comix
		SlashCmdList.COMIXJOKE = Command_BadJoke
		SlashCmdList.COMIXFAIL = Command_Fail
		SlashCmdList.COMIXAWESOME = Command_Awesome
		SlashCmdList.COMIXDRAMA = Command_Drama

		SLASH_COMIX1 = "/comix"
		SLASH_COMIXJOKE1 = "/badjoke"
		SLASH_COMIXFAIL1 = "/fail"
		SLASH_COMIXAWESOME1 = "/awesome"
		SLASH_COMIXDRAMA1 = "/drama"

		self:ApplySettings()
	end
end

function Comix:Print(msg, ...)
	if ... then
		ChatFrame:AddMessage(msg, ...)
	else
		print("\124cff33ff99Comix\124r:", msg)
	end
end

function Comix:Printf(msg, ...)
	self:Print(msg:format(...))
end

function Comix:Debug(msg, ...)
	if not self.db.profile.debug then
		return
	elseif ... then
		ChatFrame:AddMessage(msg, ...)
	else
		print("\124cff33ff99Comix Debug\124r:", msg)
	end
end

function Comix:CreateFrames()
	self.frames = {}
	self.textures = {}
	self.scales = {}
	self.visibleTime = {}
	self.status = {}

	for i = 1, 5 do
		local f = CreateFrame("Frame", "ComixFrame"..i, UIParent)
		f:SetSize(128, 128)
		f:Hide()
		self.frames[i] = f

		local t = f:CreateTexture("$parentTexture"..i, "BACKGROUND")
		self.textures[i] = t

		self.scales[i] = 0.2
		self.visibleTime[i] = 0
		self.status[i] = 0
	end
end

do
	function Comix:LoaddaShit()
		-- Counting Normal Images --
		self.ImagePhysicalCt = self.ImagePhysicalCt or #self.Images.Physical
		self:Debug("Me loaded " .. self.ImagePhysicalCt .. " piccus", 0.3, 0.3, 0.3)

		-- Counting Images in Image-Sets --
		self.ImageFireCt = self.ImageFireCt or #self.Images.Fire
		self:Debug("Me loaded " .. self.ImageFireCt .. " piccus", 0.3, 0.3, 1)

		self.ImageFrostCt = self.ImageFrostCt or #self.Images.Frost
		self:Debug("Me loaded " .. self.ImageFrostCt .. " piccus", 0.3, 1, 1)

		self.ImageFrostFireCt = self.ImageFrostFireCt or #self.Images.FrostFire
		self:Debug("Me loaded " .. self.ImageFrostFireCt .. " piccus", 0.3, 1, 1)

		self.ImageShadowCt = self.ImageShadowCt or #self.Images.Shadow
		self:Debug("Me loaded " .. self.ImageShadowCt .. " piccus", 0.3, 1, 0.3)

		self.ImageNatureCt = self.ImageNatureCt or #self.Images.Nature
		self:Debug("Me loaded " .. self.ImageNatureCt .. " piccus", 1, 1, 0.3)

		self.ImageArcaneCt = self.ImageArcaneCt or #self.Images.Arcane
		self:Debug("Me loaded " .. self.ImageArcaneCt .. " piccus", 1, 0.3, 0.3)

		self.ImageHolyHealCt = self.ImageHolyHealCt or #self.Images.HolyHeal
		self:Debug("Me loaded " .. self.ImageHolyHealCt .. " piccus", 0.5, 0.5, 0.5)

		self.ImageHolyDamageCt = self.ImageHolyDamageCt or #self.Images.HolyDamage
		self:Debug("Me loaded " .. self.ImageHolyDamageCt .. " piccus", 0.5, 0.5, 0.5)

		self.ImageDeathCt = self.ImageDeathCt or #self.Images.Death
		self:Debug("Me loaded " .. self.ImageDeathCt .. " piccus", 0.5, 0.5, 0.5)

		self.ImageOverkillCt = self.ImageOverkillCt or #self.Images.Overkill
		self:Debug("Me loaded " .. self.ImageOverkillCt .. " piccus", 0.5, 0.5, 0.5)

		self.ImageSpecialCt = self.ImageSpecialCt or #self.Images.Special
		self:Debug("Me loaded " .. self.ImageSpecialCt .. " piccus", 0.5, 0.5, 0.5)

		self.ImageMortalCombatCt = self.ImageMortalCombatCt or #self.Images.MortalCombat
		self:Debug("Me loaded " .. self.ImageMortalCombatCt .. " piccus", 0.5, 0.5, 0.5)

		-- Counting Normal Sounds --
		self.SoundCritCt = self.SoundCritCt or #self.Sounds.Crit
		self:Debug("Me loaded " .. self.SoundCritCt .. " sounds", 1, 0.3, 1)

		-- Counting Zone Sounds --
		self.SoundZoneCt = self.SoundZoneCt or #self.Sounds.Zone
		self:Debug("Me loaded " .. self.SoundZoneCt .. " sounds", 1, 1, 1)

		-- Counting One hit Sounds --
		self.SoundOneHitCt = self.SoundOneHitCt or #self.Sounds.OneHit
		self:Debug("Me loaded " .. self.SoundOneHitCt .. " sounds", 1, 1, 1)

		-- Counting Healing Sounds --
		self.SoundHealingCt = self.SoundHealingCt or #self.Sounds.Healing
		self:Debug("Me loaded " .. self.SoundHealingCt .. " sounds", 1, 1, 1)

		-- Counting Special Sounds --
		self.SoundSpecialCt = self.SoundSpecialCt or #self.Sounds.Special
		self:Debug("Me loaded " .. self.SoundSpecialCt .. " specials", 1, 0.3, 0.3)

		-- Counting Ability Sounds --
		self.SoundAbilityCt = self.SoundAbilityCt or #self.Sounds.Ability
		self:Debug("Me loaded " .. self.SoundAbilityCt .. " sounds", 1, 1, 1)

		-- Counting Death Sounds --
		self.SoundDeathCt = self.SoundDeathCt or #self.Sounds.Death
		self:Debug("Me loaded " .. self.SoundDeathCt .. " sounds", 1, 1, 1)

		-- Counting Ready check Sounds --
		self.SoundReadyCheckCt = self.SoundReadyCheckCt or #self.Sounds.ReadyCheck
		self:Debug("Me loaded " .. self.SoundReadyCheckCt .. " sounds", 1, 1, 1)

		-- Counting Res Sounds --
		self.SoundResCt = self.SoundResCt or #self.Sounds.Res
		self:Debug("Me loaded " .. self.SoundResCt .. " sounds", 1, 1, 1)

		-- Counting Objection Sounds --
		self.SoundObjectionCt = self.SoundObjectionCt or #self.Sounds.Objection
		self:Debug("Me loaded " .. self.SoundObjectionCt .. " sounds", 1, 1, 1)

		-- Counting KillCount Sounds --
		self.SoundKillCountCt = self.SoundKillCountCt or #self.Sounds.KillCount
		self:Debug("Me loaded " .. self.SoundKillCountCt .. " sounds", 1, 1, 1)

		-- NPC-specific sounds: keyed by exact English NPC name.
		-- Mr. Bigglesworth is Kel'Thuzad's cat in Naxxramas (Austin Powers reference).
		-- The Muffin Man is the food vendor in Shattrath City's Lower City.
		-- Update the names here if they differ on your realm.
		self.NPCSounds = {
			["Mr. Bigglesworth"] = self.Sounds.Special[5],  -- dr_evil.ogg
			["Muffin Man Moser"] = self.Sounds.Special[10], -- muffinman.ogg
		}

		self:Print("Open options GUI with \124cffffd700/comix\124r or get Slashcommands with \124cffffd700/comix help\124r.")
	end
end

do
	local PlaySoundFile = PlaySoundFile

	function Comix:DongSound(soundTable, sound)
		if not (self.db.profile.enabled and self.db.profile.sounds) then
			return
		end
		if soundTable == self.Sounds.Crit then
			if self.db.profile.bamSound then
				PlaySoundFile(self.Sounds.Special[13])
			else
				PlaySoundFile(self.Sounds.Crit[random(1, self.SoundCritCt)])
			end
		elseif soundTable == "customcomixsound" then
			PlaySoundFile(sound)
		elseif soundTable then
			PlaySoundFile(soundTable[sound])
		end
	end

	function Comix:CustomSound(filePath)
		self:DongSound("customcomixsound", filePath)
	end
end

function Comix:CallPic(image, name)
	if not (self.db.profile.enabled and self.db.profile.images) then return end

	self.xCoords = random(-120, 120)
	if self.xCoords <= 0 then
		self.xCoords = self.xCoords - 40
	else
		self.xCoords = self.xCoords + 40
	end

	if abs(self.yCoords or 0) < 75 then
		self.yCoords = random(50, 130)
	else
		self.yCoords = random(0, 150)
	end

	self:DongPic(self.xCoords, self.yCoords, image, name)
end

function Comix:CustomPic(filePath)
	self:CallPic(filePath, "customcomixpic")
end

do
	local SetPortraitTexture = SetPortraitTexture

	function Comix:DongPic(xCoords, yCoords, image, name)
		if self.db.profile.enabled then
			if self.frames[self.currentFrame]:IsVisible() then
				self.frames[self.currentFrame]:Hide()
			end

			self.status[self.currentFrame] = 0
			self.scales[self.currentFrame] = 0.2
			self.visibleTime[self.currentFrame] = 0

			if image == "portrait" then
				SetPortraitTexture(self.textures[self.currentFrame], name)
			else
				self.textures[self.currentFrame]:SetTexture(image)
			end
		end

		self.textures[self.currentFrame]:SetAllPoints(self.frames[self.currentFrame])

		self.frames[self.currentFrame]:ClearAllPoints()
		if image == "portrait" then
			self.frames[self.currentFrame]:SetPoint("CENTER", -150, -50)
		else
			self.frames[self.currentFrame]:SetPoint("CENTER", xCoords, yCoords)
		end
		self.frames[self.currentFrame]:Show()

		self.currentFrame = (self.currentFrame == 5) and 1 or (self.currentFrame + 1)
	end
end

-------------------------------------------------------------------------------

do
	local function jumpOrAscendStart()
		if not Comix.db.profile.enabled then return end
		if UnitOnTaxi("player") then return end

		if not IsFlying() and not IsSwimming() then
			Comix.db.profile.jumpCount = Comix.db.profile.jumpCount + 1
			if Comix.db.profile.bounceSound then
				Comix:DongSound(Comix.Sounds.Special, 8)
			end
		end
	end

	function Comix:ApplySettings()
		if not self.frame then
			self.frame = CreateFrame("Frame", "ComixFrame", WorldFrame)
			self.frame:SetAllPoints(WorldFrame)

			self.flashFrame = CreateFrame("Frame", "ComixFlashFrame", self.frame)
			self.flashFrame:SetAllPoints(self.frame)
			self.flashFrame.texture = self.flashFrame:CreateTexture("$parentTexture", "BACKGROUND")
			self.flashFrame.texture:SetTexture([[Interface\AddOns\Comix\Media\Images\flash1.tga]])
			self.flashFrame.texture:SetBlendMode("ADD")
			self.flashFrame.texture:Hide()
		end

		if not self.db.profile.enabled then
			self.frame:SetScript("OnUpdate", nil)
			self:UnregisterAllEvents()
			return
		end

		self.userGUID = UnitGUID("player")
		self.userName = UnitName("player")

		self.frame:SetScript("OnUpdate", self.Update)

		-- jump sound (hooked once; hooksecurefunc chains on each call)
		if not self.jumpHooked then
			hooksecurefunc("JumpOrAscendStart", jumpOrAscendStart)
			self.jumpHooked = true
		end

		self:ToggleEvent("READY_CHECK", "readySound")
		self:ToggleEvent("ZONE_CHANGED_NEW_AREA", "zoneSound", "specialSound")

		self:ToggleEvent("PLAYER_TARGET_CHANGED", "finish", "npcSound")
		self:ToggleEvent("UNIT_HEALTH", "finish")

		self:ToggleEvent("PLAYER_DEAD", "deathSound")
		self:ToggleEvent("RESURRECT_REQUEST", "resSound")

		self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")  -- objections, bad-joke/drama, hug counter

		self:ToggleEvent("UNIT_SPELLCAST_SENT", "demoSound", "abilitySound")

		self:ToggleEvent("COMBAT_LOG_EVENT_UNFILTERED", "critical", "overkill", "killCount", "battleSound", "critHeal")
	end
end

function Comix:ToggleEvent(event, ...)
	-- Register the event if ANY of the listed settings is enabled; unregister only when ALL are disabled.
	local shouldRegister = false
	for i = 1, select("#", ...) do
		if self.db.profile[select(i, ...)] == true then
			shouldRegister = true
			break
		end
	end
	if shouldRegister then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end

-------------------------------------------------------------------------------

function Comix:Hide()
	for i, f in ipairs(self.frames) do
		f:Hide()
		self:Print("Hiding Comix.frames[" .. i .. "]")
	end
end

local updateInterval, lastUpdate = 0.008, 0
function Comix:Update(elapsed)
	elapsed = elapsed or 0
	lastUpdate = lastUpdate + elapsed
	while lastUpdate > updateInterval do
		for i = 1, 5 do
			local frame = Comix.frames[i]
			if frame and frame:IsVisible() then
				if Comix.status[i] == 0 then
					Comix.scales[i] = Comix.scales[i] * 1.1 * Comix.db.profile.animSpeed
					if Comix.scales[i] >= Comix.db.profile.maxScale then
						Comix.scales[i] = Comix.db.profile.maxScale
						Comix.status[i] = 1
					end
					frame:SetScale(Comix.scales[i])
				elseif Comix.status[i] == 1 then
					Comix.scales[i] = Comix.db.profile.maxScale
					frame:SetScale(Comix.scales[i])
						Comix.visibleTime[i] = Comix.visibleTime[i] + 0.01
						if Comix.visibleTime[i] >= 0.15 then
							Comix.visibleTime[i] = 0
						Comix.status[i] = 2
					end
				elseif Comix.status[i] == 2 then
					Comix.visibleTime[i] = Comix.visibleTime[i] + 0.01
					if Comix.visibleTime[i] >= 1 then
						Comix.status[i] = 3
					end
				elseif Comix.status[i] == 3 then
					Comix.scales[i] = Comix.scales[i] * 0.5
					frame:SetScale(Comix.scales[i])
					if Comix.scales[i] <= 0.2 then
						frame:Hide()
						Comix.status[i] = 0
						Comix.scales[i] = 0.2
						Comix.visibleTime[i] = 0
					end
				end
			end
		end
		lastUpdate = lastUpdate - updateInterval
	end
end

-------------------------------------------------------------------------------

function Comix:Shake(force)
	if not (self.db.profile.enabled and (self.db.profile.shake or force)) then return end
	local shaker = self.ShakeFrame
	if not shaker then
		shaker = CreateFrame("Frame", "ComixShakeFrame", UIParent)
		shaker:Hide()
		shaker:SetScript("OnShow", function(self)
			self.elapsed = 0
			if not self.originalPoints then
				self.originalPoints = {}
				for i = 1, WorldFrame:GetNumPoints() do
					self.originalPoints[#self.originalPoints + 1] = {WorldFrame:GetPoint(i)}
				end
			end
		end)
		shaker:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed

			if elapsed >= Comix.db.profile.shakeDuration or (WorldFrame:IsProtected() and InCombatLockdown()) then
				-- Restore WorldFrame to its original position before hiding.
				WorldFrame:ClearAllPoints()
				for i = 1, #self.originalPoints do
					local v = self.originalPoints[i]
					WorldFrame:SetPoint(v[1], v[2], v[3], v[4], v[5])
				end
				self:Hide()
			else
				local denom = 101 - Comix.db.profile.shakeIntensity - (Comix.db.profile.shakeOffset - 1)
				if denom <= 0 then denom = 1 end
				local rand = random(-100, 100) / denom
				WorldFrame:ClearAllPoints()
				for i = 1, #self.originalPoints do
					local v = self.originalPoints[i]
					WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + rand, v[5] + rand)
				end
			end

			self.elapsed = elapsed
		end)

		self.ShakeFrame = shaker
	end

	shaker:Show()
end

function Comix:Flash(r, g, b, size)
	size = size or 1
	size = (size < 1) and 1 or (size > 2) and 2 or size
	self.flashFrame.texture:SetTexture("Interface\\Addons\\Comix\\Media\\Images\\flash" .. size .. ".tga")
	self.flashFrame.texture:SetVertexColor(r, g, b)
	UIFrameFlash(self.flashFrame.texture, 0.5, 0.5, 2, false, 1, 0)
end

-------------------------------------------------------------------------------

function Comix:KillCount()
	if self.db.profile.killCount then
		self.killCount = (self.killCount or 0) + 1

		if self.killCount == 2 then
			self:DongSound(self.Sounds.KillCount, 1)
		elseif self.killCount == 5 then
			self:DongSound(self.Sounds.KillCount, 2)
		elseif self.killCount == 8 then
			self:DongSound(self.Sounds.KillCount, 3)
		elseif self.killCount == 10 then
			self:DongSound(self.Sounds.KillCount, 4)
		elseif self.killCount == 15 then
			self:DongSound(self.Sounds.KillCount, 5)
		elseif self.killCount == 20 then
			self:DongSound(self.Sounds.KillCount, 6)
		elseif self.killCount == 30 then
			self:DongSound(self.Sounds.KillCount, 7)
		elseif self.killCount == 40 then
			self:DongSound(self.Sounds.KillCount, 8)
		elseif self.killCount == 50 then
			self:DongSound(self.Sounds.KillCount, 9)
		end
	end
end
-------------------------------------------------------------------------------

function Comix:READY_CHECK()
	if self.db.profile.enabled and self.db.profile.readySound then
		self:DongSound(self.Sounds.ReadyCheck, random(1, self.SoundReadyCheckCt))
	end
end

do
	local inInstance, instanceType
	function Comix:ZONE_CHANGED_NEW_AREA()
		inInstance, instanceType = IsInInstance()
		if inInstance then
			if instanceType == "party" or instanceType == "raid" then
				if self.db.profile.specialSound then
					self:Print("[Dr. Evil] yells: Ladies and Gentlemen, Welcome to my Underground Lair!", 1, 0, 0)
					self:DongSound(self.Sounds.Special, 16)
				elseif self.db.profile.zoneSound then
					self:DongSound(self.Sounds.Zone, random(1, self.SoundZoneCt))
				end
			elseif self.db.profile.zoneSound then
				self:DongSound(self.Sounds.Zone, random(1, self.SoundZoneCt))
			end
		elseif self.db.profile.zoneSound then
			if lastZoneTime == nil or GetTime() - lastZoneTime >= 30 then
				lastZoneTime = GetTime()
				self:DongSound(self.Sounds.Zone, random(1, self.SoundZoneCt))
			end
		end
	end
end

function Comix:PLAYER_TARGET_CHANGED()
	self.finishTarget = UnitExists("target")

	if self.db.profile.npcSound and UnitExists("target") and not UnitIsPlayer("target") then
		local npcSound = self.NPCSounds and self.NPCSounds[UnitName("target")]
		if npcSound then
			self:DongSound("customcomixsound", npcSound)
		end
	end
end

function Comix:UNIT_HEALTH(event, unit)
	if self.finishTarget and unit == "target" then
		local targetHealth, targetMaxHealth = UnitHealth("target"), UnitHealthMax("target")
		if targetHealth > 0 and not UnitIsFriend("player", "target") then
			local percent = 100 * targetHealth / targetMaxHealth
			if percent < self.db.profile.finishGap then
				self.finishTarget = false
				if self.db.profile.finishSound then
					self:DongSound(self.Sounds.Special, 12)
				end
			end
		end
	end
end

function Comix:PLAYER_DEAD()
	self:CallPic(self.Images.Death[random(1, self.ImageDeathCt)])
	self:DongSound(self.Sounds.Death, random(1, self.SoundDeathCt))
	self.killCount = 0
end

function Comix:RESURRECT_REQUEST()
	self:DongSound(self.Sounds.Res, random(1, self.SoundResCt))
end

do
	-- Resolve a sender's character name to a group unit token so that
	-- unit-token-only APIs (UnitInParty, UnitSex, SetPortraitTexture) work correctly.
	local function NameToUnitID(name)
		for i = 1, 4 do
			local u = "party" .. i
			if UnitName(u) == name then return u end
		end
		for i = 1, 40 do
			local u = "raid" .. i
			if UnitName(u) == name then return u end
		end
		return nil
	end

	-- Handles objection reactions, bad-joke/drama detections, and hug counting.
	-- Registered for CHAT_MSG_TEXT_EMOTE because SendChatMessage(text, "EMOTE")
	-- fires CHAT_MSG_TEXT_EMOTE, not CHAT_MSG_EMOTE.
	function Comix:CHAT_MSG_TEXT_EMOTE(event, msg, name)
		if not msg then return end
		local msgLower = msg:lower()

		-- Count hugs sent by the player (persisted lifetime counter).
		if name == self.userName and strfind(msgLower, "hug", 1, true) then
			self.db.profile.hugCount = self.db.profile.hugCount + 1
		end

		if strfind(msgLower, L["object"], 1, true) or strfind(msgLower, L["objects"], 1, true) then
			local unit = NameToUnitID(name)
			if unit and (UnitInParty(unit) or UnitInRaid(unit)) then
				if self.db.profile.objection and self.db.profile.objectionImage then
					self:CallPic("portrait", unit)  -- unit token required by SetPortraitTexture
					self:CallPic(self.Images.Special[5])
				end
				if self.db.profile.objection and self.db.profile.objectionSound then
					self:DongSound(self.Sounds.Objection, UnitSex(unit) == 3 and random(3, 4) or random(1, 2))
				end
			elseif self.db.profile.objection and self.db.profile.objectionPublic then
				-- Public objection: sender not in group, no portrait
				self:CallPic(self.Images.Special[5])
				self:DongSound(self.Sounds.Objection, random(1, self.SoundObjectionCt))
			end
		elseif self.db.profile.specialSound then
			-- Bad joke and drama reactions: detect messages sent by /badjoke and /drama commands.
			if strfind(msg, L["bad joke"], 1, true) then
				self:DongSound(self.Sounds.Special, 17)
			elseif strfind(msg, L["detects a hint of drama."], 1, true) then
				self:DongSound(self.Sounds.Special, 19)
			end
		end
	end
end

do
	local iceBlock = GetSpellInfo(45438)
	local cannibalize = GetSpellInfo(20577)
	local demoRoar = GetSpellInfo(48560)
	local runTable = {GetSpellInfo(11305), GetSpellInfo(33357), GetSpellInfo(5118)}
	local deathGrip = GetSpellInfo(49576)
	local metamorph = GetSpellInfo(47241)
	local runTable1 = {GetSpellInfo(1120), GetSpellInfo(8288), GetSpellInfo(8289), GetSpellInfo(11975), GetSpellInfo(27217), GetSpellInfo(47855)}

	function Comix:UNIT_SPELLCAST_SENT(event, unit, spellname)
		if unit ~= "player" then return end
		if not spellname then return end

		if self.db.profile.demoSound and (spellname == L["Demoralizing Shout"] or spellname == demoRoar) then
			self:CallPic(self.Images.Special[2])
			self:DongSound(self.Sounds.Special, random(2, 3))
		end

		if self.db.profile.abilitySound then
			if spellname == iceBlock then
				self:DongSound(self.Sounds.Ability, 2)
			elseif spellname == cannibalize then
				self:DongSound(self.Sounds.Ability, 1)
			elseif tContains(runTable, spellname) then
				self:DongSound(self.Sounds.Special, 11)
			elseif self.db.profile.demoSound and (spellname == L["Demoralizing Shout"] or spellname == demoRoar) then
				-- sound already played above; no-op here to avoid double sound
			elseif spellname == deathGrip then
				self:DongSound(self.Sounds.Special, random(20, 21))
			elseif tContains(runTable1, spellname) then
				self:DongSound(self.Sounds.Special, 22)
			elseif spellname == metamorph then
				self:DongSound(self.Sounds.Special, 23)
			end
		end
	end

	local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE or 0x00000001
	local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY or 0x00000010

	function Comix:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		if event == "SPELL_AURA_APPLIED" and select(2, ...) == L["Battle Shout"] then
			-- Guard dstGUID so this fires once (when the buff lands on the player)
			-- rather than once per raid member receiving the shout.
			if srcName == self.userName and dstGUID == self.userGUID and self.db.profile.battleSound then
				self:CallPic(self.Images.Special[1])
				self:DongSound(self.Sounds.Special, 1)
			end
			return
		end

		if srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0 and event == "SPELL_HEAL" then
			if srcName == self.userName or dstName == self.userName then
				local amount, _, _, critical = select(4, ...)
				if critical then
					if self.db.profile.critGapEnabled and self.db.profile.critGap and amount < self.db.profile.critGap then
						return
					end
					if random(1, 100) <= self.db.profile.critPercent then
						if self.db.profile.critHealFlash then
							-- Size 1 when healing self or receiving a heal; size 2 when player heals another.
							self:Flash(0, 1, 0, (srcName == self.userName and dstName ~= self.userName) and 2 or 1)
						end
						self:CallPic(self.Images.HolyHeal[random(1, self.ImageHolyHealCt)])
						if self.db.profile.critHeal then
							self:DongSound(self.Sounds.Healing, random(1, self.SoundHealingCt))
						end
					end
				end
			end
			return
		end

		if srcFlags and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
			if event == "PARTY_KILL" then
				self:KillCount()
			end
		end

		if (event == "SPELL_DAMAGE" or event == "RANGE_DAMAGE") and srcGUID == self.userGUID then
			local spellschool, amount, overkill, _, _, _, _, critical = select(3, ...)

			-- overkill is -1 in 3.3.5a when there is no overkill; guard before using it
			if self.db.profile.overkill and overkill > 0 and (amount - overkill) > 1 then
				if overkill / (amount - overkill) > (self.db.profile.overkillGap / 100) then
					self:CallPic(self.Images.Overkill[random(1, self.ImageOverkillCt)])
				end
			end

			if self.db.profile.critical then
				if critical then
					if self.db.profile.critGapEnabled and self.db.profile.critGap and amount < self.db.profile.critGap then
						return
					end
					if random(1, 100) <= self.db.profile.critPercent then
						if self.db.profile.shake then
							self:Shake()
						end
						self.critCount = (self.critCount or 0) + 1
						if self.critCount >= 3 then
							if self.db.profile.specialSound then
								self:DongSound(self.Sounds.Crit, random(1, self.SoundCritCt))
							end
							self:CallPic(self.Images.Special[3])
							self.critCount = 0
						end

						if self.db.profile.critSound then
							self:DongSound(self.Sounds.Crit)
						end

						if self.db.profile.critFlash then
							self:Flash(1, 0, 0, 2)
						end
						if spellschool == 16 then
							self:CallPic(self.Images.Frost[random(1, self.ImageFrostCt)])
						elseif spellschool == 20 then
							self:CallPic(self.Images.FrostFire[random(1, self.ImageFrostFireCt)])
						elseif spellschool == 4 then
							self:CallPic(self.Images.Fire[random(1, self.ImageFireCt)])
						elseif spellschool == 2 then
							self:CallPic(self.Images.HolyDamage[random(1, self.ImageHolyDamageCt)])
						elseif spellschool == 8 then
							self:CallPic(self.Images.Nature[random(1, self.ImageNatureCt)])
						elseif spellschool == 32 then
							self:CallPic(self.Images.Shadow[random(1, self.ImageShadowCt)])
						elseif spellschool == 64 then
							self:CallPic(self.Images.Arcane[random(1, self.ImageArcaneCt)])
						elseif spellschool == 1 then
							self:CallPic(self.Images.Physical[random(1, self.ImagePhysicalCt)])
						end
					end
				else
					self.critCount = 0
				end
			end

			return
		end

		if event == "SWING_DAMAGE" and srcGUID == self.userGUID then
			local amount, overkill, _, _, _, _, critical = ...

			-- overkill is -1 in 3.3.5a when there is no overkill; guard before using it
			if self.db.profile.overkill and overkill > 0 and (amount - overkill) > 1 then
				if overkill / (amount - overkill) > (self.db.profile.overkillGap / 100) then
					self:CallPic(self.Images.Overkill[random(1, self.ImageOverkillCt)])
					self:DongSound(self.Sounds.OneHit, random(1, self.SoundOneHitCt))
				end
			end

			if self.db.profile.critical then
				if critical then
					if self.db.profile.critGapEnabled and self.db.profile.critGap and amount < self.db.profile.critGap then
						return
					end
					if random(1, 100) <= self.db.profile.critPercent then
						if self.db.profile.shake then
							self:Shake()
						end
						self.critCount = (self.critCount or 0) + 1
						if self.critCount >= 3 then
							if self.db.profile.specialSound then
								self:DongSound(self.Sounds.Crit, random(1, self.SoundCritCt))
							end
							self:CallPic(self.Images.Special[3])
							self.critCount = 0
						end

						if self.db.profile.critSound then
							self:DongSound(self.Sounds.Crit)
						end

						if self.db.profile.critFlash then
							self:Flash(1, 0, 0, 2)
						end
						self:CallPic(self.Images.Physical[random(1, self.ImagePhysicalCt)])
					end
				else
					self.critCount = 0
				end
			end

			return
		end
	end
end