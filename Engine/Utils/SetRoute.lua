-- ---@param signals table<string> The table with signals as string
-- function SetTrainRoute(signals)
--     local prevSignal = nil

--     for k, nextSignal in pairs(signals) do
--         if (k > 1 and prevSignal ~= nil) then
--             Log(prevSignal .. " => " .. nextSignal .. " [T]")
--             VDSetRoute(prevSignal, nextSignal, VDOrderType.TrainRoute)
--         end

--         if (string.match(nextSignal, "kps$") == nil) then
--             prevSignal = nextSignal
--         else
--             prevSignal = nil
--         end
--     end
-- end

---@param signals table<string>              The table with signals as string
---@param callback? function|nil             A callback to call when VD responds to request. It accepts VDResponseCode object as argument.
---@param repeatUntilSuccessful? boolean|nil Default: true. Whether to repeat the request every 30 seconds until it gets accepted.
---@return integer|nil
function SetTrainRoute(signals, callback, repeatUntilSuccessful)
    if repeatUntilSuccessful == nil then
        repeatUntilSuccessful = true
    end

    local prevSignal = nil
    local orderId = nil

    for k, nextSignal in pairs(signals) do
        if (k > 1 and prevSignal ~= nil) then
            Log(prevSignal .. " => " .. nextSignal .. " [T]")
            orderId = VDSetRoute(prevSignal, nextSignal, VDOrderType.TrainRoute)

            AddOrderStorageLog(
                orderId, 
                {
                    from     = prevSignal,
                    to       = nextSignal,
                    type     = VDOrderType.TrainRoute,
                    callback = callback,
                    retry    = repeatUntilSuccessful
                }
            )
        end

        if (string.match(nextSignal, "kps$") == nil) then
            prevSignal = nextSignal
        else
            prevSignal = nil
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

    local prevSignal = nil
    local orderId = nil

    for k, nextSignal in pairs(signals) do
        if (k > 1 and prevSignal ~= nil) then
            Log(prevSignal .. " => " .. nextSignal .. " [M]")
            orderId = VDSetRoute(prevSignal, nextSignal, VDOrderType.ManeuverRoute)

            AddOrderStorageLog(
                orderId, 
                {
                    from     = prevSignal,
                    to       = nextSignal,
                    type     = VDOrderType.ManeuverRoute,
                    callback = callbackFirstIteration,
                    retry    = repeatUntilSuccessful
                }
            )

            callbackFirstIteration = nil
        end

        if (string.match(nextSignal, "kps$") == nil) then
            prevSignal = nextSignal
        else
            prevSignal = nil
        end
    end

    return orderId
end