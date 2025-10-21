InsertQuestOnDb = function(quest)
    MySQL.insert.await([[
        INSERT INTO quests (id, name, description, XP, steps, skillsReference, requiredQuests, hidden)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        quest:getId(),
        quest:getName(),
        quest:getDescription(),
        quest:getXP(),
        quest:getSteps(),
        json.encode(quest:getSkillsReference()),
        json.encode(quest:getRequiredQuests()),
        quest:getHidden()
    })
    return true
end

RetreiveQuestsFromDb = function()
    local results = MySQL.query.await('SELECT * FROM quests')
    local quests = {}

    if results then
        for _, row in ipairs(results) do
            local questData = {
                id = row.id,
                name = row.name,
                description = row.description,
                XP = row.XP,
                steps = row.steps,
                skillsReference = json.decode(row.skillsReference) or {},
                requiredQuests = json.decode(row.requiredQuests) or {},
                hidden = row.hidden
            }
            quests[row.id] = Quest:new(questData)
        end
    end

    return quests
end

UpdateQuestOnDb = function(quest)
    MySQL.update.await([[
        UPDATE quests 
        SET name = ?, description = ?, XP = ?, steps = ?, skillsReference = ?, requiredQuests = ?, hidden = ?
        WHERE id = ?
    ]], {
        quest:getName(),
        quest:getDescription(),
        quest:getXP(),
        quest:getSteps(),
        json.encode(quest:getSkillsReference()),
        json.encode(quest:getRequiredQuests()),
        quest:getHidden(),
        quest:getId()
    })
end

DeleteQuestFromDb = function(questId)
    MySQL.query.await('DELETE FROM quests WHERE id = ?', {questId})
end

