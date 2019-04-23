local P, C = unpack(select(2, ...))

local _E

local function update(self)
	if (not GuildBankFrame or not GuildBankFrame:IsShown()) then return end

	local tab = GetCurrentGuildBankTab()
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB or 98 do
		local index = math.fmod(i, 14)
		if (index == 0) then
			index = 14
		end
		local column = math.ceil((i-0.5)/14)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

		P:CallFilters("gbank", slotFrame, _E and slotLink)
	end
end

local function enable(self)
	_E = true

	P:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED", update)
	P:RegisterEvent("GUILDBANKFRAME_OPENED", update)
end

local function disable(self)
	_E = nil

	P:UnregisterEvent("GUILDBANKBAGSLOTS_CHANGED", update)
	P:UnregisterEvent("GUILDBANKFRAME_OPENED", update)
end

P:RegisterPipe("gbank", enable, disable, update, "Guild Bank Window", nil)