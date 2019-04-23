
local hook
local _E

local function update(self)
    local id = self:GetID()
    local name = self:GetName()
    local size = self.size

    for i=1, size do
        local bid = size - i + 1
        local slotFrame = _G[name.."Item"..bid]
        local itemLink = GetContainerItemLink(id, i)
        PingumaniaItemlevel:CallFilters("bags", slotFrame, _E and itemLink, id, i)
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

PingumaniaItemlevel:RegisterPipe("bags", enable, disable, update, "Bags", nil)