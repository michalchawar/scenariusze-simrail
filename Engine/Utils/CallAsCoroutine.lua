require("SimRailCore")

---@param func function Function to delegate the coroutine
---@param arg any | nil argument to pass to the function
---@param endCallback function | nil The function to call after the corouted function finishes its call
function CallAsCoroutine(func, arg, endCallback)
    CreateCoroutine(function()
        
        local co = coroutine.create(func)
        local result
        
        coroutine.yield(CoroutineYields.WaitFrames, 1)

        local success, caseType, value = coroutine.resume(co, arg)

        if (success == true) then
            while success == true do
                if (caseType == false) then
                    result = false
                    break
                end

                if (caseType == nil) then
                    break
                end

                if (type(caseType) == "table" and caseType.__yieldable == true) then
                    coroutine.yield(caseType.case, caseType.value)
                else
                    coroutine.yield(caseType, value)
                end

                success, caseType, value = coroutine.resume(co)
            end
        else
            result = caseType
        end

        if (endCallback ~= nil) then
            endCallback(result);
        end
    end)
end