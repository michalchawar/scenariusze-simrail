---@param signalOrTrack SignalNetworkHolder|Track The signal or track name where the trigger is applied
---@param stages table<function> The radio call stages to call
function CreatePlayerRadioCallTrigger(signalOrTrack, stages)
    if (HasValue("_playerRadioCalls", signalOrTrack)) then
        Log("The radio trigger is already registered.")
        return
    end

    SetValue("_playerRadioCalls", signalOrTrack, {
        lastCallIndex = 1,
        stages = stages,
        calls = 0,
        locked = false,
    })
end

--- The game callback
---@param trainset TrainsetInfo The trainset that call the radio
---@param zewCall integer ZEW call number
---@param channel integer Which radio channel was used
function OnPlayerRadioCall(trainset, zewCall, channel)
    -- Log("Player radio call registered, zew: " .. zewCall .. ", intended: " .. trainset.GetIntendedRadioChannel() .. ", used: " .. trainset.GetCurrentlyUsedChannel() .. " / " .. channel)

    if (zewCall ~= 3 or trainset.GetIntendedRadioChannel() ~= channel) then
        return
    end

    local signalAhead = GetTrainsetDesc(trainset).pos.lastSignal;
    local caller = GetValue("_playerRadioCalls", signalAhead);
    
    local currentStage = caller.stages[caller.lastCallIndex]
    -- Log("SignalAhead: " .. signalAhead)

    if caller ~= nil and caller.locked == false and currentStage ~= nil
    and (currentStage[2] == nil or ( type(currentStage[2]) == "function" and currentStage[2]() )) then
        caller.locked = true
        caller.calls = caller.calls + 1
        
        CallAsCoroutine(currentStage[1], caller.calls, function(result)
            if (result ~= false) then
                caller.calls = 0
                caller.lastCallIndex = caller.lastCallIndex + 1
            end

            caller.locked = false
        end)
    end
end