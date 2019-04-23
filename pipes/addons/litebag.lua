local _E
local hook

local function update(self)
    if not LiteBagInventory:IsShown() then return end
    local i = self:GetID()
    local container = self:GetParent():GetID()
    local name = self:GetName()
    local slotFrame = _G[name]
    local itemlink = GetContainerItemLink(container, i)
    PingumaniaItemlevel:CallFilters("litebag", slotFrame, _E and itemLink, container, i)
end

local function PLAYER_LOGIN()
    if not IsAddOnLoaded("LiteBag") then return end
    if (not hook) then
		hooksecurefunc("LiteBagItemButton_UpdateItem", update)
		hook = true
	end
end

local function enable()
	_E = true
    PingumaniaItemlevel:RegisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)
end

local function disable()
    _E = nil
    PingumaniaItemlevel:UnregisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)
end

PingumaniaItemlevel:RegisterPipe("litebag", enable, disable, update, "LiteBag", nil)