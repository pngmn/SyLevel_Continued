local _E
local hook

if not tdBag2 then return end
if not tdBag2.RegisterPlugin then return end

local function pipe(item)
	local name = item:GetName()
	local slotFrame = _G[name]
	local itemLink = GetContainerItemLink(item.bag, item.slot)
	SyLevel:CallFilters("tdbag2", slotFrame, _E and itemLink, item.bag, item.slot)
end

local function enable()
	_E = true
	if (not hook) then
		hook = function(...)
			if (_E) then return pipe(...) end
		end
		tdBag2:RegisterPlugin{type = "Item", update = pipe}
	end
end

local function disable()
	_E = nil
end

SyLevel:RegisterPipe("tdbag2", enable, disable, pipe, "tdBag2", nil)