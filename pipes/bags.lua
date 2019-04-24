-- TODO:
--  - Prevent unnecessary double updates.
--  - Write a description.

local hook
local _E

local function update(self)
    local id = self:GetID()
    local name = self:GetName()
    local size = self.size

    for i=1, size do
        local bid = size - i + 1
        local slotFrame = _G[name.."Item"..bid]
        local slotLink = GetContainerItemLink(id, i)
        SyLevel:CallFilters("bags", slotFrame, _E and slotLink)
    end
end

local function enable(self)
	_E = true

	if (not hook) then
		hooksecurefunc("ContainerFrame_Update", pipe)
		hook = true
	end
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("bags", enable, disable, update, "Bags", nil)
