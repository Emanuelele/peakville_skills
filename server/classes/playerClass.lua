Player = {}
Player.__index = Player

function Player:new(xPlayer, playerData)
    self = setmetatable({}, Player)
    self.identifier = xPlayer.identifier
    self.source = xPlayer.source

    self.level = playerData.level or 1
    self.XP = playerData.XP or 0
    self.tokens = playerData.tokens or Config.StartTokens

    self.currentTrees = playerData.currentTrees or {} --Riferimento agli id degli alberi sbloccati (array)

    self.quests = playerData.quests or {} --Oggetti serializzati di tipo playerQuest (array index)
    self.skills = playerData.skills or {} --Riferimento agli id delle skill sbloccate (array index)
    return self
end


--[[ METHODS ]]

function Player:addExperience(value)
    self.XP = self.XP + value

    TriggerClientEvent("peakville_skills:xpAdded", self.source, self.XP)

    while self.XP >= RequiredXPForNextLevel(self.level) do
        self.XP = self.XP - RequiredXPForNextLevel(self.level)
        self.level = self.level + 1
        self.tokens = self.tokens + GetTokensForLevel(self.level)
        TriggerClientEvent("peakville_skills:newLevelReached", self.source, self.level, self.XP, self.tokens)
    end
end

function Player:save()
    SavePlayerData(self)
end

function Player:serialize()
    return {
        identifier = self.identifier,
        level = self.level,
        XP = self.XP,
        tokens = self.tokens,
        currentTrees = self.currentTrees,
        quests = self.quests,
        skills = self.skills
    }
end

function Player:saveAndDestroy()
    self:save()

    self = nil
    return nil
end

function Player:addSkill(skill)
    if not self.skills[skill:getId()] and CanPlayerGetSkill(self, skill) then
        local tokensPrediction = self.tokens - GetTokensPriceForSkill(self, skill)
        if tokensPrediction >= 0 then
            self.tokens = tokensPrediction
            self.skills[skill:getId()] = true
            TriggerClientEvent("peakville_skills:newSkillReached", self.source, skill:getId(), self.tokens)
        end
    end
end

function Player:removeSkill(skill)
    if self.skills[skill:getId()] then
        self.tokens += math.floor(GetTokensPriceForSkill(self, skill))
    end
end

function Player:hasQuestInPool(quest)
    return self.quests[quest:getId()] ~= nil
end

--[[ GETTERS ]]

function Player:getIdentifier()
    return self.identifier
end

function Player:getSource()
    return self.source
end

function Player:getLevel()
    return self.level
end

function Player:getXP()
    return self.XP
end

function Player:getTokens()
    return self.tokens
end

function Player:getCurrentTrees()
    return self.currentTrees
end

function Player:getQuests()
    return self.quests
end

function Player:getSkills()
    return self.skills
end
