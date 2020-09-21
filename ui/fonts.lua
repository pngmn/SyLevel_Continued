local _, ns = ...
local SyLevel = ns.SyLevel

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "Font Settings"
frame.parent = ns.TrivName

frame:SetScript("OnShow", function(self)
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

function frame:CreateOptions()
	local font = SyLevelDB.FontSettings

	local title = ns.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ns.TrivName..": Font Settings")

	local fontsLabel = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
	fontsLabel:SetText("Typeface")

	local fontsDDown = CreateFrame("Button", ns.Name.."_FontsDropdown", self, "UIDropDownMenuTemplate")
	fontsDDown:SetPoint("TOPLEFT", fontsLabel, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDown, 200)

	local fontsLabelAlign = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabelAlign:SetPoint("TOPLEFT", fontsLabel, "BOTTOMLEFT", 0, -48)
	fontsLabelAlign:SetText("Align")

	local fontsDDownAlign = CreateFrame("Button", ns.Name.."_AlignDropdown", self, "UIDropDownMenuTemplate")
	fontsDDownAlign:SetPoint("TOPLEFT", fontsLabelAlign, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDownAlign, 200)

	local fontsLabelRef = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabelRef:SetPoint("TOPLEFT", fontsLabelAlign, "BOTTOMLEFT", 0, -48)
	fontsLabelRef:SetText("Reference")

	local fontsDDownRef = CreateFrame("Button", ns.Name.."_ReferenceDropdown", self, "UIDropDownMenuTemplate")
	fontsDDownRef:SetPoint("TOPLEFT", fontsLabelRef, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDownRef, 200)

	local regionPoints = {"TOP", "BOTTOM", "LEFT", "RIGHT", "CENTER", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}

	do
		local function DropDown_OnClick()
			local t = SyLevel.media:List("font")
			font.typeface = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDownRef_OnClick()
			local t = regionPoints
			font.reference = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDownAlign_OnClick()
			local t = regionPoints
			font.reference = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDown_OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Set your preferred font for text display.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local function UpdateSelected()
			local t = SyLevel.media:List("font")
			for i=1,#t do
				if font.typeface == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDown, i)
				end
			end
		end

		local function UpdateSelectedRef()
			local t = regionPoints
			for i=1,#t do
				if font.reference == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDownRef, i)
				end
			end
		end

		local function UpdateSelectedAlign()
			local t = regionPoints
			for i=1,#t do
				if font.align == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDownAlign, i)
				end
			end
		end

		local function DropDown_init()
			local info
			local t = SyLevel.media:List("font")
			for i=1,#t do
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
				info.value = i
				info.func = DropDown_OnClick
				UIDropDownMenu_AddButton(info)
			end
		end

		local function DropDownRef_init()
			local info
			local t = regionPoints
			for i=1,#t do
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
				info.value = i
				info.func = DropDownRef_OnClick
				UIDropDownMenu_AddButton(info)
			end
		end

		local function DropDownAlign_init()
			local info
			local t = regionPoints
			for i=1,#t do
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
				info.value = i
				info.func = DropDownAlign_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		fontsDDown:SetScript("OnEnter", DropDown_OnEnter)
		fontsDDown:SetScript("OnLeave", DropDown_OnLeave)

		function frame.refresh()
			UIDropDownMenu_Initialize(fontsDDown, DropDown_init)
			UpdateSelected()
			UIDropDownMenu_Refresh(fontsDDown)

			UIDropDownMenu_Initialize(fontsDDownAlign, DropDownAlign_init)
			UpdateSelectedAlign()
			UIDropDownMenu_Refresh(fontsDDownAlign)

			UIDropDownMenu_Initialize(fontsDDownRef, DropDownRef_init)
			UpdateSelectedRef()
			UIDropDownMenu_Refresh(fontsDDownRef)
		end

		self:refresh()
	end

	local s1 = ns.createSlider(frame, "Font Size", 2, 60, 1)
	s1:SetPoint("TOPLEFT", fontsDDownRef, "BOTTOMLEFT", 10, -32)
	s1:SetValue(font.size)
	s1:Show()

	local e1 = ns.createEditBox(self, "Font Size", 40, 20, true, 2)
	e1:SetPoint("TOP", s1, "BOTTOM", 0, -7)
	e1:SetNumber(font.size)
	e1.Update = function()
		e1:SetNumber(font.size)
		s1:SetValue(font.size)
		e1:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e1:SetScript("OnEnterPressed", function()
		local value = tonumber(self:GetText())
		if not value then
			value = font.size
		elseif value < 2 then
			value = 2
		elseif value > 60 then
			value = 60
		end
		font.size = value
		e1.Update()
	end)
	s1:SetScript("OnValueChanged", function()
		font.size = self:GetValue()
		e1.Update()
	end)

	local s2 = ns.createSlider(frame, "X Offset", -64, 64, 1)
	s2:SetPoint("LEFT", s1, "RIGHT", 10, 0)
	s2:SetValue(font.offsetx)
	s2:Show()
	local e2 = ns.createEditBox(self, "X Offset", 40, 20, false, 4)
	e2:SetPoint("TOP", s2, "BOTTOM", 0, -7)
	e2:SetText(font.offsetx or 0)
	e2.Update = function()
		e2:SetText(font.offsetx)
		s2:SetValue(font.offsetx)
		e2:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e2:SetScript("OnEnterPressed", function()
		local value = tonumber(self:GetText())
		if not value then
			value = font.offsetx
		elseif value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		font.offsetx = value
		e2.Update()
	end)
	s2:SetScript("OnValueChanged", function()
		font.offsetx = self:GetValue()
		e2.Update()
	end)

	local s3 = ns.createSlider(frame, "Y Offset", -64, 64, 1)
	s3:SetPoint("LEFT", s2, "RIGHT",10,0)
	s3:SetValue(font.offsety)
	s3:Show()
	local e3 = ns.createEditBox(self, "Y Offset", 40, 20, false, 4)
	e3:SetPoint("TOP", s3, "BOTTOM", 0, -7)
	e3:SetText(font.offsety or 0)
	e3.Update = function()
		e3:SetText(font.offsety)
		s3:SetValue(font.offsety)
		e3:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e3:SetScript("OnEnterPressed", function()
		local value = tonumber(self:GetText())
		if not value then
			value = font.offsety
		elseif value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		font.offsety = value
		e3.Update()
	end)
	s3:SetScript("OnValueChanged", function()
		font.offsety = self:GetValue()
		e3.Update()
	end)
	--[[ Sliders and Editboxes ]]--
end

InterfaceOptions_AddCategory(frame)