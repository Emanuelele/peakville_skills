RegisterPlayerListener = function()
    RegisterNetEvent("esx:onPlayerSpawn", function()
        local src = source

        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer or Players[src] then
            DropPlayer(src, "Errore inizializzazione skills")
        end

        local playerData = GetPlayerData(xPlayer.identifier)
        local player = Player:new(xPlayer, playerData)

        if playerData?.quests then
            player:setQuests(DeserializePlayerQuests(playerData.quests, player))
        end

        player:recalculatePlayerQuests()
        player:save()

        Players[src] = player

        local initData = {
            player = player:serialize(),
            trees = SerializeTrees(),
            skills = SerializeSkills(),
            quests = SerializePlayerQuests(player:getQuests())
        }

        TriggerClientEvent("peakville_skills:init", src, initData)
    end)

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        local player = Players[src]
        if not player then
            return
        end

        Players[src] = player:saveAndDestroy()
    end)
end
