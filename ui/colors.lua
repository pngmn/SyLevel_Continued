local _, ns = ...
local SyLevel = ns.SyLevel

local colorTable = ns.colorTable
local colorFunc = ns.colorFunc

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = "Colors"
frame.parent = ns.Name

frame:SetScript("OnShow", function(self)
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

function frame:CreateOptions()
	local title = ns.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ns.Name..": Colors")
	
	local methods = {
		"Low Green, Yellow, Red High",
		"Low Red, Yellow, Green High",
		"Predefined Colors",
		"Current Item Level Comparison",
		"Low Green, Yellow, Red High > 450",
		"Red Green, Yellow, Green High > 450",
		"Class Coloring",
		"Quality Coloring"
	}
	
	local colorDropdown = CreateFrame("Button", ns.Name.."OptFColorDropdown", self, "UIDropDownMenuTemplate")
	colorDropdown:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -16, -6)
	UIDropDownMenu_SetWidth(colorDropdown, 200, 2)

	do
		local function DropDown_OnClick(self)
			SyLevelDB.FilterSettings.colorFunc = self.value
			SyLevel:CallOptionCallbacks()
			
			SyLevel:SetColorFunc(self.value)
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local function DropDown_OnEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Sets the mode of coloring.", nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local function UpdateSelected(self)
			UIDropDownMenu_SetSelectedID(colorDropdown, SyLevelDB.ColorFunc)
		end

		local function DropDown_init(self)
			local info

			for i=1,#methods do
				info = UIDropDownMenu_CreateInfo()
				info.text = methods[i]
				info.value = i
				info.func = DropDown_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		colorDropdown:SetScript("OnEnter", DropDown_OnEnter)
		colorDropdown:SetScript("OnLeave", DropDown_OnLeave)

		function frame:refresh()
			UIDropDownMenu_Initialize(colorDropdown, DropDown_init)
			UpdateSelected()
		end
		self:refresh()
	end
end

InterfaceOptions_AddCategory(frame)
