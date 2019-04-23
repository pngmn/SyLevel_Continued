local P, C = unpack(select(2, ...))

local argcheck = P.argcheck
local colorFunc
local typeface, size, align, reference, offsetx, offsety, flags
local Media = P.media

local function createText(self, point)
	local tc = self.GearLevelText
	if (not tc) then
		if (not self:IsObjectType("Frame")) then
			tc = self:GetParent():CreateFontString(nil,"OVERLAY")
		else
			tc = self:CreateFontString(nil,"OVERLAY")
		end
		self.GearLevelText = tc
	end
	return tc
end

local function UpdateFont()
	typeface, size, align, reference, offsetx, offsety, flags = P:GetFontSettings()
end

local function UpdateColorFunc()
	colorFunc = P:GetColorFunc()
end

local function textDisplay(frame, value, quality)
	if not frame then return end
	if value then
		local tc = createText(frame)
		if not typeface then UpdateFont() end
		if not colorFunc then UpdateColorFunc() end
		tc:SetFont(Media:Fetch("font", typeface), size, flags)
        tc:SetTextColor(1, 1, 1, 1)
		tc:SetPoint(align, frame, reference, offsetx, offsety)
		tc:SetTextColor(colorFunc(value, if quality and quality or nil))
		tc:SetText(value)
		tc:Show()		
	elseif (frame.GearLevelText) then
		frame.GearLevelText:Hide()
	end
end

P:RegisterOptionCallback(UpdateFont)
P:RegisterOptionCallback(UpdateColorFunc)
P:RegisterDisplay("Text", textDisplay)