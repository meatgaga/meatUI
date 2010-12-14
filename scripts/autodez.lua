----------------------------------------------------------------------------------------
-- 自动贪婪绿色物品(by Tekkub) 自动需求宝珠(by Myrilandell of Lothar)
----------------------------------------------------------------------------------------
if SettingsCF.loot.auto_greed == true then
	local autogreed = CreateFrame("frame")
	autogreed:RegisterEvent("START_LOOT_ROLL")
	autogreed:SetScript("OnEvent", function(self, event, id)
		local name = select(2, GetLootRollItemInfo(id))
		if (name == select(1, GetItemInfo(43102)) or name == select(1, GetItemInfo(47556)) or name == select(1, GetItemInfo(45087))) then
			RollOnLoot(id, 2)
		end
		if SettingsDB.level ~= MAX_PLAYER_LEVEL then return end
		if(id and select(4, GetLootRollItemInfo(id))==2 and not (select(5, GetLootRollItemInfo(id)))) then
			if RollOnLoot(id, 3) then
				RollOnLoot(id, 3)
			else
				RollOnLoot(id, 2)
			end
		end
	end)
end

----------------------------------------------------------------------------------------
-- 自动确认绑定提示 (tekKrush by Tekkub)
----------------------------------------------------------------------------------------
if SettingsCF.loot.auto_confirm == true then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:RegisterEvent("CONFIRM_LOOT_ROLL")
	acd:RegisterEvent("LOOT_BIND_CONFIRM")
	acd:SetScript("OnEvent", function(self, event, ...)
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
	end)
end