local P, C = unpack(select(2, ...))

local threshold, quality

local ilevel = function(frame, itemlink, id, slot)
	local ilevel = -1
    ilevel, quality = P:GetUpgradedItemLevel(itemlink, id, slot)
	if ilevel and (ilevel >= threshold) then
		return ilevel, quality
	end
end

P:RegisterOptionCallback(function(db)
	local filters = db.FilterSettings
	if(filters and filters.ilevel) then
		threshold = filters.ilevel
	else
		threshold = 1
	end
end)

P:RegisterFilter('Item level text', 'Text', ilevel, [[Adds item level text that the items have.]])
