ActionsRegistry = {}

ActionsRegistry.Categorieslabels = {
    mechanic = "Meccanico",
    combat = "Combattimento",
    gathering = "Raccolta",
    crafting = "Crafting",
    exploration = "Esplorazione",
    social = "Sociale"
}

ActionsRegistry.Actions = {
    --Esempi di configurazione di azioni
    --[[ ["vehicle_part_change"] = {
        label = "Cambio Parte Veicolo",
        category = "mechanic",
        parameters = {
            part_type = { type = "string", required = true },
            vehicle_model = { type = "string", required = false }
        }
    },
    ["vehicle_repair"] = {
        label = "Riparazione Veicolo", 
        category = "mechanic",
        parameters = {
            damage_threshold = { type = "number", required = false }
        }
    },
    ["weapon_fire"] = {
        label = "Spara Arma",
        category = "combat",
        parameters = {
            weapon_type = { type = "string", required = false },
            weapon_group = { type = "string", required = false }
        },
        batched = true -- Indica che questa azione può essere inviata in batch
    },
    ["player_kill"] = {
        label = "Uccisione Giocatore",
        category = "combat",
        parameters = {
            weapon_used = { type = "string", required = false },
            headshot = { type = "boolean", required = false }
        }
    },
    ["item_harvest"] = {
        label = "Raccolta Oggetto",
        category = "gathering",
        parameters = {
            item_type = { type = "string", required = true },
            zone = { type = "string", required = false }
        },
        batched = true
    },
    ["item_craft"] = {
        label = "Crafting Oggetto",
        category = "crafting",
        parameters = {
            item_name = { type = "string", required = true },
            quality = { type = "string", required = false }
        }
    },
    ["zone_enter"] = {
        label = "Entra in Zona",
        category = "exploration",
        parameters = {
            zone_name = { type = "string", required = true }
        }
    },
    ["npc_interact"] = {
        label = "Interazione NPC",
        category = "social",
        parameters = {
            npc_id = { type = "string", required = true },
            interaction_type = { type = "string", required = false }
        }
    }, ]]
}

function ActionsRegistry.ValidateActionParams(actionKey, params)
    local action = ActionsRegistry.Actions[actionKey]
    if not action then return false, "Action not found" end

    if not action.parameters then return true end

    for paramKey, paramConfig in pairs(action.parameters) do
        if paramConfig.required and params[paramKey] == nil then
            return false, "Missing required parameter: " .. paramKey
        end

        if params[paramKey] ~= nil then
            local paramType = type(params[paramKey])
            if paramType ~= paramConfig.type then
                return false, string.format("Invalid type for %s: expected %s, got %s", 
                    paramKey, paramConfig.type, paramType)
            end
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
