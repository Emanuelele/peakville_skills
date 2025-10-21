--n.b: restituisce anche se il player va inizializzato (nessun player data presente)
GetPlayerData = function(identifier)
    local result = MySQL.single.await('SELECT * FROM players WHERE identifier = ?', {identifier})

    if not result then
        return nil, true
    end

    local playerData = {
        level = result.level,
        XP = result.XP,
        tokens = result.tokens,
        currentTrees = json.decode(result.currentTrees) or {},
        quests = json.decode(result.quests) or {},
        skills = json.decode(result.skills) or {}
    }

    return playerData, false
end

SavePlayerData = function(player)
    local data = player:serialize()

    MySQL.update.await([[
        UPDATE players 
        SET level = ?, XP = ?, tokens = ?, currentTrees = ?, quests = ?, skills = ?
        WHERE identifier = ?
    ]], {
        data.level,
        data.XP,
        data.tokens,
        json.encode(data.currentTrees),
        json.encode(data.quests),
        json.encode(data.skills),
        data.identifier
    })
end

SaveAllPlayers = function()
    for _, player in pairs(Players) do
        player:save()
    end
end

--to-do: inizializza tutti i dati del player (quest ecc) in base agli alberi scelti
--inserisce nel db le quest giornaliere, tematiche e generali per il player
InitPlayerData = function(xPlayer, trees)
end
