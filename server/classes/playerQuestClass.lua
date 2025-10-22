
PlayerQuest = {}
PlayerQuest.__index = PlayerQuest

function PlayerQuest:new(quest, player, playerQuestData)
    self = setmetatable({}, PlayerQuest)
    self.quest = quest --In fase di serializzazione salviamo solo l'id della quest, quando verrà istanziato il player sarà passato come parametro
    self.player = player --Non salvato in fase di srializzazione, quando verrà istanziato il player sarà passato come parametro
    self.completed = playerQuestData?.completed or false
    self.currentStep = playerQuestData?.currentStep or 0
    return self
end


--[[ METHODS ]]

function PlayerQuest:complete()
    if self.player:hasQuestInPool(self.quest) and not self.completed then
        self.completed = true
        self.player:addExperience(self.quest:getXP())
        self.currentStep = self.quest:getSteps()
        TriggerClientEvent("peakville_skills:questCompleted", self.player:getSource(), self.quest:getId())
    end
end

function PlayerQuest:nextSteps(stepsNumber)
    stepsNumber = stepsNumber or 1

    if not self.player:hasQuestInPool(self.quest) or self.completed then
        return
    end

    if self.currentStep + stepsNumber >= self.quest:getSteps() then
        self:complete()
        return
    end

    self.currentStep = self.currentStep + stepsNumber
    TriggerClientEvent("peakville_skills:questStepUpdated", self.player:getSource(), self.quest:getId(), self.currentStep)
end

function PlayerQuest:serialize()
    return {
        questId = self.quest:getId(),
        completed = self.completed,
        currentStep = self.currentStep
    }
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
