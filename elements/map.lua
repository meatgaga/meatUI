----------------------------------------------------------------------------------------
-- 世界地图 (基于pMap by p3lim)
----------------------------------------------------------------------------------------
local function CreateText(offset)
	local text = WorldMapButton:CreateFontString(nil, "ARTWORK")
	text:SetPoint("BOTTOM", WorldMapButton, offset, -20)
	text:SetFontObject("GameFontNormal")
	text:SetJustifyH("LEFT")
	return text
end

local function OnUpdate(player, cursor)
	local centerx, centery = WorldMapDetailFrame:GetCenter()
	local px, py = GetPlayerMapPosition("player")
	local x, y = GetCursorPosition()

	x = ((x / WorldMapFrame:GetScale()) - (centerx - (WorldMapDetailFrame:GetWidth() / 2))) / 10
	y = (((centery + (WorldMapDetailFrame:GetHeight() / 2)) - (y / WorldMapFrame:GetScale())) / WorldMapDetailFrame:GetHeight()) * 100

	player:SetFormattedText(UnitName("player")..": %.2d,%.2d", px * 100, py * 100)
	if(x >= 100 or y >= 100 or x <= 0 or y <= 0) then
		cursor:SetText(L_MAP_CURSOR.."|cffff0000"..L_MAP_BOUNDS.."|r")
	else
		cursor:SetFormattedText(L_MAP_CURSOR.."%.2d,%.2d", x, y)
	end
end

local function OnEvent(self)
	local player = CreateText(-60)
	local cursor = CreateText(60)
	local elapsed = 0

	self:SetScript("OnUpdate", function(self, u)
		elapsed = elapsed + u
		if(elapsed > 0.1) then
			OnUpdate(player, cursor)
			elapsed = 0
		end
	end)

	UIPanelWindows["WorldMapFrame"] = {area = "center", pushable = 9}
	hooksecurefunc(WorldMapFrame, "Show", function(self)
		self:SetScale(0.8)
		self:EnableKeyboard(false)
		self:EnableMouse(false)
		BlackoutWorld:Hide()
	end)

	WorldMapZoneMinimapDropDown:Hide()
	WorldMapZoomOutButton:Hide()
end

local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", OnEvent)
addon:RegisterEvent("PLAYER_LOGIN")

----------------------------------------------------------------------------------------
-- 区域地图
----------------------------------------------------------------------------------------
local bm = CreateFrame("Frame")
bm:RegisterEvent("ADDON_LOADED")
bm:SetScript("OnEvent", function(self, event, addon)
	if not BattlefieldMinimap_Update then return end
	self:SetParent(BattlefieldMinimap)
	self:SetScript("OnShow", function()
		BattlefieldMinimapCorner:Hide()
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCloseButton:Hide()
	end)
	local background = CreateFrame("Frame", "BACKGROUND", BattlefieldMinimap)
	SettingsDB.CreateTemplate(background)
	background:SetFrameLevel(0)
	background:SetPoint("TOPLEFT", SettingsDB.Scale(-2), SettingsDB.Scale(2))
	background:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-4), SettingsDB.Scale(2))
	background:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)

	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)
