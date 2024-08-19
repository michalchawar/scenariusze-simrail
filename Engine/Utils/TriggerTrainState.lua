---@param trainName string The train name the triggers will be applied to
---@param signalOrTrack string Signal or track name in front of which to trigger the states
---@param distance number The trigger distance
---@param trainNames table<string> The train names to which call the state after reaching the signal or track
function TriggerTrainState(trainName, signalOrTrack, distance, trainNames)
    local localCallback = function()
        for k, name in pairs(trainNames) do
            Log("In TriggerTrainState, name = " .. name)
            local trainState = GetTrainState(name);

            if (trainState == nil) then
                Error("The trainState (" .. name .. ") does not exist")
            else
                Log(name .. ": trying to next state")
                trainState:NextState()
            end
        end
    end

    if (trainName == "Player") then
        CreatePlayerTrigger(signalOrTrack, distance, localCallback)
    else
        CreateTrainTrigger(trainName, signalOrTrack, distance, localCallback)
    end
end