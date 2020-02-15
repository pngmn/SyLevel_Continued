local _E
local hook
if (not IsAddOnLoaded("LiteBag")) then return end

local function update(self)
	if (not (LiteBagInventory:IsVisible() or LiteBagBank:IsVisible())) then return end
	local i = self:GetID()
	local id = self:GetParent():GetID()
	local name = self:GetName()
	local slotFrame = _G[name]
	local itemLink = GetContainerItemLink(id, i)
	SyLevel:CallFilters("litebag", slotFrame, _E and itemLink, id, i)
end

local function pipe()
	local numSlots = 0
	for bag = 0, 4 do
		numSlots = numSlots + GetContainerNumSlots(bag)
	end
	for slot = 1, numSlots do
		local button = _G["LiteBagInventoryPanelItemButton"..slot]
		update(button)
	end
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

SyLevel:RegisterPipe("litebag", enable, disable, pipe, "LiteBag", nil)