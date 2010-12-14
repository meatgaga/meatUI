----------------------------------------------------------------------------------------
-- System Colors
----------------------------------------------------------------------------------------
FACTION_BAR_COLORS = {
	[1] = {r = 0.64, g = 0.24, b = 0.1},	-- hated		--{r = 0.8, g = 0.3, b = 0.22}
	[2] = {r = 0.8, g = 0.3, b = 0.22},		-- hostile
	[3] = {r = 0.84, g = 0.4, b = 0.3},		-- unfriendly	--{r = 0.75, g = 0.27, b = 0}
	[4] = {r = 0.9, g = 0.7, b = 0},		-- neutral
	[5] = {r = 0, g = 0.6, b = 0.1},		-- friendly
	[6] = {r = 0, g = 1, b = 0.1},		-- honored		--{r = 0, g = 0.6, b = 0.1}
	[7] = {r = 0, g = 1.0, b = 0.8},		-- reverted		--{r = 0, g = 0.6, b = 0.1}
	[8] = {r = 0.6, g = 0.2, b = 0.8},		-- exalted		--{r = 0, g = 0.6, b = 0.1}
}

RAID_CLASS_COLORS = {
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23 },		-- |cffC41F3B
	["DRUID"]       = { r = 1.00, g = 0.49, b = 0.04 },		-- |cffFF7D0A
	["HUNTER"]      = { r = 0.67, g = 0.83, b = 0.45 },		-- |cffABD473
	["MAGE"]        = { r = 0.41, g = 0.80, b = 0.94 },		-- |cff69CCF0
	["PALADIN"]     = { r = 0.96, g = 0.55, b = 0.73 },		-- |cffF58CBA
	["PRIEST"]      = { r = 1.00, g = 0.96, b = 0.98 },		-- |cffFFF5FA
	["ROGUE"]       = { r = 1.00, g = 0.95, b = 0.32 },		-- |cffFFF252
	["SHAMAN"]      = { r = 0.14, g = 0.35, b = 1.00 },		-- |cff2459FF
	["WARLOCK"]     = { r = 0.58, g = 0.51, b = 0.79 },		-- |cff9482C9
	["WARRIOR"]     = { r = 0.78, g = 0.61, b = 0.43 },		-- |cffC79C6E
}

---------------------------------------------------------------------------------------
-- Class color guild/friends/etc list(yClassColor by yleaf)
----------------------------------------------------------------------------------------
local GUILD_INDEX_MAX = 12
local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}
local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local function Hex(r, g, b)
	if(type(r) == "table") then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	
	if(not r or not g or not b) then
		r, g, b = 1, 1, 1
	end
	
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select("#", ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			t[i] = {ColorGradient(i/GUILD_INDEX_MAX, unpack(SMOOTH))}
		end
		return i and t[i] or {1,1,1}
	end
})

local diffColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and GetQuestDifficultyColor(i)
		if not c then return "|cffffffff" end
		t[i] = Hex(c)
		return t[i]
	end
})

local classColorHex = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return "|cffffffff" end
		t[i] = Hex(c)
		return t[i]
	end
})

local classColors = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return {1,1,1} end
		t[i] = {c.r, c.g, c.b}
		return t[i]
	end
})

if CUSTOM_CLASS_COLORS then
	local function callBack()
		wipe(classColorHex)
		wipe(classColors)
	end
	CUSTOM_CLASS_COLORS:RegisterCallback(callBack)
end

local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")
hooksecurefunc("FriendsList_Update", function()
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
	local friendIndex
	local playerArea = GetRealZoneText()
	
	for i=1, FRIENDS_TO_DISPLAY, 1 do
		friendIndex = friendOffset + i
		local name, level, class, area, connected, status, note, RAF = GetFriendInfo(friendIndex)
		local nameText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextName")
		local LocationText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextLocation")
		local infoText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextInfo")
		if not name then return end
		if connected then
			nameText:SetVertexColor(unpack(classColors[class]))
			if area == playerArea then
				area = format("|cff00ff00%s|r", area)
				LocationText:SetFormattedText(FRIENDS_LIST_TEMPLATE, area, status)
			end
			level = diffColor[level] .. level .. "|r"
			infoText:SetFormattedText(FRIENDS_LEVEL_TEMPLATE, level, class)
		else
			return
		end
	end
end)

hooksecurefunc("GuildStatus_Update", function()
	local playerArea = GetRealZoneText()
	
	if ( FriendsFrame.playerStatusFrame ) then
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal("GuildFrameButton"..i.."Name")
				local zoneText = getglobal("GuildFrameButton"..i.."Zone")
				local levelText = getglobal("GuildFrameButton"..i.."Level")
				local classText = getglobal("GuildFrameButton"..i.."Class")
				
				nameText:SetVertexColor(unpack(classColors[class]))
				if playerArea == zone then
					zoneText:SetFormattedText("|cff00ff00%s|r", zone)
				end
				levelText:SetText(diffColor[level] .. level)
			end
		end
	else
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal("GuildFrameGuildStatusButton"..i.."Name")
				nameText:SetVertexColor(unpack(classColors[class]))
				
				local rankText = getglobal("GuildFrameGuildStatusButton"..i.."Rank")
				rankText:SetVertexColor(unpack(guildRankColor[rankIndex]))
			end
		end
	end
end)

hooksecurefunc("WhoList_Update", function()
	local whoIndex
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	
	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo"player"
	local playerRace = UnitRace"player"
	
	for i=1, WHOS_TO_DISPLAY, 1 do
		whoIndex = whoOffset + i
		local nameText = getglobal("WhoFrameButton"..i.."Name")
		local levelText = getglobal("WhoFrameButton"..i.."Level")
		local classText = getglobal("WhoFrameButton"..i.."Class")
		local variableText = getglobal("WhoFrameButton"..i.."Variable")
		
		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(whoIndex)
		if not name then return end
		if zone == playerZone then
			zone = "|cff00ff00" .. zone
		end
		if guild == playerGuild then
			guild = "|cff00ff00" .. guild
		end
		if race == playerRace then
			race = "|cff00ff00" .. race
		end
		local columnTable = { zone, guild, race }
		
		nameText:SetVertexColor(unpack(classColors[class]))
		levelText:SetText(diffColor[level] .. level)
		variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
	end
end)

--[[hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isLeader, isTank, isHealer, isDamage = SearchLFGGetResults(index)
	
	local c = class and classColors[class]
	if c then
		button.name:SetTextColor(unpack(c))
		button.class:SetTextColor(unpack(c))
	end
	if level then
		button.level:SetText(diffColor[level] .. level)
	end
end)]]

hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local index = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame) + i
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
		-- faction: Battlegrounds: Horde = 0, Alliance = 1 / Arenas: Green Team = 0, Yellow Team = 1
		if name then
			local n, r = strsplit("-", name, 2)
			n = classColorHex[classToken] .. n .. "|r"
			if n == SettingsDB.name then
				n = "> " .. n .. " <"
			end
			
			if r then
				local color
				if inArena then
					if faction == 1 then
						color = "|cffffd100"
					else
						color = "|cff19ff19"
					end
				else
					if faction == 1 then
						color = "|cff00adf0"
					else
						color = "|cffff1919"
					end
				end
				r = color .. r .. "|r"
				n = n .. "|cffffffff-|r" .. r
			end
			
			local buttonNameText = getglobal("WorldStateScoreButton" .. i .. "NameText")
			buttonNameText:SetText(n)
		end
	end
end)