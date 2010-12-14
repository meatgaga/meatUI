local parent = debugstack():match[[\AddOns\(.-)\]]
local global = GetAddOnMetadata(parent, 'X-oUF')
assert(global, 'X-oUF needs to be defined in the parent add-on.')
local oUF = _G[global]

local Update = function(self, event)
	if(IsResting()) then
		self.Resting:Show()
	else
		self.Resting:Hide()
	end
end

local Enable = function(self, unit)
	local resting = self.Resting
	if(resting and unit == 'player') then
		self:RegisterEvent("PLAYER_UPDATE_RESTING", resting.Update or Update)

		if(resting:IsObjectType"Texture" and not resting:GetTexture()) then
			resting:SetTexture[[Interface\CharacterFrame\UI-StateIcon]]
			resting:SetTexCoord(0, .5, 0, .421875)
		end

		return true
	end
end

local Disable = function(self)
	local resting = self.Resting
	if(resting) then
		self:UnregisterEvent("PLAYER_UPDATE_RESTING", resting.Update or Update)
	end
end

oUF:AddElement('Resting', Update, Enable, Disable)
