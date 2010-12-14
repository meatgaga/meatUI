----------------------------------------------------------------------------------------
-- 镜像条(呼吸/疲劳 等) (基于oUF_MirrorBar)
----------------------------------------------------------------------------------------
for _, bar in pairs({
		"MirrorTimer1",
		"MirrorTimer2",
		"MirrorTimer3",
	}) do
	for i, region in pairs({_G[bar]:GetRegions()}) do
		if (region.GetTexture and region:GetTexture() == "SolidTexture") then
		region:Hide()
		end
	end

	_G[bar.."Border"]:Hide()

	_G[bar]:SetParent(UIParent)
	_G[bar]:SetHeight(SettingsDB.Scale(16))
	_G[bar]:SetWidth(SettingsDB.Scale(280))

	_G[bar.."Background"] = _G[bar]:CreateTexture(bar.."Background", "BACKGROUND", _G[bar])
	_G[bar.."Background"]:SetTexture(SettingsCF.media.blank)
	_G[bar.."Background"]:SetAllPoints(bar)
	_G[bar.."Background"]:SetVertexColor(0.15, 0.15, 0.15)

	_G[bar.."Text"]:SetFont(SettingsCF.media.font, SettingsCF.media.font_size, SettingsCF.media.font_style)
	_G[bar.."Text"]:SetShadowColor(0, 0, 0, 0)
	_G[bar.."Text"]:ClearAllPoints()
	_G[bar.."Text"]:SetPoint("CENTER", MirrorTimer1StatusBar, 0, SettingsDB.Scale(1))

	_G[bar.."StatusBar"]:SetAllPoints(_G[bar])
	_G[bar.."StatusBar"]:SetStatusBarTexture(SettingsCF.media.bar)

	local border = SettingsDB.CreateShadowFrame(_G[bar], 1, "BACKGROUND")
	border:SetPoint("TOPLEFT", _G[bar], SettingsDB.Scale(-3), SettingsDB.Scale(3))
	border:SetPoint("BOTTOMRIGHT", _G[bar], SettingsDB.Scale(3), SettingsDB.Scale(-3))
end