Validator = {}

Validator.validate = function(data, schema, visited)
    if type(data) ~= "table" then
        return false, "Data must be a table"
    end

    visited = visited or {}

    if visited[data] then
        return true
    end

    visited[data] = true

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

                if visited[value] then
                    goto continue
                end

                visited[value] = true

                if rules.items then
                    for i, item in ipairs(value) do
                        if type(item) == "table" then
                            if visited[item] then
                                goto continue_array
                            end
                            visited[item] = true
                        end

                        local coerced, coercedItem = TypeCoercion.CoerceValue(item, rules.items)
                        if not coerced then
                            return false, string.format("Field '%s[%d]' must be of type '%s'", field, i, rules.items)
                        end
                        value[i] = coercedItem

                        ::continue_array::
                    end
                end
            elseif fieldType == "table" then
                if valueType ~= "table" then
                    return false, string.format("Field '%s' must be a table", field)
                end

                if visited[value] then
                    goto continue
                end

                if rules.schema then
                    local valid, err = Validator.validate(value, rules.schema, visited)
                    if not valid then
                        return false, string.format("Field '%s': %s", field, err)
                    end
                end
            else
                local coerced, coercedValue = TypeCoercion.CoerceValue(value, fieldType)
                if not coerced then
                    return false, string.format("Field '%s' must be of type '%s', got '%s'", field, fieldType, valueType)
                end
                value = coercedValue
                data[field] = coercedValue
            end

            if rules.min and type(value) == "number" and value < rules.min then
                return false, string.format("Field '%s' must be >= %s", field, rules.min)
            end

            if rules.max and type(value) == "number" and value > rules.max then
                return false, string.format("Field '%s' must be <= %s", field, rules.max)
            end

            if rules.minLength and type(value) == "string" and #value < rules.minLength then
                return false, string.format("Field '%s' must have at least %d characters", field, rules.minLength)
            end

            if rules.maxLength and type(value) == "string" and #value > rules.maxLength then
                return false, string.format("Field '%s' must have at most %d characters", field, rules.maxLength)
            end

            ::continue::
        end
    end

    return true
end
