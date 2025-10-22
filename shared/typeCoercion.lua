TypeCoercion = {}

function TypeCoercion.CoerceValue(value, targetType)
    local currentType = type(value)

    if currentType == targetType then
        return true, value
    end

    if targetType == "number" then
        if currentType == "string" then
            local num = tonumber(value)
            if num ~= nil then
                return true, num
            end
        end
        return false, value

    elseif targetType == "string" then
        if currentType == "number" or currentType == "boolean" then
            return true, tostring(value)
        end
        return false, value

    elseif targetType == "boolean" then
        if currentType == "string" then
            local lower = string.lower(value)
            if lower == "true" or lower == "1" then
                return true, true
            elseif lower == "false" or lower == "0" then
                return true, false
            end
        elseif currentType == "number" then
            if value == 1 then
                return true, true
            elseif value == 0 then
                return true, false
            end
        end
        return false, value

    elseif targetType == "array" or targetType == "table" then
        return false, value
    end

    return false, value
end
