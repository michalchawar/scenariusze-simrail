require("SimRailCore")

GLOBAL_STATE_NAME = "scenarioState"
_G[GLOBAL_STATE_NAME] = {}

function RegisterValue(name, defaultValue)
    if (type(defaultValue) == "table") then
        _G[GLOBAL_STATE_NAME][name] = defaultValue
    else
        _G[GLOBAL_STATE_NAME][name] = { value = defaultValue }
    end
end

function IsValueRegistered(name)
    return _G[GLOBAL_STATE_NAME][name] ~= nil
end

function ClearValue(name, key)
    __PrintErrorIfNotRegistered(name)

    if (type(_G[GLOBAL_STATE_NAME][name]) == "table") then
        _G[GLOBAL_STATE_NAME][name] = {}
    else
        _G[GLOBAL_STATE_NAME][name] = { value = nil }
    end
end

function SetValue(name, key, value)
    __PrintErrorIfNotRegistered(name)

    if (value == nil) then
        value = key
        key = "value"
    end

    _G[GLOBAL_STATE_NAME][name][key] = value
end

function GetRef(name)
    __PrintErrorIfNotRegistered(name)

    return _G[GLOBAL_STATE_NAME][name]
end

function GetValue(name, key)
    __PrintErrorIfNotRegistered(name)

    if (key == nil) then
        key = "value"
    end

    return _G[GLOBAL_STATE_NAME][name][key]
end

function HasValue(name, key)
    __PrintErrorIfNotRegistered(name)

    if (key == nil) then
        key = "value"
    end

    return _G[GLOBAL_STATE_NAME][name][key] ~= nil
end

function DeleteValue(name, key)
    __PrintErrorIfNotRegistered(name)

    if (key == nil) then
        key = "value"
    end

    _G[GLOBAL_STATE_NAME][name][key] = nil
end

function IncValue(name)
    __PrintErrorIfNotRegistered(name)

    _G[GLOBAL_STATE_NAME][name]["value"] = _G[GLOBAL_STATE_NAME][name]["value"] + 1
end

function DecrValue(name)
    __PrintErrorIfNotRegistered(name)

    _G[GLOBAL_STATE_NAME][name]["value"] = _G[GLOBAL_STATE_NAME][name]["value"] - 1
end

function __PrintErrorIfNotRegistered(name)
    if (_G[GLOBAL_STATE_NAME][name] == nil) then
        Error("The collection (" .. name .. ") is not registered.")
    end
end