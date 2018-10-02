local P, C = unpack(select(2, ...))
if C["EnableBank"] ~= true then return end

local function pipe(self)
	if BankFrame:IsShown() then
		for i=1, NUM_BANKGENERIC_SLOTS or 28 do
			local slotFrame = _G["BankFrameItem"..i]
			local itemLink = GetContainerItemLink(-1, i)
            P:TextDisplay(slotFrame, itemlink, -1, i)
		end
	end
end

P:RegisterEvent("BANKFRAME_OPENED", pipe)
P:RegisterEvent("PLAYERBANKSLOTS_CHANGED", pipe)