---@param trainStateName1 string The main trainset name
---@param trainStateName2 string The secondary trainset name that will be attached to the end of the main one
---@param trainsetState? TrainsetState|nil State that will be applied to created trainset
function JoinTrainStates(trainStateName1, trainStateName2, trainsetState)
    local ts1 = GetTrainState(trainStateName1)
    local ts2 = GetTrainState(trainStateName2)

    if trainsetState == nil then
        trainsetState = TrainsetState.tsShunting
    end

    local vehicles = ts2:GetVehicleList()
    local length = ts2:GetTrainset().trainsetLenght

    CallAsCoroutine(function ()
        ts1:SwitchDirection()
        
        coroutine.yield(CoroutineYields.WaitFrames, 2)
        WaitUntil(function ()
            return ts1:GetTrainset() ~= nil
        end)

        ts2:Despawn()
        ts1:AttachVehiclesToEnd(vehicles, trainsetState, length)
    end)
end