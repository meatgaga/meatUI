----------------------------------------------------------------------------------------
-- 随机坐骑宏(基于noru by Trond A Ekseth)(yleaf,剜刀修改版)
----------------------------------------------------------------------------------------
setglobal("BINDING_NAME_CLICK NoruFrame:LeftButton", "Mount")
setglobal("BINDING_NAME_CLICK NoruDismountFrame:LeftButton", "Dismount")

local badZones = SettingsDB.client == "zhCN" and {
	["达拉然"] = true,
	["冬拥湖"] = true,
} or {
	["Dalaran"] = true,
	["Wintergrasp"] = true,
}

local subExceptions = SettingsDB.client == "zhCN" and {
	["克拉苏斯平台"] = true,
	["紫色天台"] = true,
	["达拉然下水道"] = true,
} or {
	["Krasus\' Landing"] = true,
	["Purple Parlor"] = true,
	["Underbelly"] = true,
}

local IsFlyable = IsFlyableArea
function IsFlyableArea()
	if( badZones[GetRealZoneText()] and not subExceptions[GetSubZoneText()] ) then
		return false
	else
		return IsFlyable()
	end
end

local mounts = {
	ground = {
		-- 100
		{
			-- 未知
			59573,34407,29059,579,23220,47037,42781,
			-- 职业专有
			23214,34767,23161,66906,48778,
			-- 种族坐骑.兽人
			16080,23250,23251,23252,
			-- 种族坐骑.牛头人
			18991,18992,23247,23248,23249,
			-- 种族坐骑.亡灵
			17465,22722,23246,66846,
			-- 种族坐骑.巨魔
			17450,23241,23242,23243,
			-- 种族坐骑.血精灵
			33660,35025,35027,35028,
			-- 种族坐骑.人类
			16083,23227,23228,23229,
			-- 种族坐骑.矮人
			23238,23239,23240,
			-- 种族坐骑.暗夜精灵
			23219,23221,23338,
			-- 种族坐骑.侏儒
			23222,23223,23225,
			-- 种族坐骑.德莱尼
			35712,35713,35714,
			-- 商业制造
			55531,60424,
			-- PvP
			34790,39316,23510,
			-- PvP.部落
			22718,22721,22724,23509,59788,
			-- PvP.联盟
			22717,22719,22720,22723,48027,59785,
			-- 声望奖励
			34896,34897,34898,34899,39315,39317,39318,39319,
			-- 声望奖励.部落
			59797,64659,61469,59802,
			-- 声望奖励.联盟
			17229,59799,63639,66090,61470,59804,
			-- 任务奖励
			54753,
			-- 成就奖励
			68056,68057,68187,68188,60118,60119,
			-- NPC出售.部落
			60116,61447,63635,65639,63640,65641,63643,65644,65645,65646,59793,
			-- NPC出售.联盟
			60114,61425,63232,63636,63637,63638,65637,65638,65640,65642,65643,59791,
			-- 掉落
			17481,24242,36702,41252,46628,24252,61465,61467,59810,59811,60136,60140,
			-- 节日
			49379,43900,48025,
			-- 游戏外途径
			42777,58983,59572,
			-- 绝版
			51412,15779,16055,16056,16081,16082,16084,17459,17460,17461,49322,43688,48954,26656,
		},
		-- 60
		{
			16060,
			10795,10798,16058,
			17455,17456,18363,8980,15781,
			16059,10796,468,581,58983,48025,
			-- 职业专有
			13819,34769,5784,
			-- 种族坐骑.兽人
			459,578,580,6653,6654,
			-- 种族坐骑.牛头人
			18989,18990,64657,
			-- 种族坐骑.亡灵
			17464,17462,17463,
			-- 种族坐骑.巨魔
			8395,10799,
			-- 种族坐骑.血精灵
			34795,35018,35020,35022,
			-- 种族坐骑.人类
			458,471,472,6648,
			-- 种族坐骑.矮人
			6777,6897,6898,6899,
			-- 种族坐骑.暗夜精灵
			8394,10789,10793,66847,
			-- 种族坐骑.侏儒
			10873,10969,17453,17454,33630,15780,
			-- 种族坐骑.德莱尼
			34406,35710,35711,
			-- NPC出售.联盟
			470,
			-- 节日
			43899,50869,50870,49378,
			-- 游戏外途径
			42776,17458,
			-- 绝版
			6896,
		},
		-- 0
		{
			30174
		},
	},

	flying = {
		-- 310
		{
			-- 掉落
			32345,69395,40192,63796,
			-- 成就奖励
			49193,60024,
			-- PvP
			37015,44744,58615,64927,65439,67336,
			59976,44317,3363,
			-- 国服绝版
			60021,
		},
		-- 280
		{
			41514,59650,39803,59569,
			43810,51960,61309,41513,
			61442,61444,
			61446,54729,48025,28828,
			-- 声望奖励
			43927,41515,41516,41517,41518,39798,39800,39801,39802,59570,61294,
			-- 成就奖励
			59961,60025,61996,61997,
			-- 商业制造
			44151,
			-- NPC出售
			66088,
			-- NPC出售.部落
			61230,32246,32295,32296,32297,
			-- NPC出售.联盟
			61229,32242,32289,32290,32292,
			-- 掉落
			59567,59568,59571,59996,60002,
			-- 游戏外途径
			46199,																	-- X-51虚空火箭特别加强版(特殊坐骑,刮刮卡刮出)
		},
		-- 150
		{
			61451,44153,46197,48025,
			-- NPC出售.部落
			32243,32244,32245,
			-- NPC出售.联盟
			32235,32239,32240,
			-- 游戏外途径
			49285,																	-- X-51虚空火箭(特殊坐骑,刮刮卡刮出)
		},
	},

	aq40 = {
		-- 100
		{
			25953,26054,26055,26056,
		},
	},
}

local player = {}

local function BuildDatabase()
	local list = {}
	player = {}
	for i=1, GetNumCompanions("MOUNT") do
		local _, spellName, spellId = GetCompanionInfo("MOUNT", i)
		--list[spellId] = spellName
		--list[spellId] = select(1, GetSpellInfo(spellId))
		list[spellId] = i
	end

	for type, skill in pairs(mounts) do
		for _, data in ipairs(skill) do
			local done
			for _, mount in ipairs(data) do
				if(list[mount]) then
					if(not player[type]) then player[type] = {} end
					table.insert(player[type], list[mount])
					done = true
				end
			end

			if(done) then break end
		end
	end
end

SLASH_NORU_MOUNT1 = "/mount"
SLASH_NORU_MOUNT2 = "/noru"
SlashCmdList["NORU_MOUNT"] = function()
	if IsMounted() then Dismount()
	else
		if not InCombatLockdown() then
			local flying = player.flying
			local ground = player.ground
			if IsFlyableArea() and flying then
				CallCompanion("MOUNT", flying[random(#flying)])
			elseif ground then
				CallCompanion("MOUNT", ground[random(#ground)])
			end
		end
	end
end

local noruframe = CreateFrame("Button", "NoruFrame", UIParent, "SecureActionButtonTemplate")
noruframe:SetAttribute("type", "macro")

local disframe = CreateFrame("Button", "NoruDismountFrame", UIParent, "SecureActionButtonTemplate")
disframe:SetAttribute("type", "macro")
disframe:SetAttribute("macrotext", "/cancelform\n/dismount")

local function SetMacroText(self, event, ...)
	if InCombatLockdown() then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end

	local macrotext
	if SettingsDB.class == "SHAMAN" then
		macrotext = ("/dismount [combat]" ..
					"/cast [mod:shift][combat]".. GetSpellInfo(2645) ..
					"\n/stopmacro [combat][mod:shift]"..
					"\n/mount")
	elseif SettingsDB.class == "DRUID" then
		if IsFlyableArea() then
			macrotext = ("/stopmacro [combat,flying]" ..
						"\n/cast [swimming]!" .. GetSpellInfo(1066) ..
							";[combat]!" .. GetSpellInfo(783) ..
							";[flyable,nocombat]!" .. GetSpellInfo(40120) ..
						"\n/stopmacro [combat][mounted][flyable]" ..
						"\n/cancelform" ..
						"\n/mount"
			)
		else
			macrotext = ("/stopmacro [combat,flying]" ..
						"\n/cast [swimming]!" .. GetSpellInfo(1066) ..
							";[combat]!" .. GetSpellInfo(783) ..
						"\n/stopmacro [combat][mounted]" ..
						"\n/cancelform" ..
						"\n/mount"
			)
		end
	else
		macrotext = "/mount"
	end
	noruframe:SetAttribute("macrotext", macrotext)
end

local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" or event == "COMPANION_LEARNED" then
		BuildDatabase(self, event, ...)
	end
	SetMacroText(self, event, ...)
end)

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("COMPANION_LEARNED")
if SettingsDB.class == "DRUID" then
	addon:RegisterEvent("ZONE_CHANGED")
	addon:RegisterEvent("ZONE_CHANGED_INDOORS")
	addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	addon:RegisterEvent("WORLD_MAP_UPDATE")
end
