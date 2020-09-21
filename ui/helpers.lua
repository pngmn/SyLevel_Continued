local _, ns = ...
local SyLevel = ns.SyLevel

function ns.createFontString(parent, template)
	local label = parent:CreateFontString(nil, nil, template or "GameFontHighlight")
	label:SetJustifyH("LEFT")

	return label
end

ns.FontStyle = {
	NONE = "None",
	OUTLINE = "Outline",
	THICKOUTLINE = "Thick Outline",
	["NONE, MONOCHROME"] = "No Outline, Monochrome",
	["OUTLINE, MONOCHROME"] = "Outline, Monochrome", --Strange errors surrounding this.
	["THICKOUTLINE, MONOCHROME"] = "Thick Outline, Monochrome"
}

ns.Backdrop = {
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	tile = true, tileSize = 8, edgeSize = 16,
	insets = {left = 2, right = 2, top = 2, bottom = 2}
}

ns.FullAlign = {TOPLEFT = "TOPLEFT", TOP = "TOP", TOPRIGHT = "TOPRIGHT", LEFT = "LEFT", CENTER = "CENTER",
				RIGHT = "RIGHT", BOTTOMLEFT = "BOTTOMLEFT", BOTTOM = "BOTTOM",BOTTOMRIGHT = "BOTTOMRIGHT"}

function ns.Hex(r, g, b)
	if (type(r) == "table") then
		if (r.r) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

do
	local function OnEscapePressed(self)
		self:SetText(self.oldText)
		self:ClearFocus()
		if self.update then
			self:update()
		end
	end

	local function OnEnterPressed(self)
		local text = self:GetText()
		self:ClearFocus()
		if self.update then
			self:update()
		end
	end

	local function OnEditFocusGained(self)
		self.oldText = self:GetText()

		self:SetText(self.oldText)
		self.newText = nil
	end

	local function OnEditFocusLost(self)
		self.newText = nil
		self.oldText = nil
	end

	local function OnTextChanged(self, userInput)
		if (userInput) then
			self.newText = self:GetText()
			if self.update then
				self:update()
			end
		end
	end

	local function OnChar(self)
		local text = self:GetText()
		if (self.validate and not self:validate(text)) then
			local pos = self:GetCursorPosition() - 1
			self:SetText(self.newText or self.oldText)
			self:SetCursorPosition(pos)
		end

		self.newText = self:GetText()
	end

	function ns.createEditBox(self, name, width, height, type, max)
		local editbox = CreateFrame("EditBox", ns.Name.."_Editbox_"..name, self)
		if type then
			editbox:SetNumeric()
		end
		editbox:SetFontObject(GameFontHighlight)
		editbox:SetWidth(width)
		editbox:SetHeight(height)
		editbox:SetMaxLetters(max)
		editbox:SetAutoFocus(false)
		editbox:SetJustifyH("CENTER")
		editbox:SetScript("OnEscapePressed", OnEscapePressed)
		editbox:SetScript("OnEnterPressed", OnEnterPressed)
		editbox:SetScript("OnEditFocusGained", OnEditFocusGained)
		editbox:SetScript("OnEditFocusLost", OnEditFocusLost)
		editbox:SetScript("OnTextChanged", OnTextChanged)
		editbox:SetScript("OnChar", OnChar)

		local background = editbox:CreateTexture(nil, "BACKGROUND")
		background:SetPoint("TOP", 0, -1)
		background:SetPoint("LEFT")
		background:SetPoint("RIGHT")
		background:SetPoint("BOTTOM", 0, 4)
		background:SetColorTexture(1, 1, 1, .05)

		return editbox
	end
end

do
	function ns.createSlider(self, name, minv, maxv)
		local slider = CreateFrame("Slider", name, self, "OptionsSliderTemplate")
		slider:SetMinMaxValues(minv, maxv)
		slider:SetOrientation("HORIZONTAL")
		slider:SetValueStep(1)
		_G[slider:GetName().."Text"]:SetText(name)
		_G[slider:GetName().."Low"]:SetText(minv)
		_G[slider:GetName().."High"]:SetText(maxv)
		return slider
	end
end

do
	local function OnClick(self)
		self:GetParent():GetParent().colorPicker = self
		OpenColorPicker(self)
	end

	function ns.createColorSwatch(self)
		local swatch = CreateFrame("Button", nil, self)
		swatch:SetSize(16, 16)

		local background = swatch:CreateTexture(nil, "BACKGROUND")
		background:SetSize(14, 14)
		background:SetPoint("CENTER")
		background:SetTexture(.3, .3, .3)

		swatch:SetNormalTexture[[Interface\ChatFrame\ChatFrameColorSwatch]]

		swatch:SetScript("OnClick", OnClick)

		return swatch
	end
end
