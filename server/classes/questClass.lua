Quest = {}
Quest.__index = Quest

function Quest:new(questData)
    self = setmetatable({}, Quest)
    self.id = questData.id or GenerateNewId()
    self.name = questData.name or ""
    self.description = questData.description or ""
    self.XP = questData.XP or 1
    self.type = questData.type or QUEST_TYPES["GENERAL"]
    self.steps = questData.steps or 1
    self.skills = questData.skills or {}
    return self
end


--[[ GETTERS ]]

function Quest:getId()
    return self.id
end

function Quest:getName()
    return self.name
end

function Quest:getDescription()
    return self.description
end

function Quest:getXP()
    return self.XP
end

function Quest:getType()
    return self.type
end

function Quest:getSteps()
    return self.steps
end

function Quest:getTree()
    return self.tree
end


--[[ SETTERS ]]

function Quest:setName(name)
    self.name = name
end

function Quest:setDescription(description)
    self.description = description
end

function Quest:setXP(XP)
    self.XP = XP
end

function Quest:setType(type)
    self.type = type
end

function Quest:setSteps(steps)
    self.steps = steps
end

function Quest:setTree(tree)
    self.tree = tree
end
