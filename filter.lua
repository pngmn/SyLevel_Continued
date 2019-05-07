local _, ns = ...
local SyLevel = ns.SyLevel

local argcheck = SyLevel.argcheck
local pipesTable = ns.pipesTable

local filtersTable = {}
local activeFilters = {}
local numFilters = 0

function SyLevel:RegisterFilter(name, type, filter, desc)
	argcheck(name, 2, "string")
	argcheck(type, 3, "string")
	argcheck(filter, 4, "function")
	argcheck(desc, 5, "string", "nil")

	if (filtersTable[name]) then return nil, "Filter function is already registered." end
	filtersTable[name] = {type, filter, name, desc}

	numFilters = numFilters + 1

	return true
end

do
	local function iter(_, n)
		local n, t = next(filtersTable, n)
		if (t) then
			return n, t[1], t[4]
		end
	end

	function SyLevel.IterateFilters()
		return iter, nil, nil
	end
end

-- TODO: Validate that the display we try to use actually exists.
function SyLevel:RegisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, "string")
	argcheck(filter, 3, "string")

	if (not pipesTable[pipe]) then return nil, "Pipe does not exist." end
	if (not filtersTable[filter]) then return nil, "Filter does not exist." end

	-- XXX: Clean up this logic.
	if (not activeFilters[pipe]) then
		local filterTable = filtersTable[filter]
		local display = filterTable[1]
		activeFilters[pipe] = {}
		activeFilters[pipe][display] = {}
		table.insert(activeFilters[pipe][display], filterTable)
	else
		local filterTable = filtersTable[filter]
		local ref = activeFilters[pipe][filterTable[1]]

		for _, func in next, ref do
			if (func == filter) then
				return nil, "Filter function is already registered."
			end
		end
		table.insert(ref, filterTable)
	end

	if (not SyLevelDB.EnabledFilters[filter]) then
		SyLevelDB.EnabledFilters[filter] = {}
	end
	SyLevelDB.EnabledFilters[filter][pipe] = true

	return true
end

function SyLevel.IterateFiltersOnPipe(pipe)
	local t = activeFilters[pipe]
	return coroutine.wrap(function()
		if (t) then
			for _, sub in next, t do
				for k, v in next, sub do
					coroutine.yield(v[3], v[1], v[4])
				end
			end
		end
	end)
end

function SyLevel:UnregisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, "string")
	argcheck(filter, 3, "string")

	if (not pipesTable[pipe]) then return nil, "Pipe does not exist." end
	if (not filtersTable[filter]) then return nil, "Filter does not exist." end

	--- XXX: Be more defensive here.
	local filterTable = filtersTable[filter]
	local ref = activeFilters[pipe][filterTable[1]]
	if (ref) then
		for k, func in next, ref do
			if (func == filterTable) then
				table.remove(ref, k)
				SyLevelDB.EnabledFilters[filter][pipe] = nil

				return true
			end
		end
	end
end

function SyLevel:GetNumFilters()
	return numFilters
end

ns.filtersTable = filtersTable
ns.activeFilters = activeFilters