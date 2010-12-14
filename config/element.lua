----------------------------------------------------------------------------------------
-- meatUI界面元素配置文档
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- 综合设置
----------------------------------------------------------------------------------------
SettingsCF["general"] = {
	["auto_scale"] = true,						-- 自动UI缩放
	["uiscale"] = 0.81234567890,				-- 当"auto_scale"禁用时所使用的缩放比例
	["gamefont_scale"] = 1,						-- 字体全局缩放
	["minimap_icon"] = true,					-- 在微缩地图上显示<图形设置界面>的开关图标
	["welcome_message"] = true,					-- 登录时在聊天栏中显示欢迎信息
	--[[适合于不同分辨率的UI缩放比例:
		分辨率高度   | 缩放
		768          | 1
		800          | 0.96
		900          | 0.8533333333333333
		1024         | 0.75
		1050         | 0.7314285714285714
		1080         | 0.7111111111111111
		1200         | 0.64
	]]
}

----------------------------------------------------------------------------------------
-- 便捷功能
----------------------------------------------------------------------------------------
SettingsCF["misc"] = {
	["auto_invite"] = true,						-- 自动邀请密语者
	["invite_keyword"] = "222",					-- 密语邀请暗号
	["accept_invite"] = true,					-- 自动接受好友或公会成员的邀请
	["auto_quest"] = false,						-- 自动交接任务(按下shift点击NPC可转为手动)
	["quest_icon"] = true,						-- 高亮已完成任务图标(问号)
	["auto_greed"] = false,						-- 自动贪婪绿色物品并自动需求宝珠
	["auto_confirm"] = true,					-- 自动确认绑定提示
	["auto_decline_duel"] = false,				-- 自动拒绝决斗
	["auto_resurrection"] = true,				-- 在战场中自动释放灵魂
	["shift_marking"] = true,					-- shift+点击目标弹出标记菜单
	["afk_spin_camera"] = false,				-- 暂离后旋转镜头
	["always_compare"] = true,					-- 总是进行装备比较(无需按下shift)
	["combat_notification"] = true,				-- 动态美化的战斗提示
	["low_notification"] = true,				-- 动态美化的生命值/魔法值过低提示
}

----------------------------------------------------------------------------------------
-- 错误信息
----------------------------------------------------------------------------------------
SettingsCF["error"] = {							-- http://www.wowwiki.com/WoW_Constants/Errors
	["hide"] = true,							-- 隐藏红字提示
	["black"] = true,							-- 隐藏黑名单中的红字提示
	["white"] = false,							-- 显示白名单中的红字提示
	["combat"] = false,							-- 在战斗中隐藏红字提示
}

----------------------------------------------------------------------------------------
-- 团队/敌方技能冷却监视
----------------------------------------------------------------------------------------
SettingsCF["cooldown"] = {
	-- Raid cooldowns
	["raid_enable"] = true,						-- 启用团队技能冷却监视
	["raid_font_size"] = 8,						-- 团队技能文字尺寸
	["raid_height"] = 15,						-- 团队技能冷却条高度
	["raid_width"] = 160,						-- 团队技能冷却条宽度
	["raid_upwards"] = false,					-- 团队技能冷却条向上延伸
	["raid_show_icon"] = true,					-- 显示团队技能图标
	["raid_show_inraid"] = true,				-- 在团队中监视团队技能冷却
	["raid_show_inparty"] = true,				-- 在小队中监视团队技能冷却
	["raid_show_inarena"] = true,				-- 在竞技场中监视团队技能冷却
	-- Enemy cooldowns
	["enemy_enable"] = true,					-- 启用敌方技能冷却监视
	["enemy_size"] = 30,						-- 敌方技能图标尺寸
	["enemy_show_always"] = false,				-- 在任何地点监视敌方技能冷却
	["enemy_show_inpvp"] = false,				-- 在战场中监视敌方技能冷却
	["enemy_show_inarena"] = true,				-- 在竞技场中监视敌方技能冷却
	-- Cooldown pulse
	["pulse_enable"] = false,					-- 冷却技能图标闪烁(暂时有BUG)
	-- Cooldown line
	["line_enable"] = true,						-- 流线型冷却计时器
	["line_pet"] = true,						-- 宠物技能流线型冷却计时
	["line_bag"] = true,						-- 背包物品流线型冷却计时
	["line_fail"] = true,						-- 失败技能流线型冷却计时
}

----------------------------------------------------------------------------------------
-- 聊天栏
----------------------------------------------------------------------------------------
SettingsCF["chat"] = {
	["enable"] = true,							-- 启用meatUI的聊天栏
	["width"] = 310,							-- 聊天栏宽度
	["height"] = 100,							-- 聊天栏高度
	["font_size"] = 10,							-- 聊天文字尺寸
	["font_outline"] = false,					-- 聊天文字描边
	["filter"] = true,							-- 移除垃圾消息(*玩家1* 战胜*玩家2*)
	["chat_bar"] = true,						-- 显示频道快捷按钮栏
	["input_top"] = true,						-- 输入框位于聊天栏上方
	["time_stamps"] = false,					-- 显示时间戳
	["time_color"] = "FFD700",					-- 时间戳颜色(http://www.december.com/html/spec/colorcodes.html)
	["whisp_sound"] = true,						-- 收到密语时声音提示
	["talent_spam_filter"] = true,				-- 屏蔽切换天赋时的聊天刷屏
}

----------------------------------------------------------------------------------------
-- 动作条
----------------------------------------------------------------------------------------
SettingsCF["actionbar"] = {
	-- Main
	["enable"] = true,							-- 启用meatUI的动作条
	["hotkey"] = true,							-- 显示快捷键
	["macro"] = true,							-- 显示宏名称
	["always_show"] = true,						-- 显示所有动作条
	["show_grid"] = true,						-- 显示空的动作条按钮
	["button_size"] = 26,						-- 按钮尺寸
	["button_spacing"] = 1,						-- 按钮间距
	-- Right bars
	["rightbars_three"] = true,					-- 在右侧显示3条动作条(false则将在底部显示3条动作条)
	["rightbars_mouseover"] = false,			-- 鼠标悬停时显示右侧动作条
	-- Pet bar
	["petbar_mouseover"] = false,				-- 鼠标悬停时显示宠物动作条
	["petbar_hide"] = false,					-- 隐藏宠物动作条
	["petbar_horizontal"] = false,				-- 启用横向宠物动作条
	-- Shapeshift/Stance/Totem bars
	["shapeshift_mouseover"] = false,			-- 鼠标悬停时显示变形/姿态/图腾动作条
	["shapeshift_hide"] = false,				-- 隐藏变形/姿态/图腾动作条
	-- Micromenu 
	["micromenu_mouseover"] = true,				-- 鼠标悬停时显示迷你菜单
	["micromenu_hide"] = true,					-- 隐藏迷你菜单
	-- Bagsmenu
	["bags_mouseover"] = true,					-- 鼠标悬停时显示背包栏
	["bags_hide"] = true,						-- 隐藏背包栏
}

----------------------------------------------------------------------------------------
-- 提示信息
----------------------------------------------------------------------------------------
SettingsCF["tooltip"] = {
	["enable"] = true,							-- 启用meatUI的鼠标提示信息
	["shift_modifer"] = false,					-- 按下shift时显示提示信息
	["cursor"] = false,							-- 提示信息跟随鼠标
	["icon"] = true,							-- 在提示信息中显示图标
	["icon_size"] = 20,							-- 图标尺寸
	["health_value"] = true,					-- 显示生命值数字
	["hide_button"] = false,					-- 在战斗中隐藏动作条/宠物条/变形条的提示信息
	-- Plugins
	["talents"] = true,							-- 在提示信息中显示天赋
	["achievements"] = true,					-- 在提示信息中显示成就比较
	["target"] = true,							-- 在提示信息中显示目标的目标
	["title"] = false,							-- 在提示信息中显示目标称号
	["rank"] = true,							-- 在提示信息中显示公会官阶
	["spellid"] = true,							-- 在战斗记录的技能名称提示信息中显示spellID
	["arena_experience"] = false,				-- 在提示信息中显示竞技场等级
}

----------------------------------------------------------------------------------------
-- 微缩地图
----------------------------------------------------------------------------------------
SettingsCF["minimap"] = {
	["enable"] = true,							-- 启用meatUI的微缩地图
	["size"] = 112,								-- 微缩地图尺寸
	["tracking_icon"] = true,					-- 显示追踪按钮
	["hide_combat"] = false,					-- 战斗中隐藏微缩地图
	["ping"] = true,							-- 显示谁在点击微缩地图
	["ping_self"] = true,						-- 自己点击微缩地图也显示名字
}

----------------------------------------------------------------------------------------
-- 背包
----------------------------------------------------------------------------------------
SettingsCF["bag"] = {
	["enable"] = true,
	["button_size"] = 28,						-- 物品格尺寸
	["key_columns"] = 3,						-- 钥匙链物品格每行数量
	["bank_columns"] = 17,						-- 银行物品格每行数量
	["bag_columns"] = 10,						-- 背包物品格每行数量
	["hide_empty"] = false,						-- 隐藏空物品格
}

----------------------------------------------------------------------------------------
-- 拾取窗口
----------------------------------------------------------------------------------------
SettingsCF["loot"] = {
	["loot_frame"] = true,						-- 启用meatUI的拾取窗口
	["roll_frame"] = true,						-- 启用meatUI的掷点框体
	["font_size"] = 10,							-- 拾取窗口和掷点框体的字体尺寸
	["icon_size"] = 22,							-- 拾取窗口图标尺寸
	["width"] = 214,							-- 拾取窗口宽度
}

----------------------------------------------------------------------------------------
-- 姓名板
----------------------------------------------------------------------------------------
SettingsCF["nameplate"] = {
	["enable"] = true,							-- 启用meatUI的姓名板
	["font_size"] = 10,							-- 姓名板字体尺寸
	["height"] = 8,								-- 姓名板高度
	["width"] = 120,							-- 姓名板宽度
	["combat"] = false,							-- 战斗中自动显示姓名板
	["castbar_name"] = false,					-- 显示施法名称
	["class_icons"] = true,						-- pvp状态下显示职业图标
}

----------------------------------------------------------------------------------------
-- 仇恨监视
----------------------------------------------------------------------------------------
SettingsCF["threat"] = {
	["enable"] = true,							-- 启用meatUI的仇恨监视
	["width"] = 212,							-- 仇恨条宽度
	["height"] = 12,							-- 仇恨条高度
	["bar_rows"] = 7,							-- 仇恨条数量
}

----------------------------------------------------------------------------------------
-- 信息条
----------------------------------------------------------------------------------------
SettingsCF["statpanel"] = {
	["enable"] = true,							-- 启用meatUI的信息条
	["classcolor"] = true,						-- 职业颜色模式
	["memory"] = true,							-- 显示插件内存占用
	["fps"] = true,								-- 显示每秒帧数
	["latency"] = true,							-- 显示网络延迟
	["durability"] = true,						-- 显示装备耐久度
	["bag"] = true,								-- 显示背包空格数量
	["gold"] = true,							-- 显示拥有金钱
	["exp"] = true,								-- 显示经验值
	["dps"] = true,								-- 显示每秒伤害(false则显示每秒治疗)
	["time"] = true,							-- 显示时间
	["time_local"] = false,						-- 显示本地时间
	["mail"] = true,							-- 显示邮件信息
}

----------------------------------------------------------------------------------------
--	Combat text options(xCT)
----------------------------------------------------------------------------------------
SettingsCF["combattext"] = {
-- appearence
	["font_size"] = 12,
	["damage_color"] = true,		-- display damage numbers depending on school of magic, see http://www.wowwiki.com/API_COMBAT_LOG_EVENT
	["icon"] = true,		-- show outgoing damage icons
	["icon_size"] = 16,		-- icon size of spells in outgoing damage frame, also has effect on dmg font size.
	["treshold_damage"] = 1,		-- minimum damage to show in damage frame
	["treshold_heal"] = 1,		-- minimum healing to show in incoming/outgoing healing messages.
-- class modules and goodies
	["stop_ve_spam"] = false,		-- automaticly turns off healing spam for priests in shadowform. HIDE THOSE GREEN NUMBERS PLX!
	["stop_fa_spam"] = false,		-- do not show Fel Armor healing ticks, useful for warlocks.
	["rune"] = true,		-- show deatchknight rune recharge
}

----------------------------------------------------------------------------------------
-- 法术效果/增益/减益
----------------------------------------------------------------------------------------
SettingsCF["aura"] = {
	["show_spiral"] = false,					-- 在法术效果图标上显示冷却螺旋
	["show_timer"] = true,						-- 在法术效果图标上显示持续时间
	["player_auras"] = true,					-- 在玩家框体显示法术效果
	["target_auras"] = true,					-- 在目标框体显示法术效果
	["focus_debuffs"] = false,					-- 在焦点框体显示减益效果
	["fot_debuffs"] = false,					-- 在焦点目标框体显示减益效果
	["pet_debuffs"] = false,					-- 在宠物框体显示减益效果
	["tot_debuffs"] = false,					-- 在目标的目标框体显示减益效果
	["player_aura_only"] = false,				-- 在目标框体上仅显示自己给予的减益效果
	["debuff_color_type"] = true,				-- 减益效果以法术类型着色
}

----------------------------------------------------------------------------------------
-- 单位框体
----------------------------------------------------------------------------------------
SettingsCF["unitframe"] = {
	-- Main
	["enable"] = true,							-- 启用meatUI的单位框体
	["font_size"] = 9,							-- 单位框体字体尺寸
	["own_color"] = false,						-- 自定义生命条颜色
	["show_total_value"] = false,				-- 玩家和目标框体显示详细数值(当前量-总量)
	["deficit_health"] = true,					-- 团队生命值亏减模式
	["castbar_icon"] = true,					-- 显示施法条图标
	["castbar_latency"] = true,					-- 显示施法延迟
	["show_boss"] = true,						-- 显示boss框体
	["show_arena"] = true,						-- 显示竞技场框体
	["arena_on_right"] = true,					-- 在右侧显示竞技场框体(伤害输出布局需启用)
	-- Raid
	["show_raid"] = true,						-- 显示团队框体
	["vertical_health"] = false,				-- 垂直显示团队框体生命值
	["alpha_health"] = false,					-- 生命值全满时透明化生命条
	["show_range"] = true,						-- 团队框体中超出距离的单位框体透明化
	["range_alpha"] = 0.5,						-- 超出距离的单位框体透明度
	["solo_mode"] = false,						-- 总是显示玩家的团队框体
	["player_in_party"] = false,				-- 在小队中显示玩家框体
	["raid_tanks"] = true,						-- 显示团队坦克框体
	-- Portraits
	["portrait_enable"] = false,				-- 玩家和目标框体显示3D头像
	["portrait_alpha"] = 0.3,					-- 3D头像透明度
	-- oUF Plugins
	["plugins_swing"] = true,					-- 普通攻击计时条
	["plugins_mp5"] = true,						-- 5秒回蓝计时
	["plugins_totem_bar_name"] = true,			-- 显示图腾名称
	["plugins_smooth_bar"] = false,				-- 平滑显示
	["plugins_aura_watch"] = true,				-- 团队法术监视
	["plugins_debuffhighlight_icon"] = true,	-- 高亮可驱散的减益效果图标
	["plugins_healcomm"] = true,				-- 启用oUF_HealComm4预读治疗模块
	["plugins_healcomm_bar"] = true,			-- 显示预读治疗条
	["plugins_healcomm_over"] = true,			-- 显示过量治疗条
	["plugins_healcomm_text"] = true,			-- 显示预读治疗量文字信息
	["plugins_healcomm_others"] = false,		-- 隐藏自身的预读治疗
}

----------------------------------------------------------------------------------------
-- 插件组
----------------------------------------------------------------------------------------
SettingsCF["addon"] = {							-- 可供快速切换的插件组
	raid = {									-- Type /addons raid
		"DBM-Core",
		"DXE",
		"PallyPower",
		"alDamageMeter",
		"Skada",
		"Recount",
		"Omen",
		"sThreatMeter2",
	},
	party = {									-- Type /addons party
		"DBM-Core",
		"DXE",
		"PallyPower",
		"alDamageMeter",
		"Skada",
		"Recount",
		"Omen",
		"sThreatMeter2",
	},
	pvp = {										-- Type /addons pvp
		"ArenaHistorian",
		"ncSpellalert",
	},
	quest = {									-- Type /addons quest
		"Carbonite",
		"CarboniteNodes",
		"CarboniteTransfer",
		"QuestHelper",
	},
	trade = {									-- Type /addons trade
		"Auctionator", 
	},
}
