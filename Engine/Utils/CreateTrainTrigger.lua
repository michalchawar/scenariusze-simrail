---@param trainName string The train name
---@param signalOrTrack string Signal or track name in front of which to spawn a train
---@param distance number Distance from the signal
---@param callback function Callback function
function CreateTrainTrigger(trainName, signalOrTrack, distance, callback)
    local type, ref = GetSignalOrTrackRef(signalOrTrack);
    local checker = {
        check = function(trainset)
            -- Log("In checker")
            local triggeringTrainState = GetTrainStateByTrainsetName(trainset.name)

            if triggeringTrainState == nil then
                -- Log("Nil triggeringTrainState in checker, trainset name: " .. trainset.name)
                return false
            -- else
                -- Log(triggeringTrainState:GetTrainStateName())
            end

            return trainName == triggeringTrainState:GetTrainStateName() and not triggeringTrainState:IsAttached()
        end,
        result = function()
            -- Log("Calling as callback coroutine")
            CallAsCoroutine(callback, GetTrainState(trainName):GetTrainset())
        end
    }

    if (type == "track") then
        CreateTrackTrigger(ref, distance, 0, checker)
    elseif (type == "signal") then
        CreateSignalTrigger(ref, distance, checker)
    end
end