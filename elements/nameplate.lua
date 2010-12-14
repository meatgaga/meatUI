----------------------------------------------------------------------------------------
-- 姓名板 (基于caelNamePlates by Caellian)
----------------------------------------------------------------------------------------
if not SettingsCF.nameplate.enable == true then return end

local caelNamePlates = CreateFrame("Frame", nil, UIParent)
caelNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local select = select

local isValidFrame = function(frame)
	if frame:GetName() then	return end
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end

local threatUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= 0.2 then
		if not self.oldglow:IsShown() then
			self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
		else
			local _, green = self.oldglow:GetVertexColor()
			if(green > 0.7) then
				r, g, b = 1, 1, 0.3 -- medium threat
			else
				r, g, b = 0.3, 1, 0.3 -- tanking
			end
			self.healthBar:SetStatusBarColor(r, g, b)
		end
		self.elapsed = 0
	end
end

local Abbrev = function(name)
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return SettingsDB.UTF8Sub(newname, 18, false)
end

local updatePlate = function(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		newr, newg, newb = 0.85, 0.27, 0.27
		self.healthBar:SetStatusBarColor(0.85, 0.27, 0.27)
		if self.boss:IsShown() or self.elite:IsShown() then
			self.healthBar.UnitType = "Hostile"
		end
	elseif r + b == 0 then
		-- Friendly unit
		newr, newg, newb = 0.33, 0.59, 0.33
		self.healthBar:SetStatusBarColor(0.33, 0.59, 0.33)
	elseif r + g == 0 then
		-- Friendly player
		newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		newr, newg, newb = 0.65, 0.63, 0.35
		self.healthBar:SetStatusBarColor(0.65, 0.63, 0.35)
	else
		-- Hostile player - class colored.
		newr, newg, newb = r, g, b
	end

	self.r, self.g, self.b = newr, newg, newb

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
	self.healthBar:SetHeight(SettingsDB.Scale(SettingsCF.nameplate.height))
	self.healthBar:SetWidth(SettingsDB.Scale(SettingsCF.nameplate.width))
	self.name:SetText(Abbrev(self.oldname:GetText()))

	self.healthBar.hpBackground:SetVertexColor(self.r * 0.30, self.g * 0.30, self.b * 0.30)
	self.healthBar.hpBackground:SetAlpha(0.9)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, SettingsDB.Scale(-8))
	self.castBar:SetHeight(SettingsDB.Scale(SettingsCF.nameplate.height))
	self.castBar:SetWidth(SettingsDB.Scale(SettingsCF.nameplate.width))

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	local level, elite = tonumber(self.level:GetText()), self.elite:IsShown()
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", SettingsDB.Scale(-2), SettingsDB.Scale(0.5))
	if self.boss:IsShown() then
		self.level:SetText("B")
		self.level:SetTextColor(1, 0, 0)
		self.level:Show()
--	elseif not elite and level == SettingsDB.level then
--		self.level:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local fixCastbar = function(self)
	self.castbarOverlay:Hide()
	self:SetHeight(SettingsDB.Scale(SettingsCF.nameplate.height))
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, SettingsDB.Scale(-8))
end

local colorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0.05)
		self.cbGlow:SetBackdropBorderColor(0.8, 0.05, 0.05)
		self.icGlow:SetBackdropBorderColor(0.8, 0.05, 0.05)
	else
		self.cbGlow:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		self.icGlow:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	end
end

local onSizeChanged = function(self)
	self.needFix = true
end

local onShow = function(self)
	self.channeling  = UnitChannelInfo("target")
	fixCastbar(self)
	colorCastBar(self, self.shieldedRegion:IsShown())
end

local onHide = function(self)
	self.highlight:Hide()
end

local onEvent = function(self, event, unit)
--	if unit == "target" then
		if self:IsShown() then
			colorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
--	end
end

local createPlate = function(frame)
	if frame.done then return end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()

	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	frame.OriginalHealth = healthBar

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = frame:CreateFontString()
	newNameRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, SettingsDB.Scale(4))
	newNameRegion:SetFont(SettingsCF.media.font, SettingsDB.Scale(SettingsCF.nameplate.font_size), SettingsCF.media.font_style)
	newNameRegion:SetTextColor(1, 1, 1)
	frame.name = newNameRegion

	frame.level = levelTextRegion
	levelTextRegion:SetFont(SettingsCF.media.pixel_font, SettingsDB.Scale(SettingsCF.media.pixel_font_size), SettingsCF.media.pixel_font_style)
	levelTextRegion:SetShadowOffset(0, 0)

--	local offset = UIParent:GetEffectiveScale()

	healthBar:SetStatusBarTexture(SettingsCF.media.bar)

	healthBar.hpBackground = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBackground:SetAllPoints(healthBar)
	healthBar.hpBackground:SetTexture(SettingsCF.media.blank)
	healthBar.hpBackground:SetVertexColor(0.15, 0.15, 0.15)

	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetBackdrop({
		bgFile = SettingsCF.media.blank,
		edgeFile = SettingsCF.media.blank,
		tile = false, tileSize = 0, edgeSize = SettingsDB.Scale(1),
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	healthBar.hpGlow:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
	healthBar.hpGlow:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)

	castBar:SetStatusBarTexture(SettingsCF.media.bar)

	castBar:HookScript("OnShow", onShow)
	castBar:HookScript("OnSizeChanged", onSizeChanged)
	castBar:HookScript("OnEvent", onEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetFont(SettingsCF.media.pixel_font, SettingsDB.Scale(SettingsCF.media.pixel_font_size), SettingsCF.media.pixel_font_style)
	castBar.time:SetPoint("RIGHT", castBar, "RIGHT", 0, SettingsDB.Scale(0.5))
	castBar.time:SetJustifyH("RIGHT")

	if SettingsCF.nameplate.castbar_name == true then
		castBar.castName = castBar:CreateFontString(nil, "OVERLAY")
		castBar.castName:SetFont(SettingsCF.media.font, SettingsDB.Scale(SettingsCF.nameplate.font_size), SettingsCF.media.font_style)
		castBar.castName:SetHeight(SettingsCF.nameplate.height)
		castBar.castName:SetWidth(SettingsCF.nameplate.width - 27)
		castBar.castName:SetPoint("LEFT", castBar, "LEFT", SettingsDB.Scale(2), SettingsDB.Scale(0.5))
		castBar.castName:SetTextColor(1, 1, 1)
		castBar.castName:SetJustifyH("LEFT")
	end

	castBar.cbBackground = castBar:CreateTexture(nil, "BORDER")
	castBar.cbBackground:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	castBar.cbBackground:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	castBar.cbBackground:SetTexture(SettingsCF.media.blank)
	castBar.cbBackground:SetVertexColor(0.15, 0.15, 0.15)

	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetBackdrop({
		bgFile = SettingsCF.media.blank,
		edgeFile = SettingsCF.media.blank,
		tile = false, tileSize = 0, edgeSize = SettingsDB.Scale(1),
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	castBar.cbGlow:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
	castBar.cbGlow:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	castBar.cbGlow:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	castBar.Hold = CreateFrame("Frame", nil, healthBar)
	castBar.Hold:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 0, 0)
	castBar.Hold:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)
	castBar.Hold:SetFrameLevel(10)
	castBar.Hold:SetFrameStrata("MEDIUM")

	if SettingsCF.nameplate.class_icons == true then
		frame.icon = castBar.Hold:CreateTexture(nil, "OVERLAY")
		frame.icon:SetPoint("TOPRIGHT", healthBar, "TOPLEFT", SettingsDB.Scale(-8), SettingsDB.Scale(2))
		frame.icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		frame.icon:SetHeight((SettingsCF.nameplate.height * 2) + 11)
		frame.icon:SetWidth((SettingsCF.nameplate.height * 2) + 11)

		frame.icon.Glow = CreateFrame("Frame", nil, frame)
		frame.icon.Glow:SetBackdrop({
			bgFile = SettingsCF.media.blank,
			edgeFile = SettingsCF.media.blank,
			tile = false, tileSize = 0, edgeSize = SettingsDB.Scale(1),
			insets = {left = 0, right = 0, top = 0, bottom = 0}
		})
		frame.icon.Glow:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
		frame.icon.Glow:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		frame.icon.Glow:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
		frame.icon.Glow:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		frame.icon.Glow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
		frame.icon.Glow:Hide()
	end

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetParent(castBar)
	spellIconRegion:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	spellIconRegion:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", SettingsDB.Scale(10), 0)
	spellIconRegion:SetWidth((SettingsCF.nameplate.height * 2) + 7)
	spellIconRegion:SetHeight((SettingsCF.nameplate.height * 2) + 7)

	spellIconRegion.IconBackdrop = CreateFrame("Frame", nil, castBar)
	spellIconRegion.IconBackdrop:SetBackdrop({
		bgFile = SettingsCF.media.blank,
		edgeFile = SettingsCF.media.blank,
		tile = false, tileSize = 0, edgeSize = SettingsDB.Scale(1),
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	spellIconRegion.IconBackdrop:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
	spellIconRegion.IconBackdrop:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	spellIconRegion.IconBackdrop:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	spellIconRegion.IconBackdrop:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	spellIconRegion.IconBackdrop:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	highlightRegion:SetTexture(SettingsCF.media.bar)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("CENTER", healthBar, "CENTER", 0, SettingsDB.Scale(35))
	raidIconRegion:SetWidth(SettingsDB.Scale(25))
	raidIconRegion:SetHeight(SettingsDB.Scale(25))

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion
	castBar.icGlow = spellIconRegion.IconBackdrop
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion

	frame.done = true

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	updatePlate(frame)
	frame:SetScript("OnShow", updatePlate)
	frame:SetScript("OnHide", onHide)

	frame.elapsed = 0
	frame:SetScript("OnUpdate", threatUpdate)

	if SettingsCF.nameplate.class_icons == true then
		frame:HookScript("OnUpdate", UpdateClass)
	end
end

-- Update class function
if SettingsCF.nameplate.class_icons == true then
	function UpdateClass(frame)
		local r, g, b = frame.healthBar:GetStatusBarColor()
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		local classname = ""
		local hasclass = 0
		for class, color in pairs(RAID_CLASS_COLORS) do
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
				classname = class
			end
		end
		if (classname) then
			texcoord = CLASS_BUTTONS[classname]
			if texcoord then
				hasclass = 1
			else
				texcoord = {0.5, 0.75, 0.5, 0.75}
				hasclass = 0
			end
		else
			texcoord = {0.5, 0.75, 0.5, 0.75}
			hasclass = 0
		end
		frame.icon:SetTexCoord(texcoord[1],texcoord[2],texcoord[3],texcoord[4])
		if hasclass == 1 then
			frame.icon.Glow:Show()
		else
			frame.icon.Glow:Hide()
		end
	end
end

local numKids = 0
local lastUpdate = 0
local onUpdate = function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.05 then
		lastUpdate = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids+1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())

				if isValidFrame(frame) then
					createPlate(frame)
				end
			end
			numKids = newNumKids
		end
	end
end

caelNamePlates:SetScript("OnUpdate", onUpdate)

if SettingsCF.nameplate.combat == true then
	caelNamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	function caelNamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	caelNamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	function caelNamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end
