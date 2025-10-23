ValidatorSchemas = {}

ValidatorSchemas.Tree = {
    name = { type = "string", minLength = 1, maxLength = 100, optional = true },
    description = { type = "string", optional = true },
    price = { type = "number", min = 1, optional = true }
}

ValidatorSchemas.TreeCreate = {
    name = { type = "string", minLength = 1, maxLength = 100 },
    description = { type = "string", optional = true },
    price = { type = "number", min = 1, optional = true }
}

ValidatorSchemas.Skill = {
    name = { type = "string", minLength = 1, maxLength = 100, optional = true },
    description = { type = "string", optional = true },
    image = { type = "string", optional = true },
    price = { type = "number", min = 1, optional = true },
    parentTree = { type = "number", optional = true },
    previousSkills = { type = "array", items = "number", optional = true },
    nextSkills = { type = "array", items = "number", optional = true }
}

ValidatorSchemas.SkillCreate = {
    name = { type = "string", minLength = 1, maxLength = 100 },
    description = { type = "string", optional = true },
    image = { type = "string", optional = true },
    price = { type = "number", min = 1, optional = true },
    parentTree = { type = "number" },
    previousSkills = { type = "array", items = "number", optional = true },
    nextSkills = { type = "array", items = "number", optional = true }
}

ValidatorSchemas.Quest = {
    name = { type = "string", minLength = 1, maxLength = 100, optional = true },
    description = { type = "string", optional = true },
    XP = { type = "number", min = 1, optional = true },
    steps = { type = "number", min = 1, optional = true },
    skillsReference = { type = "array", items = "number", optional = true },
    requiredQuests = { type = "array", items = "number", optional = true },
    actionConfig = { type = "table", optional = true },
    hidden = { type = "boolean", optional = true }
}

ValidatorSchemas.QuestCreate = {
    name = { type = "string", minLength = 1, maxLength = 100 },
    description = { type = "string", optional = true },
    XP = { type = "number", min = 1, optional = true },
    steps = { type = "number", min = 1, optional = true },
    skillsReference = { type = "array", items = "number", optional = true },
    requiredQuests = { type = "array", items = "number", optional = true },
    actionConfig = { type = "table", optional = true },
    hidden = { type = "boolean", optional = true }
}

ValidatorSchemas.Id = {
    id = { type = "string" }
}
