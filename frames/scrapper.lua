local P, C = unpack(select(2, ...))
if C["EnableScrapper"] ~= true then return end

local function pipe(self)
    local slotFrame = C_ScrappingMachineUI.GetCurrentPendingScrapItemLocationByIndex(self.SlotNumber)
    if not slotFrame then return end
    
    local item = Item:CreateFromItemLocation(slotFrame)
    if item:IsItemEmpty() then return end
 
    local itemLink = item:GetItemLink()
    
    P:TextDisplay(slotFrame, itemLink)
end

P:RegisterEvent("SCRAPPING_MACHINE_PENDING_ITEM_CHANGED", pipe)