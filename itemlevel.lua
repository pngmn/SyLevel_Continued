local _, ns = ...
local SyLevel = ns.SyLevel

local LE_ITEM_QUALITY_ARTIFACT=Enum.ItemQuality.Artifact
local LE_ITEM_QUALITY_HEIRLOOM=Enum.ItemQuality.Heirloom

do
	local oGetItemInfo = GetItemInfo
	ns.itemcache = ns.itemcache or setmetatable({miss = 0, tot = 0}, {__index = function(table, key)
			if not key then return "" end
			if key == "miss" then return 0 end
			if key == "tot" then return 0 end
			local cached = {oGetItemInfo(key)}
			if #cached == 0 then return nil end
			local itemLink = cached[2]
			if not itemLink then return nil end
			local cacheIt = true
			if cacheIt then
				rawset(table, key, cached)
			end
			table.miss = table.miss + 1
			return cached
		end})
end

local cache = ns.itemcache
local function CachedGetItemInfo(key, index)
	if not key then return nil end
	index = index or 1
	cache.tot = cache.tot + 1
	local cached = cache[key]
	if cached and type(cached) == "table" then
		return select(index, unpack(cached))
	else
		rawset(cache, key, nil) -- voiding broken cache entry
	end
end

-- Tooltip Scanning stuff
ns.tipCache = ns.tipCache or setmetatable({}, {__index = function(table, key) return {} end})
local tipCache = ns.tipCache
local emptytable = {}
local scanningTooltip, anchor
local itemLevelPattern = _G.ITEM_LEVEL:gsub('%%d', '(%%d+).?%%(?(%%d*)%%)?')
-- local minItemLevelPattern = _G.ITEM_LEVEL:gsub('%%d', '(%%d+%%+?).?%%(?(%%d*)%%)?')

local function ScanTip(itemLink, key, slot)
	if type(itemLink) == "number" then
		itemLink = CachedGetItemInfo(itemLink, 2)
		if not itemLink then return emptytable end
	end

	if type(tipCache[itemLink].gearcheck) == "nil" then
		local cacheIt = true
		tipCache[itemLink] = {
			ilevel = nil,
			ilevelString = nil,
			quality = CachedGetItemInfo(itemLink, 3),
			gearcheck = SyLevel:CheckGear(itemLink),
			cached = cacheIt
		}
	end

	if tipCache[itemLink].gearcheck == false then
		return emptytable
	end

	if type(tipCache[itemLink].ilevel) == "nil" or not tipCache[itemLink].cached then
		local skipScan = nil

		if not scanningTooltip then
			scanningTooltip = _G.CreateFrame("GameTooltip", "GearLevelScanTooltip", nil, "GameTooltipTemplate")
			anchor = CreateFrame("Frame")
			anchor:Hide()
		end

		GameTooltip_SetDefaultAnchor(scanningTooltip, anchor)
		scanningTooltip:ClearLines()
		local itemString = itemLink:match("|H(.-)|h")
		local rc
		if key and key > -1 and slot then
			rc = pcall(scanningTooltip.SetBagItem, scanningTooltip, key, slot)
		elseif key then
			rc = pcall(scanningTooltip.SetInventoryItem, scanningTooltip, "player", (key == -1) and BankButtonIDToInvSlotID(slot) or key)
		else
			rc = pcall(scanningTooltip.SetHyperlink, scanningTooltip, itemString)
		end

		-- Don't cache Artifact Weapons
		if tipCache[itemLink].quality == LE_ITEM_QUALITY_ARTIFACT then
			tipCache[itemLink].cached = false
		end

		if not rc then return emptytable end
		scanningTooltip:Show()

		local c = tipCache[itemLink]
		for i = 2, 3 do
			local label = _G["GearLevelScanTooltipTextLeft"..i]
			local text = label and label:GetText()
			if text then
				local normal, timewalking
				if c.ilevel == nil then
					normal, timewalking = text:match(itemLevelPattern)
					if timewalking and timewalking ~= "" then
						c.ilevel = tonumber(timewalking)
						tipCache[itemLink].cached = false
					else
						c.ilevel = tonumber(normal)
						tipCache[itemLink].cached = true
					end
				end
			end
		end
		c.ilevel = c.ilevel or 1
		scanningTooltip:Hide()
	end

	return tipCache[itemLink]
end

function SyLevel:GetHeirloomTrueLevel(itemString, id, slot)
	if type(itemString) ~= "string" then return nil, false end
	local _, itemLink = CachedGetItemInfo(itemString)
	if not itemLink then
		return nil, false
	end
	local rc = ScanTip(itemString, id, slot)
	if rc.ilevel then
		return rc.ilevel, rc.quality, true
	else
		return nil, nil, false
	end
end

function SyLevel:GetUpgradedItemLevel(itemString, id, slot)
	local ilvl, quality, isTrue = self:GetHeirloomTrueLevel(itemString, id, slot)
	if isTrue then
		return ilvl, quality
	end
end

function SyLevel:CheckGear(itemString)
	local _, _, _, _, _, itemClass, itemSubClass = GetItemInfoInstant(itemString)
	if itemClass == LE_ITEM_CLASS_WEAPON or itemClass == LE_ITEM_CLASS_ARMOR
		or itemSubClass == LE_ITEM_ARMOR_RELIC or itemSubClass == LE_ITEM_ARMOR_IDOL then
		return true
	else
		return false
	end
end