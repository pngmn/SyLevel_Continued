
local _E
local hook

local function update(self, data)
	if data then
		local itemLink = data.itemLink
		local slotFrame = self.IconHitBox
		SyLevel:CallFilters("bossframe", slotFrame, _E and itemLink)
	end
end

local function enable(self)
	_E = true

	if (not hook) then
		hooksecurefunc("BossBanner_ConfigureLootFrame", update)
		hook = true
	end
end

local function disable(self)
	_E = nil
end

SyLevel:RegisterPipe("bossframe", enable, disable, update, "Boss Frame", nil)