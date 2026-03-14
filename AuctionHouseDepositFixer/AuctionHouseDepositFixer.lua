local ServerSideDiscount, defaultDeposit, modifiedDeposit, roundedDeposit, finalDeposit

local function GetModifiedDeposit()
	ServerSideDiscount = 10 -- percentage of normal rates
	defaultDeposit = CalculateAuctionDeposit(AuctionFrameAuctions.duration, AuctionsStackSizeEntry:GetNumber() * AuctionsNumStacksEntry:GetNumber())
	modifiedDeposit = defaultDeposit * (ServerSideDiscount / 100)
	if modifiedDeposit == 0 then
		finalDeposit = 0
	elseif modifiedDeposit < 1 then
		finalDeposit = 1
	else finalDeposit = math.floor(modifiedDeposit)
		MoneyFrame_Update("AuctionsDepositMoneyFrame", finalDeposit)
	end
end

hooksecurefunc("UpdateDeposit", function()
	GetModifiedDeposit()
end)

hooksecurefunc("AuctionFrameTab_OnClick", function(self, index)
	local index = self:GetID();
	PanelTemplates_SetTab(AuctionFrame, index);
	AuctionFrameAuctions:Hide();
	AuctionFrameBrowse:Hide();
	AuctionFrameBid:Hide();
	PlaySound("igCharacterInfoTab");
	if ( index == 1 ) then
		-- Browse tab
		AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft");
		AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top");
		AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight");
		AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft");
		AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot");
		AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight");
		AuctionFrameBrowse:Show();
		AuctionFrame.type = "list";
		SetAuctionsTabShowing(false);
	elseif ( index == 2 ) then
		-- Bids tab
		AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft");
		AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Top");
		AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopRight");
		AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft");
		AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot");
		AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight");
		AuctionFrameBid:Show();
		AuctionFrame.type = "bidder";
		SetAuctionsTabShowing(false);
	elseif ( index == 3 ) then
		-- Auctions tab
		AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopLeft");
		AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Top");
		AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopRight");
		AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-BotLeft");
		AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot");
		AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-BotRight");
		AuctionFrameAuctions:Show();
		SetAuctionsTabShowing(true);
		GetModifiedDeposit();
	end
end)