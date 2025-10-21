Tree = {}
Tree.__index = Tree

function Tree:new(treeData)
    self = setmetatable({}, Tree)
    self.id = treeData.id or GenerateNewId()
    self.name = treeData.name or ""
    self.description = treeData.description or ""
    self.price = treeData.price or 1
    return self
end


--[[ METHODS ]]

function Tree:destroy()
    self = nil
    return nil
end

function Tree:getRefoundPrice()
    return math.floor(self.price / 2)
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

function Tree:getPrice()
    return self.price
end


--[[ SETTERS ]]

function Tree:setName(name)
    self.name = name
end

function Tree:setDescription(description)
    self.description = description
end

function Tree:setPrice(price)
    self.price = price
end
