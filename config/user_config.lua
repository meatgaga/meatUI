----------------------------------------------------------------------------------------
-- meatUI的个人配置文件
-- 更新前务必备份此文件!
-- 注意: 此文件必须为UTF-8编码格式!
-- 附注: 此文件在config.lua之后载入, 因此将覆盖其中的一些设置!
----------------------------------------------------------------------------------------
-- 配置格式示例:
----------------------------------------------------------------------------------------
-- if SettingsDB.name == "MegaChar" then
-- 	SettingsCF["chat"].width = 100500
-- 	SettingsCF["tooltip"].cursor = false
-- 	SettingsCF["unitframe"].plugins_totem_bar = false
-- 	SettingsCF["addon"].pvp = {ADDON1, ADDON2, ADDON3, ETC}
-- 	SettingsCF["addon"].raid = {ADDON1, ADDON2, ADDON3, ETC}
-- 	SettingsCF["position"].tooltip = {"BOTTOMRIGHT", Minimap, "TOPRIGHT", 2, 5}
-- 	SettingsCF["position"].actionbars.bar1 = {"BOTTOM", UIParent, "BOTTOM", 2, 8}
-- end
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
-- 对应每个职业的配置
-- 职业名称需要大写
----------------------------------------------------------------------------------------
if SettingsDB.class == "DRUID" then

end

--if SettingsDB.class == "WARLOCK" then
-- SettingsCF["combattext"].stop_fa_spam = true
--end

--if SettingsDB.class == "PRIEST" then
-- SettingsCF["combattext"].stop_ve_spam = true
--end

----------------------------------------------------------------------------------------
-- 对应每个角色的配置(相同项目将覆盖上面的职业配置)
-- 角色名区分大小写
----------------------------------------------------------------------------------------
if SettingsDB.name == "Черешок" 
	or SettingsDB.name == "Вершок"
	or SettingsDB.name == "Вещмешок" 
	or SettingsDB.name == "Гребешок" 
	or SettingsDB.name == "Кулешок" 
	or SettingsDB.name == "Лапушок" 
	or SettingsDB.name == "Обушок" 
	or SettingsDB.name == "Ремешок"
	or SettingsDB.name == "Шестак" then
	SettingsCF["general"].minimap_icon = false
	SettingsCF["general"].welcome_message = false
	SettingsCF["misc"].auto_quest = true
	SettingsCF["tooltip"].shift_modifer = true
	SettingsCF["tooltip"].cursor = true
	SettingsCF["tooltip"].talents = true
	SettingsCF["tooltip"].title = true
	SettingsCF["unitframe"].arena_on_right = false
	SettingsCF["unitframe"].plugins_aura_watch = true
end