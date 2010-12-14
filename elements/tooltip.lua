----------------------------------------------------------------------------------------
-- 提示信息 (基于FreebTip by Freeb)
----------------------------------------------------------------------------------------
if not SettingsCF.tooltip.enable == true then return end

local classification = {
	worldboss = L_TOOLTIP_BOSS,
	rareelite = L_TOOLTIP_RAREELITE,
	elite = L_TOOLTIP_RARE,
	rare = L_TOOLTIP_ELITE,
}

local mtooltips = {
	WorldMapTooltip,
	DropDownList1MenuBackdrop,
	DropDownList2MenuBackdrop,
	DropDownList1Backdrop,
	DropDownList2Backdrop,
--	ConsolidatedBuffsTooltip,
--	LFDSearchStatus,
	TicketStatusFrameButton,
--	AutoCompleteBox,
	ChatMenu,
	EmoteMenu,
	LanguageMenu,
	VoiceMacroMenu,
}

for i, v in ipairs(mtooltips) do
	SettingsDB.CreateTemplate(v, 0.6)
	v:SetScript("OnShow", function(self)
		self:SetBackdropColor(0, 0, 0, 0.6)
		self:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
	end)
end
--LFDSearchStatus:SetFrameStrata("TOOLTIP")

local itooltips = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
}

for i, v in ipairs(itooltips) do
	SettingsDB.CreateTemplate(v, 0.6)
	v:SetScript("OnShow", function(self)
		self:SetBackdropColor(0, 0, 0, 0.6)
		local name, item = self:GetItem()
		if(item) then
			local quality = select(3, GetItemInfo(item))
			if(quality) then
				local r, g, b = GetItemQualityColor(quality)
				self:SetBackdropBorderColor(r, g, b)
			end
		else
			self:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		end
--		self:SetBackdropColor(0, 0, 0, 0.75)
	end)
end

local function GetHexColor(color)
	return ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
end

local ClassColors = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	ClassColors[class] = GetHexColor(RAID_CLASS_COLORS[class])
end

local Reaction = {}
for i = 1, #FACTION_BAR_COLORS do
	Reaction[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

local function getTargetLine(unit)
	if UnitIsUnit(unit, "player") then
		return ("|cffff0000%s|r"):format(L_TOOLTIP_TARGET_YOU)
	elseif UnitIsPlayer(unit, "player")then
		return ClassColors[select(2, UnitClass(unit, "player"))]..UnitName(unit).."|r"
	elseif UnitReaction(unit, "player") then
		return ("%s%s|r"):format(Reaction[UnitReaction(unit, "player")], UnitName(unit))
	else
		return ("|cffffffff%s|r"):format(UnitName(unit))
	end
end

function GameTooltip_UnitColor(unit)
	local r, g, b
	local reaction = UnitReaction(unit, "player")
	if reaction then
		r = FACTION_BAR_COLORS[reaction].r
		g = FACTION_BAR_COLORS[reaction].g
		b = FACTION_BAR_COLORS[reaction].b
	else
		r = 1.0
		g = 1.0
		b = 1.0
	end
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if not UnitCanAttack("player", unit) then
				r = 1.0
				g = 1.0
				b = 1.0
			else
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local unit = select(2, self:GetUnit())
	if unit then
		local level = UnitLevel(unit)
		local color = GetQuestDifficultyColor(level)
		local textLevel = ("%s%d|r"):format(GetHexColor(color), level)
		local unitPvP = ""
		local pattern = "%s"
		if level == "??" or level == -1 then
			textLevel = "|cffff0000??|r"
		end

		if UnitIsPlayer(unit) then
			local unitRace = UnitRace(unit)
			local unitClass = UnitClass(unit)

			if UnitIsAFK(unit) then
				self:AppendText((" |cff00cc00%s|r"):format(CHAT_FLAG_AFK))
			elseif UnitIsDND(unit) then
				self:AppendText((" |cff00cc00%s|r"):format(CHAT_FLAG_DND))
			end

		for i = 2, GameTooltip:NumLines() do
			if _G["GameTooltipTextLeft"..i]:GetText():find(LEVEL) then
				pattern = pattern.." %s %s %s"
				_G["GameTooltipTextLeft"..i]:SetText((pattern):format(unitPvP, textLevel, unitRace, unitClass):trim())
				break
			end
		end

		if GetGuildInfo(unit) then
			if SettingsCF.tooltip.rank == true then
				local guildName, guildRank = GetGuildInfo(unit)
				_G["GameTooltipTextLeft2"]:SetFormattedText("%s (%s)", guildName, guildRank)
			else
				_G["GameTooltipTextLeft2"]:SetFormattedText("%s", GetGuildInfo(unit))
			end
			_G["GameTooltipTextLeft2"]:SetTextColor(0, 1, 1)
		end
	else
--			local text = GameTooltipTextLeft2:GetText()
--			local reaction = UnitReaction(unit, "player")
--			if reaction and text and not text:find(LEVEL) then
--				GameTooltipTextLeft2:SetTextColor(FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b)
--			end
		if level ~= 0 then
			local class = UnitClassification(unit)
			if class == "worldboss" then
				textLevel = ("|cffff0000%s|r"):format(classification[class])
			elseif class == "rareelite" or class == "elite" or class == "rare" then
				if level == -1 then
					textLevel = ("|cffff0000??|r %s"):format(classification[class])
				else
					textLevel = ("%s%d|r %s"):format(GetHexColor(color), level, classification[class])
				end
			end

			local creatureType = UnitCreatureType(unit)
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find(LEVEL) then
					pattern = pattern.." %s %s"
					_G["GameTooltipTextLeft"..i]:SetText((pattern):format(unitPvP, textLevel, creatureType or ""):trim())
					break
				end
			end
		end
	end

		if UnitIsPVP(unit) then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
		end

		if SettingsCF.tooltip.target == true and UnitExists(unit.."target") then
			local r, g, b = GameTooltip_UnitColor(unit.."target")
			local text = ""

			if UnitIsEnemy("player", unit.."target") then
				r, g, b = 1, 0, 0
			elseif not UnitIsFriend("player", unit.."target") then
				r, g, b = 1, 1, 0
			end

			if UnitName(unit.."target") == UnitName("player") then
				text = "|cfffed100"..STATUS_TEXT_TARGET..":|r ".."|cffff0000> "..UNIT_YOU.." <|r"
			else
				text = "|cfffed100"..STATUS_TEXT_TARGET..":|r "..UnitName(unit.."target")
			end
			self:AddLine(text, r, g, b)
		end

		if SettingsCF.tooltip.health_color == true then
			local r, g, b = GameTooltip_UnitColor(unit)
			GameTooltipStatusBar:SetStatusBarColor(r, g, b)
		else
			GameTooltipStatusBar:SetStatusBarColor(0, 1, 0, 1)
		end

		if (UnitIsDead(unit) or UnitIsGhost(unit)) then
			GameTooltipStatusBar:Hide()
		else
			GameTooltipStatusBar:Show()
			GameTooltipStatusBar:ClearAllPoints()
			GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 1, 0)
			GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -1, 0)
		end
	end
end)

GameTooltipStatusBar:SetStatusBarTexture(SettingsCF.media.bar)
GameTooltipStatusBar:SetHeight(6)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetPoint("TOPLEFT", -1, 1)
bg:SetPoint("BOTTOMRIGHT", 1, -1)
bg:SetTexture(SettingsCF.media.bar)
bg:SetVertexColor(unpack(SettingsCF.media.backdrop_color))

if SettingsCF.tooltip.health_value == true then
	GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
		if not value then
			return
		end
		local min, max = self:GetMinMaxValues()
		if (value < min) or (value > max) then
			return
		end
		local unit  = select(2, GameTooltip:GetUnit())
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			if not self.text then
				self.text = self:CreateFontString(nil, "OVERLAY")
				self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 1)
				self.text:SetFont(SettingsCF.media.pixel_font, 8, "OUTLINEMONOCHROME")
			end
			self.text:Show()
			local hp = min.." / "..max
			self.text:SetText(hp)
		end
	end)
end

local function GameTooltipDefault(tooltip, parent)
	if SettingsCF.tooltip.cursor == true then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	else
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint(unpack(SettingsCF.position.tooltip))
		tooltip.default = 1
	end
end
hooksecurefunc("GameTooltip_SetDefaultAnchor", GameTooltipDefault)

if SettingsCF.tooltip.shift_modifer == true then
	local ShiftShow = function()
		if IsShiftKeyDown() then
			GameTooltip:Show()
			GameTooltip:SetBackdropColor(0, 0, 0, 0.8)
			GameTooltip:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		else
			GameTooltip:Hide()
		end
	end
	GameTooltip:SetScript("OnShow", ShiftShow)
	local EventShow = function()
		if arg1 == "LSHIFT" and arg2 == 1 then
			GameTooltip:Show()
			GameTooltip:SetBackdropColor(0, 0, 0, 0.8)
			GameTooltip:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		elseif arg1 == "LSHIFT" and arg2 == 0 then
			GameTooltip:Hide()
		end
	end
	local sh = CreateFrame("Frame")
	sh:RegisterEvent("MODIFIER_STATE_CHANGED")
	sh:SetScript("OnEvent", EventShow)
else
	if SettingsCF.tooltip.cursor == true then
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function (GameTooltip, parent)
		GameTooltip:SetOwner(parent,"ANCHOR_CURSOR")
		end)
	else
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self)
		self:SetPoint(unpack(SettingsCF.position.tooltip))
		end)
	end
end

if not SettingsCF.tooltip.title == true then
	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		local unitName, unit = self:GetUnit()
		if unit and UnitIsPlayer(unit) then
			local title = UnitPVPName(unit)
			if title then
				title = title:gsub(unitName, "")
				name = GameTooltipTextLeft1:GetText()
				name = name:gsub(title, "")
				if name then GameTooltipTextLeft1:SetText(name) end
			end
		end
	end)
end

----------------------------------------------------------------------------------------
-- ItemRefTooltip(tekKompare by Tekkub)
----------------------------------------------------------------------------------------
if not IsAddOnLoaded("tekKompare") then
	local orig1, orig2 = {}, {}
	local GameTooltip = GameTooltip
	local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

	local function OnHyperlinkEnter(frame, link, ...)
		local linktype = link:match("^([^:]+)")
		if linktype and linktypes[linktype] then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
		if orig1[frame] then return orig1[frame](frame, link, ...) end
	end

	local function OnHyperlinkLeave(frame, ...)
		GameTooltip:Hide()
		if orig2[frame] then return orig2[frame](frame, ...) end
	end

	local _G = getfenv(0)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		orig1[frame] = frame:GetScript("OnHyperlinkEnter")
		frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

		orig2[frame] = frame:GetScript("OnHyperlinkLeave")
		frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
	end
end

----------------------------------------------------------------------------------------
-- Talent from TipTacTalents
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.talents == true then
	local _G = getfenv(0)
	local gtt = GameTooltip
	local GetTalentTabInfo = GetTalentTabInfo

	-- Locals
	local ttt = CreateFrame("Frame","TipTacTalents")
	local cache = {}
	local current = {}
	local CACHE_SIZE = 25		-- Change cache size here (Default 25)

	-- Allow these to be accessed through other addons
	ttt.cache = cache
	ttt.current = current

	local function GetTalent(isInspect, group)
		-- Get points per tree, and set "maxTree" to the tree with most points
		local maxTree, temp = 1, {}
		for i = 1, 3 do
			_, _, temp[i] = GetTalentTabInfo(i,isInspect,nil,group)
			if (temp[i] > temp[maxTree]) then
				maxTree = i
			end
		end
		temp.tree = GetTalentTabInfo(maxTree,isInspect,nil,group)
		-- Customise output. Use TipTac setting if it exists, otherwise just use formatting style one.
		temp.text = temp.tree.." ("..temp[1].."/"..temp[2].."/"..temp[3]..")"

		return temp
	end

	-- GatherTalents
	local function GatherTalents(isInspect)
		-- Inspect functions will always use the active spec when not inspecting
		local group = GetActiveTalentGroup(isInspect)

		current[1] = GetTalent(isInspect, group)
		current[2] = GetTalent(isInspect, 3 - group)

		-- Set the tips line output, for inspect, only update if the tip is still showing a unit!
		if (not isInspect) then
			gtt:AddLine(L_TOOLTIP_ACT_TALENT .. current[1].text)
			gtt:AddLine(L_TOOLTIP_INACT_TALENT .. current[2].text)
		elseif (gtt:GetUnit()) then
			for i = 2, gtt:NumLines() do
				if ((_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^" .. L_TOOLTIP_ACT_TALENT)) then
					_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s", L_TOOLTIP_ACT_TALENT, current[1].text)
					gtt:AddLine(format("%s%s", L_TOOLTIP_INACT_TALENT, current[2].text))
					-- Do not call Show() if the tip is fading out, this only works with TipTac, if TipTacTalents are used alone, it might still bug the fadeout
					if (not gtt.fadeOut) then
						gtt:Show()
					end
					break
				end
			end
		end
		-- Organise Cache
		for i = #cache, 1, -1 do
			if (current.name == cache[i].name) then
				tremove(cache,i)
				break
			end
		end
		if (#cache > CACHE_SIZE) then
			tremove(cache,1)
		end
		-- Cache the new entry
		if (CACHE_SIZE > 0) then
			cache[#cache + 1] = CopyTable(current)
		end
	end

	-- OnEvent
	ttt:SetScript("OnEvent",function(self,event)
		self:UnregisterEvent("INSPECT_TALENT_READY")
		if (gtt:GetUnit() == current.name) then
			GatherTalents(1)
		end
	end)

	-- HOOK: OnTooltipSetUnit
	gtt:HookScript("OnTooltipSetUnit",function(self,...)
		if (TipTac_Config) and (TipTac_Config.showTalents == false) then
			return
		end
		-- Get the unit -- Check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
		local _, unit = self:GetUnit()
		if (not unit) then
			local mFocus = GetMouseFocus()
			if (mFocus) and (mFocus.unit) then
				unit = mFocus.unit
			end
		end
		-- Only for players over level 9 -- Ignore PvP flagged people, unless they are friendly
		if (UnitIsPlayer(unit)) and (UnitLevel(unit) > 9 or UnitLevel(unit) == -1) and (CanInspect(unit)) then
			wipe(current)
			current.name = UnitName(unit)
			-- Player
			if (UnitIsUnit(unit,"player")) then
				GatherTalents()
			-- Others
			else
				local allowInspect = (not InspectFrame or not InspectFrame:IsShown()) and (not Examiner or not Examiner:IsShown())
				if (allowInspect) then
					ttt:RegisterEvent("INSPECT_TALENT_READY")
					NotifyInspect(unit)
				end
				for _, entry in ipairs(cache) do
				if (current.name == entry.name) then
						self:AddLine(L_TOOLTIP_ACT_TALENT .. entry[1].text)
						self:AddLine(L_TOOLTIP_INACT_TALENT .. entry[2].text)

						current[1] = entry[1]
						current[2] = entry[2]
						current.name = name
						return
					end
				end
				if (allowInspect) then
					self:AddLine(L_TOOLTIP_ACT_TALENT..L_TOOLTIP_LOADING)
				end
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Your achievement status in tooltip(Enhanced Achievements by Syzgyn)
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.achievements == true then
	local colors = {
		["GREEN"] = {
			["r"] = 0.25,
			["g"] = 0.75,
			["b"] = 0.25,
		},
		["GRAY"] = {
			["r"] = 0.5,
			["g"] = 0.5,
			["b"] = 0.5,
		},
	}

	local function hookSetHyperlink(tooltip, refString)
		local achievementID, numCriteria, GUID, name, completed, quantity, reqQuantity, month, day, year
		local output = {[0] = {}, [1] = {}}
		if select(3, string.find(refString, "(%a-):")) ~= "achievement" then return end

		achievementID = select(3, string.find(refString, ":(%d+):"))
		numCriteria = GetAchievementNumCriteria(achievementID)
		GUID = select(3, string.find(refString, ":%d+:(.-):"))

		if GUID == string.sub(UnitGUID("player"), 3) then
			tooltip:Show()
			return
		end

		tooltip:AddLine(" ")
		_,_,_,completed, month, day, year = GetAchievementInfo(achievementID)

		if completed then
			if year < 10 then year = "0" .. year end
		
			tooltip:AddLine(L_TOOLTIP_ACH_COMPLETE .. month .. "/" .. day .. "/" .. year, 0,1,0)
		elseif numCriteria == 0 then
			tooltip:AddLine(L_TOOLTIP_ACH_INCOMPLETE)
		else
			tooltip:AddLine(L_TOOLTIP_ACH_STATUS)
			for i=1, numCriteria, 2 do
				for a=0, 1 do
					output[a].text = nil
					output[a].color = nil
					if i+a <= numCriteria then
						name,_,completed,quantity,reqQuantity = GetAchievementCriteriaInfo(achievementID, i+a)
						if completed then
							output[a].text = name
							output[a].color = "GREEN"
						else
							if quantity < reqQuantity and reqQuantity > 1 then
								output[a].text = name .. " (" .. quantity .. "/" .. reqQuantity .. ")"
								output[a].color = "GRAY"
							else
								output[a].text = name
								output[a].color = "GRAY"
							end
						end
					else
						output[a].text = nil
					end
				end
				if output[1].text == nil then
					tooltip:AddLine(output[0].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b)
				else
					tooltip:AddDoubleLine(output[0].text, output[1].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b, colors[output[1].color].r, colors[output[1].color].g, colors[output[1].color].b)
				end
				output = {[0] = {}, [1] = {}}
			end
		end
		tooltip:Show()
	end

	hooksecurefunc(ItemRefTooltip, "SetHyperlink", hookSetHyperlink)
end

----------------------------------------------------------------------------------------
-- Adds item icons to tooltips()
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.icon == true then
	local function AddIcon(self, icon)
		if icon then
			local title = _G[self:GetName() .. "TextLeft1"]
			if title and not title:GetText():find("|T" .. icon) then
				title:SetFormattedText("|T%s:%d|t %s", icon, SettingsCF.tooltip.icon_size, title:GetText())
			end
		end
	end

	local function hookItem(tip)
		tip:HookScript("OnTooltipSetItem", function(self, ...)
			local name, link = self:GetItem()
			local icon = link and GetItemIcon(link)
			AddIcon(self, icon)
		end)
	end
	hookItem(_G["GameTooltip"])
	hookItem(_G["ItemRefTooltip"])

	local function hookSpell(tip)
		tip:HookScript("OnTooltipSetSpell", function(self, ...)
			local name, rank, icon = GetSpellInfo(self:GetSpell())
			AddIcon(self, icon)
		end)
	end
	hookSpell(_G["GameTooltip"])
	hookSpell(_G["ItemRefTooltip"])
end

----------------------------------------------------------------------------------------
-- 在战斗中隐藏动作条/宠物条/变形条的提示信息
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.hide_button == true then
	local CombatHideActionButtonsTooltip = function(self)
		if not IsShiftKeyDown() then
			self:Hide()
		end
	end

	hooksecurefunc(GameTooltip, "SetAction", CombatHideActionButtonsTooltip)
	hooksecurefunc(GameTooltip, "SetPetAction", CombatHideActionButtonsTooltip)
	hooksecurefunc(GameTooltip, "SetShapeshift", CombatHideActionButtonsTooltip)
end

----------------------------------------------------------------------------------------
-- 技能编号 (SpellID)
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.spellid == true then
	local TipTypeFuncs = {}

	function TipTypeFuncs.spell(tip, refString, id)
		local name, rank = GetSpellInfo(id)
		tip:AddLine("SpellID: "..id..(rank and rank ~= "" and ", "..rank or ""),0.2,0.6,1)
		tip:Show()
	end

	local function SetHyperlink_Hook(self,refString)
		local type, id = refString:match("|?H?(%a+):([^:]+)")
		if (type ~= "spell") then
			return
		else
			TipTypeFuncs[type](self,refString,id)
		end
	end

	hooksecurefunc(GameTooltip,"SetHyperlink",SetHyperlink_Hook)
	hooksecurefunc(ItemRefTooltip,"SetHyperlink",SetHyperlink_Hook)
end

----------------------------------------------------------------------------------------
-- 竞技场等级 (ArenaExp by Fernir)
----------------------------------------------------------------------------------------
if SettingsCF.tooltip.arena_experience == true then
	local isGTTActive = false
	local GTT = _G["GameTooltip"]
	-- settings start
	local needStatistic = {
		370, -- Highest 2 man personal rating
		595, -- Highest 3 man personal rating
		596, -- Highest 5 man personal rating
	}
	local needAchievements = {
		401,   -- 2000 arena rating in 2x2
		404,   -- 2000 arena rating in 5x5
		405,   -- 2000 arena rating in 3x3
		1161,  -- 2200 arena rating in 5x5
		1159,  -- 2200 arena rating in 2x2
		1160,  -- 2200 arena rating in 3x3
		2091,  -- gladiator
	}
	--settings end

	strGradient = function(val, low, high)
		local percent, r, g
		if (high > low) then
			percent = val/(high-low)
		else
			percent = 1-val/(low-high)
		end
		if (percent > 1) then percent = 1 end
		if (percent < 0) then percent = 0 end
		if (percent < 0.5) then
			r, g = 1, 2*percent
		else
			r, g = (1-percent)*2, 1
		end
		return format("|cff%02x%02x%02x%s|r", r*255, g*255, 0, val)
	end

	local skillf = CreateFrame("frame")
	skillf:RegisterEvent("ADDON_LOADED")
	skillf:SetScript("OnEvent",function(self,event,...)
		if event == "ADDON_LOADED" then
			if arg1 == ... then
				skillf:UnregisterEvent("ADDON_LOADED")
				GTT:HookScript("OnTooltipSetUnit", function()
					if InCombatLockdown() and InCombatLockdown() == 1 then return end
					if AchievementFrame and AchievementFrame:IsShown() then return end

					self.unit = select(2, GTT:GetUnit())
					if not UnitIsPlayer(self.unit) then return end

					if _G.GearScore then
						_G.GearScore:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
					end
					ClearAchievementComparisonUnit()
					skillf:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
					SetAchievementComparisonUnit(self.unit)
				end)
				GTT:HookScript("OnTooltipCleared", function()
					if skillf:IsEventRegistered("INSPECT_ACHIEVEMENT_READY") and skillf:IsEventRegistered("INSPECT_ACHIEVEMENT_READY") then
						skillf:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
					end
					isGTTActive = false
				end)
			end
		elseif event == "INSPECT_ACHIEVEMENT_READY" then
			if not GetComparisonAchievementPoints() then return end

			isGTTActive = false

			for indx, Achievement in pairs(needAchievements) do
				local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(Achievement)
				if GetAchievementComparisonInfo(Achievement) then
					GTT:AddLine(Name)
					GTT:AddTexture(Image)
					isGTTActive = true
				end
			end

			for indx, Achievement in pairs(needStatistic) do
				if GetComparisonStatistic(Achievement) ~= "--" then
					GTT:AddDoubleLine(select(2,GetAchievementInfo(Achievement)), strGradient(tonumber(GetComparisonStatistic(Achievement)), 0, 2200))
					isGTTActive = true
				end
			end

			if isGTTActive then GTT:Show() end

			if _G.GearScore then
				_G.GearScore:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			end

			skillf:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
			ClearAchievementComparisonUnit()
		end
	end)
end

----------------------------------------------------------------------------------------
-- 显示法术效果施放者 (Castby by yleaf)
----------------------------------------------------------------------------------------
local cc = {}
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
do
	for class, c in pairs(CUSTOM_CLASS_COLORS) do
		cc[class] = format("|cff%02x%02x%02x", c.r*255, c.g*255, c.b*255)
	end
end

local function SetCaster(self, unit, index, filter)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, filter)
	if unitCaster then
		local uname, urealm = UnitName(unitCaster)
		local _, uclass = UnitClass(unitCaster)
		if urealm then uname = uname.."-"..urealm end
		self:AddLine("\nCaster: " .. (cc[uclass] or "|cffffffff") .. uname .. "|r (" .. unitCaster .. ")")
		self:Show()
	end
end

hooksecurefunc(GameTooltip, "SetUnitAura", SetCaster)
--[[
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, unit, index, filter)
	filter = filter and ("HELPFUL "..filter) or "HELPFUL"
	SetCaster(self, unit, index, filter)
end)
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, unit, index, filter)
	filter = filter and ("HARMFUL "..filter) or "HARMFUL"
	SetCaster(self, unit, index, filter)
end)
]]