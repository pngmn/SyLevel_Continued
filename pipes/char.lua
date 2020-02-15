local _E
local hook
local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", [19] = "Tabard",
}

CharacterNeckSlot.RankFrame:SetAlpha(0)

local function update(self, key, slotFrame)
	if not key then return end
	item = Item:CreateFromEquipmentSlot(key)
	itemLoc = ItemLocation:CreateFromEquipmentSlot(key)
	if C_Item.DoesItemExist(itemLoc) then
		slotLink = item:GetItemLink()
		SyLevel:CallFilters("char", slotFrame, _E and slotLink, item)
	else
		SyLevel:CallFilters("char", slotFrame, _E and nil)
	end
end

local function pipe(self, slot)
	local slotFrame
	if slot then
		slotFrame = _G["Character"..slots[slot].."Slot"]
		update(self, slot, slotFrame)
	else
		for key, slotName in pairs(slots) do
			slotFrame = _G["Character"..slotName.."Slot"]
			update(self, key, slotFrame)
		end
	end
end

local function PLAYER_EQUIPMENT_CHANGED(self, event, slot)
	pipe(self, slot)
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return pipe(...) end
		end
		CharacterFrame:HookScript("OnShow", pipe)
	end
end

local function enable(self)
	_E = true
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", PLAYER_EQUIPMENT_CHANGED)
	doHook()
end

local function disable(self)
	_E = nil
	self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED", PLAYER_EQUIPMENT_CHANGED)
end

SyLevel:RegisterPipe("char", enable, disable, update, "Character", nil)
