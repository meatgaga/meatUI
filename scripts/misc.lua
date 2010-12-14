----------------------------------------------------------------------------------------
-- 一些框体的位置改变
----------------------------------------------------------------------------------------
-- 帮助界面
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint(unpack(SettingsCF.position.ticket))
TicketStatusFrame.SetPoint = SettingsDB.dummy

-- 战场分数
if WorldStateAlwaysUpFrame then
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint(unpack(SettingsCF.position.attempt))
	WorldStateAlwaysUpFrame.SetPoint = SettingsDB.dummy
	WorldStateAlwaysUpFrame:SetFrameStrata("BACKGROUND")
	WorldStateAlwaysUpFrame:SetFrameLevel(0)
end

-- 占据进度条
--[[
local mcb = CreateFrame("Frame")
local function OnEvent()
	if NUM_EXTENDED_UI_FRAMES > 0 then
		for i = 1, NUM_EXTENDED_UI_FRAMES do
			_G["WorldStateCaptureBar" .. i]:ClearAllPoints()
			_G["WorldStateCaptureBar" .. i]:SetPoint(unpack(SettingsCF.position.capture_bar))
		end
	end
end
local mcb = CreateFrame("Frame")
mcb:RegisterEvent("PLAYER_LOGIN")
mcb:RegisterEvent("UPDATE_WORLD_STATES")
mcb:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
mcb:SetScript("OnEvent", OnEvent)
]]
local function CaptureUpdate()
	if NUM_EXTENDED_UI_FRAMES then
		local captureBar
		for i = 1, NUM_EXTENDED_UI_FRAMES do
			captureBar = getglobal("WorldStateCaptureBar" .. i)

			if captureBar and captureBar:IsVisible() then
				captureBar:ClearAllPoints()
				if i == 1 then
					captureBar:SetPoint(unpack(SettingsCF.position.capture_bar))
				else
					captureBar:SetPoint("TOPLEFT", getglobal("WorldStateCaptureBar" .. i - 1 ), "TOPLEFT", 0, SettingsDB.Scale(-25))
				end
			end	
		end	
	end
end
hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)

-- 错误信息
UIErrorsFrame:ClearAllPoints()
UIErrorsFrame:SetPoint(unpack(SettingsCF.position.uierror))

-- 任务监视
WatchFrame:ClearAllPoints()
WatchFrame:SetPoint(unpack(SettingsCF.position.quest))
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(500)
WatchFrame.SetPoint = SettingsDB.dummy
WatchFrame.ClearAllPoints = SettingsDB.dummy

-- 载具指示
hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(_, _, parent)
	if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint(unpack(SettingsCF.position.vehicle))
	end
end)

-- 成就获得
local function Reanchor()
	local one, two, lfg = AchievementAlertFrame1, AchievementAlertFrame2, DungeonCompletionAlertFrame1
	if one then
		one:ClearAllPoints()
		one:SetPoint("TOP", UIParent, "TOP", 0, -20)
	end
	if two then
		two:ClearAllPoints()
		two:SetPoint("TOP", one, "BOTTOM", 0, -10)
	end
	if lfg:IsShown() then
		lfg:ClearAllPoints()
		if one then
			if two then
				lfg:SetPoint("TOP", two, "BOTTOM", 0, -10)
			else
				lfg:SetPoint("TOP", one, "BOTTOM", 0, -10)
			end
		else
			lfg:SetPoint("TOP", UIParent, "TOP", 0, -20)
		end
	end
end

local achframe = CreateFrame("Frame", nil, UIParent)
achframe:RegisterEvent("VARIABLES_LOADED")
achframe:RegisterEvent("ACHIEVEMENT_EARNED")
achframe:SetScript("OnEvent", function()
	AlertFrame_FixAnchors = Reanchor
end)

-- 战场计分板
WorldStateScoreFrame:SetScale(0.85)

----------------------------------------------------------------------------------------
-- 就位检查警告
----------------------------------------------------------------------------------------
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then
		PlaySound("ReadyCheck")
	end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

----------------------------------------------------------------------------------------
-- ALT+点击购买整组物品
----------------------------------------------------------------------------------------
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(this:GetID())))
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(this:GetID())
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(this:GetID(), floor(maxStack / quantity))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end

----------------------------------------------------------------------------------------
-- ALT+点击物品进行交易
----------------------------------------------------------------------------------------
if IS_WRATH_BUILD == nil then IS_WRATH_BUILD = (select(4, GetBuildInfo()) >= 30000) end

local targ, bag, slot

local orig1 = ContainerFrameItemButton_OnModifiedClick
ContainerFrameItemButton_OnModifiedClick = function(...)
	local self, button
	if IS_WRATH_BUILD then self, button = ... else button = ... end
	if button == "LeftButton" and IsAltKeyDown() and not CursorHasItem() then
		bag, slot = this:GetParent():GetID(), this:GetID()
		if TradeFrame:IsVisible() then
			for i=1,6 do
				if not GetTradePlayerItemLink(i) then
					PickupContainerItem(bag, slot)
					ClickTradeButton(i)
					bag, slot = nil, nil
					return
				end
			end
		elseif not CursorHasItem() and UnitExists("target") and UnitIsFriend("player", "target") and UnitIsPlayer("target") and CheckInteractDistance("target", 2) then
			targ = UnitName("target")
			InitiateTrade("target")
			return
		end
	end
	orig1(...)
end

local function posthook(...)
	if targ and not CursorHasItem() and UnitName("target") == targ then
		PickupContainerItem(bag, slot)
		ClickTradeButton(1)
	end
	targ, bag, slot = nil, nil, nil
	return ...
end

local orig2 = TradeFrame:GetScript("OnShow")
TradeFrame:SetScript("OnShow", function(...)
	if orig2 then return posthook(orig2(...))
	else posthook() end
end)

----------------------------------------------------------------------------------------
-- 已开启窗口的动作不干扰隐藏窗口 (by Fernir)
----------------------------------------------------------------------------------------
local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_AuctionUI" then
		AuctionFrame:SetMovable(true)
		AuctionFrame:SetClampedToScreen(true)
		AuctionFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		AuctionFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)

		local handleAuctionFrame = function(self)
			if AuctionFrame:GetAttribute("UIPanelLayout-enabled") then
				if AuctionFrame:IsVisible() then
					AuctionFrame.Hide = function() end
					HideUIPanel(AuctionFrame)
					AuctionFrame.Hide = nil
				end
				AuctionFrame:SetAttribute("UIPanelLayout-enabled", nil)
			else
				if AuctionFrame:IsVisible() then
					AuctionFrame.IsShown = function() end
					ShowUIPanel(AuctionFrame)
					AuctionFrame.IsShown = nil
				end
			end
		end
		hooksecurefunc("AuctionFrame_Show", handleAuctionFrame)
		hooksecurefunc("AuctionFrame_Hide", handleAuctionFrame)

		self:UnregisterEvent"ADDON_LOADED"
		self:SetScript("OnEvent", nil)
	end
end)
