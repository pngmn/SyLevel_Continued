local P, C = unpack(select(2, ...))
if C["EnableTrade"] ~= true then return end

local function player(self, event, index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)

    P:TextDisplay(slotFrame, slotLink)
end

local function target(self, event, index)
	local slotFrame = _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)

    P:TextDisplay(slotFrame, slotLink)
end

local function update(self)
	for i=1, MAX_TRADE_ITEMS or 8 do
		player(self, nil, i)
		target(self, nil, i)
	end
end

P:RegisterEvent("TRADE_UPDATE", update)
P:RegisterEvent("TRADE_SHOW", update)
P:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
P:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)