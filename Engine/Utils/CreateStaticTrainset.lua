---@param signalOrTrackName string The train name
---@param distance number The spawn distance
---@param vehicles table<PassengerCars | CargoCars | Locomotives | EZT> Array that builds up a trainset
---@param onTrainsetSpawn function Function called after the train is spawn
function CreateStaticTrainset(signalOrTrackName, distance, vehicles, onTrainsetSpawn)
    local refType, ref = GetSignalOrTrackRef(signalOrTrackName)

    if (refType == "unknown") then
        Error("The signal or track does not exist")

        return
    end

    local squarePosition = GetSquarePosition(WorldMoverUnmove(ref.transform.position));
    local name = signalOrTrackName .. "-" .. string.sub(GenerateUID(), 0, 6);
    local trainState = {
        _spawned = false,
        _trainset = nil,
        _spawnPointType = refType,
        _spawnPointRef = ref,
        _squarePosition = Vector2Create(squarePosition.x, squarePosition.y),
        GetTrainset = function(self)
            return self._trainset
        end,
        GetSquarePosition = function(self)
            return self._squarePosition
        end,
        Despawn = function(self)
            if (self._spawned == false) then
                return
            end

            -- Log("Despawn S train: " .. name)
            DecrValue("_spawnedStaticTrainsetsCount")
            DespawnTrainset(self:GetTrainset())
            self._spawned = false
        end,
        Spawn = function(self)
            if (self._spawned == true) then
                return
            end

            self._spawned = true

            local onSpawn = function(trainset)
                if (trainset == nil) then
                    Error("Error while creating the static trainset for " .. name)

                    return
                end

                self._trainset = trainset
                IncValue("_spawnedStaticTrainsetsCount")

                if (type(onTrainsetSpawn) == "function") then
                    onTrainsetSpawn(trainset)
                else
                    trainset.SetState(DynamicState.dsStop, TrainsetState.tsDeactivation, false)
                end
            end

            -- Log("Spawn S train: " .. name)

            if (self._spawnPointType == "track") then
                SpawnTrainsetAsync(name, self._spawnPointRef, distance, false, false, true, CreateVehicles(vehicles), onSpawn)
            elseif (self._spawnPointType == "signal") then
                SpawnTrainsetOnSignalAsync(name, self._spawnPointRef, distance, false, false, true, CreateVehicles(vehicles), onSpawn)
            end
        end,
    }

    local storage = GetRef("_staticTrains")

    storage[name] = trainState
end