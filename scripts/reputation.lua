----------------------------------------------------------------------------------------
-- 优化显示声望获得信息 (by sonic)
----------------------------------------------------------------------------------------
local SR_REP_MSG = "%s: %+d (%d/%d)"
local rep = {}

local function SR_Update(self)
	local numFactions = GetNumFactions()

	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i)
		if (not isHeader) or (hasRep) then
			if not rep[name] then
				rep[name] = barValue
			end

			local change = barValue - rep[name]
			if (change > 0) then
				rep[name] = barValue
				local msg = string.format(SR_REP_MSG, name, change, barValue - barMin, barMax - barMin)
				
				local info = ChatTypeInfo["COMBAT_FACTION_CHANGE"]
				for j = 1, 4, 1 do
					local chatfrm = getglobal("ChatFrame"..j)
					for k,v in pairs(chatfrm.messageTypeList) do
						if v == "COMBAT_FACTION_CHANGE" then
							chatfrm:AddMessage(msg, info.r, info.g, info.b, info.id)
							break
						end
					end
				end
			end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_FACTION")
frame:SetScript("OnEvent", SR_Update)
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", function() return true; end)

----------------------------------------------------------------------------------------
-- Shift+点击粘贴声望(LonnyRepLink by Lonny)
----------------------------------------------------------------------------------------
function ReputationBar_OnClick(self)
	if ReputationDetailFrame:IsShown() and GetSelectedFaction() == self.index then
		ReputationDetailFrame:Hide()
	else
		if self.hasRep then
			if IsModifierKeyDown() then
				local name, _, standingID, barMin, barMax, barValue = GetFactionInfo(self.index)
				barMax = barMax - barMin
				barValue = barValue - barMin
				local gender = UnitSex("player")
				local standing = GetText("FACTION_STANDING_LABEL"..standingID, gender)
				local percent = ceil((barValue / barMax) * 100)
				ChatFrame_OpenChat(format("%s (%s): %d / %d (%d%%)", name, standing, barValue, barMax, percent))
			else
				SetSelectedFaction(self.index)
				ReputationDetailFrame:Show()
				ReputationFrame_Update()
			end
		end
	end
end
