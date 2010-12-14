----------------------------------------------------------------------------------------
-- 微缩地图 (基于aMinimap)
----------------------------------------------------------------------------------------
if not SettingsCF.minimap.enable == true then return end

-- 边框
local UIMinimap = CreateFrame("Frame", "UIMinimap", Minimap)
SettingsDB.CreateTemplate(UIMinimap)
UIMinimap:ClearAllPoints()
UIMinimap:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
UIMinimap:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
UIMinimap:SetFrameLevel(0)
UIMinimap:SetFrameStrata("BACKGROUND")

-- 形状, 位置, 尺寸
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(SettingsCF.position.minimap))
Minimap:SetWidth(SettingsDB.Scale(SettingsCF.minimap.size))
Minimap:SetHeight(SettingsDB.Scale(SettingsCF.minimap.size))
Minimap:SetMaskTexture(SettingsCF.media.blank)
Minimap:SetFrameStrata("LOW")
function GetMinimapShape() return "SQUARE" end

-- 材质遮罩 (用于兼容Carbonite插件)
local hint = CreateFrame("Frame")
local total = 0
local SetTextureTrick = function(self, elapsed)
	total = total + elapsed
	if(total > 2) then
		Minimap:SetMaskTexture(SettingsCF.media.blank)
		hint:SetScript("OnUpdate", nil)
	end
end

hint:RegisterEvent("PLAYER_LOGIN")
hint:SetScript("OnEvent", function()
	hint:SetScript("OnUpdate", SetTextureTrick)
end)

-- 隐藏游戏自带边框
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- 隐藏缩放按钮
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- 隐藏语音图标
SettingsDB.Kill(MiniMapVoiceChatFrame)
SettingsDB.Kill(VoiceChatTalkers)

-- 隐藏指北材质
MinimapNorthTag:SetTexture(nil)

-- 隐藏区域文字
MinimapZoneTextButton:Hide()

-- 隐藏追踪图标背景
MiniMapTrackingBackground:Hide()

-- 隐藏游戏自带时钟框体
GameTimeFrame:Hide()
UIMinimap:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TimeManager" then
		-- Hide Game Time
		SettingsDB.Kill(TimeManagerClockButton)
	end
end)

-- 隐藏微缩地图开关按钮
MinimapToggleButton:Hide()

-- 美化邮件图标
--MiniMapMailFrame:Hide()
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", SettingsDB.Scale(6), SettingsDB.Scale(-8))
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\meatUI\\media\\textures\\mail")

-- 移动战场图标
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", SettingsDB.Scale(1), SettingsDB.Scale(6))
MiniMapBattlefieldBorder:Hide()

-- 隐藏世界地图按钮
MiniMapWorldMapButton:Hide()

-- 副本难度按钮 (3.2.2 无效)
--[[
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(2))
MiniMapInstanceDifficulty:SetScale(0.75)

GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", SettingsDB.Scale(-2), SettingsDB.Scale(2))
GuildInstanceDifficulty:SetScale(0.75)
]]

-- 日历提醒图标
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent(Minimap)
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

-- 随机组队图标 (3.2.2 无效)
--[[
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("TOP", Minimap, "TOP", SettingsDB.Scale(1), SettingsDB.Scale(6))
	MiniMapLFGFrame:SetHighlightTexture(nil)
	MiniMapLFGFrameBorder:Hide()
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)
]]

-- 鼠标滚轮缩放
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

----------------------------------------------------------------------------------------
-- 点击菜单
----------------------------------------------------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local micromenu = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() ToggleFrame(SpellBookFrame) end},
	{text = TALENTS_BUTTON,
	func = function() ToggleTalentFrame() end},
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = PLAYER_V_PLAYER,
	func = function() ToggleFrame(PVPParentFrame) end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
	if IsInGuild() then
		if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
		end
	end},
	-- 3.2.x
	{text = LFG_TITLE,
	func = function() ToggleFrame(LFGParentFrame) end},
	--3.3.x
--	{text = LFG_TITLE,
--	func = function() ToggleFrame(LFDParentFrame) end},
--	{text = LOOKING_FOR_RAID,
--	func = function() ToggleFrame(LFRParentFrame) end},
	{text = HELP_BUTTON,
	func = function() ToggleHelpFrame() end},
	{text = L_MINIMAP_GAMEMENU,
	func = function() ToggleFrame(GameMenuFrame) end},
	{text = L_MINIMAP_CALENDAR,
	func = function()
	if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
		Calendar_Toggle()
	end},
}
local addonmenu = {
	{text = "AtlasLoot",
	func = function() if IsAddOnLoaded("AtlasLoot") then AtlasLootDefaultFrame:Show() end end},
	{text = "DBM",
	func = function() if IsAddOnLoaded("DBM-Core") then DBM:LoadGUI() end end},
	{text = "DXE",
	func = function() if IsAddOnLoaded("DXE") then DXE:ToggleConfig() end end},
	{text = "PallyPower",
	func = function() if IsAddOnLoaded("PallyPower") then PallyPowerConfigFrame:Show() end end},
	{text = "Skada",
	func = function() if IsAddOnLoaded("Skada") then Skada:ToggleWindow() end end},
	{text = "WIM",
	func = function() if IsAddOnLoaded("WIM") then WIM.ShowAllWindows() end end},
	{text = "Omen",
	func = function() if IsAddOnLoaded("Omen") then Omen:Toggle() end end},
	{text = "Recount",
	func = function() if IsAddOnLoaded("Recount") then Recount.MainWindow:Show() end end},
	{text = "TinyDPS",
	func = function() if IsAddOnLoaded("TinyDPS") then tdpsFrame:Show() end end},
}

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" and not InCombatLockdown() then
		EasyMenu(micromenu, menuFrame, "cursor", 0, 0, "MENU", 2)
	elseif button == "MiddleButton" then
		EasyMenu(addonmenu, menuFrame, "cursor", 0, 0, "MENU", 2)
	elseif button == "LeftButton" then
		Minimap_OnClick(self)
	end
end)

----------------------------------------------------------------------------------------
-- 战斗中隐藏微缩地图
----------------------------------------------------------------------------------------
if SettingsCF.minimap.hide_combat == true then
	MinimapCluster:RegisterEvent("PLAYER_REGEN_ENABLED")
	MinimapCluster:RegisterEvent("PLAYER_REGEN_DISABLED")
	MinimapCluster:HookScript("OnEvent",function(self, event)
		if event == "PLAYER_REGEN_ENABLED" then
			self:Show()
		elseif event == "PLAYER_REGEN_DISABLED" then
			self:Hide()
		end
	end)
end

----------------------------------------------------------------------------------------
-- 追踪文字和图标
----------------------------------------------------------------------------------------
if SettingsCF.minimap.tracking_icon ~= true then
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTrackingIcon:SetAlpha(0)
end
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT", Minimap, SettingsDB.Scale(-5), SettingsDB.Scale(5))
MiniMapTrackingButton:SetHighlightTexture(nil)
MiniMapTrackingButtonBorder:Hide()
MiniMapTrackingIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
MiniMapTrackingIcon:SetHeight(SettingsDB.Scale(16))
MiniMapTrackingIcon:SetWidth(SettingsDB.Scale(16))

--[[
local function Minimap_GetTrackType()
	local track = nil
	for i = 1, GetNumTrackingTypes() do
		local name, _, isActive = GetTrackingInfo(i)
		if (isActive) then
			track = isActive
			MinimapTrackingText:SetText(name)
		end
		
		if (not track) then
			MinimapTrackingText:SetText(NONE)
		end
	end
end

MinimapTrackingText = Minimap:CreateFontString("$parentTrackingText", "OVERLAY")
MinimapTrackingText:SetFont(SettingsCF.media.font, SettingsCF.media.pixel_font_size, SettingsCF.media.font_style)
MinimapTrackingText:SetTextColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
MinimapTrackingText:SetPoint("CENTER", Minimap, 0, SettingsDB.Scale(35))
MinimapTrackingText:SetWidth((Minimap:GetWidth() - 5))
MinimapTrackingText:SetAlpha(0)

Minimap:SetScript("OnEnter", function()
	Minimap_GetTrackType()
	UIFrameFadeIn(MinimapTrackingText, 0.15, MinimapTrackingText:GetAlpha(), 1)
end)

Minimap:SetScript("OnLeave", function()
	Minimap_GetTrackType()
	UIFrameFadeOut(MinimapTrackingText, 0.15, MinimapTrackingText:GetAlpha(), 0)
end)
]]

----------------------------------------------------------------------------------------
-- 图形设置界面开关按钮 (by Fernir)
----------------------------------------------------------------------------------------
if SettingsCF.general.minimap_icon == true and IsAddOnLoaded("meatUI_Config") then
	local menuIcon = CreateFrame("Button", "GUIButton", Minimap)
	SettingsDB.CreateTemplate(menuIcon, 0.5)
--	menuIcon:SetWidth(SettingsCF.minimap.size)
	menuIcon:SetHeight(SettingsDB.Scale(10))
--	menuIcon:SetMovable(true)
	menuIcon:RegisterForClicks("AnyUp")
--	menuIcon:RegisterForDrag("LeftButton")
	menuIcon:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(2))
	menuIcon:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(2))
--[[
	local minimapShapes = {
		["ROUND"] = {true, true, true, true},
		["SQUARE"] = {false, false, false, false},
		["CORNER-TOPLEFT"] = {true, false, false, false},
		["CORNER-TOPRIGHT"] = {false, false, true, false},
		["CORNER-BOTTOMLEFT"] = {false, true, false, false},
		["CORNER-BOTTOMRIGHT"] = {false, false, false, true},
		["SIDE-LEFT"] = {true, true, false, false},
		["SIDE-RIGHT"] = {false, false, true, true},
		["SIDE-TOP"] = {true, false, true, false},
		["SIDE-BOTTOM"] = {false, true, false, true},
		["TRICORNER-TOPLEFT"] = {true, true, true, false},
		["TRICORNER-TOPRIGHT"] = {true, false, true, true},
		["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
		["TRICORNER-BOTTOMRIGHT"] = {false, true, true, true},
	}

	local function onupdate(self)
		if self.isMoving then
			local mx, my = Minimap:GetCenter()
			local px, py = GetCursorPosition()
			local scale = Minimap:GetEffectiveScale()
			px, py = px / scale, py / scale
			
			local angle = math.rad(math.deg(math.atan2(py - my, px - mx)) % 360)
				
			local x, y, q = math.cos(angle), math.sin(angle), 1
			if x < 0 then q = q + 1 end
			if y > 0 then q = q + 2 end

			local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
			local quadTable = minimapShapes[minimapShape]
			if quadTable[q] then
				x, y = x*80, y*80
			else
				local diagRadius = 103.13708498985 --math.sqrt(2*(80)^2)-10
				x = math.max(-78, math.min(x*diagRadius, 78));
				y = math.max(-78, math.min(y*diagRadius, 78));
			end
			self:ClearAllPoints();
			self:SetPoint("CENTER", Minimap, "CENTER", x, y);
		end
	end
]]
	menuIcon:SetScript("OnClick", function(self, button)
		if IsShiftKeyDown() and button == "RightButton" then
			ReloadUI()
		else
			if button == "LeftButton" then
				PlaySound("igMainMenuOption")
				HideUIPanel(GameMenuFrame)
				if not UIConfig or not UIConfig:IsShown() then
					CreateUIConfig()
				else
					UIConfig:Hide()
				end
			elseif button == "RightButton" then
				ToggleDropDownMenu(1, nil, iconMenuDrop, self, 0, 15)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
			end
		end
	end)
--[[
	menuIcon:SetScript("OnDragStart", function(self)
		if IsShiftKeyDown() then
			self.isMoving = true
			self:SetScript("OnUpdate", function(self) onupdate(self) end)
		end
	end)

	menuIcon:SetScript("OnDragStop", function(self)
		self.isMoving = nil
		self:SetScript("OnUpdate", nil)
		self:SetUserPlaced(true)
	end)	
]]
	menuIcon:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine("|cffcc3333meatUI|r "..SettingsDB.version)
		GameTooltip:AddLine(L_GUI_MINIMAP_ICON_LM, 1, 1, 1)
		GameTooltip:AddLine(L_GUI_MINIMAP_ICON_RM, 1, 1, 1)
		GameTooltip:AddLine(L_GUI_MINIMAP_ICON_SRM, 1, 1, 1)
--		GameTooltip:AddLine(L_GUI_MINIMAP_ICON_SD, 1, 1, 1)
		GameTooltip:Show()
	end)

	menuIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)

	function addDrop(array)
		local info = array
		
		local function dropDown_create(self, level)
			 for i, j in pairs(info) do
				UIDropDownMenu_AddButton(j, level)
			 end
		end

		local iconMenu = CreateFrame("Frame", "iconMenu", nil, "UIDropDownMenuTemplate")
		UIDropDownMenu_Initialize(iconMenu, dropDown_create, "MENU", level)
		return iconMenu
	end

	iconMenuDrop = addDrop({
			{ text = L_GUI_MINIMAP_ICON_SLASH, isTitle = 1, notCheckable = 1, keepShownOnClick = 1 },
			{ text = L_GUI_MINIMAP_ICON_SPEC, func = function() 
				local spec = GetActiveTalentGroup()
				if spec == 1 then 
					SetActiveTalentGroup(2) 
				elseif spec == 2 then 
					SetActiveTalentGroup(1) 
				end
			end },
			{ text = L_GUI_MINIMAP_ICON_CL, func = function() CombatLogClearEntries() end },
			{ text = L_GUI_MINIMAP_ICON_DBM, func = function() DBM:DemoMode() end },
			{ text = L_GUI_MINIMAP_ICON_HEAL, func = function()
				DisableAddOn("meatUI_Raid_Dps")
				EnableAddOn("meatUI_Raid_Heal")
				ReloadUI()
			end },
			{ text = L_GUI_MINIMAP_ICON_DPS, func = function()
				DisableAddOn("meatUI_Raid_Heal")
				EnableAddOn("meatUI_Raid_Dps")
				ReloadUI()
			end },
	})
end

----------------------------------------------------------------------------------------
-- 区域文字及坐标动画 (by eP)
----------------------------------------------------------------------------------------
local m_zone = CreateFrame("Frame", m_zone, UIParent)
	SettingsDB.CreateTemplate(m_zone, 0.5)
	m_zone:SetHeight(SettingsDB.Scale(18))
	m_zone:SetFrameLevel(5)
	m_zone:SetPoint("TOPLEFT", Minimap, SettingsDB.Scale(-1), SettingsDB.Scale(0.5))
	m_zone:SetPoint("TOPRIGHT", Minimap, SettingsDB.Scale(1), SettingsDB.Scale(0.5))

	SettingsDB.CreateAnim(m_zone, true, 0, 50)
	m_zone:Hide()

local m_zone_text = m_zone:CreateFontString(nil,"Overlay")
	m_zone_text:SetFont(SettingsCF.media.font, SettingsCF.media.font_size, SettingsCF.media.font_style)
--	m_zone_text:SetShadowOffset(1,-1)
	m_zone_text:SetPoint("CENTER", 0, 1)
--	m_zone_text:SetPoint("RIGHT",-4.7,1.3)
	m_zone_text:SetJustifyH("CENTER")
--	m_zone_text:SetHeight(SettingsCF.media.font_size)

local m_coord = CreateFrame("Frame", m_coord, UIParent)
	SettingsDB.CreateTemplate(m_coord, 0.5)
	m_coord:SetHeight(SettingsDB.Scale(18))
	m_coord:SetPoint("BOTTOMRIGHT", Minimap, SettingsDB.Scale(1), SettingsDB.Scale(-1))
	m_coord:SetWidth(SettingsDB.Scale(45))

	SettingsDB.CreateAnim(m_coord, true, 50, 0)
	m_coord:Hide()

local m_coord_text = m_coord:CreateFontString(nil,"Overlay")
	m_coord_text:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
--	m_coord_text:SetShadowOffset(1, -1)
	m_coord_text:SetPoint("Center", -0.7, 1.3)
	m_coord_text:SetJustifyH("LEFT")

Minimap:SetScript("OnEnter",function()
	m_zone.anim_o:Stop()
	m_coord.anim_o:Stop()
	m_zone:Show()
	m_coord:Show()
	m_coord.anim:Play()
	m_zone.anim:Play()
end)

Minimap:SetScript("OnLeave",function()
	m_coord.anim:Stop()
	m_coord.anim_o:Play()
	m_zone.anim:Stop()
	m_zone.anim_o:Play()
end)

m_coord_text:SetText("00,00")

local ela,go = 0,false

m_coord.anim:SetScript("OnFinished",function() go = true end)
m_coord.anim_o:SetScript("OnPlay",function() go = false end)

local coord_Update = function(self,t)
	ela = ela - t
	if ela > 0 or not(go) then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		m_coord_text:SetText("X _ X")
	else
		if x < 10 then 
			xt = "0"..x
		else 
			xt = x 
		end
		if y < 10 then 
			yt = "0"..y 
		else 
			yt = y 
		end
		m_coord_text:SetText(xt..","..yt)
	end
	ela = .2
end

m_coord:SetScript("OnUpdate",coord_Update)

local zone_Update = function()
	local pvp = GetZonePVPInfo()
	m_zone_text:SetText(GetMinimapZoneText())
	if pvp == "friendly" then
		m_zone_text:SetTextColor(0.1, 1.0, 0.1)
	elseif pvp == "sanctuary" then
		m_zone_text:SetTextColor(0.41, 0.8, 0.94)
	elseif pvp == "arena" or pvp == "hostile" then
		m_zone_text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvp == "contested" then
		m_zone_text:SetTextColor(1.0, 0.7, 0.0)
	else
		m_zone_text:SetTextColor(1.0, 1.0, 1.0)
	end
end

m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent",zone_Update) 

local a,k = CreateFrame("Frame"),4
a:SetScript("OnUpdate",function(self,t)
	k = k - t
	if k > 0 then return end
	self:Hide()
	zone_Update()
end)

----------------------------------------------------------------------------------------
-- 地图信号 (代码节选自LiteStats)
----------------------------------------------------------------------------------------
if SettingsCF.minimap.ping == true then
	local PingFrame = CreateFrame("Frame")

	local PingText = SettingsDB.SetFontString(PingFrame, SettingsCF.media.font, SettingsCF.media.font_size, SettingsCF.media.font_style)
	PingText:SetPoint("CENTER", Minimap, "CENTER", 0, 18)
	PingText:SetJustifyH("CENTER")

	local function OnEvent(self, event, unit)
		if unit == "Player" and SettingsCF.minimap.ping_self ~= true then return end
		if (unit == "Player" and self.timer and time() - self.timer > 1) or not self.timer or unit ~= "Player" then
			local class = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(unit))]
			local unitname = UnitName(unit)
			PingText:SetText(format("|cffff0000>|r %s |cffff0000<|r", unitname))
			PingText:SetTextColor(class.r, class.g, class.b)
			UIFrameFlash(self, 0.2, 2.8, 5, false, 0, 5)
			self.timer = time()
		end
	end
	PingFrame:RegisterEvent("MINIMAP_PING")
	PingFrame:SetScript("OnEvent", OnEvent)
end