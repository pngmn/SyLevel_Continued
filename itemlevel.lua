local P, C = unpack(select(2, ...))

local type, tonumber, select, strsplit, GetItemInfoFromHyperlink = type, tonumber, select, strsplit, GetItemInfoFromHyperlink
local unpack, GetDetailedItemLevelInfo = unpack, GetDetailedItemLevelInfo

local threshold = C["ItemLevel"].Min

do
    local oGetItemInfo = GetItemInfo
    P.itemcache = P.itemcache or setmetatable({miss = 0, tot = 0}, {__index = function(table, key)
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

local cache = P.itemcache
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
P.tipCache = P.tipCache or setmetatable({}, {__index = function(table, key) return {} end})
local tipCache = P.tipCache
local emptytable = {}
local scanningTooltip, anchor
local itemLevelPattern = _G.ITEM_LEVEL:gsub("%%d", "(%%d+)")
local minItemLevelPattern = _G.ITEM_LEVEL:gsub("%%d", "(%%d+%+?)")

local function ScanTip(itemLink, id, slot)
    if P:CheckGear(itemLink) == false then return emptytable end
    
    if type(itemLink) == "number" then
		itemLink = CachedGetItemInfo(itemLink, 2)
		if not itemLink then return emptytable end
	end
    
	if type(tipCache[itemLink].ilevel) == "nil" then -- or not tipCache[itemLink].cached then
		local cacheIt = true
        local ilevel
                     
		if not scanningTooltip then
			scanningTooltip = _G.CreateFrame("GameTooltip", "LibItemUpgradeInfoTooltip", nil, "GameTooltipTemplate")
            anchor = CreateFrame("Frame")
			anchor:Hide()
		end
        GameTooltip_SetDefaultAnchor(scanningTooltip, anchor)
        -- scanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        scanningTooltip:ClearLines()
		local itemString = itemLink:match("|H(.-)|h")
		local rc, message = pcall(scanningTooltip.SetHyperlink, scanningTooltip, itemString)
        if id and type(id) == "string" and slot then
            rc, message = pcall(scanningTooltip.SetInventoryItem, scanningTooltip, id, slot, nil, true)
        elseif id and type(id) == "number" and slot then
            rc, message = pcall(scanningTooltip.SetBagItem, scanningTooltip, id, slot) 
        end
		if not rc then return emptytable end
      	
        tipCache[itemLink] = {
            ilevel = nil,
            ilevelString = nil,
            cached = cacheIt
        }
        local c = tipCache[itemLink]
		for i = 2, 6 do
			local label, text = _G["LibItemUpgradeInfoTooltipTextLeft"..i], nil
			if label then text = label:GetText() end
			if text then
                if c.ilevel == nil then
                    c.ilevel = tonumber(text:match(itemLevelPattern))
                end
                if c.ilevelString == nil then
                    c.ilevelString = text:match(minItemLevelPattern)
                end
			end
		end
        c.ilevel = c.ilevel or 1
        scanningTooltip:Hide()
	end
	return tipCache[itemLink]
end

function P:GetHeirloomTrueLevel(itemString, id, slot)
	if type(itemString) ~= "string" then return nil, false end
	local _, itemLink = CachedGetItemInfo(itemString)
	if not itemLink then
		return nil, false
	end
	local rc = ScanTip(itemString, id, slot)
	if rc.ilevel and rc.ilevelString then
		return rc.ilevel, rc.ilevelString, true
	else
        return nil, false
    end
end

function P:GetUpgradedItemLevel(itemString, id, slot)
	local ilvl, ilvlText, isTrue = self:GetHeirloomTrueLevel(itemString, id, slot)
    if isTrue and ilvl >= threshold then
        return ilvlText
    end
end

function P:CheckGear(itemString)
    local _, _, _, _, _, itemClass = GetItemInfoInstant(itemString)
    if itemClass == LE_ITEM_CLASS_WEAPON or itemClass == LE_ITEM_CLASS_ARMOR then
        return true 
    else 
        return false
    end
end