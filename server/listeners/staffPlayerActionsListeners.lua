RegisterStaffPlayerActionsListener = function()
    lib.callback.register("peakville_skills:getOnlinePlayers", function(source)
        if not SourceIsStaffer(source) then return false end

        local onlinePlayers = {}
        for _, src in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(tonumber(src))
            if xPlayer then
                onlinePlayers[src] = {
                    source = tonumber(src),
                    identifier = xPlayer.identifier,
                    name = xPlayer.getName()
                }
            end
        end
        return onlinePlayers
    end)

    lib.callback.register("peakville_skills:getPlayerData", function(source, targetSource)
        if not SourceIsStaffer(source) then return false end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        return {
            level = player:getLevel(),
            XP = player:getXP(),
            tokens = player:getTokens(),
            currentTrees = player:getCurrentTrees(),
            skills = player:getSkills(),
            maxActiveQuests = player:getMaxActiveQuests(),
            activeQuests = player:getActiveQuests(),
            quests = SerializePlayerQuests(player:getQuests())
        }
    end)

    lib.callback.register("peakville_skills:addPlayerSkill", function(source, targetSource, skillId)
        if not SourceIsStaffer(source) then return false end

        local validSkill, err = Validator.validate({ id = tostring(skillId) }, ValidatorSchemas.Id)
        if not validSkill then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local skill = Skills[skillId]
        if not skill or player:getSkills()[skillId] then return false end

        local success = player:addSkill(skillId)
        if success then
            TriggerClientEvent("peakville_skills:skillPurchased", targetSource, skillId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:removePlayerSkill", function(source, targetSource, skillId)
        if not SourceIsStaffer(source) then return false end

        local validSkill, err = Validator.validate({ id = tostring(skillId) }, ValidatorSchemas.Id)
        if not validSkill then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player or not player:getSkills()[skillId] then return false end

        local success = player:removeSkill(skillId)
        if success then
            TriggerClientEvent("peakville_skills:skillRefunded", targetSource, skillId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:addPlayerTree", function(source, targetSource, treeId)
        if not SourceIsStaffer(source) then return false end

        local validTree, err = Validator.validate({ id = tostring(treeId) }, ValidatorSchemas.Id)
        if not validTree then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local tree = Trees[treeId]
        if not tree or player:getCurrentTrees()[treeId] then return false end

        local success = player:addTree(treeId)
        if success then
            TriggerClientEvent("peakville_skills:treePurchased", targetSource, treeId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:removePlayerTree", function(source, targetSource, treeId)
        if not SourceIsStaffer(source) then return false end

        local validTree, err = Validator.validate({ id = tostring(treeId) }, ValidatorSchemas.Id)
        if not validTree then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player or not player:getCurrentTrees()[treeId] then return false end

        local success = player:removeTree(treeId)
        if success then
            TriggerClientEvent("peakville_skills:treeRefunded", targetSource, treeId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:setPlayerXP", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        player:setXP(math.min(amount, Config.MaxXP))
        TriggerClientEvent("peakville_skills:xpAdded", targetSource, player:getXP())
        return true
    end)

    lib.callback.register("peakville_skills:addPlayerXP", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        player:addExperience(amount)
        return true
    end)

    lib.callback.register("peakville_skills:removePlayerXP", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local newXP = math.max(0, player:getXP() - amount)
        player:setXP(newXP)
        TriggerClientEvent("peakville_skills:xpAdded", targetSource, player:getXP())
        return true
    end)

    lib.callback.register("peakville_skills:setPlayerTokens", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        player:setTokens(amount)
        TriggerClientEvent("peakville_skills:tokensUpdated", targetSource, player:getTokens())
        return true
    end)

    lib.callback.register("peakville_skills:addPlayerTokens", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        player:setTokens(player:getTokens() + amount)
        TriggerClientEvent("peakville_skills:tokensUpdated", targetSource, player:getTokens())
        return true
    end)

    lib.callback.register("peakville_skills:removePlayerTokens", function(source, targetSource, amount)
        if not SourceIsStaffer(source) then return false end

        amount = tonumber(amount)
        if not amount then return false end

        local validAmount, err = Validator.validate({ value = amount }, ValidatorSchemas.Number)
        if not validAmount then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local newTokens = math.max(0, player:getTokens() - amount)
        player:setTokens(newTokens)
        TriggerClientEvent("peakville_skills:tokensUpdated", targetSource, player:getTokens())
        return true
    end)

    lib.callback.register("peakville_skills:setPlayerLevel", function(source, targetSource, level)
        if not SourceIsStaffer(source) then return false end

        level = tonumber(level)
        if not level or level < 1 or level > Config.MaxLevel then return false end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        player:setLevel(level)
        TriggerClientEvent("peakville_skills:newLevelReached", targetSource, player:getLevel(), player:getXP(), player:getTokens())
        return true
    end)

    lib.callback.register("peakville_skills:setPlayerQuestSteps", function(source, targetSource, questId, steps)
        if not SourceIsStaffer(source) then return false end

        local validQuest, err = Validator.validate({ id = tostring(questId) }, ValidatorSchemas.Id)
        if not validQuest then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        steps = tonumber(steps)
        if not steps or steps < 0 then return false end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local playerQuest = player:getQuests()[questId]
        if not playerQuest then return false end

        local quest = playerQuest:getQuest()
        playerQuest.currentStep = math.min(steps, quest:getSteps())

        if playerQuest.currentStep >= quest:getSteps() then
            playerQuest:complete()
        else
            TriggerClientEvent("peakville_skills:questStepUpdated", targetSource, questId, playerQuest.currentStep)
        end

        return true
    end)

    lib.callback.register("peakville_skills:completePlayerQuest", function(source, targetSource, questId)
        if not SourceIsStaffer(source) then return false end

        local validQuest, err = Validator.validate({ id = tostring(questId) }, ValidatorSchemas.Id)
        if not validQuest then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local playerQuest = player:getQuests()[questId]
        if not playerQuest then return false end

        playerQuest:complete()
        return true
    end)

    lib.callback.register("peakville_skills:uncompletePlayerQuest", function(source, targetSource, questId)
        if not SourceIsStaffer(source) then return false end

        local validQuest, err = Validator.validate({ id = tostring(questId) }, ValidatorSchemas.Id)
        if not validQuest then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local playerQuest = player:getQuests()[questId]
        if not playerQuest or not playerQuest:isCompleted() then return false end

        playerQuest.completed = false
        playerQuest.currentStep = 0
        TriggerClientEvent("peakville_skills:questStepUpdated", targetSource, questId, 0)
        return true
    end)

    lib.callback.register("peakville_skills:assignHiddenQuest", function(source, targetSource, questId)
        if not SourceIsStaffer(source) then return false end

        local validQuest, err = Validator.validate({ id = tostring(questId) }, ValidatorSchemas.Id)
        if not validQuest then
            Logger.Error("Invalid params: " .. err)
            return false
        end

        local player = Players[tostring(targetSource)]
        if not player then return false end

        local quest = Quests[questId]
        if not quest or not quest:getHidden() then return false end

        if player:hasQuestInPool(quest) then return false end

        player.quests[questId] = PlayerQuest:new(quest, player)
        TriggerClientEvent("peakville_skills:questsRecalculated", targetSource, SerializePlayerQuests(player:getQuests()))
        return true
    end)
end
