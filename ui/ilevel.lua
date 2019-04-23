local _, ns = ...
local SyLevel = ns.SyLevel

local colorTable = ns.colorTable

local frame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = 'Filters'
frame.parent = 'SyLevel'

frame:SetScript('OnShow', function(self)
	self:CreateOptions()
	self:SetScript('OnShow', nil)
end)

function frame:CreateOptions()
	local title = ns.createFontString(self, 'GameFontNormalLarge')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText'SyLevel: Filters'

	local thresLabel = ns.createFontString(self, 'GameFontNormalSmall')
	thresLabel:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -16)
	--thresLabel:SetText('')
	
	local s1 = ns.createSlider(self, "ItemLevelThreshold",1,795,1)
	s1:SetPoint('TOPLEFT', thresLabel, 'BOTTOMLEFT', 0, 0)
	
	local e1 = ns.createEditBox(self,"ItemLevelThreshold",40,20,true,3)
	e1:SetPoint('TOP', s1, 'BOTTOM',0,-6)
	
	do -- After Variables Loaded?
		local UpdateSlider = function(self)
			local filters = SyLevelDB.FilterSettings
			local threshold = 1
			if(filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			s1:SetValue(threshold)
		end
		
		local UpdateEditbox = function(self)
			local filters = SyLevelDB.FilterSettings
			local threshold = 1
			if(filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			e1:SetNumber(threshold)
			e1:ClearFocus()
		end
		
		s1:SetScript("OnValueChanged",function(self,value)
			SyLevelDB.FilterSettings.ilevel = value
			SyLevel:UpdateAllPipes()
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
			SyLevelDB.FilterSettings.ilevel = value
			SyLevel:UpdateAllPipes()
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
