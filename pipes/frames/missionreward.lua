local P, C = unpack(select(2, ...))

local _E
local hook

local function update(frame)
    local _, itemLink = GetItemInfo(frame.itemID)
    P:CallFilters("missionreward", frame, _E and itemLink)
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_GarrisonUI" then
        if (not hook) then
            hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", update)
            hook = true
        end
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
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
        P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
end

P:RegisterPipe("missionreward", enable, disable, update, "Mission Reward Frame", nil)