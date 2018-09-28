local P, C = unpack(select(2, ...))
if C["EnableAdventureGuide"] ~= true then return end

local function pipe(button)
    local _, itemLink = GetItemInfo(button.itemID)
    P:TextDisplay(button, itemLink)
end

hooksecurefunc(LootJournalItemSets, "ConfigureItemButton", pipe)