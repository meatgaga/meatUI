--[[
	Project.: oUF_Swing
	File....: oUF_Swing.lua
	Version.: 30300.4
	Rev Date: 08/30/2010
	Authors.: p3lim, Thalyra
]] 

--[[
	Elements handled:
	 .Swing [statusbar]
	 .Swing.Text [fontstring]

	Shared:
	 - disableMelee [boolean]
	 - disableRanged [boolean]
	 - disableOoc [boolean] (Autohide on leaving Combat)

	Functions that can be overridden from within a layout:
	 - :OverrideText(elapsed)
--]]
if SettingsCF.unitframe.enable ~= true or SettingsCF.unitframe.plugins_swing ~= true then return end

local OnDurationUpdate
do
	local elapsed = 0
	--local castcheck = 0
	--local lastcheck = 0
	local slamelapsed = 0
	local slam = GetSpellInfo(47475)
	function OnDurationUpdate(self, elapsed)
	--function OnDurationUpdate(self)
	
		local spell = UnitCastingInfo("player")
		
		if slam == spell then
			slamelapsed = slamelapsed + elapsed
		else
			if slamelapsed ~= 0 then
				self.min = self.min + slamelapsed
				self.max = self.max + slamelapsed
				self:SetMinMaxValues(self.min, self.max)
				slamelapsed = 0
			end
			
			swingelapsed = GetTime()
			if swingelapsed > self.max then
				self:Hide()
				self:SetScript("OnUpdate", nil)
			else
				self:SetValue(self.min + (swingelapsed - self.min))
				
				if self.Text then
					if self.OverrideText then
						self:OverrideText(swingelapsed)
					else
						self.Text:SetFormattedText("%.1f", self.max - swingelapsed)
					end
				end
			end
		end
	end
end

local function Melee(self, _, _, event, GUID, _, _, _, tarGUID, _, missType, spellName)
	local bar = self.Swing
	
	if UnitGUID(self.unit) == tarGUID then
	
		if string.find(event, "MISSED") then
			if missType == "PARRY" then
				bar.max = bar.min + ((bar.max - bar.min) * 0.6)
				bar:SetMinMaxValues(bar.min, bar.max)
			end
		end
		
	elseif UnitGUID(self.unit) == GUID  then
		
		-- SPELL_EXTRA_ATTACKS
		local swordprocc = false
		if event == "SPELL_EXTRA_ATTACKS" and (spellName == GetSpellInfo(12815) or spellName == GetSpellInfo(13964)) then
			swordprocc = true
		end
		-- SWING_DAMAGE, SWING_MISS, SPELL_CAST_SUCCESS
		if not string.find(event, "SWING") and not string.find(event, "SPELL_CAST_SUCCESS") then return end
		if string.find(event, "SPELL_CAST_SUCCESS") then
			if spellName ~= GetSpellInfo(47450) and spellName ~= GetSpellInfo(47520) and spellName ~= GetSpellInfo(56815) and spellName ~= GetSpellInfo(48996) and spellName ~= GetSpellInfo(48480) then return end
		end
		
		if swordprocc == true then
			swordprocc = false
		else
			bar.min = GetTime()
			bar.max = bar.min + UnitAttackSpeed(self.unit)
			local itemId = GetInventoryItemID("player", 17)
			
			if itemId ~= nil then
				local _, _, _, _, _, itemType = GetItemInfo(itemId)
				local _, _, _, _, _, weaponType = GetItemInfo(25)
				if itemType ~= weaponType then -- Worn Shortsword, little "hack" for language support
					bar:Show()
					bar:SetMinMaxValues(bar.min, bar.max)
					bar:SetScript("OnUpdate", OnDurationUpdate)
				else
					bar:Hide()
					bar:SetScript("OnUpdate", nil)
				end
			else
				bar:Show()
				bar:SetMinMaxValues(bar.min, bar.max)
				bar:SetScript("OnUpdate", OnDurationUpdate)
			end
		end
		
	end
end

local function Ranged(self, event, unit, spellName)
	if spellName ~= GetSpellInfo(75) and spellName ~= GetSpellInfo(5019) then return end

	local bar = self.Swing
	bar.min = GetTime()
	bar.max = bar.min + UnitRangedDamage(unit)

	bar:Show()
	bar:SetMinMaxValues(bar.min, bar.max)
	bar:SetScript("OnUpdate", OnDurationUpdate)
end

local function Ooc(self)
	local bar = self.Swing
	bar:Hide()
end

local function Enable(self, unit)
	local bar = self.Swing
	if bar and unit == "player" then
		
		if not bar.disableRanged then
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", Ranged)
		end
		
		if not bar.disableMelee then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Melee)
		end
		
		if not bar.disableOoc then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", Ooc)
		end
		
		bar:Hide()
		if not bar:GetStatusBarTexture() and not swing:GetTexture() then
			bar:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		return true
	end
end

local function Disable(self)
	local bar = self.Swing
	if bar then
		if not bar.disableRanged then
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", Ranged)
		end

		if not bar.disableMelee then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Melee)
		end
		
		if not bar.disableOoc then
			self:UnregisterEvent("PLAYER_REGEN_ENABLED", Ooc)
		end
	end
end

oUF:AddElement("Swing", nil, Enable, Disable)