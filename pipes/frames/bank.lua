local P, C = unpack(select(2, ...))

local _E

local function update(self)
	if (BankFrame:IsShown()) then
		for i=1, NUM_BANKGENERIC_SLOTS or 28 do
			local slotFrame = _G["BankFrameItem" .. i]
			local itemLink = GetContainerItemLink(-1, i)

			P:CallFilters("bank", slotFrame, _E and itemLink, -1, i)
		end
	end
end

local function enable(self)
	_E = true

	P:RegisterEvent("BANKFRAME_OPENED", update)
	P:RegisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

local function disable(self)
	_E = nil

	P:UnregisterEvent("BANKFRAME_OPENED", update)
	P:UnregisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

P:RegisterPipe("bank", enable, disable, update, "Bank Window", nil)