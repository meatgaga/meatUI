----------------------------------------------------------------------------------------
-- 斜杠命令
----------------------------------------------------------------------------------------
SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = "/重载"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"
SLASH_RCSLASH2 = "/就位"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"
SLASH_TICKET2 = "/帮助"

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/dis"
SLASH_DISABLE_ADDON2 = "/禁用"

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) end
SLASH_ENABLE_ADDON1 = "/en"
SLASH_ENABLE_ADDON2 = "/启用"

----------------------------------------------------------------------------------------
-- 解散团队或小队 (by Monolit)
----------------------------------------------------------------------------------------
SlashCmdList["GROUPDISBAND"] = function()
	local pName = UnitName("player")
	SendChatMessage(L_INFO_DISBAND, "RAID" or "PARTY")
	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
SLASH_GROUPDISBAND1 = "/rd"
SLASH_GROUPDISBAND2 = "/解散"

----------------------------------------------------------------------------------------
-- 切换天赋 (by Monolit)
----------------------------------------------------------------------------------------
SlashCmdList["SPEC"] = function() 
	local spec = GetActiveTalentGroup()
	if spec == 1 then SetActiveTalentGroup(2) elseif spec == 2 then SetActiveTalentGroup(1) end
end
SLASH_SPEC1 = "/ss"
SLASH_SPEC2 = "/spec"

----------------------------------------------------------------------------------------
-- 重置副本
----------------------------------------------------------------------------------------
SlashCmdList["DGR"] = function()
	ResetInstances()
end

SLASH_DGR1 = "/dgr"
SLASH_DGR2 = "/dungeonreset"
SLASH_DGR2 = "/重置副本"

----------------------------------------------------------------------------------------
-- 游戏崩溃后修复战斗记录 (2.4 and 3.3.2 bug)
----------------------------------------------------------------------------------------
SlashCmdList["CLFIX"] = function() CombatLogClearEntries() end
SLASH_CLFIX1 = "/clfix"

----------------------------------------------------------------------------------------
-- DBM测试模式
----------------------------------------------------------------------------------------
SlashCmdList["DBMTEST"] = function() DBM:DemoMode() end
SLASH_DBMTEST1 = "/dbmtest"

----------------------------------------------------------------------------------------
-- 切换为治疗者布局
----------------------------------------------------------------------------------------
SlashCmdList["HEAL"] = function()
	DisableAddOn("meatUI_Raid_Dps")
	EnableAddOn("meatUI_Raid_Heal")
	ReloadUI()
end
SLASH_HEAL1 = "/heal"
SLASH_HEAL2 = "/治疗"

----------------------------------------------------------------------------------------
-- 切换为伤害输出布局
----------------------------------------------------------------------------------------
SlashCmdList["DPS"] = function()
	DisableAddOn("meatUI_Raid_Heal")
	EnableAddOn("meatUI_Raid_Dps")
	ReloadUI()
end
SLASH_DPS1 = "/dps"
SLASH_DPS2 = "/输出"

----------------------------------------------------------------------------------------
-- 显示当前鼠标悬停的框体信息
----------------------------------------------------------------------------------------
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end

		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))

		if relativeTo then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		ChatFrame1:AddMessage("|cffCC0000~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end
SLASH_FRAME1 = "/frame"
SLASH_FRAME2 = "/框体"

----------------------------------------------------------------------------------------
-- 插件组
----------------------------------------------------------------------------------------
SlashCmdList["CHANGEADDONS"] = function(s)
	if(s and s == "raid" or s == "副本") then
		for i in pairs(SettingsCF.addon.raid) do
			EnableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			DisableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			DisableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			DisableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			DisableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	elseif(s and s == "party" or s == "小队") then
		for i in pairs(SettingsCF.addon.raid) do
			DisableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			EnableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			DisableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			DisableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			DisableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	elseif(s and s == "pvp") then
		for i in pairs(SettingsCF.addon.raid) do
			DisableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			DisableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			EnableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			DisableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			DisableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	elseif(s and s == "quest" or s == "任务") then
		for i in pairs(SettingsCF.addon.raid) do
			DisableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			DisableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			DisableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			EnableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			DisableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	elseif(s and s == "trade" or s == "商业") then
		for i in pairs(SettingsCF.addon.raid) do
			DisableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			DisableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			DisableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			DisableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			EnableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	elseif(s and s == "solo" or s == "原始") then
		for i in pairs(SettingsCF.addon.raid) do
			DisableAddOn(SettingsCF.addon.raid[i])
		end
		for i in pairs(SettingsCF.addon.party) do
			DisableAddOn(SettingsCF.addon.party[i])
		end
		for i in pairs(SettingsCF.addon.pvp) do
			DisableAddOn(SettingsCF.addon.pvp[i])
		end
		for i in pairs(SettingsCF.addon.quest) do
			DisableAddOn(SettingsCF.addon.quest[i])
		end
		for i in pairs(SettingsCF.addon.trade) do
			DisableAddOn(SettingsCF.addon.trade[i])
		end
		ReloadUI()
	else
		print("|cffffff00"..L_INFO_ADDON_SETS1.."|r")
		print("|cffffff00"..L_INFO_ADDON_SETS2.."|r")
	end
end
SLASH_CHANGEADDONS1 = "/addons"
SLASH_CHANGEADDONS2 = "/插件"

----------------------------------------------------------------------------------------
-- 降低视频设置以优化性能 (by eP)
----------------------------------------------------------------------------------------
SlashCmdList["BOOST"] = function()
	SetCVar("ffx", 0)
	SetCVar("hwPCF", 1)
	SetCVar("shadowLOD", 0)
	SetCVar("timingmethod", 1)
	--SetCVar("showshadow", 0)
	SetCVar("showfootprints", 0)
	SetCVar("showfootprintparticles", 0)
	--SetCVar("overridefarclip", 0)
	SetCVar("farclip", 600)
	--SetCVar("horizonfarclip", 1305)
	--SetCVar("detailDoodadAlpha", 0)
	SetCVar("groundeffectdensity", 16)
	SetCVar("groundeffectdist", 1)
	--SetCVar("smallcull", 0)
	SetCVar("skycloudlod", 1)
	--SetCVar("characterAmbient", 1)
	SetCVar("extshadowquality", 0)
	SetCVar("environmentDetail", 0.5)
	SetCVar("m2Faster", 1)
end
SLASH_BOOST1 = "/boost"
SLASH_BOOST2 = "/优化"
