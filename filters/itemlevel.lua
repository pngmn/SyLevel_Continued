local ilevelThreshold, qualityThreshold

local function ilevel(itemLink, id, i)
	local ilevel = -1
	if (itemLink) then
		ilevel, itemQuality = SyLevel:GetUpgradedItemLevel(itemLink, id, i)
		if not ilevel then
			ilevel = -1
		end
	end

	if ilevel and (ilevel >= ilevelThreshold) and (itemQuality >= qualityThreshold) then
		return ilevel, itemQuality
	end
end

SyLevel:RegisterOptionCallback(function(db)
	local filters = db.FilterSettings
	if (filters and filters.ilevel) then
		ilevelThreshold = filters.ilevel
	else
		ilevelThreshold = 1
	end
	if (filters and filters.quality) then
		qualityThreshold = filters.quality
	else
		qualityThreshold = 0
	end
end)

SyLevel:RegisterFilter("Item level text", "Text", ilevel, [[Adds item level text that the items have.]])