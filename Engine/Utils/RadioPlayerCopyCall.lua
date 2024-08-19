--- Send the copy radio message throughout the radio
function RadioPlayerCopyCall()
    local soundBank = "Player_copy_common"

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