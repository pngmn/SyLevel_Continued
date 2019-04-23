
local _E
local hook

local function update(self)
    for i=1, self.numActiveOptionFrames do
        local rewardFrame = self["Option"..i].Rewards
        local _, _, _, _, _, numItems = GetQuestChoiceRewardInfo(i)

        if numItems ~= 0 then
            local _, _, _, _, _, itemLink = GetQuestChoiceRewardItem(i, 1) --for now there is only ever 1 item by design
            if itemLink then
                PingumaniaItemlevel:CallFilters("questreward", rewardFrame.Item, _E and itemLink)
            end
        end
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_QuestChoice" then
        if (not hook) then
            hooksecurefunc(QuestChoiceFrame, "ShowRewards", update)
            -- hookesecurefunc("QuestInfo_ShowRewards", update)
            hook = true
        end
        PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

-- local function update()
    -- local numQuestRewards = 0
    -- local numQuestChoices = 0
    -- local rewardsFrame = QuestInfoFrame.rewardsFrame

    -- if QuestInfoFrame.questLog then
        -- local questID = select(8, GetQuestLogTitle(GetQuestLogSelection()))
        -- if C_QuestLog.ShouldShowQuestRewards(questID) then
            -- numQuestRewards = GetNumQuestLogRewards()
            -- numQuestChoices = GetNumQuestLogChoices()
        -- end
    -- else
        -- numQuestRewards = GetNumQuestRewards()
        -- numQuestChoices = GetNumQuestChoices()
    -- end

    -- local questItem
    -- local rewardsCount = 0

    -- if numQuestChoices > 0 then
        -- local index
        -- local baseIndex = rewardsCount
        -- for i = 1, numQuestChoices do
            -- index = i + baseIndex
            -- questItem = QuestInfo_GetRewardButton(rewardsFrame, index)
            -- if QuestInfoFrame.questLog then
                -- PingumaniaItemlevel:CallFilters("questreward", questItem, _E and GetQuestLogItemLink(questItem.type, i))
            -- else
                -- PingumaniaItemlevel:CallFilters("questreward", questItem, _E and GetQuestLogItemLink(questItem.type, i))
            -- end
            -- rewardsCount = rewardsCount + 1
        -- end
    -- end
 
    -- if numQuestRewards > 0 then
        -- local index
        -- local baseIndex = rewardsCount
        -- for i = 1, numQuestRewards, 1 do
            -- index = i + baseIndex
            -- questItem = QuestInfo_GetRewardButton(rewardsFrame, index)
            -- if QuestInfoFrame.questLog then
                -- PingumaniaItemlevel:CallFilters("questreward", questItem, _E and GetQuestLogItemLink(questItem.type, i))
            -- else
                -- PingumaniaItemlevel:CallFilters("questreward", questItem, _E and GetQuestItemLink(questItem.type, i))
            -- end
            -- rewardsCount = rewardsCount + 1
        -- end
    -- end
-- end



local function enable()
	_E = true
    
    if IsAddOnLoaded("Blizzard_GarrisonUI") then
        if (not hook) then
            hooksecurefunc(QuestChoiceFrame, "ShowRewards", update)
            -- hookesecurefunc("QuestInfo_ShowRewards", update)
            hook = true
        end
    else
        PingumaniaItemlevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

local function disable()
    _E = nil
end

PingumaniaItemlevel:RegisterPipe("questreward", enable, disable, update, "Quest Reward Frame", nil)