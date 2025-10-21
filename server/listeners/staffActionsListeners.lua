RegisterStaffActionsInsertListener = function()
    lib.callback.register("peakville_skills:createNewSkill", function(source, data)
        if not SourceIsStaffer(source) then return end

        local skillObjCreated, skill = pcall(function() return Skill:new(data) end)
        if skillObjCreated and skill then

            local skillInsertedOnDb, _ = pcall(function() InsertSkillOnDb(skill) end)
            if skillInsertedOnDb then

                Skills[skill:getId()] = skill

                TriggerClientEvent("peakville_skills:newSkillCreated", -1, {
                    id = skill:getId(),
                    name = skill:getName(),
                    description = skill:getDescription(),
                    image = skill:getImage(),
                    basePrice = skill:getBasePrice(),
                    parentTree = skill:getParentTree(),
                    previousSkills = skill:getPreviousSkills(),
                    nextSkills = skill:getNextSkills()
                })
            end
        end
    end)

    lib.callback.register("peakville_skills:createNewQuest", function(source, data)
        if not SourceIsStaffer(source) then return end

        local questObjCreated, quest = pcall(function() return Quest:new(data) end)
        if questObjCreated and quest then

            local questInsertedOnDb, _ = pcall(function() InsertQuestOnDb(quest) end)
            if questInsertedOnDb then

                Quests[quest:getId()] = quest
                if not quest:getHidden() then
                    TriggerClientEvent("peakville_skills:newQuestCreated", -1, {
                        id = quest:getId(),
                        name = quest:getName(),
                        description = quest:getDescription(),
                        XP = quest:getXP(),
                        steps = quest:getSteps(),
                        hidden = quest:getHidden(),
                    })
                end
            end
        end
    end)

    lib.callback.register("peakville_skills:createNewTree", function(source, data)
        if not SourceIsStaffer(source) then return end

        local treeObjCreated, tree = pcall(function() return Tree:new(data) end)
        if treeObjCreated and tree then

            local treeInsertedOnDb, _ = pcall(function() InsertTreeOnDb(tree) end)
            if treeInsertedOnDb then

                Trees[tree:getId()] = tree

                TriggerClientEvent("peakville_skills:newNewTreeCreated", -1, {
                    id = tree:getId(),
                    name = tree:getName(),
                    description = tree:getDescription(),
                })
            end
        end
    end)
end

RegisterStaffActionsEditListener = function()
    lib.callback.register("peakville_skills:updateSkill", function(source, skillId, data)
        if not SourceIsStaffer(source) then return end

        local skill = Skills[skillId]
        if not skill then return end

        local skillObjUpdated, updatedSkill = pcall(function()
            if data.name then skill:setName(data.name) end
            if data.description then skill:setDescription(data.description) end
            if data.image then skill:setImage(data.image) end
            if data.basePrice then skill:setBasePrice(data.basePrice) end
            if data.parentTree then skill:setParentTree(data.parentTree) end
            if data.previousSkills then skill:setPreviousSkills(data.previousSkills) end
            if data.nextSkills then skill:setNextSkills(data.nextSkills) end
            return skill
        end)

        if skillObjUpdated and updatedSkill then
            local skillUpdatedOnDb, _ = pcall(function() UpdateSkillOnDb(updatedSkill) end)
            if skillUpdatedOnDb then
                TriggerClientEvent("peakville_skills:skillUpdated", -1, {
                    id = updatedSkill:getId(),
                    name = updatedSkill:getName(),
                    description = updatedSkill:getDescription(),
                    image = updatedSkill:getImage(),
                    basePrice = updatedSkill:getBasePrice(),
                    parentTree = updatedSkill:getParentTree(),
                    previousSkills = updatedSkill:getPreviousSkills(),
                    nextSkills = updatedSkill:getNextSkills()
                })
            end
        end
    end)

    lib.callback.register("peakville_skills:updateQuest", function(source, questId, data)
        if not SourceIsStaffer(source) then return end

        local quest = Quests[questId]
        if not quest then return end

        local questObjUpdated, updatedQuest = pcall(function()
            if data.name then quest:setName(data.name) end
            if data.description then quest:setDescription(data.description) end
            if data.XP then quest:setXP(data.XP) end
            if data.types then quest:setTypes(data.types) end
            if data.steps then quest:setSteps(data.steps) end
            if data.tree then quest:setTree(data.tree) end
            return quest
        end)

        if questObjUpdated and updatedQuest then
            local questUpdatedOnDb, _ = pcall(function() UpdateQuestOnDb(updatedQuest) end)
            if questUpdatedOnDb then
                if updatedQuest:getTypes() ~= QUEST_TYPES["DAILY"] then
                    TriggerClientEvent("peakville_skills:questUpdated", -1, {
                        id = updatedQuest:getId(),
                        name = updatedQuest:getName(),
                        description = updatedQuest:getDescription(),
                        XP = updatedQuest:getXP(),
                        types = updatedQuest:getTypes(),
                        steps = updatedQuest:getSteps(),
                        tree = updatedQuest:getTree(),
                    })
                end
            end
        end
    end)

    lib.callback.register("peakville_skills:updateTree", function(source, treeId, data)
        if not SourceIsStaffer(source) then return end

        local tree = Trees[treeId]
        if not tree then return end

        local treeObjUpdated, updatedTree = pcall(function()
            if data.name then tree:setName(data.name) end
            if data.description then tree:setDescription(data.description) end
            return tree
        end)

        if treeObjUpdated and updatedTree then
            local treeUpdatedOnDb, _ = pcall(function() UpdateTreeOnDb(updatedTree) end)
            if treeUpdatedOnDb then
                TriggerClientEvent("peakville_skills:treeUpdated", -1, {
                    id = updatedTree:getId(),
                    name = updatedTree:getName(),
                    description = updatedTree:getDescription(),
                })
            end
        end
    end)
end

RegisterStaffActionsDeleteListener = function()
    lib.callback.register("peakville_skills:deleteSkill", function(source, skillId)
        if not SourceIsStaffer(source) then return end

        local skill = Skills[skillId]
        if not skill then return end

        local skillDeletedFromDb, _ = pcall(function() DeleteSkillFromDb(skillId) end)
        if skillDeletedFromDb then
            Skills[skillId] = nil
            TriggerClientEvent("peakville_skills:skillDeleted", -1, skillId)
        end
    end)

    lib.callback.register("peakville_skills:deleteQuest", function(source, questId)
        if not SourceIsStaffer(source) then return end

        local quest = Quests[questId]
        if not quest then return end

        local questDeletedFromDb, _ = pcall(function() DeleteQuestFromDb(questId) end)
        if questDeletedFromDb then
            Quests[questId] = nil
            TriggerClientEvent("peakville_skills:questDeleted", -1, questId)
        end
    end)

    lib.callback.register("peakville_skills:deleteTree", function(source, treeId)
        if not SourceIsStaffer(source) then return end

        local tree = Trees[treeId]
        if not tree then return end

        local treeDeletedFromDb, _ = pcall(function() DeleteTreeFromDb(treeId) end)
        if treeDeletedFromDb then
            Trees[treeId] = nil
            TriggerClientEvent("peakville_skills:treeDeleted", -1, treeId)
        end
    end)
end