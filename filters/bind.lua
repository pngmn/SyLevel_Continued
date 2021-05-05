local function binds(itemLink, id, i)
	local bind
	if (itemLink) then
		_, quality, bind = SyLevel:GetUpgradedItemLevel(itemLink, id, i)
	end

	return bind and "BoE" or "", quality
end

SyLevel:RegisterFilter("Bind text", "BindsOnText", binds, [[Adds bind on text that the items have.]])