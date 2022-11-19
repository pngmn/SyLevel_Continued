local hook
local _E

if (IsAddOnLoaded("LiteBag")) then return end
if (IsAddOnLoaded("Bagnon")) then return end
if (IsAddOnLoaded("Inventorian")) then return end

local function UpdateContainer(frame)
	local id = frame:GetID()
	local name = frame:GetName()
	local size = frame.size

	for i=1, size do
		local bid = size - i + 1
		local slotFrame = _G[name.."Item"..bid]
		local slotLink = C_Container.GetContainerItemLink(id, i)
		SyLevel:CallFilters("bags", slotFrame, _E and slotLink, id, i)
	end
end

local function UpdateCombinedContainer(frame)
	for id, button in frame:EnumerateItems() do
		local bagId = button:GetBagID()
		local buttonId = button:GetID()
		local slotLink = C_Container.GetContainerItemLink(bagId, buttonId)
		SyLevel:CallFilters("bags", button, _E and slotLink, bagId, buttonId)
	end
end

local function Update(frame)
	if frame.EnumerateItems then
		UpdateCombinedContainer(frame)
	else
		UpdateContainer(frame)
	end
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return update(...) end
		end

		local id = 1
		local frame = _G["ContainerFrame"..id]
		while (frame and frame.Update) do
			hooksecurefunc(frame, "Update", Update)
			id = id + 1
			frame = _G["ContainerFrame"..id]
		end

		hooksecurefunc(ContainerFrameCombinedBags, "Update", Update)
	end
end

local function enable(self)
	_E = true
	doHook()
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("bags", enable, disable, Update, "Bags", nil)
