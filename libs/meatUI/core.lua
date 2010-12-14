----------------------------------------------------------------------------------------
-- meatUI的核心文件
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- 自动UI缩放
----------------------------------------------------------------------------------------
function SettingsDB.UIScale()
	if SettingsCF.general.auto_scale == true then
		SettingsCF.general.uiscale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
	end
end
SettingsDB.UIScale()

-- Pixel perfect script of custom ui scale
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/SettingsCF.general.uiscale
local function scale(x)
    return mult*math.floor(x/mult+0.5)
end

function SettingsDB.Scale(x) return scale(x) end
SettingsDB.mult = mult

----------------------------------------------------------------------------------------
-- 销毁游戏物件自带功能
----------------------------------------------------------------------------------------
function SettingsDB.Kill(object)
	object.Show = SettingsDB.dummy
	object:Hide()
end

----------------------------------------------------------------------------------------
-- 隐藏游戏物件材质
----------------------------------------------------------------------------------------
function SettingsDB.HideTextures(widget)
	for i = 1,widget:GetNumRegions() do
		local region = select(i, widget:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:Hide()
		end
	end
end

----------------------------------------------------------------------------------------
-- 简化大数字
----------------------------------------------------------------------------------------
function SettingsDB.ShortValue(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
--		elseif value >= 1e3 or value <= -1e3 then
--			return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

----------------------------------------------------------------------------------------
-- UTF-8编码功能
----------------------------------------------------------------------------------------
function SettingsDB.UTF8Sub(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end
		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

----------------------------------------------------------------------------------------
-- 字符模板
----------------------------------------------------------------------------------------
function SettingsDB.SetFontString(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(0, 0)
	return fs
end

----------------------------------------------------------------------------------------
-- 样式模板
----------------------------------------------------------------------------------------
function SettingsDB.CreateTemplate(f, a)
	f:SetBackdrop({
		bgFile = SettingsCF.media.blank,
		edgeFile = SettingsCF.media.blank,
		tile = false, tileSize = 0, edgeSize = mult,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	f:SetBackdropColor(SettingsCF.media.backdrop_color[1], SettingsCF.media.backdrop_color[2], SettingsCF.media.backdrop_color[3], a or 1)
	f:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
end

function SettingsDB.CreatePanel(f, w, h, a1, p, a2, x, y)
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = SettingsCF.media.blank, 
		edgeFile = SettingsCF.media.blank, 
		tile = false, tileSize = 0, edgeSize = mult, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	f:SetBackdropColor(unpack(SettingsCF.media.backdrop_color))
	f:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
end

function SettingsDB.CreateShadow(f, a, off)
	local off = off or 2
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", SettingsDB.Scale(-off), SettingsDB.Scale(off))
	shadow:SetPoint("BOTTOMLEFT", SettingsDB.Scale(-off), SettingsDB.Scale(-off))
	shadow:SetPoint("TOPRIGHT", SettingsDB.Scale(off), SettingsDB.Scale(off))
	shadow:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(off), SettingsDB.Scale(-off))
	shadow:SetBackdrop( { 
		edgeFile = SettingsCF.media.glow, edgeSize = 3 * mult,
		insets = {left = 2 * mult, right = 2 * mult, top = 2 * mult, bottom = 2 * mult},
	})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, a or 0.5)
	--shadow:SetBackdropBorderColor(1, 1, 1, 1)
	f.shadow = shadow
end

function SettingsDB.CreateStylePanel(f, a1, a2, a3, off)		-- (依赖框体, 依赖框体背板透明度, 阴影透明度, 风格化框体背板透明度, 阴影位移)
	SettingsDB.CreateTemplate(f, a1)
	SettingsDB.CreateShadow(f, a2, off)

	local stylebd = CreateFrame("Frame", nil, f)
	stylebd:SetPoint("TOPLEFT", SettingsDB.Scale(2), SettingsDB.Scale(-2))
	stylebd:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-2), SettingsDB.Scale(2))
	SettingsDB.CreateTemplate(stylebd, a3)
	stylebd:SetFrameLevel(1)
	stylebd:SetFrameStrata(f:GetFrameStrata())
end

-- 样式化按钮
local function SetModifiedBackdrop(self)
	self:SetBackdropColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b, 0.1)
	self:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(0, 0, 0, 0.25)
	self:SetBackdropBorderColor(unpack(SettingsCF.media.border_color))
end

local function CreatePulse(frame, speed, mult, alpha) -- pulse function originally by nightcracker
	frame.speed = speed or 0.05
	frame.mult = mult or 1
	frame.alpha = alpha or 0.8
	frame.tslu = 0 -- time since last update
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult * -1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult * -1
		end
	end)
end

function SettingsDB.CreateSkinButton(f)
	local glow = CreateFrame("Frame", nil, f)
	glow:SetBackdrop({
		edgeFile = SettingsCF.media.glow,
		edgeSize = 3,
	})
	glow:SetPoint("TOPLEFT", f, SettingsDB.Scale(-4), SettingsDB.Scale(4))
	glow:SetPoint("BOTTOMRIGHT", f, SettingsDB.Scale(4), SettingsDB.Scale(-4))
	glow:SetBackdropBorderColor(SettingsDB.color.r, SettingsDB.color.g, SettingsDB.color.b)
	glow:SetAlpha(0)

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")
	SettingsDB.CreateTemplate(f, 0.25)
	f:HookScript("OnEnter", function(self) SetModifiedBackdrop(self) CreatePulse(glow) end)
	f:HookScript("OnLeave", function(self) SetOriginalBackdrop(self) glow:SetScript("OnUpdate", nil) glow:SetAlpha(0) end)
end

-- CreateShadowFrame
local function TempStyle(myframe, nobg, off)
	local off = off or 2
	if nobg ~= true then
		myframe.bg = myframe:CreateTexture(nil, "BORDER")
		myframe.bg:SetPoint("TOPLEFT", SettingsDB.Scale(off+1), SettingsDB.Scale(-off-1))
		myframe.bg:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-off-1), SettingsDB.Scale(off+1))
		myframe.bg:SetTexture(1, 1, 1, 1)
		myframe.bg:SetGradientAlpha("VERTICAL", unpack({0.26,0.26,0.26,0.14,0.21,0.21,0.21,0.5}))
		myframe.bg:SetBlendMode("ADD")
	end

	myframe.left = myframe:CreateTexture(nil, "OVERLAY")
	myframe.left:SetTexture(0, 0, 0)
	myframe.left:SetPoint("TOPLEFT", SettingsDB.Scale(off), SettingsDB.Scale(-off))
	myframe.left:SetPoint("BOTTOMLEFT", SettingsDB.Scale(off), SettingsDB.Scale(off))
	myframe.left:SetWidth(1)

	myframe.right = myframe:CreateTexture(nil, "OVERLAY")
	myframe.right:SetTexture(0, 0, 0)
	myframe.right:SetPoint("TOPRIGHT", SettingsDB.Scale(-off), SettingsDB.Scale(-off))
	myframe.right:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-off), SettingsDB.Scale(off))
	myframe.right:SetWidth(1)

	myframe.bottom = myframe:CreateTexture(nil, "OVERLAY")
	myframe.bottom:SetTexture(0, 0, 0)
	myframe.bottom:SetPoint("BOTTOMLEFT", SettingsDB.Scale(off), SettingsDB.Scale(off))
	myframe.bottom:SetPoint("BOTTOMRIGHT", SettingsDB.Scale(-off), SettingsDB.Scale(off))
	myframe.bottom:SetHeight(1)

	myframe.top = myframe:CreateTexture(nil, "OVERLAY")
	myframe.top:SetTexture(0, 0, 0)
	myframe.top:SetPoint("TOPLEFT", SettingsDB.Scale(off), SettingsDB.Scale(-off))
	myframe.top:SetPoint("TOPRIGHT", SettingsDB.Scale(-off), SettingsDB.Scale(off))
	myframe.top:SetHeight(1)

	return myframe
end

local bg_ = {
	bgFile = SettingsCF.media.blank, 
	edgeFile = SettingsCF.media.glow, edgeSize = 3 * mult,
	insets = {left = 2 * mult, right = 2 * mult, top = 2 * mult, bottom = 2 * mult},
}

local function TempSetBackdrop(self)
	self:SetBackdrop(bg_)
	self:SetBackdropBorderColor(0, 0, 0, 0.5)
	self:SetBackdropColor(0, 0, 0, 1)
	return self
end

function SettingsDB.CreateShadowFrame(parent, level, strata, nobg, nols, off)
	local myframe = CreateFrame("Frame", nil, parent)
	if nols ~= true then
		myframe:SetFrameLevel(level or 1)
		myframe:SetFrameStrata(strata or "BACKGROUND")
	end
	TempSetBackdrop(myframe)
	TempStyle(myframe, nobg, off)
	return myframe
end

-- Animation
function SettingsDB.CreateAnim(f, k, x, y)
	f.anim = f:CreateAnimationGroup("Move_In")
	f.anim.in_a = f.anim:CreateAnimation("Translation")
	f.anim.in_a:SetDuration(0)
	f.anim.in_a:SetOrder(1)
	f.anim.in_b = f.anim:CreateAnimation("Translation")
	f.anim.in_b:SetDuration(0.3)
	f.anim.in_b:SetOrder(2)
	f.anim.in_b:SetSmoothing("OUT")
	f.anim_o = f:CreateAnimationGroup("Move_Out")
	f.anim_o.b = f.anim_o:CreateAnimation("Translation")
	f.anim_o.b:SetDuration(0.3)
	f.anim_o.b:SetOrder(1)
	f.anim_o.b:SetSmoothing("IN")
	f.anim.in_a:SetOffset(x, y)
	f.anim.in_b:SetOffset(-x, -y)
	f.anim_o.b:SetOffset(x, y)
	if k then f.anim_o:SetScript("OnFinished", function() f:Hide() end) end
end

-- Alert Run
local function GetNextChar(word, num)
	local c = word:byte(num)
	local shift
	if not c then return "", num end
		if (c > 0 and c <= 127) then
			shift = 1
		elseif (c >= 192 and c <= 223) then
			shift = 2
		elseif (c >= 224 and c <= 239) then
			shift = 3
		elseif (c >= 240 and c <= 247) then
			shift = 4
		end
	return word:sub(num, num+shift-1), (num+shift)
end

local updaterun = CreateFrame("Frame")

local flowingframe = CreateFrame("Frame",nil,UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER", UIParent, 0, 136)
flowingframe:SetHeight(64)
flowingframe:SetScript("OnUpdate", FadingFrame_OnUpdate)
flowingframe:Hide()
flowingframe.fadeInTime = 0
flowingframe.holdTime = 1
flowingframe.fadeOutTime = 0.3

local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
flowingtext:SetPoint("LEFT")
flowingtext:SetFont(SettingsCF.media.font, 20, SettingsCF.media.font_style)
flowingtext:SetShadowOffset(0, 0)
flowingtext:SetJustifyH("LEFT")

local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
rightchar:SetFont(SettingsCF.media.font, 50, SettingsCF.media.font_style)
rightchar:SetShadowOffset(0, 0)
rightchar:SetJustifyH("LEFT")

local count,len,step,word,stringE,a

local speed = 0.03333

local function nextstep()
	a, step = GetNextChar(word, step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = string.upper(a)
	rightchar:SetText(a)
end

local function updatestring(self, t)
	count = count - t
	if count < 0 then
		if step > len then 
			self:Hide()
			flowingtext:SetText(stringE)
			FadingFrame_Show(flowingframe)
			rightchar:SetText("")
			word = ""
		else 
			nextstep()
			FadingFrame_Show(flowingframe)
			count = speed
		end
	end
end

updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()

function SettingsDB.AlertRun(f, r, g, b)
	flowingframe:Hide()
	updaterun:Hide()

	flowingtext:SetText(f)
	local l = flowingtext:GetWidth()

	local color1 = r or 1
	local color2 = g or 1
	local color3 = b or 1

	flowingtext:SetTextColor(color1*0.95, color2*0.95, color3*0.95)
	rightchar:SetTextColor(color1, color2, color3)

	word = f
	len = f:len()
	step = 1
	count = speed
	stringE = ""
	a = ""

	flowingtext:SetText("")
	flowingframe:SetWidth(l)

	rightchar:SetText("")
	FadingFrame_Show(flowingframe)
	updaterun:Show()
end

----------------------------------------------------------------------------------------
-- 淡入/淡出模板
----------------------------------------------------------------------------------------
function SettingsDB.FadeIn(f)
	UIFrameFadeIn(f, 0.4, f:GetAlpha(), 1)
end

function SettingsDB.FadeOut(f)
	UIFrameFadeOut(f, 0.8, f:GetAlpha(), 0)
end
