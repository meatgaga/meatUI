local menuCritereaTable = {} 			-- the code below is added by demonguy to let it support multi-spells
local menuCritereaNoSplited 			-- the code below is added by demonguy to let it support multi-spells


--[[ Select

	����һ����ʽΪ /select ����:�ؼ��� �ĺ���ʹ�ã����� /select tooltip:������Ʒ

	һ������������:

		item:<x> 					��ʾ�����к���<x>����Ʒ
		spell:<x>					��ʾ���к���<x>�ļ���
		tooltip:<x>					����ʾ�ú����κ�<x>����Ʒ
		companion:<Pet or Mount>	��ʾ��ս�������������
	
	����:

	/select item:ҩˮ					�����к���"ҩˮ"����Ʒ
	/select item:΢��					�����к��С�΢��������Ʒ
	/select item:����Ʒ					���Ϊ"����Ʒ"����Ʒ
	/select item:ʳ�������				���Ϊ��ʳ������ϡ�����Ʒ
	/select item:INVTYPE_TRINKET		���е���Ʒ
	/select companion:Pet				���з�ս������
	/select companion:Mount				��������
	/select spell:���					�����к��С���桱�����м���
	/select tooltip:������Ʒ			��Ʒ��ʾ�к��С�������Ʒ������Ʒ
	/select tooltip:�ָ�.-����ֵ		�ָܻ�����ֵ����Ʒ

	����ѡ����ĳһ��Ʒ���߼��ܺ󣬲����Ѹú��޸ĳ�Ϊ�������µĸ�ʽ:

		#showtooltip
		/cast [nobtn:2] ս����̤
		/stopmacro [nobtn:2]
		/select spell:��̤

	���Ҫʹ�õ�ǰ����Ʒ���߼��ܣ�ֱ�ӵ���ú����Ϊ�ú��һ����ݼ���ʹ�á�
	���Ҫѡ����������Ʒ���߼��ܣ��Ҽ�����ú꣬�ڵ���������������ѡ������Ҫ�ġ�
	������ս����ʹ�õ�ǰ����Ʒ���߼��ܣ����ǲ���ѡ����������Ʒ���߼��ܡ�
	Ӧ�����������еĶ�������������Ϸ�ڽ��Ķ���������
	������Select.lua�У������ھ��ڣ��޸�ģ�塣
	����������㴴����һ����ʵ���������ܣ�ֻҪ����/select��һ�С�
	�ò��û�����ã�������.lua�ļ����޸ģ�����ֻ��300���У�������ô������˵������ʡ��ʡ������

	����Ӣ�Ĳ��ᷭ�룬�ᷭ��Ҳ�����޸Ļ���ǿ�书�ܡ�
	This is mostly a proof of concept so it will get minimal support by me.  If anyone
	wants to take the idea/code and run with it you're more than welcome.  Some ideas
	include /select only as a seed and full UI support from then on (GUI to define
	criterea and templates, etc), remembering what's being replaced for complex macros,
	slot:0-19 for slot swapping, etc.

	1.0, 11/08/08, initial release

]]

Select = {
	-- template for the macro, can change this but remember to reorder params if necessary
	-- format(template,"" or "/equip [nobtn:2] item","use"|"cast","item/spell name","menuType","menuCriterea")
	template = "#showtooltip\n%s/%s [nobtn:2] %s\n/stopmacro [nobtn:2]\n/select %s:%s",

	macroCurrentlyOpen = nil, -- id of macro that summoned the menu
	buttonCurrentlyOpen = nil, -- button that contains the macro

	Menu = {},
	SpellNameToId = {} -- indexed by spell name = spellid in "spell"
}

CreateFrame("GameTooltip","SelectTooltipScan",UIParent,"GameTooltipTemplate")

function Select.SlashHandler(msg)
	local focus = GetMouseFocus()
	local action = focus.action or focus:GetAttribute("actionid")
	if action and tonumber(action) then
		local actionType,macroIndex = GetActionInfo(action)
		if actionType=="macro" then
			if strfind(GetMacroBody(macroIndex) or "",msg) then
				-- user's mouse is over the macro that called this
				Select.CloseMenu()
				Select.PopulateMenu(msg,focus)
				Select.macroCurrentlyOpen = macroIndex
				Select.buttonCurrentlyOpen = focus
			end
		end
	end
end

function Select.AddToMenu(item)
	local found
	for i=1,#(Select.Menu) do
		if Select.Menu[i]==item then
			found = 1
			break
		end
	end
	if not found then
		table.insert(Select.Menu,item)
	end
end

function Select.AddIfItemMatch(link,menuCriterea)
	local name,_,_,_,_,itemType,itemSubType,_,equipLoc = GetItemInfo(link)
	if name then
		if string.match(name or "",menuCriterea) or string.match(itemType or "",menuCriterea) or
			string.match(itemSubType or "",menuCriterea) or string.match(equipLoc or "",menuCriterea) then
			Select.AddToMenu(name)
		end
	end
end

function Select.AddIfTooltipMatch(link,menuCriterea)
	SelectTooltipScan:SetOwner(UIParent,"ANCHOR_NONE")
	SelectTooltipScan:SetHyperlink(link)
	for k=1,SelectTooltipScan:NumLines() do
		if string.match(_G["SelectTooltipScanTextLeft"..k]:GetText() or "",menuCriterea) or
			string.match(_G["SelectTooltipScanTextRight"..k]:GetText() or "",menuCriterea) then
			Select.AddToMenu(GetItemInfo(link))
			break
		end
	end
end

function Select.PopulateMenu(selectParam,focus)
	local menuType,menuCriterea = string.match(selectParam or "","(.-):(.+)")
	menuCritereaNoSplited = menuCriterea
	if not menuType or (menuType~="item" and menuType~="tooltip" and menuType~="companion" and menuType~="spell") then
		print("usage: /select type:criterea (ie /select item:Quest)")
		print("valid types: item, tooltip, companion, spell")
		return
	end
	for i in pairs(Select.Menu) do
		Select.Menu[i] = nil
	end
	-- the code below is added by demonguy to let it support multi-spells
	local num = select('#',strsplit(";",menuCriterea))
	wipe(menuCritereaTable)
	for i=1,num do
	menuCritereaTable[i] = select(i,strsplit(";",menuCriterea))
	end
	-- the code above is added by demonguy to let it support multi-spells
	
	-- this "for circle" is added by demonguy.but the body of this "for circle" is writed by the original author 
	for i,v in pairs(menuCritereaTable) do
	menuCriterea = v
	if menuType=="item" or menuType=="tooltip" then
		local link
		for i=0,4 do
			for j=1,GetContainerNumSlots(i) do
				link = GetContainerItemLink(i,j)
				if link then
					if menuType=="item" then
						Select.AddIfItemMatch(link,menuCriterea)
					else
						Select.AddIfTooltipMatch(link,menuCriterea)
					end
				end
			end
		end
		for i=0,19 do
			link = GetInventoryItemLink("player",i)
			if link then
				if menuType=="item" then
					Select.AddIfItemMatch(link,menuCriterea)
				else
					Select.AddIfTooltipMatch(link,menuCriterea)
				end
			end
		end
	elseif menuType=="spell" then
		local spellId,spellName=1,""
		while spellName do
			spellName = GetSpellName(spellId,"spell")
			if string.match(spellName or "",menuCriterea) then
				Select.AddToMenu(spellName)
				Select.SpellNameToId[spellName] = spellId
			end
			spellId=spellId+1
		end
	elseif menuType=="companion" then
		local companionType = menuCriterea=="Mount" and "MOUNT" or "CRITTER"
		for i=1,GetNumCompanions(companionType) do
			Select.AddToMenu((select(2,GetCompanionInfo(companionType,i))))
		end
	end
	end
	if #(Select.Menu)==0 then
		print("There doesn't appear to be any \""..menuCriterea.."\" "..menuType.."s.")
	else
		Select.BuildMenu(focus,menuType,menuCriterea)
	end
end

SlashCmdList["SELECTPOPOUT"] = Select.SlashHandler
SLASH_SELECTPOPOUT1 = "/select"

function Select.GetMenuDocking(button)
	local buttonName = button:GetName()
	if not buttonName then
		return
	end
	local orient = "HORIZONTAL"
	local buttonStub,buttonNumber = string.match(buttonName,"(.-)(%d+)")
	buttonNumber = tonumber(buttonNumber)
	if buttonNumber then
		local function near(v1,v2)
			if v1 and v2 then return math.abs(v2-v1)<16 end
		end
		local candidate1 = getglobal(buttonStub..(buttonNumber-1))
		local candidate2 = getglobal(buttonStub..(buttonNumber+1))
		if (candidate1 and near(candidate1:GetLeft(),button:GetLeft())) or
			(candidate2 and near(candidate2:GetLeft(),button:GetLeft())) then
			orient = "VERTICAL"
		end
	end

	local buttonTop,buttonLeft = button:GetTop(),button:GetLeft()
	local midHeight,midWidth = UIParent:GetHeight()/2,UIParent:GetWidth()/2

	if buttonTop>midHeight and orient=="HORIZONTAL" then -- on a horizontal bar in top half of screen
		if buttonLeft<midWidth then
			return "TOPLEFT", "BOTTOMLEFT", 36,0, 0,-36
		else
			return "TOPRIGHT", "BOTTOMRIGHT", -36,0, 0,-36
		end
	elseif buttonLeft<=midWidth and orient=="VERTICAL" then -- on a vertical bar in left half of screen
		if buttonTop>midHeight then
			return "TOPLEFT", "TOPRIGHT", 0,-40, 40,0
		else
			return "BOTTOMLEFT", "BOTTOMRIGHT", 0,40, 40,0
		end
	elseif buttonLeft>midWidth and orient=="VERTICAL" then -- on a vertical bar in right half of screen
		if buttonTop>midHeight then
			return "TOPRIGHT", "TOPLEFT", 0,-36, -36,0
		else
			return "BOTTOMRIGHT", "BOTTOMLEFT", 0,36, -36,0
		end
	else -- all other conditions, assume button is on a horizontal bar in bottom half of screen
		if buttonLeft>midWidth then
			return "BOTTOMRIGHT", "TOPRIGHT", -36,0, 0,36
		else
			return "BOTTOMLEFT", "TOPLEFT", 36,0, 0,36
		end
	end
end

function Select.OnTooltip(owner)
	GameTooltip:SetOwner(owner,"ANCHOR_LEFT")
	GameTooltip[owner.tooltipMethod](GameTooltip,owner.tooltipParam,"spell")
	GameTooltip:Show()
end

function Select.MenuOnUpdate(self,elapsed)
	self.timer = self.timer + elapsed
	if self.timer > .5 then
		self.timer = 0
		local f = GetMouseFocus()
		if f==Select.buttonCurrentlyOpen or string.match(f:GetName() or "","SelectMenuButton") then
			return
		else
			Select.CloseMenu()
		end
	end
end

function Select.CreateButton(idx,entryType,entryName,entryCriterea)
	local buttonName = "SelectMenuButton"..idx
	local button = getglobal(buttonName)
	if not button then
		button = getglobal(buttonName) or CreateFrame("Button",buttonName,UIParent,"ActionButtonTemplate")
		button:SetFrameStrata("DIALOG")
		button:SetScript("OnClick",function() Select.MenuSelected(button) end)
		button:SetScript("OnEnter",function() Select.OnTooltip(button) end)
		button:SetScript("OnLeave",function() GameTooltip:Hide() end)
		if button==SelectMenuButton1 then
			button.timer = 0
			button:SetScript("OnUpdate",Select.MenuOnUpdate)
		end
	end
	getglobal(buttonName.."Count"):SetText("")
	button.entryName = entryName
	button.entryType = entryType
	button.entryCriterea = menuCritereaNoSplited    -- this line is modified by demonguy
	if entryType=="item" or entryType=="tooltip" then
		local _,link,_,_,_,_,_,_,_,texture = GetItemInfo(entryName)
		getglobal(buttonName.."Icon"):SetTexture(texture)
		button.tooltipMethod = "SetHyperlink"
		button.tooltipParam = link
		if GetItemCount(entryName)>1 then
			getglobal(buttonName.."Count"):SetText(GetItemCount(entryName))
		end
	elseif entryType=="spell" then
		local _,_,texture = GetSpellInfo(entryName)
		getglobal(buttonName.."Icon"):SetTexture(texture)
		button.tooltipMethod = "SetSpell"
		button.tooltipParam = Select.SpellNameToId[entryName]
	elseif entryType=="companion" then
		local companionType = entryCriterea=="Mount" and "MOUNT" or "CRITTER"
		local _,_,spellId,texture = GetCompanionInfo(companionType,idx)
		getglobal(buttonName.."Icon"):SetTexture(texture)
		button.tooltipMethod = "SetHyperlink"
		button.tooltipParam = "spell:"..spellId
	end
	button:ClearAllPoints()
	return button
end

function Select.BuildMenu(button,menuType,menuCriterea)
	local relativeFrom,relativeTo,addx,addy,addxwrap,addywrap = Select.GetMenuDocking(button)
	local xstart,ystart = 0,0 -- these values change only when a row wraps
	local xpos,ypos = xstart,ystart -- these values change for every new button
	local menuButton
	local wrapat = 1
	local wraplimit = 1
	local numEntries = #(Select.Menu)
	if numEntries > 25 then
		wraplimit = 5
	elseif numEntries > 18 then
		wraplimit = 4
	elseif numEntries > 9 then
		wraplimit = 3
	elseif numEntries > 4 then
		wraplimit = 2
	end

	for i=1,#(Select.Menu) do
		menuButton = Select.CreateButton(i,menuType,Select.Menu[i],menuCriterea)
		menuButton:SetPoint(relativeFrom,button,relativeTo,xpos,ypos)
		menuButton:Show()
		xpos=xpos+addx
		ypos=ypos+addy
		wrapat = wrapat + 1
		if wrapat>wraplimit then
			xstart=xstart+addxwrap
			ystart=ystart+addywrap
			xpos = xstart
			ypos = ystart
			wrapat = 1
		end
	end
end

function Select.CloseMenu()
	local idx = 1
	while getglobal("SelectMenuButton"..idx) do
		getglobal("SelectMenuButton"..idx):Hide()
		idx = idx + 1
	end
end

function Select.MenuSelected(button)
	Select.CloseMenu()
	if not InCombatLockdown() then
		local oldName,_,_,isLocal = GetMacroInfo(Select.macroCurrentlyOpen)
		local exception = ""
		if (button.entryType=="item" or button.entryType=="tooltip") and select(9,GetItemInfo(button.entryName))~="" then
			-- if item can be equipped, add an /equip as first line
			exception = "/equip [nobtn:2] "..button.entryName.."\n"
		end
		local newBody = string.format(Select.template,
			exception, -- "" if item can't be equipped, "/equip etc" if it can be equipped
			(button.entryType=="spell" or button.entryType=="companion") and "cast" or "use", -- /use or /cast
			button.entryName, -- name of item or spell
			button.entryType, -- type in /select type:criterea
			button.entryCriterea -- criterea in /select type:criterea
		)
		EditMacro(Select.macroCurrentlyOpen,oldName,1,newBody,isLocal)
	else
		print("You can't /select in combat, sorry.")
	end
end
