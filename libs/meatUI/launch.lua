----------------------------------------------------------------------------------------
-- 首次登录运行的文件
----------------------------------------------------------------------------------------
local function InstallUI()
	-- 无需多次设置CVar
	SetCVar("buffDurations", 1)							-- 显示法术效果持续时间
	SetCVar("autoSelfCast", 1)							-- 自动自我施法
	SetCVar("screenshotFormat", "TGA")					-- 截屏图像格式，"TGA" 或 "JPG"
	SetCVar("screenshotQuality", 10)						-- 截屏时JPEG的图像质量(需要截屏图像格式为JPG)
	SetCVar("cameraDistanceMax", 15)						-- 最大镜头距离
	SetCVar("cameraDistanceMaxFactor", 2)					-- 最大镜头距离系数
	SetCVar("showClock", 0)								-- 显示游戏自带时钟
	SetCVar("rotateMinimap", 0)							-- 旋转地图
	SetCVar("showItemLevel", 1)							-- 显示物品等级
	SetCVar("equipmentManager", 1)						-- 装备管理
	--SetCVar("mapQuestDifficulty", 1)						-- 任务难度地图显示
	SetCVar("previewTalents", 1)							-- 预览天赋
	--SetCVar("showTutorials", 0)							-- 显示教程
	SetCVar("showNewbieTips", 0)							-- 显示新手提示
	SetCVar("UberTooltips", 1)							-- 
	SetCVar("showLootSpam", 1)							-- 
	--SetCVar("chatMouseScroll", 1)							-- 聊天框允许鼠标滚轮
	SetCVar("removeChatDelay", 1)							-- 移除聊天标签弹出延迟
	--SetCVar("chatStyle", "im")							-- 聊天模式
	--SetCVar("WholeChatWindowClickable", 0)				-- 整个聊天窗口可点击
	--SetCVar("ConversationMode", "inline")					-- 
	SetCVar("colorblindMode", 0)							-- ?色盲模式?
	SetCVar("hidePartyInRaid", 1)							-- 团队中隐藏小队
	SetCVar("lootUnderMouse", 0)							-- 拾取窗口跟随鼠标
	SetCVar("autoLootDefault", 1)							-- 自动拾取
	SetCVar("scriptErrors", 0)							-- 显示LUA错误
	SetCVar("alwaysShowActionBars", 1)					-- 总是显示动作条
--	SetCVar("nameplateAllowOverlap", 1)					-- 允许姓名板重叠 (3.2.x无效)
	SetCVar("autoDismountFlying", 1)						-- 允许自动取消飞行
	SetCVar("autoQuestWatch", 0)							-- 自动监视任务
	SetCVar("autoQuestProgress", 1)						-- 自动任务进展更新
	SetCVar("chatBubblesParty", 0)						-- 队伍聊天泡泡
	SetCVar("chatBubbles", 0)								-- 聊天泡泡
	SetCVar("guildMemberNotify", 1)						-- 公会成员提示
	SetCVar("UnitNameOwn", 1)								-- 显示自身名称
	SetCVar("UnitNameNPC", 1)								-- 显示NPC名称
--	SetCVar("UnitNameNonCombatCreatureName", 1)			-- ?
	SetCVar("UnitNamePlayerGuild", 1)						-- 显示公会名称
	SetCVar("UnitNamePlayerPVPTitle", 1)					-- 显示玩家PVP头衔
	SetCVar("UnitNameFriendlyPlayerName", 1)				-- 显示友方玩家名称
	SetCVar("UnitNameFriendlyPetName", 1)					-- 显示友方宠物名称
--	SetCVar("UnitNameFriendlyGuardianName", 1)			-- 显示友方守卫名称
--	SetCVar("UnitNameFriendlyTotemName", 1)				-- 显示友方图腾名称
	SetCVar("UnitNameEnemyPlayerName", 1)					-- 显示敌方玩家名称
	SetCVar("UnitNameEnemyPetName", 1)					-- 显示敌方宠物名称
--	SetCVar("UnitNameEnemyGuardianName", 1)				-- 显示敌方守卫名称
--	SetCVar("UnitNameEnemyTotemName", 1)					-- 显示敌方图腾名称
	SetCVar("nameplateShowFriends", 0)					-- 显示友方姓名板
--	SetCVar("nameplateShowFriendlyPets", 0)				-- 显示友方宠物姓名板
--	SetCVar("nameplateShowFriendlyGuardians", 0)			-- 显示友方守卫姓名板
--	SetCVar("nameplateShowFriendlyTotems", 0)				-- 显示友方图腾姓名板
	SetCVar("nameplateShowEnemies", 1)					-- 显示敌方姓名板
--	SetCVar("nameplateShowEnemyPets", 1)					-- 显示敌方宠物姓名板
--	SetCVar("nameplateShowEnemyGuardians", 1)				-- 显示敌方守卫姓名板
--	SetCVar("nameplateShowEnemyTotems", 1)				-- 显示敌方图腾姓名板
	SetCVar("ShowClassColorInNameplate", 1)				-- 姓名板按职业着色
	SetCVar("CombatDamage", 1)							-- 伤害文字
	SetCVar("CombatHealing", 1)							-- 治疗文字
	SetCVar("Maxfps", 120)								-- 每秒最大帧数
	SetCVar("spamFilter", 0)								-- ?
	SetCVar("questFadingDisable", 1)						-- 直接显示任务文字
	SetCVar("ShowAllSpellRanks", 0)						-- 显示所有法术等级
	SetCVar("lockActionBars", 1)							-- 锁定动作条
	SetCVar("screenEdgeFlash", 0)							-- 屏幕边缘闪光
--	WorldMap_ToggleSizeDown()								-- ?

	if SettingsCF.misc.always_compare == true then
		SetCVar("alwaysCompareItems", 1)					--总是进行装备比较
	else
		SetCVar("alwaysCompareItems", 0)
	end

--	if SettingsDB.name == "Черешок" 
--		or SettingsDB.name == "Вершок" then
--	end

	-- 聊天框
	if SettingsCF.chat.enable == true then
		FCF_ResetChatWindows()
		FCF_SetLocked(ChatFrame1, 1)

		FCF_OpenNewWindow("clean")
--		FCF_UnDockFrame(ChatFrame3)
		FCF_SetLocked(ChatFrame3, 1)
--		ChatFrame3:Show();

		for i = 1, NUM_CHAT_WINDOWS do
			local frame = _G[format("ChatFrame%s", i)]
			local chatFrameId = frame:GetID()
--			local chatName = FCF_GetChatWindowInfo(chatFrameId)

--			FCF_DockFrame(frame)

			-- Move general chat to bottom left
			if i == 1 then
				frame:ClearAllPoints()
				frame:SetPoint(unpack(SettingsCF.position.chat))
				FCF_SetWindowName(frame, "General")			-- 重命名标签
			elseif i == 2 then
				FCF_SetWindowName(frame, "Combat")			-- 重命名标签
			end

			-- 储存新默认窗口的位置和尺寸
			--FCF_SavePositionAndDimensions(frame)
			
			-- 设定默认聊天字体尺寸
			FCF_SetChatWindowFontSize(nil, frame, SettingsCF.chat.font_size)
		end

		-- 登录时自动启用聊天姓名按职业着色
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")

		-- 自动设置频道
		ChatFrame_RemoveAllMessageGroups(ChatFrame1)
		ChatFrame_AddChannel(ChatFrame1, "交易")
		ChatFrame_AddChannel(ChatFrame1, "综合")
		ChatFrame_AddChannel(ChatFrame1, "本地防务")
		ChatFrame_AddChannel(ChatFrame1, "寻求组队")
		ChatFrame_AddChannel(ChatFrame1, "Trade")
		ChatFrame_AddChannel(ChatFrame1, "General")
		ChatFrame_AddChannel(ChatFrame1, "LocalDefense")
		ChatFrame_AddChannel(ChatFrame1, "GuildRecruitment")
		ChatFrame_AddChannel(ChatFrame1, "LookingForGroup")
		ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
		ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
		ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
		ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
		ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
		ChatFrame_AddMessageGroup(ChatFrame1, "DND")
		ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
		ChatFrame_AddMessageGroup(ChatFrame1, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONEY")
		ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "SKILL")
--		ChatFrame_AddMessageGroup(ChatFrame1, "TRADESKILLS")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")

		ChatFrame_RemoveAllMessageGroups(ChatFrame3)
		ChatFrame_RemoveChannel(ChatFrame3, "交易")
		ChatFrame_RemoveChannel(ChatFrame3, "综合")
		ChatFrame_RemoveChannel(ChatFrame3, "本地防务")
		ChatFrame_RemoveChannel(ChatFrame3, "寻求组队")
		ChatFrame_RemoveChannel(ChatFrame3, "Trade")
		ChatFrame_RemoveChannel(ChatFrame3, "General")
		ChatFrame_RemoveChannel(ChatFrame3, "LocalDefense")
		ChatFrame_RemoveChannel(ChatFrame3, "GuildRecruitment")
		ChatFrame_RemoveChannel(ChatFrame3, "LookingForGroup")
		ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame3, "GUILD")
		ChatFrame_AddMessageGroup(ChatFrame3, "OFFICER")
		ChatFrame_AddMessageGroup(ChatFrame3, "GUILD_ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
		ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
		ChatFrame_AddMessageGroup(ChatFrame3, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame3, "PARTY")
		ChatFrame_AddMessageGroup(ChatFrame3, "PARTY_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame3, "RAID")
		ChatFrame_AddMessageGroup(ChatFrame3, "RAID_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame3, "RAID_WARNING")
		ChatFrame_AddMessageGroup(ChatFrame3, "BATTLEGROUND")
		ChatFrame_AddMessageGroup(ChatFrame3, "BATTLEGROUND_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame3, "BG_HORDE")
		ChatFrame_AddMessageGroup(ChatFrame3, "BG_ALLIANCE")
		ChatFrame_AddMessageGroup(ChatFrame3, "BG_NEUTRAL")
		ChatFrame_AddMessageGroup(ChatFrame3, "SYSTEM")

--		FCF_SetWindowColor(ChatFrame3, 0, 0, 0)
--		FCF_SetWindowAlpha(ChatFrame3, 0)

		-- 设置综合, 交易, 寻求组队频道颜色
		ChangeChatColor("CHANNEL2", 0.6, 0.8, 0.6)
		ChangeChatColor("CHANNEL4", 0, 0.6, 0.8)
	end
	InstalledUI = true
	SavedOptions.SetCVar = true

	ReloadUI()
end

local function DisableUI()
	DisableAddOn("meatUI");
	ReloadUI()
end

----------------------------------------------------------------------------------------
-- 弹出窗口
----------------------------------------------------------------------------------------
StaticPopupDialogs["INSTALL_UI"] = {
	text = L_POPUP_INSTALLUI,
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = InstallUI,
	OnCancel = function() InstalledUI = false SavedOptions.SetCVar = false end,
    timeout = 0,
    whileDead = 1,
	hideOnEscape = false,
}

StaticPopupDialogs["DISABLE_UI"] = {
	text = L_POPUP_DISABLEUI,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = DisableUI,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs["RESET_UI"] = {
	text = L_POPUP_RESETUI,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = InstallUI,
	OnCancel = function() InstalledUI = true SavedOptions.SetCVar = true end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs["SWITCH_RAID"] = {
	text = L_POPUP_SWITCH_RAID,
	button1 = DAMAGER,
	button2 = HEALER,
	OnAccept = function() DisableAddOn("meatUI_Raid_Heal") EnableAddOn("meatUI_Raid_Dps") ReloadUI() end,
	OnCancel = function() EnableAddOn("meatUI_Raid_Heal") DisableAddOn("meatUI_Raid_Dps") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

----------------------------------------------------------------------------------------
-- 登录功能
----------------------------------------------------------------------------------------
local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	-- 显示所有动作条
	if SettingsCF.actionbar.always_show == true then
		SetActionBarToggles( 1, 1, 1, 1, 0 )
			if SettingsDB.name == "肉嘎嘎思密达"
				or SettingsDB.name == "小肉肉思密达"
				or SettingsDB.name == "牛粑粑思密达"
				or SettingsDB.name == "肉尕尕思密达" then
				SetActionBarToggles( 1, 0, 1, 1, 0 )
			end
	end

	-- 显示空的动作条按钮
	if SettingsCF.actionbar.show_grid == true then
		ActionButton_HideGrid = function() end
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end

	if SettingsDB.getresolution == "800x600"
	or SettingsDB.getresolution == "720x576" then
		SetCVar("useUiScale", 0)
		StaticPopup_Show("DISABLE_UI")
	else
		SetCVar("useUiScale", 1)
		SetMultisampleFormat(1)
		if SettingsCF.general.uiscale > 1 then SettingsCF.general.uiscale = 1 end
		if SettingsCF.general.uiscale < 0.64 then SettingsCF.general.uiscale = 0.64 end
		SetCVar("uiScale", SettingsCF.general.uiscale)
		if InstalledUI ~= true then
			if (SavedOptions == nil) then SavedOptions = {} end
			StaticPopup_Show("INSTALL_UI")
		end
	end

	-- 移除游戏视频设置中的UI缩放选项
	VideoOptionsResolutionPanelUIScaleSlider:Hide()
	VideoOptionsResolutionPanelUseUIScale:Hide()

	if IsAddOnLoaded("meatUI_Raid_Dps") and IsAddOnLoaded("meatUI_Raid_Heal") then
		StaticPopup_Show("SWITCH_RAID")
	end

	SetCVar("showArenaEnemyFrames", 0)
	
	-- 强制显示LUA错误
	SetCVar("scriptErrors", 1)
	
	-- Force chat CVar to be applied
--	SetCVar("WholeChatWindowClickable", 0)
--	SetCVar("ConversationMode", "inline")

	-- 欢迎信息
	if SettingsCF.general.welcome_message == true then
		print("|cffffff00"..L_WELCOME_LINE_1..SettingsDB.version.."|r")
--		print("|cffffff00"..L_WELCOME_LINE_1..SettingsDB.version.." "..SettingsDB.client..".|r")
		print("|cffffff00"..L_WELCOME_LINE_2_1.." |cffffff00"..L_WELCOME_LINE_2_2)
	end
end)
SLASH_CONFIGURE1 = "/resetui"
SlashCmdList.CONFIGURE = function() StaticPopup_Show("RESET_UI") end
