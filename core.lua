local AddOnName, Engine = ...

local _G = _G

local AddOn = CreateFrame("FRAME")

Engine[1] = AddOn
Engine[2] = {}
Engine[3] = {}

_G[AddOnName] = Engine

AddOn.Name = AddOnName

function P.argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end