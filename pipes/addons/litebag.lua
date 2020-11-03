local _E
local hook
if (not IsAddOnLoaded("LiteBag")) then return end

local function update(button)
	local slot = button:GetID()
    local bag = button:GetParent():GetID()
	local name = button:GetName()
	local slotFrame = _G[name]
	local itemLink = GetContainerItemLink(bag, slot)
	SyLevel:CallFilters("litebag", slotFrame, _E and itemLink, bag, slot)
end

local function enable()
	_E = true
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		LiteBag_RegisterHook("LiteBagItemButton_Update", update)
	end
end

local function disable()
	_E = nil
end

SyLevel:RegisterPipe("litebag", enable, disable, update, "LiteBag", nil)