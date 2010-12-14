----------------------------------------------------------------------------------------
-- 聊天框 (基于idChat)
----------------------------------------------------------------------------------------
if SettingsCF.chat.enable ~= true then return end

-- 全局频道
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h["..L_CHAT_GUILD.."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h["..L_CHAT_PARTY.."]|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h["..L_CHAT_PARTY_LEADER.."]|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = CHAT_PARTY_LEADER_GET
_G.CHAT_RAID_GET = "|Hchannel:raid|h["..L_CHAT_RAID.."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h["..L_CHAT_RAID_LEADER.."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "["..L_CHAT_RAID_WARNING.."] %s:\32"
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h["..L_CHAT_BATTLEGROUND.."]|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h["..L_CHAT_BATTLEGROUND_LEADER.."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h["..L_CHAT_OFFICER.."]|h %s:\32"
_G.ACHIEVEMENT_BROADCAST = "%s! %s!"
_G.ACHIEVEMENT_BROADCAST_SELF = "%s!"
_G.PLAYER_SERVER_FIRST_ACHIEVEMENT = "|Hplayer:%s|h[%s]|h! $a!"
_G.SERVER_FIRST_ACHIEVEMENT = "%s! $a!"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "[AFK] "
_G.CHAT_FLAG_DND = "[DND] "
_G.CHAT_FLAG_GM = "|cff4154F5[GM]|r "
if SettingsDB.client == "ruRU" then
	_G.FACTION_STANDING_DECREASED = "Отношение |3-7(%s) -%d."
	_G.FACTION_STANDING_INCREASED = "Отношение |3-7(%s) +%d."
end
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L_CHAT_COME_ONLINE_COLOR
_G.ERR_FRIEND_OFFLINE_S = "%s "..L_CHAT_GONE_OFFLINE_COLOR

----------------------------------------------------------------------------------------
--	Custom timestamps color
----------------------------------------------------------------------------------------
--[[	no use in 3.2.x
TIMESTAMP_FORMAT_HHMM = "|cff"..SettingsCF.chat.time_color.."[%I:%M]|r "
TIMESTAMP_FORMAT_HHMMSS = "|cff"..SettingsCF.chat.time_color.."[%I:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff"..SettingsCF.chat.time_color.."[%H:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff"..SettingsCF.chat.time_color.."[%I:%M:%S %p]|r "
TIMESTAMP_FORMAT_HHMM_24HR = "|cff"..SettingsCF.chat.time_color.."[%H:%M]|r "
TIMESTAMP_FORMAT_HHMM_AMPM = "|cff"..SettingsCF.chat.time_color.."[%I:%M %p]|r "
]]

local AddOn = CreateFrame("Frame")
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
AddOn:SetScript("OnEvent", OnEvent)

local player = UnitName("player")
local ChatFrameEditBox = ChatFrameEditBox
local ChatFrame1 = ChatFrame1
local _G = _G
local replace = string.gsub
local find = string.find

local keywords = {
	["肉嘎嘎思密达"] = "|cFFF58CBA",
	["牛粑粑思密达"] = "|cFFFF7D0A",
	["阿格拉伊亚"] = "|cFF69CCF0",
	["射啦囧"] = "|cFFABD473",
}

local replaceschan = {
	["(%d+)%. .-"] = "[%1]",
}

-- 输入框背景
local x=({ChatFrameEditBox:GetRegions()})
x[6]:SetAlpha(0)
x[7]:SetAlpha(0)
x[8]:SetAlpha(0)

-- 玩家进入世界
local function PLAYER_ENTERING_WORLD()
	local TimeNotAtBottom = { }

	ChatFrameMenuButton:SetAlpha(0)
	ChatFrameMenuButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, 130)
	ChatFrameMenuButton:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	ChatFrameMenuButton:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

	for i = 1, NUM_CHAT_WINDOWS do
		-- 隐藏聊天框按钮
		_G["ChatFrame"..i.."UpButton"]:Hide()
		_G["ChatFrame"..i.."DownButton"]:Hide()
		_G["ChatFrame"..i.."BottomButton"]:Hide()
		_G["ChatFrame"..i.."UpButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."DownButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."BottomButton"]:SetScript("OnShow", function(self) self:Hide() end)

		-- 标签样式
		_G["ChatFrame"..i.."TabFlash"]:GetRegions():SetTexture(nil)
		_G["ChatFrame"..i.."Tab"]:GetHighlightTexture():SetTexture(nil)
		_G["ChatFrame"..i.."TabLeft"]:Hide()
		_G["ChatFrame"..i.."TabMiddle"]:Hide()
		_G["ChatFrame"..i.."TabRight"]:Hide()
		_G["ChatFrame"..i.."Tab"]:SetBackdrop({bgFile = SettingsCF.media.blank, level = "0", insets = {top = 14, left = 0, bottom = 2, right = 4}})
		_G["ChatFrame"..i.."Tab"]:SetBackdropColor(0, 0, 0, 0.6)

		-- 禁用标签闪烁
		FCF_FlashTab = function() end

		-- 隐藏聊天框背板
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end

		-- 停用聊天框渐隐
		_G["ChatFrame"..i]:SetFading(false)

		-- 改变聊天字体
		if SettingsCF.chat.font_outline == true then
			_G["ChatFrame"..i]:SetFont(SettingsCF.media.font, SettingsCF.chat.font_size, "OUTLINE")
		else
			_G["ChatFrame"..i]:SetFont(SettingsCF.media.font, SettingsCF.chat.font_size)
		end

		-- 聊天框允许鼠标滚轮
		-- 30秒后强制聊天内容翻至底部
		TimeNotAtBottom[i] = 0
		_G["ChatFrame"..i]:SetScript("OnMouseWheel", function(self, ...)
			if arg1 > 0 then
				if IsShiftKeyDown() then
					self:ScrollToTop()
				elseif IsControlKeyDown() then
					self:PageUp()
				else
					self:ScrollUp()
				end
				TimeNotAtBottom[i] = 0
				self:SetScript("OnUpdate", function(self, t)
					if TimeNotAtBottom[i] < 30 then
						TimeNotAtBottom[i] = TimeNotAtBottom[i] + t
					else
						self:ScrollToBottom()
						self:SetScript("OnUpdate", nil)
					end
				end)
			elseif arg1 < 0 then
				if IsShiftKeyDown() then
					self:ScrollToBottom()
					self:SetScript("OnUpdate", nil)
				elseif IsControlKeyDown() then
					self:PageDown()
					self:SetScript("OnUpdate", nil)
				else
					self:ScrollDown()
					if self:AtBottom() then
						self:SetScript("OnUpdate", nil)
					else
						TimeNotAtBottom[i] = 0
					end
				end
			end
		end)
		_G["ChatFrame"..i]:EnableMouseWheel(true)
		_G["ChatFrame"..i]:SetFrameStrata("LOW")
		_G["ChatFrame"..i]:SetUserPlaced(true)
	end

	-- 记忆最后使用的频道
	ChatTypeInfo.SAY.sticky = 1
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.BATTLEGROUND.sticky = 1
	ChatTypeInfo.WHISPER.sticky = 0
	--ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1

	-- 美化并定位聊天输入框
	for i=6,8 do select(i, ChatFrameEditBox:GetRegions()):Hide() end

	local editbox = CreateFrame("Button", nil, ChatFrameEditBox)
		editbox:SetBackdrop(GameTooltip:GetBackdrop())
		editbox:SetPoint("TOPLEFT", "ChatFrameEditBoxLeft", "TOPLEFT", 1, -4)
		editbox:SetPoint("BOTTOMRIGHT", "ChatFrameEditBoxRight", "BOTTOMRIGHT", -1, 2)
		editbox:SetFrameLevel(ChatFrameEditBox:GetFrameLevel()-1)

	local chatborder = CreateFrame("Button", nil, ChatFrameEditBox)
		chatborder:SetBackdrop(GameTooltip:GetBackdrop())
		chatborder:SetPoint("TOPLEFT", "ChatFrame1ResizeTopLeft")
		chatborder:SetPoint("BOTTOMRIGHT", "ChatFrame1ResizeBottomRight")
		chatborder:SetBackdropColor(0,0,0,0)
		chatborder:EnableMouse(false)

	ChatFrameEditBoxLanguage:Hide()

	local function colorize(r,g,b)
		editbox:SetBackdropBorderColor(r,g,b,1)
		chatborder:SetBackdropBorderColor(r,g,b,1)
		chatborder:Show()
		editbox:SetBackdropColor(r/3,g/3,b/3,0.8)
	end

	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = DEFAULT_CHAT_FRAME.editBox:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
			local id = GetChannelName(DEFAULT_CHAT_FRAME.editBox:GetAttribute("channelTarget"))
			if id == 0 then
				colorize(0.5,0.5,0.5)
			else
				colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		else
			colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)

	if SettingsCF.chat.input_top == true then
		ChatFrameEditBox:ClearAllPoints()
		ChatFrameEditBox:SetPoint("BOTTOMLEFT",  "ChatFrame1", "TOPLEFT",  -5, 2)
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", "ChatFrame1", "TOPRIGHT", 5, 2)
	else
		ChatFrameEditBox:ClearAllPoints()
		ChatFrameEditBox:SetPoint("TOPLEFT",  "ChatFrame1", "BOTTOMLEFT",  -5, 0)
		ChatFrameEditBox:SetPoint("TOPRIGHT", "ChatFrame1", "BOTTOMRIGHT", 5, 0)
	end

	-- 禁用游戏自带的alt键功能
	ChatFrameEditBox:SetAltArrowKeyMode(false)

	-- Tab键切换频道
	function ChatEdit_CustomTabPressed()
		if (this:GetAttribute("chatType") == "SAY") then
			if (GetNumPartyMembers()>0) then
				this:SetAttribute("chatType", "PARTY");
				ChatEdit_UpdateHeader(this);
			elseif (GetNumRaidMembers()>0) then
				this:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(this);
			elseif (GetNumBattlefieldScores()>0) then
				this:SetAttribute("chatType", "BATTLEGROUND");
				ChatEdit_UpdateHeader(this);
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(this);
			else
				return;
			end
		elseif (this:GetAttribute("chatType") == "PARTY") then
			if (GetNumRaidMembers()>0) then
				this:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(this);
			elseif (GetNumBattlefieldScores()>0) then
				this:SetAttribute("chatType", "BATTLEGROUND");
				ChatEdit_UpdateHeader(this);
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(this);
			else
				this:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(this);
			end
		elseif (this:GetAttribute("chatType") == "RAID") then
			if (GetNumBattlefieldScores()>0) then
				this:SetAttribute("chatType", "BATTLEGROUND");
				ChatEdit_UpdateHeader(this);
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(this);
			else
				this:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(this);
			end
		elseif (this:GetAttribute("chatType") == "BATTLEGROUND") then
			if (IsInGuild) then
				this:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(this);
			else
				this:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(this);
			end
		elseif (this:GetAttribute("chatType") == "GUILD") then
			this:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(this);
		elseif (this:GetAttribute("chatType") == "CHANNEL") then
			if (GetNumPartyMembers()>0) then
				this:SetAttribute("chatType", "PARTY");
				ChatEdit_UpdateHeader(this);
			elseif (GetNumRaidMembers()>0) then
				this:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(this);
			elseif (GetNumBattlefieldScores()>0) then
				this:SetAttribute("chatType", "BATTLEGROUND");
				ChatEdit_UpdateHeader(this);
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(this);
			else
				this:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(this);
			end
		end
	end

	-- 定位"综合"聊天框
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint(unpack(SettingsCF.position.chat))
	ChatFrame1:SetWidth(SettingsCF.chat.width)
	ChatFrame1:SetHeight(SettingsCF.chat.height)
end
AddOn:RegisterEvent("PLAYER_ENTERING_WORLD")
AddOn["PLAYER_ENTERING_WORLD"] = PLAYER_ENTERING_WORLD

-- 获取玩家职业颜色
local function ClassColors(class)
	if not class then return end
	class = (replace(class, " ", "")):upper()
	local c = RAID_CLASS_COLORS[class]
	if c then
		return string.format("%02x%02x%02x", c.r*255, c.g*255, c.b*255)
	end
end

-- 玩家登录
local function CHAT_MSG_SYSTEM(...)
	local login = select(3, find(arg1, "^|Hplayer:(.+)|h%[(.+)%]|h "..L_CHAT_COME_ONLINE))
	--local classColor = "999999"
	--local foundColor = true

	if login then
		local found = false
		if GetNumFriends() > 0 then ShowFriends() end
		
		for friendIndex = 1, GetNumFriends() do
			local friendName, _, class = GetFriendInfo(friendIndex)
			if friendName == login then
				classColor = ClassColors(class)
				found = true
				break
			end
		end
		
		if not found then
			if IsInGuild() then GuildRoster() end
			for guildIndex = 1, GetNumGuildMembers(true) do
				local guildMemberName, _, _, _, _, _, _, _, _, _, class = GetGuildRosterInfo(guildIndex)
				if guildMemberName == login then
					classColor = ClassColors(class)
					break
				end
			end
		end
		
	end
	
	if login then
		-- Hook the message function
		local AddMessageOriginal = ChatFrame1.AddMessage
		local function AddMessageHook(frame, text, ...)
			text = replace(text, "^|Hplayer:(.+)|h%[(.+)%]|h", "|Hplayer:%1|h|cff"..classColor.."%2|r|h")
			ChatFrame1.AddMessage = AddMessageOriginal
			return AddMessageOriginal(frame, text, ...)
		end
		ChatFrame1.AddMessage = AddMessageHook
	end
end
AddOn:RegisterEvent("CHAT_MSG_SYSTEM")
AddOn["CHAT_MSG_SYSTEM"] = CHAT_MSG_SYSTEM

-- Hook into the AddMessage function
local function AddMessageHook(frame, text, ...)
	-- 简化或隐藏频道名
	for k,v in pairs(replaceschan) do
		text = text:gsub("|h%["..k.."%]|h", "|h"..v.."|h")
	end

	-- 聊天高亮
	text = replace(text, L_CHAT_COME_ONLINE, L_CHAT_COME_ONLINE_COLOR)
	text = replace(text, L_CHAT_GONE_OFFLINE, L_CHAT_GONE_OFFLINE_COLOR)

	if find(text, replace(ERR_AUCTION_SOLD_S, "%%s", "")) then
		local itemname = text:match(replace(ERR_AUCTION_SOLD_S, "%%s", "(.+)"))
		text = "|cffef4341"..BUTTON_LAG_AUCTIONHOUSE.."|r - |cffBCD8FF"..ITEM_SOLD_COLON.."|r "
		local _, solditem = GetItemInfo(itemname)
		if solditem then
			text = text..solditem
		else
			text = text..itemname
		end
	end

	if SettingsCF.chat.time_stamps == true then
		text = "|cff0276FD" .. date("[%H:%M]") .. "|r " .. text
	end

	return AddMessageOriginal(frame, text, ...)
end

function SettingsDB.ChannelsEdits()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local frame = _G["ChatFrame"..i]
			AddMessageOriginal = frame.AddMessage
			frame.AddMessage = AddMessageHook
		end
	end
end
SettingsDB.ChannelsEdits()

-- 复制URL
local color = "00ff00"
local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

function string.color(text, color)
	return "|cff"..color..text.."|r"
end

function string.link(text, type, value, color)
	return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end

StaticPopupDialogs["LINKME"] = {
	text = L_CHAT_URL,
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = true,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function f(url)
	return string.link("["..url.."]", "url", url, color)
end

local function hook(self, text, ...)
	self:f(text:gsub(pattern, f), ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	if ( i ~= 2 ) then
		local frame = _G["ChatFrame"..i]
		frame.f = frame.AddMessage
		frame.AddMessage = hook
	end
end

local f = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(self, link, text, button)
	local type, value = link:match("(%a+):(.+)")
	if ( type == "url" ) then
		local dialog = StaticPopup_Show("LINKME")
		local editbox = _G[dialog:GetName().."WideEditBox"]  
		editbox:SetText(value)
		editbox:SetFocus()
		editbox:HighlightText()
		local button = _G[dialog:GetName().."Button2"]
            
		button:ClearAllPoints()
           
		button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
	else
		f(self, link, text, button)
	end
end

-- 复制聊天内容
local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	SettingsDB.CreateTemplate(frame, 0.6)
	frame:SetWidth(500)
	frame:SetHeight(300)
	frame:SetScale(0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(500)
	editBox:SetHeight(300)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	isf = true
end

local function GetLines(...)
	-- Grab all those 
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

function SettingsDB.ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:SetPoint("BOTTOMRIGHT", 0, 1)
		button:SetHeight(20)
		button:SetWidth(20)
		button:SetAlpha(0)
		SettingsDB.CreateTemplate(button, 0.6)
		button:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)

		local buttontext = button:CreateFontString(nil, "OVERLAY", nil)
		buttontext:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size * 2, SettingsCF.media.font_style)
		buttontext:SetText("C")
		buttontext:SetPoint("CENTER")
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")

		button:SetScript("OnMouseUp", function(self, btn)
			if i == 1 and btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
		button:SetScript("OnEnter", function() SettingsDB.FadeIn(button) end)
		button:SetScript("OnLeave", function() SettingsDB.FadeOut(button) end)
		local tab = _G[format("ChatFrame%dTab", i)]
		tab:SetScript("OnShow", function() button:Show() end)
		tab:SetScript("OnHide", function() button:Hide() end)
	end
end
SettingsDB.ChatCopyButtons()

-- 聊天过滤
if SettingsCF.chat.filter == true then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)
	DUEL_WINNER_KNOCKOUT = ""
	DUEL_WINNER_RETREAT = ""
	DRUNK_MESSAGE_ITEM_OTHER1 = ""
	DRUNK_MESSAGE_ITEM_OTHER2 = ""
	DRUNK_MESSAGE_ITEM_OTHER3 = ""
	DRUNK_MESSAGE_ITEM_OTHER4 = ""
	DRUNK_MESSAGE_OTHER1 = ""
	DRUNK_MESSAGE_OTHER2 = ""
	DRUNK_MESSAGE_OTHER3 = ""
	DRUNK_MESSAGE_OTHER4 = ""
	DRUNK_MESSAGE_ITEM_SELF1 = ""
	DRUNK_MESSAGE_ITEM_SELF2 = ""
	DRUNK_MESSAGE_ITEM_SELF3 = ""
	DRUNK_MESSAGE_ITEM_SELF4 = ""
	DRUNK_MESSAGE_SELF1 = ""
	DRUNK_MESSAGE_SELF2 = ""
	DRUNK_MESSAGE_SELF3 = ""
	DRUNK_MESSAGE_SELF4 = ""
	RAID_MULTI_LEAVE = ""
	RAID_MULTI_JOIN = ""
	ERR_PET_LEARN_ABILITY_S = ""
	ERR_PET_LEARN_SPELL_S = ""
	ERR_PET_SPELL_UNLEARNED_S = ""
end

-- 向目标密语
local function tellTarget(s)
	if not UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player") == GetDefaultLanguage("target") or not (s and s:len()>0) then
		return
	end

	local name, realm = UnitName("target")
	if realm and realm ~= GetRealmName() then
		name = ("%s-%s"):format(name, realm)
	end
	SendChatMessage(s, "WHISPER", nil, name)
end
SlashCmdList["CHATTELLTARGET"] = tellTarget
_G.SLASH_CHATTELLTARGET1 = "/tt"

----------------------------------------------------------------------------------------
-- 频道快捷条 (FavChatBar by Favorit)
----------------------------------------------------------------------------------------
if SettingsCF.chat.chat_bar == true then
	local cbar = CreateFrame("Frame", "favchat", favchat)
	cbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	cbar:RegisterEvent("ADDON_LOADED")

	function cbar:SW(button)
		if(button == "RightButton") then
			ChatFrame_OpenChat("/w ", SELECTED_DOCK_FRAME);		
		else
			ChatFrame_OpenChat("/s ", SELECTED_DOCK_FRAME);	
		end
	end

	function cbar:GO(button)
		if(button == "RightButton") then
			ChatFrame_OpenChat("/o ", SELECTED_DOCK_FRAME);		
		else
			ChatFrame_OpenChat("/g ", SELECTED_DOCK_FRAME);	
		end
	end

	function cbar:RP(button)
		if(button == "RightButton") then
			ChatFrame_OpenChat("/raid ", SELECTED_DOCK_FRAME);		
		else
			ChatFrame_OpenChat("/p ", SELECTED_DOCK_FRAME);	
		end
	end

	function cbar:GT(button)
		if(button == "RightButton") then
			ChatFrame_OpenChat("/2 ", SELECTED_DOCK_FRAME);		
		else
			ChatFrame_OpenChat("/1 ", SELECTED_DOCK_FRAME);	
		end
	end

	function cbar:YG(button)
		if(button == "RightButton") then
			ChatFrame_OpenChat("/y ", SELECTED_DOCK_FRAME);		
		else
			ChatFrame_OpenChat("/3 ", SELECTED_DOCK_FRAME);	
		end
	end

	function cbar:Style()
		favchat:ClearAllPoints()
		favchat:SetParent(UIParent)

		sw = CreateFrame("Button", "sw", favchat)
		sw:ClearAllPoints()
		sw:SetParent(favchat)
		sw:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, SettingsCF.chat.height+12)
		sw:SetWidth(14)
		sw:SetHeight(14)
		SettingsDB.CreateTemplate(sw)
		sw:SetBackdropBorderColor(0.7, 0.33, 0.82, 1)
		sw:RegisterForClicks("AnyUp")
		sw:SetScript("OnClick", cbar.SW)
		swtex = sw:CreateTexture(nil, "ARTWORK")
		swtex:SetTexture(SettingsCF.media.blank)
		swtex:SetVertexColor(0.8, 0.8, 0.8, 1)
		swtex:SetPoint("TOPLEFT", sw, "TOPLEFT", 2, -2)
		swtex:SetPoint("BOTTOMRIGHT", sw, "BOTTOMRIGHT", -2, 2)

		go = CreateFrame("Button", "go", favchat)
		go:ClearAllPoints()
		go:SetParent(favchat)
		go:SetPoint("TOP", sw, "BOTTOM", 0, -10)
		go:SetWidth(14)
		go:SetHeight(14)
		SettingsDB.CreateTemplate(go)
		go:SetBackdropBorderColor(0, 0.54, 0, 1)
		go:RegisterForClicks("AnyUp")
		go:SetScript("OnClick", cbar.GO)
		gotex = sw:CreateTexture(nil, "ARTWORK")
		gotex:SetTexture(SettingsCF.media.blank)
		gotex:SetVertexColor(0, 0.8, 0, 1)
		gotex:SetPoint("TOPLEFT", go, "TOPLEFT", 2, -2)
		gotex:SetPoint("BOTTOMRIGHT", go, "BOTTOMRIGHT", -2, 2)

		rp = CreateFrame("Button", "rp", favchat)
		rp:ClearAllPoints()
		rp:SetParent(favchat)
		rp:SetPoint("TOP", go, "BOTTOM", 0, -10)
		rp:SetWidth(14)
		rp:SetHeight(14)
		SettingsDB.CreateTemplate(rp)
		rp:SetBackdropBorderColor(0.8, 0.4, 0.1, 1)
		rp:RegisterForClicks("AnyUp")
		rp:SetScript("OnClick", cbar.RP)
		rptex = rp:CreateTexture(nil, "ARTWORK")
		rptex:SetTexture(SettingsCF.media.blank)
		rptex:SetVertexColor(0.11, 0.5, 0.7, 1)
		rptex:SetPoint("TOPLEFT", rp, "TOPLEFT", 2, -2)
		rptex:SetPoint("BOTTOMRIGHT", rp, "BOTTOMRIGHT", -2, 2)

		gt = CreateFrame("Button", "gt", favchat)
		gt:ClearAllPoints()
		gt:SetParent(favchat)
		gt:SetPoint("TOP", rp, "BOTTOM", 0, -10)
		gt:SetWidth(14)
		gt:SetHeight(14)
		SettingsDB.CreateTemplate(gt)
		gt:SetBackdropBorderColor(0.7, 0.7, 0, 1)
		gt:RegisterForClicks("AnyUp")
		gt:SetScript("OnClick", cbar.GT)
		gttex = rp:CreateTexture(nil, "ARTWORK")
		gttex:SetTexture(SettingsCF.media.blank)
		gttex:SetVertexColor(0.93, 0.8, 0.8, 1)
		gttex:SetPoint("TOPLEFT", gt, "TOPLEFT", 2, -2)
		gttex:SetPoint("BOTTOMRIGHT", gt, "BOTTOMRIGHT", -2, 2)

		yg = CreateFrame("Button", "yg", favchat)
		yg:ClearAllPoints()
		yg:SetParent(favchat)
		yg:SetPoint("TOP", gt, "BOTTOM", 0, -10)
		yg:SetWidth(14)
		yg:SetHeight(14)
		SettingsDB.CreateTemplate(yg)
		yg:SetBackdropBorderColor(0.7, 0.13, 0.13, 1)
		yg:RegisterForClicks("AnyUp")
		yg:SetScript("OnClick", cbar.YG)
		ygtex = rp:CreateTexture(nil, "ARTWORK")
		ygtex:SetTexture(SettingsCF.media.blank)
		ygtex:SetVertexColor(0.5, 1, 0.83, 1)
		ygtex:SetPoint("TOPLEFT", yg, "TOPLEFT", 2, -2)
		ygtex:SetPoint("BOTTOMRIGHT", yg, "BOTTOMRIGHT", -2, 2)
	end

	function cbar:ADDON_LOADED(event, name)
		self:Style()
	end
end

----------------------------------------------------------------------------------------
-- 收到密语时声音提示 (by Tukz)
----------------------------------------------------------------------------------------
if SettingsCF.chat.whisp_sound == true then
	local SoundSys = CreateFrame("Frame")
	SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
	SoundSys:RegisterEvent("CHAT_MSG_BN_WHISPER")
	SoundSys:HookScript("OnEvent", function(self, event, ...)
		if event == "CHAT_MSG_WHISPER" or "CHAT_MSG_BN_WHISPER" then
			PlaySoundFile(SettingsCF.media.whisp_sound)
		end
	end)
end

----------------------------------------------------------------------------------------
-- 刷屏过滤 (by Evl)
----------------------------------------------------------------------------------------
ChatFrame1.repeatFilter = true
ChatFrame1:SetTimeVisible(10)

local lastMessage
local repeatMessageFilter = function(self, event, text, sender, ...)
	if self.repeatFilter then
		if not self.repeatMessages or self.repeatCount > 100 then
			self.repeatCount = 0
			self.repeatMessages = {}
		end
		lastMessage = self.repeatMessages[sender]
		if lastMessage == text then
			return true
		end
		self.repeatMessages[sender] = text
		self.repeatCount = self.repeatCount + 1
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", repeatMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", repeatMessageFilter)

----------------------------------------------------------------------------------------
-- 屏蔽切换天赋时的聊天刷屏
----------------------------------------------------------------------------------------
if SettingsCF.chat.talent_spam_filter == true then
	local spamFilterMatch1 = string.gsub(ERR_LEARN_ABILITY_S:gsub("%.", "%."), "%%s", "(.*)")
	local spamFilterMatch2 = string.gsub(ERR_LEARN_SPELL_S:gsub("%.", "%."), "%%s", "(.*)")
	local spamFilterMatch3 = string.gsub(ERR_SPELL_UNLEARNED_S:gsub("%.", "%."), "%%s", "(.*)")
	local primarySpecSpellName = GetSpellInfo(63645)
	local secondarySpecSpellName = GetSpellInfo(63644)

	local groupNamesCaps = {
		"Primary",
		"Secondary"
	}

	specCache = {}

	HideSpam = CreateFrame("Frame");
	HideSpam:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	HideSpam:RegisterEvent("UNIT_SPELLCAST_START");
	HideSpam:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");

	HideSpam.filter = function(self, event, msg, ...)
		if strfind(msg, spamFilterMatch1) then
			return true
		elseif strfind(msg, spamFilterMatch2) then
			return true
		elseif strfind(msg, spamFilterMatch3) then
			return true
		end
		return false, msg, ...
	end

	HideSpam:SetScript("OnEvent", function( self, event, ...)
		local unit, spellName = ...

		if(event == "UNIT_SPELLCAST_START") then
			if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
				ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
			end

		elseif(event == "UNIT_SPELLCAST_INTERRUPTED") then
			if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
				ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
			end

		elseif(event == "ACTIVE_TALENT_GROUP_CHANGED") then
			for i = 1, GetNumTalentGroups() do
				specCache[i] = specCache[i] or {}
				local thisCache = specCache[i]
				TalentFrame_UpdateSpecInfoCache(thisCache, false, false, i)
				if thisCache.primaryTabIndex and thisCache.primaryTabIndex ~= 0 then
					thisCache.specName = thisCache[thisCache.primaryTabIndex].name
					thisCache.mainTabIcon = thisCache[thisCache.primaryTabIndex].icon
				elseif thisCache.secondaryTabIndex and thisCache.secondaryTabIndex ~= 0 then
					thisCache.specName = thisCache[thisCache.secondaryTabIndex].name
					thisCache.mainTabIcon = thisCache[thisCache.secondaryTabIndex].icon
				else
					thisCache.specName = "|cffff0000Talents undefined!|r"
					thisCache.mainTabIcon = "Interface\\Icons\\Ability_Seal"
				end
				thisCache.specGroupName = groupNamesCaps[i]
			end

			local activeGroupNum = GetActiveTalentGroup()
			if specCache[activeGroupNum].totalPointsSpent > 1 then
				local s = specCache[activeGroupNum];
				print(L_CHAT_CHANGE.."|cff6adb54".. s.specName .." ("..
				s[1].pointsSpent .."/"..
				s[2].pointsSpent .."/"..
				s[3].pointsSpent ..")|r"..L_CHAT_TALENT)
			end
			ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
		end
	end);
end

----------------------------------------------------------------------------------------
-- 只显示自己的拾取信息 (OnlyMyBadges by Abin/xmeet7)
----------------------------------------------------------------------------------------
local BADGES = {
-- 战场
["20558"] = 1, -- 战歌峡谷荣誉奖章
["20559"] = 1, -- 阿拉希盆地荣誉奖章
["20560"] = 1, -- 奥特兰克山谷荣誉奖章
["29024"] = 1, -- 风暴之眼荣誉奖章
["42425"] = 1, -- 远古海滩荣誉奖章
["47395"] = 1, -- 征服之岛荣誉奖章

-- TBC
["28558"] = 1, -- 幽魂碎片
["29434"] = 1, -- 公正徽章
-- 风暴要塞七武器
["30311"] = 1, -- 迁跃切割者
["30312"] = 1, -- 无尽之刃
["30313"] = 1, -- 瓦解法杖
["30314"] = 1, -- 相位壁垒
["30316"] = 1, -- 毁灭
["30317"] = 1, -- 宇宙灌注者
["30318"] = 1, -- 灵弦长弓
["30319"] = 1, -- 虚空尖刺

-- WLK
["40752"] = 1, -- 英雄纹章
["40753"] = 1, -- 勇气纹章
["43228"] = 1, -- 岩石守卫者的碎片
["43589"] = 1, -- 冬拥湖荣誉奖章
["44990"] = 1, -- 冠军的徽记
["45624"] = 1, -- 征服纹章
["47241"] = 1, -- 凯旋纹章
["49426"] = 1, -- 寒冰纹章
 }

local strreplace = string.gsub
local strfind = string.find
local type = type

local LOOT_MSG = strreplace(LOOT_ITEM, "%%s", "(.+)")
local LOOT_MSG_MULTIPLE = strreplace(strreplace(LOOT_ITEM_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)")

local function BadgesFilter(self, event, text)
	if type(text) == "string" then
		local _, _, name, lnk = strfind(text, LOOT_MSG)
		if not name then
			_, _, name, lnk = strfind(text, LOOT_MSG_MULTIPLE)
		end

		if lnk and name ~= YOU then
			local _, _, id = strfind(lnk, "item:(%d+)")
			if id and BADGES[id] then
				return true
			end
		end	
	end
	return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", BadgesFilter)