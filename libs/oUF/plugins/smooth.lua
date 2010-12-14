if SettingsCF.unitframe.enable ~= true or SettingsCF.unitframe.plugins_smooth_bar ~= true then return end

local parent = debugstack():match[[\AddOns\(.-)\]]
local global = GetAddOnMetadata(parent, 'X-oUF')
assert(global, 'X-oUF needs to be defined in the parent add-on.')

local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

local function SmoothBar(self, bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	end
end


for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)


local f, min, max = CreateFrame("Frame"), math.min, math.max
f:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local barmin, barmax = bar:GetMinMaxValues()
		local new = cur + min((value-cur)/6, max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
    if bar.Filling then
      if barmax == 0 then
        bar.Filling:SetHeight(0)
        bar.Filling:SetTexCoord(0,1,1,1)
      else
        bar.Filling:SetHeight((new / barmax) * bar:GetWidth())
        bar.Filling:SetTexCoord(0,1,  math.abs(new / barmax - 1),1)
      end
    end
		if cur == value or abs(cur - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)