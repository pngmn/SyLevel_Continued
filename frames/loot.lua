local P, C = unpack(select(2, ...))
if C["EnableLoot"] ~= true then return end

local function pipe()
	if not LootFrame:IsShown() then return end
    for i=1, LOOTFRAME_NUMBUTTONS or 4 do
        local slotFrame = _G["LootButton"..i]
        local slot = slotFrame.slot
        
        if slot then
            local itemLink = GetLootSlotLink(slot)
            P:TextDisplay(slotFrame, itemLink)
        end
    end
end

LootFrameUpButton:HookScript("OnClick", pipe)
LootFrameDownButton:HookScript("OnClick", pipe)
P:RegisterEvent("LOOT_OPENED", pipe)
P:RegisterEvent("LOOT_SLOT_CLEARED", pipe)
P:RegisterEvent("LOOT_SLOT_CHANGED", pipe)