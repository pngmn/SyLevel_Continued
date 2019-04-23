local P, C = unpack(select(2, ...))

local _E
local hook

local function update(self, data)
    if not data then return end
    local slotLink = data.itemLink
    local slotFrame = self.IconHitBox
    P:CallFilters("bossframe", slotFrame, _E and slotLink)
end

local function enable()
	_E = true
    
    if (not hook) then
        hooksecurefunc("BossBanner_ConfigureLootFrame", update)
        hook = true
    end
end

local function disable()
    _E = nil
end

P:RegisterPipe("bossframe", enable, disable, update, "Boss Frame", nil)