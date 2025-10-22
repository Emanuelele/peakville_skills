--[[
    ESEMPI DI INTEGRAZIONE PER SCRIPT ESTERNI
    Questi sono esempi pratici di come integrare il sistema di azioni
    nei tuoi script esistenti
]]

-- ============================================
-- ESEMPIO 1: MECCANICO - Cambio parti veicolo
-- ============================================

-- Nel tuo script meccanico, quando un giocatore completa una riparazione:
function OnPartChanged(partType, vehicleModel)
    -- Triggera l'azione dal client
    exports["peakville_skills"]:PerformAction("vehicle_part_change", {
        part_type = partType,      -- es: "engine", "transmission", "brakes"
        vehicle_model = vehicleModel -- es: "zentorno", "adder" (opzionale)
    })
end

-- Esempio concreto
RegisterCommand("fixengine", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        -- Il tuo codice per riparare il motore...
        SetVehicleEngineHealth(vehicle, 1000.0)
        
        -- Notifica il sistema skills
        exports["peakville_skills"]:PerformAction("vehicle_part_change", {
            part_type = "engine",
            vehicle_model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        })
    end
end, false)

-- ============================================
-- ESEMPIO 2: COMBATTIMENTO - Spari con batching
-- ============================================

-- Sistema ottimizzato per contare i proiettili sparati
local bulletsFired = 0
local lastWeaponUsed = nil

-- Event quando il giocatore spara
AddEventHandler('CEventGunShot', function(witnesses, ped)
    if ped == PlayerPedId() then
        local weapon = GetSelectedPedWeapon(ped)
        local weaponGroup = GetWeapontypeGroup(weapon)
        
        -- Converti il gruppo weapon in stringa leggibile
        local groupName = "other"
        if weaponGroup == `GROUP_PISTOL` then
            groupName = "pistol"
        elseif weaponGroup == `GROUP_SMG` then
            groupName = "smg"
        elseif weaponGroup == `GROUP_RIFLE` then
            groupName = "rifle"
        elseif weaponGroup == `GROUP_SNIPER` then
            groupName = "sniper"
        end
        
        -- Il sistema gestirà automaticamente il batching
        exports["peakville_skills"]:PerformAction("weapon_fire", {
            weapon_group = groupName,
            weapon_type = GetWeaponName(weapon)
        }, 1) -- Count 1 per proiettile
    end
end)

-- ============================================
-- ESEMPIO 3: RACCOLTA - Item harvest con zone
-- ============================================

-- Nel tuo script di farming/raccolta
function HarvestItem(itemType, amount, zone)
    -- Il tuo codice per dare l'item al player...
    
    -- Notifica il sistema skills (con batching automatico)
    exports["peakville_skills"]:PerformAction("item_harvest", {
        item_type = itemType, -- es: "apple", "orange", "iron_ore"
        zone = zone          -- es: "farm_1", "mine_north" (opzionale)
    }, amount)
end

-- Esempio di raccolta mele
RegisterCommand("harvest", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)
    
    -- Simula raccolta di 5 mele
    HarvestItem("apple", 5, zone)
end, false)

-- ============================================
-- ESEMPIO 4: SERVER SIDE - Transazioni economiche
-- ============================================

-- Nel tuo script economia (server side)
RegisterServerEvent("myshop:purchase")
AddEventHandler("myshop:purchase", function(itemPrice)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Il tuo codice per la transazione...
    
    -- Notifica il sistema skills dal server
    exports["peakville_skills"]:PerformAction(source, "money_earn", {
        source_type = "shop_sale",
        minimum_amount = itemPrice
    }, itemPrice)
end)

-- ============================================
-- ESEMPIO 5: OTTIMIZZAZIONE - Verifica rilevanza
-- ============================================

-- Prima di eseguire codice costoso, verifica se l'azione è rilevante
CreateThread(function()
    while true do
        Wait(1000)
        
        -- Verifica se vale la pena trackare i proiettili
        if exports["peakville_skills"]:IsActionRelevant("weapon_fire") then
            -- Attiva il tracking dei proiettili
            EnableBulletTracking()
        else
            -- Disattiva per risparmiare risorse
            DisableBulletTracking()
        end
    end
end)

-- ============================================
-- ESEMPIO 6: QUEST COMPLESSE - Uccisioni con headshot
-- ============================================

-- Tracking delle uccisioni (client o server)
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isDead = args[6] == 1
        
        if isDead and attacker == PlayerPedId() and IsPedAPlayer(victim) then
            local weapon = GetSelectedPedWeapon(attacker)
            local headshot = GetPedLastDamageBone(victim) == 31086
            
            exports["peakville_skills"]:PerformAction("player_kill", {
                weapon_used = GetWeaponName(weapon),
                headshot = headshot
            })
        end
    end
end)

-- ============================================
-- CONFIGURAZIONI QUEST ESEMPI (da inserire nel DB)
-- ============================================

--[[
Quest: "Cecchino Elite"
actionConfig: {
    "action": "player_kill",
    "conditions": {
        "headshot": true,
        "weapon_used": ["weapon_sniperrifle", "weapon_heavysniper"]
    }
}

Quest: "Commerciante Ricco"
actionConfig: {
    "action": "money_earn",
    "conditions": {
        "source_type": ["shop_sale", "business_income"]
    },
    "count_multiplier": 0.001  -- 1000$ = 1 step
}

Quest: "Minatore Esperto"
actionConfig: {
    "action": "item_harvest",
    "conditions": {
        "item_type": ["iron_ore", "gold_ore", "diamond"],
        "zone": ["mine_north", "mine_south"]
    },
    "max_per_action": 10  -- Max 10 step per singola azione
}
]]

