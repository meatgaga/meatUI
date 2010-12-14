----------------------------------------------------------------------------------------
-- 便捷开关头盔和披风显示 (基于HatTrick by Tekkub)
----------------------------------------------------------------------------------------
--[[ I hate that I have to do this, but Blizz's option frame fucks up the setting unless it was set from their option frame
_G.ShowCloak, _G.ShowHelm = SettingsDB.dummy, SettingsDB.dummy

for _,check in pairs{InterfaceOptionsDisplayPanelShowCloak, InterfaceOptionsDisplayPanelShowHelm} do
	check:Disable()
	check.Enable = SettingsDB.dummy
end
]]
local hcheck = CreateFrame("CheckButton", "HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
hcheck:ClearAllPoints()
hcheck:SetWidth(22)
hcheck:SetHeight(22)
hcheck:SetPoint("TOPLEFT", CharacterHeadSlot, "TOPRIGHT", 5, 2)
hcheck:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
hcheck:SetScript("OnEnter", function()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
	GameTooltip:SetText(L_HELMTIP)
end)
hcheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
hcheck:SetScript("OnEvent", function() hcheck:SetChecked(ShowingHelm()) end)
hcheck:RegisterEvent("UNIT_MODEL_CHANGED")
hcheck:SetToplevel(true)

local ccheck = CreateFrame("CheckButton", "CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
ccheck:ClearAllPoints()
ccheck:SetWidth(22)
ccheck:SetHeight(22)
ccheck:SetPoint("TOPLEFT", CharacterBackSlot, "TOPRIGHT", 5, 2)
ccheck:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
ccheck:SetScript("OnEnter", function()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
	GameTooltip:SetText(L_CLOAKTIP)
end)
ccheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
ccheck:SetScript("OnEvent", function() ccheck:SetChecked(ShowingCloak()) end)
ccheck:RegisterEvent("UNIT_MODEL_CHANGED")
ccheck:SetToplevel(true)

hcheck:SetChecked(ShowingHelm())
ccheck:SetChecked(ShowingCloak())
