local P, C = unpack(select(2, ...))
if C["EnableBag"] ~= true then return end

local function pipe(self)
    local id = self:GetID()
    local name = self:GetName()
    local size = self.size

    for i=1, size do
        local bid = size - i + 1
        local slotFrame = _G[name.."Item"..bid]
        local itemLink = GetContainerItemLink(id, i)
        P:TextDisplay(slotFrame, itemLink, id, i)
    end
end

local function PLAYER_LOGIN()
    if IsAddOnLoaded("LiteBag") then return end
    hooksecurefunc("ContainerFrame_Update", pipe)
end

P:RegisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)