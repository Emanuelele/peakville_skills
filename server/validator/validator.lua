Validator = {}

Validator.validate = function(data, schema)
    if type(data) ~= "table" then
        return false, "Data must be a table"
    end

    for field, rules in pairs(schema) do
        local value = data[field]
        local fieldType = rules.type
        local optional = rules.optional or false

        if value == nil then
            if not optional then
                return false, string.format("Field '%s' is required", field)
            end
        else
            local valueType = type(value)

            if fieldType == "array" then
                if valueType ~= "table" then
                    return false, string.format("Field '%s' must be an array", field)
                end

                if rules.items then
                    for i, item in ipairs(value) do
                        if type(item) ~= rules.items then
                            return false, string.format("Field '%s[%d]' must be of type '%s'", field, i, rules.items)
                        end
                    end
                end
            elseif fieldType == "table" then
                if valueType ~= "table" then
                    return false, string.format("Field '%s' must be a table", field)
                end

                if rules.schema then
                    local valid, err = Validator.validate(value, rules.schema)
                    if not valid then
                        return false, string.format("Field '%s': %s", field, err)
                    end
                end
            else
                if valueType ~= fieldType then
                    return false, string.format("Field '%s' must be of type '%s', got '%s'", field, fieldType, valueType)
                end
            end

            if rules.min and valueType == "number" and value < rules.min then
                return false, string.format("Field '%s' must be >= %s", field, rules.min)
            end

            if rules.max and valueType == "number" and value > rules.max then
                return false, string.format("Field '%s' must be <= %s", field, rules.max)
            end

            if rules.minLength and valueType == "string" and #value < rules.minLength then
                return false, string.format("Field '%s' must have at least %d characters", field, rules.minLength)
            end

            if rules.maxLength and valueType == "string" and #value > rules.maxLength then
                return false, string.format("Field '%s' must have at most %d characters", field, rules.maxLength)
            end
        end
    end

    return true
end
