﻿----------------------------------------------------------------------------------------
-- 掷点框体 (基于teksLoot by Tekkub)
----------------------------------------------------------------------------------------
if not SettingsCF.loot.roll_frame == true then return end

local backdrop = ({
	bgFile = SettingsCF.media.blank,
	edgeFile = SettingsCF.media.blank,
	tile = true, tileSize = 0, edgeSize = SettingsDB.mult,
	insets = {left = -SettingsDB.mult, right = -SettingsDB.mult, top = -SettingsDB.mult, bottom = -SettingsDB.mult},
})

local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollid, frame.rolltype)
end

local function HideTip() GameTooltip:Hide() end
local function HideTip2() GameTooltip:Hide(); ResetCursor() end

local rolltypes = {"need", "greed", [0] = "pass"}
local function SetTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetText(frame.tiptext)
	if frame:IsEnabled() == 0 then GameTooltip:AddLine("|cffff3333"..L_LOOT_CANNOT) end
	for name,roll in pairs(frame.parent.rolls) do if roll == rolltypes[frame.rolltype] then GameTooltip:AddLine(name, 1, 1, 1) end end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(self)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	CursorOnUpdate(self)
end

local function LootClick(frame)
	if IsControlKeyDown() then DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then ChatEdit_InsertLink(frame.link) end
end

local cancelled_rolls = {}
local function OnEvent(frame, event, rollid)
	cancelled_rolls[rollid] = true
	if frame.rollid ~= rollid then return end

	frame.rollid = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	local t = GetLootRollTimeLeft(frame.parent.rollid)
	local perc = t / frame.parent.time
	frame:SetValue(t)
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetWidth(SettingsDB.Scale(28))
	f:SetHeight(SettingsDB.Scale(28))
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", HideTip)
	f:SetScript("OnClick", ClickRoll)
	--f:SetMotionScriptsWhileDisabled(true)
	local txt = f:CreateFontString(nil, nil)
	txt:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	txt:SetPoint("CENTER", 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
	return f, txt
end

local function CreateRollFrame()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetWidth(SettingsDB.Scale(328))
	frame:SetHeight(SettingsDB.Scale(22))
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("LEFT", SettingsDB.Scale(-25), 0)
	button:SetWidth(SettingsDB.Scale(22))
	button:SetHeight(SettingsDB.Scale(22))
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", HideTip2)
	button:SetScript("OnUpdate", ItemOnUpdate)
	button:SetScript("OnClick", LootClick)

	frame.button = button

	local buttonborder = CreateFrame("Frame", nil, button)
	buttonborder:SetWidth(SettingsDB.Scale(22))
	buttonborder:SetHeight(SettingsDB.Scale(22))
	buttonborder:SetPoint("CENTER", button, "CENTER")
	buttonborder:SetBackdrop(backdrop)
	buttonborder:SetBackdropColor(1, 1, 1, 0)

	local buttonborder2 = CreateFrame("Frame", nil, button)
	buttonborder2:SetWidth(SettingsDB.Scale(24))
	buttonborder2:SetHeight(SettingsDB.Scale(24))
	buttonborder2:SetFrameLevel(buttonborder:GetFrameLevel() + 1)
	buttonborder2:SetPoint("CENTER", button, "CENTER")
	buttonborder2:SetBackdrop(backdrop)
	buttonborder2:SetBackdropColor(0, 0, 0, 0)
	buttonborder2:SetBackdropBorderColor(0, 0, 0, 1)
	frame.buttonborder = buttonborder

	local status = CreateFrame("StatusBar", nil, frame)
	status:SetWidth(SettingsDB.Scale(326))
	status:SetHeight(SettingsDB.Scale(20))
	status:SetPoint("TOPLEFT", SettingsDB.Scale(2), SettingsDB.Scale(-2))
	status:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-2), SettingsDB.Scale(2))
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel() - 1)
	status:SetStatusBarTexture(SettingsCF.media.bar)
	status:SetStatusBarColor(0.8, 0.8, 0.8, 0.9)
	status.parent = frame
	frame.status = status

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "LEFT", frame.button, "RIGHT", 5, -1)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, -1)
	local de, detext
	--de, detext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-DE-Up", "Interface\\Buttons\\UI-GroupLoot-DE-Highlight", "Interface\\Buttons\\UI-GroupLoot-DE-Down", 3, ROLL_DISENCHANT, "LEFT", greed, "RIGHT", 0, -1)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", de or greed, "RIGHT", 0, 2.2)
	--frame.needbutt, frame.greedbutt = need, greed
	frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, detext

	local bind = frame:CreateFontString()
	bind:SetPoint("LEFT", pass, "RIGHT", SettingsDB.Scale(3), SettingsDB.Scale(1))
	bind:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	frame.fsbind = bind

	local loot = frame:CreateFontString(nil, "ARTWORK")
	loot:SetFont(SettingsCF.media.font, SettingsCF.loot.font_size, SettingsCF.media.font_style)
	loot:SetPoint("LEFT", bind, "RIGHT", 0, 0)
	loot:SetPoint("RIGHT", frame, "RIGHT", SettingsDB.Scale(-5), 0)
	loot:SetHeight(SettingsDB.Scale(10))
	loot:SetWidth(SettingsDB.Scale(200))
	loot:SetJustifyH("LEFT")
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local anchor = CreateFrame("Button", nil, UIParent)
anchor:SetWidth(SettingsDB.Scale(300))
anchor:SetHeight(SettingsDB.Scale(20))
anchor:SetBackdrop(backdrop)
anchor:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
anchor:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))

local label = anchor:CreateFontString(nil, "ARTWORK")
label:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
label:SetPoint("CENTER", anchor, 0, SettingsDB.Scale(1))
label:SetText("Group loot frame")

anchor:SetScript("OnClick", anchor.Hide)
anchor:SetScript("OnDragStart", anchor.StartMoving)
anchor:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	self.db.x, self.db.y = self:GetCenter()
end)
anchor:SetMovable(true)
anchor:EnableMouse(true)
anchor:RegisterForDrag("LeftButton")
anchor:RegisterForClicks("RightButtonUp")
anchor:Hide()

local frames = {}

local f = CreateRollFrame() -- Create one for good measure
f:SetPoint("BOTTOMLEFT", next(frames) and frames[#frames] or anchor, "TOPLEFT", 0, SettingsDB.Scale(4))
table.insert(frames, f)

local function GetFrame()
	for i,f in ipairs(frames) do
		if not f.rollid then return f end
	end

	local f = CreateRollFrame()
	f:SetPoint("BOTTOMLEFT", next(frames) and frames[#frames] or anchor, "TOPLEFT", 0, SettingsDB.Scale(4))
	table.insert(frames, f)
	return f
end


local function START_LOOT_ROLL(rollid, time)
	if cancelled_rolls[rollid] then return end

	local f = GetFrame()
	f.rollid = rollid
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)
	--f.disenchant:SetText(0)

	local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollid)
	f.button:SetNormalTexture(texture)
	f.button.link = GetLootRollItemLink(rollid)

	--if canNeed then f.needbutt:Enable() else f.needbutt:Disable() end
	--if canGreed then f.greedbutt:Enable() else f.greedbutt:Disable() end
	--if canDisenchant then f.disenchantbutt:Enable() else f.disenchantbutt:Disable() end
	--SetDesaturation(f.needbutt:GetNormalTexture(), not canNeed)
	--SetDesaturation(f.greedbutt:GetNormalTexture(), not canGreed)
	--SetDesaturation(f.disenchantbutt:GetNormalTexture(), not canDisenchant)

	f.fsbind:SetText(bop and "BoP" or "BoE")
	f.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetVertexColor(color.r, color.g, color.b)
	f.fsloot:SetText(name)

	f:SetBackdropBorderColor(color.r, color.g, color.b, 1)
	f.buttonborder:SetBackdropBorderColor(color.r, color.g, color.b, 1)
	f.status:SetStatusBarColor(color.r, color.g, color.b, .7)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:SetPoint("CENTER", WorldFrame, "CENTER")
	f:Show()
end

local locale = GetLocale()
local rollpairs = locale == "zhCN" and {
	["(.*)自动放弃了(.+)，因为他无法拾取该物品。"]  = "pass",
	["(.*)自动放弃了(.+)，因为她无法拾取该物品。"]  = "pass",
	["(.*)放弃了：(.+)"] = "pass",
	["(.*)选择了贪婪取向：(.+)"] = "greed",
	["(.*)选择了需求取向：(.+)"] = "need",		
} or locale == "zhTW" and {
	["(.*)自動放棄:(.+)，因為"]  = "pass",
	["(.*)放棄了:(.+)"] = "pass",
	["(.*)選擇了貪婪優先:(.+)"] = "greed",
	["(.*)選擇了需求優先:(.+)"] = "need",
	--["(.*)選擇分解:(.+)"] = "disenchant",
} or {
	["^(.*) automatically passed on: (.+) because s?he cannot loot that item.$"] = "pass",
	["^(.*) passed on: (.+|r)$"]  = "pass",
	["(.*) has selected Greed for: (.+)"] = "greed",
	["(.*) has selected Need for: (.+)"]  = "need",
	--["(.*) has selected Disenchant for: (.+)"]  = "disenchant",
}
local EVERY_ONE = (locale == "zhCN") and "所有人" or (locale == "zhTW") and "所有人" or "Everyone"
local function ParseRollChoice(msg)
	for i,v in pairs(rollpairs) do
		local _, _, playername, itemname = string.find(msg, i)
--		if locale == "zhCN" and (v == "greed" or v == "need" or v == "disenchant")  then 
--			local temp = playername
--			playername = itemname
--			itemname = temp
--		end 
		if playername and itemname and playername ~= EVERY_ONE then return playername, itemname, v end
	end
end

local function CHAT_MSG_LOOT(msg)
	local playername, itemname, rolltype = ParseRollChoice(msg)
	if playername and itemname and rolltype then
		for _,f in ipairs(frames) do
			if f.rollid and f.button.link == itemname and not f.rolls[playername] then
				f.rolls[playername] = rolltype
				f[rolltype]:SetText(tonumber(f[rolltype]:GetText()) + 1)
				return
			end
		end
	end
end

anchor:RegisterEvent("ADDON_LOADED")
anchor:SetScript("OnEvent", function(frame, event, addon)
	if addon ~= "meatUI" then return end
	anchor:UnregisterEvent("ADDON_LOADED")
	anchor:RegisterEvent("START_LOOT_ROLL")
	anchor:RegisterEvent("CHAT_MSG_LOOT")
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")

	anchor:SetScript("OnEvent", function(frame, event, ...) if event == "CHAT_MSG_LOOT" then return CHAT_MSG_LOOT(...) else return START_LOOT_ROLL(...) end end)

	anchor:SetPoint(unpack(SettingsCF.position.group_loot))
end)

SlashCmdList["TEKSLOOT"] = function() if anchor:IsVisible() then anchor:Hide() else anchor:Show() end end
SLASH_TEKSLOOT1 = "/teksloot"