EmptyFunction = function()
end

RequiredXPForNextLevel = function(currentLevel)
    return math.floor((Config.MaxXP / math.log(Config.MaxLevel, 2)) * math.log(currentLevel + 1, 2) / 100 + 0.5) * 100
end

GetTokensForLevel = function(level)
    return level % 10 == 0 and 3 or (level % 5 == 0 and 2 or 1)
end

OnStop = function(func, onlyOnServerStop, onlyOnResourceStop)
    if not onlyOnResourceStop then
        RegisterNetEvent("txAdmin:events:serverShuttingDown", function()
            if type(func) == "function" then
                func()
            end
        end)
    end

    if not onlyOnServerStop then
        RegisterNetEvent("onResourceStop", function(resourceName)
            if resourceName == "peakville_skills" and type(func) == "function" then
                func()
            end
        end)
    end
end
