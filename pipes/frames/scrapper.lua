
local _E

local function update()
    if not ScrappingMachineFrame:IsShown() then return end
    for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
        PingumaniaItemlevel:TextDisplayHide(button.Icon)
        local pending = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(button.SlotNumber)
        if pending then
            local bag = pending.bagID
            local slot = pending.slotIndex
            local itemLink = GetContainerItemLink(bag, slot)
            local slotFrame = button.Icon
            PingumaniaItemlevel:CallFilters("scrapper", slotFrame, _E and itemLink)
        end
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_ScrappingMachineUI" then
        PingumaniaItemlevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
        PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function enable()
	_E = true
    
    if IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
        PingumaniaItemlevel:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
    else
        PingumaniaItemlevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
    PingumaniaItemlevel:UnregisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", update)
end

PingumaniaItemlevel:RegisterPipe("scrapper", enable, disable, update, "Scrapper Frame", nil)