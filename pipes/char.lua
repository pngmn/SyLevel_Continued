-- TODO:
--  - Write a description.

if (select(4, GetAddOnInfo("Fizzle"))) then return end

local _E
local hook
local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", [19] = "Tabard",
}

local function update(self)
	if (CharacterFrame:IsShown()) then
		for key, slotName in pairs(slots) do
			local slotFrame = _G["Character"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink("player", key)
			SyLevel:CallFilters("char", slotFrame, _E and slotLink)
		end
	end
end

local function UNIT_INVENTORY_CHANGED(self, event, unit)
	if (unit == "player") then
		update(self)
	end
end

local function enable(self)
	_E = true

	self:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)

	if (not hook) then
		CharacterFrame:HookScript("OnShow", update)
		hook = true	
	end
end

local function disable(self)
	_E = nil
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
end

SyLevel:RegisterPipe("char", enable, disable, update, "Character", nil)
