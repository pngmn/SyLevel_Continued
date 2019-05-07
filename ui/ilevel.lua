local _, ns = ...
local SyLevel = ns.SyLevel

local colorTable = ns.colorTable
local MAX_ITEM_LEVEL = SyLevel.MAX_ITEM_LEVEL

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "Filters"
frame.parent = ns.Name

frame:SetScript("OnShow", function(self)
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

function frame:CreateOptions()   
    local filters = SyLevelDB.FilterSettings
	local title = ns.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ns.Name..": Filters")

	local ilevelThresLabel = ns.createFontString(self, "GameFontNormalSmall")
	ilevelThresLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
	--ilevelThresLabel:SetText("")
	
	local s1 = ns.createSlider(self, "ItemLevelThreshold", 1, MAX_ITEM_LEVEL, 1)
	s1:SetPoint("TOPLEFT", ilevelThresLabel, "BOTTOMLEFT", 0, 0)
	
	local e1 = ns.createEditBox(self,"ItemLevelThreshold", 40, 20, true, 3)
	e1:SetPoint("TOP", s1, "BOTTOM", 0, -6)
	
    local qualityThresLabel = ns.createFontString(self, "GameFontNormalSmall")
	qualityThresLabel:SetPoint("TOPLEFT", e1, "BOTTOMLEFT", 0, -48)
	qualityThresLabel:SetText("Reference")
	
	local d1 = CreateFrame("Button", ns.Name.."_QualityThresholdDropdown", self, "UIDropDownMenuTemplate")
	d1:SetPoint("TOPLEFT", qualityThresLabel, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(d1, 200)
    
	do -- After Variables Loaded?
		local function UpdateSlider(self)
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			s1:SetValue(threshold)
		end
		
		local function UpdateEditbox(self)
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end	
			e1:SetNumber(threshold)
			e1:ClearFocus()
		end
		
		s1:SetScript("OnValueChanged", function(self,value)
			filters.ilevel = value
			SyLevel:UpdateAllPipes()
			UpdateSlider()
			UpdateEditbox()
		end)
		
		e1:SetScript("OnEnterPressed", function(self)
			local value = tonumber(self:GetText())
			if not value or value < 1 then
				value = 1
			elseif value > MAX_ITEM_LEVEL then
				value = MAX_ITEM_LEVEL
			end
			filters.ilevel = value
			SyLevel:UpdateAllPipes()
			UpdateSlider()
			UpdateEditbox()
			self:ClearFocus()
		end)		
        
        local ItemQualityOptions = {"Poor", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Artifact", "Heirloom"}
        local function DropDown_OnClick(self)
			local t = ItemQualityOptions
			filters.quality = t[self:GetID()]
			SyLevel:UpdateAllPipes()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDown_OnEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Set your item quality filter.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local function UpdateSelected(self)
			local t = ItemQualityOptions
			for i=1,#t do
				if filters.quality == t[i]:GetID() then
					UIDropDownMenu_SetSelectedID(d1, i)
				end
			end
		end
        
		local function DropDown_init(self)
			local info
			local t = ItemQualityOptions
			for i=0,#t-1 do
				
				info = UIDropDownMenu_CreateInfo()
				info.text = t[i]
                local color = ITEM_QUALITY_COLORS[i]
                info.text:SetTextColor(color.r, color.g, color.b)
				info.value = i
				info.func = DropDown_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		d1:SetScript("OnEnter", DropDown_OnEnter)
		d1:SetScript("OnLeave", DropDown_OnLeave)

		function frame:refresh()
            UpdateSlider()
			UpdateEditbox()
			UIDropDownMenu_Initialize(d1, DropDown_init)
			UpdateSelected()
			UIDropDownMenu_Refresh(d1)
		end		
        
		self:refresh()
	end   
end

InterfaceOptions_AddCategory(frame)