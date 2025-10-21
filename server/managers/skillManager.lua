InsertSkillOnDb = function(skill)
    MySQL.insert.await([[
        INSERT INTO skills (id, name, description, image, price, parentTree, previousSkills, nextSkills)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        skill:getId(),
        skill:getName(),
        skill:getDescription(),
        skill:getImage(),
        skill:getPrice(),
        skill:getParentTree(),
        json.encode(skill:getPreviousSkills()),
        json.encode(skill:getNextSkills())
    })
    return true
end

RetreiveSkillsFromDb = function()
    local results = MySQL.query.await('SELECT * FROM skills')
    local skills = {}

    if results then
        for _, row in ipairs(results) do
            local skillData = {
                id = row.id,
                name = row.name,
                description = row.description,
                image = row.image,
                price = row.price,
                parentTree = row.parentTree,
                previousSkills = json.decode(row.previousSkills) or {},
                nextSkills = json.decode(row.nextSkills) or {}
            }
            skills[row.id] = Skill:new(skillData)
        end
    end

    return skills
end

UpdateSkillOnDb = function(skill)
    MySQL.update.await([[
        UPDATE skills 
        SET name = ?, description = ?, image = ?, price = ?, parentTree = ?, previousSkills = ?, nextSkills = ?
        WHERE id = ?
    ]], {
        skill:getName(),
        skill:getDescription(),
        skill:getImage(),
        skill:getPrice(),
        skill:getParentTree(),
        json.encode(skill:getPreviousSkills()),
        json.encode(skill:getNextSkills()),
        skill:getId()
    })
end

DeleteSkillFromDb = function(skillId)
    MySQL.query.await('DELETE FROM skills WHERE id = ?', {skillId})
end