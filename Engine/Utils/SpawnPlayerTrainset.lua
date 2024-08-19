-- ---@param signalOrTrack string Signal or track name in front of which to spawn a train
-- ---@param distance number Distance from the signal
-- ---@param isReversed boolean Is the vehicle reversed on the track?
-- ---@param teleportToCabin boolean Should a player be teleported to cabin - this gets set to false if spawned vehicle isn't the player's vehicle
-- ---@param vehicles table<PassengerCars | CargoCars | Locomotives | EZT> Array of the vehicles that builds up a trainset
-- ---@return TrainsetInfo
-- function SpawnPlayerTrainset(signalOrTrack, distance, isReversed, teleportToCabin, vehicles)
--   local type, ref = GetSignalOrTrackRef(signalOrTrack);
--   local trainset

--   if (type == "track") then
--       trainset = SpawnTrainset("Player", ref, distance, isReversed, true, false, teleportToCabin, CreateVehicles(vehicles, false))
--   elseif (type == "signal") then
--       trainset = SpawnTrainsetOnSignal("Player", ref, distance, isReversed, true, false, teleportToCabin, CreateVehicles(vehicles, false))
--   end

--   return trainset
-- end

---@param signalOrTrack string Signal or track name in front of which to spawn a train
---@param distance number Distance from the signal
---@param isReversed boolean Is the vehicle reversed on the track?
---@param teleportToCabin boolean Should a player be teleported to cabin - this gets set to false if spawned vehicle isn't the player's vehicle
---@param vehicles table<PassengerCars | CargoCars | Locomotives | EZT> Array of the vehicles that builds up a trainset
---@return TrainsetMachineState
function SpawnPlayerTrainset(signalOrTrack, distance, isReversed, teleportToCabin, vehicles)
    CreateTrainset(
        "Player", 
        vehicles, 
        {},
        true)
    
    local playerTrainState = GetTrainState("Player")
    playerTrainState:SpawnAt(signalOrTrack, distance, DynamicState.dsStop, TrainsetState.tsTrain, false, isReversed, false, teleportToCabin, BrakeRegime.RR_Mg)

    return playerTrainState
end