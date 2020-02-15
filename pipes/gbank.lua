local _E

local function update(self)
	if (not IsAddOnLoaded("Blizzard_GuildBankUI")) then return end
	local tab = GetCurrentGuildBankTab()
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB or 98 do
		local index = math.fmod(i, 14)
		if (index == 0) then
			index = 14
		end
		local column = math.ceil((i-0.5)/14)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

		self:CallFilters("gbank", slotFrame, _E and slotLink)
	end
end

local function enable(self)
	_E = true
	self:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED", update)
	self:RegisterEvent("GUILDBANKFRAME_OPENED", update)
end

local function disable(self)
	_E = nil
	self:UnregisterEvent("GUILDBANKBAGSLOTS_CHANGED", update)
	self:UnregisterEvent("GUILDBANKFRAME_OPENED", update)
end

SyLevel:RegisterPipe("gbank", enable, disable, update, "Guild Bank Window", nil)
