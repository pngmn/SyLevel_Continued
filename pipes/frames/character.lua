
if (select(4, GetAddOnInfo("Fizzle"))) then return end
if (select(4, GetAddOnInfo("GW2_UI"))) then return end
if (select(4, GetAddOnInfo("DejaCharacterStats"))) then return end

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
			local slotFrame = _G["Character" .. slotName .. "Slot"]
			local itemLink = GetInventoryItemLink("player", key)
			PingumaniaItemlevel:CallFilters("char", slotFrame, _E and itemLink, key)
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

	PingumaniaItemlevel:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)

	if (not hook) then
		hook = function(...)
			if (_E) then return update(self) end
		end

		CharacterFrame:HookScript("OnShow", hook)
	end
end

local function disable(self)
	_E = nil
	PingumaniaItemlevel:UnregisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
end

PingumaniaItemlevel:RegisterPipe("char", enable, disable, update, "Character", nil)
