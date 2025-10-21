--n.b; difficoltà logaritmica in ottica di reset dell'xp ad ogni avanzamento di livello
RequiredXPForNextLevel = function(currentLevel)
    return math.floor((Config.MaxXP / math.log(Config.MaxLevel, 2)) * math.log(currentLevel + 1, 2) / 100 + 0.5) * 100
end

--n.b: 1 token default, 2 per i livelli multipli di 5 e 3 per i multipli di 10
GetTokensForLevel = function(level)
    return level % 10 == 0 and 3 or (level % 5 == 0 and 2 or 1)
end

--n.b: calcola anche il prezzo di skill attualmente possedute in ottica di refound con debuff
GetTokensPriceForSkill = function(player, skill)
    return skill:getBasePrice()
end

CanPlayerGetSkill = function(player, skill)
    if #skill.previousSkills == 0 then
        return true
    end

    for _, skillId in ipairs(skill.previousSkills) do
        if player.skills[skillId] then
            return true
        end
    end

    return false
end

OnStop = function(func)
    RegisterNetEvent("txAdmin:events:serverShuttingDown", function()
        if type(func) == "function" then
            func()
        end
    end)

    RegisterNetEvent("onResourceStop", function(resourceName) 
        if resourceName == "peakville_skills" and type(func) == "function" then
            func()
        end
    end)
end
