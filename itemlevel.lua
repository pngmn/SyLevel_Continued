local _, ns = ...
local SyLevel = ns.SyLevel

local type, tonumber, select, strsplit, GetItemInfoFromHyperlink = type, tonumber, select, strsplit, GetItemInfoFromHyperlink
local unpack, GetDetailedItemLevelInfo = unpack, GetDetailedItemLevelInfo

do
    local oGetItemInfo = GetItemInfo
    ns.itemcache = ns.itemcache or setmetatable({miss = 0, tot = 0}, {__index = function(table, key)
			if not key then return "" end
			if key == "miss" then return 0 end
			if key == "tot" then return 0 end
			local cached = {oGetItemInfo(key)}
			if #cached == 0 then return nil end
			local itemLink = cached[2]
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
local minItemLevelPattern = _G.ITEM_LEVEL:gsub('%%d', '(%%d+%%+?).?%%(?(%%d*)%%)?')

local function ScanTip(itemLink, id, slot)    
    if type(itemLink) == "number" then
		itemLink = CachedGetItemInfo(itemLink, 2)
		if not itemLink then return emptytable end
	end
    
    if type(tipCache[itemLink].gearcheck) == "nil" then
        local cacheIt = true
        
        tipCache[itemLink] = {
            ilevel = nil,
            ilevelString = nil,
            quality = nil,
            gearcheck = nil,
            cached = cacheIt
        }
        local c = tipCache[itemLink]
        c.gearcheck = SyLevel:CheckGear(itemLink)
    end
    
    if tipCache[itemLink].gearcheck == false then
        return emptytable
    end

	if type(tipCache[itemLink].ilevel) == "nil" then
		local cacheIt = true
        local _, quality
                     
		if not scanningTooltip then
			scanningTooltip = _G.CreateFrame("GameTooltip", "GearLevelScanTooltip", nil, "GameTooltipTemplate")
            anchor = CreateFrame("Frame")
			anchor:Hide()
		end
        GameTooltip_SetDefaultAnchor(scanningTooltip, anchor)
        scanningTooltip:ClearLines()
		local itemString = itemLink:match("|H(.-)|h")
		local rc, message = pcall(scanningTooltip.SetHyperlink, scanningTooltip, itemString)
        if id and type(id) == "string" and slot then
            rc, message = pcall(scanningTooltip.SetInventoryItem, scanningTooltip, id, slot, nil, true)
            quality = GetInventoryItemQuality(id, slot)
        elseif id and type(id) == "number" and slot then
            rc, message = pcall(scanningTooltip.SetBagItem, scanningTooltip, id, slot) 
            _, _, _, quality = GetContainerItemInfo(id, slot)
        else
            _, _, quality = GetItemInfo(itemLink)
        end
		if not rc then return emptytable end
      	
        local c = tipCache[itemLink]
		for i = 2, 3 do
			local label, text = _G["GearLevelScanTooltipTextLeft"..i], nil
			if label then text = label:GetText() end
			if text then
                local normal, timewalking
                if c.ilevel == nil then
                    normal, timewalking = text:match(itemLevelPattern)
                    if timewalking ~= "" then
                        c.ilevel = tonumber(timewalking)
                    else
                        c.ilevel = tonumber(normal)
                    end
                end
                if c.ilevelString == nil then
                    normal, timewalking = text:match(minItemLevelPattern)
                    if timewalking ~= "" then
                        c.ilevelString = timewalking
                    else
                        c.ilevelString = normal
                    end
                end
			end
		end
        c.ilevel = c.ilevel or 1
        c.quality = quality
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
	if rc.ilevel and rc.ilevelString then
		return rc.ilevel, rc.ilevelString, rc.quality, true
	else
        return nil, false
    end
end

function SyLevel:GetUpgradedItemLevel(itemString, id, slot)
	local ilvl, ilvlText, quality, isTrue = self:GetHeirloomTrueLevel(itemString, id, slot)
    if isTrue then
        return ilvl
    end
end

function SyLevel:CheckGear(itemString)
    local _, _, _, _, _, itemClass = GetItemInfoInstant(itemString)
    if itemClass == LE_ITEM_CLASS_WEAPON or itemClass == LE_ITEM_CLASS_ARMOR then
        return true 
    else 
        return false
    end
end