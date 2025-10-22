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
