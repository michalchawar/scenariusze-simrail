---@param signals table<string>              The table with signals as string
---@param callback? function|nil             A callback to call when VD responds to request. It accepts VDResponseCode object as argument.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetTrainRoute(signals, callback, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end

    local callbackFirstIteration = callback

    local prev = nil
    local orderId = nil
    local order = nil

    for k, nextSignal in pairs(signals) do
        local prevSignal = prev

        if (k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [T]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.TrainRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    -- from     = prevSignal,
                    -- to       = nextSignal,
                    -- type     = VDOrderType.ManeuverRoute,
                    order    = order,
                    callback = callbackFirstIteration,
                    retry    = repeatUntilSuccessful
                }
            )

            callbackFirstIteration = nil
        end

        if (string.match(nextSignal, "kps$") == nil) then
            prev = nextSignal
        else
            prev = nil
        end
    end

    return orderId
end

---@param signals table<string>              The table with signals as string
---@param callback? function|nil             A callback to call when VD responds to request. It accepts VDResponseCode object as argument.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetShuntingRoute(signals, callback, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end

    local callbackFirstIteration = callback

    local prev = nil
    local orderId = nil
    local order = nil

    for k, nextSignal in pairs(signals) do
        local prevSignal = prev

        if (k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [M]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.ManeuverRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    -- from     = prevSignal,
                    -- to       = nextSignal,
                    -- type     = VDOrderType.ManeuverRoute,
                    order    = order,
                    callback = callbackFirstIteration,
                    retry    = repeatUntilSuccessful
                }
            )

            callbackFirstIteration = nil
        end

        if (string.match(nextSignal, "kps$") == nil) then
            prev = nextSignal
        else
            prev = nil
        end
    end

    return orderId
end

---@param switchName string                  Name of the switch.
---@param plus boolean                       Whether to set the switch in the plus position
---@param callback? function|nil             A callback to call when VD responds to request. It accepts VDResponseCode object as argument.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetSwitchPosition(switchName, plus, callback, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end

    local order = function ()
        if plus then
            Log(switchName .. " [+]")
        else
            Log(switchName .. " [-]")
        end

        return VDSetSwitchPosition(switchName, plus)
    end
    local orderId = order()

    AddOrderStorageLog(
        orderId, 
        {
            order    = order,
            callback = callback,
            retry    = repeatUntilSuccessful
        }
    )

    return orderId
end