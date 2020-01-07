local hook
local _E

if (IsAddOnLoaded("LiteBag")) then return end
if (IsAddOnLoaded("Bagnon")) then return end
if (IsAddOnLoaded("Inventorian")) then return end

local function update(self)
    if (ContainerFrame1:IsShown()) then
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
end

local function doHook()
    if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end
		hooksecurefunc("ContainerFrame_Update", update)
	end
end

local function enable(self)
	_E = true
    doHook()
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("bags", enable, disable, update, "Bags", nil)
