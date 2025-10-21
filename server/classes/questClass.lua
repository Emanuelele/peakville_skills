Quest = {}
Quest.__index = Quest

function Quest:new(questData)
    self = setmetatable({}, Quest)
    self.id = questData.id or GenerateNewId()
    self.name = questData.name or ""
    self.description = questData.description or ""
    self.XP = questData.XP or 1
    self.steps = questData.steps or 1
    self.skillsReference = questData.skillsReference or {} --Riferimento agli id delle skill a cui la quest fa riferimento (puoi completare la quest se possiedi queste skill) (array)
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

function Quest:getSteps()
    return self.steps
end

function Quest:getTree()
    return self.tree
end

function Quest:getSkillsReference()
    return self.skillsReference
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

function Quest:setSteps(steps)
    self.steps = steps
end

function Quest:setTree(tree)
    self.tree = tree
end

function Quest:setSkillsReference(skillsReference)
    self.skillsReference = skillsReference
end