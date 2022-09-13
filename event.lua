local P, C = unpack(select(2, ...))

local name = P.Name

local function argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1, select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	return P[event](P, event, ...)
end)

local eventMetatable = {
	__call = function(funcs, self, ...)
		for _, func in next, funcs do
			func(self, ...)
		end
	end,
}

function P:RegisterEvent(event, func)
	argcheck(event, 2, "string")

	if (type(func) == "string" and type(self[func]) == "function") then
		func = self[func]
	end

	local curev = self[event]
	local kind = type(curev)
	if(curev and func) then
		if (kind == "function" and curev ~= func) then
			self[event] = setmetatable({curev, func}, eventMetatable)
		elseif (kind == "table") then
			for _, infunc in next, curev do
				if (infunc == func) then return end
			end

			table.insert(curev, func)
		end
	elseif (eventFrame:IsEventRegistered(event)) then
		return
	else
		if (type(func) == "function") then
			self[event] = func
		elseif (not self[event]) then
			return error("Handler for event [%s] does not exist.", event)
		end

		eventFrame:RegisterEvent(event)
	end
end

function P:IsEventRegistered(event)
	return eventFrame:IsEventRegistered(event)
end

function P:UnregisterEvent(event, func)
	argcheck(event, 2, "string")

	local curev = self[event]
	if (type(curev) == "table" and func) then
		for k, infunc in next, curev do
			if (infunc == func) then
				table.remove(curev, k)

				local n = #curev
				if (n == 1) then
					local _, handler = next(curev)
					self[event] = handler
				elseif (n == 0) then
					eventFrame:UnregisterEvent(event)
				end

				break
			end
		end
	elseif (curev == func) then
		self[event] = nil
		eventFrame:UnregisterEvent(event)
	end
end
