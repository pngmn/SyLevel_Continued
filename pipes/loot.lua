local hook
local _E

local function update()
	if (not LootFrame:IsVisible()) then return end
	for i = 1, LOOTFRAME_NUMBUTTONS or 4 do
		local slotFrame = _G["LootButton"..i]
		local slot = slotFrame.slot
		local itemLink = slot and GetLootSlotLink(slot)
		SyLevel:CallFilters("loot", slotFrame, _E and itemLink)
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		LootFrameUpButton:HookScript("OnClick", update)
		LootFrameDownButton:HookScript("OnClick", update)
		hook = true
	end

	self:RegisterEvent("LOOT_OPENED", update)
	self:RegisterEvent("LOOT_SLOT_CLEARED", update)
	self:RegisterEvent("LOOT_SLOT_CHANGED", update)
end

local function disable(self)
	_E = nil

	self:UnregisterEvent("LOOT_OPENED", update)
	self:UnregisterEvent("LOOT_SLOT_CLEARED", update)
	self:UnregisterEvent("LOOT_SLOT_CHANGED", update)
end

SyLevel:RegisterPipe("loot", enable, disable, update, "Loot Window", nil)
