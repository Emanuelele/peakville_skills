Tree = {}
Tree.__index = Tree

function Tree:new(treeData)
    self = setmetatable({}, Tree)
    self.id = treeData.id or GenerateNewId()
    self.name = treeData.name or ""
    self.description = treeData.description or ""
    return self
end


--[[ GETTERS ]]

function Tree:getId()
    return self.id
end

function Tree:getName()
    return self.name
end

function Tree:getDescription()
    return self.description
end


--[[ SETTERS ]]

function Tree:setName(name)
    self.name = name
end

function Tree:setDescription(description)
    self.description = description
end
