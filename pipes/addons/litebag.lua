local _E
local hook

local function update(self)
    if (not IsAddOnLoaded("LiteBag")) then return end
    if (not LiteBagInventory:IsShown()) then return end
    local i = self:GetID()
    local id = self:GetParent():GetID()
    local name = self:GetName()
    local slotFrame = _G[name]
    local itemlink = GetContainerItemLink(id, i)
    SyLevel:CallFilters("litebag", slotFrame, _E and itemLink, id, i)
end

local function PLAYER_LOGIN()
    if (not IsAddOnLoaded("LiteBag")) then return end
    if (not hook) then
		hooksecurefunc("LiteBagItemButton_UpdateItem", update)
		hook = true
	end
end

local function enable()
	_E = true
    SyLevel:RegisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)
end

local function disable()
    _E = nil
    SyLevel:UnregisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)
end

SyLevel:RegisterPipe("litebag", enable, disable, update, "LiteBag", nil)