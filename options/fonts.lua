local P, C = unpack(select(2, ...))

local colorTable = P.colorTable

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Font Settings"
frame.parent = P

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

do
	local db = PingumaniaItemlevelDB.FontSettings
	
	local title = P.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(P.Name..": Font Settings")
	
	local fontsLabel = P.createFontString(self, "GameFontNormalSmall")
	fontsLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
	fontsLabel:SetText("Typeface")
	
	local fontsDDown = CreateFrame("Button", P.Name.."_FontsDropdown", self, "UIDropDownMenuTemplate")
	fontsDDown:SetPoint("TOPLEFT", fontsLabel, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(fontsDDown,200)
	
	do
		local DropDown_OnClick = function(self)
			local t = P.media:List("font")
			db.typeface = t[self.value]
			P:SetFontSettings()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local DropDown_OnEnter = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Set your preferred font for text display.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local UpdateSelected = function(self)
			local t = P.media:List("font")
			for i=1,#t do
				if db.typeface == t[i] then
					UIDropDownMenu_SetSelectedID(fontsDDown,i)
				end
			end
		end

		local DropDown_init = function(self)
			local info
			local t = P.media:List("font")
			for i=1,#t do
				
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
				info.value = i
				info.func = DropDown_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		fontsDDown:SetScript("OnEnter", DropDown_OnEnter)
		fontsDDown:SetScript("OnLeave", DropDown_OnLeave)

		function frame:refresh()
			UIDropDownMenu_Initialize(fontsDDown, DropDown_init)
			UpdateSelected()			
			UIDropDownMenu_Refresh(fontsDDown)
		end
		self:refresh()
	end
	
	local s1 = P.createSlider(frame, "Font Size", 2, 60, 1)
	s1:SetPoint("TOPLEFT", fontsDDown, "BOTTOMLEFT", 10, -16)
	s1:SetValue(db.size)
	s1:Show()
	
	local e1 = P.createEditBox(self, "Font Size", 40, 20, true, 2)
	e1:SetPoint("TOP", s1, "BOTTOM")
	e1:SetNumber(db.size)
	e1.Update = function()
		e1:SetNumber(db.size)
		s1:SetValue(db.size)
		
		e1:ClearFocus()
		P:SetFontSettings()
	end
	e1:SetScript("OnEnterPressed", function(self)
		local value = tonumber(self:GetText())
		if not value or value < 2 then
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
	
	local s2 = P.createSlider(frame, "X Offset", -64, 64, 1)
	s2:SetPoint("LEFT", s1, "RIGHT", 10, 0)
	s2:SetValue(db.offsetx)
	s2:Show()	
	local e2 = P.createEditBox(self, "X Offset", 40, 20, false, 4)
	e2:SetPoint("TOP", s2, "BOTTOM")
	e2:SetText(db.offsetx or 0)
	e2.Update = function()
		e2:SetText(db.offsetx)
		s2:SetValue(db.offsetx)
		
		e2:ClearFocus()
		P:SetFontSettings()
	end
	e2:SetScript("OnEnterPressed",function(self)
		local value = tonumber(self:GetText())
		if value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		db.offsetx = value
		e2.Update()
	end)
	s2:SetScript("OnValueChanged",function(self)
		db.offsetx = self:GetValue()
		e2.Update()
	end)
	
	local s3 = P.createSlider(frame, "Y Offset", -64, 64, 1)
	s3:SetPoint("LEFT",s2,"RIGHT",10,0)
	s3:SetValue(db.offsety)
	s3:Show()	
	local e3 = P.createEditBox(self, "Y Offset", 40, 20, false, 4)
	e3:SetPoint("TOP",s3,"BOTTOM")
	e3:SetText(db.offsety or 0)
	e3.Update = function()
		e3:SetText(db.offsety)
		s3:SetValue(db.offsety)
		
		e3:ClearFocus()
		P:SetFontSettings()
	end
	e3:SetScript("OnEnterPressed",function(self)
		local value = tonumber(self:GetText())
		if value < -64 then
			value = -64
		elseif value > 64 then
			value = 64
		end
		db.offsety = value
		e3.Update()
	end)
	s3:SetScript("OnValueChanged",function(self)
		db.offsety = self:GetValue()
		e3.Update()
	end)	
end

InterfaceOptions_AddCategory(frame)
