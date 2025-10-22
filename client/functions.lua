WaitPlayerLoaded = function()
    while not PlayerLoaded do
        Citizen.Wait(10)
    end
end
