--- Send the voice message throughout the radio
--- @param key string The sound name to play
--- @param ignoreChannelsCheck boolean | nil If `true` the radio channel will not be checked when trying to play sound
function RadioCall(key, ignoreChannelsCheck)
    if (ignoreChannelsCheck == nil) then
        ignoreChannelsCheck = false
    end

    IncValue("_radioCallWorkingIndex")
    SetValue("_commonRadioCalls", GetValue("_radioCallWorkingIndex"), function()
        -- if not sitting in cabin then return
        if (
            GetCameraView() == CameraView.FirstPersonWalkingOutside or
            GetCameraView() == CameraView.FirstPersonWalkingCar or
            GetCameraView() == CameraView.FirstPersonWalkingIndoor or
            (ignoreChannelsCheck == false and GetPlayerTrainset().GetCurrentlyUsedChannel() ~= GetPlayerTrainset().GetIntendedRadioChannel())
        ) then
            return
        end

        DisplayChatText(key)

        if (Sounds[key] ~= nil) then
            PlayNarrationAudioClip(key)
            coroutine.yield(CoroutineYields.WaitForAudioFinishedPlaying, key)
        end
    end)

    if (GetValue("_radioCallWorkingIndex") > 0 and GetValue("_isRadioCallQueueWorking") == false) then
        SetValue("_isRadioCallQueueWorking", true)
        local index = 1

        while(true) do
            local radioCall = GetValue("_commonRadioCalls", index)

            if (radioCall == nil) then
                break
            end

            local co = coroutine.create(radioCall)

            while(true) do
                coroutine.yield(CoroutineYields.WaitFrames, 1)

                local success, caseType, value = coroutine.resume(co)

                if (success == true and caseType ~= nil) then
                    coroutine.yield(caseType, value)
                else
                    break
                end
            end

            index = index + 1
        end

        ClearValue("_commonRadioCalls")
        SetValue("_radioCallWorkingIndex", 0)
        SetValue("_isRadioCallQueueWorking", false)
    end
end