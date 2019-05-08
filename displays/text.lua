local _, ns = ...
local SyLevel = ns.SyLevel

local argcheck = SyLevel.argcheck
local colorFunc
local typeface, size, align, reference, offsetx, offsety, flags
local Media = SyLevel.media

local function createText(self, point)
	local tc = self.SyLevelText
	if (not tc) then
		if (not self:IsObjectType("Frame")) then
			tc = self:GetParent():CreateFontString(nil, "OVERLAY")
		else
			tc = self:CreateFontString(nil, "OVERLAY")
		end
		self.SyLevelText = tc
	end
	return tc
end

local function UpdateFont()
	typeface, size, align, reference, offsetx, offsety, flags = SyLevel:GetFontSettings()
end

local function UpdateColorFunc()
	colorFunc = SyLevel:GetColorFunc()
end

local function textDisplay(frame, value, valueString, quality)
	if not frame then return end
	if value then
		local tc = createText(frame)
		if not typeface then UpdateFont() end
		if not colorFunc then UpdateColorFunc() end
		tc:SetFont(Media:Fetch("font", typeface), size, flags)
		tc:SetJustifyH("CENTER")
		tc:SetTextColor(1, 1, 1, 1)
		tc:SetPoint(align, frame, reference, offsetx, offsety)
		tc:SetTextColor(colorFunc(value, quality))
		tc:SetText(valueString)
		tc:Show()		
	elseif (frame.SyLevelText) then
		frame.SyLevelText:Hide()
	end
end

SyLevel:RegisterOptionCallback(UpdateFont)
SyLevel:RegisterOptionCallback(UpdateColorFunc)
SyLevel:RegisterDisplay("Text", textDisplay)