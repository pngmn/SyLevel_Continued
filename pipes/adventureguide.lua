
local _E
local hook

local function update(self)
    if (EncounterJournalEncounterFrameInfo:IsShown()) then
        local name = self:GetName()
        local itemLink = self.link
        local slotFrame = _G[name.."Icon"]
        SyLevel:CallFilters("adventureguide", slotFrame, _E and itemLink)
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_EncounterJournal" then
        if (not hook) then
            hooksecurefunc("EncounterJournal_SetLootButton", update)
            hook = true
            _E = true
        end
        SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function enable()
	if IsAddOnLoaded("Blizzard_EncounterJournal") then
        if (not hook) then
            hooksecurefunc("EncounterJournal_SetLootButton", update)
            hook = true
            _E = true
        end
    else
        SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
end

SyLevel:RegisterPipe("adventureguide", enable, disable, update, "Adventure Guide", nil)