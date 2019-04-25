local threshold

local function ilevel(...)
	local ilevel = -1
	for i=1, select("#", ...) do
		local itemLink = select(i, ...)

		if (itemLink) then
			ilevel = SyLevel:GetUpgradedItemLevel(itemLink)
			if not ilevel then
				ilevel = -1
			end
		end
	end

	if ilevel and (ilevel >= threshold) then
		return ilevel
	end
end

SyLevel:RegisterOptionCallback(function(db)
	local filters = db.FilterSettings
	if (filters and filters.ilevel) then
		threshold = filters.ilevel
	else
		threshold = 1
	end
end)

SyLevel:RegisterFilter("Item level text", "Text", ilevel, [[Adds item level text that the items have.]])