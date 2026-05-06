assert(Comix, "Comix not found!")
local Comix = Comix

-- [[ IMAGES ]] --

do
	local Images = Comix.Images or {}
	Comix.Images = Images
	local path = "Interface\\AddOns\\Comix\\Media\\Images\\"

	-- physical (1) --
	Images.Physical = {
		[1] = path .. "Physical\\blade1.blp",
		[2] = path .. "Physical\\blade2.blp",
		[3] = path .. "Physical\\blade3.blp",
		[4] = path .. "Physical\\blade4.blp",
		[5] = path .. "Physical\\blade5.blp",
		[6] = path .. "Physical\\blade6.blp",
		[7] = path .. "Physical\\blade7.blp",
		[8] = path .. "Physical\\blade8.blp",
		[9] = path .. "Physical\\blade9.blp",
		[10] = path .. "Physical\\blade10.blp",
		[11] = path .. "Physical\\blade11.blp",
		[12] = path .. "Physical\\blade12.blp"
	}

	-- holy heal & damage (2) --
	Images.HolyHeal = {
		[1] = path .. "Holy\\holyheal1.blp",
		[2] = path .. "Holy\\holyheal2.blp",
		[3] = path .. "Holy\\holyheal3.blp",
		[4] = path .. "Holy\\holyheal4.blp"
	}
	Images.HolyDamage = {
		[1] = path .. "Holy\\holydmg1.blp",
		[2] = path .. "Holy\\holydmg2.blp",
		[3] = path .. "Holy\\holydmg3.blp",
		[4] = path .. "Holy\\holydmg4.blp"
	}

	-- fire (4) --
	Images.Fire = {
		[1] = path .. "Fire\\fire1.blp",
		[2] = path .. "Fire\\fire2.blp",
		[3] = path .. "Fire\\fire3.blp",
		[4] = path .. "Fire\\fire4.blp",
		[5] = path .. "Fire\\fire5.blp",
		[6] = path .. "Fire\\fire6.blp",
		[7] = path .. "Fire\\fire7.blp",
		[8] = path .. "Fire\\fire8.blp",
		[9] = path .. "Fire\\fire9.blp"
	}

	-- nature (8) --
	Images.Nature = {
		[1] = path .. "Nature\\nature1.blp",
		[2] = path .. "Nature\\nature2.blp",
		[3] = path .. "Nature\\nature3.blp",
		[4] = path .. "Nature\\nature4.blp"
	}

	-- frost (16) --
	Images.Frost = {
		[1] = path .. "Frost\\frost1.blp",
		[2] = path .. "Frost\\frost2.blp",
		[3] = path .. "Frost\\frost3.blp",
		[4] = path .. "Frost\\frost4.blp",
		[5] = path .. "Frost\\frost5.blp",
		[6] = path .. "Frost\\frost6.blp",
		[7] = path .. "Frost\\frost7.blp",
		[8] = path .. "Frost\\frost8.blp",
		[9] = path .. "Frost\\frost9.blp",
		[10] = path .. "Frost\\frost10.blp",
		[11] = path .. "Frost\\frost11.blp"
	}

	-- frostfire (20) --
	Images.FrostFire = {
		[1] = path .. "Frostfire\\frostfire1.blp",
		[2] = path .. "Frostfire\\frostfire2.blp",
		[3] = path .. "Frostfire\\frostfire3.blp",
		[4] = path .. "Frostfire\\frostfire4.blp"
	}

	-- shadow (32) --
	Images.Shadow = {
		[1] = path .. "Shadow\\shadow1.blp",
		[2] = path .. "Shadow\\shadow2.blp",
		[3] = path .. "Shadow\\shadow3.blp",
		[4] = path .. "Shadow\\shadow4.blp",
		[5] = path .. "Shadow\\shadow5.blp",
		[6] = path .. "Shadow\\shadow6.blp"
	}

	-- arcane (64) --
	Images.Arcane = {
		[1] = path .. "Arcane\\arcane1.blp",
		[2] = path .. "Arcane\\arcane2.blp",
		[3] = path .. "Arcane\\arcane3.blp",
		[4] = path .. "Arcane\\arcane4.blp"
	}

	-- death --
	Images.Death = {
		[1] = path .. "Death\\death1.blp",
		[2] = path .. "Death\\death2.blp",
		[3] = path .. "Death\\death3.blp"
	}

	-- overkill --
	Images.Overkill = {
		[1] = path .. "Overkill\\overkill1.blp",
		[2] = path .. "Overkill\\overkill2.blp",
		[3] = path .. "Overkill\\overkill3.blp",
		[4] = path .. "Overkill\\overkill4.blp"
	}

	-- special --
	Images.Special = {
		[1] = path .. "Special\\battleshout.blp",
		[2] = path .. "Special\\demoshout.blp",
		[3] = path .. "Special\\ironman.blp",
		[4] = path .. "Special\\stun.blp",
		[5] = path .. "Special\\objection.blp"
	}

	-- mortal combat --
	Images.MortalCombat = {
		[1] = path .. "Special\\brutality.blp",
		[2] = path .. "Special\\fatality.blp",
		[3] = path .. "Special\\superb.blp",
		[4] = path .. "Special\\outstanding.blp",
		[5] = path .. "Special\\excellent.blp"
	}
end

-- [[ Sounds ]] --

do
	local Sounds = Comix.Sounds or {}
	Comix.Sounds = Sounds
	local path = "Interface\\AddOns\\Comix\\Media\\Sounds\\"

	-- crit --
	Sounds.Crit = {
		[1] = path .. "Crit\\Crit1.ogg",
		[2] = path .. "Crit\\Crit2.ogg",
		[3] = path .. "Crit\\Crit3.ogg",
		[4] = path .. "Crit\\Crit4.ogg",
		[5] = path .. "Crit\\homer-woohoo.ogg",
		[6] = path .. "Crit\\Crit6.ogg",
		[7] = path .. "Crit\\Crit7.ogg",
		[8] = path .. "Crit\\anime-wow.ogg",
		[9] = path .. "Crit\\Toasty.ogg",
		[10] = path .. "Crit\\skadoosh.ogg",
		[11] = path .. "Crit\\uwu.ogg",
		[12] = path .. "Crit\\imgonnawreckit.ogg",
		[13] = path .. "Crit\\impressive.ogg",
		[14] = path .. "Crit\\MKLaugh.ogg",
		[15] = path .. "Crit\\riff.ogg",
		[16] = path .. "Crit\\mongoose.ogg",
		[17] = path .. "Crit\\excellent.ogg",
		[18] = path .. "Crit\\boombaby.ogg",
		[19] = path .. "Crit\\SNAP.ogg"
	}

	-- special --
	Sounds.Special = {
		[1] = path .. "Special\\Battleshout.ogg",
		[2] = path .. "Special\\DemoShout.ogg",
		[3] = path .. "Special\\DemoShout2.ogg",
		[4] = path .. "Special\\impressive.ogg",
		[5] = path .. "Special\\dr_evil.ogg",
		[6] = path .. "Special\\game.ogg",
		[7] = path .. "Special\\allyourbase.ogg",
		[8] = path .. "Special\\boing.ogg",
		[9] = path .. "Special\\welldone.ogg",
		[10] = path .. "Special\\muffinman.ogg",
		[11] = path .. "Special\\speedy.ogg",
		[12] = path .. "Special\\finishim.ogg",
		[13] = path .. "Special\\bam.ogg",
		[14] = path .. "Special\\TYM.ogg",
		[15] = path .. "Special\\bucketonothing.ogg",
		[16] = path .. "Special\\lair.ogg",
		[17] = path .. "Special\\drum.ogg",
		[18] = path .. "Special\\ExtraLife.ogg",
		[19] = path .. "Special\\drama.ogg",
		[20] = path .. "Special\\Overhere.ogg",
		[21] = path .. "Special\\Comehere.ogg",
		[22] = path .. "Special\\MKSoul.ogg",
		[23] = path .. "Special\\44rage.ogg"
	}

	-- resurrect --
	Sounds.Res = {
		[1] = path .. "Res\\res1.ogg",
		[2] = path .. "Res\\res2.ogg",
		[3] = path .. "Res\\crash1up.ogg",
		[4] = path .. "Res\\ka-ching.ogg",
		[5] = path .. "Res\\Mario 1UP.ogg",
		[6] = path .. "Res\\mega-man-1up.ogg",
		[7] = path .. "Res\\round-two.ogg",
		[8] = path .. "Res\\sonic-1-extra-life.ogg"
	}

	-- ability --
	Sounds.Ability = {
		[1] = path .. "Ability\\cookie.ogg",
		[2] = path .. "Ability\\frosty.ogg",
		[3] = path .. "Ability\\flare.ogg"
	}

	-- ready check --
	Sounds.ReadyCheck = {
		[1] = path .. "Ready\\ready1.ogg",
		[2] = path .. "Ready\\ready2.ogg",
		[3] = path .. "Ready\\ready3.ogg",
		[4] = path .. "Ready\\ready4.ogg",
		[5] = path .. "Ready\\ready5.ogg",
		[6] = path .. "Ready\\ready6.ogg",
		[7] = path .. "Ready\\imready.ogg",
		[8] = path .. "Ready\\Bringiton.ogg",
		[9] = path .. "Ready\\concentration.ogg"
	}

	-- death --
	Sounds.Death = {
		[1] = path .. "Death\\its-official-you-suck.ogg",
		[2] = path .. "Death\\Super-mario-bros-death.ogg",
		[3] = path .. "Death\\pacmandie.ogg",
		[4] = path .. "Death\\whoa.ogg",
		[5] = path .. "Death\\Samusdeath.ogg",
		[6] = path .. "Death\\nooo.ogg",
		[7] = path .. "Death\\Zelda 2 death.ogg",
		[8] = path .. "Death\\alexdeath.ogg",
		[9] = path .. "Death\\zelda.ogg",
		[10] = path .. "Death\\mariodie2.ogg",
		[11] = path .. "Death\\death1.ogg",
		[12] = path .. "Death\\Megaman death.ogg",
		[13] = path .. "Death\\Castlevaina death.ogg",
		[14] = path .. "Death\\Dark Souls - You Died.ogg",
		[15] = path .. "Death\\Double dragon game over.ogg",
		[16] = path .. "Death\\Kirby death.ogg",
		[17] = path .. "Death\\ninja-gaiden-death.ogg",
		[18] = path .. "Death\\Pitfall death.ogg",
		[19] = path .. "Death\\price-is-right-losing-trombone.ogg",
		[20] = path .. "Death\\Punch out KO.ogg",
		[21] = path .. "Death\\Splatterhouse 2 death.ogg",
		[22] = path .. "Death\\You Lose.ogg",
		[23] = path .. "Death\\MGS-gameover.ogg",
		[24] = path .. "Death\\Hellokitty.ogg",
		[25] = path .. "Death\\emotionaldmg.ogg",
		[26] = path .. "Death\\Fudge.ogg"
	}

	-- kill count --
	Sounds.KillCount = {
		[1] = path .. "KillCount\\killingspree.ogg",
		[2] = path .. "KillCount\\rampage.ogg",
		[3] = path .. "KillCount\\multikill.ogg",
		[4] = path .. "KillCount\\unstoppable.ogg",
		[5] = path .. "KillCount\\ultrakill.ogg",
		[6] = path .. "KillCount\\dominating.ogg",
		[7] = path .. "KillCount\\godlike.ogg",
		[8] = path .. "KillCount\\ludicrouskill.ogg",
		[9] = path .. "KillCount\\monsterkill.ogg"
	}

	-- zone --
	Sounds.Zone = {
		[1] = path .. "Zone\\Kung fu start.ogg",
		[2] = path .. "Zone\\Punch out start.ogg",
		[3] = path .. "Zone\\Super metroid start.ogg",
		[4] = path .. "Zone\\Megaman2 start.ogg",
		[5] = path .. "Zone\\zone5.ogg",
		[6] = path .. "Zone\\zone6.ogg",
		[7] = path .. "Zone\\zone7.ogg",
		[8] = path .. "Zone\\zone8.ogg",
		[9] = path .. "Zone\\zone9.ogg",
		[10] = path .. "Zone\\zone10.ogg",
		[11] = path .. "Zone\\zone11.ogg",
		[12] = path .. "Zone\\zone12.ogg",
		[13] = path .. "Zone\\zone13.ogg",
		[14] = path .. "Zone\\QUEST.ogg"
	}

	-- one hit --
	Sounds.OneHit = {
		[1] = path .. "OneHit\\brutality.ogg",
		[2] = path .. "OneHit\\fatality.ogg",
		[3] = path .. "OneHit\\supurb.ogg",
		[4] = path .. "OneHit\\outstanding.ogg",
		[5] = path .. "OneHit\\excelent.ogg"
	}

	-- healing --
	Sounds.Healing = {
		[1] = path .. "Healing\\healing1.ogg",
		[2] = path .. "Healing\\heal.ogg",
		[3] = path .. "Healing\\healing3.ogg",
		[4] = path .. "Healing\\alleluia.ogg",
		[5] = path .. "Healing\\homer-woohoo.ogg",
		[6] = path .. "Healing\\anime-wow.ogg",
		[7] = path .. "Healing\\roboheal.ogg",
		[8] = path .. "Healing\\MarioPowerUp.ogg"
	}

	-- objection --
	Sounds.Objection = {
		[1] = path .. "Objection\\objectionm1.ogg",
		[2] = path .. "Objection\\objectionm2.ogg",
		[3] = path .. "Objection\\objectionf1.ogg",
		[4] = path .. "Objection\\objectionf2.ogg"
	}
end