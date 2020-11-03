local _E

local function update()
	if (not ScrappingMachineFrame:IsVisible()) then return end
	for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
		local slotFrame = button.Icon
		local pending = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(button.SlotNumber)
		local bag = pending and pending.bagID
		local slot = pending and pending.slotIndex
		local itemLink = pending and GetContainerItemLink(bag, slot)
		SyLevel:CallFilters("scrapper", slotFrame, _E and itemLink)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_ScrappingMachineUI") then
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_CLOSE", update)
		SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable(self)
	_E = true

	if IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_CLOSE", update)
	else
		SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil
	SyLevel:UnregisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
end

SyLevel:RegisterPipe("scrapper", enable, disable, update, "Scrapper Frame", nil)