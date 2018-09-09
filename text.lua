local P, C = unpack(select(2, ...))

function P:CreateText(self)
	local tc = self.GearLevelText
	if (not tc) then
		if (not self:IsObjectType("Frame")) then
			tc = self:GetParent():CreateFontString(nil, "OVERLAY")
		else
			tc = self:CreateFontString(nil, "OVERLAY")
		end
		self.GearLevelText = tc
	end
	return tc
end

function P:TextDisplay(frame, value)
	if not frame then return end
	if value then
		local tc = P:CreateText(frame)
		tc:SetFont(C["ItemLevel"].Font, C["ItemLevel"].FontSize, "OUTLINE")
		tc:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
		tc:SetTextColor(0, 1, 0)
		tc:SetText(value)
		tc:Show()		
	elseif (frame.GearLevelText) then
		frame.GearLevelText:Hide()
	end
end