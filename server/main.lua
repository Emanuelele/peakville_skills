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

    while true do
        Citizen.Wait(Config.SavePlayersTime)
        SaveAllPlayers()
    end
end)

Logger.FinishInit()
