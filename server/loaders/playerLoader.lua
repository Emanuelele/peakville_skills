RegisterPlayerLoader = function()
    RegisterNetEvent("esx:onPlayerSpawn", function()
        local src = source
        LoadPlayer(src)
    end)

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        local player = Players[src]
        if not player then
            return
        end

        player:save()

        Players[src] = nil
    end)
end
