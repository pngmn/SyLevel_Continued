local P, C = unpack(select(2, ...))
if C["EnableBank"] ~= true then return end

local function pipe(self)
	if BankFrame:IsShown() then
        local i = self:GetID()
        local container = self:GetParent():GetID()
        local name = self:GetName()
        
        local slotFrame = _G[name]
        local slotLink = GetContainerItemLink(container, i)

        local ilevel = P:GetUpgradedItemLevel(slotLink)
        P:TextDisplay(slotFrame, ilevel)
	end
end

hooksecurefunc("BankFrameItemButton_Update", pipe)