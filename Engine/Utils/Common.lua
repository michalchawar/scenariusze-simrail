require("SimRailCore")

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function table.split(tbl, lastIndexOfFirstTable)
    local tab1 = {}
    local tab2 = {}

    for i = 1, #tbl, 1 do
        if i <= lastIndexOfFirstTable then
            tab1[#tab1 + 1] = tbl[i]
        else
            tab2[#tab2 + 1] = tbl[i]
        end
    end

    return tab1, tab2
end

function table.reverse(tbl)
    local result = {}

    for i = 1, #tbl, 1 do
        result[ i ] = tbl[ #tbl - i + 1 ]
    end

    return result
end

function table.extend(tbl, collection)
    local result = tbl

    for i = 1, #collection, 1 do
        result[ #result + 1 ] = collection[ i ]
    end

    return result
end

function table.empty (tbl)
    for _, _ in pairs(tbl) do
        return false
    end
    return true
end

---@return TrainsetInfo
function GetPlayerTrainset() 
    return RailstockGetPlayerTrainset()
end

---@return TrainsetMachineState
function GetPlayerTrainState() 
    return GetTrainStateByTrainsetName(GetPlayerTrainset().name)
end

---@return Vehicle
function GetPlayerVehicle() 
    return RailstockGetPlayerVehicle()
end

---@return TrainDesc
function GetPlayerTrainDesc() 
    return GetTrainsetDesc(GetPlayerTrainset())
end

---@param name string The train name
---@return TrainsetMachineState
function GetTrainState(name) 
    return GetValue("_trainStates", name)
end

---@param trainsetName string The trainset name
---@return TrainsetMachineState
function GetTrainStateByTrainsetName(trainsetName) 
    return GetValue("_trainStatesByTrainsetName", trainsetName)
end

--- Waits for trainState to spawn. Call only in coroutine.
---@param trainState TrainsetMachineState TrainState to spawn
function WaitForTrainStateToSpawn(trainState)
    WaitUntil(function ()
        return trainState:GetTrainset() ~= nil
    end)
end

--- Structures and functions for managing routes and signals
-- --@field from     string       Signal, from which the order is issued
-- --@field to       string       Signal, to which the order is issued
-- --@field type     VDOrderType  Type of issued order

---@class OrderStorageEntry
---@field order    function     Function, that executes the order and returns its orderId (passed from VirtualDispatcher) 
---@field callback function|nil Callback to execute when the order gets accepted
---@field retry    boolean      Whether to repeat the request every 30 seconds until it gets accepted
local OrderStorageEntry = {}

--- Saves OrderStorageEntry object with corresponding orderId parameter
---@param orderId integer OrderID, corresponding to the order to retrieve info about
---@param entry   OrderStorageEntry Object to save in the storage
function AddOrderStorageLog(orderId, entry)
    SetValue("_vdOrderStorage", orderId, entry)
end

--- Returns OrderStorageEntry object corresponding to orderId parameter
---@param orderId integer OrderID, corresponding to the order to retrieve info about
---@return OrderStorageEntry
function GetOrderStorageLog(orderId)
    return GetValue("_vdOrderStorage", orderId)
end

--- Updates OrderStorageEntry object with new orderId
---@param oldOrderId integer OrderID of expired order storage log
---@param newOrderId integer OrderID of new order storage log
function UpdateOrderStorageLog(oldOrderId, newOrderId)
    if not HasValue("_vdOrderStorage", oldOrderId) then
        return
    end
    
    local log = GetValue("_vdOrderStorage", oldOrderId)
    SetValue("_vdOrderStorage", newOrderId, log)
    DeleteValue("_vdOrderStorage", oldOrderId)
end

--- Deletes OrderStorageEntry object corresponding to orderId parameter
---@param orderId integer OrderID, corresponding to the order to delete info about
function DeleteOrderStorageLog(orderId)
    DeleteValue("_vdOrderStorage", orderId)
end

--- Ends a scenario with MissionResultEnum.ScenarioProcedureFailed if current player vehicle speed exceeds given one
---@param maxSpeed integer Speed that when exceeded fails the mission
function FailMissionIfSpeedExceeds(maxSpeed)
    Log("Checking for speed (FailMission)")

    local playerVehicle = GetPlayerVehicle()

    if playerVehicle.velAbs > maxSpeed then
        FinishMission(MissionResultEnum.ScenarioProcedureFailed)
    end
end