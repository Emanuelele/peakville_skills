InsertTreeOnDb = function(tree)
    MySQL.insert.await([[
        INSERT INTO trees (id, name, description)
        VALUES (?, ?, ?)
    ]], {
        tree:getId(),
        tree:getName(),
        tree:getDescription()
    })
    return true
end

RetreiveTreesFromDb = function()
    local results = MySQL.query.await('SELECT * FROM trees')
    local trees = {}

    if results then
        for _, row in ipairs(results) do
            local treeData = {
                id = row.id,
                name = row.name,
                description = row.description
            }
            trees[row.id] = Tree:new(treeData)
        end
    end

    return trees
end

UpdateTreeOnDb = function(tree)
    MySQL.update.await([[
        UPDATE trees 
        SET name = ?, description = ?
        WHERE id = ?
    ]], {
        tree:getName(),
        tree:getDescription(),
        tree:getId()
    })
end

DeleteTreeFromDb = function(treeId)
    MySQL.query.await('DELETE FROM trees WHERE id = ?', {treeId})
end