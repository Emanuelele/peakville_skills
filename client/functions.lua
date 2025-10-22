WaitPlayerLoaded = function()
    while not PlayerLoaded do
        Citizen.Wait(10)
    end
end

RefreshDataIfUiOpen = function()
    if NuiOpen then
        SendNUIMessage({
            action = 'init',
            data = ClientData
        })
    end
end