----------------------------------------------------------------------------------------
-- meatUI的媒体配置文档
----------------------------------------------------------------------------------------
SettingsCF["media"] = {
	["font"] = [[Interface\AddOns\meatUI\media\fonts\font.ttf]],				-- 主字体(主要用于显示中文)
	["font_size"] = 10,															-- 主字体尺寸
	["font_style"] = "OUTLINE",													-- 主字体样式("OUTLINE"=细描边;"THICKOUTLINE"=粗描边;"OUTLINEMONOCHROME"=像素描边)
	["pixel_font"] = [[Interface\AddOns\meatUI\media\fonts\pixelfont.ttf]],		-- 像素字体(主要用于显示数字)
	["pixel_font_size"] = 8,													-- 像素字体尺寸
	["pixel_font_style"] = "OUTLINEMONOCHROME",									-- 像素字体样式("OUTLINE"=细描边;"THICKOUTLINE"=粗描边;"OUTLINEMONOCHROME"=像素描边)
	["blank"] = [[Interface\AddOns\meatUI\media\textures\white]],				-- 纯白材质
	["bar"] = [[Interface\AddOns\meatUI\media\textures\bar]],					-- 状态条材质
	["highlight"] = [[Interface\AddOns\meatUI\media\textures\highlight]],		-- 减益效果高亮材质
	["glow"] = [[Interface\AddOns\meatUI\media\textures\glow]],					-- 光晕/阴影材质
	["whisp_sound"] = [[Interface\AddOns\meatUI\media\sounds\whisper.mp3]],		-- 密语提示音
	["border_color"] = {0, 0, 0},												-- 边框颜色
	["backdrop_color"] = {0, 0, 0},												-- 边框背板颜色
	["uf_color"] = {0.4, 0.4, 0.4},												-- 当["own_color"] = true时单位框体颜色
}
