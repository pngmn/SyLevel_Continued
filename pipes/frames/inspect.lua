local P, C = unpack(select(2, ...))

if (select(4, GetAddOnInfo("Fizzle"))) then return end

local _E
local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", [19] = "Tabard",
}

local _MISSING = {}
local pollFrame = CreateFrame("Frame")
pollFrame:Hide()
local time = 3

pollFrame:SetScript("OnUpdate", function(self, elapsed)
	time = time + elapsed

	if (time >= 3) then
		local unit = InspectFrame.unit
		if(not unit) then
			self:Hide()
			table.wipe(_MISSING)
		end

		for i, slotName in next, _MISSING do
			local itemLink = GetInventoryItemLink(unit, i)
			if (itemLink) then
				P:CallFilters("inspect", _G["Inspect" .. slotName .. "Slot"], _E and itemLink)

				_MISSING[i] = nil
			end
		end

		if (not next(_MISSING)) then
			self:Hide()
		end
	end
end)

local function update(self)
	if (not InspectFrame or not InspectFrame:IsShown()) then return end

	local unit = InspectFrame.unit
	for i, slotName in next, slots do
		local itemLink = GetInventoryItemLink(unit, i)
		local itemTexture = GetInventoryItemTexture(unit, i)

		if (itemTexture and not itemLink) then
			_MISSING[i] = slotName
			pollFrame:Show()
		end

		P:CallFilters("inspect", _G["Inspect"..slotName.."Slot"], _E and itemLink)
	end
end

local function UNIT_INVENTORY_CHANGED(self, event, unit)
	if (InspectFrame.unit == unit) then
		update(self)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_InspectUI") then
		P:RegisterEvent("PLAYER_TARGET_CHANGED", update)
		P:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
		P:RegisterEvent("INSPECT_READY", update)
		P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable(self)
	_E = true

	if (IsAddOnLoaded("Blizzard_InspectUI")) then
		P:RegisterEvent("PLAYER_TARGET_CHANGED", update)
		P:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
		P:RegisterEvent("INSPECT_READY", update)
	else
		P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil

	P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	P:UnregisterEvent("PLAYER_TARGET_CHANGED", update)
	P:UnregisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
	P:UnregisterEvent("INSPECT_READY", update)
end

P:RegisterPipe("inspect", enable, disable, update, "Inspect Window", nil)