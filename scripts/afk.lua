----------------------------------------------------------------------------------------
-- ÔÝÀëºóÐý×ª¾µÍ· (by Telroth and Ecl¨ªps¨¦)
----------------------------------------------------------------------------------------
if not SettingsCF.misc.afk_spin_camera == true then return end
local SpinCam = CreateFrame("Frame")

local OnEvent = function(self, event, unit)
	if (event == "PLAYER_FLAGS_CHANGED") then
		if unit == "player" then
			if UnitIsAFK(unit) then
				SpinStart()
			else
				SpinStop()
			end
		end
	elseif (event == "PLAYER_LEAVING_WORLD") then
		SpinStop()
	end
end
SpinCam:RegisterEvent("PLAYER_ENTERING_WORLD")
SpinCam:RegisterEvent("PLAYER_LEAVING_WORLD")
SpinCam:RegisterEvent("PLAYER_FLAGS_CHANGED")
SpinCam:SetScript("OnEvent", OnEvent)

function SpinStart()
	spinning = true
	SaveView(4)
	ResetView(5)
	SetView(5)
	MoveViewRightStart(0.1)
	UIParent:Hide()
end

function SpinStop()
	if not spinning then return end
	spinning = nil
	MoveViewRightStop()
	SetView(4)
	UIParent:Show()
end
