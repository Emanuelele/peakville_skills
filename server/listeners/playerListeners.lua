RegisterPlayerListener = function()
    RegisterNetEvent("esx:onPlayerSpawn", function()
        local src = source

        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then
            DropPlayer(src, "Errore inizializzazione skills")
        end

        local playerData, toInit = GetPlayerData(xPlayer.identifier)
        if toInit then
            TriggerClientEvent("peakville_skills:firstInit", src)
        end
        local player = Player:new(xPlayer, playerData)

        Players[src] = player

        TriggerClientEvent("peakville_skills:init", src, player:GetPlayerDataSerialized())
    end)

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        local player = Players[src]
        if not player then
            return
        end

        Players[src] = player:saveAndDestroy()
    end)

    RegisterNetEvent("peakville_skills:firstInitCompleted", function(trees)
        local src = source

        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then
            DropPlayer(src, "Errore inizializzazione skills")
        end

        InitPlayerData(xPlayer, trees)

        local playerData, _ = GetPlayerData(xPlayer.identifier)
        local player = Player:new(xPlayer, playerData)

        Players[src] = player

        TriggerClientEvent("peakville_skills:init", src, player:GetPlayerDataSerialized())
    end)
end
