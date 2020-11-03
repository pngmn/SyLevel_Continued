-- TODO:
--  - Write a description.

local _E

if (IsAddOnLoaded("LiteBag")) then return end
if (IsAddOnLoaded("Bagnon")) then return end
if (IsAddOnLoaded("Inventorian")) then return end

local function update()
	if (not BankFrame:IsVisible()) then return end
	for i=1, NUM_BANKGENERIC_SLOTS or 28 do
		local slotFrame = _G["BankFrameItem"..i]
		local slotLink = GetContainerItemLink(-1, i)
		SyLevel:CallFilters("bank", slotFrame, _E and slotLink)
	end
end

local function enable(self)
	_E = true

	self:RegisterEvent("BANKFRAME_OPENED", update)
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

local function disable(self)
	_E = nil

	self:UnregisterEvent("BANKFRAME_OPENED", update)
	self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

SyLevel:RegisterPipe("bank", enable, disable, update, "Bank Window", nil)
