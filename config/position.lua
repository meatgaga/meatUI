----------------------------------------------------------------------------------------
-- meatUI的位置配置文档
----------------------------------------------------------------------------------------
SettingsCF["position"] = {
	-- 综合
	["minimap"] = {"TOPRIGHT", UIParent, "TOPRIGHT", -5.5, -15},					-- 微缩地图
	["map"] = {"CENTER", UIParent, "CENTER", 0, 70},								-- 世界地图
	["chat"] = {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 23, 23},						-- 聊天框
	["tooltip"] = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 22},					-- 提示信息
	["ticket"] = {"TOPLEFT", UIParent, "TOPLEFT", 20, -20},							-- GM帮助
	["attempt"] = {"BOTTOM", UIParent, "TOP", -85, -20},							-- 占据信息
	["capture_bar"] = {"TOP", UIParent, "TOP", 0, 0},								-- 占据计时条
	["vehicle"] = {"BOTTOM", Minimap, "BOTTOM", 0, -10},							-- 载具指示
	["uierror"] = {"TOP", UIParent, "TOP", 0, -30},									-- 红字错误信息
	["quest"] = {"TOPLEFT", UIParent, "TOPLEFT", 25, -10},							-- 任务监视
	["loot"] = {"BOTTOM", UIParent, "BOTTOM", -276, 416},							-- 拾取框体
	["group_loot"] = {"BOTTOM", UIParent, "BOTTOM", -210, 600},						-- 掷点框体
	["raid_cooldown"] = {"TOPLEFT", UIParent, "TOPLEFT", 40, -24},					-- 团队技能监视
	["enemy_cooldown"] = {"BOTTOMLEFT", "oUF_Player", "TOPRIGHT", 29, 66},			-- 敌方技能监视
	["threat_meter"] = {"BOTTOMLEFT", "oUF_Target", "TOPLEFT", 0, -123},			-- 仇恨监视
	-- 动作条位置
	actionbars = {
		["bottom_bars"] = {"BOTTOM", UIParent, "BOTTOM", 0, 7},						-- 下方动作条1
		["right_bars"] = {"RIGHT", UIParent, "RIGHT", -4, 0},						-- 右侧动作条1
		["stance"] = {"BOTTOM", UIParent, "BOTTOM", -285, 148},						-- 姿态/变形/图腾动作条
		["pet_vertical"] = {"RIGHT", "Bar45Holder", "LEFT", -3, 0},					-- 垂直宠物动作条
		["pet_horizontal"] = {"BOTTOM", "Bar2Holder", "TOP", 0, 1},					-- 水平宠物动作条
		["bags"] = {"TOPLEFT", UIParent, "TOPLEFT", 270, 0},						-- 背包栏
		["menu"] = {"TOPLEFT", UIParent, "TOPLEFT", 0, 0},							-- 迷你菜单
		["vehicle"] = {"BOTTOMRIGHT", "Bar1Holder", "BOTTOMLEFT", -1, 0},			-- 载具按钮
	},
	-- 单位框体位置
	unitframes = {
		["player"] = {"BOTTOM", UIParent, "BOTTOM", -276, 216},						-- 玩家框体
		["target"] = {"BOTTOM", UIParent, "BOTTOM", 276, 216},						-- 目标框体
		["target_target"] = {"BOTTOMRIGHT", "oUF_Target", "TOPRIGHT", 0, -52},		-- 目标的目标框体
		["pet"] = {"BOTTOMLEFT", "oUF_Player", "TOPLEFT", 0, -52},					-- 宠物框体
		["focus"] = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 0, -52},				-- 焦点框体
		["focus_target"] = {"BOTTOMLEFT", "oUF_Target", "TOPLEFT", 0, -52},			-- 焦点的目标框体
		["party_heal"] = {"TOPLEFT", "oUF_Player", "BOTTOMRIGHT", 10, -7},			-- 治疗者布局的小队框体
		["raid_heal"] = {"TOPLEFT", "oUF_Player", "BOTTOMRIGHT", 10, -7},			-- 治疗者布局的团队框体
		["party_dps"] = {"BOTTOMLEFT", UIParent, "LEFT", 22, -70},					-- 伤害输出布局的小队框体
		["raid_dps"] = {"TOPLEFT", UIParent, "TOPLEFT", 22, -22},					-- 伤害输出布局的团队框体
		["arena"] = {"BOTTOMRIGHT", UIParent, "RIGHT", -20, -70},					-- 竞技场框体
		["boss"] = {"BOTTOMRIGHT", UIParent, "RIGHT", -20, -70},					-- Boss框体
		["tank"] = {"BOTTOMLEFT", UIParent, "BOTTOM", 176, 26},						-- 坦克框体
		["player_castbar"] = {"BOTTOMLEFT", "oUF_Player", "BOTTOMRIGHT", 30, 0},	-- 玩家施法条
		["target_castbar"] = {"CENTER", "oUF_Player_Castbar", "CENTER", 0, 20},		-- 目标施法条
		["focus_castbar"] = {"CENTER", UIParent, "CENTER", 0, 200},					-- 焦点施法图标
	},
}