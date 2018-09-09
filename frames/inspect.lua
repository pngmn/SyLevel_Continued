local P, C = unpack(select(2, ...))
if C["EnableInspect"] ~= true then return end

if(select(4, GetAddOnInfo("Fizzle"))) then return end

local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", [19] = "Tabard",
}

local function pipe(self)
	if (not InspectFrame or not InspectFrame:IsShown()) then return end

	local unit = InspectFrame.unit
	for i, slotName in next, slots do
		local itemLink = GetInventoryItemLink(unit, i)
		local itemTexture = GetInventoryItemTexture(unit, i)

		local ilevel = P:GetUpgradedItemLevel(itemLink)
        P:TextDisplay(_G["Inspect"..slotName.."Slot"], ilevel)
	end
end

local function UNIT_INVENTORY_CHANGED(self, event, unit)
	if (InspectFrame.unit == unit) then
		pipe(self)
	end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_InspectUI" then
        self:RegisterEvent("PLAYER_TARGET_CHANGED", pipe)
        self:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
        self:RegisterEvent("INSPECT_READY", pipe)
        self:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

if (IsAddOnLoaded("Blizzard_InspectUI")) then
    P:RegisterEvent("PLAYER_TARGET_CHANGED", pipe)
    P:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
    P:RegisterEvent("INSPECT_READY", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end