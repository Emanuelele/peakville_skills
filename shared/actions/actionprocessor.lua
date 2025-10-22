ActionProcessor = {}

function ActionProcessor.MatchesQuestRequirements(actionParams, questActionConfig)
    if not questActionConfig or not questActionConfig.conditions then
        return true
    end

    for condKey, condValue in pairs(questActionConfig.conditions) do
        local paramValue = actionParams[condKey]

        if type(condValue) == "table" then
            local found = false
            for _, acceptedValue in ipairs(condValue) do
                if paramValue == acceptedValue then
                    found = true
                    break
                end
            end
            if not found then return false end
        elseif paramValue ~= condValue then
            return false
        end
    end

    return true
end

if IsDuplicityVersion() then
    function ActionProcessor.ProcessActionForPlayer(player, actionKey, actionParams, count)
        count = count or 1
        local processedQuests = {}

        for questId, _ in pairs(player:getActiveQuests()) do
            local playerQuest = player:getQuests()[questId]

            if playerQuest and not playerQuest:isCompleted() then
                local quest = playerQuest:getQuest()
                local actionConfig = quest:getActionConfig()

                if actionConfig and actionConfig.action == actionKey then

                    if ActionProcessor.MatchesQuestRequirements(actionParams, actionConfig) then

                        local stepsToAdd = count

                        if actionConfig.count_multiplier then
                            stepsToAdd = math.floor(count * actionConfig.count_multiplier)
                        end

                        if actionConfig.max_per_action then
                            stepsToAdd = math.min(stepsToAdd, actionConfig.max_per_action)
                        end

                        if stepsToAdd > 0 then
                            playerQuest:nextSteps(stepsToAdd)
                            table.insert(processedQuests, {
                                questId = questId,
                                steps = stepsToAdd
                            })
                        end
                    end
                end
            end
        end
        return processedQuests
    end
end


ActionProcessor.BatchedActions = {}

function ActionProcessor.BatchAction(playerId, actionKey, actionParams, count)
    count = count or 1

    if not ActionProcessor.BatchedActions[playerId] then
        ActionProcessor.BatchedActions[playerId] = {}
    end

    local batchKey = actionKey .. ":" .. json.encode(actionParams)

    if not ActionProcessor.BatchedActions[playerId][batchKey] then
        ActionProcessor.BatchedActions[playerId][batchKey] = {
            action = actionKey,
            params = actionParams,
            count = 0,
            timer = nil
        }
    end

    local batch = ActionProcessor.BatchedActions[playerId][batchKey]
    batch.count = batch.count + count

    if batch.timer then
        Citizen.Cleartimeout(batch.timer)
    end

    batch.timer = SetTimeout(Config.ActionBatchDelay or 1000, function()
        if ActionProcessor.BatchedActions[playerId] and 
           ActionProcessor.BatchedActions[playerId][batchKey] then

            local finalBatch = ActionProcessor.BatchedActions[playerId][batchKey]

            if finalBatch.count > 0 then
                if IsDuplicityVersion() then
                    local player = Players[playerId]
                    if player then
                        ActionProcessor.ProcessActionForPlayer(player, finalBatch.action, finalBatch.params, finalBatch.count)
                    end
                else
                    TriggerServerEvent("peakville_skills:processAction", finalBatch.action, finalBatch.params, finalBatch.count)
                end
            end

            ActionProcessor.BatchedActions[playerId][batchKey] = nil

            if next(ActionProcessor.BatchedActions[playerId]) == nil then
                ActionProcessor.BatchedActions[playerId] = nil
            end
        end
    end)
end

function ActionProcessor.ClearPlayerBatches(playerId)
    if ActionProcessor.BatchedActions[playerId] then
        for _, batch in pairs(ActionProcessor.BatchedActions[playerId]) do
            if batch.timer then
                Citizen.Cleartimeout(batch.timer)
            end
        end
        ActionProcessor.BatchedActions[playerId] = nil
    end
end

