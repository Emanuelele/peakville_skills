Config = {}

Config.Debug = true
Config.StartTokens = 10
Config.SaveThresholdIds = 10
Config.SavePlayersTime = 60000
Config.MaxLevel = 50
Config.MaxXP = 10000 --Xp massimo dell'ultimo livello
Config.DefaultMaxActiveQuests = 3
Config.ActionBatchDelay = 3000
Config.MaxActionBatchSize = 1000

Config.Actions = {
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