local P, C = unpack(select(2, ...))

local pipesTable = {}
local numPipes = 0

local argcheck = P.argcheck

function P:RegisterPipe(pipe, enable, disable, update, name, desc)
	argcheck(pipe, 2, "string")
	argcheck(enable, 3, "function")
	argcheck(disable, 4, "function", "nil")
	argcheck(update, 5, "function")
	argcheck(name, 6, "string", "nil")
	argcheck(desc, 7, "string", "nil")

	-- Silently fail.
	if(pipesTable[pipe]) then
		return nil, string.format("Pipe [%s] is already registered.")
	else
		numPipes = numPipes + 1

		pipesTable[pipe] = {
			enable = enable;
			disable = disable;
			name = name;
			update = update;
			desc = desc;
		}
	end

	return true
end

do
	local function iter(_, n)
		local n, t = next(pipesTable, n)
		if(t) then
			return n, t.isActive, t.name, t.desc
		end
	end
    
	function P.IteratePipes()
		return iter, nil, nil
	end
end

function P:EnablePipe(pipe)
	argcheck(pipe, 2, "string")

	local ref = pipesTable[pipe]
	if(ref and not ref.isActive) then
		ref.enable(self)
		ref.isActive = true

		PingumaniaItemLevelDB.EnabledPipes[pipe] = true

		return true
	end
end

function P:DisablePipe(pipe)
	argcheck(pipe, 2, "string")

	local ref = pipesTable[pipe]
	if(ref and ref.isActive) then
		if(ref.disable) then ref.disable(self) end
		ref.isActive = false

		PingumaniaItemLevelDB.EnabledPipes[pipe] = false

		return true
	end
end

function P:IsPipeEnabled(pipe)
	argcheck(pipe, 2, "string")

	return pipesTable[pipe].isActive
end

function P:UpdatePipe(pipe)
	argcheck(pipe, 2, "string")

	local ref = pipesTable[pipe]
	if(ref) then
		ref.update(self)

		return true
	end
end

function P:GetNumPipes()
	return numPipes
end

P.pipesTable = pipesTable