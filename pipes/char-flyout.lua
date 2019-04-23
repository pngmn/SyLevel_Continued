-- TODO:
--  - Prevent unnecessary double updates.
--  - Write a description.

local hook
local _E

local getIL = function(loc)
	local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(loc)
	if(not player and not bank and not bags) then return end

	if(not bags) then
		return GetInventoryItemLink('player', slot)
	else
		return GetContainerItemLink(bag, slot)
	end
end

local pipe = function(self)
	local location, il = self.location
	if(location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION) then
		il = getIL(location)
	end

	return SyLevel:CallFilters('char-flyout', self, _E and il)
end

local update = function(self)
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

local enable = function(self)
	_E = true

	if(not hook) then
		hook = function(...)
			if(_E) then return pipe(...) end
		end

		hooksecurefunc('EquipmentFlyout_DisplayButton', hook)
	end
end

local disable = function(self)
	_E = nil
end

SyLevel:RegisterPipe('char-flyout', enable, disable, update, 'Character Equipment Flyout', nil)
