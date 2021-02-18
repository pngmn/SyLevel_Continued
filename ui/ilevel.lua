local _, ns = ...
local SyLevel = ns.SyLevel

local MAX_ITEM_LEVEL = SyLevel.MAX_ITEM_LEVEL

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "Filters"
frame.parent = ns.TrivName

frame:SetScript("OnShow", function(self)
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

function frame:CreateOptions()
	local filters = SyLevelDB.FilterSettings
	local title = ns.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ns.TrivName..": Filters")

	local ilevelThresLabel = ns.createFontString(self, "GameFontNormalSmall")
	ilevelThresLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)

	local s1 = ns.createSlider(self, "Item Level Threshold", 1, MAX_ITEM_LEVEL, 1)
	s1:SetPoint("TOPLEFT", ilevelThresLabel, "BOTTOMLEFT", 0, -16)

	local e1 = ns.createEditBox(self, "ItemLevelThreshold", 40, 20, true, 3)
	e1:SetPoint("TOP", s1, "BOTTOM", 0, -6)

	local ItemQualityOptions = {"Poor", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Artifact", "Heirloom"}

	local qualityThresLabel = ns.createFontString(self, "GameFontNormalSmall")
	qualityThresLabel:SetPoint("TOPLEFT", s1, "BOTTOMLEFT", 0, -48)
	qualityThresLabel:SetText("Item Quality Threshold")

	local d1 = CreateFrame("Button", ns.Name.."_QualityThresholdDropdown", self, "UIDropDownMenuTemplate")
	d1:SetPoint("TOPLEFT", qualityThresLabel, "BOTTOMLEFT", -6, -4)
	UIDropDownMenu_SetWidth(d1, 200)
	UIDropDownMenu_SetText(d1,ITEM_QUALITY_COLORS[filters.quality].hex .. ItemQualityOptions[filters.quality + 1] .. "|r")

	do -- After Variables Loaded?
		local function UpdateSlider()
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end
			s1:SetValue(threshold)
		end

		local function UpdateEditbox()
			local threshold = 1
			if (filters and filters.ilevel) then
				threshold = filters.ilevel
			end
			e1:SetNumber(threshold)
			e1:ClearFocus()
		end

		s1:SetScript("OnValueChanged", function(_, value)
			filters.ilevel = value
			SyLevel:UpdateAllPipes()
			UpdateSlider()
			UpdateEditbox()
		end)

		e1:SetScript("OnEnterPressed", function()
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

		local function DropDown_OnClick(info)
			filters.quality = info.value - 1
			SyLevel:UpdateAllPipes()
			UIDropDownMenu_SetText(d1, ITEM_QUALITY_COLORS[filters.quality].hex .. ItemQualityOptions[info.value] .. "|r")
		end

		local function DropDown_OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Set your item quality filter.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local function DropDown_init()
			local info
			local t = ItemQualityOptions
			for i = 1, #t do
				info = UIDropDownMenu_CreateInfo()
				info.text = ITEM_QUALITY_COLORS[i-1].hex .. t[i] .. "|r"
				info.value = i
				info.func = DropDown_OnClick
				info.checked = i == filters.quality + 1
				UIDropDownMenu_AddButton(info)
			end
		end

		d1:SetScript("OnEnter", DropDown_OnEnter)
		d1:SetScript("OnLeave", DropDown_OnLeave)

		function frame.refresh()
			UpdateSlider()
			UpdateEditbox()
			UIDropDownMenu_Initialize(d1, DropDown_init)
		end

		self:refresh()
	end
end

InterfaceOptions_AddCategory(frame)