
local _E
local hooked

local function updateContents(self)
	if (not IsAddOnLoaded"Blizzard_VoidStorageUI") then return end
	for slot=1, VOID_WITHDRAW_MAX or 80 do
		local slotFrame =  _G["VoidStorageStorageButton" .. slot]
		local page = _G["VoidStorageFrame"].page
		local itemID = GetVoidItemInfo(page, slot)
		local itemName, itemLink
		if itemID then
			itemName, itemLink = GetItemInfo(itemID)
		end
		PingumaniaItemlevel:CallFilters("voidstore", slotFrame, _E and itemLink)
	end

	for slot=1, VOID_WITHDRAW_MAX or 9 do
		local slotFrame = _G["VoidStorageWithdrawButton" .. slot]
		local itemID = GetVoidTransferWithdrawalInfo(slot)
		local itemName, itemLink
		if itemID then
			itemName, itemLink = GetItemInfo(itemID)
		end
		PingumaniaItemlevel:CallFilters("voidstore", slotFrame, _E and itemLink)
	end
end

local function updateDeposit(self, event, slot)
	if (not IsAddOnLoaded"Blizzard_VoidStorageUI") then return end

	local slotFrame = _G["VoidStorageDepositButton" .. slot]
	local itemID = GetVoidTransferDepositInfo(slot)
	local itemName, itemLink
	if itemID then
		itemName, itemLink = GetItemInfo(itemID)
	end
	PingumaniaItemlevel:CallFilters("voidstore", slotFrame, _E and itemLink)
end

local function update(self)
	if (not IsAddOnLoaded"Blizzard_VoidStorageUI") then return end
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

local function enable(self)
	_E = true
	PingumaniaItemlevel:RegisterEvent("VOID_STORAGE_UPDATE", updateContents);
	PingumaniaItemlevel:RegisterEvent("INVENTORY_SEARCH_UPDATE", updateContents);
	PingumaniaItemlevel:RegisterEvent("VOID_DEPOSIT_WARNING", updateContents);
	PingumaniaItemlevel:RegisterEvent("VOID_STORAGE_CONTENTS_UPDATE", updateContents)
	PingumaniaItemlevel:RegisterEvent("VOID_STORAGE_DEPOSIT_UPDATE", updateDeposit)
	PingumaniaItemlevel:RegisterEvent("VOID_TRANSFER_DONE", update)
	PingumaniaItemlevel:RegisterEvent("VOID_STORAGE_OPEN", update)
end

local function disable(self)
	_E = nil
	PingumaniaItemlevel:UnregisterEvent("VOID_STORAGE_UPDATE", updateContents);
	PingumaniaItemlevel:UnregisterEvent("INVENTORY_SEARCH_UPDATE", updateContents);
	PingumaniaItemlevel:UnregisterEvent("VOID_DEPOSIT_WARNING", updateContents);
	PingumaniaItemlevel:UnregisterEvent("VOID_STORAGE_CONTENTS_UPDATE", updateContents)
	PingumaniaItemlevel:UnregisterEvent("VOID_STORAGE_DEPOSIT_UPDATE", updateDeposit)
	PingumaniaItemlevel:UnregisterEvent("VOID_TRANSFER_DONE", update)
	PingumaniaItemlevel:UnregisterEvent("VOID_STORAGE_OPEN", update)
end

PingumaniaItemlevel:RegisterPipe("voidstore", enable, disable, update, "Void Storage Window", nil)