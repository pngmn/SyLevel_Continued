local P, C = unpack(select(2, ...))

local argcheck = P.argcheck

local displaysTable = {}

--[[ Display API ]]

function P:RegisterDisplay(name, display)
	argcheck(name, 2, "string")
	argcheck(display, 3, "function")

	displaysTable[name] = display
end

P.displaysTable = displaysTable