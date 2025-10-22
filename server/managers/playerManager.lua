GetPlayerData = function(identifier)
    local result = MySQL.single.await('SELECT * FROM players WHERE identifier = ?', { identifier })

    if not result then
        return nil
    end

    local playerData = {
        level = result.level,
        XP = result.XP,
        tokens = result.tokens,
        maxActiveQuests = result.maxActiveQuests,
        activeQuests = json.decode(result.activeQuests) or {},
        currentTrees = json.decode(result.currentTrees) or {},
        quests = json.decode(result.quests) or {},
        skills = json.decode(result.skills) or {}
    }

    return playerData
end

SavePlayerData = function(player)
    local data = player:serialize()

    MySQL.query.await([[
    INSERT INTO players (identifier, level, XP, tokens, maxActiveQuests, activeQuests, currentTrees, quests, skills)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
        level = VALUES(level),
        XP = VALUES(XP),
        tokens = VALUES(tokens),
        maxActiveQuests = VALUES(maxActiveQuests),
        activeQuests = VALUES(activeQuests),
        currentTrees = VALUES(currentTrees),
        quests = VALUES(quests),
        skills = VALUES(skills)
    ]], {
        data.identifier,
        data.level,
        data.XP,
        data.tokens,
        data.maxActiveQuests,
        json.encode(data.activeQuests),
        json.encode(data.currentTrees),
        json.encode(data.quests),
        json.encode(data.skills)
    })
end

SaveAllPlayers = function(serverStop)
    if next(Players) == nil then
        return
    end

    local queries = {}

    for _, player in pairs(Players) do
        local data = player:serialize()
        table.insert(queries, {
            query = [[
                INSERT INTO players (identifier, level, XP, tokens, maxActiveQuests, activeQuests, currentTrees, quests, skills)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    level = VALUES(level),
                    XP = VALUES(XP),
                    tokens = VALUES(tokens),
                    maxActiveQuests = VALUES(maxActiveQuests),
                    activeQuests = VALUES(activeQuests),
                    currentTrees = VALUES(currentTrees),
                    quests = VALUES(quests),
                    skills = VALUES(skills)
            ]],
            values = {
                data.identifier,
                data.level,
                data.XP,
                data.tokens,
                data.maxActiveQuests,
                json.encode(data.activeQuests),
                json.encode(data.currentTrees),
                json.encode(data.quests),
                json.encode(data.skills)
            }
        })
    end

    if serverStop then
        MySQL.execute(queries)
    else
        MySQL.prepare(queries)
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
