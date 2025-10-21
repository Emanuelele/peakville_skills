
PlayerQuest = {}
PlayerQuest.__index = PlayerQuest

function PlayerQuest:new(quest, player, playerQuestData)
    self = setmetatable({}, PlayerQuest)
    self.quest = quest --In fase di serializzazione salviamo solo l'id della quest
    self.player = player --In fase di serializzazione salviamo solo l'identificativo del player
    self.completed = playerQuestData and playerQuestData.completed or false
    self.currentStep = playerQuestData and playerQuestData.currentStep or 0
    return self
end


--[[ METHODS ]]

function PlayerQuest:complete()
    if self.player:hasQuestInPool(self.quest) and not self.completed then
        self.completed = true
        self.player:addExperience(self.quest:getXP())
        TriggerClientEvent("peakville_skills:questCompleted", self.player:getSource(), self.quest:getId())
    end
end

function PlayerQuest:nextSteps(stepsNumber)
    if
        self.player:hasQuestInPool(self.quest)
        and not self.completed
        and self.currentStep + (stepsNumber or 1) >= self.quest:getSteps()
    then
        self:complete()
        self.currentStep = self.quest:getSteps()
        return
    end
    self.currentStep += (stepsNumber or 1)
end

--[[ GETTERS ]]

function PlayerQuest:getQuest()
    return self.quest
end

function PlayerQuest:getPlayer()
    return self.player
end

function PlayerQuest:isCompleted()
    return self.completed
end

function PlayerQuest:getCurrentStep()
    return self.currentStep
end
