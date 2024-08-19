--- Send the radio check message throughout the radio
--- @param trainName string The train name to trigger the radio check call
function RadioCheckCall(trainName)
    RadioCall(trainName .. "_radio_check")

    if (Sounds["TD_" .. trainName .. "_radio_check_ok"] ~= nil) then
        coroutine.yield(CoroutineYields.WaitForSeconds, GetRandomInt(1, 4))
        RadioCall("TD_" .. trainName .. "_radio_check_ok")

        if (Sounds[trainName .. "_radio_check_thanks"] ~= nil) then
            coroutine.yield(CoroutineYields.WaitForSeconds, GetRandomInt(1, 4))
            RadioCall(trainName .. "_radio_check_thanks")
        end
    end
end