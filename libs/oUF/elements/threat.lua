local parent = debugstack():match[[\AddOns\(.-)\]]
local global = GetAddOnMetadata(parent, 'X-oUF')
assert(global, 'X-oUF needs to be defined in the parent add-on.')
local oUF = _G[global]

local Update = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local threat = self.Threat
	if(threat.PreUpdate) then threat:PreUpdate(unit) end

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		threat:SetVertexColor(r, g, b)
		threat:Show()
	else
		threat:Hide()
	end

	if(threat.PostUpdate) then
		return threat:PostUpdate(unit, status)
	end
end

local Enable = function(self)
	local threat = self.Threat
	if(threat) then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", threat.Update or Update)
		threat:Hide()

		if(threat:IsObjectType"Texture" and not threat:GetTexture()) then
			threat:SetTexture[[Interface\Minimap\ObjectIcons]]
			threat:SetTexCoord(6/8, 7/8, 1/2, 1)
		end

		return true
	end
end

local Disable = function(self)
	local threat = self.Threat
	if(threat) then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE", threat.Update or Update)
	end
end

oUF:AddElement('Threat', Update, Enable, Disable)
