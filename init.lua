local P, C = unpack(select(2, ...))

local _VERSION = GetAddOnMetadata(P.Name, "version")
local argcheck = P.argcheck
local print = function(...) print("|cff33ff99P:|r ", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end
local pipesTable = ns.pipesTable
local filtersTable = ns.filtersTable
local displaysTable = ns.displaysTable
local numFilters = 0
local optionCallbacks = {}
local activeFilters = ns.activeFilters

P.version = _VERSION

local function copyTable(initial)
	local endTable = {}
	for k,v in pairs(initial) do
		if v and type(v) == "table" then
			endTable[k] = copyTable(v)
		else
			endTable[k] = v
		end
	end
	return endTable			
end

local defaults = {
	version = _VERSION,
	EnabledPipes = {},
	EnabledFilters = {},
	FontSettings = {
		typeface = "Friz Quadrata TT",
		size = 14,
		align = "TOPLEFT",
		reference = "TOPLEFT",
		offsetx = -1,
		offsety = 3,
		flags = "OUTLINE"
	},
	FilterSettings = {},
	ColorFunc = 4
}

local updateDB = function(db)
	for k,v in pairs(defaults) do
		if not db[k] then
			if type(v) == "table" then
				db[k] = copyTable(v)
			else
				db[k] = v
			end
		end
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == P.Name) then
		if (not PingumaniaItemLevelDB) then
			PingumaniaItemLevelDB = {}
			PingumaniaItemLevelDB = copyTable(defaults)			
			P:SetColorFunc(PingumaniaItemLevelDB.ColorFunc)
			for pipe in next, pipesTable do
				self:EnablePipe(pipe)
				for filter in next, filtersTable do
					self:RegisterFilterOnPipe(pipe, filter)
				end
			end
			self:UpdateAllPipes()
		elseif PingumaniaItemLevelDB and PingumaniaItemLevelDB.version ~= _VERSION then
			updateDB(PingumaniaItemLevelDB)
			PingumaniaItemLevelDB.version = _VERSION
			P:SetColorFunc(PingumaniaItemLevelDB.ColorFunc)
			P:RegisterAllPipesAndFilters()
		else
			P:SetColorFunc(PingumaniaItemLevelDB.ColorFunc)
			P:RegisterAllPipesAndFilters()
		end
		self:UnregisterEvent(event)
	end
	
end

--[[ General API ]]

function P:CallFilters(pipe, frame, ...)
	argcheck(pipe, 2, "string")

	if(not pipesTable[pipe]) then return nil, "Pipe does not exist." end

	local ref = activeFilters[pipe]
	if(ref) then
		for display, filters in next, ref do
			-- TODO: Move this check out of the loop.
			if(not displaysTable[display]) then return nil, "Display does not exist." end

			for i=1,#filters do
				local func = filters[i][2]

				-- drop out of the loop if we actually do something nifty on a frame.
				if(displaysTable[display](frame, func(...))) then break end
			end
		end
	end
end

function P:RegisterAllPipesAndFilters()
	for pipe in next, PingumaniaItemLevelDB.EnabledPipes do
		if PingumaniaItemLevelDB.EnabledPipes[pipe] then
			self:EnablePipe(pipe)
			for filter, enabledPipes in next, PingumaniaItemLevelDB.EnabledFilters do
				if(enabledPipes[pipe]) then
					self:RegisterFilterOnPipe(pipe, filter)
					break
				end
			end
		end
	end
	self:UpdateAllPipes()
end

function P:UpdateAllPipes()
	P:CallOptionCallbacks()
	for pipe, active, name, desc in P.IteratePipes() do
		if(active) then
			P:UpdatePipe(pipe)
		end
	end	
end

function P:RegisterOptionCallback(func)
	argcheck(func, 2, "function")

	table.insert(optionCallbacks, func)
end

function P:CallOptionCallbacks()
	for _, func in next, optionCallbacks do
		func(PingumaniaItemLevelDB)
	end
end

P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)