local hook
local _E

local function getIL(loc)
	local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(loc)
	if (not player and not bank and not bags) then return end
	if (not bags) then
		return GetInventoryItemLink("player", slot)
	else
		return GetContainerItemLink(bag, slot)
	end
end

local function pipe(self)
	local location, itemLink = self.location
	if (location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION - 1) then
		itemLink = getIL(location)
	end

	return SyLevel:CallFilters("char-flyout", self, _E and itemLink)
end

local function update(self)
	if not CharacterFrame:IsShown() then return end
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		hooksecurefunc("EquipmentFlyout_DisplayButton", pipe)
		hook = true
	end
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("char-flyout", enable, disable, update, "Character Equipment Flyout", nil)
