------------------------------------------------------------------------
--	Fonction (don't edit this if you don't know what you are doing!)
------------------------------------------------------------------------
if not SettingsCF.unitframe.enable == true then return end

local function SetUpAnimGroup(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

local function Flash(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local function StopFlash(self)
	if self.anim then
		self.anim:Finish()
	end
end

function SettingsDB.SpawnMenu(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

function SettingsDB.PostUpdateHealth(health, unit, min, max)
	if (unit and unit:find("arena%dtarget")) then return end
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		if min ~= max then
			local r, g, b
--			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			r, g, b = oUF.ColorGradient(min/max, unpack(oUF.colors.smooth))
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				if SettingsCF.unitframe.show_total_value == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", SettingsDB.ShortValue(min), SettingsDB.ShortValue(max))
				else
					health.value:SetFormattedText("|cffffffff%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			elseif unit == "target" then
				if SettingsCF.unitframe.show_total_value == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", SettingsDB.ShortValue(min), SettingsDB.ShortValue(max))
				else
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffffffff%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), SettingsDB.ShortValue(min))
				end
			else
				health.value:SetFormattedText("|cffffffff%d%%|r", floor(min / max * 100))
			end
		else
			if unit == "player" and unit ~= "pet" then
				health.value:SetText("|cffffffff"..max.."|r")
			else
				health.value:SetText("|cffffffff"..SettingsDB.ShortValue(max).."|r")
			end
		end
	end
end

function SettingsDB.PostUpdateRaidHealth(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		if min ~= max then
			local r, g, b
--			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			r, g, b = oUF.ColorGradient(min/max, unpack(oUF.colors.smooth))
			if SettingsCF.unitframe.deficit_health == true then
				health.value:SetText("|cffFFFFFF".."-"..SettingsDB.ShortValue(max-min))
			else
				health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
			end
		else
				health.value:SetText("|cffffffff"..SettingsDB.ShortValue(max).."|r")
		end
		if SettingsCF.unitframe.alpha_health == true then
			if(min / max > 0.95) then 
				health:SetAlpha(0.6)
				--self.Power:SetAlpha(0.6)
				--self.FrameBackdrop:SetAlpha(0.6)
			else
				health:SetAlpha(1)
				--self.Power:SetAlpha(1)
				--self.FrameBackdrop:SetAlpha(1)
			end
		end
	end
end

function SettingsDB.PostUpdatePower(power, unit, min, max)
	if (unit and unit:find("arena%dtarget")) then return end
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = SettingsDB.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if unit == "focus" or unit == "focustarget" or unit == "targettarget" then return end

	if not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if SettingsCF.unitframe.show_total_value == true then
						power.value:SetFormattedText("|cffffffff%s|r |cffD7BEA5|||r |cffffffff%s|r", SettingsDB.ShortValue(min), SettingsDB.ShortValue(max))
					else
						power.value:SetFormattedText("|cffffffff%s|r |cffD7BEA5-|r |cffffffff%d%%|r", SettingsDB.ShortValue(min), floor(min / max * 100))
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if SettingsCF.unitframe.show_total_value == true then
						power.value:SetFormattedText("|cffffffff%s|r |cffD7BEA5|||r |cffffffff%s|r", SettingsDB.ShortValue(min), SettingsDB.ShortValue(max))
					else
						power.value:SetFormattedText("|cffffffff%d%%|r", floor(min / max * 100))
					end
				elseif (unit and unit:find("arena%d")) then
					power.value:SetText(SettingsDB.ShortValue(min))
				else
					if SettingsCF.unitframe.show_total_value == true then
						power.value:SetFormattedText("|cffffffff%s|r |cffD7BEA5|||r |cffffffff%s|r", SettingsDB.ShortValue(min), SettingsDB.ShortValue(max))
					else
						power.value:SetFormattedText("|cffffffff%s|r |cffD7BEA5-|r |cffffffff%d%%|r",  min, floor(min / max * 100))
					end
				end
			else
				power.value:SetText("|cffffffff"..min.."|r")
			end
		else
			if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) then
				power.value:SetText("|cffffffff"..SettingsDB.ShortValue(min).."|r")
			else
				power.value:SetText("|cffffffff"..min.."|r")
			end
		end
	end
end

local delay = 0
function SettingsDB.UpdateManaLevel(self, elapsed)
	delay = delay + elapsed
	if self.parent.unit ~= "player" or delay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	delay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana <= 20 then
		self.ManaLevel:SetText("|cffaf5050"..L_UF_MANA.."|r")
		Flash(self, 0.3)
	else
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

function SettingsDB.UpdateDruidMana(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= 20 then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050".."Low Mana".."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
--[[			if self.Power.value:GetText() then
				self.DruidMana:SetPoint("RIGHT", -4, -5)
				self.Power.value:SetPoint("RIGHT",self.DruidMana, "LEFT", -1, 0)
				self.DruidMana:SetFormattedText("|cffD7BEA5 -|r %d%%|r", floor(min / max * 100))
			else
				self.DruidMana:SetPoint("RIGHT", -4, -5)
				self.Power.value:SetPoint("RIGHT",self.DruidMana, "LEFT", -1, 0)
				self.DruidMana:SetFormattedText("%d%%", floor(min / max * 100))
			end]]
			if self.Power.value:GetText() then
				self.DruidMana:SetPoint("RIGHT", self.Power.value, "LEFT", SettingsDB.Scale(-1), 0)
				self.DruidMana:SetFormattedText("%d%%|r |cffD7BEA5-|r", floor(min / max * 100))
				self.DruidMana:SetJustifyH("RIGHT")
			else
				self.DruidMana:SetPoint("LEFT", self.Power, "LEFT", SettingsDB.Scale(4), SettingsDB.Scale(1))
				self.DruidMana:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidMana:SetText()
		end

		self.DruidMana:SetAlpha(1)
	else
		self.DruidMana:SetAlpha(0)
	end
end

function SettingsDB.UpdateCPoints(self, event, unit)
	if unit == PlayerFrame.unit and unit ~= self.CPoints.unit then
		self.CPoints.unit = unit
	end
end

function SettingsDB.UpdateReputationColor(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
	bar.bg:SetVertexColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b, 0.25)
end

local ChannelingTicks = {
	-- warlock
	[GetSpellInfo(1120)] = 5,	-- 吸取灵魂
	[GetSpellInfo(689)] = 5,	-- 吸取生命
	[GetSpellInfo(5138)] = 5,	-- 吸取法力
	[GetSpellInfo(5740)] = 4,	-- 火焰之雨
	-- druid
	[GetSpellInfo(740)] = 4,	-- 宁静
	[GetSpellInfo(16914)] = 10,	-- 飓风
	-- priest
	[GetSpellInfo(15407)] = 3,	-- 精神鞭笞
	[GetSpellInfo(48045)] = 5,	-- 精神灼烧
	[GetSpellInfo(47540)] = 2,	-- 苦修
	-- mage
	[GetSpellInfo(5143)] = 5,	-- 奥术飞弹
	[GetSpellInfo(10)] = 5,		-- 暴风雪
	[GetSpellInfo(12051)] = 4,	-- 唤醒
	-- hunter
	[GetSpellInfo(1510)] = 6,	-- 乱射
}

local ticks = {}

local function SetBarTicks(CastBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = CastBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = CastBar:CreateTexture(nil, "OVERLAY")
				ticks[k]:SetTexture(SettingsCF.media.blank, "OVERLAY")
				ticks[k]:SetVertexColor(0, 0, 0, 0.25)
				ticks[k]:SetWidth(SettingsDB.Scale(1))
				ticks[k]:SetHeight(SettingsDB.Scale(16))
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", CastBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end

function SettingsDB.OnCastbarUpdate(Castbar, elapsed)
	if Castbar.casting or Castbar.channeling then
		local parent = Castbar:GetParent()
		local duration = Castbar.casting and Castbar.duration + elapsed or Castbar.duration - elapsed
		if (Castbar.casting and duration >= Castbar.max) or (Castbar.channeling and duration <= 0) then
			Castbar.casting = nil
			Castbar.channeling = nil
			return
		end
		if parent.unit == "player" or parent.unit == "target" or parent.unit == "arena" or parent.unit == "focus" then
			if Castbar.delay ~= 0 then
				Castbar.Time:SetFormattedText("%.1f |cffff0000%s %.1f|r", duration, Castbar.channeling and "- " or "+", Castbar.delay)
			else
				Castbar.Time:SetFormattedText("%.1f / %.1f", duration, Castbar.max)
			end
		end
		Castbar.duration = duration
		Castbar:SetValue(duration)
	end
end

function SettingsDB.PostCastStart(Castbar, unit, name, rank, text, castid)
	if unit == "vehicle" then unit = "player" end

	if unit == "player" then
		local latency = GetTime() - Castbar.castSent
		latency = latency > Castbar.max and Castbar.max or latency
		Castbar.Latency:SetFormattedText("%dms", latency * 1e3)
		Castbar.SafeZone:SetWidth(Castbar:GetWidth() * latency / Castbar.max)
		Castbar.SafeZone:ClearAllPoints()
		Castbar.SafeZone:SetPoint("TOPRIGHT")
		Castbar.SafeZone:SetPoint("BOTTOMRIGHT")

		if Castbar.channeling then
			local spell = UnitChannelInfo(unit)
			Castbar.ChannelingTicks = ChannelingTicks[spell] or 0
			SetBarTicks(Castbar, Castbar.ChannelingTicks)
		else
			SetBarTicks(Castbar, 0)
		end
	end

	local r, g, b, color
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		color = oUF.colors.class[class]
	else
		local reaction = UnitReaction(unit, "player");
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r;
			g = FACTION_BAR_COLORS[reaction].g;
			b = FACTION_BAR_COLORS[reaction].b;
		else
			r, g, b = 1, 1, 1
		end
	end

	if color then
		r, g, b = color[1], color[2], color[3]
	end

	if Castbar.interrupt and UnitCanAttack("player", unit) then
		Castbar:SetStatusBarColor(1, 0, 0)
		Castbar.bg:SetVertexColor(1, 0, 0, 0.25)
	else
		if unit == "pet" or unit == "vehicle" then
			local _, class = UnitClass("player")
			local r, g, b = unpack(oUF.colors.class[class])
			if SettingsCF.unitframe.own_color == true then
				Castbar:SetStatusBarColor(unpack(SettingsCF.media.uf_color))
				Castbar.bg:SetVertexColor(0.1, 0.1, 0.1)
			else
				if b then
					Castbar:SetStatusBarColor(r, g, b)
					Castbar.bg:SetVertexColor(r, g, b, 0.25)
				end
			end
		else
			if SettingsCF.unitframe.own_color == true then
				Castbar:SetStatusBarColor(unpack(SettingsCF.media.uf_color))
				Castbar.bg:SetVertexColor(0.1, 0.1, 0.1)
			else
				Castbar:SetStatusBarColor(r, g, b)
				Castbar.bg:SetVertexColor(r, g, b, 0.25)
			end
		end
	end
end

local function FormatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

--[[function HideBuffFrame()
	if PlayerDebuffs ~= true then return end
	-- hide buff
	BuffFrame:UnregisterEvent("UNIT_AURA")
	BuffFrame:Hide()
	TemporaryEnchantFrame:Hide()
	InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
	InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)
end
HideBuffFrame()]]

local function CreateAuraTimer(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(1, 0, 0)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

function SettingsDB.AuraTrackerTime(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture("")
			self.text:SetText("")
		end	
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

function SettingsDB.HideAuraFrame(self)
	if self.unit == "player" then
		if not SettingsCF.aura.player_auras then
			self.Buffs:Hide()
			self.Debuffs:Hide()
			self.Enchant:Hide()
			BuffFrame:Hide()
			TemporaryEnchantFrame:Hide()
		else
			BuffFrame:Hide()
			TemporaryEnchantFrame:Hide()
		end
		BuffFrame:UnregisterEvent("UNIT_AURA")
	elseif self.unit == "pet" and not SettingsCF.aura.pet_debuffs or self.unit == "focus" and not SettingsCF.aura.focus_debuffs 
	or self.unit == "focustarget" and not SettingsCF.aura.fot_debuffs or self.unit == "targettarget" and not SettingsCF.aura.tot_debuffs then
		self.Debuffs:Hide()
	elseif self.unit == "target" and not SettingsCF.aura.target_auras then
		self.Auras:Hide()
	end
end

local CancelAura = function(self, button)
	if button == "RightButton" and not self.debuff then
		CancelUnitBuff("player", self:GetID())
	end
end

function SettingsDB.PostCreateAura(element, button)
	SettingsDB.CreateTemplate(button)

	button.Background = SettingsDB.CreateShadowFrame(button, 1, "BACKGROUND")
	button.Background:SetPoint("TOPLEFT", SettingsDB.Scale(-2), SettingsDB.Scale(2))
	button.Background:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(2), SettingsDB.Scale(-2))

	button.remaining = SettingsDB.SetFontString(button, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	button.remaining:SetPoint("CENTER", button, "CENTER", SettingsDB.Scale(1), SettingsDB.Scale(1))
	button.remaining:SetTextColor(1, 1, 1)

	--button.showDebuffType = true		-- show debuff border type color 
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	--button.disableCooldown = true	-- hide CD spiral

	button.icon:SetPoint("TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	button.icon:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetDrawLayer("ARTWORK")

	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, SettingsDB.Scale(1))
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	button.count:SetTextColor(1, 1, 1)

	if SettingsCF.aura.show_spiral == true then
		element.disableCooldown = false
		button.cd:SetReverse()
		button.overlayFrame = CreateFrame("frame", nil, button, nil)
		button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
		button.cd:ClearAllPoints()
		button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
		button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
		button.overlay:SetParent(button.overlayFrame)
		button.count:SetParent(button.overlayFrame)
		button.remaining:SetParent(button.overlayFrame)
	else
		element.disableCooldown = true
	end

	if unit == "player" then
		button:SetScript("OnMouseUp", CancelAura)
	end
end

function SettingsDB.CreateEnchantTimer(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

function SettingsDB.PostUpdateAura(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
			icon.icon:SetDesaturated(true)
		else
			if SettingsCF.aura.debuff_color_type == true then
				local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
				icon:SetBackdropBorderColor(color.r, color.g, color.b)
				icon.icon:SetDesaturated(false)
			else
				icon:SetBackdropBorderColor(1, 0, 0)
			end
		end
	else
		icon:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	end
	
	if duration and duration > 0 and SettingsCF.aura.show_timer == true then
		icon.remaining:Show()
		icon.timeLeft = expirationTime
		icon:SetScript("OnUpdate", CreateAuraTimer)
	else
		icon.remaining:Hide()
		icon.timeLeft = math.huge
		icon:SetScript("OnUpdate", nil)
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

function SettingsDB.MLAnchorUpdate(self)
	if self.Leader:IsShown() then
		self.MasterLooter:SetPoint("TOPLEFT", SettingsDB.Scale(6), SettingsDB.Scale(6))
	else
		self.MasterLooter:SetPoint("TOPLEFT", SettingsDB.Scale(-6), SettingsDB.Scale(6))
	end
end

function SettingsDB.UpdatePetInfo(self,event)
	if self.Name then self.Name:UpdateTag(self.unit) end
end

function SettingsDB.PortraitPostUpdate(element, unit)
	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
		element:SetAlpha(0)
	else
		element:SetAlpha(SettingsCF.unitframe.portrait_alpha)
	end
end

function SettingsDB.UpdateThreat(self, event, unit)
	if self.unit ~= unit then return end
	local threat = UnitThreatSituation(self.unit)
--	if (threat == 3) then
	if threat and threat > 1 then
		r, g, b = GetThreatStatusColor(threat)
		if self.Panel then
			self.Panel:SetBackdropBorderColor(r, g, b, 1)
		else
			self.Name:SetTextColor(r, g, b)
		end
	else
		if self.Panel then
			self.Panel:SetBackdropBorderColor(0, 0, 0, 0.5)
		else
			self.Name:SetTextColor(1, 1, 1)
		end
	end 
end

function SettingsDB.updateAllElements(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

SettingsDB.CountOffsets = {
	TOPLEFT = {SettingsDB.Scale(6), 0},
	TOPRIGHT = {SettingsDB.Scale(-6), 0},
	BOTTOMLEFT = {SettingsDB.Scale(6), 0},
	BOTTOMRIGHT = {SettingsDB.Scale(-6), 0},
	LEFT = {SettingsDB.Scale(6), 0},
	RIGHT = {SettingsDB.Scale(-6), 0},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

function SettingsDB.CreateAuraWatchIcon(self, icon)
	SettingsDB.CreateTemplate(icon)
	icon.icon:SetPoint("TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	icon.icon:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	icon.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon.icon:SetDrawLayer("ARTWORK")
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	icon.overlay:SetTexture()
end

function SettingsDB.CreateAuraWatch(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, SettingsDB.Scale(-1), SettingsDB.Scale(1))
	auras:SetPoint("BOTTOMRIGHT", self.Health, SettingsDB.Scale(1), SettingsDB.Scale(-1))
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = SettingsDB.CreateAuraWatchIcon

	local buffs = {}

	if (SettingsDB.buffids["ALL"]) then
		for key, value in pairs(SettingsDB.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (SettingsDB.buffids[SettingsDB.class]) then
		for key, value in pairs(SettingsDB.buffids[SettingsDB.class]) do
			tinsert(buffs, value)
		end
	end

	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:SetWidth(SettingsDB.Scale(7))
			icon:SetHeight(SettingsDB.Scale(7))
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetPoint("TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
			tex:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
			tex:SetTexture(SettingsCF.media.blank)
			if (spell[3]) then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
			count:SetPoint("CENTER", unpack(SettingsDB.CountOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	self.AuraWatch = auras
end
