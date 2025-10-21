Skill = {}
Skill.__index = Skill

function Skill:new(skillData)
    self = setmetatable({}, Skill)
    self.id = skillData.id or GenerateNewId()
    self.name = skillData.name or ""
    self.description = skillData.description or ""
    self.image = skillData.image or ""
    self.price = skillData.price or 1

    self.parentTree = skillData.parentTree --Riferimento all'id dell'albero genitore
    self.previousSkills = skillData.previousSkills or {} --Riferimento agli id delle skill precedenti (array)
    self.nextSkills = skillData.nextSkills or {} --Riferimento agli id delle skill successive (array)

    return self
end

--[[ METHODS ]]

function Skill:destroy()
    self = nil
    return nil
end

function Skill:getRefoundPrice()
    return math.floor(self.price / 2)
end

function Skill:isUnlockable(player)
    for _, prevSkillId in ipairs(self.previousSkills) do
        if not player.skills[prevSkillId] then
            return false
        end
    end

    for _, treeId in ipairs(self.parentTree) do
        if not player.trees[treeId] then
            return false
        end
    end

    return true
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

function Skill:getPrice()
    return self.price
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

function Skill:setPrice(price)
    self.price = price
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
