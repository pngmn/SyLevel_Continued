local _E
local hook
if (not IsAddOnLoaded("LiteBag")) then return end

local function update(self)
	-- if (not (LiteBagInventory:IsVisible() or LiteBagBank:IsVisible())) then return end
	local i = self:GetID()
	local id = self:GetParent():GetID()
	local name = self:GetName()
	local slotFrame = _G[name]
	local itemLink = GetContainerItemLink(id, i)
	if itemLink then
		SyLevel:CallFilters("litebag", slotFrame, _E and itemLink, id, i)
	else
		SyLevel:CallFilters("litebag", slotFrame, _E and nil)
	end
end

local function pipe()
	for bag = 1, 5 do
		for slot = 1, GetContainerNumSlots(bag-1) do
			local button = _G["LiteBagInventoryPanelContainerFrame"..bag.."Item"..slot]
			if button then update(button) end
		end
	end
end

local function enable()
	_E = true
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		LiteBag_RegisterHook('LiteBagItemButton_Update', update)
		-- hooksecurefunc('LiteBagPanel_UpdateBag', pipe)
	end
end

local function disable()
	_E = nil
end

SyLevel:RegisterPipe("litebag", enable, disable, pipe, "LiteBag", nil)