local addon, ns = ...
ns.SyLevel = {}
ns.Name = addon
ns.TrivName = "SyLevel Continued"
ns.Classic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
ns.BCC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
ns.Mainline = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

function ns.SyLevel.argcheck(value, num, ...)
	assert(type(num) == "number", "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2, 2, 0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end