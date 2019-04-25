
local _E
local hook

local function update()
    if (not QuestInfoRewardsFrame or not QuestInfoRewardsFrame:IsShown()) then return end
	-- Now, get information about this quest.
	local StaticRewards, RewardChoices
	local GetLinkFunction, GetRewardInfoFunction
	if QuestInfoFrame.questLog then
		StaticRewards = GetNumQuestLogRewards()
		RewardChoices = GetNumQuestLogChoices()
		GetLinkFunction = GetQuestLogItemLink
	else
		StaticRewards = GetNumQuestRewards()
		RewardChoices = GetNumQuestChoices()
		GetLinkFunction = GetQuestItemLink
	end
	-- BUG: In 7.0, sometimes when turning in a quest (the "else" case above), these numbers are still 0 by the time that this is called.  Calling GetNumQuest*() too early apparently prevents the reward from getting shown at all...?
	if StaticRewards + RewardChoices == 0 then return end
	if not QuestInfo_GetRewardButton(QuestInfoFrame.rewardsFrame, 1) then
		return
	end

	for i = 1, StaticRewards do
        local itemLink = GetLinkFunction("reward", i)
        if itemLink then
            local questItem = QuestInfo_GetRewardButton(QuestInfoFrame.rewardsFrame, i)
            local slotFrame = questItem.IconBorder
			SyLevel:CallFilters("questreward", slotFrame, _E and itemLink)
		end
    end
    
	for i = 1, RewardChoices do
        local itemLink = GetLinkFunction("choice", i)
        if itemLink then
            local questItem = QuestInfo_GetRewardButton(QuestInfoFrame.rewardsFrame, i)
            local slotFrame = questItem.IconBorder
			SyLevel:CallFilters("questreward", slotFrame, _E and itemLink)
		end
	end
end

local function OnQuestInfo_Display(template)
	-- There are a variety of QUEST_TEMPLATE_* tables in QuestInfo.lua.  Instead of hooking QuestInfo_ShowRewards directly,
	-- wait until after QuestInfo_Display is finished, and then call our QuestInfo_ShowRewards hook if QuestInfo_ShowRewards
	-- was ever called.  (I don't remember why...) 
	local i = 1
	while template.elements[i] do
		if template.elements[i] == QuestInfo_ShowRewards then update() return end
		i = i + 3
	end
end

local function doHook()
    if (not hook) then 
        hook = function(...)
            if _E then return OnQuestInfo_Display(...) end
        end
        hooksecurefunc("QuestInfo_Display", OnQuestInfo_Display)
    end
end

local function enable(self)
	_E = true
    doHook()
end

local function disable(self)
    _E = nil
end

SyLevel:RegisterPipe("questreward", enable, disable, update, "Quest Reward Frame", nil)