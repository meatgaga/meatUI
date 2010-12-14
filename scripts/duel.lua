----------------------------------------------------------------------------------------
-- 自动拒绝决斗
----------------------------------------------------------------------------------------
if SettingsCF.misc.auto_decline_duel == true then
	local dd = CreateFrame("Frame")
	dd:RegisterEvent("DUEL_REQUESTED")
	dd:SetScript("OnEvent", function(self, event, name)
		HideUIPanel(StaticPopup1)
		CancelDuel()
		SettingsDB.AlertRun(L_INFO_DUEL..name,0,1,1)
	end)
end
