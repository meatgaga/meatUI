----------------------------------------------------------------------------------------
-- 防止一些设置矛盾
----------------------------------------------------------------------------------------
if SettingsCF.error.black == true and SettingsCF.error.white == true then
	SettingsCF.error.white = false
end

if SettingsCF.error.hide == true and SettingsCF.error.combat == true then
	SettingsCF.error.hide = false
end

----------------------------------------------------------------------------------------
-- 当某些单体插件载入时自动改变一些设置
----------------------------------------------------------------------------------------
if (IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames")) then
	SettingsCF.unitframe.enable = false
end

if (IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2") or IsAddOnLoaded("HealBot") or IsAddOnLoaded("VuhDo") or IsAddOnLoaded("oUF_Freebgrid")) then
	SettingsCF.unitframe.show_raid = false
end

if (IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("Aloft") or IsAddOnLoaded("dNamePlates") or IsAddOnLoaded("caelNamePlates")) then
	SettingsCF.nameplate.enable = false
end

if (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4")) then
	SettingsCF.actionbar.enable = false
end

if (IsAddOnLoaded("Mapster")) then
	SettingsCF.map.enable = false
end

if (IsAddOnLoaded("Prat-3.0") or IsAddOnLoaded("Chatter")) then
	SettingsCF.chat.enable = false
end

if (IsAddOnLoaded("Quartz") or IsAddOnLoaded("AzCastBar") or IsAddOnLoaded("eCastingBar")) then
	SettingsCF.unitframe.unit_castbar = false
end

if (IsAddOnLoaded("Afflicted3") or IsAddOnLoaded("InterruptBar") or IsAddOnLoaded("alEnemyCD")) then
	SettingsCF.cooldown.enemy_enable = false
end

if (IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip")) then
	SettingsCF.tooltip.enable = false
end

if (IsAddOnLoaded("Gladius")) then
	SettingsCF.unitframe.show_arena = false
end

if (IsAddOnLoaded("Omen") or IsAddOnLoaded("sThreatMeter2") or IsAddOnLoaded("SkadaThreat")) then
	SettingsCF.threat.enable = false
end

if (IsAddOnLoaded("DBM-SpellTimers") or IsAddOnLoaded("alRaidCD")) then
	SettingsCF.cooldown.raid_enable = false
end

if (IsAddOnLoaded("TipTacTalents")) then
	SettingsCF.tooltip.talents = false
end

if (IsAddOnLoaded("meatUI_Raid_Dps")) then
	SettingsCF.unitframe.arena_on_right = true
elseif (IsAddOnLoaded("meatUI_Raid_Heal")) then
	SettingsCF.unitframe.arena_on_right = false
end

if (IsAddOnLoaded("cargBags_Nivaya") or IsAddOnLoaded("cargBags")) then
	SettingsCF.bag.enable = false
	DisableAddOn("meatUI_Bag")
end

if not SettingsCF.bag.enable == true then
	DisableAddOn("meatUI_Bag")
end

if (IsAddOnLoaded("LiteStats")) then
	SettingsCF.infopanel.enable = false
end
