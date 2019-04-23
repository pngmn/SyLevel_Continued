local P, C = unpack(select(2, ...))

local hook
local _E

local function getIL(location)
	local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(location)
	if (not player and not bank and not bags) then return end

	if (not bags) then
		return GetInventoryItemLink("player", slot), "player", slot
	else
		return GetContainerItemLink(bag, slot), bag, slot
	end
end

local function pipe(self)
    if not CharacterFrame:IsShown() then return end
	local location, itemLink, id, i = self.location
	if (location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION -1) then
		itemLink, id, slot = getIL(location)
	end

	return P:CallFilters("char-flyout", self, _E and itemLink, id, slot)
end

local function update(self)
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		hook = function(...)
			if (_E) then return pipe(...) end
		end

		hooksecurefunc("EquipmentFlyout_DisplayButton", hook)
	end
end

local function disable(self)
	_E = nil
end

P:RegisterPipe("char-flyout", enable, disable, update, "Character Equipment Flyout", nil)