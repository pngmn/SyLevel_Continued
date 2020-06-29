local hook
local _E
if (not IsAddOnLoaded("Bagnon")) then return end

local function update(self)
		local bag = self.bag
		local id = self:GetID()
		local slotFrame = _G[self:GetName()]
		local slotLink = GetContainerItemLink(bag, id)
		SyLevel:CallFilters("Bagnonbags", slotFrame, _E and slotLink)
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		-- hooksecurefunc(Bagnon.Item, "Update", update)
		hooksecurefunc(Bagnon.Item, "UpdateBorder", update)
	end
end

local function enable(self)
	_E = true
	doHook()
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("Bagnonbags", enable, disable, update, "Bagnon Bag Window", nil)
