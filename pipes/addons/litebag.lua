local _E
local hook
if (not IsAddOnLoaded("LiteBag")) then return end

local function update(self)
    if (not (LiteBagInventory:IsShown() or LiteBagBank:IsShown())) then return end
    local i = self:GetID()
    local id = self:GetParent():GetID()
    local name = self:GetName()
    local slotFrame = _G[name]
    local itemLink = GetContainerItemLink(id, i)
    SyLevel:CallFilters("litebag", slotFrame, _E and itemLink, id, i)
end

local function enable()
	_E = true
    if (not hook) then
        hook = function(...)
			if (_E) then return update(...) end
		end
        hooksecurefunc("LiteBagItemButton_UpdateItem", update)
	end
end

local function disable()
    _E = nil
end

SyLevel:RegisterPipe("litebag", enable, disable, update, "LiteBag", nil)