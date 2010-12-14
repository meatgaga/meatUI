----------------------------------------------------------------------------------------
-- 此模块将在meatUI_Config插件载入后读取新的玩家配置
----------------------------------------------------------------------------------------
if not IsAddOnLoaded("meatUI_Config") or GUIConfig == nil then return end

for group, options in pairs(GUIConfig) do
	if SettingsCF[group] then
		local count = 0
		for option, value in pairs(options) do
			if SettingsCF[group][option] ~= nil then
				if SettingsCF[group][option] == value then
					GUIConfig[group][option] = nil	
				else
					count = count + 1
					SettingsCF[group][option] = value
				end
			end
		end
		if count == 0 then GUIConfig[group] = nil end
	else
		GUIConfig[group] = nil
	end
end