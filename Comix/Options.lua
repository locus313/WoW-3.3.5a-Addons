assert(Comix, "Comix not found!")
local Comix = Comix
local L = LibStub("AceLocale-3.0"):GetLocale("Comix")

Comix.defaults = {
	profile = {
		enabled = true,
		sounds = true,
		images = true,
		maxScale = 2,
		animSpeed = 1,
		-- shake --
		shake = false,
		shakeDuration = 1,
		shakeIntensity = 70,
		shakeOffset = 1,
		-- critical & overkill --
		critical = true,
		critSound = true,
		critPercent = 100,
		critHeal = true,
		critFlash = true,
		critHealFlash = true,
		critGapEnabled = false,
		critGap = false,
		overkill = true,
		overkillGap = 75,
		-- finish him --
		finish = true,
		finishSound = true,
		finishGap = 20,
		-- objections --
		objection = true,
		objectionSound = true,
		objectionImage = true,
		objectionPublic = false,
		-- other sound --
		abilitySound = true,
		bamSound = false,
		battleSound = true,
		bounceSound = true,
		deathSound = true,
		demoSound = true,
		killCount = true,
		readySound = true,
		resSound = true,
		specialSound = true,
		zoneSound = true,
		npcSound = true,
		-- lifetime counters --
		jumpCount = 0,
		hugCount = 0
	}
}

local function Disabled_Shake()
	return (Comix.db.profile.shake ~= true)
end

local function Disabled_Critial()
	return (Comix.db.profile.critical ~= true)
end

local function Disabled_Overkill()
	return (Comix.db.profile.overkill ~= true)
end

local function Disabled_Finish()
	return (Comix.db.profile.finish ~= true)
end

local function Disabled_Object()
	return (Comix.db.profile.objection ~= true)
end

local function Disabled_CritGap()
	return (Comix.db.profile.critical ~= true) or (Comix.db.profile.critGapEnabled ~= true)
end

Comix.options = {
	type = "group",
	name = "Comix",
	get = function(i) return Comix.db.profile[i[#i]] end,
	set = function(i, val)
		Comix.db.profile[i[#i]] = val
		Comix:ApplySettings()
	end,
	args = {
		enabled = {
			type = "toggle",
			name = L["Enable"],
			width = "double",
			order = 10
		},
		sounds = {
			type = "toggle",
			name = L["Sound"],
			desc = L["There is nothing better than sound, always leave this enabled!"],
			order = 20
		},
		images = {
			type = "toggle",
			name = L["Images"],
			desc = L["You don't like images? Disable them here."],
			order = 30
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Adjust the size of the images."],
			min = 0.5, max = 4, step = 0.1, bigStep = 0.5,
			get = function() return Comix.db.profile.maxScale end,
			set = function(_, val)
				Comix.db.profile.maxScale = val
				Comix:ApplySettings()
			end,
			order = 60
		},
		animSpeed = {
			type = "range",
			name = L["Animation Speed"],
			min = 0.1, max = 3, step = 0.01, bigStep = 0.1,
			order = 70
		},
		-- shake --
		shakeGroup = {
			type = "group",
			name = L["Shake"],
			inline = true,
			order = 80,
			args = {
				shake = {
					type = "toggle",
					name = L["Enable"],
					width = "double",
					order = 10
				},
				shakeDuration = {
					type = "range",
					name = L["Duration"],
					min = 1, max = 3, step = 0.1, bigStep = 1,
					hidden = Disabled_Shake,
					disabled = Disabled_Shake,
					order = 20
				},
				shakeIntensity = {
					type = "range",
					name = L["Intensity"],
					min = 0, max = 100, step = 1,
					hidden = Disabled_Shake,
					disabled = Disabled_Shake,
					order = 30
				},
				shakeOffset = {
					type = "range",
					name = L["Offset"],
					min = 0, max = 3, step = 1,
					hidden = Disabled_Shake,
					disabled = Disabled_Shake,
					order = 40
				}
			}
		},
		-- critical --
		critGroup = {
			type = "group",
			name = L["Crit"],
			inline = true,
			order = 90,
			args = {
				critical = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Toggle the Crit sounds for damage."],
					width = "double",
					order = 10
				},
				critHeal = {
					type = "toggle",
					name = L["Enable for heals"],
					desc = L["Toggle the heal sounds."],
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 20
				},
				critSound = {
					type = "toggle",
					name = L["Sound"],
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 30
				},
				critPercent = {
					type = "range",
					name = L["Crit Percent"],
					desc = L["Percentage chance for crits to show."],
					width = "double",
					min = 1, max = 100, step = 1,
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 40
				},
				critGapEnabled = {
					type = "toggle",
					name = L["Critical Gap"],
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 50
				},
				critGap = {
					type = "input",
					name = L["Gap"],
					desc = L["Only want fun at really impressive crits ? try this."],
					hidden = Disabled_CritGap,
					disabled = Disabled_CritGap,
					get = function() return tostring(Comix.db.profile.critGap or "") end,
					set = function(_, val)
						Comix.db.profile.critGap = tonumber(val) or false
						Comix:ApplySettings()
					end,
					order = 60
				},
				critFlash = {
					type = "toggle",
					name = L["Flash"],
					desc = L["Super fancy flashes when you crit or are crit by something."],
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 70
				},
				critHealFlash = {
					type = "toggle",
					name = L["Flash for heals"],
					desc = L["Kind of like the crit flash except replace the word crit with heal."],
					hidden = Disabled_Critial,
					disabled = Disabled_Critial,
					order = 80
				}
			}
		},
		-- overkill --
		overkillGroup = {
			type = "group",
			name = L["Overkill"],
			inline = true,
			order = 100,
			args = {
				overkill = {
					type = "toggle",
					name = L["Enable"],
					desc = L["If you kill something hard enough, good things happen."],
					order = 10
				},
				overkillGap = {
					type = "range",
					name = L["Gap"],
					desc = L["Minimum amount to trigger this."],
					min = 50, max = 100, step = 1, bigStep = 5,
					hidden = Disabled_Overkill,
					disabled = Disabled_Overkill,
					order = 20
				}
			}
		},
		-- finish him --
		finishGroup = {
			type = "group",
			name = L["Finish Him"],
			inline = true,
			order = 110,
			args = {
				finish = {
					type = "toggle",
					name = L["Enable"],
					desc = L["\"Finish Him\"-Sound for low-Health foes."],
					width = "double",
					order = 10
				},
				finishSound = {
					type = "toggle",
					name = L["Sound"],
					hidden = Disabled_Finish,
					disabled = Disabled_Finish,
					order = 20
				},
				finishGap = {
					type = "range",
					name = L["Gap"],
					desc = L["Percentage of health left to trigger."],
					min = 1, max = 30, step = 1,
					hidden = Disabled_Finish,
					disabled = Disabled_Finish,
					order = 30
				}
			}
		},
		-- objection --
		objectionGroup = {
			type = "group",
			name = L["Objection"],
			inline = true,
			order = 120,
			args = {
				objection = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Objection Sounds, Phoenix Wright Style."],
					order = 10
				},
				objectionSound = {
					type = "toggle",
					name = L["Objection Sounds"],
					hidden = Disabled_Object,
					disabled = Disabled_Object,
					order = 20
				},
				objectionImage = {
					type = "toggle",
					name = L["Objection Images"],
					desc = L["Enable Objection Images. Portraits only display for party/raid members."],
					hidden = Disabled_Object,
					disabled = Disabled_Object,
					order = 30
				},
				objectionPublic = {
					type = "toggle",
					name = L["Public Objections"],
					desc = L["Ignore Objections from everyone outside your party or raid. Public objections do not show a portrait and are not gender specific."],
					hidden = Disabled_Object,
					disabled = Disabled_Object,
					order = 40
				}
			}
		},
		-- other sounds --
		other = {
			type = "group",
			name = L["Other Options"],
			inline = true,
			order = 130,
			args = {
				abilitySound = {
					type = "toggle",
					name = L["Ability"],
					order = 10
				},
				bamSound = {
					type = "toggle",
					name = L["Bam"],
					desc = L["Replace all sounds with \"BAM\""],
					order = 20
				},
				bounceSound = {
					type = "toggle",
					name = L["Jump"],
					desc = L["Disable the annoying boing sound for jumping by unchecking this here box."],
					order = 30
				},
				deathSound = {
					type = "toggle",
					name = L["Death"],
					desc = L["This Turns on the Death Sounds and Images, makes dying much more demoralizing, but funny at the same time."],
					order = 40
				},
				battleSound = {
					type = "toggle",
					name = L["Battle Shout"],
					desc = L["Almost as cool as Demoralizing Shout, only for battles."],
					order = 50
				},
				demoSound = {
					type = "toggle",
					name = L["Demoralizing Shout"],
					desc = L["Fun stuff for Demoralizing Shout/Roar can be disabled if annoying."],
					order = 60
				},
				killCount = {
					type = "toggle",
					name = L["Kill Count"],
					order = 70
				},
				readySound = {
					type = "toggle",
					name = READY_CHECK,
					desc = L["Are you ready? Yes? No!"],
					order = 80
				},
				resSound = {
					type = "toggle",
					name = L["Resurrect Sound"],
					desc = L["Extra Liiiiife!!!!"],
					order = 90
				},
				specialSound = {
					type = "toggle",
					name = L["Special Sound"],
					order = 100
				},
				zoneSound = {
					type = "toggle",
					name = L["Zone Sound"],
					desc = L["Yes, there is a sound for zone changes, toggle it on/off with this."],
					order = 110
				},
				npcSound = {
					type = "toggle",
					name = L["NPC Sounds"],
					desc = L["Play a sound when targeting special NPCs (Mr. Bigglesworth, Muffin Man Moser)."],
					order = 120
				}
			}
		}
	}
}