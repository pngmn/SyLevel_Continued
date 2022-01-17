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
local itemLevelPattern = gsub(ITEM_LEVEL, '%%d', '(%%d+).?%%(?(%%d*)%%)?')
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
			bind = nil,
			quality = CachedGetItemInfo(itemLink, 3),
			gearcheck = SyLevel:CheckGear(itemLink),
			cached = cacheIt
		}
	end

	if tipCache[itemLink].gearcheck == false then
		return emptytable
	end

	if type(tipCache[itemLink].ilevel) == "nil" or not tipCache[itemLink].cached then
		if not scanningTooltip then
			scanningTooltip = CreateFrame("GameTooltip", "SyLevelScanTooltip", nil, "GameTooltipTemplate")
			anchor = CreateFrame("Frame")
			anchor:Hide()
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

		for i = 2, 4 do
			local label = _G["SyLevelScanTooltipTextLeft"..i]
			local text = label and label:GetText()
			if text then
				if not tipCache[itemLink].ilevel then
					local normal, timewalking = strmatch(text, itemLevelPattern)
					if timewalking and timewalking ~= "" then
						tipCache[itemLink].ilevel = tonumber(timewalking)
						tipCache[itemLink].cached = false
					else
						tipCache[itemLink].ilevel = tonumber(normal)
						tipCache[itemLink].cached = true
					end
				end
				if not tipCache[itemLink].bind then
					if text == ITEM_BIND_ON_EQUIP then
						tipCache[itemLink].bind = true
						tipCache[itemLink].cached = false
					end
				end
			end
		end

		-- Don't cache Artifact Weapons
		if tipCache[itemLink].quality == LE_ITEM_QUALITY_ARTIFACT then
			tipCache[itemLink].cached = false
		end

		tipCache[itemLink].ilevel = tipCache[itemLink].ilevel or 1
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
		return rc.ilevel, rc.quality, rc.bind, true
	else
		return nil, nil, false, false
	end
end

function SyLevel:GetUpgradedItemLevel(itemString, id, slot)
	local ilvl, quality, bind, isTrue = self:GetHeirloomTrueLevel(itemString, id, slot)
	if isTrue then
		return ilvl, quality, bind
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