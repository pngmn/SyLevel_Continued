local P, C = unpack(select(2, ...))

function P:CreateText(self)
	local tc = self.GearLevelText
	if (not tc) then
		if (not self:IsObjectType("Frame")) then
			tc = self:GetParent():CreateFontString(nil, "OVERLAY", "GameFontNormalOutline")
		else
			tc = self:CreateFontString(nil, "OVERLAY", "GameFontNormalOutline")
		end
		self.GearLevelText = tc
	end
	return tc
end

function P:TextDisplay(frame, itemlink, id, slot)
    if not frame then return end
    local value = P:GetUpgradedItemLevel(itemlink, id, slot)
	if value then
		local tc = P:CreateText(frame)
		-- tc:SetFont(C["ItemLevel"].Font, C["ItemLevel"].FontSize, C["ItemLevel"].FontStyle)
		-- tc:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -3)
        tc:SetJustifyH("LEFT")
        tc:SetPoint("BOTTOM", frame, "BOTTOM", 0, 3)
		tc:SetTextColor(0, 1, 0)
		tc:SetText(value)
		tc:Show()		
	elseif (frame.GearLevelText) then
		frame.GearLevelText:Hide()
	end
end

function P:TextDisplayHide(frame)
    if not frame then return end		
	if (frame.GearLevelText) then
		frame.GearLevelText:Hide()
	end
end