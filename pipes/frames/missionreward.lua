
local _E
local hook

local function update(frame)
    local _, itemLink = GetItemInfo(frame.itemID)
    PingumaniaItemlevel:CallFilters("missionreward", frame, _E and itemLink)
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_GarrisonUI" then
        if (not hook) then
            hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", update)
            hook = true
        end
        PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function enable()
	_E = true
    
    if IsAddOnLoaded("Blizzard_GarrisonUI") then
        if (not hook) then
            hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", update)
            hook = true
        end
    else
        PingumaniaItemlevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
end

PingumaniaItemlevel:RegisterPipe("missionreward", enable, disable, update, "Mission Reward Frame", nil)