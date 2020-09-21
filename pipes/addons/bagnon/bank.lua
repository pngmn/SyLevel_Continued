local hook
local _E
if (not IsAddOnLoaded("Bagnon")) then return end

local bagFrames = {}

local function IsBankSlot(bag)
	if type(bag) == "number" then
		if bag == -1 or (bag >= 5 or bag <= 11) then
			return true
		else
			return false
		end
	else
		return false
	end
end

local bankUpdate = function(self)
	if not bagFrames[self] then bagFrames[self] = self end
	if not self:GetVisibleBags() then return end
	for _, bag in self:GetVisibleBags() do
		if Bagnon:IsBank(bag) or Bagnon:IsBankBag(bag) then
			local bagSize = self:GetBagSize(bag)
			for slot = 1, bagSize do
				local itemSlot = self:GetItemSlot(bag, slot)
				SyLevel:CallFilters('Bagnonbags', itemSlot, _E and itemSlot:GetItem())
			end
		end
	end
end

local slotUpdate = function(self, _, bag, slot)
	local itemSlot = self:GetItemSlot(bag, slot)
	if not itemSlot or not IsBankSlot(bag) then return end
	SyLevel:CallFilters('Bagnonbags', itemSlot, _E and itemSlot:GetItem())
end

local update = function(self)
	for _, v in pairs(bagFrames) do
		if v then
			bankUpdate(v)
		end
	end
end

local enable = function(self)
	_E = true

	if (not hook) then
		if Bagnon.Bag then
			hooksecurefunc(Bagnon.ItemFrame, "UpdateEverything", bankUpdate)
			hooksecurefunc(Bagnon.ItemFrame, "HandleSpecificItemEvent", slotUpdate)
			hook = true
		end
	end
end

local disable = function(self)
	_E = nil
end

SyLevel:RegisterPipe('Bagnonbank', enable, disable, update, 'Bagnon Bank Window', nil)
