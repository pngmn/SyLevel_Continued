local threshold
--local IUI = LibStub("LibItemUpgradeInfo-1.0")

local ilevel = function(itemLink, id, slot)
	local ilevel = -1

	if (itemLink) then
		ilevel = SyLevel:GetUpgradedItemLevel(itemLink, id, slot)
		if not ilevel then
			ilevel = -1
		end
	end

	if ilevel and (ilevel >= threshold) then
		return ilevel
	end
end

SyLevel:RegisterOptionCallback(function(db)
	local filters = db.FilterSettings
	if(filters and filters.ilevel) then
		threshold = filters.ilevel
	else
		threshold = 1
	end
end)

SyLevel:RegisterFilter('Item level text', 'Text', ilevel, [[Adds item level text that the items have.]])
