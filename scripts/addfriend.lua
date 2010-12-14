----------------------------------------------------------------------------------------
-- 目标右键菜单中添加和删除好友 (EasyAddFriend by RIOKOU)
----------------------------------------------------------------------------------------
local EasyAddFriend = CreateFrame("Frame","EasyAddFriendFrame")
EasyAddFriend:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_ShowMenu", EasyAddFriendCheck) end)
EasyAddFriend:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {"PARTY", "PLAYER", "RAID_PLAYER", "RAID", "FRIEND", "TEAM", "CHAT_ROSTER", "TARGET", "FOCUS"}

local AddFriendButtonInfo = {
	text = L_MENU_ADDFRIEND,
	value = "ADD_FRIEND",
	func = function() AddFriend(UIDROPDOWNMENU_OPEN_MENU.name) end,
	notCheckable = 1,
}

local RemoveFriendButtonInfo = {
	text = L_MENU_REMOVEFRIEND,
	value = "REMOVE_FRIEND",
	func = function() RemoveFriend(UIDROPDOWNMENU_OPEN_MENU.name) end,
	notCheckable = 1
}

function EasyAddFriendCheck()
	local PossibleButton = getglobal("DropDownList1Button"..(DropDownList1.numButtons)-1)
	if PossibleButton["value"] ~= "ADD_FRIEND" then		-- is there not already an add friend button on it?
		local GoodUnit = false
		for i=1, #PopupUnits do	
		if OPEN_DROPDOWNMENUS[1]["which"] == PopupUnits[i] then
			GoodUnit = true
			end
		end

		if UIDROPDOWNMENU_OPEN_MENU["unit"] == "target" and ((not UnitIsPlayer("target")) or (not UnitIsFriend("player", "target"))) then
			GoodUnit = false
		end

		if GoodUnit then		-- is the unit of the popup one that we want to use? (e.g. not vehicles, npcs, or enemy players)
			local IsAlreadyFriend = false
			for z=1, GetNumFriends() do
				if GetFriendInfo(z) == UIDROPDOWNMENU_OPEN_MENU["name"] or UIDROPDOWNMENU_OPEN_MENU["name"] == UnitName("player") then
					IsAlreadyFriend = true
					CreateRemoveFriendButton()		-- Add the button
				end
			end
			if not IsAlreadyFriend then		-- is this person not already your friend?
				CreateAddFriendButton()		-- Add the button
			end
		end
	end
end

function CreateAddFriendButton()
		local CancelButtonFrame = getglobal("DropDownList1Button"..DropDownList1.numButtons)
		CancelButtonFrame:Hide() 									-- hide the "Cancel" button
		DropDownList1.numButtons = DropDownList1.numButtons - 1		-- make the DropDownMenu API think the "Cancel" button never existed
		UIDropDownMenu_AddButton(AddFriendButtonInfo)				-- create our "Add Friend" button, it gets put where the cancel button used to be
end

function CreateRemoveFriendButton()
		local CancelButtonFrame = getglobal("DropDownList1Button"..DropDownList1.numButtons)
		CancelButtonFrame:Hide() 									-- hide the "Cancel" button
		DropDownList1.numButtons = DropDownList1.numButtons - 1		-- make the DropDownMenu API think the "Cancel" button never existed
		UIDropDownMenu_AddButton(RemoveFriendButtonInfo)					-- create a new cancel button after our "Add Friend" button
end
