----------------------------------------------------------------------------------------
-- 信息条 (基于Tukui)
----------------------------------------------------------------------------------------
if SettingsCF.statpanel.enable ~= true then return end

----------------------------------------------------------------------------------------
-- 颜色渐变功能 (节选自LiteStats)
----------------------------------------------------------------------------------------
local function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1,g1,b1,r2,g2,b2 = select(seg*3+1,1,0,0,1,1,0,0,1,0,0,0,0) -- R -> Y -> G
	local r,g,b = r1+(r2-r1)*relperc,g1+(g2-g1)*relperc,b1+(b2-b1)*relperc
	return format("|cff%02x%02x%02x",r*255,g*255,b*255),r,g,b
end

----------------------------------------------------------------------------------------
-- 文字颜色
----------------------------------------------------------------------------------------
local function Hex(color)
	return format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
end

if SettingsCF.statpanel.classcolor == true then
	colortag = Hex(SettingsDB.color)
	else
	colortag = "|cff4DB2E6"
end

----------------------------------------------------------------------------------------
-- 信息条框体
----------------------------------------------------------------------------------------
local statpanel = CreateFrame("Frame", actionbar, UIParent)
statpanel:SetFrameLevel(2)
statpanel:SetFrameStrata("MEDIUM")
statpanel:SetHeight(10)
statpanel:SetWidth(GetScreenWidth())
statpanel:SetPoint("BOTTOM", 0, SettingsDB.Scale(2))

--------------------------------------------------------------------
-- 内存占用模块
--------------------------------------------------------------------
if SettingsCF.statpanel.memory == true then
	local MemStat = CreateFrame("Frame")
	MemStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 18, 0)
	Text:SetJustifyH("LEFT")

	local function formatMem(memory)
		local mult = 10^1
		if memory > 999 then
			local mem = floor((memory/1024) * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0"..colortag.."mb|r")
			else
				return mem..string.format(colortag.."mb|r")
			end
		else
			local mem = floor(memory * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0"..colortag.."kb|r")
			else
				return mem..string.format(colortag.."kb|r")
			end
		end
	end

	local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory
	local function RefreshMem(self)
		Memory = {}
		UpdateAddOnMemoryUsage()
		Total = 0
		for i = 1, GetNumAddOns() do
			Mem = GetAddOnMemoryUsage(i)
			Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
			Total = Total + Mem
		end

		MEMORY_TEXT = formatMem(Total)
		table.sort(Memory, function(a, b)
			if a and b then
				return a[2] > b[2]
			end
		end)

		-- Setup Memory tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			--if not InCombatLockdown() then
				GameTooltip:SetOwner(this, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(L_STAT_MEMORY,"--------------",0.75,0.9,1,0.5,0.5,0.5)
				for i = 1, #Memory do
					if Memory[i][3] then 
						local color = Memory[i][2] <= 102.4 and {0,1} -- 0 - 100
						or Memory[i][2] <= 512 and {0.75,1} -- 100 - 512
						or Memory[i][2] <= 1024 and {1,1} -- 512 - 1mb
						or Memory[i][2] <= 2560 and {1,0.75} -- 1mb - 2.5mb
						or Memory[i][2] <= 5120 and {1,0.5} -- 2.5mb - 5mb
						or {1,0.1} -- 5mb +
						GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2]), 1, 1, 1, color[1],color[2], 0)
					end
				end
				GameTooltip:Show()
			--end
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	local int, int2 = 5, 1
	local function Update(self, t)
		int = int - t
		int2 = int2 - t
		if int < 0 then
			RefreshMem(self)
			int = 5
		end
		if int2 < 0 then
			Text:SetText(MEMORY_TEXT)
			int2 = 1
		end
	end

	MemStat:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			HideUIPanel(GameMenuFrame)
			if not UIConfig or not UIConfig:IsShown() then
				CreateUIConfig()
			else
				UIConfig:Hide()
			end
		elseif button == "RightButton" then
			UpdateAddOnMemoryUsage()
			local oldcount = gcinfo()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			local count = gcinfo()
			print(format("|cff66C6FF%s|r %s", L_STAT_COLLECT, formatMem(oldcount - count)))
			Update(MemStat, 10)
		end
	end)
	MemStat:SetScript("OnUpdate", Update) 
	Update(MemStat, 10)
end

--------------------------------------------------------------------
-- FPS模块
--------------------------------------------------------------------
if SettingsCF.statpanel.fps == true then
	local FpsStat = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 66, 0)
	Text:SetJustifyH("LEFT")

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local fps, r = floor(GetFramerate()), 30
			Text:SetFormattedText("%s%d|r"..colortag.."fps|r", gradient(fps/r), fps)
			int = 1
		end
	end

	FpsStat:SetScript("OnUpdate", Update) 
	Update(FpsStat, 10)
end

--------------------------------------------------------------------
-- 网络延迟模块
--------------------------------------------------------------------
if SettingsCF.statpanel.latency == true then
	local LatencyStat = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 114, 0)
	Text:SetJustifyH("LEFT")

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local latency, r = select(3,GetNetStats()), 300
			Text:SetFormattedText("%s%d|r"..colortag.."ms|r", gradient(1-latency/r), latency)
			int = 1
		end
	end

	LatencyStat:SetScript("OnUpdate", Update) 
	Update(LatencyStat, 10)
end

--------------------------------------------------------------------
-- 装备耐久度模块
--------------------------------------------------------------------
if SettingsCF.statpanel.durability == true then
	local DurStat = CreateFrame("Frame")
	DurStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 162, 0)
	Text:SetJustifyH("LEFT")

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%d|cffffd700g|r %d|cffc7c7cfs|r %d|cffeda55fc|r", gold, silver, copper)
		return cash
	end

	local Total = 0
	local dcur, dmax
	local Slots = {
		[1] = {1, "Head", 1000},
		[2] = {3, "Shoulder", 1000},
		[3] = {5, "Chest", 1000},
		[4] = {6, "Waist", 1000},
		[5] = {9, "Wrist", 1000},
		[6] = {10, "Hands", 1000},
		[7] = {7, "Legs", 1000},
		[8] = {8, "Feet", 1000},
		[9] = {16, "Main Hand", 1000},
		[10] = {17, "Off Hand", 1000},
		[11] = {18, "Ranged", 1000}
	}

	function OnEvent(self)
		local tooltip = CreateFrame("GameTooltip")
		tooltip:Hide()
		local cost = 0
		for i = 1, 10 do
			local _,_,tempcost = tooltip:SetInventoryItem("player", Slots[i][1])
			cost = cost + tempcost
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				dcur, dmax = GetInventoryItemDurability(Slots[i][1])
				if dcur then 
					Slots[i][3] = dcur/dmax
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)

		local durability = floor(Slots[1][3]*100)
		if Total > 0 then
			Text:SetFormattedText("%s%d%%|r"..colortag.."D|r", gradient(durability/100), durability)
		else
			Text:SetText("|cff00ff00100%|r"..colortag.."D|r")
		end

		-- Setup Durability Tooltip
		DurStat:SetAllPoints(Text)
		DurStat:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				GameTooltip:SetOwner(this, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:AddDoubleLine(REPAIR_COST,FormatTooltipMoney(cost*0.8),1,1,1,1,1,1)
				GameTooltip:Show()
			end
		end)
		DurStat:SetScript("OnLeave", function() GameTooltip:Hide() end)
		Total = 0
		DurStat:SetAllPoints(Text)
	end

	DurStat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DurStat:RegisterEvent("PLAYER_ENTERING_WORLD")
	DurStat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	DurStat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- 背包空格模块
--------------------------------------------------------------------
if SettingsCF.statpanel.bag == true then
	local BagStat = CreateFrame("Frame")
	BagStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 210, 0)
	Text:SetJustifyH("LEFT")

	local function OnEvent(self, event, ...)
			local free, total = 0, 0
			for i = 0, NUM_BAG_SLOTS do
				free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
			end
			Text:SetFormattedText("%s%d"..colortag.."/|r%d",gradient(free/30),free,total)
			self:SetAllPoints(Text)
	end

	BagStat:RegisterEvent("PLAYER_LOGIN")
	BagStat:RegisterEvent("BAG_UPDATE")
	BagStat:SetScript("OnEvent", OnEvent)
	BagStat:SetScript("OnMouseDown", function() OpenAllBags() end)
end

--------------------------------------------------------------------
-- 金钱数量模块
--------------------------------------------------------------------
if SettingsCF.statpanel.gold == true then
	local GoldStat = CreateFrame("Frame")
	GoldStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", statpanel, "BOTTOMLEFT", 258, 0)
	Text:SetJustifyH("LEFT")

	local Profit = 0
	local Spent = 0
	local OldMoney = 0

	local function formatMoney(money)
		local gold = floor(math.abs(money) / 10000)
		local silver = mod(floor(math.abs(money) / 100), 100)
		local copper = mod(floor(math.abs(money)), 100)
		if gold > 0 then
--			return format("|cffffd700%s|r.|cffc7c7cf%s|r.|cffeda55f%s|r", gold, silver, copper)
--			return format("%s|cffffd700g|r%s|cffc7c7cfs|r%s|cffeda55fc|r", gold, silver, copper)
			return format("%s|cffffd700g|r", gold)
		elseif silver > 0 then
--			return format("%s|cffc7c7cfs|r%s|cffeda55fc|r", silver, copper)
			return format("%s|cffc7c7cfs|r", silver)
		else
			return format("%s|cffeda55fc|r", copper)
		end
	end

	local function FormatTooltipMoney(money)
		local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
		local cash = ""
		cash = format("%d|cffffd700g|r %d|cffc7c7cfs|r %d|cffeda55fc|r", gold, silver, copper)
		return cash
	end

	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end

		local NewMoney = GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money

		if OldMoney > NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Moeny
			Profit = Profit + Change
		end

		Text:SetText(formatMoney(NewMoney))
		-- Setup Money Tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				self.hovered = true 
				GameTooltip:SetOwner(this, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(MONEY, 0.75, 0.9, 1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L_STAT_SESSION)
				GameTooltip:AddDoubleLine(L_STAT_EARN, formatMoney(Profit), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(L_STAT_SPEND, formatMoney(Spent), 1, 1, 1, 1, 1, 1)
				if Profit < Spent then
					GameTooltip:AddDoubleLine(L_STAT_DEFICIT, formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
				elseif (Profit-Spent) > 0 then
					GameTooltip:AddDoubleLine(L_STAT_PROFIT, formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
				end

				local numWatched = GetNumWatchedTokens()
				if numWatched > 0 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CURRENCY)

					for i = 1, numWatched do
						local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
						local r, g, b, hex = GetItemQualityColor(select(3, GetItemInfo(itemID)))

						GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1)
					end
				end
				GameTooltip:Show()
			end
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		OldMoney = NewMoney
	end

	GoldStat:RegisterEvent("PLAYER_MONEY")
	GoldStat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	GoldStat:RegisterEvent("SEND_MAIL_COD_CHANGED")
	GoldStat:RegisterEvent("PLAYER_TRADE_MONEY")
	GoldStat:RegisterEvent("TRADE_MONEY_CHANGED")
	GoldStat:RegisterEvent("PLAYER_ENTERING_WORLD")
	GoldStat:SetScript("OnMouseDown", function() ToggleCharacter("TokenFrame") end)
	GoldStat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- 时间模块
--------------------------------------------------------------------
if SettingsCF.statpanel.time == true then
	local ClockStat = CreateFrame("Frame")
	ClockStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 1)
	Text:SetJustifyH("CENTER")

	local function Update(self)
		local pendingCalendarInvites = CalendarGetNumPendingInvites()
		LHr24 = date("%H")
	--	local LHr = tonumber(date("%I"))
		LMin = date("%M")
		GHr, GMin = GetGameTime()
--		if GHr == 0 then GHr = 12 end
		if SettingsCF.statpanel.time_local == true then
			if pendingCalendarInvites > 0 then
				Text:SetFormattedText("|cffFF0000%s:%02d|r", LHr24, LMin)
			else
				Text:SetFormattedText("|cffffffff%s:%02d|r", LHr24, LMin)
			end
		else
			if pendingCalendarInvites > 0 then
				Text:SetFormattedText("|cffFF0000%02s:%02d|r", GHr, GMin)
			else
				Text:SetFormattedText("|cffffffff%02s:%02d|r", GHr, GMin)
			end
		end
		self:SetAllPoints(Text)
	end

	ClockStat:SetScript("OnEnter", function(self)
		OnLoad = function(self) RequestRaidInfo() end,

		GameTooltip:SetOwner(this, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOP", self, "BOTTOM", 0, -1)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(date("%A, %B %d"), 0.75, 0.9, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, LHr24..":"..LMin, 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, format("%02s:%02d", GHr, GMin), 0.75, 0.9, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		local wgtime = GetWintergraspWaitTime() or nil
		inInstance, instanceType = IsInInstance()
		if not ( instanceType == "none" ) then
			wgtime = L_STAT_UNAVAILABLE
		elseif wgtime == nil then
			wgtime = L_STAT_INPROGRESS
		else
			local hour = tonumber(format("%01.f", floor(wgtime/3600)))
			local min = format(hour>0 and "%02.f" or "%01.f", floor(wgtime/60 - (hour*60)))
			local sec = format("%02.f", floor(wgtime - hour*3600 - min *60))
			wgtime = (hour>0 and hour..":" or "")..min..":"..sec
		end

		GameTooltip:AddDoubleLine(L_STAT_WINTERGRASP, wgtime)
		local oneraid
		for i = 1, GetNumSavedInstances() do
			local name,_,reset,difficulty,locked,extended,_,isRaid,maxPlayers = GetSavedInstanceInfo(i)
			if isRaid and (locked or extended) then
				local tr,tg,tb,diff
				if not oneraid then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(L_STAT_SAVED)
				oneraid = true
				end

				local function fmttime(sec,table)
					local table = table or {}
					local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
					local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
					local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
					return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
				end
				if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
				if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
				GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)",name,maxPlayers,diff),fmttime(reset),1,1,1,tr,tg,tb)
			end
		end
		GameTooltip:Show()
	end)
	ClockStat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	ClockStat:RegisterEvent("PLAYER_ENTERING_WORLD")
	ClockStat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	ClockStat:RegisterEvent("UPDATE_INSTANCE_INFO")
	ClockStat:SetScript("OnUpdate", Update)
	ClockStat:SetScript("OnMouseDown", function(self,b) (b == "RightButton" and ToggleTimeManager or ToggleCalendar)() end)
	Update(ClockStat)
end

--[[
--------------------------------------------------------------------
-- player sp
--------------------------------------------------------------------

if playersp > 0 then
	local Stat9 = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	panel_setpoint(playersp, Text)
   
	local int = 1

	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText(GetSpellBonusDamage(7) .. " " .. "sp")
			int = 1
		end
	end

	Stat9:SetScript("OnUpdate", Update)
	Update(Stat9, 10)
end

--------------------------------------------------------------------
-- player ap
--------------------------------------------------------------------

if playerap > 0 then
	local Stat10 = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	panel_setpoint(playerap, Text)
   
	local int = 1

	local function Update(self, t)
		int = int - t
		if int < 0 then
			local base, posBuff, negBuff = UnitAttackPower("player")
			local effective = base + posBuff + negBuff
			Text:SetText(effective .. " " .. "ap")
			int = 1
		end
	end

	Stat10:SetScript("OnUpdate", Update)
	Update(Stat10, 10)
end

--------------------------------------------------------------------
-- player haste
--------------------------------------------------------------------

if playerhaste > 0 then
	local Stat11 = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	panel_setpoint(playerhaste, Text)
   
	local int = 1

	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText(GetCombatRating(20) .. " " .. "haste")
			int = 1
		end     
	end

	Stat11:SetScript("OnUpdate", Update)
	Update(Stat11, 10)
end

--------------------------------------------------------------------
-- player arp
--------------------------------------------------------------------

if playerarp > 0 then
	local Stat12 = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	panel_setpoint(playerarp, Text)
   
	local int = 1

	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText(GetCombatRating(25) .. " " .. "arp")
			int = 1
		end     
	end

	Stat12:SetScript("OnUpdate", Update)
	Update(Stat12, 10)
end
]]

--------------------------------------------------------------------
-- DPS
--------------------------------------------------------------------
if SettingsCF.statpanel.dps == true then
	local events = {
		SWING_DAMAGE = true,
		RANGE_DAMAGE = true,
		SPELL_DAMAGE = true,
		SPELL_PERIODIC_DAMAGE = true,
		DAMAGE_SHIELD = true,
		DAMAGE_SPLIT = true,
		SPELL_EXTRA_ATTACKS = true,
	}
	local DPS_FEED = CreateFrame("Frame")
	local player_id = UnitGUID("player")
	local dmg_total, last_dmg_amount = 0, 0
	local cmbt_time = 0

	local pet_id = UnitGUID("pet")

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetText("0.0"..colortag.."dps|r")
	Text:SetPoint("BOTTOMRIGHT", statpanel, "BOTTOMRIGHT", -8, 0)
	Text:SetJustifyH("RIGHT")

	DPS_FEED:EnableMouse(true)
	DPS_FEED:SetHeight(20)
	DPS_FEED:SetWidth(100)
	DPS_FEED:SetAllPoints(Text)

	DPS_FEED:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	DPS_FEED:RegisterEvent("PLAYER_LOGIN")

	DPS_FEED:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			cmbt_time = cmbt_time + elap
		end

		Text:SetText(getDPS())
	end)

	function DPS_FEED:PLAYER_LOGIN()
		DPS_FEED:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		DPS_FEED:RegisterEvent("PLAYER_REGEN_ENABLED")
		DPS_FEED:RegisterEvent("PLAYER_REGEN_DISABLED")
		DPS_FEED:RegisterEvent("UNIT_PET")
		player_id = UnitGUID("player")
		DPS_FEED:UnregisterEvent("PLAYER_LOGIN")
	end

	function DPS_FEED:UNIT_PET(unit)
		if unit == "player" then
			pet_id = UnitGUID("pet")
		end
	end

	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function DPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)		   
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end

		-- only use events from the player
		local id = select(3, ...)

		if id == player_id or id == pet_id then
			if select(2, ...) == "SWING_DAMAGE" then
				last_dmg_amount = select(9, ...)
			else
				last_dmg_amount = select(12, ...)
			end
			 
			dmg_total = dmg_total + last_dmg_amount
		end
	end

	function getDPS()
		if (dmg_total == 0) then
			return ("0.0"..colortag.."dps|r")
		else
			return string.format("%.1f"..colortag.."dps|r", (dmg_total or 0) / (cmbt_time or 1))
		end
	end

	function DPS_FEED:PLAYER_REGEN_ENABLED()
		Text:SetText(getDPS())
	end

	function DPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end

	DPS_FEED:SetScript("OnMouseDown", function (self, button, down)
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end)

--------------------------------------------------------------------
-- HPS
--------------------------------------------------------------------
else
	local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local HPS_FEED = CreateFrame("Frame")
	local player_id = UnitGUID("player")
	local actual_heals_total, cmbt_time = 0

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetText("0.0"..colortag.."hps|r")
	Text:SetPoint("BOTTOMRIGHT", statpanel, "BOTTOMRIGHT", -8, 0)
	Text:SetJustifyH("RIGHT")

	HPS_FEED:EnableMouse(true)
	HPS_FEED:SetHeight(20)
	HPS_FEED:SetWidth(100)
	HPS_FEED:SetAllPoints(Text)

	HPS_FEED:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	HPS_FEED:RegisterEvent("PLAYER_LOGIN")

	HPS_FEED:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			HPS_FEED:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cmbt_time = cmbt_time + elap
		else
			HPS_FEED:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		Text:SetText(get_hps())
	end)

	function HPS_FEED:PLAYER_LOGIN()
		HPS_FEED:RegisterEvent("PLAYER_REGEN_ENABLED")
		HPS_FEED:RegisterEvent("PLAYER_REGEN_DISABLED")
		player_id = UnitGUID("player")
		HPS_FEED:UnregisterEvent("PLAYER_LOGIN")
	end

	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function HPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)         
	-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end
		if event == "PLAYER_REGEN_DISABLED" then return end

	-- only use events from the player
		local id = select(3, ...)
		if id == player_id then
			amount_healed = select(12, ...)
			amount_over_healed = select(13, ...)
			-- add to the total the healed amount subtracting the overhealed amount
			actual_heals_total = actual_heals_total + math.max(0, amount_healed - amount_over_healed)
		end
	end

	function HPS_FEED:PLAYER_REGEN_ENABLED()
		Text:SetText(get_hps)
	end

	function HPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		actual_heals_total = 0
	end

	HPS_FEED:SetScript("OnMouseDown", function (self, button, down)
		cmbt_time = 0
		actual_heals_total = 0
	end)

	function get_hps()
		if (actual_heals_total == 0) then
			return ("0.0"..colortag.."hps|r")
		else
			return string.format("%.1f"..colortag.."hps|r", (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end
end

--------------------------------------------------------------------
-- Mail
--------------------------------------------------------------------
if SettingsCF.statpanel.mail == true then
	MiniMapMailFrame.Show = MiniMapMailFrame.Hide
	local MailStat = CreateFrame("Frame")
	MailStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMRIGHT", statpanel, "BOTTOMRIGHT", -70, 0)
	Text:SetJustifyH("RIGHT")

	local function OnEvent(self)
		if HasNewMail() then
			Text:SetText(colortag.."Mail|r")
		else
			Text:SetText("|cffffffffMail|r")
		end
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
			MinimapMailFrameUpdate()
			GameTooltip:Show()
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	MailStat:RegisterEvent("PLAYER_ENTERING_WORLD")
	MailStat:RegisterEvent("UPDATE_PENDING_MAIL")
	MailStat:RegisterEvent("MAIL_INBOX_UPDATE")
	MailStat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- 经验值模块
--------------------------------------------------------------------
if SettingsCF.statpanel.exp == true and UnitLevel("player") ~= MAX_PLAYER_LEVEL then
	local ExpStat = CreateFrame("Frame")
	ExpStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(statpanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOM", statpanel, "BOTTOM", 204, 0)
	Text:SetJustifyH("LEFT")

	local function Update(self)
		local XP = UnitXP("player")
		local XPMax = UnitXPMax("player")

		if (GetXPExhaustion() == nil) then
			RestXP = 0
			Text:SetFormattedText(colortag.."L|r%d "..colortag.."-|r %d%%", UnitLevel("player"), XP/XPMax*100)
		else 
			RestXP = GetXPExhaustion()
			Text:SetFormattedText(colortag.."L|r%d "..colortag.."-|r %d%% "..colortag.."R:|r%d%%", UnitLevel("player"), XP/XPMax*100, RestXP/XPMax*100)
		end

		ExpStat:SetAllPoints(Text)
		ExpStat:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				GameTooltip:SetOwner(this, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", ExpStat, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(COMBAT_XP_GAIN, 0.75, 0.9, 1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(L_STAT_LEVEL, format("%d/%d", XP, XPMax),1, 1, 1, 0, 0.4, 1)
				GameTooltip:AddDoubleLine(L_STAT_REST, RestXP,1, 1, 1, 0.7, 0, 0.7)
				GameTooltip:Show()
			end
		end)
		ExpStat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	ExpStat:SetScript("OnUpdate", Update)
end
