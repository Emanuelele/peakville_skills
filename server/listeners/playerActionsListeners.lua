RegisterPlayerActionsListener = function()
    lib.callback.register("peakville_skills:purchaseTree", function(source, treeId)
        local valid, error = Validator.validate({id = treeId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid tree id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local tree = Trees[treeId]
        if not tree then return false end

        if player:getCurrentTrees()[treeId] then
            return false
        end

        local tokensPrediction = player:getTokens() - tree:getPrice()
        if tokensPrediction < 0 then
            return false
        end

        local success = player:addTree(treeId)
        if success then
            player:setTokens(tokensPrediction)
            TriggerClientEvent("peakville_skills:treePurchased", source, treeId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:refundTree", function(source, treeId)
        local valid, error = Validator.validate({id = treeId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid tree id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local tree = Trees[treeId]
        if not tree then return false end

        if not player:getCurrentTrees()[treeId] then
            return false
        end

        if not tree:isLeafForPlayer(player) then
            return false
        end

        local success = player:removeTree(treeId)
        if success then
            player:setTokens(player:getTokens() + tree:getRefoundPrice())
            TriggerClientEvent("peakville_skills:treeRefunded", source, treeId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:purchaseSkill", function(source, skillId)
        local valid, error = Validator.validate({id = skillId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid skill id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local skill = Skills[skillId]
        if not skill then return false end

        if player:getSkills()[skillId] then
            return false
        end

        if not skill:isUnlockable(player) then
            return false
        end

        local tokensPrediction = player:getTokens() - skill:getPrice()
        if tokensPrediction < 0 then
            return false
        end

        local success = player:addSkill(skillId)
        if success then
            player:setTokens(tokensPrediction)
            TriggerClientEvent("peakville_skills:skillPurchased", source, skillId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:refundSkill", function(source, skillId)
        local valid, error = Validator.validate({id = skillId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid skill id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local skill = Skills[skillId]
        if not skill then return false end

        if not player:getSkills()[skillId] then
            return false
        end

        if not skill:isLeafForPlayer(player) then
            return false
        end

        local success = player:removeSkill(skillId)
        if success then
            player:setTokens(player:getTokens() + skill:getRefoundPrice())
            TriggerClientEvent("peakville_skills:skillRefunded", source, skillId, player:getTokens())
        end
        return success
    end)

    lib.callback.register("peakville_skills:selectQuest", function(source, questId)
        local valid, error = Validator.validate({id = questId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid quest id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local success = player:selectQuest(questId)
        if success then
            TriggerClientEvent("peakville_skills:questSelected", source, questId)
        end
        return success
    end)

    lib.callback.register("peakville_skills:deselectQuest", function(source, questId)
        local valid, error = Validator.validate({id = questId}, ValidatorSchemas.Id)
        if not valid then
            Logger.Error("Invalid quest id: " .. error)
            return false
        end

        local player = Players[source]
        if not player then return false end

        local success = player:deselectQuest(questId)
        if success then
            TriggerClientEvent("peakville_skills:questDeselected", source, questId)
        end
        return success
    end)
end