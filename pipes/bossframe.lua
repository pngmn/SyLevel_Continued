
local _E
local hook

local function update(self, data)
    if not data then return end
    local itemLink = data.itemLink
    local slotFrame = self.IconHitBox
    Sylevel:CallFilters("bossframe", slotFrame, _E and itemLink)
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

SyLevel:RegisterPipe("bossframe", enable, disable, update, "Boss Frame", nil)