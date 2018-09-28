local P, C = unpack(select(2, ...))
if C["EnableGuildBank"] ~= true then return end

local function pipe(self)
    if (not GuildBankFrame or not GuildBankFrame:IsShown()) then return end

	local tab = GetCurrentGuildBankTab()
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB or 98 do
		local index = math.fmod(i, 14)
		if index == 0 then
			index = 14
		end
		local column = math.ceil((i-0.5)/14)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

        P:TextDisplay(slotFrame, slotLink)
	end
end

P:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED", pipe)
P:RegisterEvent("GUILDBANKFRAME_OPENED", pipe)