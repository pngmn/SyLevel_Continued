local _, ns = ...
local SyLevel = ns.SyLevel
local argcheck = SyLevel.argcheck

local displaysTable = {}

--[[ Display API ]]

function SyLevel:RegisterDisplay(name, display)
	argcheck(name, 2, "string")
	argcheck(display, 3, "function")

	displaysTable[name] = display
end

ns.displaysTable = displaysTable