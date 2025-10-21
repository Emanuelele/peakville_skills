--to-do: recupera info dal DB e costruisce la tabella playerData.
--n.b: restituisce anche se il player va inizializzato(nessun player data presente)
GetPlayerData = function(identifier)
    return nil, nil
end

--to-do
SavePlayerData = function(player)
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
