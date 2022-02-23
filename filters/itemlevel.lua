local ilevelThreshold, qualityThreshold

local function ilevel(itemLink, id, i)
	local ilvl = -1
	local itemQuality = -1
	if (itemLink) then
		ilvl, itemQuality = SyLevel:GetItemLevel(itemLink, id, i)
	end

	if ilvl and (ilvl >= ilevelThreshold) and (itemQuality >= qualityThreshold) then
		return ilvl, itemQuality
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

SyLevel:RegisterFilter("Item level text", "ItemLevelText", ilevel, [[Adds item level text that the items have.]])