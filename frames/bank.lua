local P, C = unpack(select(2, ...))
if C["EnableBank"] ~= true then return end

local function pipe(self)
	if not BankFrame:IsShown() then return end
    local i = self:GetID()
    local container = self:GetParent():GetID()
    local name = self:GetName()
    local slotFrame = _G[name]
    local itemlink = GetContainerItemLink(container, i)

    P:TextDisplay(slotFrame, itemlink, container, i)
end

hooksecurefunc("BankFrameItemButton_Update", pipe)