ActionsRegistry = {}

ActionsRegistry.Categorieslabels = {
    mechanic = "Meccanico",
    combat = "Combattimento",
    gathering = "Raccolta",
    crafting = "Crafting",
    exploration = "Esplorazione",
    social = "Sociale"
}

ActionsRegistry.Actions = Config.Actions

function ActionsRegistry.ValidateActionParams(actionKey, params)
    local action = ActionsRegistry.Actions[actionKey]
    if not action then return false, "Action not found" end

    if not action.parameters then return true end

    for paramKey, paramConfig in pairs(action.parameters) do
        if paramConfig.required and params[paramKey] == nil then
            return false, "Missing required parameter: " .. paramKey
        end

        if params[paramKey] ~= nil then
            local coerced, coercedValue = TypeCoercion.CoerceValue(params[paramKey], paramConfig.type)

            if not coerced then
                local paramType = type(params[paramKey])
                return false, string.format("Invalid type for %s: expected %s, got %s", 
                    paramKey, paramConfig.type, paramType)
            end

            params[paramKey] = coercedValue
        end
    end

    return true
end

function ActionsRegistry.GetActionsByCategory(category)
    local actions = {}
    for key, action in pairs(ActionsRegistry.Actions) do
        if action.category == category then
            actions[key] = action
        end
    end
    return actions
end

function ActionsRegistry.GetAllCategories()
    local categories = {}
    for _, action in pairs(ActionsRegistry.Actions) do
        categories[action.category] = true
    end
    local categoryList = {}
    for category, _ in pairs(categories) do
        table.insert(categoryList, ActionsRegistry.Categorieslabels[category] or category)
    end
    return categoryList
end
