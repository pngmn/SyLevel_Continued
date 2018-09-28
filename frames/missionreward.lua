local P, C = unpack(select(2, ...))
if C["EnableMissionReward"] ~= true then return end

local function pipe(frame)
    local _, itemLink = GetItemInfo(frame.itemID)
    P:TextDisplay(frame, itemLink)
end

hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", pipe)