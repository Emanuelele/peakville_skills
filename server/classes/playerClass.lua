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

    self.maxActiveQuests = playerData?.maxActiveQuests or Config.DefaultMaxActiveQuests
    self.activeQuests = playerData?.activeQuests or {}
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
        maxActiveQuests = self.maxActiveQuests,
        activeQuests = self.activeQuests,
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

function Player:addTree(treeId)
    if not self.currentTrees[treeId] then
        self.currentTrees[treeId] = true
        return true
    end
    return false
end

function Player:removeTree(treeId)
    if self.currentTrees[treeId] then
        self.currentTrees[treeId] = nil
        return true
    end
    return false
end

function Player:addSkill(skillId)
    if not self.skills[skillId] then
        self.skills[skillId] = true
        self:recalculatePlayerQuests()
        return true
    end
    return false
end

function Player:removeSkill(skillId)
    if self.skills[skillId] then
        self.skills[skillId] = nil
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

    if #skillsReference > 0 then
        for _, skillId in ipairs(skillsReference) do
            if not self.skills[skillId] then
                return false
            end
        end
    end

    local requiredQuests = quest:getRequiredQuests()
    if #requiredQuests > 0 then
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

        if currentQuestData?.completed then
            newQuests[questId] = currentQuestData
        elseif currentQuestData?.currentStep > 0 then
            if quest:getHidden() or self:checkQuestRequirements(quest) then
                newQuests[questId] = currentQuestData
            end
        elseif self:canUnlockQuest(quest) then
            newQuests[questId] = PlayerQuest:new(quest, self)
        end
    end

    self.quests = newQuests
    TriggerClientEvent("peakville_skills:questsRecalculated", self.source, SerializePlayerQuests(self.quests))
end

function Player:selectQuest(questId)
    if self.quests[questId] and not self.activeQuests[questId] then
        if self:getActiveQuestsCount() >= self.maxActiveQuests then
            return false
        end
        self.activeQuests[questId] = true
        return true
    end
    return false
end

function Player:deselectQuest(questId)
    if self.activeQuests[questId] then
        self.activeQuests[questId] = nil
        local playerQuest = self.quests[questId]
        if playerQuest and not playerQuest.completed then
            playerQuest.currentStep = 0
        end
        return true
    end
    return false
end

function Player:isQuestActive(questId)
    return self.activeQuests[questId] ~= nil
end

function Player:getActiveQuestsCount()
    local count = 0
    for _ in pairs(self.activeQuests) do
        count = count + 1
    end
    return count
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

function Player:getMaxActiveQuests()
    return self.maxActiveQuests
end

function Player:getActiveQuests()
    return self.activeQuests
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

function Player:setMaxActiveQuests(value)
    self.maxActiveQuests = value
end

function Player:setActiveQuests(value)
    self.activeQuests = value
end
