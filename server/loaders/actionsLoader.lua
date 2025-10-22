RegisterActionsLoader = function()
    exports("PerformAction", function(source, actionKey, actionParams, count)
        local player = Players[tostring(source)]
        if not player then
            return
        end

        local valid, error = ActionsRegistry.ValidateActionParams(actionKey, actionParams or {})
        if not valid then
            Logger.Error("Invalid action params from source " .. source .. ": " .. error)
            return
        end

        local action = ActionsRegistry.Actions[actionKey]
        if not action then
            Logger.Error("Unknown action from source " .. source .. ": " .. actionKey)
            return
        end

        local processedQuests = ActionProcessor.ProcessActionForPlayer(
            player, actionKey, actionParams or {}, count or 1
        )

        if Config.Debug and #processedQuests > 0 then
            Logger.Info(string.format("Player %s performed action %s, affected %d quests", 
                player:getIdentifier(), actionKey, #processedQuests))
        end

        return processedQuests
    end)


    RegisterNetEvent("peakville_skills:processAction", function(actionKey, actionParams, count)
        local source = source

        if type(actionKey) ~= "string" or type(count) ~= "number" or count < 1 then
            Logger.Warning("Invalid action data from source " .. source)
            return
        end

        count = math.min(count, Config.MaxActionBatchSize or 1000)

        exports["peakville_skills"]:PerformAction(source, actionKey, actionParams, count)
    end)

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        ActionProcessor.ClearPlayerBatches(src)
    end)
end