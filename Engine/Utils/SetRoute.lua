---@param signals table<string>              The table with signals as string
---@param callback? function|nil             A callback to call when VD responds to request. It accepts VDResponseCode object as argument.
---@param sequential? boolean|nil            Default: true. Whether to request subroutes one by one, only when the previous gets accepted.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetTrainRoute(signals, callback, sequential, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end
    if sequential == nil then
        sequential = true
    end

    local callbackFirstIteration = callback

    local prev = nil
    local orderId = nil
    local order = nil

    for k, nextSignal in pairs(signals) do
        local prevSignal = prev

        if (not sequential and k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [T]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.TrainRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    order    = order,
                    callback = callbackFirstIteration,
                    retry    = repeatUntilSuccessful
                }
            )

            callbackFirstIteration = nil
        elseif (sequential and k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [T, S]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.TrainRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    order    = order,
                    callback = function ()
                        if type(callbackFirstIteration) == "function" then
                            callbackFirstIteration() 
                        end

                        local t1, t2 = table.split(signals, k - 1)

                        SetTrainRoute(t2, nil, true, repeatUntilSuccessful)
                    end,
                    retry    = repeatUntilSuccessful
                }
            )

            break
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
---@param sequential? boolean|nil            Default: true. Whether to request subroutes one by one, only when the previous gets accepted.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetShuntingRoute(signals, callback, sequential, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end
    if sequential == nil then
        sequential = true
    end

    local callbackFirstIteration = callback

    local prev = nil
    local orderId = nil
    local order = nil

    for k, nextSignal in pairs(signals) do
        local prevSignal = prev

        if (not sequential and k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [M]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.ManeuverRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    order    = order,
                    callback = callbackFirstIteration,
                    retry    = repeatUntilSuccessful
                }
            )

            callbackFirstIteration = nil
        elseif (sequential and k > 1 and prevSignal ~= nil) then
            order = function ()
                Log(prevSignal .. " => " .. nextSignal .. " [M, S]")
                return VDSetRoute(prevSignal, nextSignal, VDOrderType.ManeuverRoute)
            end
            orderId = order()

            AddOrderStorageLog(
                orderId, 
                {
                    order    = order,
                    callback = function ()
                        if type(callbackFirstIteration) == "function" then
                            callbackFirstIteration() 
                        end

                        local t1, t2 = table.split(signals, k - 1)

                        SetShuntingRoute(t2, nil, true, repeatUntilSuccessful)
                    end,
                    retry    = repeatUntilSuccessful
                }
            )

            break
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