Players = {}
Trees = {}
Skills = {}
Quests = {}

Logger.Init()

InitScript()
RegisterPlayerLoader()
RegisterPlayerActionsListener()

RegisterActionsLoader()

RegisterStaffActionsInsertListener()
RegisterStaffActionsEditListener()
RegisterStaffActionsDeleteListener()

RegisterStaffPlayerActionsListener()

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
        Logger.Info("Saved " .. #GetPlayers() .. " players")
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    for _, src in ipairs(GetPlayers()) do
        if ESX.GetPlayerFromId(src) then
            LoadPlayer(src)
        end
    end
end)

Logger.FinishInit()
