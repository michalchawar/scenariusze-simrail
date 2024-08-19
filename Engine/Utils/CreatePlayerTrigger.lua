---@param signalOrTrack string Signal in front of which to spawn a train
---@param distance number Distance from the signal
---@param callback function Callback function
---@param checkFunction? function|nil Optional. Function, that determines, whether the callback should be executed when the trigger is applied. When it returns true, the callback is run and the trigger is removed. The function accepts triggering trainset as the argument.
function CreatePlayerTrigger(signalOrTrack, distance, callback, checkFunction)
    if checkFunction == nil then
        checkFunction = function(trainset)
            return true
        end
    end

    local type, ref = GetSignalOrTrackRef(signalOrTrack);
    local checker = {
        check = function(trainset)
            return trainset.name == GetPlayerTrainset().name and checkFunction(trainset)
        end,
        result = function()
            CallAsCoroutine(callback)
        end
    }

    if (type == "track") then
        CreateTrackTrigger(ref, distance, 0, checker)
    elseif (type == "signal") then
        CreateSignalTrigger(ref, distance, checker)
    end
end