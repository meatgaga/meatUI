if SettingsDB.class ~= "HUNTER" then return end

----------------------------------------------------------------------------------------
-- 下拉菜单 - 守护
----------------------------------------------------------------------------------------
local spells = {
	[1] = {61846,61846},		-- Aspect of the Dragonhawk
	[2] = {13163,13163},		-- Aspect of the Monkey
	[3] = {13165,13165},		-- Aspect of the Hawk
	[4] = {13161,13161},		-- Aspect of the Beast
	[5] = {13159,13159},		-- Aspect of the Pack
	[6] = {20043,20043},		-- Aspect of the Wild
	[7] = {34074,34074},		-- Aspect of the Viper
}

local _, class = UnitClass("player")
local color = RAID_CLASS_COLORS[class]

local f = CreateFrame("Frame", "AspectMenu", UIParent)
SettingsDB.CreatePanel(f, SettingsCF.minimap.size + 2, #spells * 20 + 2, "TOP", Minimap, "BOTTOM", 0, -7)
f:SetBackdropBorderColor(0, 0, 0, 0)
f:SetBackdropColor(0, 0, 0, 0)

for i, spell in pairs(spells) do
	local aspect = GetSpellInfo(spell[1])

	local b = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
	SettingsDB.CreatePanel(b, SettingsCF.minimap.size + 2, 20, "BOTTOMLEFT", f, "BOTTOMLEFT", 0, ((i - 1) * 21))
	b:SetBackdropColor(0, 0, 0, 0.6)
	b:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
	b:SetFrameStrata("HIGH")

	local l = b:CreateFontString(nil, "OVERLAY", nil)
	l:SetFont(SettingsCF.media.font, SettingsCF.media.font_size, SettingsCF.media.font_style)
	l:SetText(aspect)
	b:SetFontString(l)

	b:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	b:SetAttribute("type1", "spell")
	b:SetAttribute("spell1", aspect)
	b:SetAttribute("type2", "spell")
	b:SetAttribute("spell2", aspect)
end
f:Hide()

local b = CreateFrame("Button", nil, UIParent)
SettingsDB.CreateTemplate(b)
b:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
b:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT")
b:SetWidth(SettingsDB.Scale(20))
b:SetHeight(SettingsDB.Scale(20))
b:SetAlpha(0)

local bt = b:CreateTexture(nil, "BORDER")
bt:SetTexture("Interface\\Icons\\Ability_Hunter_AspectoftheViper")
bt:SetTexCoord(0.1, 0.9, 0.1, 0.9)
bt:SetPoint("TOPLEFT", b, SettingsDB.Scale(1), SettingsDB.Scale(-1))
bt:SetPoint("BOTTOMRIGHT", b, SettingsDB.Scale(-1), SettingsDB.Scale(1))

b:SetScript("OnClick", function(self)
	if not InCombatLockdown() then
	if _G["AspectMenu"]:IsShown() then
		_G["AspectMenu"]:Hide()
	else
		_G["AspectMenu"]:Show()
		end
	end
end)

b:SetScript("OnEnter", function()
	if InCombatLockdown() then return end
	SettingsDB.FadeIn(b)
end)

b:SetScript("OnLeave", function()
	SettingsDB.FadeOut(b)
end)

f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:SetScript("OnEvent", function(self)
	if self:IsShown() then
		self:Hide()
	end
end)

----------------------------------------------------------------------------------------
-- 宠物快乐度聊天栏提示
----------------------------------------------------------------------------------------
local PetHappiness = CreateFrame("Frame")
PetHappiness.happiness = GetPetHappiness()

local OnEvent = function(self, event, unit)
	local happiness = GetPetHappiness()
	local hunterPet = select(2, HasPetUI())

	if (event == "UNIT_HAPPINESS" and happiness and hunterPet and self.happiness ~= happiness) then
		self.happiness = happiness
		if (happiness == 1) then
			DEFAULT_CHAT_FRAME:AddMessage(L_CLASS_HUNTER_UNHAPPY, 1, 0, 0)
		elseif (happiness == 2) then
			DEFAULT_CHAT_FRAME:AddMessage(L_CLASS_HUNTER_CONTENT, 1, 1, 0)
		elseif (happiness == 3) then
			DEFAULT_CHAT_FRAME:AddMessage(L_CLASS_HUNTER_HAPPY, 0, 1, 0)
		end
	elseif (event == "UNIT_PET") then
		self.happiness = happiness
		if (happiness == 1) then
			DEFAULT_CHAT_FRAME:AddMessage(L_CLASS_HUNTER_UNHAPPY, 1, 0, 0)
		end
	end
end
PetHappiness:RegisterEvent("UNIT_HAPPINESS")
PetHappiness:RegisterEvent("UNIT_PET")
PetHappiness:SetScript("OnEvent", OnEvent)

----------------------------------------------------------------------------------------
-- 距离检测条(cRange by Chimaine)
----------------------------------------------------------------------------------------
local mRange = CreateFrame("Frame", "mRangeFrame", UIParent)
mRange:Hide()

local maxRange, count, scatterShot = 30, nil, nil
local bar1, bar2, bg, button
local spell = {
	AutoShot = {},
	Throw = {},
	ScatterShot = {},
	WingClip = {},
}

-- Color tables... Anyone knows a better way? o0
local mRangecolors = { -- colors r,g,b.
	melee = {0.67, 0.02, 0.13},
	low = {0.31, 0.41, 0.53},
	mid = {0.31, 0.41, 0.53}, -- fallback color
	opt = {0.57, 0.73, 0.35},
	oor = {0.67, 0.02, 0.13},
}

--	Utility functions
local function print(text)
	if text == nil then text = "" end
	DEFAULT_CHAT_FRAME:AddMessage("|cff7696bcm|rRange: ".. text)
end

local function SetupScripts()
	mRange:RegisterEvent("PLAYER_LOGIN")
	mRange:RegisterEvent("PLAYER_TARGET_CHANGED")
	mRange:RegisterEvent("CHARACTER_POINTS_CHANGED")

	mRange:SetScript("OnEvent", function(self, event)
		self[event](self)
	end)
	mRange:SetScript("OnUpdate", function()
		mRange:OnUpdate_Bars()
	end)
end

local function GetSpellInfos()
	spell.Throw.Name = GetSpellInfo(2764)
	spell.AutoShot.Name = GetSpellInfo(75)
	spell.ScatterShot.Name = GetSpellInfo(19503)
	spell.WingClip.Name = GetSpellInfo(2974)

	spell.Throw.Range = select(9,GetSpellInfo(2764))
	spell.AutoShot.Range = select(9,GetSpellInfo(75))
	spell.ScatterShot.Range = select(9,GetSpellInfo(19503))
	spell.WingClip.Range = select(9,GetSpellInfo(2974))
	maxRange = spell.AutoShot.Range

	local i = 1
	while true do
		local spellName = GetSpellName(i, BOOKTYPE_SPELL)
		if not spellName then
			break
		end
		if spellName == spell.Throw.Name then
			spell.Throw.ID = i
		elseif spellName == spell.AutoShot.Name then
			spell.AutoShot.ID = i
		elseif spellName == spell.WingClip.Name then
			spell.WingClip.ID = i
		elseif spellName == spell.ScatterShot.Name then
			spell.ScatterShot.ID = i
			scatterShot = true
		end
		i = i + 1
	end
end

--	Frame Setup
local function FrameSetup()
	mRange:SetHeight(SettingsDB.Scale(5))
	mRange:SetWidth(SettingsDB.Scale(212))
	mRange:SetPoint("BOTTOM", UIParent, "BOTTOM", 276, SettingsCF.actionbar.rightbars_three == true and 210 or 238)

	bar1 = CreateFrame("Statusbar", nil, mRange)
	bar1:SetAllPoints(mRange)
	bar1:SetFrameLevel(2)
	bar1:SetOrientation("HORIZONTAL")
	bar1:SetMinMaxValues(0, maxRange)
	bar1:SetStatusBarTexture(SettingsCF.media.bar)

	bar1.text = bar1:CreateFontString(nil, 'OVERLAY')
	bar1.text:SetPoint("CENTER")
	bar1.text:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)

	bar2 = CreateFrame("Statusbar", nil, bar1)
	bar2:SetAllPoints(bar1)
	bar2:SetFrameLevel(1)
	bar2:SetOrientation("HORIZONTAL")
	bar2:SetMinMaxValues(0, maxRange)
	bar2:SetStatusBarTexture(SettingsCF.media.bar)

	bar2.bg = bar2:CreateTexture(nil, "BACKGROUND")
	bar2.bg:SetAllPoints(bar2)
	bar2.bg:SetTexture(SettingsCF.media.blank)
	bar2.bg:SetVertexColor(0.15, 0.15, 0.15)

	bar2.backdrop = SettingsDB.CreateShadowFrame(bar2, 1, "BACKGROUND")
	bar2.backdrop:SetPoint("TOPLEFT", SettingsDB.Scale(-3), SettingsDB.Scale(3))
	bar2.backdrop:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(3), SettingsDB.Scale(-3))
end

--	Handler
function mRange:OnUpdate_Bars()
	if UnitName("target") then
		if IsSpellInRange(spell.WingClip.ID, "target") == 1 then -- Wing Clip
			bar1:SetValue(0)
			bar2:SetValue(0)
			bar1.text:SetText("Melee")
			bar1.text:SetTextColor(unpack(mRangecolors.melee))
		elseif CheckInteractDistance("target", 3) == 1 then -- Duel distance: 9,9m... Made it 10m :P
			bar1:SetValue(5)
			bar2:SetValue(10)
			bar1.text:SetText("5m - 10m")
			bar1.text:SetTextColor(1, 1, 1)
			bar1:SetStatusBarColor(unpack(mRangecolors.low))
			bar2:SetStatusBarColor(unpack(mRangecolors.low))
		elseif scatterShot and IsSpellInRange(spell.ScatterShot.ID, "target") == 1 then -- Scatter Shot
			bar1:SetValue(10)
			bar2:SetValue(spell.ScatterShot.Range)
			bar1.text:SetText("10m - "..spell.ScatterShot.Range.."m")
			bar1.text:SetTextColor(1, 1, 1)
			bar1:SetStatusBarColor(unpack(mRangecolors.mid))
			bar2:SetStatusBarColor(unpack(mRangecolors.mid))
		elseif IsSpellInRange(spell.Throw.ID, "target") == 1 then -- Throw
			if scatterShot then
				bar1:SetValue(spell.ScatterShot.Range)
				bar1.text:SetText(spell.ScatterShot.Range.."m - "..spell.Throw.Range.."m")
			else
				bar1:SetValue(10)
				bar1.text:SetText("10m - "..spell.Throw.Range.."m")
			end
			bar1.text:SetTextColor(1, 1, 1)
			bar2:SetValue(spell.Throw.Range)
			bar1:SetStatusBarColor(unpack(mRangecolors.mid))
			bar2:SetStatusBarColor(unpack(mRangecolors.mid))
		elseif IsSpellInRange(spell.AutoShot.ID, "target") == 1 then -- Auto Shot
			bar1:SetValue(spell.Throw.Range)
			bar2:SetValue(maxRange)
			bar1.text:SetText("30m - "..maxRange.."m")
			bar1.text:SetTextColor(1, 1, 1)
			bar1:SetStatusBarColor(unpack(mRangecolors.opt))
			bar2:SetStatusBarColor(unpack(mRangecolors.opt))
		else
			bar1:SetValue(maxRange)
			bar2:SetValue(maxRange)
			bar1.text:SetText("OOR")
			bar1.text:SetTextColor(1, 1, 1)
			bar1:SetStatusBarColor(unpack(mRangecolors.oor))
			bar2:SetStatusBarColor(unpack(mRangecolors.oor))
		end
		bar2:SetAlpha(0.6)
	end
end

function mRange:PLAYER_TARGET_CHANGED()
	-- Ugly workaround for a max range bug: Even after PLAYER_ALIVE on login, GetSpellInfo returns the untalented value. 
	-- So we re-check our max range when we target something for the first time.
	if not count then
		GetSpellInfos()
		if bar1 then
			bar1:SetMinMaxValues(0, maxRange)
			bar2:SetMinMaxValues(0, maxRange)
		end
		count = true
	end

	if UnitName("target") and not UnitIsFriend("player", "target") and not UnitIsDead("target") then
		mRange:Show()
	else
		mRange:Hide()
	end
end

function mRange:CHARACTER_POINTS_CHANGED()
	GetSpellInfos()
	bar1:SetMinMaxValues(0, maxRange)
	bar2:SetMinMaxValues(0, maxRange)
end

function mRange:PLAYER_LOGIN()
	--GetSpellInfos()
	FrameSetup()
end

--	Events/Scripts
SetupScripts()
