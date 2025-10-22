Player = {}
Player.__index = Player

function Player:new(xPlayer, playerData)
    self = setmetatable({}, Player)
    self.identifier = xPlayer.identifier
    self.source = xPlayer.source

    self.level = playerData?.level or 1
    self.XP = playerData?.XP or 0
    self.tokens = playerData?.tokens or Config.StartTokens

    self.currentTrees = playerData?.currentTrees or {}

    self.quests = playerData?.quests or {}
    self.skills = playerData?.skills or {}
    return self
end


--[[ METHODS ]]

function Player:addExperience(value)
    self.XP = math.min(self.XP + value, Config.MaxXP)

    TriggerClientEvent("peakville_skills:xpAdded", self.source, self.XP)

    while self.XP >= RequiredXPForNextLevel(self.level) and self.level < Config.MaxLevel do
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
    local serializedQuests = {}
    for questId, playerQuest in pairs(self.quests) do
        serializedQuests[questId] = playerQuest:serialize()
    end

    return {
        identifier = self.identifier,
        level = self.level,
        XP = self.XP,
        tokens = self.tokens,
        currentTrees = self.currentTrees,
        quests = serializedQuests,
        skills = self.skills
    }
end

function Player:saveAndDestroy()
    self:save()

    self = nil
    return nil
end

function Player:addTree(tree)
    if not self.currentTrees[tree:getId()] then
        local tokensPrediction = self.tokens - tree:getPrice()
        if tokensPrediction >= 0 then
            self.tokens = tokensPrediction
            self.currentTrees[tree:getId()] = true
            return true
        end
        return false
    end
    return false
end

function Player:removeTree(tree)
    if self.currentTrees[tree:getId()] then
        self.tokens = self.tokens + tree:getRefoundPrice()
        self.currentTrees[tree:getId()] = nil
        return true
    end
    return false
end

function Player:addSkill(skill)
    if not self.skills[skill:getId()] and skill:isUnlockable(self) then
        local tokensPrediction = self.tokens - skill:getPrice()
        if tokensPrediction >= 0 then
            self.tokens = tokensPrediction
            self.skills[skill:getId()] = true
            self:recalculatePlayerQuests()
            return true
        end
        return false
    end
    return false
end

function Player:removeSkill(skill)
    if self.skills[skill:getId()] then
        self.tokens = self.tokens + skill:getRefoundPrice()
        self.skills[skill:getId()] = nil
        self:recalculatePlayerQuests()
        return true
    end
    return false
end

function Player:hasQuestInPool(quest)
    return self.quests[quest:getId()] ~= nil
end

function Player:checkQuestRequirements(quest)
    local skillsReference = quest:getSkillsReference()
    if skillsReference and #skillsReference > 0 then
        for _, skillId in ipairs(skillsReference) do
            if not self.skills[skillId] then
                return false
            end
        end
    end

    local requiredQuests = quest:getRequiredQuests()
    if requiredQuests and #requiredQuests > 0 then
        for _, requiredQuestId in ipairs(requiredQuests) do
            local playerQuest = self.quests[requiredQuestId]
            if not playerQuest or not playerQuest.completed then
                return false
            end
        end
    end

    return true
end

function Player:canUnlockQuest(quest)
    if quest:getHidden() then
        return false
    end

    return self:checkQuestRequirements(quest)
end

function Player:recalculatePlayerQuests()
    local newQuests = {}

    for questId, quest in pairs(Quests) do
        local currentQuestData = self.quests[questId]

        if currentQuestData then
            if currentQuestData.completed then
                newQuests[questId] = currentQuestData
            elseif currentQuestData.currentStep > 0 then
                if quest:getHidden() or self:checkQuestRequirements(quest) then
                    newQuests[questId] = currentQuestData
                end
            end
        else
            if self:canUnlockQuest(quest) then
                newQuests[questId] = PlayerQuest:new(quest, self)
            end
        end
    end

    self.quests = newQuests
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

--[[ SETTERS ]]

function Player:setLevel(value)
    self.level = value
end

function Player:setXP(value)
    self.XP = value
end

function Player:setTokens(value)
    self.tokens = value
end

function Player:setCurrentTrees(value)
    self.currentTrees = value
end

function Player:setQuests(value)
    self.quests = value
end

function Player:setSkills(value)
    self.skills = value
end
