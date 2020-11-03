local _E
local hook

local function update()
	if (not MerchantFrame:IsVisible()) then return end
	if (MerchantFrame.selectedTab == 1) then
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
			local itemLink = GetMerchantItemLink(index)
			local slotFrame = _G["MerchantItem"..i.."ItemButton"]
			SyLevel:CallFilters("merchant", slotFrame, _E and itemLink)
		end
		local buyBackLink = GetBuybackItemLink(GetNumBuybackItems())
		SyLevel:CallFilters("merchant", MerchantBuyBackItemItemButton, _E and buyBackLink)
	else
		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			local itemLink = GetBuybackItemLink(i)
			local slotFrame = _G["MerchantItem"..i.."ItemButton"]
			SyLevel:CallFilters("merchant", slotFrame, _E and itemLink)
		end
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		hooksecurefunc("MerchantFrame_Update", hook)
	end
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("merchant", enable, disable, update, "Merchant Window", nil)
