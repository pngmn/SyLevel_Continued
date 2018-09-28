local P, C = unpack(select(2, ...))
if C["EnableMissionReward"] ~= true then return end

local function pipe(frame)
    local _, itemLink = GetItemInfo(frame.itemID)
    P:TextDisplay(frame, itemLink)
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_GarrisonUI" then
        hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", pipe)
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

if IsAddOnLoaded("Blizzard_GarrisonUI") then
    hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end