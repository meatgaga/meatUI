----------------------------------------------------------------------------------------
-- 所有错误信息查询: www.wowwiki.com/WoW_Constants/Errors
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
-- 白名单, 其中的错误不会隐藏
----------------------------------------------------------------------------------------
SettingsDB.white_list = {
	[ERR_INV_FULL] = true,
	[ERR_QUEST_LOG_FULL] = true,
	[ERR_ITEM_MAX_COUNT] = true,
	[ERR_NOT_ENOUGH_MONEY] = true,
}

----------------------------------------------------------------------------------------
-- 黑名单, 其中的错误将隐藏
----------------------------------------------------------------------------------------
SettingsDB.black_list = {
	[SPELL_FAILED_NO_COMBO_POINTS] = true,
	[SPELL_FAILED_TARGETS_DEAD] = true,
	[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
	[SPELL_FAILED_TARGET_AURASTATE] = true,
	[SPELL_FAILED_CASTER_AURASTATE] = true,
	[SPELL_FAILED_NO_ENDURANCE] = true,
	[SPELL_FAILED_BAD_TARGETS] = true,
	[SPELL_FAILED_NOT_MOUNTED] = true,
	[SPELL_FAILED_NOT_ON_TAXI] = true,
	[SPELL_FAILED_NOT_INFRONT] = true,
	[SPELL_FAILED_NOT_IN_CONTROL] = true,
	[SPELL_FAILED_MOVING] = true,
	[ERR_ATTACK_FLEEING] = true,
	[ERR_ITEM_COOLDOWN] = true,
	[ERR_GENERIC_NO_TARGET] = true,
	[ERR_ABILITY_COOLDOWN] = true,
	[ERR_NO_ATTACK_TARGET] = true,
	[ERR_SPELL_COOLDOWN] = true,
	[ERR_OUT_OF_ENERGY] = true,
	[ERR_OUT_OF_RAGE] = true,
	[ERR_OUT_OF_FOCUS] = true,
	[ERR_INVALID_ATTACK_TARGET] = true,
	[ERR_NOEMOTEWHILERUNNING] = true,
	[OUT_OF_ENERGY] = true,
}