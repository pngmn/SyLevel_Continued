local P, C = unpack(select(2, ...))
if C["EnableMerchant"] ~= true then return end

local ilevel

local function pipe()
	if MerchantFrame:IsShown() then
		if MerchantFrame.selectedTab == 1 then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
				local itemLink = GetMerchantItemLink(index)
				local slotFrame = _G["MerchantItem"..i.."ItemButton"]
	
                P:TextDisplay(slotFrame, itemLink)
			end
			local buyBackLink = GetBuybackItemLink(GetNumBuybackItems())
            P:TextDisplay(slotFrame, buyBackLink)
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				local itemLink = GetBuybackItemLink(i)
				local slotFrame = _G["MerchantItem"..i.."ItemButton"]

                P:TextDisplay(slotFrame, itemLink)
			end
		end
	end
end

hooksecurefunc("MerchantFrame_Update", pipe)