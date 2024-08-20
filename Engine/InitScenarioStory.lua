require("SimRailCore")
require("Engine/Enums")
require("Engine/Utils/CallAsCoroutine")
require("Engine/Utils/Common")
require("Engine/Utils/CreatePlayerRadioCallTrigger")
require("Engine/Utils/CreatePlayerTrigger")
require("Engine/Utils/CreateRandomCargoCars")
require("Engine/Utils/CreateStaticTrainset")
require("Engine/Utils/CreateTrainset")
require("Engine/Utils/CreateTrainTrigger")
require("Engine/Utils/CreateVehicles")
require("Engine/Utils/Debug")
require("Engine/Utils/GetSetValue")
require("Engine/Utils/GetSignalOrTrackRef")
require("Engine/Utils/JoinTrainStates")
require("Engine/Utils/RadioCall")
require("Engine/Utils/RadioCheckCall")
require("Engine/Utils/RadioDepartureCall")
require("Engine/Utils/RadioPlayerCall")
require("Engine/Utils/RadioPlayerCopyCall")
require("Engine/Utils/RadioPlayerCopySideTrackCall")
require("Engine/Utils/ScenarioDateTime")
require("Engine/Utils/SetRoute")
require("Engine/Utils/SpawnPlayerTrainset")
require("Engine/Utils/TriggerTrainState")
require("Engine/Utils/WaitUntil")
require("Engine/Utils/WaitUntilVDReady")

RegisterValue("_playerRadioCalls", {})
RegisterValue("_staticTrains", {})
RegisterValue("_spawnedStaticTrainsetsCount", 0)
RegisterValue("_trainStates", {})
RegisterValue("_trainStatesByTrainsetName", {})
RegisterValue("_autoDespawnTrainstates", {})
RegisterValue("_spawnedTrainsetsCount", 0)
RegisterValue("_radioCallWorkingIndex", 0)
RegisterValue("_commonRadioCalls", {})
RegisterValue("_isRadioCallQueueWorking", false)

RegisterValue("_vdReady", false)
RegisterValue("_vdOrderStorage", {})

RegisterValue("_scenarioDate", {
        year = 0001,
        month = 01,
        day = 01
    }
)

function InitScenarioStory(scenarioStory)
    if (type(scenarioStory.staticTrains) == "table") then
        for k, v in pairs(scenarioStory.staticTrains) do
            CreateStaticTrainset(v[1], v[2], v[3], v[4])
        end
    end

    if (type(scenarioStory.aiTrains) == "table") then
        for k, v in pairs(scenarioStory.aiTrains) do
            CreateTrainset(k, v[1], v[2], false)
        end
    end

    if (type(scenarioStory.radioCalls) == "table") then
        for k, v in pairs(scenarioStory.radioCalls) do
            CreatePlayerRadioCallTrigger(k, v)
        end
    end

    if (type(scenarioStory.playerEvents) == "table") then
        for k, v in pairs(scenarioStory.playerEvents) do
            CreatePlayerTrigger(v[1], v[2], v[3], v[4])
        end
    end

    if (type(scenarioStory.trainEvents) == "table") then
        for k, v in pairs(scenarioStory.trainEvents) do
            CreateTrainTrigger(v[1], v[2], v[3], v[4])
        end
    end

    if (type(scenarioStory.trainStateTriggers) == "table") then
        for k, v in pairs(scenarioStory.trainStateTriggers) do
            TriggerTrainState(v[1], v[2], v[3], v[4])
        end
    end
end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function MathDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    return math.sqrt(dx * dx + dy * dy)
end

function SpawnDespawnStaticTrainsets()
    local staticTrains = GetRef("_staticTrains")

    for k, v in pairs(staticTrains) do
        local playerPosition = GetSquarePosition(WorldMoverUnmove(GetPlayerController().transform.position))
        local square = v:GetSquarePosition()

        if (MathDistance(playerPosition.x, playerPosition.y, square.x, square.y) < 4) then
            v:Spawn()
        else
            v:Despawn()
        end
    end
end

--- The game callback
---@param x integer Position X
---@param z integer Position Z
---@param sceneGO GameObject Reference to scene's main object
function OnSquareLoaded(x, z, sceneGO)
    -- Log("load: " .. x .. " x " .. z)
    SpawnDespawnStaticTrainsets()
end

--- The game callback
---@param x integer Position X
---@param z integer Position Z
function OnSquareUnloaded(x, z)
    local autoDespawnTrainstates = GetRef("_autoDespawnTrainstates")

    for k, v in pairs(autoDespawnTrainstates) do
        if v:GetTrainset() ~= nil then
            local square = GetSquarePositionForTrainset(v:GetTrainset())

            if (MathDistance(x, z, square.x, square.y) < 4) then
                v:MarkAsDespawnable()
            else
                v:Despawn()
            end
        end
    end

    SpawnDespawnStaticTrainsets()
end

function OnVirtualDispatcherReady()
    Log("VD is ready")
    SetValue("_vdReady", true)
end

--- Function called by SimRail when VD responds to VD request
---@param orderId integer Request order ID to which it VD responded
---@param status  VDReponseCode Response that VD has sent
function OnVirtualDispatcherResponseReceived(orderId, status)
    local orderLog = GetOrderStorageLog(orderId)

    -- not accepted
    if status == VDReponseCode.Error then
        if not orderLog.retry then
            return
        end

        -- retry
        CallAsCoroutine(
            function ()
                coroutine.yield(CoroutineYields.WaitForSeconds, 30)
            end,
            nil,
            function ()
                -- Log(orderLog.from .. " => " .. orderLog.to .. " [T, R]")
                -- local retriedOrderId = VDSetRoute(orderLog.from, orderLog.to, orderLog.type)
                local retriedOrderId = orderLog.order()
                UpdateOrderStorageLog(orderId, retriedOrderId)
            end
        )
    elseif status == VDReponseCode.Accepted then
        -- accepted
        if type(orderLog.callback) == "function" then
            -- Log("Calling callback")
            CallAsCoroutine(orderLog.callback, status)
        -- else
        --     Error("Callback isn't a function")
        end

        DeleteOrderStorageLog(orderId)
    end
end

function OnTrainsetsSplit(oldTrainset, newTrainset)
    -- Log("Name of old trainset: " .. oldTrainset.name)
    -- Log("Name of new trainset: " .. newTrainset.name)
    
    local oldTrainState = GetTrainStateByTrainsetName( oldTrainset.name )
    
    -- if oldTrainState == nil then
    --     Log("Old Trainstate not found")
    -- end

    oldTrainState:DetachTrainStateFromSelf(oldTrainset, newTrainset)
end

---@param builtTrainset TrainsetInfo
---@param destroyedTrainset TrainsetInfo
function OnTrainsetsJoined(builtTrainset, destroyedTrainset)
    -- Log("Name of destroyed trainset: " .. destroyedTrainset.name)
    -- Log("Name of built trainset: " .. builtTrainset.name)
    
    local destroyedTrainState = GetTrainStateByTrainsetName( destroyedTrainset.name )
    local builtTrainState = GetTrainStateByTrainsetName( builtTrainset.name )

    -- if builtTrainState == nil then
    --     Log("Built Trainstate not found")
    -- elseif destroyedTrainState == nil then
    --     Log("Destroyed Trainstate not found")
    -- end

    builtTrainState:AttachTrainStateToSelf( destroyedTrainState )
end