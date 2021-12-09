local function binds(itemLink, id, i)
	local bind
	if (itemLink) then
		bind = select(3, SyLevel:GetUpgradedItemLevel(itemLink, id, i))
	end

	return bind and "BoE" or ""
end

SyLevel:RegisterFilter("Bind text", "BindsOnText", binds, [[Adds bind on text that the items have.]])