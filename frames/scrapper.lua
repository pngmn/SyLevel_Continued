local P, C = unpack(select(2, ...))
if C["EnableScrapper"] ~= true then return end

local function pipe()
    if not ScrappingMachineFrame:IsShown() then return end
    for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
        P:TextDisplayHide(button.Icon)
        local pending = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(button.SlotNumber)
        if pending then
            local bag = pending.bagID
            local slot = pending.slotIndex
            local itemLink = GetContainerItemLink(bag, slot)
            local slotFrame = button.Icon
                      
            P:TextDisplay(slotFrame, itemLink)
        end
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_ScrappingMachineUI" then
        P:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", pipe)
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

if IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
    P:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end