Players = {}
Trees = {}
Skills = {}
Quests = {}

Logger.Init()

InitScript()
RegisterPlayerLoaderListener()
RegisterPlayerActionsListener()

RegisterStaffActionsInsertListener()
RegisterStaffActionsEditListener()
RegisterStaffActionsDeleteListener()

Citizen.CreateThread(function()
    OnStop(function()
        SaveAllPlayers(true)
    end, true)

    OnStop(function()
        SaveAllPlayers(nil)
    end, nil, true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.SavePlayersTime)
        SaveAllPlayers()
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    for _, src in ipairs(GetPlayers()) do
        LoadPlayer(src)
    end
end)

Logger.FinishInit()
