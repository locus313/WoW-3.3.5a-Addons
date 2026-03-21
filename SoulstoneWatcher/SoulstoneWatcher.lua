SoulstoneWatcherConfig = {}

local SPELL_ID = 5232
local localizedClass, englishClass, classIndex = UnitClass("player")
local button1Player;
local button2Player;
local button3Player;
local button4Player;
local castID;
local castTargetPlayer;
local msgSent = false;
local versionMsgSent = false;
local versionNumber = 107;
local prefix = "SoulstoneWatcher"
local f
local triggerEventFrame

local function start_loading(self, event)
    load_options()
end

local function set_option_message_to_say(self, option, check)
    if SoulstoneWatcherConfig.say == true then
        SoulstoneWatcherConfig.say = false
        return
    end
    if SoulstoneWatcherConfig.say == false or SoulstoneWatcherConfig.say == nil then
        SoulstoneWatcherConfig.say = true
        return
    end
end

local function set_option_message_to_raid(self, option, check)
    if SoulstoneWatcherConfig.say_to_raid == true then
        SoulstoneWatcherConfig.say_to_raid = false
        return
    end
    if SoulstoneWatcherConfig.say_to_raid == false or SoulstoneWatcherConfig.say_to_raid == nil then
        SoulstoneWatcherConfig.say_to_raid = true
        return
    end
end

local function set_option_message_to_party(self, option, check)
    if SoulstoneWatcherConfig.say_to_party == true then
        SoulstoneWatcherConfig.say_to_party = false
        return
    end
    if SoulstoneWatcherConfig.say_to_party == false or SoulstoneWatcherConfig.say_to_party == nil then
        SoulstoneWatcherConfig.say_to_party = true
        return
    end
end

local function set_option_enable_at_ready(self, option, check)
    if SoulstoneWatcherConfig.enable_at_ready == true then
        SoulstoneWatcherConfig.enable_at_ready = false
        return
    end
    if SoulstoneWatcherConfig.enable_at_ready == false or SoulstoneWatcherConfig.enable_at_ready == nil then
        SoulstoneWatcherConfig.enable_at_ready = true
        return
    end
end

local function set_option_enable_at_join(self, option, check)
    if SoulstoneWatcherConfig.enable_at_join == true then
        SoulstoneWatcherConfig.enable_at_join = false
        return
    end
    if SoulstoneWatcherConfig.enable_at_join == false or SoulstoneWatcherConfig.enable_at_join == nil then
        SoulstoneWatcherConfig.enable_at_join = true
        return
    end
end

local function set_option_show_cast_buttons(self, option, check)
    if SoulstoneWatcherConfig.show_cast_buttons == true then
        SoulstoneWatcherConfig.show_cast_buttons = false
        return
    end
    if SoulstoneWatcherConfig.show_cast_buttons == false or SoulstoneWatcherConfig.show_cast_buttons == nil then
        SoulstoneWatcherConfig.show_cast_buttons = true
        return
    end
end

local SoulstoneWatcherOptions = {};
SoulstoneWatcherOptions.panel = CreateFrame( "Frame", "SoulstoneWatcherOptionsPanel", UIParent );
SoulstoneWatcherOptions.panel.name = "Soulstone Watcher";
InterfaceOptions_AddCategory(SoulstoneWatcherOptions.panel);

local markerOptionsText = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsText", "OVERLAY", "GameFontNormalLarge")
markerOptionsText:SetPoint("TOP", SoulstoneWatcherOptions.panel, "TOP",0,-10)
markerOptionsText:SetText("|cff8788EESoulstone Watcher Options")

local markerOptionsTextRaid = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsTextRaid", "OVERLAY", "GameFontNormal")
markerOptionsTextRaid:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",10,-30)
markerOptionsTextRaid:SetText("Enable at (changes take effect after reload)")

local enableCheckBoxReady = CreateFrame("CheckButton", "enableCheckBoxReady", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
enableCheckBoxReady:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -50)
enableCheckBoxReady:SetSize(20,20)
enableCheckBoxReady:SetScript("OnClick", set_option_enable_at_ready)

local enableCheckBoxReadyText = SoulstoneWatcherOptions.panel:CreateFontString("enableCheckBoxReadyText", "OVERLAY", "GameFontWhite")
enableCheckBoxReadyText:SetPoint("LEFT", enableCheckBoxReady, "RIGHT", 5, 0)
enableCheckBoxReadyText:SetText("Enable check at ReadyCheck")

local enableCheckBoxJoin = CreateFrame("CheckButton", "enableCheckBoxJoin", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
enableCheckBoxJoin:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -70)
enableCheckBoxJoin:SetSize(20,20)
enableCheckBoxJoin:SetScript("OnClick", set_option_enable_at_join)

local enableCheckBoxJoinText = SoulstoneWatcherOptions.panel:CreateFontString("enableCheckBoxJoinText", "OVERLAY", "GameFontWhite")
enableCheckBoxJoinText:SetPoint("LEFT", enableCheckBoxJoin, "RIGHT", 5, 0)
enableCheckBoxJoinText:SetText("Enable check when joining a group")

local markerOptionsTextMessage = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsTextMessage", "OVERLAY", "GameFontNormal")
markerOptionsTextMessage:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",10,-110)
markerOptionsTextMessage:SetText("Cast Messages")

local messageCheckBoxSay = CreateFrame("CheckButton", "messageCheckBoxSay", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
messageCheckBoxSay:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -130)
messageCheckBoxSay:SetSize(20,20)
messageCheckBoxSay:SetScript("OnClick", set_option_message_to_say)

local messageCheckBoxSayText = SoulstoneWatcherOptions.panel:CreateFontString("messageCheckBoxSayText", "OVERLAY", "GameFontWhite")
messageCheckBoxSayText:SetPoint("LEFT", messageCheckBoxSay, "RIGHT", 5, 0)
messageCheckBoxSayText:SetText("Send cast message (/say)")

local messageCheckBoxRaid = CreateFrame("CheckButton", "messageCheckBoxRaid", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
messageCheckBoxRaid:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -150)
messageCheckBoxRaid:SetSize(20,20)
messageCheckBoxRaid:SetScript("OnClick", set_option_message_to_raid)

local messageCheckBoxRaidText = SoulstoneWatcherOptions.panel:CreateFontString("messageCheckBoxRaidText", "OVERLAY", "GameFontWhite")
messageCheckBoxRaidText:SetPoint("LEFT", messageCheckBoxRaid, "RIGHT", 5, 0)
messageCheckBoxRaidText:SetText("Send cast message to Raid")

local messageCheckBoxParty = CreateFrame("CheckButton", "messageCheckBoxParty", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
messageCheckBoxParty:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -170)
messageCheckBoxParty:SetSize(20,20)
messageCheckBoxParty:SetScript("OnClick", set_option_message_to_party)

local messageCheckBoxPartyText = SoulstoneWatcherOptions.panel:CreateFontString("messageCheckBoxParty", "OVERLAY", "GameFontWhite")
messageCheckBoxPartyText:SetPoint("LEFT", messageCheckBoxParty, "RIGHT", 5, 0)
messageCheckBoxPartyText:SetText("Send cast message to Party")

local markerOptionsTextButtons = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsTextButtons", "OVERLAY", "GameFontNormal")
markerOptionsTextButtons:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",10,-330)
markerOptionsTextButtons:SetText("Castbutton options")

local enableCheckBoxButtons = CreateFrame("CheckButton", "enableCheckBoxButtons", SoulstoneWatcherOptions.panel, "UICheckButtonTemplate")
enableCheckBoxButtons:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",25, -350)
enableCheckBoxButtons:SetSize(20,20)
enableCheckBoxButtons:SetScript("OnClick", set_option_show_cast_buttons)

local enableCheckBoxButtonsText = SoulstoneWatcherOptions.panel:CreateFontString("enableCheckBoxButtonsText", "OVERLAY", "GameFontWhite")
enableCheckBoxButtonsText:SetPoint("LEFT", enableCheckBoxButtons, "RIGHT", 5, 0)
enableCheckBoxButtonsText:SetText("Show castbuttons on ReadyCheck and party invite")

local markerOptionsTextTarget = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsTextTarget", "OVERLAY", "GameFontNormal")
markerOptionsTextTarget:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",10,-210)
markerOptionsTextTarget:SetText("Soulstone Main Target")

local healerClasses = { PRIEST = true, DRUID = true, PALADIN = true, SHAMAN = true }

local dropDownMainTarget = CreateFrame("Frame", "SWMainTargetDropDown", SoulstoneWatcherOptions.panel, "UIDropDownMenuTemplate")
dropDownMainTarget:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT", 0, -225)
UIDropDownMenu_SetWidth(dropDownMainTarget, 120)
UIDropDownMenu_Initialize(dropDownMainTarget, function(self)
    local info = UIDropDownMenu_CreateInfo()
    -- None option
    info.text = "None"
    info.checked = (SoulstoneWatcherConfig.main_target == "" or SoulstoneWatcherConfig.main_target == nil)
    info.func = function()
        SoulstoneWatcherConfig.main_target = ""
        UIDropDownMenu_SetText(dropDownMainTarget, "None")
        CloseDropDownMenus()
    end
    UIDropDownMenu_AddButton(info)

    local healers = {}
    local others = {}
    if GetNumRaidMembers() > 0 then
        for i = 1, MAX_RAID_MEMBERS do
            local name, _, _, _, _, fileName = GetRaidRosterInfo(i)
            if name then
                if healerClasses[fileName] then
                    table.insert(healers, name)
                else
                    table.insert(others, name)
                end
            end
        end
    else
        local myName = UnitName("player")
        local _, myClass = UnitClass("player")
        if myName then
            if healerClasses[myClass] then table.insert(healers, myName)
            else table.insert(others, myName) end
        end
        for i = 1, GetNumPartyMembers() do
            local name = UnitName("party"..i)
            local _, memberClass = UnitClass("party"..i)
            if name then
                if healerClasses[memberClass] then table.insert(healers, name)
                else table.insert(others, name) end
            end
        end
    end

    for _, name in ipairs(healers) do
        local n = name
        info = UIDropDownMenu_CreateInfo()
        info.text = n .. " (Healer)"
        info.checked = (SoulstoneWatcherConfig.main_target == n)
        info.func = function()
            SoulstoneWatcherConfig.main_target = n
            UIDropDownMenu_SetText(dropDownMainTarget, n)
            CloseDropDownMenus()
        end
        UIDropDownMenu_AddButton(info)
    end
    for _, name in ipairs(others) do
        local n = name
        info = UIDropDownMenu_CreateInfo()
        info.text = n
        info.checked = (SoulstoneWatcherConfig.main_target == n)
        info.func = function()
            SoulstoneWatcherConfig.main_target = n
            UIDropDownMenu_SetText(dropDownMainTarget, n)
            CloseDropDownMenus()
        end
        UIDropDownMenu_AddButton(info)
    end
end)

local dropDownMainTargetText = SoulstoneWatcherOptions.panel:CreateFontString("dropDownMainTargetText", "OVERLAY", "GameFontWhite")
dropDownMainTargetText:SetPoint("LEFT", dropDownMainTarget, "RIGHT", 1, 0)
dropDownMainTargetText:SetText("Shown first in cast buttons (healers listed first)")

local markerOptionsTextRank = SoulstoneWatcherOptions.panel:CreateFontString("markerOptionsTextRank", "OVERLAY", "GameFontNormal")
markerOptionsTextRank:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT",10,-258)
markerOptionsTextRank:SetText("Soulstone Item Rank")

local dropDownRaid = CreateFrame("Frame", "WPDemoDropDown", SoulstoneWatcherOptions.panel, "UIDropDownMenuTemplate")
dropDownRaid:SetPoint("TOPLEFT", SoulstoneWatcherOptions.panel, "TOPLEFT", 0, -275)
UIDropDownMenu_SetWidth(dropDownRaid, 80)
UIDropDownMenu_Initialize(dropDownRaid, function(self)
    local info = UIDropDownMenu_CreateInfo()
    info.func = self.MinorSoulstone
    info.text = "Minor Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.LesserSoulstone
    info.text = "Lesser Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.Soulstone
    info.text = "Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.GreaterSoulstone
    info.text = "Greater Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.MajorSoulstone
    info.text = "Major Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.MasterSoulstone
    info.text = "Master Soulstone"
    UIDropDownMenu_AddButton(info)
    info.func = self.DemonicSoulstone
    info.text = "Demonic Soulstone"
    UIDropDownMenu_AddButton(info)
end)

local dropDownRaidText = SoulstoneWatcherOptions.panel:CreateFontString("dropDownRaidText", "OVERLAY", "GameFontWhite")
dropDownRaidText:SetPoint("LEFT", dropDownRaid, "RIGHT", 1,0)
dropDownRaidText:SetText("Select soulstone item (rank) for the cast bars.")

local castButton1 = CreateFrame("Button", "SWCastButton1", UIParent, "SecureActionButtonTemplate,UIPanelButtonTemplate")
castButton1:SetPoint("CENTER", 0, 100)
castButton1:SetSize(100, 40)
castButton1:SetAttribute("type", "item")
castButton1:Hide()

local castButton2 = CreateFrame("Button", "SWCastButton2", UIParent, "SecureActionButtonTemplate,UIPanelButtonTemplate")
castButton2:SetPoint("CENTER", 0, 60)
castButton2:SetSize(100, 40)
castButton2:SetAttribute("type", "item")
castButton2:Hide()

local castButton3 = CreateFrame("Button", "SWCastButton3", UIParent, "SecureActionButtonTemplate,UIPanelButtonTemplate")
castButton3:SetPoint("CENTER", 150, 100)
castButton3:SetSize(100, 40)
castButton3:SetAttribute("type", "item")
castButton3:Hide()

local castButton4 = CreateFrame("Button", "SWCastButton4", UIParent, "SecureActionButtonTemplate,UIPanelButtonTemplate")
castButton4:SetPoint("CENTER", 150, 60)
castButton4:SetSize(100, 40)
castButton4:SetAttribute("type", "item")
castButton4:Hide()

local castButtonClear = CreateFrame("Button", "SWCastButtonClear", UIParent, "UIPanelButtonTemplate")
castButtonClear:SetPoint("CENTER", 75, 20)
castButtonClear:SetSize(100, 40)
castButtonClear:SetText("Hide Buttons")
castButtonClear:SetScript("OnClick", function(self, arg1)
    castButton1:Hide()
    castButton2:Hide()
    castButton3:Hide()
    castButton4:Hide()
    castButtonClear:Hide()
end)
castButtonClear:Hide()

function dropDownRaid:MinorSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Minor Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 5232
    SPELL_ID = 20707
    castButton1:SetAttribute("item", "item:5232")
    castButton2:SetAttribute("item", "item:5232")
    castButton3:SetAttribute("item", "item:5232")
    castButton4:SetAttribute("item", "item:5232")
    CloseDropDownMenus()
end

function dropDownRaid:LesserSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Lesser Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 16892
    SPELL_ID = 20762
    castButton1:SetAttribute("item", "item:16892")
    castButton2:SetAttribute("item", "item:16892")
    castButton3:SetAttribute("item", "item:16892")
    castButton4:SetAttribute("item", "item:16892")
    CloseDropDownMenus()
end

function dropDownRaid:Soulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 16893
    SPELL_ID = 20763
    castButton1:SetAttribute("item", "item:16893")
    castButton2:SetAttribute("item", "item:16893")
    castButton3:SetAttribute("item", "item:16893")
    castButton4:SetAttribute("item", "item:16893")
    CloseDropDownMenus()
end

function dropDownRaid:GreaterSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Greater Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 16895
    SPELL_ID = 20764
    castButton1:SetAttribute("item", "item:16895")
    castButton2:SetAttribute("item", "item:16895")
    castButton3:SetAttribute("item", "item:16895")
    castButton4:SetAttribute("item", "item:16895")
    CloseDropDownMenus()
end

function dropDownRaid:MajorSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Major Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 16896
    SPELL_ID = 20765
    castButton1:SetAttribute("item", "item:16896")
    castButton2:SetAttribute("item", "item:16896")
    castButton3:SetAttribute("item", "item:16896")
    castButton4:SetAttribute("item", "item:16896")
    CloseDropDownMenus()
end

function dropDownRaid:MasterSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Master Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 22116
    SPELL_ID = 27239
    castButton1:SetAttribute("item", "item:22116")
    castButton2:SetAttribute("item", "item:22116")
    castButton3:SetAttribute("item", "item:22116")
    castButton4:SetAttribute("item", "item:22116")
    CloseDropDownMenus()
end

function dropDownRaid:DemonicSoulstone()
    UIDropDownMenu_SetText(dropDownRaid, "Demonic Soulstone")
    SoulstoneWatcherConfig.soulstone_itemid = 36895
    SPELL_ID = 47883
    castButton1:SetAttribute("item", "item:36895")
    castButton2:SetAttribute("item", "item:36895")
    castButton3:SetAttribute("item", "item:36895")
    castButton4:SetAttribute("item", "item:36895")
    CloseDropDownMenus()
end

local frame = CreateFrame("FRAME");
frame:RegisterEvent("VARIABLES_LOADED");
frame:SetScript("OnEvent", start_loading)

local function getUnitToken(name)
    if GetNumRaidMembers() > 0 then
        for i = 1, MAX_RAID_MEMBERS do
            local n = GetRaidRosterInfo(i)
            if n == name then return "raid"..i end
        end
    else
        for i = 1, GetNumPartyMembers() do
            if UnitName("party"..i) == name then return "party"..i end
        end
        if UnitName("player") == name then return "player" end
    end
    return nil
end

local function get_player_buffs(player)
    buffList = {}
    button1Player = nil
    button2Player = nil
    button3Player = nil
    button4Player = nil

    -- If a main target is configured, move them to the front of the list
    local mainTarget = SoulstoneWatcherConfig.main_target
    local orderedPlayers = {}
    if mainTarget and mainTarget ~= "" then
        for _, name in ipairs(player) do
            if name == mainTarget then
                table.insert(orderedPlayers, 1, name)
            elseif name then
                table.insert(orderedPlayers, name)
            end
        end
    else
        for _, name in ipairs(player) do
            if name then
                table.insert(orderedPlayers, name)
            end
        end
    end

    for index, playerName in ipairs(orderedPlayers) do
        if index == 1 then
            button1Player = playerName
        end
        if index == 2 then
            button2Player = playerName
        end
        if index == 3 then
            button3Player = playerName
        end
        if index == 4 then
            button4Player = playerName
        end
    end

    if classIndex == 9 and SoulstoneWatcherConfig.show_cast_buttons then

        if button1Player ~= nil then
            local unit1 = getUnitToken(button1Player)
            castButton1:SetText(button1Player)
            if unit1 then castButton1:SetAttribute("unit", unit1) end
            castButton1:Show()
            castButtonClear:Show()
        end

        if button2Player ~= nil then
            local unit2 = getUnitToken(button2Player)
            castButton2:SetText(button2Player)
            if unit2 then castButton2:SetAttribute("unit", unit2) end
            castButton2:Show()
            castButtonClear:Show()
        end

        if button3Player ~= nil then
            local unit3 = getUnitToken(button3Player)
            castButton3:SetText(button3Player)
            if unit3 then castButton3:SetAttribute("unit", unit3) end
            castButton3:Show()
            castButtonClear:Show()
        end

        if button4Player ~= nil then
            local unit4 = getUnitToken(button4Player)
            castButton4:SetText(button4Player)
            if unit4 then castButton4:SetAttribute("unit", unit4) end
            castButton4:Show()
            castButtonClear:Show()
        end
    end
end

local function get_raid_players()
    raidPlayerList = {}
    if GetNumRaidMembers() > 0 then
        for i=1,MAX_RAID_MEMBERS do
            local name = GetRaidRosterInfo(i)
            if name then
                table.insert(raidPlayerList, name)
            end
        end
    else
        -- In a party (not a raid), use party unit tokens
        local numParty = GetNumPartyMembers()
        for i=1,numParty do
            local name = UnitName("party"..i)
            if name then
                table.insert(raidPlayerList, name)
            end
        end
        local myName = UnitName("player")
        if myName then
            table.insert(raidPlayerList, myName)
        end
    end
    return raidPlayerList
end

local function OnEvent(self, event)
    local itemID = SoulstoneWatcherConfig.soulstone_itemid or 36895
    startTime, duration, enable = GetItemCooldown(itemID)

    if (duration == nil or duration == 0) and classIndex == 9 then
        print("|cff8788EESoulstone Watcher: Your Soulstone is ready")
        player = get_raid_players()
        check = get_player_buffs(player)
        versionMsgSent = false
    end
end

local function cooldownCheck(self, event)
    if msgSent == false then
        local itemID = SoulstoneWatcherConfig.soulstone_itemid or 36895
        startTime, duration, enable = GetItemCooldown(itemID)

        if (duration == nil or duration == 0) and classIndex == 9 then
            SendAddonMessage(prefix, versionNumber, "RAID")
            SendAddonMessage(prefix, versionNumber, "GUILD")        
            print("|cff8788EESoulstone Watcher: Your Soulstone is ready again !")
            msgSent = true
            versionMsgSent = false
        end    
    end
end

function load_options(self, event)
    if SoulstoneWatcherConfig.enable_at_ready == nil then
        SoulstoneWatcherConfig.enable_at_ready = true
    end

    if SoulstoneWatcherConfig.enable_at_ready == true then
        enableCheckBoxReady:SetChecked(true)
    end

    if SoulstoneWatcherConfig.enable_at_ready == false then
        enableCheckBoxReady:SetChecked(false)
    end

    if SoulstoneWatcherConfig.enable_at_join == nil then
        SoulstoneWatcherConfig.enable_at_join = true
    end

    if SoulstoneWatcherConfig.enable_at_join == true then
        enableCheckBoxJoin:SetChecked(true)
    end

    if SoulstoneWatcherConfig.enable_at_join == false then
        enableCheckBoxJoin:SetChecked(false)
    end

    if SoulstoneWatcherConfig.say == nil then
        SoulstoneWatcherConfig.say = true
    end

    if SoulstoneWatcherConfig.say == true then
        messageCheckBoxSay:SetChecked(true)
    end

    if SoulstoneWatcherConfig.say == false then
        messageCheckBoxSay:SetChecked(false)
    end

    if SoulstoneWatcherConfig.say_to_raid == nil then
        SoulstoneWatcherConfig.say_to_raid = true
    end

    if SoulstoneWatcherConfig.say_to_raid == true then
        messageCheckBoxRaid:SetChecked(true)
    end

    if SoulstoneWatcherConfig.say_to_raid == false then
        messageCheckBoxRaid:SetChecked(false)
    end

    if SoulstoneWatcherConfig.say_to_party == nil then
        SoulstoneWatcherConfig.say_to_party = true
    end
    if SoulstoneWatcherConfig.say_to_party == true then
        messageCheckBoxParty:SetChecked(true)
    end
    if SoulstoneWatcherConfig.say_to_party == false then
        messageCheckBoxParty:SetChecked(false)
    end

    if SoulstoneWatcherConfig.show_cast_buttons == nil then
        SoulstoneWatcherConfig.show_cast_buttons = true
    end
    if SoulstoneWatcherConfig.show_cast_buttons == true then
        enableCheckBoxButtons:SetChecked(true)
    end
    if SoulstoneWatcherConfig.show_cast_buttons == false then
        enableCheckBoxButtons:SetChecked(false)
    end

    if SoulstoneWatcherConfig.soulstone_itemid == nil then
        SoulstoneWatcherConfig.soulstone_itemid = 36895
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 5232 then
        UIDropDownMenu_SetText(dropDownRaid, "Minor Soulstone")
        SPELL_ID = 20707
        castButton1:SetAttribute("item", "item:5232")
        castButton2:SetAttribute("item", "item:5232")
        castButton3:SetAttribute("item", "item:5232")
        castButton4:SetAttribute("item", "item:5232")
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 16892 then
        UIDropDownMenu_SetText(dropDownRaid, "Lesser Soulstone")
        SPELL_ID = 20762
        castButton1:SetAttribute("item", "item:16892")
        castButton2:SetAttribute("item", "item:16892")
        castButton3:SetAttribute("item", "item:16892")
        castButton4:SetAttribute("item", "item:16892")
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 16893 then
        UIDropDownMenu_SetText(dropDownRaid, "Soulstone")
        SPELL_ID = 20763
        castButton1:SetAttribute("item", "item:16893")
        castButton2:SetAttribute("item", "item:16893")
        castButton3:SetAttribute("item", "item:16893")
        castButton4:SetAttribute("item", "item:16893")
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 16895 then
        UIDropDownMenu_SetText(dropDownRaid, "Greater Soulstone")
        SPELL_ID = 20764
        castButton1:SetAttribute("item", "item:16895")
        castButton2:SetAttribute("item", "item:16895")
        castButton3:SetAttribute("item", "item:16895")
        castButton4:SetAttribute("item", "item:16895")
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 16896 then
        UIDropDownMenu_SetText(dropDownRaid, "Major Soulstone")
        SPELL_ID = 20765
        castButton1:SetAttribute("item", "item:16896")
        castButton2:SetAttribute("item", "item:16896")
        castButton3:SetAttribute("item", "item:16896")
        castButton4:SetAttribute("item", "item:16896")
    end


    if SoulstoneWatcherConfig.soulstone_itemid == 22116 then
        UIDropDownMenu_SetText(dropDownRaid, "Master Soulstone")
        SPELL_ID = 27239
        castButton1:SetAttribute("item", "item:22116")
        castButton2:SetAttribute("item", "item:22116")
        castButton3:SetAttribute("item", "item:22116")
        castButton4:SetAttribute("item", "item:22116")
    end

    if SoulstoneWatcherConfig.soulstone_itemid == 36895 then
        UIDropDownMenu_SetText(dropDownRaid, "Demonic Soulstone")
        SPELL_ID = 47883
        castButton1:SetAttribute("item", "item:36895")
        castButton2:SetAttribute("item", "item:36895")
        castButton3:SetAttribute("item", "item:36895")
        castButton4:SetAttribute("item", "item:36895")
    end

    if SoulstoneWatcherConfig.main_target == nil then
        SoulstoneWatcherConfig.main_target = ""
    end
    local displayTarget = SoulstoneWatcherConfig.main_target ~= "" and SoulstoneWatcherConfig.main_target or "None"
    UIDropDownMenu_SetText(dropDownMainTarget, displayTarget)

    if not triggerEventFrame then
        triggerEventFrame = CreateFrame("Frame")
        triggerEventFrame:SetScript("OnEvent", OnEvent)
    end

    -- Unregister all events first to avoid duplicates
    triggerEventFrame:UnregisterAllEvents()

    if SoulstoneWatcherConfig.enable_at_ready == nil then
        SoulstoneWatcherConfig.enable_at_ready = true
    end
    if SoulstoneWatcherConfig.enable_at_ready == true then
        triggerEventFrame:RegisterEvent("READY_CHECK")
    end
    if SoulstoneWatcherConfig.enable_at_join == nil then
        SoulstoneWatcherConfig.enable_at_join = true
    end 
    if SoulstoneWatcherConfig.enable_at_join == true then
        triggerEventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
    end
end

cooldownEventFrame = CreateFrame("Frame")
cooldownEventFrame:RegisterEvent("SPELL_UPDATE_USABLE")
cooldownEventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
cooldownEventFrame:SetScript("OnEvent", cooldownCheck)

local function versionCheck(self, event, pre, text)
    if event == "CHAT_MSG_ADDON" and pre == prefix and tonumber(text) > versionNumber and versionMsgSent == false then
        print("|cff8788EESoulstone Watcher: New Addon version available")
        versionMsgSent = true
    end
end

local readAddonMsg = CreateFrame("Frame")
readAddonMsg:RegisterEvent("CHAT_MSG_ADDON")
readAddonMsg:SetScript("OnEvent", versionCheck)

local sendAddonVersion = CreateFrame("Frame")
sendAddonVersion:RegisterEvent("PLAYER_ENTERING_WORLD")
sendAddonVersion:SetScript("OnEvent", function(self, event, pre, text)
    SendAddonMessage(prefix, versionNumber, "RAID")
    SendAddonMessage(prefix, versionNumber, "GUILD")
end)

if classIndex == 9 then
    local spellEventFrame = CreateFrame("Frame")
    spellEventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    spellEventFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
    spellEventFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4)
                -- WotLK 3.3.5a: UNIT_SPELLCAST_SENT(unit, spellName, rank, target)
                --                UNIT_SPELLCAST_SUCCEEDED(unit, spellName, rank)
                if (event == "UNIT_SPELLCAST_SENT" and arg1 == "player") then
                    castTargetPlayer = arg4;
                elseif (event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" and arg2 == "Soulstone Resurrection") then
                    if castTargetPlayer == nil then return end
                    print("|cff8788EESoulstone Watcher: Casted Soulstone on "..castTargetPlayer)
                    msgSent = false
                    castButton1:Hide()
                    castButton2:Hide()
                    castButton3:Hide()
                    castButton4:Hide()
                    castButtonClear:Hide()
                    if SoulstoneWatcherConfig.say == true and UnitInParty("player") ~= nil then
                        SendChatMessage("Casted Soulstone on "..castTargetPlayer, "SAY")
                        return
                    end
                    if SoulstoneWatcherConfig.say_to_raid == true and UnitInRaid("player") ~= nil then
                        SendChatMessage("Casted Soulstone on "..castTargetPlayer, "RAID")
                        return
                    end
                    if SoulstoneWatcherConfig.say_to_party == true and UnitInParty("player") ~= nil then
                        SendChatMessage("Casted Soulstone on "..castTargetPlayer, "PARTY")
                        return
                    end
                end
    end)
end
