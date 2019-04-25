local _, ns = ...
local SyLevel = ns.SyLevel

local _VERSION = GetAddOnMetadata("SyLevel", "version")

local argcheck = SyLevel.argcheck

local print = function(...) print("|cff33ff99SyLevel:|r ", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end

local pipesTable = ns.pipesTable
local filtersTable = ns.filtersTable
local displaysTable = ns.displaysTable

local numFilters = 0

local optionCallbacks = {}
local activeFilters = ns.activeFilters

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
		size = 13,
		align = "BOTTOM",
		reference = "BOTTOM",
		offsetx = 2,
		offsety = 0,
		flags = "OUTLINE"
	},
	FilterSettings = {},
	ColorFunc = 4
}

local function updateDB(db)
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
	if (addon == "PingumaniaItemlevel") then
		if (not SyLevelDB) then
			SyLevelDB = {}
			SyLevelDB = copyTable(defaults)			
			SyLevel:SetColorFunc(SyLevelDB.ColorFunc)
			for pipe in next, pipesTable do
				self:EnablePipe(pipe)
				for filter in next, filtersTable do
					self:RegisterFilterOnPipe(pipe, filter)
				end
			end
			self:UpdateAllPipes()
		elseif SyLevelDB and SyLevelDB.version ~= _VERSION then
			updateDB(SyLevelDB)
			SyLevelDB.version = _VERSION
			SyLevel:SetColorFunc(SyLevelDB.ColorFunc)
			SyLevel:RegisterAllPipesAndFilters()
		else
			SyLevel:SetColorFunc(SyLevelDB.ColorFunc)
			SyLevel:RegisterAllPipesAndFilters()
		end
		self:UnregisterEvent(event)
	end
	
end

--[[ General API ]]

function SyLevel:CallFilters(pipe, frame, ...)
	argcheck(pipe, 2, "string")

	if (not pipesTable[pipe]) then return nil, "Pipe does not exist." end
	
	local ref = activeFilters[pipe]
	-- print(ref)
	if (ref) then
		for display, filters in next, ref do
			-- TODO: Move this check out of the loop.
			if (not displaysTable[display]) then return nil, "Display does not exist." end

			for i=1,#filters do
				local func = filters[i][2]

				-- drop out of the loop if we actually do something nifty on a frame.
				if (displaysTable[display](frame, func(...))) then break end
			end
		end
	end
end

function SyLevel:RegisterAllPipesAndFilters()
	for pipe in next, SyLevelDB.EnabledPipes do
		if SyLevelDB.EnabledPipes[pipe] then
			self:EnablePipe(pipe)
			for filter, enabledPipes in next, SyLevelDB.EnabledFilters do
				if (enabledPipes[pipe]) then
					self:RegisterFilterOnPipe(pipe, filter)
					break
				end
			end
		end
	end
	self:UpdateAllPipes()
end

function SyLevel:UpdateAllPipes()
	SyLevel:CallOptionCallbacks()
	for pipe, active, name, desc in SyLevel.IteratePipes() do
		if (active) then
			SyLevel:UpdatePipe(pipe)
		end
	end	
end

function SyLevel:RegisterOptionCallback(func)
	argcheck(func, 2, "function")

	table.insert(optionCallbacks, func)
end

function SyLevel:CallOptionCallbacks()
	for _, func in next, optionCallbacks do
		func(SyLevelDB)
	end
end

SyLevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)

SyLevel.argcheck = argcheck

SyLevel.version = _VERSION
_G.SyLevel = SyLevel
