local _, ns = ...
ns.SyLevel = {}

function ns.SyLevel.argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end


function GetItemLink(input)
	local output
	if GetItemInfo(input) ~= nil then
		output = select(2,GetItemInfo(input))
	end	
	if output then return output end
end