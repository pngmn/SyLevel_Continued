local _E

local function update(self)
	if (ScrappingMachineFrame and ScrappingMachineFrame:IsShown()) then
		for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			local slotFrame = button.Icon
			local pending = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(button.SlotNumber)
			if pending then
				local bag = pending.bagID
				local slot = pending.slotIndex
				local itemLink = GetContainerItemLink(bag, slot)
				SyLevel:CallFilters("scrapper", slotFrame, _E and itemLink)
			else
				SyLevel:CallFilters("scrapper", slotFrame, _E and nil)
			end
		end
	end
end

local function ADDON_LOADED(self, _, addon)
	if (addon == "Blizzard_ScrappingMachineUI") then
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
		SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable(self)
	_E = true

	if IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
		SyLevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
	else
		SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil
	SyLevel:UnregisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
end

SyLevel:RegisterPipe("scrapper", enable, disable, update, "Scrapper Frame", nil)