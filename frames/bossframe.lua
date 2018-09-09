local P, C = unpack(select(2, ...))
if C["EnableBossFrame"] ~= true then return end

local function pipe(self, data)
    if not data then return end
    local slotLink = data.itemLink
    local slotFrame = self.IconHitBox
    
    local ilevel = P:GetUpgradedItemLevel(slotLink)
    P:TextDisplay(slotFrame, ilevel)
end

hooksecurefunc("BossBanner_ConfigureLootFrame", pipe)