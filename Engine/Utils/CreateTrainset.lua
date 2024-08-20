---@class TrainsetMachineState
local TrainsetMachineState = {}

--- Gets TrainState's name
---@return string
function TrainsetMachineState:GetTrainStateName() end

--- Gets TrainState's composite trainsetInfo
---@return TrainsetInfo
function TrainsetMachineState:GetTrainset() end

--- Gets array of enum vehicles, that this TrainState consists of
---@return table<PassengerCars | CargoCars | Locomotives | EZT>
function TrainsetMachineState:GetVehicleList() end

--- Gets array of TrainStates that have been incorporated into this TrainState
---@return table<TrainsetMachineState>
function TrainsetMachineState:GetSubTrainStates() end

--- Gets information whether the TrainState is currently in another TrainState
---@return boolean
function TrainsetMachineState:IsAttached() end

--- Gets information whether the TrainState is a player vehicle
---@return boolean
function TrainsetMachineState:IsPlayerVehicle() end

--- Gets information whether the TrainState has dummy physics
---@return boolean
function TrainsetMachineState:IsDummy() end

--- Gets information of TrainState's default TrainsetState
---@return TrainsetState
function TrainsetMachineState:GetTrainsetState() end

--- Sets information of TrainState's default TrainsetState and changes it if it is spawned
---@param trainState TrainsetState Target trainset state.
function TrainsetMachineState:SetTrainsetState(trainState) end

--- Gets information of TrainState's default brake regime
---@return TrainsetState
function TrainsetMachineState:GetBrakeRegime() end

--- Allows this TrainState to automatically despawn when out of render distance; works only for non-player vehicles
function TrainsetMachineState:MarkAsDespawnable() end

--- Disallows automatical despawn of this TrainState when out of render distance
function TrainsetMachineState:DisableAutoDespawn() end

--- Sets a despawn trigger for this TrainState; player vehicles and attached trainsets cannot be despawned this way
---@param signalOrTrackName string A signal or track name
---@param distance          integer|nil Default: 100. Distance from signal or position on track, where to despawn the trainset
function TrainsetMachineState:DespawnAt(signalOrTrackName, distance) end

--- Despawns this TrainState; player vehicles and attached trainsets cannot be despawned this way
function TrainsetMachineState:Despawn() end

--- Spawns trainset
---@param signalOrTrackName string  A signal or track name
---@param distance number           Distance from specified signal or track to spawn the trainset at
---@param dynamics DynamicState     The dynamic state of spawning trainset
---@param state TrainsetState       The trainset state of spawning trainset
---@param async? boolean            Default: true. Whether to spawn the trainset asynchroniously
---@param reversed? boolean         Default: false. Whether to spawn the trainset in reversed order
---@param dummyPhysics? boolean     Default: true. Whether the trainset should use simplified physics
---@param teleportToCabin? boolean  Default: false. Whether to teleport the player to the cabin once the trainset spawns. Works only for player trainsets
---@param brakeRegime? BrakeRegime  Default: BrakeRegime.None. What brake regime should be applied to spawned vehicles
function TrainsetMachineState:SpawnAt(signalOrTrackName, distance, dynamics, state, async, reversed, dummyPhysics, teleportToCabin, brakeRegime) end

--- Triggers next stage of this TrainState
function TrainsetMachineState:NextState() end

--- Respawns TrainState in the same place with reverse order of vehicles (which are also reversed)
function TrainsetMachineState:SwitchDirection() end

--- Expands the TrainState with specified vehicles at the end. Respawns the trainset. Use only for non-player trainsets
---@param newVehicles table<PassengerCars | CargoCars | Locomotives | EZT>  Array of vehicles to attach to the end of trainset
---@param trainsetState? TrainsetState   Default: TrainsetState.tsTrain. The trainset state to apply to the respawned trainset
---@param length? number                 Default: 0. I don't really remember what it does
function TrainsetMachineState:AttachVehiclesToEnd(newVehicles, trainsetState, length) end

--- Splits the TrainState, creating one new and respawning both. Use only for non-player trainsets
---@param numberOfVehicles integer      Number of vehicles to detach, counting from the end of trainset
---@param newName? string               Default: '<OriginalTrainStateName>-Detached'. Name to apply to the created TrainState
---@param trainsetState? TrainsetState  Default: TrainsetState.tsTrain. The trainset state to apply to the respawned trainset
---@param dummyPhysics? boolean         Default: true. Whether the detached trainset should use simplified physics
---@param brakeRegime? BrakeRegime      Default: BrakeRegime.None. What brake regime should be applied to detached vehicles
function TrainsetMachineState:DetachVehiclesFromEnd(numberOfVehicles, newName, trainsetState, dummyPhysics, brakeRegime) end

--- Marks this TrainState as a part of another one. Use only for non-player trainsets
function TrainsetMachineState:AttachSelf() end

--- Marks this TrainState as an independent trainset. Use only for non-player trainsets
---@param newTrainset TrainsetInfo The trainset that has been created in OnTrainsetsSplit() to set as this TrainState's trainset
---@param vehicles    table<PassengerCars | CargoCars | Locomotives | EZT>  Array of enum vehicles that specified trainset is built of
function TrainsetMachineState:DetachSelf(newTrainset, vehicles) end

--- Extends this TrainState with another TrainState. Use only for player trainsets
---@param targetTrainState TrainsetMachineState Non-player TrainState to incorporate into this TrainState
function TrainsetMachineState:AttachTrainStateToSelf(targetTrainState) end

--- Detaches last attached TrainState from this TrainState. Use only for player trainsets
---@param remainingTrainset TrainsetInfo    The trainset that should stay as this TrainState's trainset
---@param detachedTrainset  TrainsetInfo    The trainset that has been detached
function TrainsetMachineState:DetachTrainStateFromSelf(remainingTrainset, detachedTrainset) end

--- Registers a TrainState of type TrainsetMachineState
---@param name string The train name
---@param vehicles table<PassengerCars | CargoCars | Locomotives | EZT> Array that builds up a trainset
---@param stages table<function<TrainsetMachineState>> Array with stages
---@param isPlayerVehicle boolean Whether spawned trainState should belong to player
function CreateTrainset(name, vehicles, stages, isPlayerVehicle)
    if isPlayerVehicle == nil then
        isPlayerVehicle = false
    end
    
    local trainState = {
        _index = 1,
        _name = name,
        _trainset = nil,
        _vehicleList = vehicles,
        _disableAutoDespawn = false,
        _despawnable = false,
        _attached = false,
        _isPlayerVehicle = isPlayerVehicle,
        _isDummy = true,
        _trainsetState = TrainsetState.tsTrain,
        _brakeRegime = BrakeRegime.None,
        _subTrainStates = {},
        GetTrainStateName = function(self)
            return self._name
        end,
        GetTrainset = function(self)
            return self._trainset
        end,
        GetVehicleList = function(self)
            return self._vehicleList
        end,
        GetSubTrainStates = function(self)
            return self._subTrainStates
        end,
        IsAttached = function(self)
            return self._attached
        end,
        IsPlayerVehicle = function(self)
            return self._isPlayerVehicle
        end,
        IsDummy = function(self)
            return self._isDummy
        end,
        GetTrainsetState = function(self)
            return self._trainsetState
        end,
        SetTrainsetState = function(self, trainsetState)
            self._trainsetState = trainsetState

            if self._trainset ~= nil then
                self._trainset.SetState(DynamicState.dsStop, trainsetState, false)
            end
        end,
        GetBrakeRegime = function(self)
            return self._brakeRegime
        end,
        MarkAsDespawnable = function(self)
            self._despawnable = true
        end,
        DisableAutoDespawn = function(self)
            if (HasValue("_autoDespawnTrainstates", self._name)) then
                DeleteValue("_autoDespawnTrainstates", self._name)
            end

            self._disableAutoDespawn = true
        end,
        DespawnAt = function(self, signalOrTrackName, distance)
            local type, ref = GetSignalOrTrackRef(signalOrTrackName);
            local checker = {
                check = function(trainset)
                    return trainset.name == self:GetTrainset().name;
                end,
                result = function()
                    self:Despawn()
                end,
            }

            self:DisableAutoDespawn()

            if distance == nil then
                distance = 100
            end

            if (type == "track") then
                CreateTrackTrigger(ref, distance, 0, checker)
            elseif (type == "signal") then
                CreateSignalTrigger(ref, distance, checker)
            end
        end,
        Despawn = function(self)
            if (self._disableAutoDespawn == false and self._despawnable == false) then
                Log("Ommiting despawn")
                return
            end

            if (self._attached or self._isPlayerVehicle) then
                Log("Can't despawn attached/player trainState " .. self._name)
                return
            end

            Log("Despawn AI train: " .. self._name)
            
            DecrValue("_spawnedTrainsetsCount")
            DespawnTrainset(self:GetTrainset())
            
            self:DisableAutoDespawn()
            
            -- DeleteValue("_trainStates", self._name)
            if HasValue("_trainStatesByTrainsetName", self._trainset.name) then
                DeleteValue("_trainStatesByTrainsetName", self._trainset.name)
            end
        end,
        SpawnAt = function(self, signalOrTrackName, distance, dynamics, state, async, reversed, dummyPhysics, teleportToCabin, brakeRegime)
            -- Log("Wywołano SpawnAt()")
            if (self._attached) then
                Log("Can't spawn attached trainState " .. self._name)
                return
            end
            
            if (async == nil) then
                async = true
            end
            if (reversed == nil) then
                reversed = false
            end
            if (dummyPhysics == nil) then
                dummyPhysics = self._isDummy
            end
            if (teleportToCabin == nil or not self._isPlayerVehicle) then
                teleportToCabin = false
            end
            if (brakeRegime == nil) then
                brakeRegime = self._brakeRegime
            end
            
            local type, ref = GetSignalOrTrackRef(signalOrTrackName)
            local onSpawn = function(trainset)
                if (trainset == nil) then
                    Error("Error while creating the trainset for " .. self._name)

                    return
                end

                self._trainset = trainset
                self._isDummy = dummyPhysics

                SetValue("_trainStatesByTrainsetName", trainset.name, self)

                if not self._isPlayerVehicle then
                    IncValue("_spawnedTrainsetsCount")

                    if (self._disableAutoDespawn == false) then
                        SetValue("_autoDespawnTrainstates", self._name, self)
                    end
                end

                if (dynamics == nil) then
                    dynamics = DynamicState.dsStop
                end
                if (state == nil) then
                    Log("Setting default trainsetState")
                    state = self._trainsetState
                end

                Log("Spawning state: " .. 10 + state)

                trainset.SetState(dynamics, state, true)
                
                self._trainsetState = state

                local timetable = LoadTimetableFromFile(self._name .. ".xml")

                if (timetable ~= nil) then
                    trainset.SetTimetable(timetable, false)
                end
            end

            if (distance == nil) then
                distance = 0
            end

            Log("Spawn " .. (self._isPlayerVehicle and "Player" or "AI") .. " train: " .. self._name)

            if (type == "track") then
                if (async and not self._isPlayerVehicle) then
                    Log("Spawning on track async")
                    SpawnTrainsetAsync(self._name, ref, distance, false, self._isPlayerVehicle, dummyPhysics, CreateVehicles(self._vehicleList, reversed, brakeRegime), onSpawn)
                else
                    Log("Spawning on track sync")
                    local created = SpawnTrainset(self._name, ref, distance, false, self._isPlayerVehicle, dummyPhysics, teleportToCabin, CreateVehicles(self._vehicleList, reversed, brakeRegime))
                    onSpawn(created)
                end
            elseif (type == "signal") then
                if (async and not self._isPlayerVehicle) then
                    Log("Spawning on signal async")
                    SpawnTrainsetOnSignalAsync(self._name, ref, distance, false, self._isPlayerVehicle, dummyPhysics, CreateVehicles(self._vehicleList, reversed, brakeRegime), onSpawn)
                else
                    Log("Spawning on signal sync")
                    local created = SpawnTrainsetOnSignal(self._name, ref, distance, reversed, self._isPlayerVehicle, dummyPhysics, teleportToCabin, CreateVehicles(self._vehicleList, reversed, brakeRegime))
                    onSpawn(created)
                end
            end
        end,
        NextState = function(self)
            if (self._attached) then
                return
            end

            Log(self._name .. ": Entered next state, index = " .. self._index)

            local stageCallee = stages[self._index];

            if stageCallee == nil then
                Log("Nil stageCallee")
                return
            end

            self._index = self._index + 1

            Log("Calling stageCallee")

            CallAsCoroutine(stageCallee, self)
        end,
        SwitchDirection = function(self)
            if (self._attached or self._isPlayerVehicle) then
                Error("Can't forcefully switch direction of attached/player trainState " .. self._name)
                return
            end

            local trainDesc = GetTrainsetDesc(self._trainset)

            if (trainDesc.pos.speed ~= 0) then
                Error("Can't switch direction of moving trainset: " .. self._name)
            end
            
            local signalName = trainDesc.pos.lastSignal
            local distanceToSignal = trainDesc.pos.lastDistanceToSignal or trainDesc.pos.signalDistance

            -- Log("Switching direction")
            -- Log("Despawning original train")
            self:Despawn()
            -- Log("Spawning reversed train")
            self:SpawnAt(signalName, distanceToSignal, DynamicState.dsStop, self._trainsetState, false, true)
            self:DisableAutoDespawn()
        end,
        AttachVehiclesToEnd = function(self, newVehicles, trainsetState, length)
            if (self._attached or self._isPlayerVehicle) then
                Error("Can't attach vehicles to the end of attached/player trainState " .. self._name)
                return
            end
            
            if (trainsetState == nil) then
                trainsetState = TrainsetState.tsTrain
            end
            if (length == nil) then
                length = 0
            end

            local trainDesc = GetTrainsetDesc(self._trainset)

            if (trainDesc.pos.speed ~= 0) then
                Error("Can't attach to moving trainset: " .. self._name)
            end

            local newTrainsetVehicles = self._vehicleList
            
            for i = 1, #newVehicles, 1 do
                newTrainsetVehicles[ #newTrainsetVehicles + 1 ] = newVehicles[i]
            end

            self._vehicleList = newTrainsetVehicles
            
            local signalName = trainDesc.pos.lastSignal
            local distanceToSignal = trainDesc.pos.lastDistanceToSignal or trainDesc.pos.signalDistance
            -- local distanceToSignal = trainDesc.pos.signalDistance

            -- Log("Attaching " .. #newVehicles .. " vehicles at the end of " .. self._name)
            -- Log("Found signal " .. signalName)
            -- Log("Signal is at distance of " .. distanceToSignal)

            -- Log("Despawning original train")
            self:Despawn()
            -- Log("Spawning lengthened train")
            -- self:SpawnAt(signalName, distanceToSignal - length, DynamicState.dsStop, TrainsetState.tsDeactivation, false, true)
            self:SpawnAt(signalName, distanceToSignal, DynamicState.dsStop, trainsetState, false, false)
            self:DisableAutoDespawn()
            -- CallAsCoroutine(function ()
            --     coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            --     self:SetTrainsetState(trainsetState)
            -- end)
        end,
        DetachVehiclesFromEnd = function(self, numberOfVehicles, newName, trainsetState, dummyPhysics, brakeRegime)
            if (self._attached or self._isPlayerVehicle) then
                Error("Can't detach vehicles from the end of attached/player trainState " .. self._name)
                return
            end
            
            if (trainsetState == nil) then
                trainsetState = TrainsetState.tsTrain
            end
            if (dummyPhysics == nil) then
                dummyPhysics = true
            end
            if (brakeRegime == nil) then
                brakeRegime = BrakeRegime.None
            end

            local trainDesc = GetTrainsetDesc(self._trainset)

            if (trainDesc.pos.speed ~= 0) then
                Error("Can't detach from moving trainset: " .. self._name)
            end

            -- if ( numberOfVehicles > self._trainset. )
            local firstTrainsetVehicles, secondTrainsetVehicles = table.split(self._vehicleList, #self._vehicleList - numberOfVehicles)
            local signalName = trainDesc.pos.lastSignal
            local distanceToSignal = trainDesc.pos.lastDistanceToSignal or trainDesc.pos.signalDistance
            distanceToSignal = math.floor(distanceToSignal) - 1

            -- Log("Detaching " .. numberOfVehicles .. " vehicles from the end of " .. self._name)

            self._vehicleList = firstTrainsetVehicles
            -- Log("Despawning original train")
            self:Despawn()
            -- Log("Spawning shortened train")
            self:SpawnAt(signalName, distanceToSignal, DynamicState.dsStop, TrainsetState.tsTrain, false)

            -- Log("Creating detached vehicles")
            CreateTrainset(
                newName or self._name .. "_Detached", 
                secondTrainsetVehicles, 
                {
                    ---@param trainState TrainsetMachineState
                    function (trainState)
                        trainState:SpawnAt( signalName, distanceToSignal + self._trainset.trainsetLenght + 1, DynamicState.dsDecEmergency, trainsetState, false, false, dummyPhysics, false, brakeRegime )
                        trainState:DisableAutoDespawn()
                    end,
                },
                false
            )
            -- Log("Detached")
        end,
        AttachSelf = function(self)
            if self._isPlayerVehicle then
                Error("Can't attach player trainState to the end of another trainState " .. self._name)
            end
            
            local oldTrainset = self._trainset

            self._attached = true
            self._trainset = nil
            self._vehicleList = {}

            if (HasValue("_autoDespawnTrainstates", self._name)) then
                DeleteValue("_autoDespawnTrainstates", self._name)
            end
            if (HasValue("_trainStatesByTrainsetName", oldTrainset.name)) then
                DeleteValue("_trainStatesByTrainsetName", oldTrainset.name)
            end

            DecrValue("_spawnedTrainsetsCount")
        end,
        DetachSelf = function(self, newTrainset, vehicles)
            if self._isPlayerVehicle then
                Error("Can't detach player trainState to the end of another trainState " .. self._name)
            end

            self._attached = false
            self._trainset = newTrainset
            self._vehicleList = vehicles

            if (self._disableAutoDespawn == false) then
                SetValue("_autoDespawnTrainstates", self._name, self)
            end
            SetValue("_trainStatesByTrainsetName", self._trainset.name, self)

            IncValue("_spawnedTrainsetsCount")
        end,
        AttachTrainStateToSelf = function(self, targetTrainState)
            self._subTrainStates[ #self._subTrainStates + 1 ] = targetTrainState;
            self._vehicleList = table.extend(self._vehicleList, targetTrainState:GetVehicleList())

            targetTrainState:AttachSelf()
        end,
        DetachTrainStateFromSelf = function(self, remainingTrainset, detachedTrainset)
            local remainingVehicleList, detachedVehicleList = table.split(self._vehicleList, #remainingTrainset.Vehicles)

            self._vehicleList = remainingVehicleList
            
            local detachedTrainState = nil
            
            if not table.empty(self._subTrainStates) then
                detachedTrainState = table.remove(self._subTrainStates, #self._subTrainStates)
            else 
                detachedTrainState = CreateTrainset( self._name .. "-Detached-" .. string.sub(GenerateUID(), 0, 3), detachedVehicleList, {}, false )
            end
            
            -- if #self.remainingVehicleList == 1 then
            --     self._subTrainStates = {}
            -- end

            detachedTrainState:DetachSelf(detachedTrainset, detachedVehicleList)
        end,
    }

    
    SetValue("_trainStates", name, trainState)
    
    trainState:NextState()
end