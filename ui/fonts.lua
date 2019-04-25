local _, ns = ...
local SyLevel = ns.SyLevel

local colorTable = ns.colorTable
local pendingConfig

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "Font Settings"
frame.parent = "SyLevel"

frame:SetScript("OnShow", function(self) 	
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

local sliders = {
	["size"] = {
		name = "Font Size",
		low = 8,
		high = 32,
		step = 1,
	},
	["x"] = {
		name = "X Offset",
		low = -64,
		high = 64,
		step = 0.5,
	},
	["y"] = {
		name = "Y Offset",
		low = -64,
		high = 64,
		step = 0.5
	},
}

function frame:CreateOptions()
	local db = SyLevelDB.FontSettings
	
	local title = ns.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText"SyLevel: Font Settings"
	
	local fontsLabel = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
	fontsLabel:SetText("Typeface")
	
	local fontsDDown = CreateFrame("Button", "SyLevel_FontsDropdown", self, "UIDropDownMenuTemplate")
	fontsDDown:SetPoint("TOPLEFT", fontsLabel, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDown, 200)

	local fontsLabelAlign = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabelAlign:SetPoint("TOPLEFT", fontsLabel, "BOTTOMLEFT", 0, -48)
	fontsLabelAlign:SetText("Align")
	
	local fontsDDownAlign = CreateFrame("Button", "SyLevel_AlignDropdown", self, "UIDropDownMenuTemplate")
	fontsDDownAlign:SetPoint("TOPLEFT", fontsLabelAlign, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDownAlign, 200)

	local fontsLabelRef = ns.createFontString(self, "GameFontNormalSmall")
	fontsLabelRef:SetPoint("TOPLEFT", fontsLabelAlign, "BOTTOMLEFT", 0, -48)
	fontsLabelRef:SetText("Reference")
	
	local fontsDDownRef = CreateFrame("Button", "SyLevel_ReferenceDropdown", self, "UIDropDownMenuTemplate")
	fontsDDownRef:SetPoint("TOPLEFT", fontsLabelRef, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDownRef, 200)

	do
		local function DropDown_OnClick(self)
			local t = SyLevel.media:List("font")
			db.typeface = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDownRef_OnClick(self)
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
			db.reference = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDownAlign_OnClick(self)
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
			db.reference = t[self.value]
			SyLevel:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDown_OnEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Set your preferred font for text display.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local function UpdateSelected(self)
			local t = SyLevel.media:List("font")
			for i=1,#t do
				if db.typeface == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDown, i)
				end
			end
		end

		local function UpdateSelectedRef(self)
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
			for i=1,#t do
				if db.reference == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDownRef, i)
				end
			end
		end

		local function UpdateSelectedAlign(self)
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
			for i=1,#t do
				if db.align == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDownAlign, i)
				end
			end
		end

		local function DropDown_init(self)
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

		local function DropDownRef_init(self)
			local info
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
			for i=1,#t do
				
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
				info.value = i
				info.func = DropDownRef_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		local function DropDownAlign_init(self)
			local info
			local t = {"TOP", "BOTTOM", "LEFT", "RIGHT", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
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

		function frame:refresh()
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
	s1:SetValue(db.size)
	s1:Show()
	
	local e1 = ns.createEditBox(self, "Font Size", 40, 20, true, 2)
	e1:SetPoint("TOP", s1, "BOTTOM", 0, -7)
	e1:SetNumber(db.size)
	e1.Update = function()
		e1:SetNumber(db.size)
		s1:SetValue(db.size)
		e1:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e1:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if not value then
			value = db.size
		elseif value < 2 then
			value = 2
		elseif value > 60 then
			value = 60
		end
		db.size = value
		e1.Update()
	end)
	s1:SetScript("OnValueChanged", function(self)
		db.size = self:GetValue()
		e1.Update()
	end)
	
	local s2 = ns.createSlider(frame, "X Offset", -64, 64, 1)
	s2:SetPoint("LEFT", s1, "RIGHT", 10, 0)
	s2:SetValue(db.offsetx)
	s2:Show()	
	local e2 = ns.createEditBox(self, "X Offset", 40, 20, false, 4)
	e2:SetPoint("TOP", s2, "BOTTOM", 0, -7)
	e2:SetText(db.offsetx or 0)
	e2.Update = function()
		e2:SetText(db.offsetx)
		s2:SetValue(db.offsetx)
		e2:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e2:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if not value then
			value = db.offsetx	
		elseif value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		db.offsetx = value
		e2.Update()
	end)
	s2:SetScript("OnValueChanged", function(self)
		db.offsetx = self:GetValue()
		e2.Update()
	end)
	
	local s3 = ns.createSlider(frame, "Y Offset", -64, 64, 1)
	s3:SetPoint("LEFT", s2, "RIGHT",10,0)
	s3:SetValue(db.offsety)
	s3:Show()	
	local e3 = ns.createEditBox(self, "Y Offset", 40, 20, false, 4)
	e3:SetPoint("TOP", s3, "BOTTOM", 0, -7)
	e3:SetText(db.offsety or 0)
	e3.Update = function()
		e3:SetText(db.offsety)
		s3:SetValue(db.offsety)
		
		e3:ClearFocus()
		SyLevel:SetFontSettings()
	end
	e3:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if not value then
			value = db.offsety
		elseif value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		db.offsety = value
		e3.Update()
	end)
	s3:SetScript("OnValueChanged", function(self)
		db.offsety = self:GetValue()
		e3.Update()
	end)
	
	--[[ Sliders and Editboxes ]]--
	
end

InterfaceOptions_AddCategory(frame)