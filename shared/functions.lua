EmptyFunction = function()
end

RequiredXPForNextLevel = function(currentLevel)
    return math.floor((Config.MaxXP / math.log(Config.MaxLevel, 2)) * math.log(currentLevel + 1, 2) / 100 + 0.5) * 100
end

GetTokensForLevel = function(level)
    return level % 10 == 0 and 3 or (level % 5 == 0 and 2 or 1)
end
