local threshold

local function ilevel(itemLink, id, i)
	local ilevel = -1
	if (itemLink) then
		ilevel, ilevelString, ilevelQuality = SyLevel:GetUpgradedItemLevel(itemLink, id, i)
		if not ilevel then
			ilevel = -1
		end
	end

	if ilevel and (ilevel >= threshold) then
		return ilevel, ilevelString, ilevelQuality
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