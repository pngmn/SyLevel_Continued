local P, C = unpack(select(2, ...))
if C["EnableLoot"] ~= true then return end

local function pipe()
	if (LootFrame:IsShown() and SyLevel:IsPipeEnabled"loot") then
		for i=1, LOOTFRAME_NUMBUTTONS or 4 do
			local slotFrame = _G["LootButton" .. i]
			local slot = slotFrame.slot
			
			local itemLink
			if slot then
				itemLink = GetLootSlotLink(slot)
			end

            P:TextDisplay(slotFrame, itemLink)
		end
	end
end

LootFrameUpButton:HookScript("OnClick", pipe)
LootFrameDownButton:HookScript("OnClick", pipe)
P:RegisterEvent("LOOT_OPENED", pipe)
P:RegisterEvent("LOOT_SLOT_CLEARED", pipe)
P:RegisterEvent("LOOT_SLOT_CHANGED", pipe)