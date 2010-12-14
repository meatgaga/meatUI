if not SettingsCF.cooldown.line_enable == true then return end

local CoolLine = CreateFrame("Frame", "CoolLine", UIParent)
local self = CoolLine
self:SetScript("OnEvent", function(this, event, ...)
	this[event](this, ...)
end)

local _G = getfenv(0)
local pairs, ipairs = pairs, ipairs
local tinsert, tremove = tinsert, tremove
local GetTime = GetTime
local random = math.random
local strmatch = strmatch
local UnitExists, HasPetUI = UnitExists, HasPetUI

local db, block
local backdrop = { edgeSize=1, }
local section, iconsize = 0, 0
local tick0, tick1, tick10, tick30, tick60, tick120, tick300
local BOOKTYPE_SPELL, BOOKTYPE_PET = BOOKTYPE_SPELL, BOOKTYPE_PET
local spells = { [BOOKTYPE_SPELL] = { }, [BOOKTYPE_PET] = { }, }
local frames, cooldowns = { }, { }

local SetValue, updatelook, createfs, ShowOptions, RuneCheck
local function SetValueH(this, v, just)
	this:SetPoint(just or "CENTER", self, "LEFT", v, 0)
end
local function SetValueHR(this, v, just)
	this:SetPoint(just or "CENTER", self, "LEFT", db.w - v, 0)
end
local function SetValueV(this, v, just)
	this:SetPoint(just or "CENTER", self, "BOTTOM", 0, v)
end
local function SetValueVR(this, v, just)
	this:SetPoint(just or "CENTER", self, "BOTTOM", 0, db.h - v)
end

self:RegisterEvent("ADDON_LOADED")
function CoolLine:ADDON_LOADED(a1)
	if a1 ~= "meatUI" then return end
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	CoolLineDB = CoolLineDB or { }
	CoolLineCharDB = nil
	db = CoolLineDB
	if db.dbinit ~= 1 then
		db.dbinit = 1
		for k, v in pairs({
			w = 280, h = 18,
			bgcolor = { r = 0, g = 0, b = 0, a = 0.25, },
			bordercolor = { r = 0, g = 0, b = 0, a = 0.8, },
			spellcolor = { r = 0.8, g = 0.4, b = 0, a = 1, },
			nospellcolor = { r = 0, g = 0, b = 0, a = 1, },
			block = {  -- [spell or item name] = true,
				[GetItemInfo(6948) or "Hearthstone"] = true,  -- Hearthstone
			},
		}) do
			db[k] = (db[k] ~= nil and db[k]) or v
		end
	end
	block = db.block

	if SettingsDB.class == "DEATHKNIGHT" then
		local runecd = {  -- fix by NeoSyrex
			[GetSpellInfo(50977) or "Death Gate"] = 11,
			[GetSpellInfo(43265) or "Death and Decay"] = 11,
			[GetSpellInfo(48263) or "Frost Presence"] = 1,
			[GetSpellInfo(48266) or "Blood Presence"] = 1,
			[GetSpellInfo(48265) or "Unholy Presence"] = 1, 
			[GetSpellInfo(42650) or "Army of the Dead"] = 11,
			[GetSpellInfo(49222) or "Bone Shield"] = 11,
			[GetSpellInfo(47476) or "Strangulate"] = 11,
			[GetSpellInfo(51052) or "Anti-Magic Zone"] = 11,
			[GetSpellInfo(63560) or "Ghoul Frenzy"] = 10,
			[GetSpellInfo(49184) or "Howling Blast"] = 8,
			[GetSpellInfo(51271) or "Unbreakable Armor"] = 11,
			[GetSpellInfo(55233) or "Vampiric Blood"] = 11,
			[GetSpellInfo(49005) or "Mark of Blood"] = 11,
			[GetSpellInfo(48982) or "Rune Tap"] = 11,
		}
		RuneCheck = function(name, duration)
			local rc = runecd[name]
			if not rc or (rc <= duration and (rc > 10 or rc >= duration)) then
				return true
			end
		end
	end

	createfs = function(f, text, offset, just)
		local fs = f or self.overlay:CreateFontString(nil, "OVERLAY")
		fs:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
		fs:SetTextColor(1, 1, 1, 0.5)
		fs:SetText(text)
		--fs:SetWidth(CoolFontSize * 3)
		--fs:SetHeight(CoolFontSize + 2)
		--fs:SetShadowColor(db.bgcolor.r, db.bgcolor.g, db.bgcolor.b, db.bgcolor.a)
		--fs:SetShadowOffset(1, -1)
		if just then
			fs:ClearAllPoints()
			if db.reverse then
				just = (just == "LEFT" and "RIGHT") or "LEFT"
				offset = offset + ((just == "LEFT" and 1) or -1)
				fs:SetJustifyH(just)
			else
				offset = offset + ((just == "LEFT" and 1) or -1)
				fs:SetJustifyH(just)
			end
		else
			fs:SetJustifyH("CENTER")
		end
		SetValue(fs, offset, just)
		return fs
	end

	updatelook = function()
		self:SetWidth(db.w)
		self:SetHeight(db.h)
		self:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 256)

		self.bg = self.bg or self:CreateTexture(nil, "ARTWORK")
		self.bg:SetTexture(SettingsCF.media.blank)
		self.bg:SetVertexColor(db.bgcolor.r, db.bgcolor.g, db.bgcolor.b, db.bgcolor.a)
		self.bg:SetAllPoints(self)
		self.bg:SetTexCoord(0, 1, 0, 1)

		self.border = self.border or CreateFrame("Frame", nil, self)
		self.border:SetPoint("TOPLEFT", -1, 1)
		self.border:SetPoint("BOTTOMRIGHT", 1, -1)
		backdrop.edgeFile = (SettingsCF.media.blank)
		self.border:SetBackdrop(backdrop)
		self.border:SetBackdropBorderColor(db.bordercolor.r, db.bordercolor.g, db.bordercolor.b, db.bordercolor.a)

		self.overlay = self.overlay or CreateFrame("Frame", nil, self.border)
		self.overlay:SetFrameLevel(11)

		section = (db.w) / 6
		iconsize = (db.h) + (db.iconplus or 0)
		SetValue = (db.reverse and SetValueHR or SetValueH)

		tick0 = createfs(tick0, "0", 0, "LEFT")
		tick1 = createfs(tick1, "1", section)
		tick10 = createfs(tick10, "3", section * 2)
		tick30 = createfs(tick30, "10", section * 3)
		tick60 = createfs(tick60, "60", section * 4)
		tick120 = createfs(tick120, "2m", section * 5)
		tick300 = createfs(tick300, "6m", section * 6, "RIGHT")

		if SettingsCF.cooldown.line_pet == true then
			self:RegisterEvent("UNIT_PET")
			self:UNIT_PET("player")
		else
			self:UnregisterEvent("UNIT_PET")
			self:UnregisterEvent("PET_BAR_UPDATE_COOLDOWN")
		end
		if SettingsCF.cooldown.line_bag == true then
			self:RegisterEvent("BAG_UPDATE_COOLDOWN")
		else
			self:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		end
		if SettingsCF.cooldown.line_fail == true then
			self:RegisterEvent("UNIT_SPELLCAST_FAILED")
		else
			self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
		end
--		CoolLine:SetAlpha((#cooldowns > 0) and CoolActiveAlpha or CoolInactiveAlpha)
		CoolLine:SetAlpha((#cooldowns > 0) and 1 or 0)
		for _, frame in ipairs(cooldowns) do
			frame:SetWidth(iconsize)
			frame:SetHeight(iconsize)
		end
	end
	
	if IsLoggedIn() then
		CoolLine:PLAYER_LOGIN()
	else
		self:RegisterEvent("PLAYER_LOGIN")
	end
end

--------------------------------
function CoolLine:PLAYER_LOGIN()
--------------------------------
	self.PLAYER_LOGIN = nil
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	if UnitHasVehicleUI("player") then
		self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		self:RegisterEvent("UNIT_EXITED_VEHICLE")
	end
	updatelook()
	self:SPELLS_CHANGED()
	self:SPELL_UPDATE_COOLDOWN()
	self:BAG_UPDATE_COOLDOWN()
--	self:SetAlpha((#cooldowns == 0 and CoolInactiveAlpha) or CoolActiveAlpha)
	self:SetAlpha((#cooldowns == 0 and 0) or 1)
end

local iconback = { bgFile = SettingsCF.media.blank }
local elapsed, throt, ptime, isactive = 0, 1.5, 0, false
local function ClearCooldown(f, name)
	name = name or (f and f.name)
	for index, frame in ipairs(cooldowns) do
		if frame.name == name then
			frame:Hide()
			frame.name = nil
			frame.endtime = nil
			tinsert(frames, tremove(cooldowns, index))
			break
		end
	end
end
local function SetupIcon(frame, position, tthrot, active, fl)
	throt = (throt < tthrot and throt) or tthrot
	isactive = active or isactive
	if fl then
		frame:SetFrameLevel(random(1,4) * 2 + 2)
	end
	SetValue(frame, position)
end
local function OnUpdate(this, a1, ctime, dofl)
	elapsed = elapsed + a1
	if elapsed < throt then return end
	elapsed = 0
	
	if #cooldowns == 0 then
		self:SetScript("OnUpdate", nil)
		self:SetAlpha(0)
		return
	end
	
	ctime = ctime or GetTime()
	if ctime > ptime then
		dofl, ptime = true, ctime + 0.4
	end
	isactive, throt = false, 1.5
	for index, frame in pairs(cooldowns) do
		local remain = frame.endtime - ctime
		if remain < 3 then
			if remain > 1 then
				SetupIcon(frame, section * (remain + 1) * 0.5, 0.02, true, dofl)  -- 1 + (remain - 1) / 2
			elseif remain > 0.3 then
				SetupIcon(frame, section * remain, 0, true, dofl)
			elseif remain > 0 then
				local size = iconsize * (0.5 - remain) * 5  -- iconsize + iconsize * (0.3 - remain) / 0.2
				frame:SetWidth(size)
				frame:SetHeight(size)
				SetupIcon(frame, section * remain, 0, true, dofl)
			elseif remain > -1 then
				SetupIcon(frame, 0, 0, true, dofl)
				frame:SetAlpha(1 + remain)  -- fades
			else
				throt = (throt < 0.2 and throt) or 0.2
				isactive = true
				ClearCooldown(frame)
			end
		elseif remain < 10 then
			SetupIcon(frame, section * (remain + 11) * 0.143, remain > 4 and 0.05 or 0.02, true, dofl)  -- 2 + (remain - 3) / 7
		elseif remain < 60 then
			SetupIcon(frame, section * (remain + 140) * 0.02, 0.12, true, dofl)  -- 3 + (remain - 10) / 50
		elseif remain < 120 then
			SetupIcon(frame, section * (remain + 180) * 0.01666, 0.25, true, dofl)  -- 4 + (remain - 60) / 60
		elseif remain < 360 then
			SetupIcon(frame, section * (remain + 1080) * 0.004166, 1.2, true, dofl)  -- 5 + (remain - 120) / 240
			frame:SetAlpha(1)
		else
			SetupIcon(frame, 6 * section, 2, false, dofl)
		end
	end
	if not isactive then
		self:SetAlpha(0.5)
	end
end
local function NewCooldown(name, icon, endtime, isplayer)
	local f
	for index, frame in pairs(cooldowns) do
		if frame.name == name and frame.isplayer == isplayer then
			f = frame
			break
		elseif frame.endtime == endtime then
			return
		end
	end
	if not f then
		f = f or tremove(frames)
		if not f then
			f = CreateFrame("Frame", nil, CoolLine.border)
			f:SetBackdrop(iconback)
			f.icon = f:CreateTexture(nil, "ARTWORK")
			f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			f.icon:SetPoint("TOPLEFT", 1, -1)
			f.icon:SetPoint("BOTTOMRIGHT", -1, 1)
		end
		tinsert(cooldowns, f)
	end
	local ctime = GetTime()
	f:SetWidth(iconsize)
	f:SetHeight(iconsize)
	f:SetAlpha((endtime - ctime > 360) and 0.6 or 1)
	f.name, f.endtime, f.isplayer = name, endtime, isplayer
	f.icon:SetTexture(icon)
	local c = db[isplayer and "spellcolor" or "nospellcolor"]
	f:SetBackdropColor(c.r, c.g, c.b, c.a)
	f:Show()
	self:SetScript("OnUpdate", OnUpdate)
	self:SetAlpha(1)
	OnUpdate(self, 2, ctime)
end
CoolLine.NewCooldown, CoolLine.ClearCooldown = NewCooldown, ClearCooldown

do  -- cache spells that have a cooldown
	local CLTip = CreateFrame("GameTooltip", "CLTip", CoolLine, "GameTooltipTemplate")
	CLTip:SetOwner(CoolLine, "ANCHOR_NONE")
	local GetSpellName = GetSpellName
	local cooldown1 = gsub(SPELL_RECAST_TIME_MIN, "%%%.%d[fg]", "(.+)")
	local cooldown2 = gsub(SPELL_RECAST_TIME_SEC, "%%%.%d[fg]", "(.+)")
	local function CheckRight(rtext)
		local text = rtext and rtext:GetText()
		if text and (strmatch(text, cooldown1) or strmatch(text, cooldown2)) then
			return true
		end
	end
	local function CacheBook(btype)
		local name, last
		local sb = spells[btype]
		for i = 1, 500, 1 do
			name = GetSpellName(i, btype)
			if not name then break end
			if name ~= last then
				last = name
				if sb[name] then
					sb[name] = i
				else
					CLTip:SetSpell(i, btype)
					if CheckRight(CLTipTextRight2) or CheckRight(CLTipTextRight3) or CheckRight(CLTipTextRight4) then
						sb[name] = i
					end
				end
			end
		end
	end
	----------------------------------
	function CoolLine:SPELLS_CHANGED()
	----------------------------------
		CacheBook(BOOKTYPE_SPELL)
		if not CoolHidePet == true then
			CacheBook(BOOKTYPE_PET)
		end
	end
end

do  -- scans spellbook to update cooldowns, throttled since the event fires a lot
	local selap = 0
	local spellthrot = CreateFrame("Frame", nil, CoolLine)
	local GetSpellCooldown, GetSpellTexture = GetSpellCooldown, GetSpellTexture
	local function CheckSpellBook(btype)
		for name, id in pairs(spells[btype]) do
			local start, duration, enable = GetSpellCooldown(id, btype)
			if enable == 1 and start > 0 and not block[name] and (not RuneCheck or RuneCheck(name, duration))then
				if duration > 2.5 then
					NewCooldown(name, GetSpellTexture(id, btype), start + duration, btype == BOOKTYPE_SPELL)
				else
					for index, frame in ipairs(cooldowns) do
						if frame.name == name then
							if frame.endtime > start + duration + 0.1 then
								frame.endtime = start + duration
							end
							break
						end
					end
				end
			else
				ClearCooldown(nil, name)
			end
		end
	end
	spellthrot:SetScript("OnUpdate", function(this, a1)
		selap = selap + a1
		if selap < 0.33 then return end
		selap = 0
		this:Hide()
		CheckSpellBook(BOOKTYPE_SPELL)
		if not CoolHidePet == true and HasPetUI() then
			CheckSpellBook(BOOKTYPE_PET)
		end
	end)
	spellthrot:Hide()
	-----------------------------------------
	function CoolLine:SPELL_UPDATE_COOLDOWN()
	-----------------------------------------
		spellthrot:Show()
	end
end

do  -- scans equipments and bags for item cooldowns
	local GetItemInfo = GetItemInfo
	local GetInventoryItemCooldown, GetInventoryItemTexture = GetInventoryItemCooldown, GetInventoryItemTexture
	local GetContainerItemCooldown, GetContainerItemInfo = GetContainerItemCooldown, GetContainerItemInfo
	local GetContainerNumSlots = GetContainerNumSlots
	---------------------------------------
	function CoolLine:BAG_UPDATE_COOLDOWN()
	---------------------------------------
		for i = 1, (CoolHideBag == true and 0) or 18, 1 do
			local start, duration, enable = GetInventoryItemCooldown("player", i)
			if enable == 1 then
				local name = GetItemInfo(GetInventoryItemLink("player", i))
				if start > 0 and not block[name] then
					if duration > 3 and duration < 3601 then
						NewCooldown(name, GetInventoryItemTexture("player", i), start + duration)
					end
				else
					ClearCooldown(nil, name)
				end
			end
		end
		for i = 0, (CoolHideBag == true and -1) or 4, 1 do
			for j = 1, GetContainerNumSlots(i), 1 do
				local start, duration, enable = GetContainerItemCooldown(i, j)
				if enable == 1 then
					local name = GetItemInfo(GetContainerItemLink(i, j))
					if start > 0 and not block[name] then
						if duration > 3 and duration < 3601 then
							NewCooldown(name, GetContainerItemInfo(i, j), start + duration)
						end
					else
						ClearCooldown(nil, name)
					end
				end
			end
		end
	end
end

-------------------------------------------
function CoolLine:PET_BAR_UPDATE_COOLDOWN()
-------------------------------------------
	for i = 1, 10, 1 do
		local start, duration, enable = GetPetActionCooldown(i)
		if enable == 1 then
			local name, _, texture = GetPetActionInfo(i)
			if name then
				if start > 0 and not block[name] then
					if duration > 3 then
						NewCooldown(name, texture, start + duration)
					end
				else
					ClearCooldown(nil, name)
				end
			end
		end
	end
end
------------------------------
function CoolLine:UNIT_PET(a1)
------------------------------
	if a1 ~= "player" then return end
	if UnitExists("pet") and not HasPetUI() then
		self:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	else
		self:UnregisterEvent("PET_BAR_UPDATE_COOLDOWN")
	end
end

local GetActionCooldown, HasAction = GetActionCooldown, HasAction
---------------------------------------------
function CoolLine:ACTIONBAR_UPDATE_COOLDOWN()  -- used only for vehicles
---------------------------------------------
	for i = 1, 6, 1 do
		local b = _G["VehicleMenuBarActionButton"..i]
		if b and HasAction(b.action) then
			local start, duration, enable = GetActionCooldown(b.action)
			if enable == 1 then
				if start > 0 and not block[GetActionInfo(b.action)] then
					if duration > 3 then
						NewCooldown("vhcle"..i, GetActionTexture(b.action), start + duration)
					end
				else
					ClearCooldown(nil, "vhcle"..i)
				end
			end
		end
	end
end
------------------------------------------
function CoolLine:UNIT_ENTERED_VEHICLE(a1)
------------------------------------------
	if a1 ~= "player" or not UnitHasVehicleUI("player") then return end
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:ACTIONBAR_UPDATE_COOLDOWN()
end
-----------------------------------------
function CoolLine:UNIT_EXITED_VEHICLE(a1)
-----------------------------------------
	if a1 ~= "player" then return end
	self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	for index, frame in ipairs(cooldowns) do
		if strmatch(frame.name, "vhcle") then
			ClearCooldown(nil, frame.name)
		end
	end
end

local failborder
----------------------------------------------------
function CoolLine:UNIT_SPELLCAST_FAILED(unit, spell)
----------------------------------------------------
	if unit ~= "player" or #cooldowns == 0 then return end
	for index, frame in pairs(cooldowns) do
		if frame.name == spell then
			if frame.endtime - GetTime() > 1 then
				if not failborder then
					failborder = CreateFrame("Frame", nil, CoolLine.border)
					failborder:SetBackdrop(iconback)
					failborder:SetBackdropColor(1, 0, 0, 0.9)
					failborder:Hide()
					failborder:SetScript("OnUpdate", function(this, a1)
						this.alp = this.alp - a1
						if this.alp < 0 then return this:Hide() end
						this:SetAlpha(this.alp > 1 and 1 or this.alp)
					end)
				end
				failborder.alp = 1.2
				failborder:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
				failborder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
				failborder:Show()
			end
			break
		end
	end

end