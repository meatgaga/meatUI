-------------------------------------------------------------------------------
--  ClearFont v3.22b ������ǿ��
--  ������ClearFont v20000-2 �汾�����޸ģ�
--  ԭ���ߣ�KIRKBURN��ԭ�����Ѳ��ٸ��£���
--  �ٷ���ҳ��http://www.clearfont.co.uk/
-- -----------------------------------------------------------------------------
--  �����޸ģ����� Ԫ��֮�� ��Ϯ����
--  ����ҳ�棺http://bbs.game.mop.com/viewthread.php?tid=1503056
--  �������ڣ�2010.10.19
-------------------------------------------------------------------------------
-- CLEARFONT.LUA - ��׼WOW�û���������
--  A. ClearFont��ܡ�Ԥ�ȶ�������λ��
--  B. WOW�û��������
--  C. �������빦��
--  D. ��һ������ʱӦ�������趨
-------------------------------------------------------------------------------

-- =============================================================================
--  A. ClearFont��ܡ�Ԥ�ȶ�������λ��
--  ����Ը���������������Լ�������λ��
-- =============================================================================
ClearFont = CreateFrame("Frame", "ClearFont")

local CLEAR_FONT_BASE = "Interface\\AddOns\\meatUI\\media\\fonts\\"	-- ����Ѱ��
local CLEAR_FONT_NUMBER = CLEAR_FONT_BASE .. "font.ttf"			-- ��ҡ��ѵ��������󶨵�����
local CLEAR_FONT_EXP = CLEAR_FONT_BASE .. "font.ttf"				-- ���������������ϵ�����
local CLEAR_FONT_QUEST = CLEAR_FONT_BASE .. "font.ttf"				-- ����˵�������š�ʯ������������
local CLEAR_FONT_DAMAGE = CLEAR_FONT_BASE .. "font.ttf"			-- ս���˺���ֵ��ʾ
local CLEAR_FONT = CLEAR_FONT_BASE .. "font.ttf"					-- ��Ϸ�����е���Ҫ����
local CLEAR_FONT_ITEM = CLEAR_FONT_BASE .. "font.ttf"				-- ��Ʒ�����ܵ�˵������
local CLEAR_FONT_CHAT = CLEAR_FONT_BASE .. "font.ttf"				-- ��������
-- local YOUR_FONT_STYLE = CLEAR_FONT_BASE .. "YourFontName.ttf"	-- ��������Լ�������(����)

-------------------------------------------------------------------------------
-- ȫ�������������(��������������嶼̫���̫Сʱ�����������)
-- ����: ���������������С��80%, ��ô���Խ�"1.0"�ĳ�"0.8"
-------------------------------------------------------------------------------
local CF_SCALE = SettingsCF.general.gamefont_scale

-------------------------------------------------------------------------------
-- �����ڵ����岢�ı�����
-------------------------------------------------------------------------------
local function CanSetFont(object) 
	return (type(object)=="table" 
		and object.SetFont and object.IsObjectType 
		and not object:IsObjectType("SimpleHTML"))
end

-- =============================================================================
--  B. WOW�û��ӿ����
-- =============================================================================
--   ����**�޸������С/��Ч**����Ҫ�Ĳ���
--   ��Ҫ�����屻�����г�, ���ಿ�����尴����ĸ��˳������
--   �����г�ֻ����ClearFont�޸��˵ķ�������, ���������з��涼����ʾ����(����: ��Ӱ)
-- -----------------------------------------------------------------------------
--  �������¿��ô���Ľ���
--   �������:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale)
--   ��ͨ���:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale, "OUTLINE")
--   �����:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale, "THICKOUTLINE")
--   �������:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale, "OUTLINEMONOCHROME")
--   ������ɫ:		Font:SetTextColor(r, g, b)
--   ��Ӱ��ɫ:		Font:SetShadowColor(r, g, b) 
--   ��Ӱλ��:		Font:SetShadowOffset(x, y) 
--   ͸����:		Font:SetAlpha(x)
--
--   ����: 			SetFont(CLEAR_FONT, 13 * CF_SCALE)
--   ��������ĵ�һ������(A.)�����������������, �ڶ������������С
-- =============================================================================
function ClearFont:ApplySystemFonts()
-------------------------------------------------------------------------------
-- ������Ϸ�����"3D"����(Dark Imakuni)
--  ***ע��*** ClearFont���ܶ�����Щ����Ĵ�С����Ч(������BlizzardĬ����Ϸ���)
-------------------------------------------------------------------------------
--  ��Щ����������Ĭ���Ŷӿ�ܡ�����MT/MA��ʱ��������
--  ����㲻�õ�������MT/MA��, ���Ա�����Щ�����, �������κ����⣡
-------------------------------------------------------------------------------
	STANDARD_TEXT_FONT = CLEAR_FONT_CHAT					-- ��������
	UNIT_NAME_FONT = CLEAR_FONT								-- ͷ���ϵ�����, Ư���ı�(Զ�����ɿ���)
	NAMEPLATE_FONT = CLEAR_FONT								-- ͷ���ϵ�����, ����������(NamePlate, ����V���󿿽�Ŀ��, ���ֵ�Ѫ��)
	DAMAGE_TEXT_FONT = CLEAR_FONT_DAMAGE					-- ������Ŀ���Ϸ��������˺�ָʾ(����SCT/DCT�޹�)

-------------------------------------------------------------------------------
-- �����˵������С(Note by Kirkburn)
--  ***ע��*** ClearFontֻ�ܶ����������Ĵ�С(������BlizzardĬ����Ϸ���)
-------------------------------------------------------------------------------
--  ��Щ����������Ĭ���Ŷӿ�ܡ�����MT/MA��ʱ��������
--  ����㲻�õ�������MT/MA��, ���Ա�����Щ�����, �������κ����⣡
-------------------------------------------------------------------------------
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12 * CF_SCALE

-------------------------------------------------------------------------------
-- ְҵɫ��(���¾�ΪĬ��ֵ/Ĭ������)
-------------------------------------------------------------------------------
--	RAID_CLASS_COLORS = {
--		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },			-- ����
--		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },			-- ��ʿ
--		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },				-- ��ʦ
--		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },			-- ʥ��ʿ
--		["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },				-- ��ʦ
--		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },			-- Ǳ����
--		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },			-- ��³��
--		["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0 },			-- ����
--		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 }			-- սʿ
--		["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },	-- ������ʿ
--	}

-------------------------------------------------------------------------------
-- ϵͳ����(���¾�ΪĬ��ֵ/Ĭ������)
-- ����������ϵͳ����ģ��, ��Ҫ��������������̳�(New in WotLK/3.x)
-------------------------------------------------------------------------------
--	SystemFont_Tiny:SetFont(CLEAR_FONT, 9 * CF_SCALE)
--	SystemFont_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
--	SystemFont_Outline_Small:SetFont(CLEAR_FONT_CHAT, 12 * CF_SCALE, "OUTLINE")
--	SystemFont_Shadow_Small:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	SystemFont_Shadow_Small:SetShadowColor(0, 0, 0) 
--	SystemFont_Shadow_Small:SetShadowOffset(1, -1) 
--	SystemFont_InverseShadow_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
--	SystemFont_InverseShadow_Small:SetShadowColor(0.4, 0.4, 0.4) 
--	SystemFont_InverseShadow_Small:SetShadowOffset(1, -1) 
--	SystemFont_InverseShadow_Small:SetAlpha(0.75)
--	SystemFont_Med1:SetFont(CLEAR_FONT, 13 * CF_SCALE)
--	SystemFont_Shadow_Med1:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	SystemFont_Shadow_Med1:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Med1:SetShadowOffset(1, -1) 
--	SystemFont_Med2:SetFont(CLEAR_FONT, 14 * CF_SCALE)
--	SystemFont_Med3:SetFont(CLEAR_FONT, 13 * CF_SCALE)
--	SystemFont_Shadow_Med3:SetFont(CLEAR_FONT, 14 * CF_SCALE)
--	SystemFont_Shadow_Med3:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Med3:SetShadowOffset(1, -1) 
--	SystemFont_Large:SetFont(CLEAR_FONT, 13 * CF_SCALE)
--	SystemFont_Shadow_Large:SetFont(CLEAR_FONT, 17 * CF_SCALE)
--	SystemFont_Shadow_Large:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Large:SetShadowOffset(1, -1) 
--	SystemFont_Shadow_Huge1:SetFont(CLEAR_FONT, 20 * CF_SCALE)
--	SystemFont_Shadow_Huge1:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Huge1:SetShadowOffset(1, -1) 
--	SystemFont_OutlineThick_Huge2:SetFont(CLEAR_FONT, 22 * CF_SCALE, "THICKOUTLINE")
--	SystemFont_Shadow_Outline_Huge2:SetFont(CLEAR_FONT, 22 * CF_SCALE, "OUTLINE")
--	SystemFont_Shadow_Outline_Huge2:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Outline_Huge2:SetShadowOffset(2, -2)
--	SystemFont_Shadow_Huge3:SetFont(CLEAR_FONT, 25 * CF_SCALE)
--	SystemFont_Shadow_Huge3:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Huge3:SetShadowOffset(1, -1) 
--	SystemFont_OutlineThick_Huge4:SetFont(CLEAR_FONT, 26 * CF_SCALE, "THICKOUTLINE")
--	SystemFont_OutlineThick_WTF:SetFont(CLEAR_FONT, 112 * CF_SCALE, "THICKOUTLINE")
--	NumberFont_Shadow_Small:SetFont(CLEAR_FONT_CHAT, 12 * CF_SCALE)
--	NumberFont_Shadow_Small:SetTextColor(0, 0, 0)
--	NumberFont_Shadow_Small:SetShadowOffset(1, -1) 
--	NumberFont_OutlineThick_Mono_Small:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE")
--	NumberFont_Shadow_Med:SetFont(CLEAR_FONT_CHAT, 14 * CF_SCALE)
--	NumberFont_Shadow_Med:SetTextColor(0, 0, 0)
--	NumberFont_Shadow_Med:SetShadowOffset(1, -1) 
--	NumberFont_Outline_Med:SetFont(CLEAR_FONT_DAMAGE, 12 * CF_SCALE, "OUTLINE")		-- 3.1.3�汾Ĭ�����壺CLEAR_FONT_NUMBER
--	NumberFont_Outline_Large:SetFont(CLEAR_FONT_DAMAGE, 14 * CF_SCALE, "OUTLINE")	-- 3.1.3�汾Ĭ�����壺CLEAR_FONT_NUMBER
--	NumberFont_Outline_Huge:SetFont(CLEAR_FONT_DAMAGE, 20 * CF_SCALE, "THICKOUTLINE")
--	GameTooltipHeader:SetFont(CLEAR_FONT, 16 * CF_SCALE)
--	QuestFont_Large:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE)
--	QuestFont_Shadow_Huge:SetFont(CLEAR_FONT_QUEST, 17 * CF_SCALE)
--	QuestFont_Shadow_Huge:SetTextColor(0.49, 0.35, 0.05)
--	QuestFont_Shadow_Huge:SetShadowOffset(1, -1) 
--	MailFont_Large:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	SpellFont_Small:SetFont(CLEAR_FONT, 12 * CF_SCALE)
--	InvoiceFont_Med:SetFont(CLEAR_FONT, 12 * CF_SCALE)
--	InvoiceFont_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
--	Tooltip_Med:SetFont(CLEAR_FONT_CHAT, 13 * CF_SCALE)
--	Tooltip_Small:SetFont(CLEAR_FONT_CHAT, 12 * CF_SCALE)
--	AchievementFont_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
--	ReputationDetailFont:SetFont(CLEAR_FONT, 13 * CF_SCALE)
--	ReputationDetailFont:SetTextColor(0, 0, 0)
--	ReputationDetailFont:SetShadowColor(1, 1, 1) 
--	ReputationDetailFont:SetShadowOffset(1, -1) 

-------------------------------------------------------------------------------
-- ����Ϸ����: �洦�ɼ�����Ҫ������
-------------------------------------------------------------------------------
-- ������, ��ť, ���ܱ���(���������), ������(������־���), ���ѽ�ɫ����(�罻���), ��������, ����������(PvP���), ϵͳ�˵���Ŀ
	if (CanSetFont(GameFontNormal)) then 		GameFontNormal:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 15

-- ������, ϵͳ�˵���ť, �ɾ͵������ɾ���Ŀ(�ɾ����), ���������Ŀ, ����������(������־���), ��������
	if (CanSetFont(GameFontHighlight)) then 	GameFontHighlight:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 15

-- (δȷ��)
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ��14
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetTextColor(1.0, 0.82, 0); end	-- Ĭ��ֵ��(1.0, 0.82, 0)
-- ��ť(����ѡ״̬)
	if (CanSetFont(GameFontDisable)) then 	GameFontDisable:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
	if (CanSetFont(GameFontDisable)) then 	GameFontDisable:SetTextColor(0.6, 0.6, 0.6); end		-- Ĭ��ֵ: (0.5, 0.5, 0.5)

-- ����ɫ������
	if (CanSetFont(GameFontGreen)) then 		GameFontGreen:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 15
	if (CanSetFont(GameFontRed)) then 		GameFontRed:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
	if (CanSetFont(GameFontBlack)) then 		GameFontBlack:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
	if (CanSetFont(GameFontWhite)) then 		GameFontWhite:SetFont(CLEAR_FONT, 12 * CF_SCALE); end

-------------------------------------------------------------------------------
-- С����: ������С����ĵط�, ���ɫ�������, BUFFʱ��, �����
-------------------------------------------------------------------------------
-- ͷ��������, BUFFʱ��, δѡ�������ǩ, ����д󲿷���������, �츳�������, ͷ�ν���(�ɾ����), ��ѯ�������Ա��ɫ����(�罻���), 
-- ������վ����ϸ, վ�ӵȼ�(PvP���), �������Ŀ
	if (CanSetFont(GameFontNormalSmall)) then 			GameFontNormalSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 15

-- ��������, �����˵�ѡ��, ��ѡ�������ǩ, ��ɫ���ԡ����ܵ����֡�������Ŀ(��ɫ��Ϣ���), �츳����(�츳���), ��ɫ�ȼ���ְҵ����Ϣ��������Ϣ(�罻���), 
-- ��ϸ�����㡢�������ȷ�(PvP���), ʱ����Ϣ, ϵͳ�˵�����Ŀ
	if (CanSetFont(GameFontHighlightSmall)) then 			GameFontHighlightSmall:SetFont(CLEAR_FONT, 10 * CF_SCALE); end	-- Ĭ��ֵ: 15
	if (CanSetFont(GameFontHighlightSmallOutline)) then	GameFontHighlightSmallOutline:SetFont(CLEAR_FONT, 10 * CF_SCALE, "OUTLINE"); end

-- PvP�������, �Ŷ���尴ť��
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetFont(CLEAR_FONT, 10 * CF_SCALE); end	-- Ĭ��ֵ: 15
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetTextColor(0.6, 0.6, 0.6); end	-- Ĭ��ֵ: (0.5, 0.5, 0.5)

-- (δȷ��)
	if (CanSetFont(GameFontDarkGraySmall)) then 			GameFontDarkGraySmall:SetFont(CLEAR_FONT, 10 * CF_SCALE); end	-- Ĭ��ֵ: 15
	if (CanSetFont(GameFontDarkGraySmall)) then 			GameFontDarkGraySmall:SetTextColor(0.4, 0.4, 0.4); end	-- Ĭ��ֵ: (0.35, 0.35, 0.35)

-- (δȷ��)
	if (CanSetFont(GameFontGreenSmall)) then 				GameFontGreenSmall:SetFont(CLEAR_FONT, 10 * CF_SCALE); end	-- Ĭ��ֵ: 15
	if (CanSetFont(GameFontRedSmall)) then				GameFontRedSmall:SetFont(CLEAR_FONT, 10 * CF_SCALE); end

-- ��С����
	if (CanSetFont(GameFontHighlightExtraSmall)) then 	GameFontHighlightExtraSmall:SetFont(CLEAR_FONT, 9 * CF_SCALE); end		-- Ĭ��ֵ: 15

-------------------------------------------------------------------------------
-- ������: ����
-------------------------------------------------------------------------------
-- ʱ��, ���
	if (CanSetFont(GameFontNormalLarge)) then 			GameFontNormalLarge:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 17
	if (CanSetFont(GameFontHighlightLarge)) then 			GameFontHighlightLarge:SetFont(CLEAR_FONT, 11 * CF_SCALE); end

-- ���������
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 17
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetTextColor(0.6, 0.6, 0.6); end	-- Ĭ��ֵ: (0.5, 0.5, 0.5)

-- (δȷ��)
	if (CanSetFont(GameFontGreenLarge)) then 				GameFontGreenLarge:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 17
	if (CanSetFont(GameFontRedLarge)) then 				GameFontRedLarge:SetFont(CLEAR_FONT, 12 * CF_SCALE); end

-------------------------------------------------------------------------------
-- �޴�����: Raid����
-------------------------------------------------------------------------------
	if (CanSetFont(GameFontNormalHuge)) then				GameFontNormalHuge:SetFont(CLEAR_FONT, 18 * CF_SCALE); end	-- Ĭ��ֵ: 20


-- -----------------------------------------------------------------------------
-- Boss��������
-- -----------------------------------------------------------------------------
	if (CanSetFont(BossEmoteNormalHuge)) then			BossEmoteNormalHuge:SetFont(CLEAR_FONT, 24 * CF_SCALE); end		-- Ĭ��ֵ��25


-- -----------------------------------------------------------------------------
-- ��������: ������, ���, ������, ��Ʒ��ջ����
-------------------------------------------------------------------------------
-- ���, ��Ʒ��Buff��ջ����
	if (CanSetFont(NumberFontNormal)) then				NumberFontNormal:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE"); end		-- Ĭ��ֵ: 12
	if (CanSetFont(NumberFontNormalYellow)) then 			NumberFontNormalYellow:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE); end

-- �������İ�����
	if (CanSetFont(NumberFontNormalSmall)) then 			NumberFontNormalSmall:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE"); end		-- Ĭ��ֵ: 11
	if (CanSetFont(NumberFontNormalSmallGray)) then 		NumberFontNormalSmallGray:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "THICKOUTLINE"); end

-- (δȷ��)
	if (CanSetFont(NumberFontNormalLarge)) then 			NumberFontNormalLarge:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE"); end		-- Ĭ��ֵ: 14

-- ���ͷ���ϵı�����ָʾ
	if (CanSetFont(NumberFontNormalHuge)) then			NumberFontNormalHuge:SetFont(CLEAR_FONT_DAMAGE, 14 * CF_SCALE, "THICKOUTLINE"); end	-- Ĭ��ֵ: 20
--	if (CanSetFont(NumberFontNormalHuge)) then				NumberFontNormalHuge:SetAlpha(30); end

-------------------------------------------------------------------------------
-- ���촰��������������������
-------------------------------------------------------------------------------
-- �������������
	if (CanSetFont(ChatFontNormal)) then 				ChatFontNormal:SetFont(CLEAR_FONT_CHAT, 11 * CF_SCALE); end	-- Ĭ��ֵ: 14

-- ��ѡ����������С
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}

-- ���촰��Ĭ������
	if (CanSetFont(ChatFontSmall)) then 				ChatFontSmall:SetFont(CLEAR_FONT_CHAT, 11 * CF_SCALE); end	-- Ĭ��ֵ: 12

-------------------------------------------------------------------------------
-- ������־: ������־���鼮��
-------------------------------------------------------------------------------
-- �������
	if (CanSetFont(QuestTitleFont)) then 				QuestTitleFont:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end	-- Ĭ��ֵ: 17
	if (CanSetFont(QuestTitleFont)) then 				QuestTitleFont:SetShadowColor(0.54, 0.4, 0.1); end		-- Ĭ��ֵ: (0, 0, 0)

-- ��������
	if (CanSetFont(QuestFont)) then					QuestFont:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end		-- Ĭ��ֵ: 14
	if (CanSetFont(QuestFont)) then					QuestFont:SetTextColor(0.15, 0.09, 0.04); end			-- Ĭ��ֵ: (0, 0, 0)

-- ����Ŀ��
	if (CanSetFont(QuestFontNormalSmall)) then		QuestFontNormalSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE); end	-- Ĭ��ֵ: 14
	if (CanSetFont(QuestFontNormalSmall)) then		QuestFontNormalSmall:SetShadowColor(0.54, 0.4, 0.1); end	-- Ĭ��ֵ: (0.3, 0.18, 0)

-- �������
	if (CanSetFont(QuestFontHighlight)) then 			QuestFontHighlight:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end	-- Ĭ��ֵ: 13

-- -----------------------------------------------------------------------------
-- ��Ʒ��Ϣ: ��Щ"���Ҽ��Ķ�"����Ʒ(������Ʒ����������, �������Я�����鼮, �ż��ĸ�����)
-- -----------------------------------------------------------------------------
	if (CanSetFont(ItemTextFontNormal)) then 	 	  	ItemTextFontNormal:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end		-- Ĭ��ֵ��15
	if (CanSetFont(ItemTextFontNormal)) then			ItemTextFontNormal:SetShadowColor(0.18, 0.12, 0.06); end	-- Ĭ��ֵ��(0.18, 0.12, 0.06)

-- -----------------------------------------------------------------------------
-- �ʼ�
-- -----------------------------------------------------------------------------
	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end	-- Ĭ��ֵ��15
	if (CanSetFont(MailTextFontNormal)) then 		   	MailTextFontNormal:SetTextColor(0.18, 0.12, 0.06); end		-- Ĭ��ֵ��(0.18, 0.12, 0.06)
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowColor(0.54, 0.4, 0.1); end
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowOffset(1, -1); end

-- -----------------------------------------------------------------------------
-- ���ܣ��������ͣ������������س��ȣ������ܵȼ�
-- -----------------------------------------------------------------------------
	if (CanSetFont(SubSpellFont)) then				SubSpellFont:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end	-- Ĭ��ֵ��12
	if (CanSetFont(SubSpellFont)) then 	   			SubSpellFont:SetTextColor(0.35, 0.2, 0); end	-- Ĭ��ֵ��(0.35, 0.2, 0)

-------------------------------------------------------------------------------
-- �Ի���ť: "ͬ��"������
-------------------------------------------------------------------------------
	if (CanSetFont(DialogButtonNormalText)) then 		DialogButtonNormalText:SetFont(CLEAR_FONT, 11 * CF_SCALE); end	-- Ĭ��ֵ: 13
	if (CanSetFont(DialogButtonHighlightText)) then 	DialogButtonHighlightText:SetFont(CLEAR_FONT, 11 * CF_SCALE); end

-------------------------------------------------------------------------------
-- �����л���ʾ: ����Ļ����֪ͨ
-------------------------------------------------------------------------------
-- ��������
	if (CanSetFont(ZoneTextFont)) then				ZoneTextFont:SetFont(CLEAR_FONT, 24 * CF_SCALE, "THICKOUTLINE"); end		-- Ĭ��ֵ: 112
	if (CanSetFont(ZoneTextFont)) then				ZoneTextFont:SetShadowColor(0, 0, 0); end	-- Ĭ��ֵ: (1.0, 0.9294, 0.7607)
	if (CanSetFont(ZoneTextFont)) then				ZoneTextFont:SetShadowOffset(1, -1); end

-- ��������
	if (CanSetFont(SubZoneTextFont)) then				SubZoneTextFont:SetFont(CLEAR_FONT, 20 * CF_SCALE, "THICKOUTLINE"); end		-- Ĭ��ֵ: 26

-------------------------------------------------------------------------------
-- PvP��Ϣ: ��"�����е�����", "�������"��
-------------------------------------------------------------------------------
	if (CanSetFont(PVPInfoTextFont)) then				PVPInfoTextFont:SetFont(CLEAR_FONT, 18 * CF_SCALE, "THICKOUTLINE"); end		-- Ĭ��ֵ: 22

-------------------------------------------------------------------------------
-- ������Ϣ����: "��һ���������ڽ�����"������
-------------------------------------------------------------------------------
	if (CanSetFont(ErrorFont)) then					ErrorFont:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ĭ��ֵ: 17
	if (CanSetFont(ErrorFont)) then					ErrorFont:SetShadowOffset(1, -1); end	-- Ĭ��ֵ: (1, -1)


-------------------------------------------------------------------------------
-- ״̬��: ͷ�����е�����(����ֵ������ֵ/ŭ��ֵ/����ֵ��), ������(���顢������)
-------------------------------------------------------------------------------
	if (CanSetFont(TextStatusBarText)) then			TextStatusBarText:SetFont(CLEAR_FONT_EXP, 11 * CF_SCALE, "OUTLINE"); end	-- Ĭ��ֵ: 12

-------------------------------------------------------------------------------
-- ս����¼����
-------------------------------------------------------------------------------
	if (CanSetFont(CombatLogFont)) then				CombatLogFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end	-- Ĭ��ֵ: 16

-------------------------------------------------------------------------------
-- ��ʾ��(ToolTip)
-------------------------------------------------------------------------------
-- ��ʾ������
	if (CanSetFont(GameTooltipText)) then				GameTooltipText:SetFont(CLEAR_FONT_ITEM, 11 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- װ���Ƚϵ�С�ֲ���
	if (CanSetFont(GameTooltipTextSmall)) then		GameTooltipTextSmall:SetFont(CLEAR_FONT_ITEM, 10 * CF_SCALE); end	-- Ĭ��ֵ: 12

-- ��ʾ�����
	if (CanSetFont(GameTooltipHeaderText)) then		GameTooltipHeaderText:SetFont(CLEAR_FONT, 11 * CF_SCALE, "OUTLINE"); end	-- Ĭ��ֵ: 16

-------------------------------------------------------------------------------
-- �����ͼ: λ�ñ���
-------------------------------------------------------------------------------
	if (CanSetFont(WorldMapTextFont)) then			WorldMapTextFont:SetFont(CLEAR_FONT, 90 * CF_SCALE, "THICKOUTLINE"); end	-- Ĭ��ֵ: 102
	if (CanSetFont(WorldMapTextFont)) then			WorldMapTextFont:SetShadowColor(0, 0, 0); end	-- Ĭ��ֵ: (1.0, 0.9294, 0.7607)
	if (CanSetFont(WorldMapTextFont)) then			WorldMapTextFont:SetShadowOffset(1, -1); end
--	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetAlpha(0.4); end

-------------------------------------------------------------------------------
-- ������: �������ʼ����ķ�����
-------------------------------------------------------------------------------
	if (CanSetFont(InvoiceTextFontNormal)) then		InvoiceTextFontNormal:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end	-- Ĭ��ֵ: 12
	if (CanSetFont(InvoiceTextFontNormal)) then		InvoiceTextFontNormal:SetTextColor(0.15, 0.09, 0.04); end	-- Ĭ��ֵ: (0.18, 0.12, 0.06)
	if (CanSetFont(InvoiceTextFontSmall)) then		InvoiceTextFontSmall:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end	-- Ĭ��ֵ: 10
	if (CanSetFont(InvoiceTextFontSmall)) then		InvoiceTextFontSmall:SetTextColor(0.15, 0.09, 0.04); end	-- Ĭ��ֵ: (0.18, 0.12, 0.06)

-- -----------------------------------------------------------------------------
-- ս������: ��ѩ����ս��ָʾ��
-- -----------------------------------------------------------------------------

	if (CanSetFont(CombatTextFont)) then				CombatTextFont:SetFont(CLEAR_FONT_DAMAGE, 25 * CF_SCALE, "OUTLINE"); end		-- Ĭ��ֵ��25
	if (CanSetFont(CombatTextFont)) then				CombatTextFont:SetShadowOffset(0, 0); end

-------------------------------------------------------------------------------
-- ӰƬ��Ļ����(New in WotLK/3.x)
-------------------------------------------------------------------------------
	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetFont(CLEAR_FONT, 24 * CF_SCALE); end		-- Ĭ��ֵ: 25
	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetTextColor(1.0, 0.78, 0); end	-- Ĭ��ֵ: (1.0, 0.78, 0)

-------------------------------------------------------------------------------
-- �ɾ�ϵͳ(New in WotLK/3.x)
-------------------------------------------------------------------------------
-- �ɾ�ϵͳ��������ϵĳɾͷ���
	if (CanSetFont(AchievementPointsFont)) then		AchievementPointsFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- �ɾ�ϵͳ�ܻ����ĳɾͷ���
	if (CanSetFont(AchievementPointsFontSmall)) then	AchievementPointsFontSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- �ɾ�ϵͳ����������
	if (CanSetFont(AchievementDescriptionFont)) then	AchievementDescriptionFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- �ɾ�ϵͳ�����ĸ�����
	if (CanSetFont(AchievementCriteriaFont)) then		AchievementCriteriaFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- �ɾ�ϵͳ��¼������
	if (CanSetFont(AchievementDateFont)) then			AchievementDateFont:SetFont(CLEAR_FONT, 10 * CF_SCALE); end		-- Ĭ��ֵ: 13

-- -----------------------------------------------------------------------------
-- �����, ����ϵͳ���(��ȷ�ϣ�New in WotLK/3.2+)
-- -----------------------------------------------------------------------------
	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetFont(CLEAR_FONT, 15 * CF_SCALE); end		-- Ĭ��ֵ��15
	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetTextColor(1.0, 1.0, 1.0); end	-- Ĭ��ֵ��(1.0, 1.0, 1.0)

end

-- =============================================================================
--  C. ÿ��һ���������ʱ����������Ĺ���
--  ������ϲ�������ҵĲ����
-- =============================================================================
ClearFont:SetScript("OnEvent",
		function()
			if (event == "ADDON_LOADED") then
				ClearFont:ApplySystemFonts()
			end
		end)
ClearFont:RegisterEvent("ADDON_LOADED")

-- =============================================================================
--  D. ��һ������ʱӦ�������趨
--  �����ܹ�������
-- =============================================================================
ClearFont:ApplySystemFonts()
