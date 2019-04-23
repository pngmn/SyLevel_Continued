
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
				PingumaniaItemlevel:CallFilters("inspect", _G["Inspect" .. slotName .. "Slot"], _E and itemLink)

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

		PingumaniaItemlevel:CallFilters("inspect", _G["Inspect"..slotName.."Slot"], _E and itemLink)
	end
end

local function UNIT_INVENTORY_CHANGED(self, event, unit)
	if (InspectFrame.unit == unit) then
		update(self)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_InspectUI") then
		PingumaniaItemlevel:RegisterEvent("PLAYER_TARGET_CHANGED", update)
		PingumaniaItemlevel:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
		PingumaniaItemlevel:RegisterEvent("INSPECT_READY", update)
		PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable(self)
	_E = true

	if (IsAddOnLoaded("Blizzard_InspectUI")) then
		PingumaniaItemlevel:RegisterEvent("PLAYER_TARGET_CHANGED", update)
		PingumaniaItemlevel:RegisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
		PingumaniaItemlevel:RegisterEvent("INSPECT_READY", update)
	else
		PingumaniaItemlevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil

	PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	PingumaniaItemlevel:UnregisterEvent("PLAYER_TARGET_CHANGED", update)
	PingumaniaItemlevel:UnregisterEvent("UNIT_INVENTORY_CHANGED", UNIT_INVENTORY_CHANGED)
	PingumaniaItemlevel:UnregisterEvent("INSPECT_READY", update)
end

PingumaniaItemlevel:RegisterPipe("inspect", enable, disable, update, "Inspect Window", nil)