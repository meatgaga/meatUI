if not SettingsCF.unitframe.enable == true then return end

------------------------------------------------------------------------
-- 布局
------------------------------------------------------------------------
local pos = SettingsCF.position.unitframes

local function Shared(self, unit)
	-- 自定义颜色
	self.colors = SettingsDB.oUF_colors

	-- 注册点击行为
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	local unit = (unit and unit:find("arena%dtarget")) and "arenatarget" 
	or (unit and unit:find("arena%d")) and "arena"
	or (unit and unit:find("boss%d")) and "boss" or unit
	
	-- 右键菜单
	self.menu = SettingsDB.SpawnMenu
	if (unit == "arena" and SettingsCF.unitframe.show_arena == true and unit ~= "arenatarget") or (unit == "boss" and SettingsCF.unitframe.show_boss == true) then
		self:SetAttribute("type2", "focus")
	else
		self:SetAttribute("*type2", "menu")
	end

	-- 所有单位的背板
--	self.FrameBackdrop = CreateFrame("Frame", nil, self)
--	SettingsDB.CreateTemplate(self.FrameBackdrop)
--	self.FrameBackdrop:SetFrameStrata("BACKGROUND")
--	self.FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
--	self.FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))

	self.Panel = SettingsDB.CreateShadowFrame(self, 1, "MEDIUM", true)
	self.Panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))
	if (unit == "player" and SettingsDB.class == "DEATHKNIGHT") or ( unit== "player" and SettingsDB.class == "SHAMAN") then
		self.Panel:SetPoint("TOPLEFT", self, "TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(8))
	else
		self.Panel:SetPoint("TOPLEFT", self, "TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
	end

	-- 生命条
	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
		self.Health:SetHeight(SettingsDB.Scale(21))
	elseif unit == "arenatarget" then
		self.Health:SetHeight(SettingsDB.Scale(27))
	else
		self.Health:SetHeight(SettingsDB.Scale(13))
	end
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	self.Health:SetStatusBarTexture(SettingsCF.media.bar)

	-- 生命条背景
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(SettingsCF.media.blank)
	self.Health.bg.multiplier = 0.25

	-- 生命值
	self.Health.value = SettingsDB.SetFontString(self.Health, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	if unit == "player" or unit == "pet" or unit == "focus" then
		self.Health.value:SetPoint("RIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		self.Health.value:SetJustifyH("RIGHT")
	elseif unit == "arena" then
		if SettingsCF.unitframe.arena_on_right == true then
			self.Health.value:SetPoint("LEFT", SettingsDB.Scale(2), SettingsDB.Scale(1))
			self.Health.value:SetJustifyH("LEFT")
		else
			self.Health.value:SetPoint("RIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
			self.Health.value:SetJustifyH("RIGHT")
		end
	else
		self.Health.value:SetPoint("LEFT", SettingsDB.Scale(2), SettingsDB.Scale(1))
		self.Health.value:SetJustifyH("LEFT")
	end

	-- 生命条更新
	self.Health.frequentUpdates = true
	if SettingsCF.unitframe.own_color == true then
		self.Health.colorTapping = false
		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health:SetStatusBarColor(unpack(SettingsCF.media.uf_color))
	else
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		if UnitIsPlayer("target") then
			self.Health.colorReaction = false
		else
			self.Health.colorReaction = true
		end	
	end
	if SettingsCF.unitframe.plugins_smooth_bar == true then
		self.Health.Smooth = true
	end
	self.Health.PostUpdate = SettingsDB.PostUpdateHealth

--	self.DebuffHighlightAlpha = 1
--	self.DebuffHighlightBackdrop = true
--	self.DebuffHighlightFilter = true

	-- 能量条
	self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
	if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
		self.Power:SetHeight(SettingsDB.Scale(5))
	elseif unit == "arenatarget" then
		self.Power:SetHeight(SettingsDB.Scale(0))
	else
		self.Power:SetHeight(SettingsDB.Scale(2))
	end	
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, SettingsDB.Scale(-1))
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, SettingsDB.Scale(-1))
	self.Power:SetStatusBarTexture(SettingsCF.media.bar)

	-- 能量条背景
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(SettingsCF.media.blank)
	self.Power.bg.multiplier = 0.25

	-- 能量值
	self.Power.value = SettingsDB.SetFontString(self.Power, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	if unit == "player"then
		self.Power.value:SetPoint("RIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		self.Power.value:SetJustifyH("RIGHT")
	elseif unit == "arena" then
		if SettingsCF.unitframe.arena_on_right == true then
			self.Power.value:SetPoint("LEFT", SettingsDB.Scale(2), SettingsDB.Scale(1))
			self.Power.value:SetJustifyH("LEFT")
		else
			self.Power.value:SetPoint("RIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
			self.Power.value:SetJustifyH("RIGHT")
		end
	elseif unit=="pet" then
		self.Power.value:Hide()
	else
		self.Power.value:SetPoint("LEFT", SettingsDB.Scale(2), SettingsDB.Scale(1))
		self.Power.value:SetJustifyH("LEFT")
	end

	--能量条更新
--	self.Power.PreUpdate = PreUpdatePower
	self.Power.PostUpdate = SettingsDB.PostUpdatePower

	self.Power.frequentUpdates = true
	self.Power.colorDisconnected = true
	self.Power.colorTapping = true
	if SettingsCF.unitframe.own_color == true then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	if SettingsCF.unitframe.plugins_smooth_bar == true then
		self.Power.Smooth = true
	end

	-- 名字, 等级, 类型等信息
	if unit ~= "player" then
		self.Name = SettingsDB.SetFontString(self.Health, SettingsCF.media.font, SettingsCF.unitframe.font_size, SettingsCF.media.font_style)
		if unit == "target" then
			self.Name:SetPoint("RIGHT", 0, 0)
			self:Tag(self.Name, "[talents] [getnamecolor][namelong]")
			self.Level = SettingsDB.SetFontString(self.Power, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			self.Level:SetPoint("RIGHT", 0, SettingsDB.Scale(1))
			self:Tag(self.Level, "[cpoints] [threat] [shortclassification][CType] [diffcolor][level]")
		elseif unit == "focus" then
			self.Name:SetPoint("LEFT", SettingsDB.Scale(2), 0)
			self:Tag(self.Name, "[getnamecolor][namemedium]")
		elseif unit == "pet" then
			self.Name:SetPoint("LEFT", SettingsDB.Scale(2), 0)
			self:Tag(self.Name, "[getnamecolor][nameshort]")
			self:RegisterEvent("UNIT_PET", SettingsDB.UpdatePetInfo)
		elseif unit == "arenatarget" then
			self.Name:SetPoint("CENTER", 0, 0)
			self:Tag(self.Name, "[getnamecolor][namearena]")
		elseif unit == "arena" then
			if SettingsCF.unitframe.arena_on_right == true then
				self.Name:SetPoint("RIGHT", 0, 0)
				self:Tag(self.Name, "[talents] [getnamecolor][namemedium]")
			else
				self.Name:SetPoint("LEFT", SettingsDB.Scale(2), 0)
				self:Tag(self.Name, "[getnamecolor][namemedium] [talents]")
			end
		else
			self.Name:SetPoint("RIGHT", 0, 0)
			self:Tag(self.Name, "[getnamecolor][namemedium]")
		end
	end

	-- 玩家框架
	if (unit == "player") then
		-- 自定义信息 (低魔法值警告)
		self.FlashInfo = CreateFrame("Frame", "FlashInfo", self)
		self.FlashInfo:SetScript("OnUpdate", SettingsDB.UpdateManaLevel)
		self.FlashInfo.parent = self
		self.FlashInfo:SetToplevel(true)
		self.FlashInfo:SetAllPoints(self.Health)

		self.FlashInfo.ManaLevel = SettingsDB.SetFontString(self.FlashInfo, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
		self.FlashInfo.ManaLevel:SetPoint("CENTER", self.FlashInfo, "CENTER", 0, SettingsDB.Scale(1))

		-- 战斗图标
		self.Combat = self.Power:CreateTexture(nil, "OVERLAY")
		self.Combat:SetWidth(SettingsDB.Scale(12))
		self.Combat:SetHeight(SettingsDB.Scale(12))
		self.Combat:SetPoint("BOTTOMLEFT", SettingsDB.Scale(-6), SettingsDB.Scale(-6))
--			self.Combat:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
--			self.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		self.Combat:SetTexture("Interface\\AddOns\\meatUI\\media\\textures\\combat")
		self.Combat:SetVertexColor(1, 0, 0)

		-- 休息图标
		if SettingsDB.level ~= MAX_PLAYER_LEVEL then
			self.Resting = self.Power:CreateTexture(nil, "OVERLAY")
			self.Resting:SetWidth(SettingsDB.Scale(12))
			self.Resting:SetHeight(SettingsDB.Scale(12))
			self.Resting:SetPoint("BOTTOMLEFT", SettingsDB.Scale(-6), SettingsDB.Scale(-6))
			self.Resting:SetTexture("Interface\\AddOns\\meatUI\\media\\textures\\rest")
			self.Resting:SetVertexColor(0, 1, 0)
--			self.Resting:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
--			self.Resting:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		-- 队长图标
		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetHeight(SettingsDB.Scale(12))
		self.Leader:SetWidth(SettingsDB.Scale(12))
		self.Leader:SetPoint("TOPLEFT", SettingsDB.Scale(-6), SettingsDB.Scale(6))
		self.Leader:SetTexture("Interface\\AddOns\\meatUI\\media\\textures\\leader")
		self.Leader:SetVertexColor(0.9, 0.8, 0.5)

		-- 物品分配者图标
		self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
		self.MasterLooter:SetHeight(SettingsDB.Scale(12))
		self.MasterLooter:SetWidth(SettingsDB.Scale(12))
		self.MasterLooter:SetPoint("TOPLEFT", SettingsDB.Scale(-6), SettingsDB.Scale(6))
		self.MasterLooter:SetTexture("Interface\\AddOns\\meatUI\\media\\textures\\looter")
		self.MasterLooter:SetVertexColor(0.6, 0.2, 0.8)

		self:RegisterEvent("PARTY_LEADER_CHANGED", SettingsDB.MLAnchorUpdate)
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", SettingsDB.MLAnchorUpdate)

		-- 符文条
		if SettingsDB.class == "DEATHKNIGHT" then
			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, SettingsDB.Scale(1))
			self.Runes:SetHeight(SettingsDB.Scale(4))
			self.Runes:SetWidth(SettingsDB.Scale(212))
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
				self.Runes[i]:SetWidth(207 / 6)		--(头像宽度(1431行)-间隔(1像素)*5) / 6
				self.Runes[i]:SetHeight(4)
				if (i == 1) then
					self.Runes[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, SettingsDB.Scale(1))
				else
					self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i-1], "TOPRIGHT", SettingsDB.Scale(1), 0)
				end
				self.Runes[i]:SetStatusBarTexture(SettingsCF.media.bar)
--				self.Runes[i]:SetStatusBarColor(unpack(RuneLoadColors[i]))

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetAllPoints()
				self.Runes[i].bg:SetTexture(SettingsCF.media.blank)
				self.Runes[i].bg.multiplier = 0.25
			end
		end

		-- 图腾条
		if SettingsDB.class == "SHAMAN" then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
				self.TotemBar[i]:SetWidth(209 / 4)		--(头像宽度(1431行)-间隔(1像素)*3) / 4
				self.TotemBar[i]:SetHeight(4)
				if (i == 1) then
					self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, SettingsDB.Scale(1))
				else
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", SettingsDB.Scale(1), 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(SettingsCF.media.bar)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

--[[				self.TotemBar[i].FrameBackdrop = CreateFrame("Frame", nil, self.TotemBar[i])
				SettingsDB.CreateTemplate(self.TotemBar[i].FrameBackdrop)
				self.TotemBar[i].FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.TotemBar[i].FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
				self.TotemBar[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
]]
				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(SettingsCF.media.blank)
				self.TotemBar[i].bg.multiplier = 0.25
				if SettingsCF.unitframe.plugins_totem_bar_name == true then
					self.TotemBar[i].Name = SettingsDB.SetFontString(self.TotemBar[i], SettingsCF.media.font, SettingsCF.unitframe.font_size, SettingsCF.media.font_style)
					self.TotemBar[i].Name:SetPoint("CENTER", self.TotemBar[i], "CENTER", 0, SettingsDB.Scale(1))
					self.TotemBar[i].Name:SetTextColor(1, 1, 1)
				end
			end
		end

		-- 德鲁伊变形状态下显示魔法值
		if SettingsDB.class == "DRUID" then
			CreateFrame("Frame"):SetScript("OnUpdate", function() SettingsDB.UpdateDruidMana(self) end)
			self.DruidMana = SettingsDB.SetFontString(self.Power, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			self.DruidMana:SetTextColor(1, 0.49, 0.04)
		end

		-- 经验条
		if SettingsDB.level ~= MAX_PLAYER_LEVEL then
			self.Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
			self.Experience:SetHeight(SettingsDB.Scale(3))
			self.Experience:SetWidth(SettingsDB.Scale(321))
			self.Experience:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, SettingsDB.Scale(2))
			self.Experience:SetStatusBarTexture(SettingsCF.media.bar)
			self.Experience:SetStatusBarColor(0, 0.4, 1)

			self.Experience.Rested = CreateFrame("StatusBar", nil, self)
			self.Experience.Rested:SetAllPoints(self.Experience)
			self.Experience.Rested:SetStatusBarTexture(SettingsCF.media.bar)
			self.Experience.Rested:SetStatusBarColor(0.7, 0, 0.7, 0.75)

			self.Experience.bg = self.Experience:CreateTexture(nil, "BORDER")
			self.Experience.bg:SetAllPoints(self.Experience)
			self.Experience.bg:SetTexture(SettingsCF.media.blank)
			self.Experience.bg:SetVertexColor(0, 0.4, 1, 0.25)

			self.Experience.FrameBackdrop = CreateFrame("Frame", nil, self.Experience)
			SettingsDB.CreateTemplate(self.Experience.FrameBackdrop)
			self.Experience.FrameBackdrop:SetFrameLevel(1)
			self.Experience.FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
			self.Experience.FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))

			self.Experience.Tooltip = false
		end

		-- 声望条
		self.Reputation = CreateFrame("StatusBar", self:GetName().."_self.Reputation", self)
		self.Reputation:SetHeight(SettingsDB.Scale(3))
		self.Reputation:SetWidth(SettingsDB.Scale(112))
		self.Reputation:SetPoint("TOP", Minimap, "BOTTOM", 0, SettingsDB.Scale(-3))
		self.Reputation:SetStatusBarTexture(SettingsCF.media.bar)
		self.Reputation:SetStatusBarColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)

		self.Reputation.bg = self.Reputation:CreateTexture(nil, "BORDER")
		self.Reputation.bg:SetAllPoints(self.Reputation)
		self.Reputation.bg:SetTexture(SettingsCF.media.blank)

		self.Reputation.FrameBackdrop = CreateFrame("Frame", nil, self.Reputation)
		SettingsDB.CreateTemplate(self.Reputation.FrameBackdrop)
		self.Reputation.FrameBackdrop:SetFrameLevel(1)
		self.Reputation.FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		self.Reputation.FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))

		self.Reputation.PostUpdate = SettingsDB.UpdateReputationColor
		self.Reputation.Tooltip = true

		-- Swing bar
		if SettingsCF.unitframe.plugins_swing == true then
			self.Swing = CreateFrame("StatusBar", self:GetName().."_Swing", self)
			self.Swing:SetStatusBarTexture(SettingsCF.media.bar)
			self.Swing:SetStatusBarColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
			self.Swing:SetHeight(SettingsDB.Scale(5))
			self.Swing:SetWidth(SettingsDB.Scale(280))
			self.Swing:SetPoint("TOPLEFT", "oUF_Player", "BOTTOMRIGHT", SettingsDB.Scale(30), SettingsDB.Scale(-3))

			self.Swing.bg = self.Swing:CreateTexture(nil, "BORDER")
			self.Swing.bg:SetAllPoints(self.Swing)
			self.Swing.bg:SetTexture(SettingsCF.media.blank)
			self.Swing.bg:SetVertexColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b, 0.25)

			self.Swing.FrameBackdrop = SettingsDB.CreateShadowFrame(self.Swing, 1, "BACKGROUND")
			self.Swing.FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
			self.Swing.FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))

			self.Swing.Text = SettingsDB.SetFontString(self.Swing, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			self.Swing.Text:SetPoint("CENTER", 0, SettingsDB.Scale(1))
			self.Swing.Text:SetTextColor(1, 1, 1)
		end

		-- Power spark
		if SettingsCF.unitframe.plugins_mp5 == true then
			self.Spark = self.Power:CreateTexture(nil, "OVERLAY")
			self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			self.Spark:SetVertexColor(1, 1, 1, 1)
			self.Spark:SetBlendMode("ADD")
			self.Spark:SetHeight(self.Power:GetHeight()*2.5)
			self.Spark:SetWidth(self.Power:GetHeight()*1)
			-- self.Spark.rtl = true -- Make the spark go from Right To Left instead
			-- self.Spark.manatick = true -- Show mana regen ticks outside FSR (like the energy ticker)
			-- self.Spark.highAlpha = 1 	-- What alpha setting to use for the FSR and energy spark
			-- self.Spark.lowAlpha = 0.25 -- What alpha setting to use for the mana regen ticker
		end
	end

	-- 连击点
	if unit == "target" then
		self.CPoints = {}
		self.CPoints.unit = PlayerFrame.unit
		for i = 1, 5 do
			self.CPoints[i] = CreateFrame("StatusBar", nil, self)
			self.CPoints[i]:SetHeight(SettingsDB.Scale(4))
			self.CPoints[i]:SetWidth(SettingsDB.Scale(4))
			self.CPoints[i]:SetStatusBarTexture(SettingsCF.media.blank)
			self.CPoints[i]:SetFrameLevel(self.Health:GetFrameLevel() + 1)

			self.CPoints[i].FrameBackdrop = CreateFrame("Frame", nil, self.CPoints[i])
			SettingsDB.CreateTemplate(self.CPoints[i].FrameBackdrop)
			self.CPoints[i].FrameBackdrop:SetFrameLevel(self.CPoints[i]:GetFrameLevel())
			self.CPoints[i].FrameBackdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
			self.CPoints[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))

			if i == 1 then
				self.CPoints[i]:SetPoint("TOPLEFT", self.Health, 0, 0)
				self.CPoints[i]:SetStatusBarColor(0.9, 0.1, 0.1)
			else
				self.CPoints[i]:SetPoint("LEFT", self.CPoints[i-1], "RIGHT", SettingsDB.Scale(1), 0)
			end
		end
		self.CPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
		self.CPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
		self.CPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
		self.CPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)
		self:RegisterEvent("UNIT_COMBO_POINTS", SettingsDB.UpdateCPoints)
	end

	-- 魔法效果: 宠物/目标的目标/焦点/焦点目标
	if unit == "pet" or unit == "targettarget" or unit == "focus" or unit == "focustarget" then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(SettingsDB.Scale(24))
		self.Debuffs:SetWidth(SettingsDB.Scale(109))
		self.Debuffs.size = SettingsDB.Scale(24)
		self.Debuffs.spacing = SettingsDB.Scale(3)
		self.Debuffs.num = 4
		self.Debuffs["growth-y"] = "DOWN"
		if unit == "pet" or unit == "focus" then
			self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-17))
			self.Debuffs.initialAnchor = "TOPRIGHT"
			self.Debuffs["growth-x"] = "LEFT"
		else
			self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(-17))
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-x"] = "RIGHT"
		end
		self.Debuffs.PostCreateIcon = SettingsDB.PostCreateAura
		self.Debuffs.PostUpdateIcon = SettingsDB.PostUpdateAura
	end

	-- 魔法效果: 玩家
	if unit == "player" then
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs:SetHeight(SettingsDB.Scale(25))
		self.Buffs:SetWidth(SettingsDB.Scale(25 * 18))
		self.Buffs.size = SettingsDB.Scale(25)
		self.Buffs.num = 36
		self.Buffs.spacing = SettingsDB.Scale(2)
		self.Buffs["spacing-x"] = SettingsDB.Scale(2)
		self.Buffs["spacing-y"] = SettingsDB.Scale(2)
		self.Buffs:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", SettingsDB.Scale(-128), SettingsDB.Scale(-14))
		self.Buffs.initialAnchor = "TOPRIGHT"
		self.Buffs["growth-x"] = "LEFT"
		self.Buffs["growth-y"] = "DOWN"
		self.Buffs.filter = true

		self.Buffs.PostCreateIcon = SettingsDB.PostCreateAura
		self.Buffs.PostUpdateIcon = SettingsDB.PostUpdateAura

		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(SettingsDB.Scale(214))
		self.Debuffs:SetWidth(SettingsDB.Scale(214))
		self.Debuffs.size = SettingsDB.Scale(25)
		self.Debuffs.spacing = SettingsDB.Scale(2)
		self.Debuffs.initialAnchor = "BOTTOMRIGHT"
		self.Debuffs["growth-y"] = "UP"
		self.Debuffs["growth-x"] = "LEFT"
		if SettingsDB.class == "DEATHKNIGHT" or SettingsDB.class == "SHAMAN" then
			self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(8))
		else
			self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(3))
		end

		self.Debuffs.PostCreateIcon = SettingsDB.PostCreateAura
		self.Debuffs.PostUpdateIcon = SettingsDB.PostUpdateAura

		self.Enchant = CreateFrame("Frame", nil, self)
		self.Enchant:SetHeight(SettingsDB.Scale(25))
		self.Enchant:SetWidth(SettingsDB.Scale(53))
		self.Enchant:SetPoint("TOPRIGHT", self, "TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(1))
		self.Enchant.size =  SettingsDB.Scale(25)
		self.Enchant.spacing =  SettingsDB.Scale(2)
		self.Enchant.initialAnchor = "TOPRIGHT"
		self.Enchant["growth-x"] = "LEFT"
		self.PostCreateEnchantIcon = SettingsDB.PostCreateAura
		self.PostUpdateEnchantIcons = SettingsDB.CreateEnchantTimer
	end

	-- 魔法效果: 目标
	if unit == "target" then
		self.Auras = CreateFrame("Frame", nil, self)
		self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(3))
		self.Auras.initialAnchor = "BOTTOMLEFT"
		self.Auras["growth-x"] = "RIGHT"
		self.Auras["growth-y"] = "UP"
		self.Auras.numDebuffs = 16
		self.Auras.numBuffs = 32
		self.Auras:SetHeight(SettingsDB.Scale(214))
		self.Auras:SetWidth(SettingsDB.Scale(214))
		self.Auras.spacing = SettingsDB.Scale(2)
		self.Auras.size = SettingsDB.Scale(25)
		self.Auras.gap = true
		self.Auras.onlyShowPlayer = SettingsCF.aura.player_aura_only
		self.Auras.PostCreateIcon = SettingsDB.PostCreateAura
		self.Auras.PostUpdateIcon = SettingsDB.PostUpdateAura
	end

	-- 施法条
	if unit ~= "arenatarget" then
		self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
		self.Castbar:SetStatusBarTexture(SettingsCF.media.bar, "OVERLAY")

		self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
		self.Castbar.bg:SetAllPoints()
		self.Castbar.bg:SetTexture(SettingsCF.media.blank)

--[[
		self.Castbar.Overlay = CreateFrame("Frame", nil, self.Castbar)
		SettingsDB.CreateTemplate(self.Castbar.Overlay)
		self.Castbar.Overlay:SetFrameStrata("BACKGROUND")
		self.Castbar.Overlay:SetPoint("TOPLEFT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		self.Castbar.Overlay:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
]]
		self.Castbar.backdrop = SettingsDB.CreateShadowFrame(self.Castbar, 1, "BACKGROUND")
		self.Castbar.backdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
		self.Castbar.backdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))

		self.Castbar.OnUpdate = SettingsDB.OnCastbarUpdate
		self.Castbar.PostCastStart = SettingsDB.PostCastStart
		self.Castbar.PostChannelStart = SettingsDB.PostCastStart

		if unit == "player" then
			if SettingsCF.unitframe.castbar_icon == true then
				self.Castbar:SetPoint(pos.player_castbar[1], pos.player_castbar[2], pos.player_castbar[3], pos.player_castbar[4] + 20, pos.player_castbar[5])
				self.Castbar:SetWidth(SettingsDB.Scale(260))
			else
				self.Castbar:SetPoint(pos.player_castbar[1], pos.player_castbar[2], pos.player_castbar[3], pos.player_castbar[4], pos.player_castbar[5])
				self.Castbar:SetWidth(SettingsDB.Scale(280))
			end
			self.Castbar:SetHeight(SettingsDB.Scale(16))
		elseif unit == "target" then
			self.Castbar:SetPoint(pos.target_castbar[1], pos.target_castbar[2], pos.target_castbar[3], pos.target_castbar[4], pos.target_castbar[5])
			if SettingsCF.unitframe.castbar_icon == true then
				self.Castbar:SetWidth(SettingsDB.Scale(260))
			else
				self.Castbar:SetWidth(SettingsDB.Scale(280))
			end
			self.Castbar:SetHeight(SettingsDB.Scale(16))
		elseif unit == "arena" or unit == "boss" then
			self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, SettingsDB.Scale(-4))
			self.Castbar:SetWidth(SettingsDB.Scale(150))
			self.Castbar:SetHeight(SettingsDB.Scale(16))
		else
			self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, SettingsDB.Scale(-4))
			self.Castbar:SetWidth(SettingsDB.Scale(104))
			self.Castbar:SetHeight(SettingsDB.Scale(4))
		end

		if unit == "focus" then
			self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
			self.Castbar.Button:SetHeight(SettingsDB.Scale(65))
			self.Castbar.Button:SetWidth(SettingsDB.Scale(65))
			self.Castbar.Button:SetPoint(unpack(pos.focus_castbar))

			self.Castbar.Button.backdrop = SettingsDB.CreateShadowFrame(self.Castbar.Button, 1, "BACKGROUND")
			self.Castbar.Button.backdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
			self.Castbar.Button.backdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))

			self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
			self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 0, 0)
			self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, 0, 0)
			self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			self.Castbar.Time = SettingsDB.SetFontString(self.Castbar, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size * 2, SettingsCF.media.pixel_font_style)
			self.Castbar.Time:SetParent(self.Castbar.Button)
			self.Castbar.Time:SetPoint("CENTER", self.Castbar.Icon, "CENTER", 0, SettingsDB.Scale(1))
			self.Castbar.Time:SetTextColor(1, 1, 1)

			self.Castbar.Text = SettingsDB.SetFontString(self.Castbar, SettingsCF.media.font, SettingsCF.media.font_size, SettingsCF.media.font_style)
			self.Castbar.Text:SetPoint("TOP", self.Castbar.Icon, "BOTTOM", 0, SettingsDB.Scale(-5))
			self.Castbar.Text:SetTextColor(1, 1, 1)
		end

		if unit == "player" or unit == "target" or unit == "arena" or unit == "boss" then
			self.Castbar.Time = SettingsDB.SetFontString(self.Health, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			self.Castbar.Time:SetPoint("RIGHT", self.Castbar, "RIGHT", 0, SettingsDB.Scale(1))
			self.Castbar.Time:SetTextColor(1, 1, 1)
			self.Castbar.Time:SetJustifyH("RIGHT")

			self.Castbar.Text = SettingsDB.SetFontString(self.Health, SettingsCF.media.font, SettingsCF.unitframe.font_size, SettingsCF.media.font_style)
			self.Castbar.Text:SetPoint("LEFT", self.Castbar, "LEFT", SettingsDB.Scale(2), SettingsDB.Scale(1))
			self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", SettingsDB.Scale(-1), 0)
			self.Castbar.Text:SetTextColor(1, 1, 1)
			self.Castbar.Text:SetJustifyH("LEFT")

			self.Castbar:HookScript("OnShow", function() self.Castbar.Text:Show(); self.Castbar.Time:Show() end)
			self.Castbar:HookScript("OnHide", function() self.Castbar.Text:Hide(); self.Castbar.Time:Hide() end)

			if SettingsCF.unitframe.castbar_icon == true and unit ~= "arena" then
				self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.Button:SetHeight(SettingsDB.Scale(16))
				self.Castbar.Button:SetWidth(SettingsDB.Scale(16))

				self.Castbar.Button.Background = SettingsDB.CreateShadowFrame(self.Castbar.Button, 1, "BACKGROUND")
				self.Castbar.Button.Background:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
				self.Castbar.Button.Background:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))

				self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 0, 0)
				self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, 0, 0)
				self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				self.Castbar.Button:SetPoint("RIGHT", self.Castbar, "LEFT", SettingsDB.Scale(-4), 0)
			end

			if unit == "arena" then
				self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.Button:SetHeight(SettingsDB.Scale(20))
				self.Castbar.Button:SetWidth(SettingsDB.Scale(20))
				self.Castbar.Button:SetPoint("TOPRIGHT", self.Castbar, "TOPLEFT", SettingsDB.Scale(-5), SettingsDB.Scale(2))

				self.Castbar.Button.Background = SettingsDB.CreateShadowFrame(self.Castbar.Button, 1, "BACKGROUND")
				self.Castbar.Button.Background:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
				self.Castbar.Button.Background:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))

				self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, 0, 0)
				self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, 0, 0)
				self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end

			if unit == "player" then
				self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
				self.Castbar.SafeZone:SetTexture(SettingsCF.media.blank)
				self.Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27, 0.5)

				if SettingsCF.unitframe.castbar_latency == true then
					self.Castbar.Latency = self.Castbar:CreateFontString(nil, "OVERLAY")
					self.Castbar.Latency:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
					self.Castbar.Latency:SetTextColor(1, 1, 1)
					self.Castbar.Latency:SetPoint("RIGHT", self.Castbar, "BOTTOMRIGHT", 0, SettingsDB.Scale(1))
					self.Castbar.Latency:SetJustifyH("RIGHT")
				end

				self:RegisterEvent("UNIT_SPELLCAST_SENT", function(self, event, caster)
					if (caster == "player" or caster == "vehicle") then
						self.Castbar.castSent = GetTime()
					end
				end)
			end
		end
	end

	-- 宠物快乐度文字
	if unit == "pet" then
		self.PetHappiness = SettingsDB.SetFontString(self.Health, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
		self.PetHappiness:SetJustifyH("RIGHT")
		self.PetHappiness:SetPoint("LEFT", self.Name, "RIGHT", SettingsDB.Scale(2), SettingsDB.Scale(1))
		self.PetHappiness.frequentUpdates = true
		self:Tag(self.PetHappiness, "[getnamecolor][happiness]")
	end

	-- 3D头像
	if unit == "player" or unit == "target" then
		if SettingsCF.unitframe.portrait_enable == true then
			self.Portrait = CreateFrame("PlayerModel", nil, self)
			self.Portrait:SetFrameLevel(self.Health:GetFrameLevel())
			self.Portrait:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 0, 0)
			self.Portrait:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
			self.Portrait:SetAlpha(SettingsCF.unitframe.portrait_alpha)

			if unit == "target" then
				self.Portrait.PostUpdate = SettingsDB.PortraitPostUpdate
			end
		end
	end

	-- 竞技场饰品和魔法监视
	if SettingsCF.unitframe.show_arena and unit == "arena" then
		self.Trinket = CreateFrame("Frame", nil, self)
		self.Trinket:SetHeight(SettingsDB.Scale(31))
		self.Trinket:SetWidth(SettingsDB.Scale(31))
		if SettingsCF.unitframe.arena_on_right == true then
			self.Trinket:SetPoint("TOPRIGHT", self, "TOPLEFT", SettingsDB.Scale(-5), SettingsDB.Scale(2))
		else
			self.Trinket:SetPoint("TOPLEFT", self, "TOPRIGHT", SettingsDB.Scale(5), SettingsDB.Scale(2))
		end
		self.Trinket.bg = SettingsDB.CreateTemplate(self.Trinket)
		self.Trinket.trinketUseAnnounce = true

		self.AuraTracker = CreateFrame("Frame", nil, self)
		self.AuraTracker:SetWidth(self.Trinket:GetWidth())
		self.AuraTracker:SetHeight(self.Trinket:GetHeight())
		self.AuraTracker:SetPoint("CENTER", self.Trinket, "CENTER")
		self.AuraTracker:SetFrameStrata("HIGH")

		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, "ARTWORK")
		self.AuraTracker.icon:SetWidth(self.Trinket:GetWidth())
		self.AuraTracker.icon:SetHeight(self.Trinket:GetHeight())
		self.AuraTracker.icon:SetPoint("TOPLEFT", self.Trinket, SettingsDB.Scale(1), SettingsDB.Scale(-1))
		self.AuraTracker.icon:SetPoint("BOTTOMRIGHT", self.Trinket, SettingsDB.Scale(-1), SettingsDB.Scale(1))
		self.AuraTracker.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		self.AuraTracker.text = self.AuraTracker:CreateFontString(nil, "OVERLAY")
		self.AuraTracker.text:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size * 2, SettingsCF.media.pixel_font_style)
		self.AuraTracker.text:SetPoint("CENTER", self.AuraTracker, 0, 0)
		self.AuraTracker:SetScript("OnUpdate", SettingsDB.AuraTrackerTime)
	end

	-- 预读治疗条/治疗文字
	if SettingsCF.unitframe.plugins_healcomm == true then
		if SettingsCF.unitframe.plugins_healcomm_bar == true then
			self.HealCommBar = CreateFrame("StatusBar", nil, self.Health)
			self.HealCommBar:SetHeight(0)
			self.HealCommBar:SetWidth(0)
			self.HealCommBar:SetStatusBarTexture(self.Health:GetStatusBarTexture():GetTexture())
			self.HealCommBar:SetStatusBarColor(0, 1, 0, 0.35)
			self.HealCommBar:SetPoint("LEFT", self.Health, "LEFT")
		end
		if SettingsCF.unitframe.plugins_healcomm_text == true then
			self.HealCommText = self.Health:CreateFontString(self.Health, "OVERLAY")
			self.HealCommText:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			self.HealCommText:SetTextColor(0, 1, 0)
			self.HealCommText:SetPoint("CENTER", self.Health, 0, SettingsDB.Scale(1))
			self.HealCommTextFormat = SettingsDB.ShortValue
		end	
		self.allowHealCommOverflow = SettingsCF.unitframe.plugins_healcomm_over
		self.HealCommOthersOnly = SettingsCF.unitframe.plugins_healcomm_others
	end

	if SettingsDB.class == "HUNTER" then
		self:SetAttribute("type3", "spell")
		self:SetAttribute("spell3", GetSpellInfo(34477))
	elseif SettingsDB.class == "DRUID" then
		self:SetAttribute("type3", "spell")
		self:SetAttribute("spell3", GetSpellInfo(29166))
	elseif SettingsDB.class == "PALADIN" then
		self:SetAttribute("type3", "spell")
		self:SetAttribute("spell3", GetSpellInfo(31789))
	end

	-- 单位宽度和高度
	if unit == "player" or unit == "target" then
		self:SetAttribute("initial-height", SettingsDB.Scale(27))
		self:SetAttribute("initial-width", SettingsDB.Scale(212))
	elseif unit == "arena" or unit == "boss" then
		self:SetAttribute("initial-height", SettingsDB.Scale(27))
		self:SetAttribute("initial-width", SettingsDB.Scale(150))
	elseif unit == "arenatarget" then
		self:SetAttribute("initial-height", SettingsDB.Scale(27))
		self:SetAttribute("initial-width", SettingsDB.Scale(30))
	else
		self:SetAttribute("initial-height", SettingsDB.Scale(16))
		self:SetAttribute("initial-width", SettingsDB.Scale(104))
	end

	-- 仇恨边框
	if unit ~= "arenatarget" then
		table.insert(self.__elements, SettingsDB.UpdateThreat)
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", SettingsDB.UpdateThreat)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", SettingsDB.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", SettingsDB.UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", SettingsDB.UpdateThreat)
	end

	-- 团队标记
	self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetParent(self.Health)
	self.RaidIcon:SetWidth((unit == "player" or unit == "target") and SettingsDB.Scale(15) or SettingsDB.Scale(12))
	self.RaidIcon:SetHeight((unit == "player" or unit == "target") and SettingsDB.Scale(15) or SettingsDB.Scale(12))
	self.RaidIcon:SetPoint("TOP", 0, 0)

	-- 减益高亮
	if unit ~= "arenatarget" then
		self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlight:SetAllPoints(self.Health)
		self.DebuffHighlight:SetTexture(SettingsCF.media.highlight)
		self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight:SetBlendMode("ADD")
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightFilter = true
	end

	SettingsDB.HideAuraFrame(self)
	return self
end

------------------------------------------------------------------------
-- 头像位置
------------------------------------------------------------------------

oUF:RegisterStyle("meatGaGa", Shared)
oUF:SetActiveStyle("meatGaGa")
if SettingsCF.actionbar.rightbars_three == true then
	oUF:Spawn("player", "oUF_Player"):SetPoint(pos.player[1], pos.player[2], pos.player[3], pos.player[4], pos.player[5])
else
	oUF:Spawn("player", "oUF_Player"):SetPoint(pos.player[1], pos.player[2], pos.player[3], pos.player[4], pos.player[5] + 28)
end
if SettingsCF.actionbar.rightbars_three == true then
	oUF:Spawn("target", "oUF_Target"):SetPoint(pos.target[1], pos.target[2], pos.target[3], pos.target[4], pos.target[5])
else
	oUF:Spawn("target", "oUF_Target"):SetPoint(pos.target[1], pos.target[2], pos.target[3], pos.target[4], pos.target[5] + 28)
end
oUF:Spawn("pet", "oUF_Pet"):SetPoint(unpack(SettingsCF.position.unitframes.pet))
oUF:Spawn("focus", "oUF_Focus"):SetPoint(unpack(SettingsCF.position.unitframes.focus))
oUF:Spawn("focustarget", "oUF_FocusTarget"):SetPoint(unpack(SettingsCF.position.unitframes.focus_target))
oUF:Spawn("targettarget", "oUF_TargetTarget"):SetPoint(unpack(SettingsCF.position.unitframes.target_target))

if SettingsCF.unitframe.show_arena and not IsAddOnLoaded("Gladius") then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			if SettingsCF.unitframe.arena_on_right == true then
				arena[i]:SetPoint(pos.arena[1], pos.arena[2], pos.arena[3], pos.arena[4], pos.arena[5])
			else
				arena[i]:SetPoint("BOTTOMLEFT", pos.arena[2], "LEFT", pos.arena[4] + 75, pos.arena[5])
			end
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, SettingsDB.Scale(30))
		end
	end

	for i, v in ipairs(arena) do v:Show() end

	local arenatarget = {}
	for i = 1, 5 do
		arenatarget[i] = oUF:Spawn("arena"..i.."target", "oUF_Arena"..i.."Target")
		if i == 1 then
			if SettingsCF.unitframe.arena_on_right == true then
				arenatarget[i]:SetPoint("TOPRIGHT", arena[i], "TOPLEFT", SettingsDB.Scale(-41), 0)
			else
				arenatarget[i]:SetPoint("TOPRIGHT", arena[i], "TOPLEFT", SettingsDB.Scale(-7), 0)
			end
		else
			arenatarget[i]:SetPoint("BOTTOM", arenatarget[i-1], "TOP", 0, SettingsDB.Scale(30))
		end
	end

	for i, v in ipairs(arenatarget) do v:Show() end
end

------------------------------------------------------------------------
--	测试用
------------------------------------------------------------------------
local testui = TestUI or function() end
TestUI = function()
	testui()
	UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return "penancelol", "Rank 2", "Interface\\Icons\\Spell_Holy_Penance", random(5), "Magic", 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if(v.UNIT_AURA) then
				v:UNIT_AURA("UNIT_AURA", v.unit)
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"
