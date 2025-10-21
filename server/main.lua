Players = {}
Trees = {}
Skills = {}
Quests = {}

Logger.Init()

InitScript()
RegisterPlayerListener()

RegisterStaffActionsInsertListener()
RegisterStaffActionsEditListener()
RegisterStaffActionsDeleteListener()

Citizen.CreateThread(function()
    OnStop(function()
        SaveAllPlayers()
    end)

    while true do
        Citizen.Wait(Config.SavePlayersTime)
        SaveAllPlayers()
    end
end)

Logger.FinishInit()
