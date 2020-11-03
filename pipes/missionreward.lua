local _E
local hook

local function update(self, rewards)
	if (rewards and #rewards > 0) then
		local index = 1
		for _, reward in pairs(rewards) do
			local Reward = self.Rewards[index]
			local _, itemLink = reward.itemID and GetItemInfo(reward.itemID)
			SyLevel:CallFilters("missionreward", Reward.IconBorder, _E and itemLink)
			index = index + 1
		end
	end
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		hooksecurefunc("GarrisonMissionButton_SetRewards", update)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_GarrisonUI") then
		doHook()
		SyLevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function enable()
	_E = true
	if IsAddOnLoaded("Blizzard_GarrisonUI") then
		doHook()
	else
		SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable()
	_E = nil
end

SyLevel:RegisterPipe("missionreward", enable, disable, update, "Mission Reward Frame", nil)