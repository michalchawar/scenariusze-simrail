--- Send the departure radio message throughout the radio
--- @param trainName string | nil The train name to trigger the radio departure call
function RadioDepartureCall(trainName)
    local soundBank = "TM_departure_call"

    if (trainName ~= nil) then
        soundBank = "TM_" .. trainName .. "_departure_call"
    end

    if (IsValueRegistered(soundBank) == false) then
        RegisterValue(soundBank, 0)

        for k, v in pairs(Sounds) do
            if (string.match(k, "^" .. soundBank)) then
                IncValue(soundBank)
            end
        end
    end

    local soundKey = soundBank .. "_" .. GetRandomInt(1, GetValue(soundBank) + 1)

    RadioCall(soundKey, true)
end