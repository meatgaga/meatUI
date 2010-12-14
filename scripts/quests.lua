----------------------------------------------------------------------------------------
-- 任务等级 (yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function questlevel()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end
hooksecurefunc("QuestLog_Update", questlevel)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", questlevel)

----------------------------------------------------------------------------------------
-- 自动接受任务 (idQuestAutomation by Industrial)
----------------------------------------------------------------------------------------
if SettingsCF.misc.auto_quest == true then
	local qauto = CreateFrame("Frame")
	qauto.completed_quests = {}
	qauto.incomplete_quests = {}

	function qauto:canAutomate ()
		if IsShiftKeyDown() then
			return false
		else
			return true
		end
	end

	function qauto:strip_text (text)
		if not text then return end
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r","%1")
		text = text:gsub("%[.*%]%s*","")
		text = text:gsub("(.+) %(.+%)", "%1")
		text = text:trim()
		return text
	end

	function qauto:QUEST_PROGRESS ()
		if not self:canAutomate() then return end
		if IsQuestCompletable() then
			CompleteQuest()
		end
	end

	function qauto:QUEST_LOG_UPDATE ()
		if not self:canAutomate() then return end
		local start_entry = GetQuestLogSelection()
		local num_entries = GetNumQuestLogEntries()
		local title
		local is_complete
		local no_objectives

		self.completed_quests = {}
		self.incomplete_quests = {}

		if num_entries > 0 then
			for i = 1, num_entries do
				SelectQuestLogEntry(i)
				title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
				no_objectives = GetNumQuestLeaderBoards(i) == 0
				if title then
					if is_complete or no_objectives then
						self.completed_quests[title] = true
					else
						self.incomplete_quests[title] = true
					end
				end
			end
		end
		SelectQuestLogEntry(start_entry)
	end

	function qauto:GOSSIP_SHOW ()
		if not self:canAutomate() then return end

		local button
		local text

		for i = 1, 32 do
			button = _G["GossipTitleButton" .. i]
			if button:IsVisible() then
				text = self:strip_text(button:GetText())
				ABCDE={button:GetText(), text}
				if button.type == "Available" then
					button:Click()
				elseif button.type == "Active" then
					if self.completed_quests[text] then
						button:Click()
					end
				end
			end
		end
	end

	function qauto:QUEST_GREETING (...)
		if not self:canAutomate() then return end

		local button
		local text

		for i = 1, 32 do
			button = _G["QuestTitleButton" .. i]
			if button:IsVisible() then
				text = self:strip_text(button:GetText())
				if self.completed_quests[text] then
					button:Click()
				elseif not self.incomplete_quests[text] then
					button:Click()
				end
			end
		end
	end

	function qauto:QUEST_DETAIL ()
		if not self:canAutomate() then return end
		AcceptQuest()
	end

	function qauto:QUEST_COMPLETE (event)
		if not self:canAutomate() then return end
		if GetNumQuestChoices() <= 1 then
			GetQuestReward(QuestFrameRewardPanel.itemChoice)
		end
	end

	function qauto.onevent (self, event, ...)
		if self[event] then
			self[event](self, ...)
		end
	end

	qauto:SetScript("OnEvent", qauto.onevent)
	qauto:RegisterEvent("GOSSIP_SHOW")
	qauto:RegisterEvent("QUEST_COMPLETE")
	qauto:RegisterEvent("QUEST_DETAIL")
	qauto:RegisterEvent("QUEST_FINISHED")
	qauto:RegisterEvent("QUEST_GREETING")
	qauto:RegisterEvent("QUEST_LOG_UPDATE")
	qauto:RegisterEvent("QUEST_PROGRESS")

	_G.idQuestAutomation = qauto
end

----------------------------------------------------------------------------------------
-- 高亮已完成任务图标(问号)
----------------------------------------------------------------------------------------
if SettingsCF.misc.quest_icon == true then
	local _G = getfenv(0)

	-- Tries to deal with incompatabilities that other mods cause
	local function stripStupid(text)
		if( not text ) then
			return nil
		end
		
		-- Strip [<level crap>] <quest title>
		text = string.gsub(text, "%[(.+)%]", "")
		-- Strip color codes
		text = string.gsub(text, "|c%x%x%x%x%x%x%x%x(.+)|r", "%1")
		-- Strip (low level) at the end of a quest
		text = string.gsub(text, "(.+) %((.+)%)", "%1")
		
		text = string.trim(text)
		text = string.lower(text)
		return text
	end

	function checkQuestText(buttonText, texture)
		buttonText = stripStupid(buttonText)
		
		for i=1, GetNumQuestLogEntries() do
			local questName, _, _, _, _, _, isComplete = GetQuestLogTitle(i)
			
			if( buttonText == stripStupid(questName) ) then
				if( ( isComplete and isComplete > 0 ) or GetNumQuestLeaderBoards(i) == 0 ) then
					SetDesaturation(texture, nil)
					return
				end
				break
			end
		end

		SetDesaturation(texture, true)
	end

	local function updateGossipIcons()
		if( not GossipFrame:IsVisible() ) then
			return
		end

		for i=1, GossipFrame.buttonIndex do
			local button = _G["GossipTitleButton" .. i]
			if( button:IsVisible() ) then
				if( button.type == "Active" ) then
					checkQuestText(button:GetText(), _G[button:GetName() .. "GossipIcon"])
				else
					SetDesaturation(_G[button:GetName() .. "GossipIcon"], nil)
				end
			end
		end
	end

	local function updateQuestIcons()
		if( not QuestFrameGreetingPanel:IsVisible() ) then
			return
		end

		for i=1, (GetNumActiveQuests() + GetNumAvailableQuests()) do
			local button = _G["QuestTitleButton" .. i]
			if( button:IsVisible() ) then
				if( button.isActive == 1 ) then
					checkQuestText(button:GetText(), (button:GetRegions()))
				else
					SetDesaturation((button:GetRegions()), nil)
				end
			end
		end
	end

	local qiframe = CreateFrame("Frame")
	qiframe:RegisterEvent("QUEST_GREETING")
	qiframe:RegisterEvent("GOSSIP_SHOW")
	qiframe:RegisterEvent("QUEST_LOG_UPDATE")
	qiframe:SetScript("OnEvent", function(self, event)
		updateQuestIcons()
		updateGossipIcons()
	end)
end
