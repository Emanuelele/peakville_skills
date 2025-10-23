PlayerLoaded = false
ClientData = {
    player = {
        level = 1,
        XP = 0,
        tokens = 0,
        currentTrees = {},
        skills = {},
        maxActiveQuests = Config.DefaultMaxActiveQuests,
        activeQuests = {}
    },
    trees = {},
    skills = {},
    quests = {}
}

RegisterNetEvent("peakville_skills:init", function(initData)
    ClientData.player.level = initData.player.level
    ClientData.player.XP = initData.player.XP
    ClientData.player.tokens = initData.player.tokens
    ClientData.player.currentTrees = initData.player.currentTrees
    ClientData.player.skills = initData.player.skills
    ClientData.player.maxActiveQuests = initData.player.maxActiveQuests
    ClientData.player.activeQuests = initData.player.activeQuests

    ClientData.trees = initData.trees
    ClientData.skills = initData.skills
    ClientData.quests = initData.quests
    CliendData.availableActions = Config.Actions
    PlayerLoaded = true
end)

RegisterNetEvent("peakville_skills:xpAdded", function(XP)
    WaitPlayerLoaded()
    ClientData.player.XP = XP
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:newLevelReached", function(level, XP, tokens)
    WaitPlayerLoaded()
    ClientData.player.level = level
    ClientData.player.XP = XP
    ClientData.player.tokens = tokens
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:treePurchased", function(treeId, tokens)
    WaitPlayerLoaded()
    ClientData.player.currentTrees[treeId] = true
    ClientData.player.tokens = tokens
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:treeRefunded", function(treeId, tokens)
    WaitPlayerLoaded()
    ClientData.player.currentTrees[treeId] = nil
    ClientData.player.tokens = tokens
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:skillPurchased", function(skillId, tokens)
    WaitPlayerLoaded()
    ClientData.player.skills[skillId] = true
    ClientData.player.tokens = tokens
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:skillRefunded", function(skillId, tokens)
    WaitPlayerLoaded()
    ClientData.player.skills[skillId] = nil
    ClientData.player.tokens = tokens
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:questsRecalculated", function(quests)
    WaitPlayerLoaded()
    ClientData.quests = quests
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:questSelected", function(questId)
    WaitPlayerLoaded()
    ClientData.player.activeQuests[questId] = true
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:questDeselected", function(questId)
    WaitPlayerLoaded()
    ClientData.player.activeQuests[questId] = nil
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:questCompleted", function(questId)
    WaitPlayerLoaded()
    if ClientData.quests[questId] then
        ClientData.quests[questId].completed = true
        RefreshDataIfUiOpen()
    end
end)

RegisterNetEvent("peakville_skills:questStepUpdated", function(questId, currentStep)
    WaitPlayerLoaded()
    if ClientData.quests[questId] then
        ClientData.quests[questId].currentStep = currentStep
        RefreshDataIfUiOpen()
    end
end)

RegisterNetEvent("peakville_skills:newTreeCreated", function(treeData)
    WaitPlayerLoaded()
    ClientData.trees[treeData.id] = treeData
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:treeUpdated", function(treeData)
    WaitPlayerLoaded()
    if ClientData.trees[treeData.id] then
        ClientData.trees[treeData.id] = treeData
        RefreshDataIfUiOpen()
    end
end)

RegisterNetEvent("peakville_skills:treeDeleted", function(treeId)
    WaitPlayerLoaded()
    ClientData.trees[treeId] = nil
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:newSkillCreated", function(skillData)
    WaitPlayerLoaded()
    ClientData.skills[skillData.id] = skillData
    RefreshDataIfUiOpen()
end)

RegisterNetEvent("peakville_skills:skillUpdated", function(skillData)
    WaitPlayerLoaded()
    if ClientData.skills[skillData.id] then
        ClientData.skills[skillData.id] = skillData
        RefreshDataIfUiOpen()
    end
end)

RegisterNetEvent("peakville_skills:skillDeleted", function(skillId)
    WaitPlayerLoaded()
    ClientData.skills[skillId] = nil
    RefreshDataIfUiOpen()
end)
