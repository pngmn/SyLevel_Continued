local P, C = unpack(select(2, ...))
if C["EnableBag"] ~= true then return end

local function pipe(self)
    if not LiteBagInventory:IsShown() then return end
    local i = self:GetID()
    local container = self:GetParent():GetID()
    local name = self:GetName()
    local slotFrame = _G[name]
    local itemlink = GetContainerItemLink(container, i)
    
    P:TextDisplay(slotFrame, itemlink, container, i)
end

local function PLAYER_LOGIN()
    if not IsAddOnLoaded("LiteBag") then return end
    hooksecurefunc("LiteBagItemButton_UpdateItem", pipe)
end

P:RegisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)