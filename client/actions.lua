local ActionBatcher = {}

exports("PerformAction", function(actionKey, actionParams, count)
    WaitPlayerLoaded()

    local valid, error = ActionsRegistry.ValidateActionParams(actionKey, actionParams or {})
    if not valid then
        if Config.Debug then
            print("^1[Skills] Invalid action params: " .. error)
        end
        return false
    end

    local action = ActionsRegistry.Actions[actionKey]
    if not action then
        if Config.Debug then
            print("^1[Skills] Unknown action: " .. actionKey)
        end
        return false
    end

    if action.batched then
        ActionBatcher:Add(actionKey, actionParams or {}, count or 1)
    else
        TriggerServerEvent("peakville_skills:processAction", actionKey, actionParams or {}, count or 1)
    end

    return true
end)

function ActionBatcher:Add(actionKey, params, count)
    local batchKey = actionKey .. ":" .. json.encode(params)

    if not self.batches then
        self.batches = {}
    end

    if not self.batches[batchKey] then
        self.batches[batchKey] = {
            action = actionKey,
            params = params,
            count = 0,
            timer = nil
        }
    end

    local batch = self.batches[batchKey]
    batch.count = batch.count + count

    if batch.timer then
        Citizen.Cleartimeout(batch.timer)
    end

    batch.timer = SetTimeout(Config.ActionBatchDelay or 1000, function()
        if self.batches[batchKey] and self.batches[batchKey].count > 0 then

            TriggerServerEvent("peakville_skills:processAction",
                self.batches[batchKey].action,
                self.batches[batchKey].params,
                self.batches[batchKey].count
            )

            self.batches[batchKey] = nil
        end
    end)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if ActionBatcher?.batches then
            for _, batch in pairs(ActionBatcher.batches) do
                if batch.count > 0 then
                    TriggerServerEvent("peakville_skills:processAction", batch.action, batch.params, batch.count)
                end
            end
        end
    end
end)

function IsActionRelevantForActiveQuests(actionKey)
    for questId, _ in pairs(ClientData.player.activeQuests) do
        local quest = ClientData.quests[questId]
        if quest and quest.actionConfig and quest.actionConfig.action == actionKey then
            return true
        end
    end
    return false
end

exports("IsActionRelevant", function(actionKey)
    WaitPlayerLoaded()
    return IsActionRelevantForActiveQuests(actionKey)
end)
