local _, ns = ...
local SyLevel = ns.SyLevel

local colorFunc
local typeface, size, align, reference, offsetx, offsety, flags
local Media = SyLevel.media

local function createText(self)
	local tc = self.SyLevelBindText
	if (not tc) then
		if (not self:IsObjectType("Frame")) then
			tc = self:GetParent():CreateFontString(nil, "OVERLAY")
		else
			tc = self:CreateFontString(nil, "OVERLAY")
		end
		self.SyLevelBindText = tc
	end
	return tc
end

local function UpdateFont()
	typeface, size, align, reference, offsetx, offsety, flags = SyLevel:GetFontSettings()
end

local function UpdateColorFunc()
	colorFunc = SyLevel:GetColorFunc()
end

local function textDisplay(frame, value, quality)
	if not frame then return end
	if value then
		local tc = createText(frame)
		if not typeface then UpdateFont() end
		if not colorFunc then UpdateColorFunc() end
		tc:SetFont(Media:Fetch("font", typeface), size, flags)
		tc:SetJustifyH("CENTER")
		tc:SetTextColor(1, 1, 1, 1)
		tc:SetPoint("TOP", frame, "TOP", offsetx, offsety)
		if quality then
			tc:SetTextColor(colorFunc(value, quality))
		end
		tc:SetText(value)
		tc:Show()
	elseif (frame.SyLevelBindText) then
		frame.SyLevelBindText:Hide()
	end
end

SyLevel:RegisterOptionCallback(UpdateFont)
SyLevel:RegisterOptionCallback(UpdateColorFunc)
SyLevel:RegisterDisplay("BindsOnText", textDisplay)