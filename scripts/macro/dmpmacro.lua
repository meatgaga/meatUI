local button = CreateFrame("Button", ..., UIParent, "SecureActionButtonTemplate")

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if not (self:GetItem() and (IsAltKeyDown() and IsShiftKeyDown() or IsMouseButtonDown(3)) and GetMouseFocus():GetID() > 0) then return end
	local iName, _, iRarity, _, _, iType, iSubType = GetItemInfo(self:GetItem())
	local mText = ""
	if iName:find("矿石") and GetSpellInfo("选矿") then
		mText = "/cast 选矿\n/use "..self:GetItem()
	elseif iSubType == "草药" then
		mText = GetSpellInfo("研磨") and "/cast 研磨\n/use "..self:GetItem() or "/cast 炼金术"
	elseif (iType == "武器" or iType == "护甲") and iRarity > 1 and iRarity < 5 and not IsEquippedItem(iName) then
		mText = "/cast 分解\n/use "..self:GetItem()
	elseif iType == "珠宝" then
		mText = "/cast 珠宝加工"
	elseif iSubType == "布料" then
		mText = GetSpellInfo("裁缝") and "/cast 裁缝" or "/cast 急救"
	elseif iSubType == "肉类" then
		mText = "/cast 烹饪"
	elseif iSubType == "附魔" then
		mText = "/cast 附魔"
	elseif iSubType == "皮革" then
		mText = "/cast 制皮"
	elseif iName == "铁匠之锤" or iName:find("矿石") or iName:find("石头") then
		mText = GetSpellInfo("锻造") and "/cast 锻造" or "/cast 工程学"
	elseif iName == "扳手" or iSubType == "零件" and not iName:find("墨水") then
		mText = "/cast 工程学"
	elseif iName == "学者的书写工具" or iName:find("墨水") or iName:find("颜料") then
		mText = "/cast 铭文"
	else
		return
	end
	button:SetAttribute("*type*", "macro")
	button:SetAttribute("macrotext", mText)
	button:SetAllPoints(GetMouseFocus())
	button:Show()
end)

button:SetScript("OnLeave", function(self) self:Hide() self:ClearAllPoints() end)
button:SetFrameStrata("DIALOG")
