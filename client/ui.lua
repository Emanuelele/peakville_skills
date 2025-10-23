NuiOpen = false
WaitPlayerLoaded()
RegisterCommand('skills', function()
    NuiOpen = not NuiOpen
    SetNuiFocus(NuiOpen, NuiOpen)

    if NuiOpen then
        SendNUIMessage({
            action = 'setVisible',
            data = true
        })

        SendNUIMessage({
            action = 'init',
            data = ClientData
        })

        SendNUIMessage({
            action = 'isStaffer',
            data = ESX.PlayerData.group ~= "user"
        })
    else
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
    end
end, false)

RegisterNUICallback('close', function(data, cb)
    NuiOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('purchaseTree', function(treeId, cb)
    local success = lib.callback.await('peakville_skills:purchaseTree', false, treeId)
    cb(success)
end)

RegisterNUICallback('refundTree', function(treeId, cb)
    local success = lib.callback.await('peakville_skills:refundTree', false, treeId)
    cb(success)
end)

RegisterNUICallback('purchaseSkill', function(skillId, cb)
    local success = lib.callback.await('peakville_skills:purchaseSkill', false, skillId)
    cb(success)
end)

RegisterNUICallback('refundSkill', function(skillId, cb)
    local success = lib.callback.await('peakville_skills:refundSkill', false, skillId)
    cb(success)
end)

RegisterNUICallback('selectQuest', function(questId, cb)
    local success = lib.callback.await('peakville_skills:selectQuest', false, questId)
    cb(success)
end)

RegisterNUICallback('deselectQuest', function(questId, cb)
    local success = lib.callback.await('peakville_skills:deselectQuest', false, questId)
    cb(success)
end)

RegisterNUICallback('createNewTree', function(data, cb)
    local success = lib.callback.await('peakville_skills:createNewTree', false, data)
    cb(success)
end)

RegisterNUICallback('updateTree', function(data, cb)
    local success = lib.callback.await('peakville_skills:updateTree', false, data.treeId, data.data)
    cb(success)
end)

RegisterNUICallback('deleteTree', function(treeId, cb)
    local success = lib.callback.await('peakville_skills:deleteTree', false, treeId)
    cb(success)
end)

RegisterNUICallback('createNewSkill', function(data, cb)
    local success = lib.callback.await('peakville_skills:createNewSkill', false, data)
    cb(success)
end)

RegisterNUICallback('updateSkill', function(data, cb)
    local success = lib.callback.await('peakville_skills:updateSkill', false, data.skillId, data.data)
    cb(success)
end)

RegisterNUICallback('deleteSkill', function(skillId, cb)
    local success = lib.callback.await('peakville_skills:deleteSkill', false, skillId)
    cb(success)
end)

RegisterNUICallback('createNewQuest', function(data, cb)
    local success = lib.callback.await('peakville_skills:createNewQuest', false, data)
    cb(success)
end)

RegisterNUICallback('updateQuest', function(data, cb)
    local success = lib.callback.await('peakville_skills:updateQuest', false, data.questId, data.data)
    cb(success)
end)

RegisterNUICallback('deleteQuest', function(questId, cb)
    local success = lib.callback.await('peakville_skills:deleteQuest', false, questId)
    cb(success)
end)

RegisterNUICallback('getOnlinePlayers', function(data, cb)
    local result = lib.callback.await('peakville_skills:getOnlinePlayers', false)
    cb(result)
end)

RegisterNUICallback('getPlayerData', function(data, cb)
    local result = lib.callback.await('peakville_skills:getPlayerData', false, data)
    cb(result)
end)

RegisterNUICallback('addPlayerSkill', function(data, cb)
    local result = lib.callback.await('peakville_skills:addPlayerSkill', false, data.targetSource, data.skillId)
    cb(result)
end)

RegisterNUICallback('removePlayerSkill', function(data, cb)
    local result = lib.callback.await('peakville_skills:removePlayerSkill', false, data.targetSource, data.skillId)
    cb(result)
end)

RegisterNUICallback('addPlayerTree', function(data, cb)
    local result = lib.callback.await('peakville_skills:addPlayerTree', false, data.targetSource, data.treeId)
    cb(result)
end)

RegisterNUICallback('removePlayerTree', function(data, cb)
    local result = lib.callback.await('peakville_skills:removePlayerTree', false, data.targetSource, data.treeId)
    cb(result)
end)

RegisterNUICallback('setPlayerXP', function(data, cb)
    local result = lib.callback.await('peakville_skills:setPlayerXP', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('addPlayerXP', function(data, cb)
    local result = lib.callback.await('peakville_skills:addPlayerXP', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('removePlayerXP', function(data, cb)
    local result = lib.callback.await('peakville_skills:removePlayerXP', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('setPlayerTokens', function(data, cb)
    local result = lib.callback.await('peakville_skills:setPlayerTokens', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('addPlayerTokens', function(data, cb)
    local result = lib.callback.await('peakville_skills:addPlayerTokens', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('removePlayerTokens', function(data, cb)
    local result = lib.callback.await('peakville_skills:removePlayerTokens', false, data.targetSource, data.amount)
    cb(result)
end)

RegisterNUICallback('setPlayerLevel', function(data, cb)
    local result = lib.callback.await('peakville_skills:setPlayerLevel', false, data.targetSource, data.level)
    cb(result)
end)

RegisterNUICallback('setPlayerQuestSteps', function(data, cb)
    local result = lib.callback.await('peakville_skills:setPlayerQuestSteps', false, data.targetSource, data.questId, data.steps)
    cb(result)
end)

RegisterNUICallback('completePlayerQuest', function(data, cb)
    local result = lib.callback.await('peakville_skills:completePlayerQuest', false, data.targetSource, data.questId)
    cb(result)
end)

RegisterNUICallback('uncompletePlayerQuest', function(data, cb)
    local result = lib.callback.await('peakville_skills:uncompletePlayerQuest', false, data.targetSource, data.questId)
    cb(result)
end)

RegisterNUICallback('assignHiddenQuest', function(data, cb)
    local result = lib.callback.await('peakville_skills:assignHiddenQuest', false, data.targetSource, data.questId)
    cb(result)
end)
