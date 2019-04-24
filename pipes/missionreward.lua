
local _E
local hook

local function update(self)
    if (GarrisonMissionFrame and GarrisonMissionFrame:IsShown()) then
        local _, itemLink = GetItemInfo(self.itemID)
        local slotFrame = self
        SyLevel:CallFilters("missionreward", slotFrame, _E and itemLink)
    end
end

local function ADDON_LOADED(self, event, addon)
    if (addon == "Blizzard_GarrisonUI") then
        if (not hook) then
            hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", update)
            hook = true
        end
        SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
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
        SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
end

SyLevel:RegisterPipe("missionreward", enable, disable, update, "Mission Reward Frame", nil)