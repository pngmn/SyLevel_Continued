local _, ns = ...
local SyLevel = ns.SyLevel

-- Tooltip Scanning stuff
local scanningTooltip, anchor
local getItemInfoCache = {}
local tipCache = {}
local itemLevelPattern = gsub(ITEM_LEVEL, '%%d', '(%%d+).?%%(?(%%d*)%%)?')
local bindPatterns = {
	[ITEM_BIND_ON_EQUIP] = "BoE",
	[ITEM_BIND_TO_BNETACCOUNT] = "BoA",
	[ITEM_BNETACCOUNTBOUND] = "BoA",
}

local function CachedGetItemInfo(key)
	if not key then return end
	if not getItemInfoCache[key] then
		getItemInfoCache[key] = select(2, GetItemInfo(key))
	end
	return getItemInfoCache[key]
end

local function ScanTip(itemLink, key, slot)
	if not itemLink then return end

	if not tipCache[itemLink] then
		tipCache[itemLink] = {
			ilevel = nil,
			bind = nil,
			quality = select(3, GetItemInfo(itemLink)),
			cached = nil
		}
	end

	if not tipCache[itemLink].ilevel or tipCache[itemLink].cached == false then
		if not scanningTooltip then
			anchor = CreateFrame("Frame")
			anchor:Hide()
			scanningTooltip = CreateFrame("GameTooltip", "SyLevelScanTooltip", nil, "GameTooltipTemplate")
		end
		GameTooltip_SetDefaultAnchor(scanningTooltip, anchor)
		scanningTooltip:ClearLines()
		local itemString = strmatch(itemLink, "|H(.-)|h")
		if key and key > -1 and slot then
			scanningTooltip.SetBagItem(scanningTooltip, key, slot)
		elseif key then
			scanningTooltip.SetInventoryItem(scanningTooltip, "player", (key == -1) and BankButtonIDToInvSlotID(slot) or key)
		else
			scanningTooltip.SetHyperlink(scanningTooltip, itemString)
		end
		scanningTooltip:Show()

		tipCache[itemLink].cached = true
		tipCache[itemLink].bind = nil

		for i = 2, 4 do
			local label = _G["SyLevelScanTooltipTextLeft"..i]
			local text = label and label:GetText()
			if text then
				local normal, timewalking = strmatch(text, itemLevelPattern)
				if timewalking and timewalking ~= "" then
					tipCache[itemLink].ilevel = tonumber(timewalking)
					tipCache[itemLink].cached = false
				elseif normal then
					tipCache[itemLink].ilevel = tonumber(normal)
				end

				-- Don't cache BoE gear
				if text == ITEM_BIND_ON_EQUIP then
					tipCache[itemLink].cached = false
				end

				for pattern, key in pairs(bindPatterns) do
					if strfind(text, pattern) then
						tipCache[itemLink].bind = key
					end
				end
			end
		end

		-- Don't cache Artifact Weapons
		if tipCache[itemLink].quality == Enum.ItemQuality.Artifact then
			tipCache[itemLink].cached = false
		end

		tipCache[itemLink].ilevel = tipCache[itemLink].ilevel or 1
		scanningTooltip:Hide()
	end

	return tipCache[itemLink].ilevel, tipCache[itemLink].quality, tipCache[itemLink].bind
end

function SyLevel:GetItemLevel(itemString, id, slot)
	if type(itemString) ~= "string" then
		return
	end
	local itemLink = CachedGetItemInfo(itemString)
	local ilevel, quality, bind = ScanTip(itemLink, id, slot)
	if ilevel then
		return ilevel, quality, bind
	end
end