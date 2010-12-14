----------------------------------------------------------------------------------------
-- 信息条 (基于Tukui)
----------------------------------------------------------------------------------------
if SettingsCF.infopanel.enable ~= true then return end

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
-- 信息条框体
----------------------------------------------------------------------------------------
local infopanel = CreateFrame("Frame", actionbar, UIParent)
infopanel:SetFrameLevel(2)
infopanel:SetFrameStrata("MEDIUM")
infopanel:SetHeight(10)
infopanel:SetWidth(GetScreenWidth())
infopanel:SetPoint("BOTTOM", 0, SettingsDB.Scale(2))

--------------------------------------------------------------------
-- 内存占用模块
--------------------------------------------------------------------
if SettingsCF.infopanel.memory == true then
	local MemStat = CreateFrame("Frame")
	MemStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 18, 0)
	Text:SetJustifyH("LEFT")

	local statColor = { }
	local function formatMem(memory, color)
		if color then
			statColor = { "", "" }
		else
			statColor = { "", "" }
		end

		local mult = 10^1
		if memory > 999 then
			local mem = floor((memory/1024) * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0%smb%s", unpack(statColor))
			else
				return mem..string.format("%smb%s", unpack(statColor))
			end
		else
			local mem = floor(memory * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0%skb%s", unpack(statColor))
			else
				return mem..string.format("%skb%s", unpack(statColor))
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
		
		MEMORY_TEXT = formatMem(Total, true)
		table.sort(Memory, function(a, b)
			if a and b then
				return a[2] > b[2]
			end
		end)
		
		-- Setup Memory tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			--if not InCombatLockdown() then
				GameTooltip:SetOwner(this, "ANCHOR_NONE");
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				for i = 1, #Memory do
					if Memory[i][3] then 
						local red = Memory[i][2]/Total*2
						local green = 1 - red
						GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)
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

	MemStat:SetScript("OnMouseDown", function() collectgarbage("collect") Update(MemStat, 10) end)
	MemStat:SetScript("OnUpdate", Update) 
	Update(MemStat, 10)
end

--------------------------------------------------------------------
-- FPS模块
--------------------------------------------------------------------
if SettingsCF.infopanel.fps == true then
	local FpsStat = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 66, 0)
	Text:SetJustifyH("LEFT")

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local fps, r = floor(GetFramerate()), 30
			Text:SetFormattedText("%s%d|r|cff4DB2E6fps|r", gradient(fps/r), fps)
			int = 1
		end
	end

	FpsStat:SetScript("OnUpdate", Update) 
	Update(FpsStat, 10)
end

--------------------------------------------------------------------
-- 网络延迟模块
--------------------------------------------------------------------
if SettingsCF.infopanel.latency == true then
	local LatencyStat = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 114, 0)
	Text:SetJustifyH("LEFT")

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local latency, r = select(3,GetNetStats()), 300
			Text:SetFormattedText("%s%d|r|cff4DB2E6ms|r", gradient(1-latency/r), latency)
			int = 1
		end
	end

	LatencyStat:SetScript("OnUpdate", Update) 
	Update(LatencyStat, 10)
end

--------------------------------------------------------------------
-- 装备耐久度模块
--------------------------------------------------------------------
if SettingsCF.infopanel.durability == true then
	local DurStat = CreateFrame("Frame")
	DurStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 162, 0)
--	Text:SetJustifyH("LEFT")

	local Total = 0
	local current, max
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

	local function OnEvent(self)
		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(Slots[i][1])
				if current then 
					Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)

		local durability = floor(Slots[1][3]*100)
		if Total > 0 then
			Text:SetFormattedText("%s%d%%|r|cff4DB2E6D|r", gradient(durability/100), durability)
		else
			Text:SetText("|cff00ff00100%|r|cff4DB2E6D|r")
		end
		-- Setup Durability Tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				GameTooltip:SetOwner(this, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				for i = 1, 11 do
					if Slots[i][3] ~= 1000 then
						green = Slots[i][3]*2
						red = 1 - green
						GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
					end
				end
				GameTooltip:Show()
			end
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		Total = 0
	end

	DurStat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DurStat:RegisterEvent("MERCHANT_SHOW")
	DurStat:RegisterEvent("PLAYER_ENTERING_WORLD")
	DurStat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	DurStat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- 背包空格模块
--------------------------------------------------------------------
if SettingsCF.infopanel.bag == true then
	local BagStat = CreateFrame("Frame")
	BagStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 210, 0)
	Text:SetJustifyH("LEFT")

	local function OnEvent(self, event, ...)
			local free, total,used = 0, 0, 0
			for i = 0, NUM_BAG_SLOTS do
				free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
			end
			used = total - free
			Text:SetText(used.."|cff4DB2E6/|r"..total)
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
if SettingsCF.infopanel.gold == true then
	local GoldStat = CreateFrame("Frame")
	GoldStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMLEFT", infopanel, "BOTTOMLEFT", 258, 0)
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
				GameTooltip:AddLine("Session: ")
				GameTooltip:AddDoubleLine("Earned:", formatMoney(Profit), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine("Spent:", formatMoney(Spent), 1, 1, 1, 1, 1, 1)
				if Profit < Spent then
					GameTooltip:AddDoubleLine("Deficit:", formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
				elseif (Profit-Spent) > 0 then
					GameTooltip:AddDoubleLine("Profit:", formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
				end
				GameTooltip:AddLine(" ")								
				local myPlayerRealm = GetCVar("realmName")
				local myPlayerName  = UnitName("player")
				if (tgoldDB == nil) then tgoldDB = {}; end
				if (tgoldDB[myPlayerRealm]==nil) then tgoldDB[myPlayerRealm]={}; end
				tgoldDB[myPlayerRealm][myPlayerName] = GetMoney()
				local totalGold = 0
				GameTooltip:AddLine("Character: ")
				local thisRealmList = tgoldDB[myPlayerRealm];
				for k,v in pairs(thisRealmList) do
					GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
					totalGold=totalGold+v;
				end 
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine("Server: ")
				GameTooltip:AddDoubleLine("Total: ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

				local numWatched = GetNumWatchedTokens()
				if numWatched > 0 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Currency:")

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
if SettingsCF.infopanel.time == true then
	local ClockStat = CreateFrame("Frame")
	ClockStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 1)
	Text:SetJustifyH("CENTER")

	local int = 1
	local LHr24 = date("%H")
--	local LHr = tonumber(date("%I"))
	local LMin = date("%M")
	local GHr, GMin = GetGameTime()
	local function Update(self, t)
		local pendingCalendarInvites = CalendarGetNumPendingInvites()
		int = int - t
		if int < 0 then
			if SettingsCF.infopanel.time_local == true then
				if pendingCalendarInvites > 0 then
					Text:SetFormattedText("|cffFF0000%s:%02d|r", LHr24, LMin)
				else
					Text:SetFormattedText("|cffffffff%s:%02d|r", LHr24, LMin)
				end
			else
				if pendingCalendarInvites > 0 then
					Text:SetFormattedText("|cffFF0000%s:%02d|r", GHr, GMin)
				else
					Text:SetFormattedText("|cffffffff%s:%02d|r", GHr, GMin)
				end
			end
			self:SetAllPoints(Text)
			int = 1
		end
	end

	ClockStat:SetScript("OnEnter", function(self)
		OnLoad = function(self) RequestRaidInfo() end,

		GameTooltip:SetOwner(this, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOP", self, "BOTTOM", 0, -1)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, LHr24..":"..LMin)
		GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_REALMTIME, GHr..":"..GMin)
		GameTooltip:AddLine(" ")
		local wgtime = GetWintergraspWaitTime() or nil
               inInstance, instanceType = IsInInstance()
               if not ( instanceType == "none" ) then
                  wgtime = "Unavailable"
               elseif wgtime == nil then
                  wgtime = "In Progress"
               else
                  local hour = tonumber(format("%01.f", floor(wgtime/3600)))
                  local min = format(hour>0 and "%02.f" or "%01.f", floor(wgtime/60 - (hour*60)))
                  local sec = format("%02.f", floor(wgtime - hour*3600 - min *60))            
                  wgtime = (hour>0 and hour..":" or "")..min..":"..sec            
               end

               GameTooltip:AddDoubleLine("Wintergrasp:",wgtime)
               local oneraid
                  for i = 1, GetNumSavedInstances() do
                  local name,_,reset,difficulty,locked,extended,_,isRaid,maxPlayers = GetSavedInstanceInfo(i)
                  if isRaid and (locked or extended) then
                     local tr,tg,tb,diff
                  if not oneraid then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Saved Raid(s)")
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
   ClockStat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
   ClockStat:RegisterEvent("PLAYER_ENTERING_WORLD")
   ClockStat:SetScript("OnUpdate", Update)
   ClockStat:RegisterEvent'UPDATE_INSTANCE_INFO'
   ClockStat:SetScript("OnMouseDown", function() GameTimeFrame:Click() end)
   Update(ClockStat, 10)
end

--[[
--------------------------------------------------------------------
-- player sp
--------------------------------------------------------------------

if playersp > 0 then
	local Stat9 = CreateFrame("Frame")

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
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

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	panel_setpoint(playerap, Text)
   
	local int = 1

	local function Update(self, t)
		int = int - t
		if int < 0 then
			local base, posBuff, negBuff = UnitAttackPower("player");
			local effective = base + posBuff + negBuff;
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

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
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

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
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
if SettingsCF.infopanel.dps == true then
    local events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
    local DPS_FEED = CreateFrame("Frame")
    local player_id = UnitGUID("player")
    local dmg_total, last_dmg_amount = 0, 0
    local cmbt_time = 0

    local pet_id = UnitGUID("pet")
     
	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
    Text:SetText("0.0 dps")
	Text:SetPoint("BOTTOMRIGHT", infopanel, "BOTTOMRIGHT", -8, 0)
--	Text:SetJustifyH("LEFT")

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
			return ("0.0 " .. "dps")
        else
			return string.format("%.1f " .. "dps", (dmg_total or 0) / (cmbt_time or 1))
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
end

--------------------------------------------------------------------
-- SUPPORT FOR HPS Feed... 
--------------------------------------------------------------------

if SettingsCF.infopanel.hps == true then
	local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local HPS_FEED = CreateFrame("Frame")
	local player_id = UnitGUID("player")
	local actual_heals_total, cmbt_time = 0
 
	local hText = EuiSetFontn(infopanel)
	hText:SetText("0.0 hps")
 
	panel_setpoint(hps_text, hText)
 
	HPS_FEED:EnableMouse(true)
	HPS_FEED:SetHeight(20)
	HPS_FEED:SetWidth(100)
	HPS_FEED:SetAllPoints(hText)
 
	HPS_FEED:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	HPS_FEED:RegisterEvent("PLAYER_LOGIN")
 
	HPS_FEED:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			HPS_FEED:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cmbt_time = cmbt_time + elap
		else
			HPS_FEED:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		hText:SetText(get_hps())
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
		hText:SetText(get_hps)
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
			return ("0.0 " .. "hps")
		else
			return string.format("%.1f " .. "hps", (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end

end

--------------------------------------------------------------------
-- Mail
--------------------------------------------------------------------
if SettingsCF.infopanel.mail == true then
	MiniMapMailFrame.Show = MiniMapMailFrame.Hide
	local MailStat = CreateFrame("Frame")
	MailStat:EnableMouse(true)

	local Text = SettingsDB.SetFontString(infopanel, SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	Text:SetPoint("BOTTOMRIGHT", infopanel, "BOTTOMRIGHT", -70, 0)
	Text:SetJustifyH("RIGHT")

	local function OnEvent(self)
		if HasNewMail() then
			Text:SetText("|cff4DB2E6New Mail!|r")
		else
			Text:SetText("|cffffffffNo New Mail|r")
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
