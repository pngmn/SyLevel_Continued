local P, C = unpack(select(2, ...))
if C["EnableTradeskill"] ~= true then return end

local selectedRecipeID

local function pipe(self)
	local recipeID = self.RecipeList:GetSelectedRecipeID()
	selectedRecipeID = recipeID and recipeID or nil
	if not selectedRecipeID then return end

	local itemLink = C_TradeSkillUI.GetRecipeItemLink(selectedRecipeID)
	if itemLink then
        P:TextDisplay(TradeSkillFrame.DetailsFrame.Contents.ResultIcon, itemLink)
	end

	local numReagents = C_TradeSkillUI.GetRecipeNumReagents(selectedRecipeID)
	for reagentIndex = 1, numReagents do
		local reagentFrame = TradeSkillFrame.DetailsFrame.Contents.Reagents[reagentIndex]
		local reagentLink = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipeID, reagentIndex)

        P:TextDisplay(reagentFrame, reagentLink)
	end
end

local function ADDON_LOADED(self, event, addon)
	if addon == "Blizzard_TradeSkillUI" then
		hooksecurefunc(TradeSkillFrame, "OnRecipeChanged", pipe)
		P:UnregisterEvent(event, ADDON_LOADED)
	end
end

if IsAddOnLoaded("Blizzard_TradeSkillUI") then
    hooksecurefunc(TradeSkillFrame, "OnRecipeChanged", pipe)
else
    P:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end