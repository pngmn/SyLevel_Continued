local _E
local hooked
local updateContents = function(self)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end
	for slot=1, VOID_WITHDRAW_MAX or 80 do
		local slotFrame =  _G['VoidStorageStorageButton' .. slot]
		local page = _G['VoidStorageFrame'].page
		local itemID = GetVoidItemInfo(page, slot)
		local itemName, itemLink
		if itemID then
			itemName, itemLink = GetItemInfo(itemID)
		end
		self:CallFilters('voidstore', slotFrame, _E and itemLink)
	end

	for slot=1, VOID_WITHDRAW_MAX or 9 do
		local slotFrame = _G['VoidStorageWithdrawButton' .. slot]
		local itemID = GetVoidTransferWithdrawalInfo(slot)
		local itemName, itemLink
		if itemID then
			itemName, itemLink = GetItemInfo(itemID)
		end
		self:CallFilters('voidstore', slotFrame, _E and itemLink)
	end
end

local updateDeposit = function(self, event, slot)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end

	local slotFrame = _G['VoidStorageDepositButton' .. slot]
	local itemID = GetVoidTransferDepositInfo(slot)
	local itemName, itemLink
	if itemID then
		itemName, itemLink = GetItemInfo(itemID)
	end
	self:CallFilters('voidstore', slotFrame, _E and itemLink)
end

local update = function(self)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end
	if not hooked then -- This hook became necessary as there are no events that trigger this update.
		hooksecurefunc("VoidStorage_SetPageNumber", function()
			updateContents(self)
		end)
		hooked = true
	end
	for slot=1, VOID_DEPOSIT_MAX or 9 do
		updateDeposit(self, nil, slot)
	end

	return updateContents(self)
end

local enable = function(self)
	_E = true
	self:RegisterEvent("VOID_STORAGE_UPDATE", updateContents);
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE", updateContents);
	self:RegisterEvent("VOID_DEPOSIT_WARNING", updateContents);
	self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', updateContents)
	self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', updateDeposit)
	self:RegisterEvent('VOID_TRANSFER_DONE', update)
	self:RegisterEvent('VOID_STORAGE_OPEN', update)
end

local disable = function(self)
	_E = nil
	self:UnregisterEvent("VOID_STORAGE_UPDATE", updateContents);
	self:UnregisterEvent("INVENTORY_SEARCH_UPDATE", updateContents);
	self:UnregisterEvent("VOID_DEPOSIT_WARNING", updateContents);
	self:UnregisterEvent('VOID_STORAGE_CONTENTS_UPDATE', updateContents)
	self:UnregisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', updateDeposit)
	self:UnregisterEvent('VOID_TRANSFER_DONE', update)
	self:UnregisterEvent('VOID_STORAGE_OPEN', update)
end

SyLevel:RegisterPipe('voidstore', enable, disable, update, 'Void Storage Window', nil)