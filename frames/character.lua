local P, C = unpack(select(2, ...))
if C["EnableCharacter"] ~= true then return end

if(select(4, GetAddOnInfo("Fizzle"))) then return end
if(select(4, GetAddOnInfo("GW2_UI"))) then return end
if(select(4, GetAddOnInfo("DejaCharacterStats"))) then return end

local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", [19] = "Tabard",
}

local function pipe(self)
	if CharacterFrame:IsShown() then
		for key, slotName in pairs(slots) do
			local slotFrame = _G["Character"..slotName.."Slot"]
            local itemlink = GetInventoryItemLink("player", key)
            
            P:TextDisplay(slotFrame, itemlink, "player", key)
		end
	end
end

local function UNIT_INVENTORY_CHANGED(self, event, unit)
    if unit == "player" then
		pipe(self)
	end
end
    
CharacterFrame:HookScript("OnShow", pipe)
P:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
