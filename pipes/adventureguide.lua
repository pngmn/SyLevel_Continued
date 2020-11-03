local _E
local hook

local function update(button)
	if (not EncounterJournal:IsVisible() or not button) then return end
	local itemLink = button.link
	local slotFrame = button.IconBorder
	SyLevel:CallFilters("adventureguide", slotFrame, _E and itemLink)
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		hooksecurefunc("EncounterJournal_SetLootButton", update)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_EncounterJournal") then
		doHook()
		SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable(self)
	_E = true
	if IsAddOnLoaded("Blizzard_EncounterJournal") then
		doHook()
	else
		SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("adventureguide", enable, disable, update, "AdventureGuide", nil)