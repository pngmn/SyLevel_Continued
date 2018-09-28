local P, C = unpack(select(2, ...))
if C["EnableAdventureGuide"] ~= true then return end

local function pipe(self)
    local itemLink = self.link
    local slotFrame = _G[self:GetName().."Icon"]
    P:TextDisplay(slotFrame, itemLink)
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_EncounterJournal" then
        hooksecurefunc("EncounterJournal_SetLootButton", pipe)
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

if IsAddOnLoaded("Blizzard_EncounterJournal") then
    hooksecurefunc("EncounterJournal_SetLootButton", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end