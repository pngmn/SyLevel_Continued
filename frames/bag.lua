local P, C = unpack(select(2, ...))
if C["EnableBag"] ~= true then return end

local function pipe(self)
    local i = self:GetID()
    local container = self:GetParent():GetID()
    local name = self:GetName()

    local slotFrame = _G[name]
    local slotLink = GetContainerItemLink(container, i)
    
    local ilevel = P:GetUpgradedItemLevel(slotLink, container, i)
    P:TextDisplay(slotFrame, ilevel)
end

hooksecurefunc("ContainerFrameItemButton_UpdateItemUpgradeIcon", pipe)