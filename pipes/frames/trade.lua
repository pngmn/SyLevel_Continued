
local _E

local function player(self, event, index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)
    PingumaniaItemlevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function target(self, event, index)
	local slotFrame = _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)
    PingumaniaItemlevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function update(self)
	for i=1, MAX_TRADE_ITEMS or 8 do
		player(self, nil, i)
		target(self, nil, i)
	end
end

local function enable(self)
	_E = true

	PingumaniaItemlevel:RegisterEvent("TRADE_UPDATE", update)
	PingumaniaItemlevel:RegisterEvent("TRADE_SHOW", update)
	PingumaniaItemlevel:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	PingumaniaItemlevel:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

local function disable(self)
	_E = nil

	PingumaniaItemlevel:UnregisterEvent("TRADE_UPDATE", update)
	PingumaniaItemlevel:UnregisterEvent("TRADE_SHOW", update)
	PingumaniaItemlevel:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	PingumaniaItemlevel:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

PingumaniaItemlevel:RegisterPipe("trade", enable, disable, update, "Trade Window", nil)