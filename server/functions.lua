OnStop = function(func, onlyOnServerStop, onlyOnResourceStop)
    if not onlyOnResourceStop then
        RegisterNetEvent("txAdmin:events:serverShuttingDown", function()
            if type(func) == "function" then
                func()
            end
        end)
    end

    if not onlyOnServerStop then
        RegisterNetEvent("onResourceStop", function(resourceName)
            if resourceName == "peakville_skills" and type(func) == "function" then
                func()
            end
        end)
    end
end

local idCounter = GetResourceKvpInt("skills_id_gen") or 0
GenerateNewId = function()
    idCounter = idCounter + 1

    if idCounter % Config.SaveThresholdIds == 0 then
        SetResourceKvpInt("skills_id_gen", idCounter)
    end

    return idCounter
end
OnStop(function() SetResourceKvpInt("skills_id_gen", idCounter) end)

SourceIsStaffer = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer and xPlayer.getGroup() ~= "user"
end

SerializeTrees = function()
    local serializedTrees = {}
    for treeId, tree in pairs(Trees) do
        serializedTrees[treeId] = tree:serialize()
    end
    return serializedTrees
end

SerializeSkills = function()
    local serializedSkills = {}
    for skillId, skill in pairs(Skills) do
        serializedSkills[skillId] = skill:serialize()
    end
    return serializedSkills
end

SerializePlayerQuests = function(playerQuests)
    local serializedQuests = {}
    for questId, playerQuest in pairs(playerQuests) do
        local quest = playerQuest:getQuest()
        serializedQuests[questId] = {
            quest = quest:serialize(),
            completed = playerQuest:isCompleted(),
            currentStep = playerQuest:getCurrentStep()
        }
    end
    return serializedQuests
end

LoadPlayer = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or Players[src] then
        DropPlayer(src, "Errore inizializzazione skills")
    end

    local playerData = GetPlayerData(xPlayer.identifier)
    local player = Player:new(xPlayer, playerData)

    if playerData?.quests then
        ---@diagnostic disable-next-line: need-check-nil
        player:setQuests(DeserializePlayerQuests(playerData.quests, player))
    end

    player:recalculatePlayerQuests(true)
    player:save()

    Players[src] = player

    local initData = {
        player = player:serialize(),
        trees = SerializeTrees(),
        skills = SerializeSkills(),
        quests = SerializePlayerQuests(player:getQuests())
    }

    TriggerClientEvent("peakville_skills:init", src, initData)
end
