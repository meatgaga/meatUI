----------------------------------------------------------------------------------------
-- 自动接受好友或公会成员的邀请
----------------------------------------------------------------------------------------
if SettingsCF.misc.accept_invite == true then
	local IsFriend = function(name)
		for i = 1, GetNumFriends() do if(GetFriendInfo(i) == name) then return true end end
		if(IsInGuild()) then for i = 1, GetNumGuildMembers() do if(GetGuildRosterInfo(i) == name) then return true end end end
	end

	local ai = CreateFrame("Frame")
	ai:RegisterEvent("PARTY_INVITE_REQUEST")
	ai:SetScript("OnEvent", function(frame, event, name)
		if(IsFriend(name)) then
			SettingsDB.AlertRun(L_INFO_INVITE..name,0,1,1)
			print(format("|cffffff00"..L_INFO_INVITE..name))
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if(frame:IsVisible() and frame.which == "PARTY_INVITE") then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				end
			end
		else
			SendWho(name)
		end
	end)
end

----------------------------------------------------------------------------------------
--	自动发出邀请的密语关键字
----------------------------------------------------------------------------------------
if SettingsCF.misc.auto_invite == true then
	local autoinvite = CreateFrame("Frame")
	autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
	autoinvite:SetScript("OnEvent", function(self, event, arg1, arg2)
		if ((not UnitExists("party1") or IsPartyLeader("player")) and arg1:lower():match(SettingsCF.misc.invite_keyword)) then
			InviteUnit(arg2)
		end
	end)
end
