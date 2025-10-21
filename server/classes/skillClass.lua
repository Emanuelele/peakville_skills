Skill = {}
Skill.__index = Skill

function Skill:new(skillData)
    self = setmetatable({}, Skill)
    self.id = skillData.id or GenerateNewId()
    self.name = skillData.name or ""
    self.description = skillData.description or ""
    self.image = skillData.image or ""
    self.basePrice = skillData.basePrice or 1

    self.parentTree = skillData.parentTree or 0
    self.previousSkills = skillData.previousSkills or {}
    self.nextSkills = skillData.nextSkills or {}

    return self
end

--[[ METHODS ]]

function Skill:destroy()
    self = nil
    return nil
end


--[[ GETTERS ]]

function Skill:getId()
    return self.id
end

function Skill:getName()
    return self.name
end

function Skill:getDescription()
    return self.description
end

function Skill:getImage()
    return self.image
end

function Skill:getBasePrice()
    return self.basePrice
end

function Skill:getParentTree()
    return self.parentTree
end

function Skill:getPreviousSkills()
    return self.previousSkills
end

function Skill:getNextSkills()
    return self.nextSkills
end


--[[ SETTERS ]]

function Skill:setName(name)
    self.name = name
end

function Skill:setDescription(description)
    self.description = description
end

function Skill:setImage(image)
    self.image = image
end

function Skill:setBasePrice(basePrice)
    self.basePrice = basePrice
end

function Skill:setParentTree(parentTree)
    self.parentTree = parentTree
end

function Skill:setPreviousSkills(previousSkills)
    self.previousSkills = previousSkills or {}
end

function Skill:setNextSkills(nextSkills)
    self.nextSkills = nextSkills or {}
end
