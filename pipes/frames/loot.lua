
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

			PingumaniaItemlevel:CallFilters("loot", slotFrame, _E and itemLink)
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

	PingumaniaItemlevel:RegisterEvent("LOOT_OPENED", update)
	PingumaniaItemlevel:RegisterEvent("LOOT_SLOT_CLEARED", update)
	PingumaniaItemlevel:RegisterEvent("LOOT_SLOT_CHANGED", update)
end

local function disable(self)
	_E = nil

	PingumaniaItemlevel:UnregisterEvent("LOOT_OPENED", update)
	PingumaniaItemlevel:UnregisterEvent("LOOT_SLOT_CLEARED", update)
	PingumaniaItemlevel:UnregisterEvent("LOOT_SLOT_CHANGED", update)
end

PingumaniaItemlevel:RegisterPipe("loot", enable, disable, update, "Loot Window", nil)