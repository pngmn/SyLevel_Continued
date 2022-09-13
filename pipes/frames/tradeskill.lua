
local _E
local hook
local selectedRecipeID

local function pipe(self)
	local recipeID = self.RecipeList:GetSelectedRecipeID()
	selectedRecipeID = recipeID and recipeID or nil
	if not selectedRecipeID then return end

	local itemLink = C_TradeSkillUI.GetRecipeItemLink(selectedRecipeID)
	if itemLink then
        PingumaniaItemlevel:CallFilters("tradeskill", TradeSkillFrame.DetailsFrame.Contents.ResultIcon, _E and itemLink)
	end

	local numReagents = C_TradeSkillUI.GetRecipeNumReagents(selectedRecipeID)
	for reagentIndex = 1, numReagents do
		local reagentFrame = TradeSkillFrame.DetailsFrame.Contents.Reagents[reagentIndex]
		local reagentLink = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipeID, reagentIndex)

        PingumaniaItemlevel:CallFilters("tradeskill", reagentFrame, _E and reagentLink)
	end
end

local function doHook()
	if (not hook) then
		hook = function(...)
			if (_E) then return pipe(...) end
		end

		hooksecurefunc(TradeSkillFrame, "OnRecipeChanged", hook)
	end
end

local function ADDON_LOADED(self, event, addon)
	if (addon == "Blizzard_TradeSkillUI") then
		doHook()
		PingumaniaItemlevel:UnregisterEvent(event, ADDON_LOADED)
	end
end

local function update(self)
	if (selectedRecipeID) then
		return pipe(self, selectedRecipeID)
	end
end

local function enable(self)
	_E = true

	if (IsAddOnLoaded("Blizzard_TradeSkillUI")) then
		doHook()
	else
		PingumaniaItemlevel:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local function disable(self)
	_E = nil

	PingumaniaItemlevel:UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
end

PingumaniaItemlevel:RegisterPipe("tradeskill", enable, disable, update, "Profession Window", nil)