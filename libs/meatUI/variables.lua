----------------------------------------------------------------------------------------
-- meatUI variables
----------------------------------------------------------------------------------------
SettingsCF = { }
SettingsDB = { }
SavedOptions = { }

SettingsDB.dummy = function() return end
SettingsDB.name, _ = UnitName("player")
_, SettingsDB.class = UnitClass("player")
SettingsDB.client = GetLocale()
SettingsDB.level = UnitLevel("player")
SettingsDB.resolution = GetCurrentResolution()
SettingsDB.getresolution = select(SettingsDB.resolution, GetScreenResolutions())
SettingsDB.version = GetAddOnMetadata("meatUI", "Version")
SettingsDB.release = GetAddOnMetadata("meatUI", "X-Release")
SettingsDB.combat = UnitAffectingCombat("player")
SettingsDB.patch = GetBuildInfo()
SettingsDB.color = RAID_CLASS_COLORS[SettingsDB.class]
