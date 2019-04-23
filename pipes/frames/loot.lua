local P, C = unpack(select(2, ...))

local hook
local _E

local function update()
	if (LootFrame:IsShown()) then
		for i=1, LOOTFRAME_NUMBUTTONS or 4 do
			local slotFrame = _G["LootButton" .. i]
			local slot = slotFrame.slot
			
			local itemLink
			if (slot) then
				itemLink = GetLootSlotLink(slot)
			end

			P:CallFilters("loot", slotFrame, _E and itemLink)
		end
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		LootFrameUpButton:HookScript("OnClick", update)
		LootFrameDownButton:HookScript("OnClick", update)

		hook = true
	end

	P:RegisterEvent("LOOT_OPENED", update)
	P:RegisterEvent("LOOT_SLOT_CLEARED", update)
	P:RegisterEvent("LOOT_SLOT_CHANGED", update)
end

local function disable(self)
	_E = nil

	P:UnregisterEvent("LOOT_OPENED", update)
	P:UnregisterEvent("LOOT_SLOT_CLEARED", update)
	P:UnregisterEvent("LOOT_SLOT_CHANGED", update)
end

P:RegisterPipe("loot", enable, disable, update, "Loot Window", nil)