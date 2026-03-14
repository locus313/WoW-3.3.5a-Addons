-- Advanced Trade Skill Window v0.7.7
-- copyright 2006 by Rene Schneider (Slarti on EU-Blackhand)

-- main script file


ATSW_TRADE_SKILLS_DISPLAYED = 23;
ATSW_MAX_TRADE_SKILL_REAGENTS = 8;
ATSW_TRADE_SKILL_HEIGHT = 16;
ATSW_MAX_DELAY = 4.0;
ATSW_MAX_RETRIES = 5;

ATSWTypeColor = { };
ATSWTypeColor["optimal"] = { r = 1.00, g = 0.50, b = 0.25, font = GameFontNormalLeftOrange };
ATSWTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00, font = GameFontNormalLeftYellow };
ATSWTypeColor["easy"] = { r = 0.25, g = 0.75, b = 0.25, font = GameFontNormalLeftLightGreen };
ATSWTypeColor["trivial"] = { r = 0.50, g = 0.50, b = 0.50, font = GameFontNormalLeftGrey };
ATSWTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0, font = GameFontNormalLeft };

ATSWRarityColor={};
ATSWRarityColor[5] = { r = 0.64, g = 0.21, b = 0.93 };
ATSWRarityColor[4] = { r = 0, g = 0.44, b = 0.87 };
ATSWRarityColor[3] = { r = 0.12, g = 1, b = 0 };
ATSWRarityColor[2] = { r = 1, g = 1, b = 1 };
ATSWRarityColor[1] = { r = 0.62, g = 0.62, b = 0.62 };

ATSWRarityNames={};
ATSWRarityNames["purple"]=5;
ATSWRarityNames["blue"]=4;
ATSWRarityNames["green"]=3;
ATSWRarityNames["white"]=2;
ATSWRarityNames["grey"]=1;


atsw_tradeskilllist={};
local atsw_tradeskillheaders={};
local atsw_skilllisting={};
local atsw_tradeskillcountcache={};
local atsw_tradeskillcountwithinventorycache={};
atsw_selectedskill="";
local atsw_displayedgroup="";
local atsw_retries=0;
local atsw_retrydelay=0;
local atsw_retry=false;
local atsw_delay=0;
local atsw_working=false;
local atsw_processingtimeout=0;
local atsw_scans=0;
local atsw_updatedelay=0;
local atsw_uncategorizedexpanded=true;
local atsw_tradeskillid={};
local atsw_currentinvslotfilter={};
local atsw_invslotfilter={};
local atsw_invslotfiltered={};
local atsw_currentsubclassfilter={};
local atsw_subclassfilter={};
local atsw_subclassfiltered={};
local atsw_updating=false;
local atsw_incombat=false;
local atsw_bankopened=false;
local atsw_queueditemlist={};
local atsw_temporaryitemlist={};
atsw_queue={};
local atsw_preventupdate=false;
local atsw_iscurrentlyenabled=false;
local atsw_processingname="";
local atsw_processing=false;
local atsw_processnext=false;
local atsw_lastremoved="";
local atsw_missingitems={};
local atsw_necessaryitems={};
local atsw_filter="";
local atsw_scan_timeout=0;
local atsw_scan_state=0;
local atsw_scan_delay=0.1;
local atsw_scan_numtradeskills=0;
local atsw_scan_nextskill=0;
atsw_itemlist={};
atsw_orderby={};
atsw_disabled={};
atsw_savedqueue={};
atsw_savednecessaryitems={};
atsw_is_sorted=false;
atsw_prescanned={};
atsw_newrecipelinks=true;
atsw_onlycreatable=false;

function ATSW_OnLoad()
	SLASH_ATSW1 = "/atsw";
	SlashCmdList["ATSW"] = ATSW_Command;
	ATSWFrame:RegisterEvent("TRADE_SKILL_UPDATE");
	ATSWFrame:RegisterEvent("TRADE_SKILL_CLOSE");
	ATSWFrame:RegisterEvent("TRADE_SKILL_SHOW");
	ATSWFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	ATSWFrame:RegisterEvent("UPDATE_TRADESKILL_RECAST");
	ATSWFrame:RegisterEvent("BANKFRAME_OPENED");
	ATSWFrame:RegisterEvent("BANKFRAME_CLOSED");
	ATSWFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	ATSWFrame:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	ATSWFrame:RegisterEvent("MERCHANT_SHOW");
	ATSWFrame:RegisterEvent("MERCHANT_UPDATE");
	ATSWFrame:RegisterEvent("MERCHANT_CLOSED");
	ATSWFrame:RegisterEvent("BAG_UPDATE");
	ATSWFrame:RegisterEvent("TRAINER_CLOSED");
	ATSWFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	ATSWFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	ATSWFrame:RegisterEvent("AUCTION_HOUSE_CLOSED");
	ATSWFrame:RegisterEvent("AUCTION_HOUSE_SHOW");
	ATSWFrame:RegisterEvent("CRAFT_SHOW");
	ATSWFrame:RegisterEvent("CRAFT_CLOSE");
	ATSWFrame:RegisterEvent("PLAYER_LOGOUT");
	ATSWFrame:RegisterEvent("UI_ERROR_MESSAGE");
end

function ATSW_ShowWindow()
	if(type(atsw_orderby)~="table") then atsw_orderby={}; end
	if(not atsw_orderby[UnitName("player")]) then atsw_orderby[UnitName("player")]={}; end
	if(not atsw_orderby[UnitName("player")][atsw_selectedskill]) then atsw_orderby[UnitName("player")][atsw_selectedskill]="nothing"; end
	--if(atsw_oldmode and atsw_orderby[UnitName("player")][atsw_selectedskill]=="nothing") then 
	--	atsw_orderby[UnitName("player")][atsw_selectedskill]="name";
	--end
	atsw_oldtradeskillcount=0;
	atsw_is_sorted=false;
	if(atsw_subclassfiltered[atsw_selectedskill]==nil) then atsw_subclassfiltered[atsw_selectedskill]={}; end
	if(atsw_invslotfiltered[atsw_selectedskill]==nil) then atsw_invslotfiltered[atsw_selectedskill]={}; end
	ShowUIPanel(ATSWCheckerFrame);
	ShowUIPanel(ATSWFrame);
	SetPortraitTexture(ATSWFramePortrait, "player");
	--if(not atsw_oldmode) then
		ExpandTradeSkillSubClass(0);
		if(GetTradeSkillSelectionIndex()>1) then
			ATSWFrame_SetSelection(GetTradeSkillSelectionIndex());
		else
			if(GetNumTradeSkills()>0) then
				ATSWFrame_SetSelection(GetFirstTradeSkill());
				FauxScrollFrame_SetOffset(ATSWListScrollFrame, 0);
			end
			ATSWListScrollFrameScrollBar:SetValue(0);
		end
	--end
	ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), GetTradeSkillLine()).." - "..ATSW_VERSION);
	ATSW_AdjustFrame();
	ATSW_ResetPossibleItemCounts();
	ATSW_CreateTradeSkillList();
	ATSW_CreateSkillListing();
	ATSWInv_UpdateItemList();
	ATSWFrame_UpdateQueue();
	ATSWInv_UpdateQueuedItemList();
	ATSWFrame_Update();
	ATSWInputBox:SetText("1");
	atsw_updatedelay=0.5;
end

function ATSW_HideWindow()
	ATSW_SaveQueue(false);
	atsw_processing=false;
	if(AC_Craft and AC_Craft:GetParent()==ATSWFrame and TradeSkillFrame~=nil) then -- for ArmorCraft and atsw_oldmode==false
		AC_Craft:SetParent(TradeSkillFrame);
		AC_Craft:SetPoint("TOPLEFT","TradeSkillFrame","TOPRIGHT",-40,100);
		AC_Craft:SetFrameLevel(0);
		AC_ToggleButton:SetParent(TradeSkillFrame);
		AC_ToggleButton:SetFrameLevel(TradeSkillFrame:GetFrameLevel()+3);
		AC_ToggleButton:SetPoint("RIGHT","TradeSkillFrameCloseButton","LEFT")
		AC_UseButton:SetPoint("RIGHT","AC_ToggleButton","LEFT");
		AC_UseButton:SetFrameLevel(TradeSkillFrame:GetFrameLevel()+3);
	end
	ATSWQueueStartStopButton:Enable();
	ATSWQueueDeleteButton:Enable();
	HideUIPanel(ATSWFrame);
end

function ATSW_GetSelectedSkill()
	atsw_selectedskill=GetTradeSkillLine();
	if(not atsw_disabled[UnitName("player")]) then
		atsw_disabled[UnitName("player")]={};
	end
	if(not atsw_disabled[UnitName("player")][atsw_selectedskill]) then
		atsw_disabled[UnitName("player")][atsw_selectedskill]=0;
	end
end

function ATSW_CheckForRescan()
	atsw_scans=0;
	skillname=GetTradeSkillLine();
	if(skillname) then
		if(skillname~=atsw_displayedgroup) then
			if(atsw_displayedgroup~="") then
				ATSW_SaveQueue(false);
			end
			atsw_displayedgroup=skillname;
			atsw_selectedskill=skillname;
			ATSW_RestoreQueue();
			ATSW_CreateTradeSkillList();
			ATSW_NoteNecessaryItemsForQueue();
		end
	end
	if(ls3dci_guiTradeButton and ls3dci_guiTradeButton:IsVisible() and ls3dci_guiTradeButton:GetParent()~=ATSWFrame) then -- for LS3D craft info
		ls3dci_guiTradeButton:SetParent(ATSWFrame);
		ls3dci_guiTradePostButton:SetParent(ATSWFrame);
		ls3dci_guiTradeWatchButton:SetParent(ATSWFrame);
		ls3dci_guiTradeButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+50, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradePostButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+156, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradeWatchButton:SetPoint("BOTTOM", "ATSWFrame", "TOP", ls3dci_optVars.buttonPos[1]+262, ls3dci_optVars.buttonPos[2]-554);
		ls3dci_guiTradeButton:SetAlpha(1.0);
		ls3dci_guiTradePostButton:SetAlpha(1.0);
		ls3dci_guiTradeWatchButton:SetAlpha(1.0);
	end
	if(AC_Craft and AC_Craft:GetParent()~=ATSWFrame) then -- for ArmorCraft
		AC_Craft:SetParent(ATSWFrame);
		AC_Craft:SetPoint("TOPLEFT","ATSWFrame","TOPRIGHT",-40,0);
		AC_Craft:SetFrameLevel(0);
		AC_ToggleButton:SetParent(ATSWFrame);
		AC_ToggleButton:SetFrameLevel(ATSWFrame:GetFrameLevel()+3);
		AC_ToggleButton:SetPoint("RIGHT","ATSWFrameCloseButton","LEFT")
		AC_UseButton:SetFrameLevel(ATSWFrame:GetFrameLevel()+3);
		AC_UseButton:SetPoint("RIGHT","AC_ToggleButton","LEFT");
		AC_Craft:SetAlpha(1.0);
		AC_ToggleButton:SetAlpha(1.0);
		AC_UseButton:SetAlpha(1.0);
	end
end

function ATSW_OnHide()
	--if(not atsw_oldmode) then 
		TradeSkillFrame_Hide(); 
	--else
	--	CraftFrame_Hide();
	--end
	HideUIPanel(ATSWCheckerFrame);
	HideUIPanel(ATSWReagentFrame);
	HideUIPanel(ATSWCSFrame);
	atsw_displayedgroup="";
	atsw_selectedskill="";
end

function ATSW_Command(cmd)
	if(cmd=="show") then
		ATSW_ShowWindow();
	elseif(cmd=="disable") then
		ATSW_DisableForActiveTradeskill();
	elseif(cmd=="enable") then
		ATSW_EnableForActiveTradeskill();
	elseif(cmd=="reagents") then
		ShowUIPanel(ATSWAllReagentListFrame);
	elseif(cmd=="deletequeues") then
		atsw_savedqueue={};
		atsw_savednecessaryitems={};
		ATSW_DisplayMessage(ATSW_QUEUESDELETED);
	end
end

function ATSW_DisableForActiveTradeskill()
	--if(atsw_oldmode) then
	--	if(CraftFrame and CraftFrame:IsVisible()) then
	--		atsw_disabled[UnitName("player")][atsw_selectedskill]=1;
	--		ATSW_IsEnabled();
	--		HideUIPanel(ATSWFrame);
	--		ATSW_ShowBlizzardCraftFrame();
	--		ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_DEACTIVATED);
	--	end
	--else
		if(TradeSkillFrame and TradeSkillFrame:IsVisible()) then
			atsw_disabled[UnitName("player")][atsw_selectedskill]=1;
			ATSW_IsEnabled();
			HideUIPanel(ATSWFrame);
			ATSW_ShowBlizzardTradeSkillFrame();
			ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_DEACTIVATED);
		end
	--end	
end

function ATSW_EnableForActiveTradeskill()
	--if(atsw_oldmode) then
	--	if(CraftFrame and CraftFrame:IsVisible()) then
	--		atsw_disabled[UnitName("player")][atsw_selectedskill]=0;
	--		ATSW_IsEnabled();
	--		ATSW_ShowWindow();
	--		ATSW_HideBlizzardCraftFrame();
	--		ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_ACTIVATED);
	--	end
	--else
		if(TradeSkillFrame and TradeSkillFrame:IsVisible()) then
			atsw_disabled[UnitName("player")][atsw_selectedskill]=0;
			ATSW_IsEnabled();
			ATSW_ShowWindow();
			ATSW_HideBlizzardTradeSkillFrame();
			ATSW_DisplayMessage(ATSW_ACTIVATIONMESSAGE.." "..ATSW_ACTIVATED);
		end
	--end
end

function ATSWFrame_Show()
	ATSW_ShowWindow();
end

function ATSW_CheckForTradeSkillWindow(arg1)
	if(ATSWFrame:IsVisible()) then
		if(atsw_updatedelay>0) then
			atsw_updatedelay=atsw_updatedelay-arg1;
			if(atsw_updatedelay<=0) then
				ATSWFrame_Update();
				atsw_updatedelay=0;
			end
		end
		ATSW_CheckForRescan();
	end
	if(atsw_processnext==true) then 
		atsw_processnext=false;
		ATSW_ProcessNextQueueItem();
	end
	if(atsw_processing==true) then
		if(atsw_processingtimeout~=0) then
			if(atsw_processingtimeout>0) then
				atsw_processingtimeout=atsw_processingtimeout-arg1;
			else
				atsw_processingtimeout=0;
				ATSWQueueStartStopButton:Enable();
				ATSWQueueDeleteButton:Enable();
				ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
				atsw_processing=false;
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
				ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			end
		end
		if(atsw_retry==true) then
			if(atsw_retrydelay<ATSW_MAX_DELAY) then
				atsw_retrydelay=atsw_retrydelay+arg1;
			else
				atsw_retrydelay=0;
				ATSW_ProcessNextQueueItem();
			end
		end		
	end
end

function ATSW_IsEnabled()
	if((atsw_disabled[UnitName("player")][atsw_selectedskill]==0 and not IsShiftKeyDown()) or (atsw_disabled[UnitName("player")][atsw_selectedskill]==1 and IsShiftKeyDown())) then
		atsw_iscurrentlyenabled=true;
		return true;
	else
		atsw_iscurrentlyenabled=false;
		return false;
	end
end

function ATSW_IsCurrentlyEnabled()
	return atsw_iscurrentlyenabled;
end

function ATSW_HideBlizzardTradeSkillFrame()
	TradeSkillFrame:SetAlpha(0);
	TradeSkillFrame:ClearAllPoints();
	TradeSkillFrame:SetPoint("TOPLEFT", 0, 900);
end

function ATSW_ShowBlizzardTradeSkillFrame()
	TradeSkillFrame:SetAlpha(1);
	TradeSkillFrame:ClearAllPoints();
end

function ATSWFrame_OnEvent()
	if(event=="TRADE_SKILL_SHOW") then
		--if(CraftFrame and CraftFrame:IsVisible()) then ATSW_HideWindow(); end
		--atsw_oldmode=false;
		ATSW_GetSelectedSkill();
		if(ATSW_IsEnabled()) then
			local version,build,date=GetBuildInfo();
			local locale=GetLocale();
			if(IsTradeSkillLinked() or (atsw_prescanned[atsw_selectedskill]==build..locale and not IsAltKeyDown())) then
				ATSW_ShowWindow();
			else
				ATSW_InitSlowScan();
			end
		else
			ATSW_ShowBlizzardTradeSkillFrame();
			--HideUIPanel(ATSWFrame);
		end
	elseif(event=="TRADE_SKILL_CLOSE") then
		ATSW_HideWindow();
	--elseif(event=="CRAFT_SHOW") then
	--	if(TradeSkillFrame and TradeSkillFrame:IsVisible()) then ATSW_HideWindow(); end
	--	atsw_oldmode=true;
	--	local name=GetCraftDisplaySkillLine();
	--	if(name) then 
	--		ATSW_GetSelectedSkill();
	--		if(ATSW_IsEnabled()) then
	--			local version,build,date=GetBuildInfo();
	--			local locale=GetLocale();
	--			if(atsw_prescanned[atsw_selectedskill]==build..locale and not IsAltKeyDown()) then
	--				ATSW_ShowWindow();
	--			else
	--				ATSW_InitSlowScan();
	--			end
	--		else
	--			ATSW_ShowBlizzardCraftFrame();
	--			--HideUIPanel(ATSWFrame);
	--		end
	--	end
	--elseif(event=="CRAFT_CLOSE") then
	--	ATSW_HideWindow();
	elseif(event=="BANKFRAME_OPENED") then
		atsw_bankopened=true;
		ATSWBank_UpdateBankList();
		if(atsw_displayreagentlist==true) then
			ATSWAllReagentList_OpenBankFrame();
		end
		if(ATSWAllReagentListFrame:IsVisible()) then
			ATSWARLFGetFromBankButton:Enable();
		end
	elseif(event=="BANKFRAME_CLOSED") then
		atsw_bankopened=false;
		if(ATSWAllReagentListFrame:IsVisible()) then
			ATSWARLFGetFromBankButton:Disable();
		end
		if(atsw_displayreagentlist==true) then
			ATSWAllReagentList_CloseBankFrame();
		end
	elseif(event=="PLAYERBANKSLOTS_CHANGED") then
		ATSWBank_UpdateBankList();
	elseif(event=="PLAYERBANKBAGSLOTS_CHANGED") then
		ATSWBank_UpdateBankList();
	elseif(event=="MERCHANT_SHOW") then
		ATSWMerchant_InsertAutoBuyButton();
		ATSWMerchant_UpdateMerchantList();
		ATSWMerchant_AutoBuy();
	elseif(event=="MERCHANT_CLOSED") then
		ATSWMerchant_RemoveAutoBuyButton();
	elseif(event=="MERCHANT_UPDATE") then
		ATSWMerchant_UpdateMerchantList();
	elseif(event=="AUCTION_HOUSE_SHOW") then
		ATSWAuction_ShowShoppingList();
	elseif(event=="AUCTION_HOUSE_CLOSED") then
		ATSWAuction_HideShoppingList();
	elseif(event=="BAG_UPDATE") then
		if(ATSWFrame:IsVisible()) then
			if(atsw_processing==true) then
				if(table.getn(atsw_queue)==0) then
					atsw_processingtimeout=-1;
				end
			end
			atsw_retries=0;
			atsw_retrydelay=ATSW_MAX_DELAY;
		end
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateItemList();
		ATSWBank_UpdateBankList();
		if(GetTradeSkillSelectionIndex()>0 and ATSWFrame:IsVisible()) then
			ATSWFrame_SetSelection(GetTradeSkillSelectionIndex());
		end
	end
	if(not ATSWFrame:IsVisible()) then
		return;
	end
	if(TradeSkillFrame and TradeSkillFrame:IsVisible() and ATSW_IsCurrentlyEnabled()) then
		ATSW_HideBlizzardTradeSkillFrame();
	end
	if(event=="TRADE_SKILL_UPDATE") then
		--ATSW_DisplayMessage(GetTime().."TRADE_SKILL_UPDATE");
		if(atsw_scans<2) then
			atsw_scans=atsw_scans+1;
			ATSW_CreateTradeSkillList();
			ATSWCreateButton:Disable();
			ATSWQueueButton:Disable();
			ATSWCreateAllButton:Disable();
			ATSWQueueAllButton:Disable();
			ATSWHighlightFrame:Hide();
			if(GetTradeSkillSelectionIndex()>0) then
				ATSWFrame_SetSelection(GetTradeSkillSelectionIndex());
			else
				if(GetNumTradeSkills()>0) then
					ATSWFrame_SetSelection(GetFirstTradeSkill());
					FauxScrollFrame_SetOffset(ATSWListScrollFrame, 0);
				end
				ATSWListScrollFrameScrollBar:SetValue(0);
			end
			if(atsw_updating==false) then
				ATSW_ResetPossibleItemCounts();
				ATSW_CreateSkillListing();
				ATSWFrame_Update(); 
			end
		end
	elseif(event=="UNIT_PORTRAIT_UPDATE") then
		if(arg1=="player") then
			SetPortraitTexture(ATSWFramePortrait, "player");
		end
	elseif(event=="UPDATE_TRADESKILL_RECAST") then
		ATSWInputBox:SetNumber(GetTradeskillRepeatCount());
	elseif(event=="UNIT_SPELLCAST_STOP" or event=="UNIT_SPELLCAST_CHANNEL_STOP") then
		if(arg1=="player") then ATSW_SpellcastStop(); end
	elseif(event=="UNIT_SPELLCAST_START") then
		if(arg1=="player") then	ATSW_SpellcastStart(); end
	elseif(event=="UNIT_SPELLCAST_INTERRUPTED") then
		if(arg1=="player") then ATSW_SpellcastInterrupted(); end
	elseif(event=="TRAINER_CLOSED") then
		ATSW_ResetPossibleItemCounts();
		ATSW_CreateSkillListing();
		if(ATSWFrame:IsVisible()) then ATSWFrame_Update(); end
	elseif(event=="PLAYER_REGEN_ENABLED") then
		atsw_incombat=false;
	elseif(event=="PLAYER_REGEN_DISABLED") then
		atsw_incombat=true;
	elseif(event=="PLAYER_LOGOUT") then
		ATSW_SaveQueue(false);
	elseif(event=="UI_ERROR_MESSAGE") then
		if(ATSWFrame:IsVisible()) then
			if(arg1==INVENTORY_FULL) then
				ATSW_SpellcastInterrupted();
			end
			if(string.find(arg1,string.sub(SPELL_FAILED_REAGENTS,1,string.len(SPELL_FAILED_REAGENTS)-2),1,true)~=nil) then
				ATSW_SpellcastInterrupted();
			end
			if(string.find(arg1,string.sub(SPELL_FAILED_REQUIRES_SPELL_FOCUS,1,string.len(SPELL_FAILED_REQUIRES_SPELL_FOCUS)-4),1,true)~=nil) then
				ATSW_SpellcastInterrupted();
			end
		end
	end
end

function ATSW_AdjustFrame()
	--if(atsw_oldmode) then
	--	ATSWHeaderSortButton:Hide();
	--	ATSWInvSlotDropDown:Hide();
	--	ATSWSubClassDropDown:Hide();
	--	ATSWExpandButtonFrame:Hide();
	--	ATSWCreateButton:Hide();
	--	ATSWQueueButton:Hide();
	--	ATSWCreateAllButton:Hide();
	--	ATSWQueueAllButton:Hide();
	--	ATSWDecrementButton:Hide();
	--	ATSWInputBox:Hide();
	--	ATSWIncrementButton:Hide();
	--	ATSWQueueStartStopButton:Hide();
	--	ATSWQueueDeleteButton:Hide();
	--	ATSWReagentsButton:Hide();
	--	ATSWHorizontalBarLeft:Hide();
	--	ATSWHorizontalBarLeft2:Hide();
	--	ATSWHorizontalBarLeftAddon:Hide();
	--	ATSWHorizontalBarLeft2Addon:Hide();
---
--		ATSWEnchantButton:Show();
--		ATSWReagentLabel:SetPoint("TOPLEFT", "ATSWFrame", "TOPLEFT" , 380, -180);
--		ATSWCraftDescription:Show();
--	else
		ATSWHeaderSortButton:Show();
		ATSWInvSlotDropDown:Show();
		ATSWSubClassDropDown:Show();
		ATSWExpandButtonFrame:Show();
		ATSWCreateButton:Show();
		ATSWQueueButton:Show();
		ATSWCreateAllButton:Show();
		ATSWQueueAllButton:Show();
		ATSWDecrementButton:Show();
		ATSWInputBox:Show();
		ATSWIncrementButton:Show();
		ATSWQueueStartStopButton:Show();
		ATSWQueueDeleteButton:Show();
		ATSWReagentsButton:Show();
		ATSWHorizontalBarLeft:Show();
		ATSWHorizontalBarLeft2:Show();
		ATSWHorizontalBarLeftAddon:Show();
		ATSWHorizontalBarLeft2Addon:Show();

		ATSWEnchantButton:Hide();
		ATSWReagentLabel:SetPoint("TOPLEFT", "ATSWFrame", "TOPLEFT" , 380, -136);
		ATSWCraftDescription:Hide();
--	end
	if(IsTradeSkillLinked()) then
		ATSWCreateButton:Disable();
		ATSWCreateAllButton:Disable();
		ATSWDecrementButton:Disable();
		ATSWInputBox:Hide();
		ATSWIncrementButton:Disable();
		ATSWTradeSkillLinkButton:Hide();
		ATSWCreateAllButton:Disable();
		ATSWQueueAllButton:Disable();
		ATSWQueueStartStopButton:Disable();
		ATSWQueueDeleteButton:Disable();
		ATSWReagentsButton:Disable();
	else
		ATSWCreateButton:Enable();
		ATSWCreateAllButton:Enable();
		ATSWDecrementButton:Enable();
		ATSWInputBox:Show();
		ATSWIncrementButton:Enable();
		ATSWTradeSkillLinkButton:Show();
		ATSWCreateAllButton:Enable();
		ATSWQueueAllButton:Enable();
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWReagentsButton:Enable();
	end
end

function ATSW_SortTradeSkills()
	local tradeskills={};
	ExpandTradeSkillSubClass(0);
	local numTradeSkills=GetNumTradeSkills();

	for i=1,numTradeSkills,1 do
		local skillName, skillType, numAvailable, isExpanded, altVerb = GetTradeSkillInfo(i);
		if(skillType~="header") then
			local skillTypeNumber=0;
			if(skillType=="easy") then skillTypeNumber=1; end
			if(skillType=="medium") then skillTypeNumber=2; end
			if(skillType=="optimal") then skillTypeNumber=3; end
			table.insert(tradeskills,{name=skillName,id=i,skilltype=skillTypeNumber,altVerb=altVerb});
		end
	end

	atsw_tradeskillid={};
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="name") then
		table.sort(tradeskills,ATSW_CompareName);
		for i=1,table.getn(tradeskills),1 do
			table.insert(atsw_tradeskillid,tradeskills[i].id);
		end
	end
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="difficulty") then
		table.sort(tradeskills,ATSW_CompareDifficulty);
		for i=1,table.getn(tradeskills),1 do
			table.insert(atsw_tradeskillid,tradeskills[i].id);
		end
	end
	atsw_is_sorted=true;
end

function ATSW_CompareName(i,j)
	return string.lower(i.name) < string.lower(j.name);
end

function ATSW_CompareDifficulty(i,j)
	return string.lower(i.skilltype) > string.lower(j.skilltype);
end

function ATSW_OrderBy(order)
	atsw_orderby[UnitName("player")][atsw_selectedskill]=order;
	atsw_is_sorted=false;
	ATSW_CreateSkillListing();
	ATSWFrame_Update();
end

function ATSWFrame_Update()
	if(not ATSWFrame:IsVisible()) then return; end
	if(type(atsw_orderby)~="table") then atsw_orderby={}; end
	if(not atsw_orderby[UnitName("player")]) then atsw_orderby[UnitName("player")]={}; end
	if(not atsw_orderby[UnitName("player")][atsw_selectedskill]) then atsw_orderby[UnitName("player")][atsw_selectedskill]="nothing"; end
	--if(atsw_oldmode and atsw_orderby[UnitName("player")][atsw_selectedskill]=="nothing") then 
	--	atsw_orderby[UnitName("player")][atsw_selectedskill]="name";
	--end
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="name") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(true);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(false);
	elseif(atsw_orderby[UnitName("player")][atsw_selectedskill]=="difficulty") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(true);
		ATSWCustomSortButton:SetChecked(false);
	elseif(atsw_orderby[UnitName("player")][atsw_selectedskill]=="custom") then
		ATSWHeaderSortButton:SetChecked(false);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(true);
	else
		ATSWHeaderSortButton:SetChecked(true);
		ATSWNameSortButton:SetChecked(false);
		ATSWDifficultySortButton:SetChecked(false);
		ATSWCustomSortButton:SetChecked(false);
	end
	for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
		getglobal("ATSWSkill"..i):Hide();
	end
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="nothing" or atsw_orderby[UnitName("player")][atsw_selectedskill]=="custom") then
		ATSWExpandButtonFrame:Show();
		local numTradeSkills=table.getn(atsw_skilllisting);
		local skillOffset=FauxScrollFrame_GetOffset(ATSWListScrollFrame);

		if(numTradeSkills==0) then
			ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), GetTradeSkillLine()).." - "..ATSW_VERSION);
			ATSWSkillName:Hide();
			ATSWSkillIcon:Hide();
			ATSWRequirementLabel:Hide();
			ATSWCollapseAllButton:Disable();
			for i=1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
				getglobal("ATSWReagent"..i):Hide();
			end
		else
			ATSWSkillName:Show();
			ATSWSkillIcon:Show();
			ATSWCollapseAllButton:Enable();
		end

		FauxScrollFrame_Update(ATSWListScrollFrame, numTradeSkills, ATSW_TRADE_SKILLS_DISPLAYED, ATSW_TRADE_SKILL_HEIGHT, nil, nil, nil, ATSWHighlightFrame, 293, 316);
		ATSWHighlightFrame:Hide();
		local jumped=1;
		for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
			local skillName, skillType, numAvailable, isExpanded;
			local skillIndex;
			repeat
				skillIndex=skillOffset+jumped;
				if(skillIndex>numTradeSkills) then
					skillName=nil;
				else
					skillName = atsw_skilllisting[skillIndex].name;
					skillType = atsw_skilllisting[skillIndex].type;
					isExpanded = atsw_skilllisting[skillIndex].expanded;
				end
				jumped=jumped+1;
			until ((skillName and ATSW_Filter(skillName)==true and ATSW_FilterInvSlot(skillName) and ATSW_FilterSubClass(skillName)) or skillIndex>numTradeSkills or skillType=="header");
			if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
			local skillButton=getglobal("ATSWSkill"..i);
			if(skillIndex<=numTradeSkills) then
				if(ATSWListScrollFrame:IsVisible()) then
					skillButton:SetWidth(293);
				else
					skillButton:SetWidth(323);
				end
				local color=ATSWTypeColor[skillType];
				if(color) then
					skillButton:SetNormalFontObject(color.font);
				end
				
				if(atsw_skilllisting[skillIndex] and atsw_skilllisting[skillIndex].id) then
					skillButton:SetID(atsw_skilllisting[skillIndex].id);
					skillButton:Enable();
				else
					skillButton:SetDisabledTexture("");
					skillButton:Disable();
					skillButton:SetText("DELETED: "..skillName);
					skillType="notfound";
				end
				skillButton:Show();
				if(skillType=="header") then
					skillButton:SetText(skillName);
					if(isExpanded) then
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
					else
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					end
					getglobal("ATSWSkill"..i.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
					getglobal("ATSWSkill"..i):UnlockHighlight();
				elseif(skillType~="notfound") then
					if(not skillName)then
						return;
					end
					skillButton:SetNormalTexture("");
					getglobal("ATSWSkill"..i.."Highlight"):SetTexture("");
					if(atsw_multicount==true) then
						if ( numAvailable == 0 ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailable.."]");
						end
					else
						local numAvailableString=ATSW_GetNumItemsPossibleWithInventory(skillName).."/"..numAvailable;
						if ( numAvailableString == "0/0" ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailableString.."]");
						end
					end
					
					if(GetTradeSkillSelectionIndex()==atsw_skilllisting[skillIndex].id) then
						ATSWHighlightFrame:SetPoint("TOPLEFT", "ATSWSkill"..i, "TOPLEFT", 0, 0);
						ATSWHighlightFrame:Show();
						ATSWFrame.numAvailable = numAvailable;
						getglobal("ATSWSkill"..i):LockHighlight();
					else
						getglobal("ATSWSkill"..i):UnlockHighlight();
					end
				end			
			else
				skillButton:Hide();
			end
		end
	end
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="name" or atsw_orderby[UnitName("player")][atsw_selectedskill]=="difficulty") then
		ATSWExpandButtonFrame:Hide();
		atsw_updating=true;
		if(atsw_is_sorted==false) then ATSW_SortTradeSkills(); end
		local numTradeSkills=table.getn(atsw_tradeskillid);
		local skillOffset=FauxScrollFrame_GetOffset(ATSWListScrollFrame);

		if(numTradeSkills==0) then
			ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), GetTradeSkillLine()).." - "..ATSW_VERSION);
			ATSWSkillName:Hide();
			ATSWSkillIcon:Hide();
			ATSWRequirementLabel:Hide();
			ATSWCollapseAllButton:Disable();
			for i=1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
				getglobal("ATSWReagent"..i):Hide();
			end
		else
			ATSWSkillName:Show();
			ATSWSkillIcon:Show();
			ATSWCollapseAllButton:Enable();
		end

		FauxScrollFrame_Update(ATSWListScrollFrame, numTradeSkills, ATSW_TRADE_SKILLS_DISPLAYED, ATSW_TRADE_SKILL_HEIGHT, nil, nil, nil, ATSWHighlightFrame, 293, 316);
		ATSWHighlightFrame:Hide();
		local jumped=1;
		for i=1,ATSW_TRADE_SKILLS_DISPLAYED,1 do
			local skillName, skillType, numAvailable, isExpanded, craftSubSpellName;
			local skillIndex;
			repeat
				skillIndex=atsw_tradeskillid[skillOffset+jumped];
				if(skillIndex==nil) then
					skillName=nil;
				else	
					skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex);
				end
				jumped=jumped+1;
			until (((skillName and ATSW_Filter(skillName)==true and ATSW_FilterInvSlot(skillName) and ATSW_FilterSubClass(skillName)) or skillIndex==nil) and skillType~="header");
			if(skillIndex) then
				skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex);
				if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
				local skillButton=getglobal("ATSWSkill"..i);
				if(ATSWListScrollFrame:IsVisible()) then
					skillButton:SetWidth(293);
				else
					skillButton:SetWidth(323);
				end
				local color=ATSWTypeColor[skillType];
				if(color) then
					skillButton:SetNormalFontObject(color.font);
				end
				
				skillButton:SetID(skillIndex);
				skillButton:Show();
				if(skillType=="header") then
					skillButton:SetText(skillName);
					if(isExpanded) then
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
					else
						skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
					end
					getglobal("ATSWSkill"..i.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
					getglobal("ATSWSkill"..i):UnlockHighlight();
				else
					if(not skillName)then
						return;
					end
					skillButton:SetNormalTexture("");
					getglobal("ATSWSkill"..i.."Highlight"):SetTexture("");
					if(atsw_multicount==true) then
						if ( numAvailable == 0 ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailable.."]");
						end
					else
						local numAvailableString=ATSW_GetNumItemsPossibleWithInventory(skillName).."/"..numAvailable;
						if ( numAvailableString == "0/0" ) then
							skillButton:SetText(" "..skillName);
						else
							skillButton:SetText(" "..skillName.." ["..numAvailableString.."]");
						end
					end
					
					if(GetTradeSkillSelectionIndex()==skillIndex) then
						ATSWHighlightFrame:SetPoint("TOPLEFT", "ATSWSkill"..i, "TOPLEFT", 0, 0);
						ATSWHighlightFrame:Show();
						ATSWFrame.numAvailable = numAvailable;
						getglobal("ATSWSkill"..i):LockHighlight();
					else
						getglobal("ATSWSkill"..i):UnlockHighlight();
					end
				end
			end
		end
		atsw_updating=false;
	end
end

function ATSWSkillButton_OnClick(button)
	if(button=="LeftButton") then
		ATSWFrame_SetSelection(this:GetID(),true);
		ATSWFrame_Update();
	end
end

function ATSWFrame_SetSelection(id,wasClicked)
	local skillName, skillType, numAvailable, altVerb;
	local listpos=ATSW_GetSkillListingPos(id);
	if(atsw_skilllisting[listpos]) then
		skillName = atsw_skilllisting[listpos].name;
		skillType = atsw_skilllisting[listpos].type;
		altVerb = atsw_skilllisting[listpos].altVerb;
	else
		skillName=nil;
	end
	if(skillName) then numAvailable=ATSW_GetNumItemsPossible(skillName); end
	if(IsShiftKeyDown() and skillName~=nil and wasClicked~=nil) then
		if(arg1=="LeftButton" and (ChatFrameEditBox:IsVisible() or WIM_EditBoxInFocus~=nil)) then
			ATSW_AddTradeSkillReagentLinksToChatFrame(skillName);
		end
	end
	ATSWHighlightFrame:Show();
	if(skillType=="header") then
		ATSWHighlightFrame:Hide();
		if(atsw_skilllisting[listpos].expanded) then
			ATSW_SetHeaderExpanded(id,false);
		else
			ATSW_SetHeaderExpanded(id,true);
		end
		ATSWFrame_Update();
		return;
	end
	ATSWFrame.selectedSkillName=skillName;
	ATSWFrame.selectedSkill = id;
	SelectTradeSkill(id);

	if(GetTradeSkillSelectionIndex()>GetNumTradeSkills())then
		return;
	end
	local color=ATSWTypeColor[skillType];
	if(color) then
		ATSWHighlight:SetVertexColor(color.r, color.g, color.b);
	end

	-- General Info
	local skillLineName, skillLineRank, skillLineMaxRank = GetTradeSkillLine();
	ATSWFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), skillLineName).." - "..ATSW_VERSION);
	-- Set statusbar info
	ATSWRankFrameSkillName:SetText(skillLineName);
	ATSWRankFrame:SetStatusBarColor(0.0, 0.0, 1.0, 0.5);
	ATSWRankFrameBackground:SetVertexColor(0.0, 0.0, 0.75, 0.5);
	ATSWRankFrame:SetMinMaxValues(0, skillLineMaxRank);
	ATSWRankFrame:SetValue(skillLineRank);
	ATSWRankFrameSkillRank:SetText(skillLineRank.."/"..skillLineMaxRank);

	ATSWSkillName:SetText(skillName);
	--if(atsw_oldmode and GetCraftDescription(id)) then
	--	ATSWCraftDescription:SetText(GetCraftDescription(id));
	--end
	if(GetTradeSkillCooldown(id)) then
		ATSWSkillCooldown:SetText(COOLDOWN_REMAINING.." "..SecondsToTime(GetTradeSkillCooldown(id)));
	else
		ATSWSkillCooldown:SetText("");
	end
	ATSWSkillIcon:SetNormalTexture(GetTradeSkillIcon(id));
	local minMade,maxMade = GetTradeSkillNumMade(id);
	if(maxMade>1) then
		if(minMade==maxMade) then
			ATSWSkillIconCount:SetText(minMade);
		else
			ATSWSkillIconCount:SetText(minMade.."-"..maxMade);
		end
		if(ATSWSkillIconCount:GetWidth()>39) then
			ATSWSkillIconCount:SetText("~"..floor((minMade + maxMade)/2));
		end
	else
		ATSWSkillIconCount:SetText("");
	end
	
	local creatable = 1;
	local numReagents = GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1 do
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
		local reagent = getglobal("ATSWReagent"..i);
		local name = getglobal("ATSWReagent"..i.."Name");
		local count = getglobal("ATSWReagent"..i.."Count");
		if(not reagentName or not reagentTexture) then
			reagent:Hide();
		else
			reagent:Show();
			SetItemButtonTexture(reagent, reagentTexture);
			name:SetText(reagentName);
			-- Grayout items
			if(playerReagentCount<reagentCount) then
				SetItemButtonTextureVertexColor(reagent, 0.5, 0.5, 0.5);
				name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			else
				SetItemButtonTextureVertexColor(reagent, 1.0, 1.0, 1.0);
				name:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			end
			if(playerReagentCount>=100) then
				playerReagentCount = "*";
			end
			count:SetText(playerReagentCount.." /"..reagentCount);
		end
	end
	local reagentToAnchorTo = numReagents;
	if((numReagents > 0) and (mod(numReagents, 2)==0)) then
		reagentToAnchorTo = reagentToAnchorTo - 1;
	end
	
	for i=numReagents+1, ATSW_MAX_TRADE_SKILL_REAGENTS, 1 do
		getglobal("ATSWReagent"..i):Hide();
	end

	local spellFocus=BuildColoredListString(GetTradeSkillTools(id));
	if(spellFocus) then
		ATSWRequirementLabel:Show();
		ATSWRequirementText:SetText(spellFocus);
	else
		ATSWRequirementLabel:Hide();
		ATSWRequirementText:SetText("");
	end

	if(creatable and not IsTradeSkillLinked()) then
		ATSWCreateButton:Enable();
		ATSWQueueButton:Enable();
		ATSWCreateAllButton:Enable();
		ATSWQueueAllButton:Enable();
		ATSWDecrementButton:Enable();
		ATSWIncrementButton:Enable();		
	else
		ATSWCreateButton:Disable();
		ATSWQueueButton:Disable();
		ATSWCreateAllButton:Disable();
		ATSWQueueAllButton:Disable();
		ATSWDecrementButton:Disable();
		ATSWIncrementButton:Disable();
	end

	if(not altVerb) then
		ATSWQueueStartStopButton:Show();
		ATSWQueueDeleteButton:Show();
		ATSWReagentsButton:Show();
		ATSWEnchantButton:Hide();
	else
		ATSWQueueStartStopButton:Hide();
		ATSWQueueDeleteButton:Hide();
		ATSWReagentsButton:Hide();
		ATSWEnchantButton:Show();
	end


	if(FRC_CraftFrame_SetSelection and FRC_TradeSkillFrame_SetSelection) then -- for Fizzwidgets ReagentCost
		--if(atsw_oldmode==false) then
			local ATSW_Orig_TradeSkillFrame_SetSelection=FRC_Orig_TradeSkillFrame_SetSelection;
			FRC_Orig_TradeSkillFrame_SetSelection=ATSW_NOP;
			FRC_TradeSkillFrame_SetSelection(id);
			FRC_Orig_TradeSkillFrame_SetSelection=ATSW_Orig_TradeSkillFrame_SetSelection;
			ATSWReagentLabel:SetText(TradeSkillReagentLabel:GetText());
		--else
		--	local ATSW_Orig_CraftFrame_SetSelection=FRC_Orig_CraftFrame_SetSelection;
		--	FRC_Orig_CraftFrame_SetSelection=ATSW_NOP;
		--	FRC_CraftFrame_SetSelection(id);
		--	FRC_Orig_CraftFrame_SetSelection=ATSW_Orig_CraftFrame_SetSelection;
		--	ATSWReagentLabel:SetText(CraftReagentLabel:GetText());
		--end
	end
end

function ATSWSubClassDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, ATSWSubClassDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 120);
	UIDropDownMenu_SetSelectedID(self, 1);
end

function ATSWSubClassDropDown_OnShow(self)
	UIDropDownMenu_Initialize(self, ATSWSubClassDropDown_Initialize);
	if(atsw_currentsubclassfilter[atsw_selectedskill]==nil or atsw_currentsubclassfilter[atsw_selectedskill]==0) then
		UIDropDownMenu_SetSelectedID(self, 1);
	end
end

function ATSWSubClassDropDown_Initialize()
	ATSWFilterFrame_LoadSubClasses(GetTradeSkillSubClasses());
end

function ATSWFilterFrame_LoadSubClasses(...)
	local info = UIDropDownMenu_CreateInfo();
	info.text = TEXT(ALL_SUBCLASSES);
	info.func = ATSWSubClassDropDownButton_OnClick;
	info.checked = false;
	if(atsw_currentsubclassfilter[atsw_selectedskill] and atsw_currentsubclassfilter[atsw_selectedskill]==0) then info.checked=true; end
	UIDropDownMenu_AddButton(info);
	
	local checked;
	for i=1, select("#", ...), 1 do
		if (atsw_currentsubclassfilter[atsw_selectedskill] and atsw_currentsubclassfilter[atsw_selectedskill]==0 and select("#", ...)>1) then
			checked = nil;
			UIDropDownMenu_SetText(ATSWSubClassDropDown, TEXT(ALL_SUBCLASSES));
		else
			if(atsw_currentsubclassfilter[atsw_selectedskill] and i==atsw_currentsubclassfilter[atsw_selectedskill]) then
				checked=true;
				UIDropDownMenu_SetText(ATSWSubClassDropDown, select(i, ...));
			else
				checked=false;
			end
		end
		info.text = select(i, ...);
		info.func = ATSWSubClassDropDownButton_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWInvSlotDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, ATSWInvSlotDropDown_Initialize);
	UIDropDownMenu_SetWidth(self, 120);
	UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, 1);
end

function ATSWInvSlotDropDown_OnShow(self)
	UIDropDownMenu_Initialize(self, ATSWInvSlotDropDown_Initialize);
	if(atsw_currentinvslotfilter[atsw_selectedskill]==nil or atsw_currentinvslotfilter[atsw_selectedskill]==0) then
		UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, 1);
	end
end

function ATSWInvSlotDropDown_Initialize()
	ATSWFilterFrame_LoadInvSlots(GetTradeSkillInvSlots());
end

function ATSWFilterFrame_LoadInvSlots(...)
	local info = UIDropDownMenu_CreateInfo();
	info.text = TEXT(ALL_INVENTORY_SLOTS);
	info.func = ATSWInvSlotDropDownButton_OnClick;
	info.checked = false;
	if(atsw_currentinvslotfilter[atsw_selectedskill]==0) then info.checked=true; end
	UIDropDownMenu_AddButton(info);
	
	local checked=false;
	for i=1, select("#", ...), 1 do
		if (atsw_currentinvslotfilter[atsw_selectedskill] and atsw_currentinvslotfilter[atsw_selectedskill]==0 and select("#", ...)>1) then
			checked = false;
			UIDropDownMenu_SetText(ATSWInvSlotDropDown, TEXT(ALL_INVENTORY_SLOTS));
		else
			if(atsw_currentinvslotfilter[atsw_selectedskill] and i==atsw_currentinvslotfilter[atsw_selectedskill]) then
				checked=true;
				UIDropDownMenu_SetText(ATSWInvSlotDropDown, select(i, ...));
			else
				checked=false;
			end
		end
		info.text = select(i, ...);
		info.func = ATSWInvSlotDropDownButton_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWSubClassDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(ATSWSubClassDropDown, self:GetID());
	if(self:GetID()==1) then
		atsw_subclassfilter[atsw_selectedskill]=nil;
		atsw_subclassfiltered[atsw_selectedskill]={};
		atsw_currentsubclassfilter[atsw_selectedskill]=0;
		ATSW_CreateSkillListing();
		ATSWFrame_Update();
	else
		atsw_subclassfilter[atsw_selectedskill]=self:GetID()-1;
		atsw_currentsubclassfilter[atsw_selectedskill]=atsw_subclassfilter[atsw_selectedskill];
		SetTradeSkillSubClassFilter(self:GetID() - 1, 1, 1);
	end
end

function ATSWInvSlotDropDownButton_OnClick(self)
	UIDropDownMenu_SetSelectedID(ATSWInvSlotDropDown, self:GetID());
	if(self:GetID()==1) then
		atsw_invslotfilter[atsw_selectedskill]=nil;
		atsw_invslotfiltered[atsw_selectedskill]={};
		atsw_currentinvslotfilter[atsw_selectedskill]=0;
		ATSW_CreateSkillListing();
		ATSWFrame_Update();
	else
		atsw_invslotfilter[atsw_selectedskill]=self:GetID()-1;
		atsw_currentinvslotfilter[atsw_selectedskill]=atsw_invslotfilter[atsw_selectedskill];
		SetTradeSkillInvSlotFilter(self:GetID() - 1, 1, 1);
	end
end

function ATSW_FilterInvSlot(skillName)
	if(atsw_currentinvslotfilter[atsw_selectedskill]==0 or atsw_currentinvslotfilter[atsw_selectedskill]==nil) then 
		return true; 
	end
	if(atsw_invslotfiltered[atsw_selectedskill][skillName]) then 
		return true;
	else
		return false;
	end	
end

function ATSW_FilterSubClass(skillName)
	if(atsw_currentsubclassfilter[atsw_selectedskill]==0 or atsw_currentsubclassfilter[atsw_selectedskill]==nil) then 
		return true; 
	end
	if(atsw_subclassfiltered[atsw_selectedskill][skillName]) then 
		return true;
	else
		return false;
	end	
end

function ATSWCollapseAllButton_OnClick()
	if (this.collapsed) then
		this.collapsed = nil;
		if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="custom") then
			if(atsw_customheaders[UnitName("player")]) then
				if(atsw_customheaders[UnitName("player")][atsw_selectedskill]) then
					for i=1,table.getn(atsw_customheaders[UnitName("player")][atsw_selectedskill]),1 do
						atsw_customheaders[UnitName("player")][atsw_selectedskill][i].expanded=true;
					end
				end
			end
			atsw_uncategorizedexpanded=true;
		else
			for i=1,table.getn(atsw_tradeskillheaders),1 do
				atsw_tradeskillheaders[i].expanded=true;
			end
		end
	else
		this.collapsed = 1;
		ATSWListScrollFrameScrollBar:SetValue(0);
		if(atsw_orderby[UnitName("player")][atsw_selectedskill]=="custom") then
			if(atsw_customheaders[UnitName("player")]) then
				if(atsw_customheaders[UnitName("player")][atsw_selectedskill]) then
					for i=1,table.getn(atsw_customheaders[UnitName("player")][atsw_selectedskill]),1 do
						atsw_customheaders[UnitName("player")][atsw_selectedskill][i].expanded=false;
					end
				end
			end
			atsw_uncategorizedexpanded=false;
		else
			for i=1,table.getn(atsw_tradeskillheaders),1 do
				atsw_tradeskillheaders[i].expanded=false;
			end
		end
	end
	ATSW_CreateSkillListing();
	ATSWFrame_Update();
end

function ATSWFrame_UpdateQueue()
	local jobs=table.getn(atsw_queue);
	local offset=FauxScrollFrame_GetOffset(ATSWQueueScrollFrame);

	for i=1,4,1 do
		local jobindex=i+offset;
		local queueCount=getglobal("ATSWQueueItem"..i.."CountText");
		local queueName=getglobal("ATSWQueueItem"..i.."NameText");
		local queueItem=getglobal("ATSWQueueItem"..i);
		local queueButton=getglobal("ATSWQueueItem"..i.."DeleteButton");
		if(atsw_queue[jobindex]) then
			queueCount:SetText(atsw_queue[jobindex].count.."x");
			queueName:SetText(atsw_queue[jobindex].name);
			queueItem.jobindex=jobindex;
			queueButton.jobindex=jobindex;
			queueItem:Show();
			queueButton:Show();
		else
			queueButton:Hide();
			queueItem:Hide();
		end
	end

	FauxScrollFrame_Update(ATSWQueueScrollFrame, jobs, 4, 22);
end

function ATSW_DeleteQueue()
	atsw_queue={};
	ATSW_ResetPossibleItemCounts();
	ATSWInv_UpdateQueuedItemList();
	ATSWFrame_UpdateQueue();
	ATSWFrame_Update();
	ATSWQueueStartStopButton:Enable();
	ATSWQueueDeleteButton:Enable();
	ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
end

function ATSW_SaveQueue(delete)
	if(ATSWFrame:IsVisible()) then
		ATSW_NoteNecessaryItemsForQueue();
		if(atsw_savedqueue[UnitName("player")]==nil) then
			atsw_savedqueue[UnitName("player")]={};
		end
		atsw_savedqueue[UnitName("player")][atsw_displayedgroup]=atsw_queue;
		if(atsw_savednecessaryitems[UnitName("player")]==nil) then
			atsw_savednecessaryitems[UnitName("player")]={};
		end
		atsw_savednecessaryitems[UnitName("player")][atsw_displayedgroup]=atsw_necessaryitems;
		if(delete==true) then
			ATSW_DeleteQueue();
		end
	end
end

function ATSW_RestoreQueue()
	if(ATSWFrame:IsVisible()) then
		if(atsw_savedqueue[UnitName("player")]~=nil) then
			if(atsw_savedqueue[UnitName("player")][atsw_selectedskill]~=nil) then
				atsw_queue=atsw_savedqueue[UnitName("player")][atsw_displayedgroup];
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
				return;
			end
		end
		ATSW_DeleteQueue();
	end
end

function ATSW_DeleteJob(jobindex)
	if(atsw_queue[jobindex]) then
		table.remove(atsw_queue,jobindex);
		if(FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)>0 and FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)+4>table.getn(atsw_queue)) then
			FauxScrollFrame_SetOffset(ATSWQueueScrollFrame,FauxScrollFrame_GetOffset(ATSWQueueScrollFrame)-1);
		end
		if(atsw_preventupdate==false) then
			ATSW_ResetPossibleItemCounts();
			ATSWInv_UpdateQueuedItemList();
			ATSWFrame_UpdateQueue();
			ATSWFrame_Update();
		end
	end
end

function ATSW_AddJobLL(skillname, num)
	for i=1,table.getn(atsw_queue),1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count+num;
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
	local itemlink=ATSW_GetLinkForSkill(skillname);
	table.insert(atsw_queue,{name=skillname,count=num,link=itemlink});
	if(atsw_preventupdate==false) then
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateQueuedItemList();
		ATSWFrame_UpdateQueue();
		ATSWFrame_Update();
	end
end

function ATSW_GetLinkForSkill(skillname)
	for i=1,GetNumTradeSkills(),1 do
		local skill=GetTradeSkillInfo(i)
		if(skill==skillname) then
			return GetTradeSkillItemLink(i);
		end
	end
	return nil;
end

function ATSW_AddJobFirst(skillname, num)
	for i=1,table.getn(atsw_queue),1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count+num;
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
	table.insert(atsw_queue,1,{name=skillname,count=num});
	if(atsw_preventupdate==false) then
		ATSW_ResetPossibleItemCounts();
		ATSWInv_UpdateQueuedItemList();
		ATSWFrame_UpdateQueue();
		ATSWFrame_Update();
	end
end

function ATSW_DeleteJobPartial(skillname, num)
	for i=1,table.getn(atsw_queue),1 do
		if(atsw_queue[i].name==skillname) then
			atsw_queue[i].count=atsw_queue[i].count-num;
			if(atsw_queue[i].count<=0) then ATSW_DeleteJob(i); end
			if(atsw_preventupdate==false) then
				ATSW_ResetPossibleItemCounts();
				ATSWInv_UpdateQueuedItemList();
				ATSWFrame_UpdateQueue();
				ATSWFrame_Update();
			end
			return;
		end
	end
end

function ATSW_StartStopProcessing()
	if(atsw_processing==true) then
		ATSW_AddJobFirst(atsw_processingname,1);
		atsw_processing=false;
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
	else
		if(table.getn(atsw_queue)==0) then return; end
		atsw_processing=true;
		--ATSWQueueStartStopButton:Disable();
		--ATSWQueueDeleteButton:Disable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		ATSW_StartProcessing();
	end
end

function ATSW_Enchant()
	DoCraft(GetCraftSelectionIndex());
end

function ATSW_SetColumnWidth(width, frame)
	if not frame then
    	frame = this;
	end
	frame:SetWidth(width);
  	getglobal(frame:GetName().."Middle"):SetWidth(width - 9);
	frame:Disable();
end

function ATSW_StartProcessing()
	atsw_retries=0;
	atsw_retry=false;
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_STOP");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_START");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	ATSWFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	ATSW_ProcessNextQueueItem(true);	
end

function ATSW_ProcessNextQueueItem(directClick)
	if(table.getn(atsw_queue)>0 and atsw_retries<ATSW_MAX_RETRIES) then
--		atsw_processingname=atsw_queue[1].name;
--		atsw_working=true;
--		atsw_retries=atsw_retries+1;
--		atsw_retry=true;
--		atsw_retrydelay=0;
--		DoTradeSkill(ATSW_GetTradeSkillID(atsw_queue[1].name),1);
		if(directClick~=nil and directClick==true) then
			ATSW_ProcessIt();
		else
			--ATSWCFItemName:SetText(ATSWCF_TITLE2.."\n"..atsw_queue[1].count.."x "..atsw_queue[1].name);
			--ShowUIPanel(ATSWContinueFrame);
			ATSWQueueStartStopButton:Enable();
			ATSWQueueDeleteButton:Enable();
			ATSWQueueStartStopButton:SetText(ATSW_CONTINUEQUEUE);
		end
	else
		atsw_processingtimeout=5;
	end
end

function ATSW_ProcessIt()
	atsw_processingname=atsw_queue[1].name;
	atsw_working=true;
	atsw_retries=atsw_retries+1;
	atsw_retry=true;
	atsw_processnext=false;
	atsw_retrydelay=0;
	DoTradeSkill(ATSW_GetTradeSkillID(atsw_queue[1].name),atsw_queue[1].count);	
end

function ATSW_SpellcastStop()
	atsw_working=false;
	if(atsw_queue[1]) then
		atsw_lastremoved=atsw_processingname;
		ATSW_DeleteJobPartial(atsw_processingname,1);
		ATSWFrame_UpdateQueue();
	end
	if(atsw_processing==true) then 
		if(atsw_queue[1]~=nil and atsw_queue[1].name~=atsw_processingname) then
			atsw_processnext=true;
		end
	else	
		ATSWQueueStartStopButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		ATSWQueueDeleteButton:Enable();
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	end
end

function ATSW_SpellcastInterrupted()
	if(atsw_processing==true) then 
		atsw_working=false;
		--if(atsw_lastremoved) then
		--	ATSW_AddJobFirst(atsw_lastremoved,1);
		--	ATSWFrame_UpdateQueue();
		--end
		--if(atsw_retries<ATSW_MAX_RETRIES) then
		--	atsw_retries=atsw_retries+1;
		--	atsw_retry=true;
		--	atsw_retrydelay=0;
		--	return;
		--end
		ATSWQueueStartStopButton:Enable();
		ATSWQueueDeleteButton:Enable();
		ATSWQueueStartStopButton:SetText(ATSW_STARTQUEUE);
		atsw_processing=false;
		atsw_interrupted=true;
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_START");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		ATSWFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	end
end

function ATSW_SpellcastStart()
	atsw_retry=false;
	atsw_retrydelay=0;
	atsw_processingtimeout=0;
end

function ATSWDBF_OnOK()
	if(table.getn(atsw_queue)>0) then
		ATSW_ProcessIt();
	end
end

function ATSWDBF_OnAbort()
	ATSW_StartStopProcessing();	
end

function ATSW_GetTradeSkillID(skillName) 
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==skillName) then 
			return atsw_tradeskilllist[i].id;
		end
	end
	return 0;
end

function ATSW_GetTradeSkillListPos(id)
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].id==id) then 
			return i;
		end
	end
	return -1;	
end

function ATSW_GetTradeSkillListPosByName(name)
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==name) then 
			return i;
		end
	end
	return -1;	
end

function ATSW_CreateTradeSkillList()
	local numTradeSkills=GetNumTradeSkills();
	local currentHeader=0;

	atsw_oldtradeskillheaders=atsw_tradeskillheaders;
	atsw_tradeskilllist={};
	atsw_tradeskillheaders={};

	--if(atsw_oldmode) then 
	--	table.insert(atsw_tradeskillheaders,{name="invisibleheader",id=0,list={},expanded=true});
	--	currentHeader=1;
	--end

	for i=1,numTradeSkills,1 do
		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i);
		if(skillName~=nil) then
			if(skillType=="header") then
				local oldexpanded=true;
				for j=1,table.getn(atsw_oldtradeskillheaders),1 do
					if(atsw_oldtradeskillheaders[j].name==skillName) then
						oldexpanded=atsw_oldtradeskillheaders[j].expanded;
					end
				end
				table.insert(atsw_tradeskillheaders,{name=skillName,id=i,list={},expanded=oldexpanded});
				currentHeader=table.getn(atsw_tradeskillheaders);
			else
				if(currentHeader>0) then -- or atsw_oldmode
					reagentlist={};
					local numReagents = GetTradeSkillNumReagents(i);
					local skillLink = GetTradeSkillItemLink(i);
					local numMade = GetTradeSkillNumMade(i);
					for j=1, numReagents, 1 do
						local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(i, j);
						local reagentLink = GetTradeSkillReagentItemLink(i,j);
						if(reagentName) then
							table.insert(reagentlist,{name=reagentName,count=reagentCount,link=reagentLink});
						end
					end
					local recipeLink=GetTradeSkillRecipeLink(i);
					table.insert(atsw_tradeskilllist,{name=skillName,id=i,reagents=reagentlist,link=skillLink,type=skillType,num=numMade,recipelink=recipeLink});
					table.insert(atsw_tradeskillheaders[currentHeader].list,table.getn(atsw_tradeskilllist));
				end
			end
		end
	end

	local check=false;

	if(atsw_invslotfilter[atsw_selectedskill]~=nil) then
		atsw_invslotfilter[atsw_selectedskill]=nil;
		atsw_invslotfiltered[atsw_selectedskill]={};
		for i=1,table.getn(atsw_tradeskilllist),1 do
			atsw_invslotfiltered[atsw_selectedskill][atsw_tradeskilllist[i].name]=1;
		end
		for i=1,table.getn(atsw_tradeskillheaders),1 do
			atsw_invslotfiltered[atsw_selectedskill][atsw_tradeskillheaders[i].name]=1;
		end
		SetTradeSkillInvSlotFilter(0, 1, 1);
		check=true;
	end

	if(atsw_subclassfilter[atsw_selectedskill]~=nil) then
		atsw_subclassfilter[atsw_selectedskill]=nil;
		atsw_subclassfiltered[atsw_selectedskill]={};
		for i=1,table.getn(atsw_tradeskilllist),1 do
			atsw_subclassfiltered[atsw_selectedskill][atsw_tradeskilllist[i].name]=1;
		end
		for i=1,table.getn(atsw_tradeskillheaders),1 do
			atsw_subclassfiltered[atsw_selectedskill][atsw_tradeskillheaders[i].name]=1;
		end
		SetTradeSkillSubClassFilter(0, 1, 1);
		check=true;
	end

	if(check==false) then
		ATSW_CreateSkillListing();
	end
end

function ATSW_GetSkillListingPos(id)
	for i=1,table.getn(atsw_skilllisting),1 do
		if(atsw_skilllisting[i].id==id) then 
			return i;
		end
	end
	return -1;	
end

function ATSW_CreateSkillListing()
	atsw_skilllisting={};
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]~="custom") then
		for i=1,table.getn(atsw_tradeskillheaders),1 do
			table.insert(atsw_skilllisting,{type="header",name=atsw_tradeskillheaders[i].name,expanded=atsw_tradeskillheaders[i].expanded,id=atsw_tradeskillheaders[i].id});
			if(atsw_tradeskillheaders[i].expanded==true) then
				for j=1,table.getn(atsw_tradeskillheaders[i].list),1 do
					local skillName=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].name;
					local skillID=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].id;
					local skillType=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].type;
					local numMade=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].num;
					local skillLink=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].link;
					local recipeLink=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].recipelink;
					table.insert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink,recipelink=recipeLink});
				end
			end
		end
	else
		local atsw_allskills={};
		for i=1,table.getn(atsw_tradeskillheaders),1 do
			for j=1,table.getn(atsw_tradeskillheaders[i].list),1 do
				table.insert(atsw_allskills,atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].name);
			end
		end
		if(atsw_customheaders[UnitName("player")]) then
			if(atsw_customheaders[UnitName("player")][atsw_selectedskill]) then
				for i=1,table.getn(atsw_customheaders[UnitName("player")][atsw_selectedskill]),1 do
					table.insert(atsw_skilllisting,{type="header",name=atsw_customheaders[UnitName("player")][atsw_selectedskill][i].name,expanded=atsw_customheaders[UnitName("player")][atsw_selectedskill][i].expanded,id=i*1000});
					if(atsw_customsorting[UnitName("player")] and atsw_customsorting[UnitName("player")][atsw_selectedskill] and atsw_customsorting[UnitName("player")][atsw_selectedskill][atsw_customheaders[UnitName("player")][atsw_selectedskill][i].name]) then
						for j=1,table.getn(atsw_customsorting[UnitName("player")][atsw_selectedskill][atsw_customheaders[UnitName("player")][atsw_selectedskill][i].name]),1 do
							local skillName=atsw_customsorting[UnitName("player")][atsw_selectedskill][atsw_customheaders[UnitName("player")][atsw_selectedskill][i].name][j].name;
							local skillID, skillType, numMade, skillLink, recipeLink=ATSW_GetSkillDataFromSkillList(skillName);
							if(atsw_customheaders[UnitName("player")][atsw_selectedskill][i].expanded==true) then table.insert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink,recipelink=recipeLink}); end
							for k=1,table.getn(atsw_allskills),1 do
								if(atsw_allskills[k]==skillName) then
									table.remove(atsw_allskills,k);
								end
							end
						end
					end
				end
			end
		end
		if(table.getn(atsw_allskills)>0) then
			table.insert(atsw_skilllisting,{type="header",name=ATSWCS_UNCATEGORIZED,expanded=atsw_uncategorizedexpanded,id=1001});
			if(atsw_uncategorizedexpanded==true) then
				for i=1,table.getn(atsw_allskills),1 do
					local skillName=atsw_allskills[i];
					local skillID, skillType, numMade, skillLink=ATSW_GetSkillDataFromSkillList(skillName);
					table.insert(atsw_skilllisting,{type=skillType,name=skillName,id=skillID,num=numMade,link=skillLink});
				end
			end
		end
	end
end

function ATSW_GetSkillDataFromSkillList(skillName)
	for i=1,table.getn(atsw_tradeskillheaders),1 do
		for j=1,table.getn(atsw_tradeskillheaders[i].list),1 do
			if(skillName==atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].name) then
				local skillID=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].id;
				local skillType=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].type;
				local numMade=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].num;
				local skillLink=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].link;
				local recipeLink=atsw_tradeskilllist[atsw_tradeskillheaders[i].list[j]].recipelink;
				return skillID, skillType, numMade, skillLink, recipeLink;
			end
		end
	end
	return nil;
end

function ATSW_SetHeaderExpanded(id,value)
	if(atsw_orderby[UnitName("player")][atsw_selectedskill]~="custom") then
		for i=1,table.getn(atsw_tradeskillheaders),1 do
			if(atsw_tradeskillheaders[i].id==id) then
				atsw_tradeskillheaders[i].expanded=value;
			end
		end
	else
		if(id==1001) then
			atsw_uncategorizedexpanded=value;
		else
			atsw_customheaders[UnitName("player")][atsw_selectedskill][id/1000].expanded=value;
		end
	end
	ATSW_CreateSkillListing();
end

function ATSW_AddTradeSkillReagentLinksToChatFrame(skillName)
	local channel,chatnumber;
	if(WIM_EditBoxInFocus~=nil) then
		channel = "WHISPER";
		chatnumber = WIM_EditBoxInFocus:GetParent().theUser;
	else
		channel = ChatFrameEditBox:GetAttribute("chatType");
		if channel=="WHISPER" then
			chatnumber = ChatFrameEditBox:GetAttribute("tellTarget");
		elseif channel=="CHANNEL" then
			chatnumber = ChatFrameEditBox:GetAttribute("channelTarget");
		end
	end
	local chatline;
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i]) then
			if(atsw_tradeskilllist[i].name==skillName) then
				if(atsw_newrecipelinks==true) then
					ChatEdit_InsertLink(atsw_tradeskilllist[i].recipelink);
				else
					SendChatMessage(ATSW_REAGENTLIST1..atsw_tradeskilllist[i].link..ATSW_REAGENTLIST2,channel,nil,chatnumber);
					for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
						chatline=atsw_tradeskilllist[i].reagents[j].count.."x "..atsw_tradeskilllist[i].reagents[j].link;
						SendChatMessage(chatline,channel,nil,chatnumber);
					end
				end
			end
		end
	end
end

function ATSWFrameIncrement_OnClick()
	if(ATSWInputBox:GetNumber()<100) then
		ATSWInputBox:SetNumber(ATSWInputBox:GetNumber()+1);
	end
end

function ATSWFrameDecrement_OnClick()
	if(ATSWInputBox:GetNumber()>0) then
		ATSWInputBox:SetNumber(ATSWInputBox:GetNumber()-1);
	end
end

function ATSW_GetNumItemsPossible(skillName)
	return ATSW_GetNumItemsPossibleCached(skillName,atsw_tradeskillcountcache);
end

function ATSW_GetNumItemsPossibleCached(skillName,cacheTable)
	if(cacheTable and cacheTable[skillName]) then
		return cacheTable[skillName];
	end
	local atsw_considermerchants_backup=atsw_considermerchants;
	if(atsw_considermerchants==true and ATSW_CheckIfCreatedOnlyWithVendorStuff(skillName)==true) then
		atsw_considermerchants=false;
	end
	local i;
	local temporaryitemlist=atsw_temporaryitemlist;
	for i=1,500,1 do
		ATSW_ClearTable(temporaryitemlist);
		if(ATSW_CheckIfPossible(skillName,i)==false) then 
			ATSW_ClearTable(temporaryitemlist);
			if(cacheTable) then cacheTable[skillName]=(i-1); end
			atsw_considermerchants=atsw_considermerchants_backup;
			return (i-1);
		end
	end
	atsw_considermerchants=atsw_considermerchants_backup;
	return 0;
end

function ATSW_GetNumItemsPossibleWithInventory(skillName)
	local atsw_considerbank_backup=atsw_considerbank;
	local atsw_consideralts_backup=atsw_consideralts;
	local atsw_considermerchants_backup=atsw_considermerchants;
	atsw_considerbank=false;
	atsw_consideralts=false;
	atsw_considermerchants=false;
	local count=ATSW_GetNumItemsPossibleCached(skillName,atsw_tradeskillcountwithinventorycache);
	atsw_considerbank=atsw_considerbank_backup;
	atsw_consideralts=atsw_consideralts_backup;
	atsw_considermerchants=atsw_considermerchants_backup;
	return count;
end

function ATSW_ClearTable(tbl)
	for k in pairs(tbl) do
		tbl[k]=nil;
	end
end

function ATSW_ToggleReagentFrame()
	if(ATSWReagentFrame:IsVisible()) then
		HideUIPanel(ATSWReagentFrame);
	else
		ATSW_ShowNecessaryReagents();
	end
end

function ATSW_ResetPossibleItemCounts()
	atsw_tradeskillcountcache={};
	atsw_tradeskillcountwithinventorycache={};
end

function ATSW_AddJob(skillName,count)
	ATSW_ClearTable(atsw_temporaryitemlist);
	local numMade=1;
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==skillName) then
			numMade=atsw_tradeskilllist[i].num;
		end
	end
	ATSW_AddJobRecursive(skillName,count*numMade,true);	
end

function ATSW_AddJobRecursive(skillName,count,firstcall,depth,previousSkill)
	-- Endless recursion is prevented by checking a reagent against the name of the skill in the previous recursion step
	-- This should eliminate any circles with just two elements recursing into eachother (AFAIK that's the only type of circular
	-- recipes available in the game as of patch 2.2)
	-- In addition to that, a depth counter is used to kill the recursion after at most 10 steps, "just in case"
	-- The same mechanism applies to all recursive functions below
	if(depth==nil) then 
		depth=10;
	else
		if(depth<=0) then return; end
	end
	if(ATSW_CheckBlacklist(skillName)==false or firstcall==true) then
		for i=1,table.getn(atsw_tradeskilllist),1 do
			if(atsw_tradeskilllist[i].name==skillName) then
				local usagecount=math.ceil(count/atsw_tradeskilllist[i].num);
				for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
					local itemcount=ATSW_GetItemCountMinusQueued(atsw_tradeskilllist[i].reagents[j].name);
					if(itemcount<0) then itemcount=0; end
					local necessary=atsw_tradeskilllist[i].reagents[j].count*usagecount;
					if(itemcount<necessary and atsw_tradeskilllist[i].reagents[j].name~=previousSkill) then
						local missing=necessary-itemcount;
						ATSW_AddJobRecursive(atsw_tradeskilllist[i].reagents[j].name,missing,false,depth-1,skillName);
					end
				end
				ATSW_AddJobLL(skillName,usagecount);
			end
		end
	end
end

function ATSW_CheckIfPossible(skillName,count,depth,previousSkill)
	if(depth==nil) then 
		depth=10;
	else
		if(depth<=0) then return; end
	end
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==skillName) then
			for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
				local usagecount=count;
				for k=1,table.getn(atsw_tradeskilllist),1 do
					if(atsw_tradeskilllist[k].name==atsw_tradeskilllist[i].reagents[j].name) then
						usagecount=math.ceil(count/atsw_tradeskilllist[k].num);
						break;
					end
				end
				local itemcount=ATSW_GetItemCountMinusQueuedAndTemporary(atsw_tradeskilllist[i].reagents[j].name);
				local necessary=atsw_tradeskilllist[i].reagents[j].count*usagecount;
				if(itemcount>=necessary) then
					ATSW_TemporaryUseItem(atsw_tradeskilllist[i].reagents[j].name,necessary);
				else
					if(atsw_tradeskilllist[i].reagents[j].name~=previousSkill) then
						local missing=necessary-itemcount;
						local response=ATSW_CheckIfPossible(atsw_tradeskilllist[i].reagents[j].name,missing,depth-1,skillName);
						if(response==false) then return false; end
					end
				end
			end
			return true;
		end
	end
	return false;
end

function ATSW_CheckIfCreatedOnlyWithVendorStuff(skillName,depth,previousSkill)
	if(depth==nil) then 
		depth=10;
	else
		if(depth<=0) then return; end
	end
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==skillName) then
			for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
				if(atsw_tradeskilllist[i].reagents[j].name~=previousSkill) then
					local response=ATSW_CheckIfCreatedOnlyWithVendorStuff(atsw_tradeskilllist[i].reagents[j].name,depth-1,skillName);
					if(response==false) then return false; end
				end
			end
			return true;
		end
	end
	return ATSWMerchant_CheckIfAvailable(skillName);
end

function ATSW_NoteMissingItems(skillName,count,depth,previousSkill)
	if(depth==nil) then 
		depth=10;
	else
		if(depth<=0) then return; end
	end
	if(ATSW_CheckBlacklist(skillName)==false) then
		for i=1,table.getn(atsw_tradeskilllist),1 do
			if(atsw_tradeskilllist[i].name==skillName) then
				for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
					local itemcount=ATSW_GetItemCountMinusQueuedAndTemporary(atsw_tradeskilllist[i].reagents[j].name);
					local necessary=atsw_tradeskilllist[i].reagents[j].count*count;
					if(itemcount>=necessary) then
						ATSW_TemporaryUseItem(atsw_tradeskilllist[i].reagents[j].name,necessary);
					else
						if(atsw_tradeskilllist[i].reagents[j].name~=previousSkill) then
							local missing=necessary-itemcount;
							ATSW_NoteMissingItems(atsw_tradeskilllist[i].reagents[j].name,missing,depth-1,skillName);
						end
					end
				end
				return;
			end
		end
	end
	for i=1,table.getn(atsw_missingitems),1 do
		if(atsw_missingitems[i]) then
			if(atsw_missingitems[i].name==skillName) then
				atsw_missingitems[i].cnt=atsw_missingitems[i].cnt+count;
				return;
			end
		end
	end
	table.insert(atsw_missingitems,{name=skillName,cnt=count});
end

function ATSW_OutputMissingItems(skillName,count)
	ATSW_DisplayMessage(ATSW_ITEMSMISSING1..count.."x '"..skillName.."'"..ATSW_ITEMSMISSING2);
	for i=1,table.getn(atsw_missingitems),1 do
		ATSW_DisplayMessage(atsw_missingitems[i].cnt.."x '"..atsw_missingitems[i].name.."'");
	end	
end

function ATSW_NoteNecessaryItems(skillName,count,itemLink)
	for i=1,table.getn(atsw_tradeskilllist),1 do
		if(atsw_tradeskilllist[i].name==skillName) then
			for j=1,table.getn(atsw_tradeskilllist[i].reagents),1 do
				local necessary=atsw_tradeskilllist[i].reagents[j].count*count;
				local found=false;
				for x=1,table.getn(atsw_necessaryitems),1 do
					if(atsw_necessaryitems[x]) then
						if(atsw_necessaryitems[x].name==atsw_tradeskilllist[i].reagents[j].name) then
							atsw_necessaryitems[x].cnt=atsw_necessaryitems[x].cnt+necessary;
							found=true;
							break;
						end
					end
				end
				if(found==false) then
					table.insert(atsw_necessaryitems,{name=atsw_tradeskilllist[i].reagents[j].name,cnt=necessary,link=atsw_tradeskilllist[i].reagents[j].link});
				end
			end
			return;
		end
	end
end

function ATSW_NoteNecessaryItemsForQueue()
	atsw_necessaryitems={};
	for i=1,table.getn(atsw_queue),1 do
		ATSW_NoteNecessaryItems(atsw_queue[i].name,atsw_queue[i].count,nil);
	end
	ATSW_FilterNecessaryItems();
end

function ATSW_FilterNecessaryItems()
	for i=1,table.getn(atsw_necessaryitems),1 do
		for k=1,table.getn(atsw_queue),1 do
			if(atsw_necessaryitems[i].name==atsw_queue[k].name) then
				atsw_necessaryitems[i].cnt=atsw_necessaryitems[i].cnt-atsw_queue[k].count;
			end
		end
	end
	for i=table.getn(atsw_necessaryitems),1,-1 do
		if(atsw_necessaryitems[i].cnt<=0) then
			table.remove(atsw_necessaryitems,i);
		end
	end
end

function ATSW_NoteNecessaryItemsForTradeskill(skillName,skillCount)
	local atsw_queue_backup=atsw_queue;
	atsw_preventupdate=true;
	atsw_queue={};
	ATSW_AddJob(skillName,skillCount);
	ATSW_NoteNecessaryItemsForQueue();
	atsw_queue=atsw_queue_backup;
	atsw_preventupdate=false;
end

function ATSW_ShowNecessaryReagents()
	ATSW_NoteNecessaryItemsForQueue();
	for i=1,20,1 do
		local count=getglobal("ATSWRFReagent"..i.."Count");
		local item=getglobal("ATSWRFReagent"..i.."Item");
		local inv=getglobal("ATSWRFReagent"..i.."Inventory");
		local bank=getglobal("ATSWRFReagent"..i.."Bank");
		local merchant=getglobal("ATSWRFReagent"..i.."Merchant");
		local alt=getglobal("ATSWRFReagent"..i.."Alt");
		local missing=getglobal("ATSWRFReagent"..i.."Missing");
		if(atsw_necessaryitems[i]) then
			local items_inventory=ATSWInv_GetItemCount(atsw_necessaryitems[i].name);
			local items_bank=ATSWBank_GetItemCount(atsw_necessaryitems[i].name);
			local items_alt=ATSWAlt_GetItemCount(atsw_necessaryitems[i].name);
			local items_missing=items_inventory+items_bank+items_alt-atsw_necessaryitems[i].cnt;
			local items_merchant=ATSWMerchant_CheckIfAvailable(atsw_necessaryitems[i].name);
			count:SetText(atsw_necessaryitems[i].cnt.."x");
			count:Disable();
			count:Show();
			item:SetText("["..atsw_necessaryitems[i].name.."]");
			item.link=atsw_necessaryitems[i].link;
			item:Show();
			if(items_inventory>=atsw_necessaryitems[i].cnt) then items_inventory="|cff00ff00"..items_inventory.."|r"; else items_inventory="|cffff0000"..items_inventory.."|r"; end
			inv:SetText(items_inventory);
			inv:Disable();
			inv:Show();
			if(items_bank>=atsw_necessaryitems[i].cnt) then items_bank="|cff00ff00"..items_bank.."|r"; else items_bank="|cffff0000"..items_bank.."|r"; end
			bank:SetText(items_bank);
			bank:Disable();
			bank:Show();
			merchant:SetText("X");
			merchant:Disable();
			if(items_merchant==true) then
				merchant:Show();
			else
				merchant:Hide();
			end
			if(items_alt>0) then
				alt:Enable();
				alt.itemname=atsw_necessaryitems[i].name;
			else
				alt:Disable();
			end
			if(items_alt>=atsw_necessaryitems[i].cnt) then items_alt="|cff00ff00"..items_alt.."|r"; else items_alt="|cffff0000"..items_alt.."|r"; end
			alt:SetText(items_alt);
			alt:Show();
			if(items_missing>=0) then
				missing:SetText("|cff00ff00".."+"..items_missing.."|r");
			else
				missing:SetText("|cffff0000"..items_missing.."|r");
			end
			missing:Disable();
			missing:Show();
		else
			count:Hide();
			item:Hide();
			inv:Hide();
			bank:Hide();
			merchant:Hide();
			alt:Hide();
			missing:Hide();
		end
	end
	ShowUIPanel(ATSWReagentFrame);
end

function ATSWItemButton_OnEnter()
    if(this.link) then
    	GameTooltip:SetOwner(this, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT",this:GetName(),"TOPLEFT");
	GameTooltip:SetHyperlink(string.gsub(this.link, "|c(%x+)|H(item:%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r", "%2"));
        GameTooltip:Show();
    end
end

function ATSWItemButton_OnLeave()
	GameTooltip:Hide();
end

function ATSW_TemporaryUseItem(itemname,count)
	if(atsw_temporaryitemlist[itemname]) then
		atsw_temporaryitemlist[itemname]=atsw_temporaryitemlist[itemname]+count;
	else
		atsw_temporaryitemlist[itemname]=count;
	end	
end

function ATSW_CheckBlacklist(itemname)
	for i=1,table.getn(atsw_blacklist),1 do
		if(atsw_blacklist[i]) then
			if(atsw_blacklist[i]==itemname) then return true; end
		end
	end
	return false;	
end

function ATSW_UpdateFilter(filtertext)
	atsw_filter=filtertext;
	ATSWFrame_Update();	
end

function ATSW_Filter(skillname)
	if(skillname==nil) then return false; end
	if(skillname=="") then return true; end
	local parameters={};
	if(atsw_onlycreatable) then
		local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
		if(possible<=0) then
			return false;
		end
	end	
	for w in string.gmatch(atsw_filter, ":[^:]*") do
		local _, _, param_name, param_value=string.find(w, ":(%a+)%s([^:]*)");
		if(param_name~=nil) then _, _, param_name=string.find(param_name,"^%s*(.-)%s*$"); end
		if(param_value~=nil) then _, _, param_value=string.find(param_value,"^%s*(.-)%s*$"); end
		if(param_name~=nil) then
			table.insert(parameters,{name=param_name,value=param_value});
		end
	end
	local _, _, searchstring=string.find(atsw_filter,"^([^:]*):?");
	if(searchstring~=nil) then
		_, _, searchstring=string.find(searchstring,"^%s*(.-)%s*$");
		table.insert(parameters,1,{name="name",value=searchstring});
	end
	for i=1,table.getn(parameters),1 do
		if(parameters[i].name=="name") then
			if(string.find(string.lower(skillname),".-"..string.lower(parameters[i].value)..".-")==nil) then
				return false;
			end
		end
		if(parameters[i].name=="reagent") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local found=false;
				for j=1,table.getn(atsw_tradeskilllist[index].reagents),1 do
					if(string.find(string.lower(atsw_tradeskilllist[index].reagents[j].name),".-"..string.lower(parameters[i].value)..".-")~=nil) then
						found=true;
					end
				end
				if(found==false) then return false; end
			else
				return false;
			end
		end
		if(parameters[i].name=="minlevel") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local level=ATSW_GetItemMinLevel(atsw_tradeskilllist[index].id);
				if(tonumber(parameters[i].value,10)==nil or level==0 or level<tonumber(parameters[i].value,10)) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="maxlevel") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local level=ATSW_GetItemMinLevel(atsw_tradeskilllist[index].id);
				if(tonumber(parameters[i].value,10)==nil or level==0 or level>tonumber(parameters[i].value,10)) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="minrarity") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local rarity=ATSW_GetItemRarity(atsw_tradeskilllist[index].id);
				local reference=ATSWRarityNames[parameters[i].value];
				if(reference==nil or rarity==0 or rarity<reference) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="maxrarity") then
			local index=ATSW_GetTradeSkillListPosByName(skillname);
			if(index~=-1) then
				local rarity=ATSW_GetItemRarity(atsw_tradeskilllist[index].id);
				local reference=ATSWRarityNames[parameters[i].value];
				if(reference==nil or rarity==0 or rarity>reference) then
					return false;
				end
			else
				return false;
			end
		end
		if(parameters[i].name=="minpossible") then
			local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible<tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="maxpossible") then
			local possible=ATSW_GetNumItemsPossibleWithInventory(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible>tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="minpossibletotal") then
			local possible=ATSW_GetNumItemsPossible(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible<tonumber(parameters[i].value,10)) then
				return false;
			end
		end
		if(parameters[i].name=="maxpossibletotal") then
			local possible=ATSW_GetNumItemsPossible(skillname);
			if(tonumber(parameters[i].value,10)==nil or possible>tonumber(parameters[i].value,10)) then
				return false;
			end
		end
	end
	return true;
end

function ATSW_GetItemMinLevel(tradeskillid)
	ATSWScanTooltip:SetOwner(ATSWFrame, "ANCHOR_TOPLEFT");
	ATSWScanTooltip:SetTradeSkillItem(tonumber(tradeskillid,10));
	local linecount=ATSWScanTooltip:NumLines();
	local k;
	for k=1,linecount,1 do
		local ttextLeft = getglobal("ATSWScanTooltipTextLeft"..k);
		if(ttextLeft) then
			local text=ttextLeft:GetText();
			if(text) then
				local _, _, level=string.find(text,ATSW_SCAN_MINLEVEL);
				if(level) then
					ATSWScanTooltip:Hide();
					return tonumber(level,10);
				end
			end
		end
	end
	ATSWScanTooltip:Hide();
	return 0;
end

function ATSW_GetItemRarity(tradeskillid)
	ATSWScanTooltip:SetOwner(ATSWFrame, "ANCHOR_TOPLEFT");
	ATSWScanTooltip:SetTradeSkillItem(tonumber(tradeskillid,10));
	local ttextLeft = getglobal("ATSWScanTooltipTextLeft1");
	if(ttextLeft) then
		local cr,cg,cb=ttextLeft:GetTextColor();
		if(cr) then
			cr=ATSW_Round(cr,2);
			cg=ATSW_Round(cg,2);
			cb=ATSW_Round(cb,2);
			local col;
			for col=1,5,1 do
				if(ATSWRarityColor[col].r==cr and ATSWRarityColor[col].g==cg and ATSWRarityColor[col].b==cb) then
					ATSWScanTooltip:Hide();
					return col;
				end
			end
		end
	end
	ATSWScanTooltip:Hide();
	return 0;
end

function ATSW_Test()
	local stats=GetTradeSkillItemStats(3);
	ATSW_DisplayMessage(stats);
end

function ATSW_ToggleOptionsFrame()
	if(ATSWOptionsFrame:IsVisible()) then
		HideUIPanel(ATSWOptionsFrame);
	else
		if(atsw_multicount==true) then
			ATSWOFUnifiedCounterButton:SetChecked(true);
			ATSWOFSeparateCounterButton:SetChecked(false);
		else
			ATSWOFUnifiedCounterButton:SetChecked(false);
			ATSWOFSeparateCounterButton:SetChecked(true);
		end
		if(atsw_considerbank==true) then
			ATSWOFIncludeBankButton:SetChecked(true);
		else	
			ATSWOFIncludeBankButton:SetChecked(false);
		end
		if(atsw_consideralts==true) then
			ATSWOFIncludeAltsButton:SetChecked(true);
		else	
			ATSWOFIncludeAltsButton:SetChecked(false);
		end
		if(atsw_considermerchants==true) then
			ATSWOFIncludeMerchantsButton:SetChecked(true);
		else	
			ATSWOFIncludeMerchantsButton:SetChecked(false);
		end
		if(atsw_autobuy==true) then
			ATSWOFAutoBuyButton:SetChecked(true);
		else	
			ATSWOFAutoBuyButton:SetChecked(false);
		end
		if(atsw_recipetooltip==true) then
			ATSWOFTooltipButton:SetChecked(true);
		else
			ATSWOFTooltipButton:SetChecked(false);
		end
		if(atsw_displayshoppinglist==true) then
			ATSWOFShoppingListButton:SetChecked(true);
		else
			ATSWOFShoppingListButton:SetChecked(false);
		end
		if(atsw_displayreagentlist==true) then
			ATSWOFReagentListButton:SetChecked(true);
		else
			ATSWOFReagentListButton:SetChecked(false);
		end
		if(atsw_newrecipelinks==true) then
			ATSWOFNewRecipeLinkButton:SetChecked(true);
		else
			ATSWOFNewRecipeLinkButton:SetChecked(false);
		end
		ShowUIPanel(ATSWOptionsFrame);
	end
end

function ATSW_ToggleCSFrame()
	ShowUIPanel(ATSWCSFrame);
end

-- tooltip functions

atsw_recipetooltip=true;

function ATSW_DisplayTradeskillTooltip()
	if(atsw_recipetooltip==false) then return; end
	ATSWTradeskillTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT",-300);
	ATSWTradeskillTooltip:SetBackdropColor(0,0,0,1);

	local tradeskillid=this:GetID();
	local skillName, skillType, numAvailable;
	local listpos=ATSW_GetSkillListingPos(tradeskillid);
	if(atsw_skilllisting[listpos]) then
		skillName = atsw_skilllisting[listpos].name;
		skillType = atsw_skilllisting[listpos].type;
	else
		skillName=nil;
		akillType=nil;
	end

	if(skillName and skillType ~= "header") then
		ATSWTradeskillTooltip:AddLine(skillName);
		local color=ATSWTypeColor[skillType];
		if(color) then
			ATSWTradeskillTooltipTextLeft1:SetVertexColor(color.r, color.g, color.b);
		end
		ATSWTradeskillTooltip:AddLine(ATSW_GetNumItemsPossibleWithInventory(skillName)..ATSW_TOOLTIP_PRODUCABLE);
		ATSWTradeskillTooltipTextLeft2:SetVertexColor(1, 1, 1);
		ATSWTradeskillTooltip:AddLine(" ");
		ATSWTradeskillTooltip:AddLine(ATSW_TOOLTIP_NECESSARY);

		ATSW_NoteNecessaryItemsForTradeskill(skillName,1);
		for i=1,20,1 do
			if(atsw_necessaryitems[i]) then
				local items_inventory=ATSWInv_GetItemCount(atsw_necessaryitems[i].name);
				local items_bank=ATSWBank_GetItemCount(atsw_necessaryitems[i].name);
				local items_alt=ATSWAlt_GetItemCount(atsw_necessaryitems[i].name);
				local items_missing=items_inventory+items_bank+items_alt-atsw_necessaryitems[i].cnt;
				local items_merchant="";
				if(ATSWMerchant_CheckIfAvailable(atsw_necessaryitems[i].name)==true) then
					items_merchant=ATSW_TOOLTIP_BUYABLE;
				end				
				ATSWTradeskillTooltip:AddLine(atsw_necessaryitems[i].cnt.."x "..atsw_necessaryitems[i].name.." ("..items_inventory.." / "..items_bank.." / "..items_alt..")"..items_merchant);
				local r,g,b=ATSW_GetLinkColorRGB(atsw_necessaryitems[i].link);
				getglobal("ATSWTradeskillTooltipTextLeft"..(4+i)):SetVertexColor(r/256, g/256, b/256);
			end
		end
		ATSWTradeskillTooltip:AddLine(ATSW_TOOLTIP_LEGEND);
		
		ATSWTradeskillTooltip:Show();
	end
end

function ATSW_GetLinkColor(link)
	if(link) then
    		local _,_,color = string.find(link, "^.*|cff(.-)|.*$");
	    	return color;
 	else
    		return nil;
	end
end

function ATSW_GetLinkColorRGB(link)
	if(link) then
		local color=ATSW_HexToDec(ATSW_GetLinkColor(link));
		local r=math.floor(color/65536);
		local g=math.floor((color-r*65536)/256);
		local b=math.floor((color-r*65536-g*256));
		return r,g,b;
	else
		return 0,0,0;
	end
end

-- item count functions

atsw_considerbank=false;
atsw_consideralts=false;
atsw_considermerchants=false;
atsw_multicount=true;

function ATSW_GetItemCountMinusQueuedAndTemporary(itemname)
	if(atsw_temporaryitemlist[itemname]) then
		return ATSW_GetItemCountMinusQueued(itemname)-atsw_temporaryitemlist[itemname];
	else
		return ATSW_GetItemCountMinusQueued(itemname);
	end
end

function ATSW_GetItemCountMinusQueued(itemname)
	local getitemcount=ATSWInv_GetItemCount(itemname);
	if(atsw_considerbank==true) then
		getitemcount=getitemcount+ATSWBank_GetItemCount(itemname);
	end
	if(atsw_considermerchants==true) then
		if(atsw_merchantlist[itemname]) then 
			getitemcount=getitemcount+99999;
		end
	end
	if(atsw_consideralts==true) then
		getitemcount=getitemcount+ATSWAlt_GetItemCount(itemname);
	end
	if(atsw_queueditemlist[itemname]) then
		return getitemcount-atsw_queueditemlist[itemname];
	else
		return getitemcount;
	end
end

-- inventory functions

function ATSWInv_GetItemName(bag, slot)
	local link = GetContainerItemLink(bag, slot);
	if(link) then
    	local _,_,name = string.find(link, "^.*%[(.*)%].*$");
    	return name;
 	else
    	return nil;
    end
end

function ATSWInv_UpdateItemList()
	if(atsw_incombat==true) then return; end
	if(not atsw_itemlist[GetRealmName()]) then
		atsw_itemlist[GetRealmName()]={};
	end
	atsw_itemlist[GetRealmName()][UnitName("player")]={};
	for container=0, 4, 1 do
		for slot=1, GetContainerNumSlots(container), 1 do
			local itemname=ATSWInv_GetItemName(container,slot);
			if(itemname) then
				local _, itemcount=GetContainerItemInfo(container, slot);
				if(atsw_itemlist[GetRealmName()][UnitName("player")][itemname]) then
					atsw_itemlist[GetRealmName()][UnitName("player")][itemname]=atsw_itemlist[GetRealmName()][UnitName("player")][itemname]+itemcount;
				else
					atsw_itemlist[GetRealmName()][UnitName("player")][itemname]=itemcount;
					--table.setn(atsw_itemlist[GetRealmName()][UnitName("player")],table.getn(atsw_itemlist[GetRealmName()][UnitName("player")])+1);
				end
			end
		end
	end
	if(ATSWFrame:IsVisible()) then ATSWFrame_Update(); end
end

function ATSWInv_GetItemCount(itemname)
	if(atsw_itemlist[GetRealmName()]) then
		if(atsw_itemlist[GetRealmName()][UnitName("player")]) then
			if(atsw_itemlist[GetRealmName()][UnitName("player")][itemname]) then
				return atsw_itemlist[GetRealmName()][UnitName("player")][itemname];
			end
		end
	end
	return 0;
end

function ATSWInv_UpdateQueuedItemList()
	atsw_queueditemlist={};
	for i=1,table.getn(atsw_queue),1 do
		for j=1,table.getn(atsw_tradeskilllist),1 do
			if(atsw_tradeskilllist[j].name==atsw_queue[i].name) then
				for k=1,table.getn(atsw_tradeskilllist[j].reagents),1 do
					if(atsw_tradeskilllist[j].reagents[k]) then
						if(atsw_queueditemlist[atsw_tradeskilllist[j].reagents[k].name]) then
							atsw_queueditemlist[atsw_tradeskilllist[j].reagents[k].name]=atsw_queueditemlist[atsw_tradeskilllist[j].reagents[k].name]+atsw_tradeskilllist[j].reagents[k].count*atsw_queue[i].count;
						else
							atsw_queueditemlist[atsw_tradeskilllist[j].reagents[k].name]=atsw_tradeskilllist[j].reagents[k].count*atsw_queue[i].count;
							--table.setn(atsw_queueditemlist,table.getn(atsw_queueditemlist)+1);
						end
					end
				end
			end
		end
	end	
end

function ATSWInv_FindBagForItem(name, count)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(name);
	if(itemName==nil) then return; end
	local possiblecontainer=nil;
	for container=0, 4, 1 do
		for slot=1, GetContainerNumSlots(container), 1 do
			local bagitemname=ATSWInv_GetItemName(container,slot);
			if(bagitemname) then
				if(bagitemname==name) then
					local _, itemcount, locked=GetContainerItemInfo(container, slot);
					local freeslots=itemStackCount-itemcount;
					if(freeslots>=count and locked==nil) then
						return container;
					end
				end
			else
				if(possiblecontainer==nil) then
					possiblecontainer=container;
				end
			end
		end
	end
	return possiblecontainer;
end


-- bank functions

atsw_bankitemlist={};

function ATSWBank_UpdateBankList()
	if(atsw_bankopened==true) then
		if(not atsw_bankitemlist[GetRealmName()]) then
			atsw_bankitemlist[GetRealmName()]={};
		end
		atsw_bankitemlist[GetRealmName()][UnitName("player")]={};
		for slot=1, 28, 1 do
			local name=ATSWInv_GetItemName(BANK_CONTAINER,slot);
			if(name) then
				local icon, count = GetContainerItemInfo(BANK_CONTAINER, slot);
				ATSWBank_AddToBankList(name,count);
			end
		end
		for container=5, 12, 1 do
			for slot=1, GetContainerNumSlots(container), 1 do
				local name=ATSWInv_GetItemName(container,slot);
				if(name) then
					local icon, count = GetContainerItemInfo(container, slot);
					ATSWBank_AddToBankList(name,count);
				end
			end
		end
		ATSW_ResetPossibleItemCounts();
	end
end

function ATSWBank_AddToBankList(name,count)
	if(not atsw_bankitemlist[GetRealmName()]) then
		atsw_bankitemlist[GetRealmName()]={};
	end
	if(not atsw_bankitemlist[GetRealmName()][UnitName("player")]) then
		atsw_bankitemlist[GetRealmName()][UnitName("player")]={};
	end
	if(atsw_bankitemlist[GetRealmName()][UnitName("player")][name]) then
		atsw_bankitemlist[GetRealmName()][UnitName("player")][name]=atsw_bankitemlist[GetRealmName()][UnitName("player")][name]+count;
	else
		atsw_bankitemlist[GetRealmName()][UnitName("player")][name]=count;
	end
end

function ATSWBank_GetItemCount(name)
	if(atsw_bankitemlist[GetRealmName()]) then
		if(atsw_bankitemlist[GetRealmName()][UnitName("player")]) then
			if(atsw_bankitemlist[GetRealmName()][UnitName("player")][name]) then
				return atsw_bankitemlist[GetRealmName()][UnitName("player")][name];
			end	
		end
	end
	return 0;
end

function ATSWBank_FetchItemsFromBank(reqname, reqcount)
	if(atsw_bankopened==true) then
		for slot=1, 28, 1 do
			local name=ATSWInv_GetItemName(BANK_CONTAINER,slot);
			if(name and name==reqname) then
				local icon, count = GetContainerItemInfo(BANK_CONTAINER, slot);
				local fetchcount=reqcount;
				if(reqcount>count) then fetchcount=count; end
				if(fetchcount>0) then
					ATSWBankFetchItem(name, BANK_CONTAINER, slot, fetchcount, count);
					reqcount=reqcount-fetchcount;
				end
			end
		end
		for container=5, 11, 1 do
			for slot=1, GetContainerNumSlots(container), 1 do
				local name=ATSWInv_GetItemName(container,slot);
				if(name and name==reqname) then
					local icon, count = GetContainerItemInfo(container, slot);
					local fetchcount=reqcount;
					if(reqcount>count) then fetchcount=count; end
					if(fetchcount>0) then
						ATSWBankFetchItem(name, container, slot, fetchcount, count);
						reqcount=reqcount-fetchcount;
					end
				end
			end
		end
	end
end

function ATSWBankFetchItem(name, bag, slot, reqcount, totalcount)
	ClearCursor();
	if(totalcount==1 or reqcount==totalcount) then
		PickupContainerItem(bag, slot);
	else
		SplitContainerItem(bag, slot, reqcount);
	end
	local container=ATSWInv_FindBagForItem(name, reqcount);
	if(container==nil or container==0) then PutItemInBackpack(); end
	if(container==1) then PutItemInBag(20); end
	if(container==2) then PutItemInBag(21); end
	if(container==3) then PutItemInBag(22); end
	if(container==4) then PutItemInBag(23); end
end

-- alternative character functions

atsw_playernames={};

function ATSWAlt_GetItemCount(name, player)
	return ATSWAlt_GetItemCountInInventory(name, player)+ATSWAlt_GetItemCountInBank(name, player);	
end

function ATSWAlt_GetItemCountInInventory(name, player)
	local itemcount=0;
	if(atsw_itemlist[GetRealmName()]) then
		atsw_playernames={};
		table.foreach(atsw_itemlist[GetRealmName()],ATSWAlt_TableIterator);
		for i=1,table.getn(atsw_playernames),1 do
			if(atsw_itemlist[GetRealmName()][atsw_playernames[i]] and (player==atsw_playernames[i] or player==nil)) then
				if(atsw_itemlist[GetRealmName()][atsw_playernames[i]][name]) then
					itemcount=itemcount+atsw_itemlist[GetRealmName()][atsw_playernames[i]][name];
				end
			end
		end
	end
	return itemcount;	
end

function ATSWAlt_GetItemCountInBank(name, player)
	local itemcount=0;
	if(atsw_bankitemlist[GetRealmName()]) then
		atsw_playernames={};
		table.foreach(atsw_bankitemlist[GetRealmName()],ATSWAlt_TableIterator);
		for i=1,table.getn(atsw_playernames),1 do
			if(atsw_bankitemlist[GetRealmName()][atsw_playernames[i]] and (player==atsw_playernames[i] or player==nil)) then
				if(atsw_bankitemlist[GetRealmName()][atsw_playernames[i]][name]) then
					itemcount=itemcount+atsw_bankitemlist[GetRealmName()][atsw_playernames[i]][name];
				end
			end
		end
	end
	return itemcount;	
end

function ATSWAlt_TableIterator(key,value)
	if(key~=UnitName("player")) then table.insert(atsw_playernames,key); end
end

function ATSWAlt_GetItemLocation(name)
	ATSW_DisplayMessage(ATSW_ALTLIST1..name..ATSW_ALTLIST2);
	if(atsw_itemlist[GetRealmName()]) then
		atsw_playernames={};
		table.foreach(atsw_itemlist[GetRealmName()],ATSWAlt_TableIterator);
		for i=1,table.getn(atsw_playernames),1 do
			if(atsw_itemlist[GetRealmName()][atsw_playernames[i]]) then
				if(atsw_itemlist[GetRealmName()][atsw_playernames[i]][name]) then
					ATSW_DisplayMessage(atsw_itemlist[GetRealmName()][atsw_playernames[i]][name].."x "..ATSW_ALTLIST3..atsw_playernames[i]);
				end
			end
		end
	end
	if(atsw_bankitemlist[GetRealmName()]) then
		atsw_playernames={};
		table.foreach(atsw_bankitemlist[GetRealmName()],ATSWAlt_TableIterator);
		for i=1,table.getn(atsw_playernames),1 do
			if(atsw_bankitemlist[GetRealmName()][atsw_playernames[i]]) then
				if(atsw_bankitemlist[GetRealmName()][atsw_playernames[i]][name]) then
					ATSW_DisplayMessage(atsw_bankitemlist[GetRealmName()][atsw_playernames[i]][name].."x "..ATSW_ALTLIST4..atsw_playernames[i]);
				end
			end
		end
	end
end

-- auction functions

atsw_displayshoppinglist=true;

function ATSWAuction_ShowShoppingList()
	if(AuctionFrame:IsVisible() and ATSWAuction_UpdateReagentList()>0 and atsw_displayshoppinglist) then
		ATSWShoppingListFrame:Show();
		ATSWShoppingListFrame:SetPoint("TOPLEFT","AuctionFrame","TOPLEFT",353,-436);
		ATSW_NoteNecessaryItemsForQueue();
		ATSWAuction_UpdateReagentList();
	end
end

function ATSWAuction_HideShoppingList()
	ATSWShoppingListFrame:Hide();	
end

function ATSWAuction_UpdateReagentList()
	local necessary={};
	local charname, skillname, skillarrays, k, v;
	if(atsw_savednecessaryitems) then
		for charname, skillarrays in pairs(atsw_savednecessaryitems) do
			if(skillarrays) then
				for skillname, necessaryitems in pairs(skillarrays) do
					for k, v in pairs(necessaryitems) do
						table.insert(necessary, {name=v.name,count=v.cnt,link=v.link});
					end
				end
			end
		end
	end
	local reagents=table.getn(necessary);
	local offset=FauxScrollFrame_GetOffset(ATSWSLScrollFrame);
	for i=1,5,1 do
		local count=getglobal("ATSWSLFReagent"..i.."Count");
		local item=getglobal("ATSWSLFReagent"..i.."Item");
		local inv=getglobal("ATSWSLFReagent"..i.."Inventory");
		local bank=getglobal("ATSWSLFReagent"..i.."Bank");
		local merchant=getglobal("ATSWSLFReagent"..i.."Merchant");
		local alt=getglobal("ATSWSLFReagent"..i.."Alt");
		local missing=getglobal("ATSWSLFReagent"..i.."Missing");
		if(necessary[offset+i]) then
			local items_inventory=ATSWInv_GetItemCount(necessary[offset+i].name);
			local items_bank=ATSWBank_GetItemCount(necessary[offset+i].name);
			local items_alt=ATSWAlt_GetItemCount(necessary[offset+i].name);
			local items_missing=items_inventory+items_bank+items_alt-necessary[offset+i].count;
			local items_merchant=ATSWMerchant_CheckIfAvailable(necessary[offset+i].name);
			count:SetText(necessary[offset+i].count.."x");
			count:Disable();
			count:Show();
			item:SetText("["..necessary[offset+i].name.."]");
			item.link=necessary[offset+i].link;			
			item.itemname=necessary[offset+i].name;
			item:Show();
			if(items_inventory>=necessary[offset+i].count) then items_inventory="|cff00ff00"..items_inventory.."|r"; else items_inventory="|cffff0000"..items_inventory.."|r"; end
			inv:SetText(items_inventory);
			inv:Disable();
			inv:Show();
			if(items_bank>=necessary[offset+i].count) then items_bank="|cff00ff00"..items_bank.."|r"; else items_bank="|cffff0000"..items_bank.."|r"; end
			bank:SetText(items_bank);
			bank:Disable();
			bank:Show();
			merchant:SetText("X");
			merchant:Disable();
			if(items_merchant==true) then
				merchant:Show();
			else
				merchant:Hide();
			end
			alt:SetText(items_alt);
			if(items_alt>0) then
				alt:Enable();
				if(items_alt>=necessary[offset+i].count) then items_alt="|cff00ff00"..items_alt.."|r"; else items_alt="|cffff0000"..items_alt.."|r"; end
				alt.itemname=necessary[offset+i].name;
			else
				alt:Disable();
			end
			alt:Show();
			if(items_missing>=0) then
				missing:SetText("|cff00ff00".."+"..items_missing.."|r");
			else
				missing:SetText("|cffff0000"..items_missing.."|r");
			end
			missing:Disable();
			missing:Show();
		else
			count:Hide();
			item:Hide();
			inv:Hide();
			bank:Hide();
			merchant:Hide();
			alt:Hide();
			missing:Hide();
		end
	end
	FauxScrollFrame_Update(ATSWSLScrollFrame, reagents, 5, 5);
	return reagents;
end

function ATSWAuction_SearchForItem(itemname)
	if(CanSendAuctionQuery()) then
		BrowseName:SetText(itemname);
		AuctionFrameBrowse_Search();
		BrowseNoResultsText:SetText(BROWSE_NO_RESULTS);
	end
end

-- merchant functions

atsw_autobuy=false;
atsw_merchantlist={};

function ATSWMerchant_InsertAutoBuyButton()
	if(table.getn(atsw_queue)==0) then return; end
	if(ATSWMerchant_Buy(true)==false) then return; end
	ATSWAutoBuyButtonFrame:Show();
	ATSWAutoBuyButtonFrame:SetPoint("TOPLEFT", "MerchantFrame", "TOPLEFT" , 60, -28);
	ATSWAutoBuyButtonFrame:SetFrameStrata("HIGH");
end

function ATSWMerchant_RemoveAutoBuyButton()
	ATSWAutoBuyButtonFrame:Hide();
end

function ATSWMerchant_ExecuteAutoBuy()
	ATSWMerchant_RemoveAutoBuyButton();
	ATSWMerchant_Buy();
end

function ATSWMerchant_UpdateMerchantList()
	if(MerchantFrame:IsVisible()) then
		local numitems=GetMerchantNumItems();
		if(numitems==148) then numitems=0; end
		for i=1,numitems,1 do
			local itemname=ATSWMerchant_GetItemName(i);
			if(itemname) then
				local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i);
				if(numAvailable==-1) then
					atsw_merchantlist[itemname]=true;
				end
			end
		end
	end
end

function ATSWMerchant_GetItemName(slot)
	local link = GetMerchantItemLink(slot);
	if(link) then
    	local _,_,name = string.find(link, "^.*%[(.*)%].*$");
    	return name;
 	else
    	return nil;
    end
end

function ATSWMerchant_CheckIfAvailable(itemname)
	if(atsw_merchantlist[itemname]) then
		return true;
	else
		return false;
	end
end

function ATSWMerchant_AutoBuy()
	if(atsw_autobuy==true) then
		ATSWMerchant_Buy();
	end
end

function ATSWMerchant_Buy(onlyCheck)
	local needtobuy=false;
	if(table.getn(atsw_queue)>0) then
		if(MerchantFrame:IsVisible()) then
			ATSW_NoteNecessaryItemsForQueue();
			autobuymessage=false;
			local numitems=GetMerchantNumItems();
			if(numitems==148) then numitems=0; end
			for i=1,numitems,1 do
				local itemname=ATSWMerchant_GetItemName(i);
				if(itemname) then
					for k=1,table.getn(atsw_necessaryitems),1 do
						if(atsw_necessaryitems[k]) then
							if(atsw_necessaryitems[k].name==itemname) then
								local stilltobuy=atsw_necessaryitems[k].cnt-ATSWInv_GetItemCount(itemname);
								if(stilltobuy>0) then
									local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i);
									local sName, sLink, iQuality, iLevel, iMinLevel, sType, sSubType, iCount = GetItemInfo(GetMerchantItemLink(i));
									local itemstobuy=math.ceil(stilltobuy/quantity);
									if(onlyCheck==nil or onlyCheck==false) then
										if(iCount==nil) then
											for l=1,itemstobuy,1 do
												BuyMerchantItem(i,1);
											end
										else
											local fullstackstobuy=math.floor(stilltobuy/iCount);
											local fullstackitemcount=math.floor(iCount/quantity);
											local resttobuy=math.ceil((stilltobuy-(fullstackstobuy*iCount))/quantity);
											if(fullstackstobuy>0) then
												for l=1,fullstackstobuy,1 do
													BuyMerchantItem(i,fullstackitemcount);
												end
											end
											if(resttobuy>0) then
												BuyMerchantItem(i,resttobuy);
											end
										end
										if(autobuymessage==false) then
											ATSW_DisplayMessage(ATSW_AUTOBUYMESSAGE);
											autobuymessage=true;
										end
										local totalprice=price*itemstobuy;
										local gold=math.floor(totalprice/10000);
										local silver=math.floor((totalprice-gold*10000)/100);
										local copper=math.fmod(totalprice,100);
										local moneystring="";
										if(gold>0) then
											moneystring=gold.."g "..silver.."s "..copper.."c";
										elseif(silver>0) then
											moneystring=silver.."s "..copper.."c";
										else
											moneystring=copper.."c";
										end
										ATSW_DisplayMessage((itemstobuy*quantity).."x "..GetMerchantItemLink(i).." ("..moneystring..")");
									else
										needtobuy=true;
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return needtobuy;
end

-- all reagents for all queues frame functions

atsw_displayreagentlist=false;

function ATSWAllReagentListCharDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, ATSWAllReagentListCharDropDown_Initialize);
	UIDropDownMenu_SetWidth(this, 400);
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, 1);
end

function ATSWAllReagentListCharDropDown_OnShow()
	UIDropDownMenu_Initialize(this, ATSWAllReagentListCharDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, 1);
	FauxScrollFrame_SetOffset(ATSWARLFScrollFrame, 0);
	ATSWAllReagentList_ScrollUpdate();
end

function ATSWAllReagentList_OpenBankFrame()
	if(atsw_savednecessaryitems) then
		for k, v in pairs(atsw_savednecessaryitems)  do
			for k2, v2 in pairs(v) do
				if(table.getn(v2)>0) then
					ShowUIPanel(ATSWAllReagentListFrame);
					return;
				end
			end
		end
	end
end

function ATSWAllReagentList_CloseBankFrame()
	HideUIPanel(ATSWAllReagentListFrame);
end

function ATSWAllReagentListCharDropDown_Initialize()
	local info={};
	local count=0;
	if(atsw_savednecessaryitems) then
		for k, v in pairs(atsw_savednecessaryitems)  do
			for k2, v2 in pairs(v) do
				if(table.getn(v2)>0) then
					info.text=k.." - "..k2;
					info.func=ATSWAllReagentListCharDropDownButton_OnClick;
					info.checked=false;
					info.charname=k;
					UIDropDownMenu_AddButton(info);
					count=count+1;
				end
			end
		end
	end
	if(count==0) then
		info.text=ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY;
		info.func=nil;
		info.checked=false;
		UIDropDownMenu_AddButton(info);
	end
end

function ATSWAllReagentListCharDropDownButton_OnClick()
	UIDropDownMenu_SetSelectedID(ATSWAllReagentListCharDropDown, this:GetID());
	local charname, skillname=string.match(this:GetText(), "(%w*) %- (%w*)");
	ATSWAllReagentList_Update(charname, skillname);
	FauxScrollFrame_SetOffset(ATSWARLFScrollFrame, 0);
end

function ATSWAllReagentList_ScrollUpdate()
	local charname, skillname=string.match(UIDropDownMenu_GetText(ATSWAllReagentListCharDropDown), "(%w*) %- (%w*)");
	ATSWAllReagentList_Update(charname, skillname);
end

function ATSWAllReagentList_Update(charname, skillname)
	local offset=FauxScrollFrame_GetOffset(ATSWARLFScrollFrame);
	local necessary={};
	if(charname) then
		ATSWAllReagentListFrameHeader1:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..charname);
		ATSWAllReagentListFrameHeader2:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..UnitName("player"));
		if(atsw_savednecessaryitems[charname] and atsw_savednecessaryitems[charname][skillname]) then
			for k, v in pairs(atsw_savednecessaryitems[charname][skillname]) do
				table.insert(necessary, {name=v.name,count=v.cnt,link=v.link});
			end
		end
	end
	for i=1+offset, 7+offset, 1 do
		local lcount=getglobal("ATSWARLFReagent"..(i-offset).."Count");
		local lname=getglobal("ATSWARLFReagent"..(i-offset).."Item");
		local lorigcount=getglobal("ATSWARLFReagent"..(i-offset).."OrigCount");
		local llocalcount=getglobal("ATSWARLFReagent"..(i-offset).."LocalCount");
		local laltcount=getglobal("ATSWARLFReagent"..(i-offset).."AltCount");
		local lmerchant=getglobal("ATSWARLFReagent"..(i-offset).."Merchant");
		if(necessary[i]) then
			local localcount=ATSWInv_GetItemCount(necessary[i].name)+ATSWBank_GetItemCount(necessary[i].name);
			local origcount=ATSWAlt_GetItemCount(necessary[i].name, charname);
			local altcount=ATSWAlt_GetItemCount(necessary[i].name);
			local merchant=ATSWMerchant_CheckIfAvailable(necessary[i].name);
			if(UnitName("player")~=charname) then
				altcount=altcount-origcount;
			end
			lcount:SetText(necessary[i].count);
			lname:SetText("["..necessary[i].name.."]");
			lname.link=necessary[i].link;
			lname.itemname=necessary[i].name;
			lorigcount:SetText(origcount);
			llocalcount:SetText(localcount);
			laltcount:SetText(altcount);
			laltcount.itemname=necessary[i].name;
			if(merchant==true) then
				lmerchant:SetText("X");
			else
				lmerchant:SetText("");
			end
		else
			lcount:SetText("");
			lname:SetText("");
			lname.link=nil;
			lorigcount:SetText("");
			llocalcount:SetText("");
			laltcount:SetText("");
			lmerchant:SetText("");
		end
		lmerchant:Disable();
		llocalcount:Disable();
		lorigcount:Disable();
	end
	FauxScrollFrame_Update(ATSWARLFScrollFrame, table.getn(necessary), 7, 22);
end

function ATSWAllReagentList_FetchItemsFromBank(itemname)
	if(atsw_bankopened==false) then return; end
	local charname, skillname=string.match(UIDropDownMenu_GetText(ATSWAllReagentListCharDropDown), "(%w*) %- (%w*)");
	local offset=FauxScrollFrame_GetOffset(ATSWARLFScrollFrame);
	local necessary={};
	if(charname) then
		ATSWAllReagentListFrameHeader1:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..charname);
		ATSWAllReagentListFrameHeader2:SetText(ATSW_ALLREAGENTLISTFRAME_CH1..UnitName("player"));
		if(atsw_savednecessaryitems[charname] and atsw_savednecessaryitems[charname][skillname]) then
			for k, v in pairs(atsw_savednecessaryitems[charname][skillname]) do
				table.insert(necessary, {name=v.name,count=v.cnt,link=v.link});
			end
		end
	end
	for i=1,table.getn(necessary),1 do
		local itemstofetch=0;
		if(UnitName("player")==charname) then
			itemstofetch=necessary[i].count-ATSWInv_GetItemCount(necessary[i].name);
		else
			itemstofetch=necessary[i].count-ATSWAlt_GetItemCount(necessary[i].name, charname)-ATSWInv_GetItemCount(necessary[i].name);
		end
		if(itemstofetch>0 and (itemname==nil or itemname==necessary[i].name)) then
			ATSWBank_FetchItemsFromBank(necessary[i].name, itemstofetch);
		end
	end
end

-- slow scanning mechanism

function ATSW_InitSlowScan()
	if(TradeSkillFrame and TradeSkillFrame:IsVisible() and ATSW_IsCurrentlyEnabled()) then
		ATSW_HideBlizzardTradeSkillFrame();
	end
	local blah=GetNumTradeSkills();
	atsw_scan_timeout=3.0;
	atsw_scan_state=1;
	ATSWScanDelayFrame:Show();
	ATSWScanDelayFrameBar:SetMinMaxValues(0,1);
	ATSWScanDelayFrameBar:SetValue(0);
	ATSWScanDelayFrameBarText:SetText(ATSW_SCAN_DELAY_FRAME_INITIALIZING);
end

function ATSW_FinalizeSlowScan()
	atsw_scan_state=0;
	ATSWScanDelayFrame:Hide();
	local version,build,date=GetBuildInfo();
	local locale=GetLocale();
	atsw_prescanned[atsw_selectedskill]=build..locale;
	ATSW_ShowWindow();
end

function ATSW_AbortSlowScan()
	atsw_scan_state=0;
	ATSWScanDelayFrame:Hide();
	ATSW_HideWindow();
end

function ATSW_SkipSlowScan()
	ATSW_FinalizeSlowScan();
end

function ATSWScanDelayFrame_OnUpdate()
	atsw_scan_timeout=atsw_scan_timeout-arg1;
	if(atsw_scan_timeout<=0) then
		atsw_scan_timeout=atsw_scan_delay;
		if(atsw_scan_state==1) then
			atsw_scan_state=2;
			atsw_scan_numtradeskills=GetNumTradeSkills();
			atsw_scan_nextskill=1;
			ATSWScanDelayFrameBar:SetMinMaxValues(0,atsw_scan_numtradeskills);
		end
		ATSW_ContinueSlowScan();
	end
end

function ATSW_ContinueSlowScan()
	if(atsw_scan_nextskill>=atsw_scan_numtradeskills) then
		ATSW_FinalizeSlowScan();
	else
		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(atsw_scan_nextskill);
		if(skillName~=nil) then
			if(skillType~="header") then
				local numReagents = GetTradeSkillNumReagents(atsw_scan_nextskill);
				local skillLink = GetTradeSkillItemLink(atsw_scan_nextskill);
				local numMade = GetTradeSkillNumMade(atsw_scan_nextskill);
				for j=1, numReagents, 1 do
					local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(atsw_scan_nextskill, j);
					local reagentLink = GetTradeSkillReagentItemLink(atsw_scan_nextskill,j);
				end
			end
		end
		atsw_scan_nextskill=atsw_scan_nextskill+1;
		ATSWScanDelayFrameBar:SetValue(atsw_scan_nextskill);
		ATSWScanDelayFrameBarText:SetText(atsw_scan_nextskill.." / "..atsw_scan_numtradeskills);
	end
end


-- general utility functions

function ATSW_DisplayMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function ATSW_HexToDec(hex)
	hex=string.upper(hex);
	local total=0;
	for i=1,string.len(hex),1 do
		local char=string.byte(hex,i);
		local numeric;
		if(char>64) then
			numeric=char-55;
		else
			numeric=char-48;
		end
		total=total+numeric*math.pow(16,string.len(hex)-i);
	end
	return total;
end

function ATSW_GetItemID(link)
	if(link) then
		local _,_,id = string.find(link, "^.*|Hitem:(%d*):.*%[.*%].*$");
		return id;
	else
		return nil;
	end
end

function ATSW_Round(number,decimals)
	return math.floor((number*math.pow(10,decimals)+0.5))/math.pow(10,decimals);
end

function ATSW_NOP()
	-- do nothing!
end