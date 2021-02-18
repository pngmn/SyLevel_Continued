local _E

local function player(index)
	local slotFrame = index and _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = index and GetTradePlayerItemLink(index)

	SyLevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function target(index)
	local slotFrame = index and _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = index and GetTradeTargetItemLink(index)

	SyLevel:CallFilters("trade", slotFrame, _E and slotLink)
end

local function update()
	for i = 1, MAX_TRADE_ITEMS or 8 do
		player(i)
		target(i)
	end
end

local function TRADE_PLAYER_ITEM_CHANGED(self, event, index)
	player(index)
end

local function TRADE_TARGET_ITEM_CHANGED(self, event, index)
	target(index)
end

local function enable(self)
	_E = true

	self:RegisterEvent("TRADE_UPDATE", update)
	self:RegisterEvent("TRADE_SHOW", update)
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", TRADE_PLAYER_ITEM_CHANGED)
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", TRADE_TARGET_ITEM_CHANGED)
end

local function disable(self)
	_E = nil

	self:UnregisterEvent("TRADE_UPDATE", update)
	self:UnregisterEvent("TRADE_SHOW", update)
	self:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

SyLevel:RegisterPipe("trade", enable, disable, update, "Trade Window", nil)