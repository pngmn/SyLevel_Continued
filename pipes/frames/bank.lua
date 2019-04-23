
local _E

local function update(self)
	if (BankFrame:IsShown()) then
		for i=1, NUM_BANKGENERIC_SLOTS or 28 do
			local slotFrame = _G["BankFrameItem" .. i]
			local itemLink = GetContainerItemLink(-1, i)

			PingumaniaItemlevel:CallFilters("bank", slotFrame, _E and itemLink, -1, i)
		end
	end
end

local function enable(self)
	_E = true

	PingumaniaItemlevel:RegisterEvent("BANKFRAME_OPENED", update)
	PingumaniaItemlevel:RegisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

local function disable(self)
	_E = nil

	PingumaniaItemlevel:UnregisterEvent("BANKFRAME_OPENED", update)
	PingumaniaItemlevel:UnregisterEvent("PLAYERBANKSLOTS_CHANGED", update)
end

PingumaniaItemlevel:RegisterPipe("bank", enable, disable, update, "Bank Window", nil)