---@param condition function The condition as function
function WaitUntil(condition)
    while (true) do
        coroutine.yield(CoroutineYields.WaitForSeconds, 1)

        if (condition() == true) then
            break
        end
    end
end