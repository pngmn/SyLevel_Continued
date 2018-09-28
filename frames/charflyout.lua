local P, C = unpack(select(2, ...))
if C["EnableCharacter"] ~= true then return end

local itemlink

local function pipe(self)
    if not CharacterFrame:IsShown() then return end
	local location = self.location
	if (location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION - 1) then
        local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(location)
        if (not player and not bank and not bags) then return end

        if not bags then
            itemlink = GetInventoryItemLink("player", slot)
            P:TextDisplay(self, itemlink, "player", slot)
        else
            itemlink = GetContainerItemLink(bag, slot)
            P:TextDisplay(self, itemlink, bag, slot)
        end
	end
end

local function update(self)
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

hooksecurefunc("EquipmentFlyout_DisplayButton", pipe)