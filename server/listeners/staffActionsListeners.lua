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
                    price = skill:getPrice(),
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

                for _, player in pairs(Players) do
                    RecalculatePlayerQuests(player)
                end

                if not quest:getHidden() then
                    TriggerClientEvent("peakville_skills:newQuestCreated", -1, {
                        id = quest:getId(),
                        name = quest:getName(),
                        description = quest:getDescription(),
                        XP = quest:getXP(),
                        steps = quest:getSteps(),
                        skillsReference = quest:getSkillsReference(),
                        requiredQuests = quest:getRequiredQuests(),
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

                TriggerClientEvent("peakville_skills:newTreeCreated", -1, {
                    id = tree:getId(),
                    name = tree:getName(),
                    description = tree:getDescription(),
                    price = tree:getPrice()
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
            if data.price then skill:setPrice(data.price) end
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
                    price = updatedSkill:getPrice(),
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
            if data.steps then quest:setSteps(data.steps) end
            if data.skillsReference then quest:setSkillsReference(data.skillsReference) end
            if data.requiredQuests then quest:setRequiredQuests(data.requiredQuests) end
            if data.hidden ~= nil then quest:setHidden(data.hidden) end
            return quest
        end)

        if questObjUpdated and updatedQuest then
            local questUpdatedOnDb, _ = pcall(function() UpdateQuestOnDb(updatedQuest) end)
            if questUpdatedOnDb then
                for _, player in pairs(Players) do
                    RecalculatePlayerQuests(player)
                end
                
                if not updatedQuest:getHidden() then
                    TriggerClientEvent("peakville_skills:questUpdated", -1, {
                        id = updatedQuest:getId(),
                        name = updatedQuest:getName(),
                        description = updatedQuest:getDescription(),
                        XP = updatedQuest:getXP(),
                        steps = updatedQuest:getSteps(),
                        skillsReference = updatedQuest:getSkillsReference(),
                        requiredQuests = updatedQuest:getRequiredQuests(),
                        hidden = updatedQuest:getHidden(),
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
            if data.price then tree:setPrice(data.price) end
            return tree
        end)

        if treeObjUpdated and updatedTree then
            local treeUpdatedOnDb, _ = pcall(function() UpdateTreeOnDb(updatedTree) end)
            if treeUpdatedOnDb then
                TriggerClientEvent("peakville_skills:treeUpdated", -1, {
                    id = updatedTree:getId(),
                    name = updatedTree:getName(),
                    description = updatedTree:getDescription(),
                    price = updatedTree:getPrice()
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
            
            for _, player in pairs(Players) do
                if player.quests[questId] then
                    player.quests[questId] = nil
                end
            end
            
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
