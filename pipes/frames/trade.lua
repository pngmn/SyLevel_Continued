local P, C = unpack(select(2, ...))

local _E

local function player(self, event, index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)
    P:CallFilters("trade", slotFrame, _E and slotLink)
end

local function target(self, event, index)
	local slotFrame = _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)
    P:CallFilters("trade", slotFrame, _E and slotLink)
end

local function update(self)
	for i=1, MAX_TRADE_ITEMS or 8 do
		player(self, nil, i)
		target(self, nil, i)
	end
end

local function enable(self)
	_E = true

	P:RegisterEvent("TRADE_UPDATE", update)
	P:RegisterEvent("TRADE_SHOW", update)
	P:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	P:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

local function disable(self)
	_E = nil

	P:UnregisterEvent("TRADE_UPDATE", update)
	P:UnregisterEvent("TRADE_SHOW", update)
	P:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	P:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

P:RegisterPipe("trade", enable, disable, update, "Trade Window", nil)