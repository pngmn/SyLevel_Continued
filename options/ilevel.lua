local P, C = unpack(select(2, ...))

local colorTable = P.colorTable

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Filters"
frame.parent = P

do
	local title = P.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(P.Name..": Filters")

	local thresLabel = P.createFontString(self, "GameFontNormalSmall")
	thresLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
	--thresLabel:SetText("")
	
	local s1 = P.createSlider(self, "ItemLevelThreshold", 1, 795, 1)
	s1:SetPoint("TOPLEFT", thresLabel, "BOTTOMLEFT", 0, 0)
	
	local e1 = P.createEditBox(self,"ItemLevelThreshold", 40, 20, true, 3)
	e1:SetPoint("TOP", s1, "BOTTOM", 0, -6)
	
	do -- After Variables Loaded?
		local UpdateSlider = function(self)
			local filters = PingumaniaItemlevelDB.FilterSettings
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			s1:SetValue(threshold)
		end
		
		local UpdateEditbox = function(self)
			local filters = PingumaniaItemlevelDB.FilterSettings
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			e1:SetNumber(threshold)
			e1:ClearFocus()
		end
		
		s1:SetScript("OnValueChanged",function(self,value)
			PingumaniaItemlevelDB.FilterSettings.ilevel = value
			P:UpdateAllPipes()
			UpdateSlider()
			UpdateEditbox()
		end)
		
		e1:SetScript("OnEnterPressed",function(self)
			local value = tonumber(self:GetText())
			if not value or value < 1 then
				value = 1
			elseif value > 795 then
				value = 795
			end
			PingumaniaItemlevelDB.FilterSettings.ilevel = value
			P:UpdateAllPipes()
			UpdateSlider()
			UpdateEditbox()
			self:ClearFocus()
		end)		
	
		function frame:refresh()
			UpdateSlider()
			UpdateEditbox()
		end
		self:refresh()
	end
end

InterfaceOptions_AddCategory(frame)
