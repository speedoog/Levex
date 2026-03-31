function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key,orig_value in next,orig,nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy,DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- V2 qui marche
function deepcopy(orig,copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key,orig_value in next,orig,nil do
                copy[deepcopy(orig_key,copies)] = deepcopy(orig_value,copies)
            end
            setmetatable(copy,deepcopy(getmetatable(orig),copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
