local nuiOpen = false

RegisterCommand('skills', function()
    nuiOpen = not nuiOpen
    SetNuiFocus(nuiOpen, nuiOpen)

    if nuiOpen then
        SendNUIMessage({
            action = 'setVisible',
            data = true
        })

        SendNUIMessage({
            action = 'init',
            data = ClientData
        })
    else
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
    end
end, false)

RegisterNUICallback('close', function(data, cb)
    nuiOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('purchaseTree', function(treeId, cb)
    local success = lib.callback.await('peakville_skills:purchaseTree', false, treeId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)

RegisterNUICallback('refundTree', function(treeId, cb)
    local success = lib.callback.await('peakville_skills:refundTree', false, treeId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)

RegisterNUICallback('purchaseSkill', function(skillId, cb)
    local success = lib.callback.await('peakville_skills:purchaseSkill', false, skillId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)

RegisterNUICallback('refundSkill', function(skillId, cb)
    local success = lib.callback.await('peakville_skills:refundSkill', false, skillId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)

RegisterNUICallback('selectQuest', function(questId, cb)
    local success = lib.callback.await('peakville_skills:selectQuest', false, questId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)

RegisterNUICallback('deselectQuest', function(questId, cb)
    local success = lib.callback.await('peakville_skills:deselectQuest', false, questId)
    cb(success)
    SendNUIMessage({
        action = 'init',
        data = ClientData
    })
end)
