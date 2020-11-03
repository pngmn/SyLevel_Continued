local _E

local function player(index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)

	SyLevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function target(index)
	local slotFrame = _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)

	SyLevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function update()
	for i = 1, MAX_TRADE_ITEMS or 8 do
		player(i)
		target(i)
	end
end

local function enable(self)
	_E = true

	self:RegisterEvent("TRADE_UPDATE", update)
	self:RegisterEvent("TRADE_SHOW", update)
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

local function disable(self)
	_E = nil

	self:UnregisterEvent("TRADE_UPDATE", update)
	self:UnregisterEvent("TRADE_SHOW", update)
	self:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

SyLevel:RegisterPipe("trade", enable, disable, update, "Trade Window", nil)
