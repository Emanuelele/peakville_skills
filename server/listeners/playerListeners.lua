RegisterPlayerListener = function()
    RegisterNetEvent("esx:onPlayerSpawn", function()
        local src = source

        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then
            DropPlayer(src, "Errore inizializzazione skills")
        end

        local playerData = GetPlayerData(xPlayer.identifier)
        local player = Player:new(xPlayer, playerData)

        player:setQuests(RecalculatePlayerQuests(player))
        player:save()

        Players[src] = player

        TriggerClientEvent("peakville_skills:init", src, player:serialize())
    end)

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        local player = Players[src]
        if not player then
            return
        end

        Players[src] = player:saveAndDestroy()
    end)
end
