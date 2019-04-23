local P, C = unpack(select(2, ...))

local _E

local function update()
    if not ScrappingMachineFrame:IsShown() then return end
    for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
        P:TextDisplayHide(button.Icon)
        local pending = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(button.SlotNumber)
        if pending then
            local bag = pending.bagID
            local slot = pending.slotIndex
            local itemLink = GetContainerItemLink(bag, slot)
            local slotFrame = button.Icon
            P:CallFilters("scrapper", slotFrame, _E and itemLink)
        end
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_ScrappingMachineUI" then
        P:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function enable()
	_E = true
    
    if IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
        P:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
    else
        P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
    P:UnregisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
end

P:RegisterPipe("scrapper", enable, disable, update, "Scrapper Frame", nil)