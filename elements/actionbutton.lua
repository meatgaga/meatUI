----------------------------------------------------------------------------------------
-- 动作条按钮样式 (基于alBarMods by Allez)
----------------------------------------------------------------------------------------
local _G = _G

local modSetBorderColor = function(button)
	if not button.bd then return end
	if button.pushed then
		button.bd:SetBackdropBorderColor(1, 1, 1)
		button.over:SetBackdropColor(1, 1, 1, 0.15)
	elseif button.hover then
		button.bd:SetBackdropBorderColor(1, 1, 0)
		button.over:SetBackdropColor(1, 1, 0, 0.15)
	elseif button.checked then
		button.bd:SetBackdropBorderColor(0, 1, 1)
		button.over:SetBackdropColor(0, 1, 1, 0.15)
	elseif button.equipped then
		button.bd:SetBackdropBorderColor(0, 1, 0)
		button.over:SetBackdropColor(0, 1, 0, 0.15)
	else
		button.bd:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
		button.over:SetBackdropColor(0, 0, 0, 0)
	end
end

local modActionButtonDown = function(id)
	local button
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = true
	modSetBorderColor(button)
end

local modActionButtonUp = function(id)
	local button
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = false
	modSetBorderColor(button)
end

local modMultiActionButtonDown = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = true
	modSetBorderColor(button)
end
  
local modMultiActionButtonUp = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = false
	modSetBorderColor(button)
end

local modActionButton_UpdateState = function(button)
	local action = button.action
	if not button.bd then return end
	if IsCurrentAction(action) or IsAutoRepeatAction(action) then
		button.checked = true
	else
		button.checked = false
	end
	modSetBorderColor(button)
end

local setStyle = function(bname)
	local button = _G[bname]
	local icon   = _G[bname.."Icon"]
	local flash  = _G[bname.."Flash"]

	if not button.bd then
		button:SetWidth(SettingsDB.Scale(SettingsDB.buttonsize))
		button:SetHeight(SettingsDB.Scale(SettingsDB.buttonsize))

		button.bd = CreateFrame("Frame", nil, button)
		button.bd:SetPoint("TOPLEFT", 0, 0)
		button.bd:SetPoint("BOTTOMRIGHT", 0, 0)
		button.bd:SetFrameStrata("BACKGROUND")
		SettingsDB.CreateTemplate(button.bd, 0.6)
		button.bd:SetBackdropColor(0, 0, 0, 0.25)

		button.over = CreateFrame("Frame", nil, button)
		button.over:SetFrameLevel(button:GetFrameLevel() + 1)
		button.over:SetFrameStrata(button:GetFrameStrata())
		button.over:SetPoint("TOPLEFT", button, "TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
		button.over:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
		button.over:SetBackdrop({
			bgFile = SettingsCF["media"].blank,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		button.over:SetBackdropColor(0, 0, 0, 0)

		button:HookScript("OnEnter", function(self)
			self.hover = true
			modSetBorderColor(self)
		end)
		button:HookScript("OnLeave", function(self)
			self.hover = false
			modSetBorderColor(self)
		end)
	end

	flash:SetTexture("")
	button:SetHighlightTexture("")
	button:SetPushedTexture("")
	button:SetCheckedTexture("")
	button:SetNormalTexture("")
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint("TOPLEFT", button, "TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
	icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
end

local modActionButton_Update = function(self)
	local action = self.action
	local name = self:GetName()
	local button = self
	local count = _G[name.."Count"]
	local border = _G[name.."Border"]
	local hotkey = _G[name.."HotKey"]
	local macro = _G[name.."Name"]

	border:Hide()

	count:ClearAllPoints()
	count:SetPoint("BOTTOMRIGHT", 0, SettingsDB.Scale(2))
	count:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	count:SetTextColor(0.6, 0.6, 0.6)

	macro:SetFont(SettingsCF.media.font, SettingsCF.media.pixel_font_size, SettingsCF.media.font_style)
	if SettingsCF.actionbar.macro ~= true then
		macro:Hide()
	end

	hotkey:ClearAllPoints()
	hotkey:SetPoint("TOPLEFT", SettingsDB.Scale(1.5), SettingsDB.Scale(-1))
	hotkey:SetWidth(SettingsDB.buttonsize)
	hotkey:SetHeight(SettingsCF.media.pixel_font_size)
	hotkey:SetFont(SettingsCF.media.pixel_font, SettingsCF.media.pixel_font_size, SettingsCF.media.pixel_font_style)
	hotkey:SetTextColor(1, 1, 1)
	hotkey:SetJustifyH("LEFT")
	if SettingsCF.actionbar.hotkey ~= true then
		hotkey:Hide()
	end

	setStyle(name)
	if IsEquippedAction(action) then
		button.equipped = true
	else
		button.equipped = false
	end
	modSetBorderColor(button)
end
  
local modPetActionBar_Update = function()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]

		setStyle(name)
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)

		local autocast = _G["PetActionButton"..i.."AutoCastable"]
		autocast:SetWidth(SettingsDB.buttonsize + 25)
		autocast:SetHeight(SettingsDB.buttonsize + 25)
		autocast:ClearAllPoints()
		autocast:SetPoint("CENTER", button, 0, 0)

		local cd = _G["PetActionButton"..i.."Cooldown"]
		cd:ClearAllPoints()
		cd:SetPoint("TOPLEFT", button, 2, -2)
		cd:SetPoint("BOTTOMRIGHT", button, -2, 2)
	end
end

local modShapeshiftBar_UpdateState = function()    
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]

		setStyle(name)
		local texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)
	end
end

local modPossessBar_UpdateState = function()
	for i = 1, NUM_POSSESS_SLOTS do
		local name = "PossessButton"..i
		local button  = _G[name]

		setStyle(name)
		modSetBorderColor(button)
	end
end

local modActionButton_UpdateUsable = function(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	local isUsable, notEnoughMana = IsUsableAction(action)

	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.8, 0.1, 0.1, 1)			-- 距离过远的颜色
		return
	elseif notEnoughMana then
		icon:SetVertexColor(0.1, 0.3, 1, 1)				-- 魔法值不足的颜色
		return
	elseif isUsable then
		icon:SetVertexColor(1, 1, 1, 1)					-- 使用之中的颜色
		return
	else
		icon:SetVertexColor(0.4, 0.4, 0.4, 1)			-- 数量不足的颜色
		return
	end
end

local modActionButton_OnUpdate = function(self, elapsed)
	local t = self.mod_range
	local update_timer = 0.1
	if not t then
		self.mod_range = 0
		return
	end
	t = t + elapsed
	if t < update_timer then
		self.mod_range = t
		return
	else
		self.mod_range = 0
		modActionButton_UpdateUsable(self)
	end
end

local modActionButton_UpdateHotkeys = function(self, actionButtonType)
	if (not actionButtonType) then
		actionButtonType = "ACTIONBUTTON"
	end
	local hotkey = _G[self:GetName().."HotKey"]
	local key = GetBindingKey(actionButtonType..self:GetID()) or GetBindingKey("CLICK "..self:GetName()..":LeftButton")
	local text = GetBindingText(key, "KEY_", 1)
	local replace = string.gsub

	text = replace(text, "(s%-)", "S+")
	text = replace(text, "(a%-)", "A+")
	text = replace(text, "(c%-)", "C+")
	text = replace(text, "(Mouse Button )", "M")
	text = replace(text, "(Кнопка мыши )", "M")
	text = replace(text, KEY_BUTTON3, "M3")
	text = replace(text, "(Num Pad )", "N")
	text = replace(text, KEY_PAGEUP, "PU")
	text = replace(text, KEY_PAGEDOWN, "PD")
	text = replace(text, KEY_SPACE, "SpB")
	text = replace(text, KEY_INSERT, "Ins")
	text = replace(text, KEY_HOME, "Hm")
	text = replace(text, KEY_MOUSEWHEELDOWN, "MWD")
	text = replace(text, KEY_MOUSEWHEELUP, "MWU")
	text = replace(text, KEY_DELETE, "Del")

	hotkey:SetText(text)

	if SettingsCF.actionbar.hotkey == true then
		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOPLEFT", SettingsDB.Scale(1.5), SettingsDB.Scale(-1))
		hotkey:SetWidth(SettingsDB.buttonsize + 2)
		hotkey:SetHeight(SettingsCF.media.pixel_font_size)
	else
		hotkey:Hide()
	end
end

hooksecurefunc("ActionButton_Update", modActionButton_Update)
hooksecurefunc("ActionButton_UpdateUsable", modActionButton_UpdateUsable)
hooksecurefunc("ActionButton_UpdateState", modActionButton_UpdateState)
hooksecurefunc("ActionButtonDown", modActionButtonDown)
hooksecurefunc("ActionButtonUp", modActionButtonUp)
hooksecurefunc("MultiActionButtonDown", modMultiActionButtonDown)
hooksecurefunc("MultiActionButtonUp", modMultiActionButtonUp)
ActionButton_OnUpdate = modActionButton_OnUpdate

hooksecurefunc("ShapeshiftBar_OnLoad", modShapeshiftBar_UpdateState)
hooksecurefunc("ShapeshiftBar_Update", modShapeshiftBar_UpdateState)
hooksecurefunc("ShapeshiftBar_UpdateState", modShapeshiftBar_UpdateState)
hooksecurefunc("PetActionBar_Update", modPetActionBar_Update)
hooksecurefunc("ActionButton_UpdateHotkeys", modActionButton_UpdateHotkeys)
hooksecurefunc("PossessBar_Update", modPossessBar_UpdateState)

-- 修正冷却螺旋尺寸以免覆盖边框
local buttonNames = {
	"ActionButton",
	"BonusActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"ShapeshiftButton",
	"MultiCastActionButton",
}
for _, name in ipairs( buttonNames ) do
	for index = 1, 20 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]

		if ( button == nil or cooldown == nil ) then
			break;
		end

		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", SettingsDB.Scale(1), SettingsDB.Scale(-1))
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", SettingsDB.Scale(-1), SettingsDB.Scale(1))
	end
end