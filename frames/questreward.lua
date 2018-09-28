local P, C = unpack(select(2, ...))
if C["EnableQuestReward"] ~= true then return end

local function pipe(self)
    for i=1, self.numActiveOptionFrames do
        local rewardFrame = self["Option"..i].Rewards
        local _, _, _, _, _, numItems = GetQuestChoiceRewardInfo(i)

        if numItems ~= 0 then
            local _, _, _, _, _, itemLink = GetQuestChoiceRewardItem(i, 1) --for now there is only ever 1 item by design
            if itemLink then
                P:TextDisplay(rewardFrame.Item, itemLink)
            end
        end
    end
end

local function ADDON_LOADED(self, event, addon)
    if addon == "Blizzard_QuestChoice" then
        hooksecurefunc(QuestChoiceFrame, "ShowRewards", pipe)
        P:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

if IsAddOnLoaded("Blizzard_QuestChoice") then
    hooksecurefunc(QuestChoiceFrame, "ShowRewards", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end

-- local function pipe()
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
                -- P:TextDisplay(questItem, GetQuestLogItemLink(questItem.type, i))
            -- else
                -- P:TextDisplay(questItem, GetQuestItemLink(questItem.type, i))
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
                -- P:TextDisplay(questItem, GetQuestLogItemLink(questItem.type, i))
            -- else
                -- P:TextDisplay(questItem, GetQuestItemLink(questItem.type, i))
            -- end
            -- rewardsCount = rewardsCount + 1
        -- end
    -- end
-- end

-- hookesecurefunc("QuestInfo_ShowRewards", pipe)