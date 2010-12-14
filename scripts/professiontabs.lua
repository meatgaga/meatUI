local AddOn = CreateFrame("Frame")
AddOn:SetScript("OnEvent", function(self, Event, ...) self[Event](self, Event, ...) end)
AddOn:RegisterEvent("TRADE_SKILL_SHOW")
AddOn:RegisterEvent("TRADE_SHOW")
AddOn:RegisterEvent("SKILL_LINES_CHANGED")

local RealTradeSkillFrame
local IsCurrentSpell = IsCurrentSpell
local Cache, TradeSkillFrameTabs, TradeFrameTabs = {}, {}, {}
local TradeSkillFrameTabIndex, TradeFrameTabIndex = 1, 1
local Professions = {
	[1] = { 2259, 3101, 3464, 11611, 28596, 51304 }, -- Alchemy
	[2] = { 2018, 3100, 3538, 9785, 29844, 51300 }, -- Blacksmithing
	[3] = { 7411, 7412, 7413, 13920, 28029, 51313 }, -- Enchanting
	[4] = { 4036, 4037, 4038, 12656, 30350, 51306 }, -- Engineering
	[5] = { 45357, 45358, 45359, 45360, 45361, 45363 }, -- Inscription
	[6] = { 25229, 25230, 28894, 28895, 28897, 51311 }, -- Jewelcrafting
	[7] = { 2108, 3104, 3811, 10662, 32549, 51302 }, -- Leatherworking
	[8] = { 3908, 3909, 3910, 12180, 26790, 51309 }, -- Tailoring
	[9] = { 2550, 3102, 3413, 18260, 33359, 51296 }, -- Cooking
	[10] = { 3273, 3274, 7924, 10846, 27028, 45542 }, -- First Aid
	[11] = { 53428 }, -- Runeforging
	[12] = { 2656 }, -- Smelting
	[13] = { 13262 }, -- Disenchant
	[14] = { 51005 }, -- Milling
	[15] = { 31252 }, -- Prospecting
	[16] = { 818 }, -- Basic Campfire
	[17] = { 1804 }, -- Pick Lock
}

local function CacheProfessions()
	wipe(Cache)
	for Index = 1, #Professions do
		for IndexTwo = 1, #Professions[Index] do
			local Profession = Professions[Index][IndexTwo]
			if IsSpellKnown(Profession) then
				Cache[#Cache+1] = Profession
				break
			end
		end
	end
end

local function TriggerEvents()
	if TradeFrame and TradeFrame:IsShown() then
		AddOn:TRADE_SHOW()
	end
	
	if RealTradeSkillFrame and RealTradeSkillFrame:IsShown() then
		AddOn:TRADE_SKILL_SHOW()
	end
end

local function Tab_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
	GameTooltip:AddLine(self.SpellRank ~= "" and self.SpellName .. " (" .. self.SpellRank .. ")" or self.SpellName, 1, 1, 1)
	GameTooltip:Show()
end

local function Tab_OnLeave(self)
	GameTooltip:Hide()
end

local function CreateTab(Table, Parent, SpellName, SpellRank)
	local Tab = CreateFrame("CheckButton", nil, Parent, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate")
	Tab.SpellName = SpellName
	Tab.SpellRank = SpellRank
	Tab:SetPoint("TOPLEFT", Parent, "TOPRIGHT", Parent == SkilletFrame and 0 or -32, -32 + (-50 * #Table))
	Tab:SetScript("OnEnter", Tab_OnEnter)
	Tab:SetScript("OnLeave", Tab_OnLeave)
	
	Table[#Table + 1] = Tab
	return Tab
end

local function UpdateTabs(Table, Combat)
	for Index = 1, #Table do
		local Tab = Table[Index]
		
		if Index > #Cache then
			if not Combat then Tab:Hide() end
		else
			if not Combat then Tab:Show() end
			Tab:SetChecked(IsCurrentSpell(Tab.SpellName))
		end
	end
end

local function EventHandler(Table, Parent)
	if InCombatLockdown() then
		AddOn:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		CacheProfessions()
		
		for Index = 1, #Cache do
			local SpellName, SpellRank, SpellTexture = GetSpellInfo(Cache[Index])
			local Tab = Table[Index] or CreateTab(Table, Parent, SpellName, SpellRank)
			
			Tab.SpellName = SpellName
			Tab.SpellRank = SpellRank
			Tab:SetNormalTexture(SpellTexture)
			Tab:SetAttribute("type", "spell")
			Tab:SetAttribute("spell", SpellName)
		end
	end
	
	UpdateTabs(Table, InCombatLockdown())
end

function AddOn:TRADE_SKILL_SHOW()
	RealTradeSkillFrame = MRTSkillFrame or ATSWFrame or SkilletFrame or TradeSkillFrame
	EventHandler(TradeSkillFrameTabs, RealTradeSkillFrame)
end

function AddOn:TRADE_SHOW()
	EventHandler(TradeFrameTabs, TradeFrame)
end

function AddOn:SKILL_LINES_CHANGED()
	TriggerEvents()
end

function AddOn:PLAYER_REGEN_ENABLED(Event)
	self:UnregisterEvent(Event)
	TriggerEvents()
end
