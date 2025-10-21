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

CanUnlockQuest = function(player, quest)
    if quest:getHidden() then
        return false
    end

    local skillsReference = quest:getSkillsReference()
    if skillsReference and #skillsReference > 0 then
        for _, skillId in ipairs(skillsReference) do
            if not player:getSkills()[skillId] then
                return false
            end
        end
    end

    local requiredQuests = quest:getRequiredQuests()
    if requiredQuests and #requiredQuests > 0 then
        for _, requiredQuestId in ipairs(requiredQuests) do
            local playerQuest = player:getQuests()[requiredQuestId]
            if not playerQuest or not playerQuest.completed then
                return false
            end
        end
    end

    return true
end

RecalculatePlayerQuests = function(player)
    local currentQuests = player:getQuests()
    local newQuests = {}

    for questId, quest in pairs(Quests) do
        local currentQuestData = currentQuests[questId]

        if currentQuestData then
            if currentQuestData.completed then
                newQuests[questId] = currentQuestData
            elseif currentQuestData.currentStep > 0 then
                if CanUnlockQuest(player, quest) then
                    newQuests[questId] = currentQuestData
                end
            end
        else
            if CanUnlockQuest(player, quest) then
                newQuests[questId] = {
                    questId = questId,
                    completed = false,
                    currentStep = 0
                }
            end
        end
    end

    player:setQuests(newQuests)
end
