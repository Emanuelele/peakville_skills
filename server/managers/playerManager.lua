GetPlayerData = function(identifier)
    local result = MySQL.single.await('SELECT * FROM players WHERE identifier = ?', { identifier })

    if not result then
        return nil
    end

    local playerData = {
        level = result.level,
        XP = result.XP,
        tokens = result.tokens,
        currentTrees = json.decode(result.currentTrees) or {},
        quests = json.decode(result.quests) or {},
        skills = json.decode(result.skills) or {}
    }

    return playerData
end

SavePlayerData = function(player)
    local data = player:serialize()

    MySQL.query.await([[
    INSERT INTO players (identifier, level, XP, tokens, currentTrees, quests, skills)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
        level = VALUES(level),
        XP = VALUES(XP),
        tokens = VALUES(tokens),
        currentTrees = VALUES(currentTrees),
        quests = VALUES(quests),
        skills = VALUES(skills)
    ]], {
        data.identifier,
        data.level,
        data.XP,
        data.tokens,
        json.encode(data.currentTrees),
        json.encode(data.quests),
        json.encode(data.skills)
    })
end

SaveAllPlayers = function()
    for _, player in pairs(Players) do
        player:save()
    end
end

DeserializePlayerQuests = function(serializedQuests, player)
    local quests = {}
    for questId, questData in pairs(serializedQuests) do
        local playerQuest = PlayerQuest.deserialize(questData, player)
        if playerQuest then
            quests[questId] = playerQuest
        end
    end
    return quests
end
