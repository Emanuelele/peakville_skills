local idCounter = GetResourceKvpInt("skills_id_gen") or 0
GenerateNewId = function()
    idCounter = idCounter + 1

    if idCounter % Config.SaveThresholdIds == 0 then
        SetResourceKvpInt("skills_id_gen", idCounter)
    end

    return idCounter
end
OnStop(function() SetResourceKvpInt("skills_id_gen", idCounter) end)

SourceIsStaffer = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer and xPlayer.getGroup() ~= "user"
end
