require("SimRailCore")

function CreateAITrains()
    return {
        ["IC_37002_Odra_Train"] = {
            {
                Locomotives.EU07_092_IC,
                PassengerCars.IC_1CLASS_IC_VARIANT_2,
                PassengerCars.IC_WARS,
                PassengerCars.IC_2CLASS_WITH_WC_FOR_DISABLED,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
            },
            {
                --- @param trainState TrainsetMachineState
                function(trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(5, 35, 00) ) --DateTimeCreate(2024, 05, 03, 5, 35, 00))
                    trainState:NextState()
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9759")
                
                    WaitUntilVDReady()
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_K", "KO_N3" })
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1])
                    Log("37002: Arrived")
                    
                    coroutine.yield(CoroutineYields.WaitForTrainsetDepartureWhistle, trainState:GetTrainset())
                    Log("37002: Finished exchange")
                    
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                    trainState:DetachVehiclesFromEnd(2, "IC_37002_Odra_1", TrainsetState.tsTrain, false, BrakeRegime.RR_Mg)
                    Log("37002: Detached")
                    
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    SetTrainRoute({ "KO_N3", "KO_Skps" })
                end,
            }
        },
        ["IC_14002_Polonia_Train"] = {
            {
                Locomotives.EP08_013,
                PassengerCars.IC_1CLASS_IC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_FOR_DISABLED,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
            },
            {
                --- @param trainState TrainsetMachineState
                function(trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(5, 43, 00) ) -- DateTimeCreate(2024, 05, 03, 5, 43, 00))
                    trainState:NextState()
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()

                    WaitUntilVDReady()
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_L", "KO_N9" })
                    
                    coroutine.yield(CoroutineYields.WaitForVehicleStartedMoving, trainState:GetTrainset().Vehicles[1])
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1])
                    Log("14002: Arrived")
                    
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset())
                    Log("14002: Finished exchange")

                    SetValue("icPoloniaArrived", true)
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    coroutine.yield(CoroutineYields.WaitForSeconds, 120)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(6, 04, 55) ) -- DateTimeCreate(2024, 05, 03, 6, 04, 55))
                    SetTrainRoute({"KO_N9", "KO_Skps"})
                end,
            },
        },
        ["IC_48150_Gwarek_Train"] = {
            {
                Locomotives.EU07_005_IC
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9759")
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_N5", 10, DynamicState.dsStop, TrainsetState.tsShunting, true, false, true, false, BrakeRegime.RR_Mg)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    SetShuntingRoute({"KO_N5", "KO_Tm65"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    SetShuntingRoute({"KO_Tm64", "KO_M1"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1])
                    coroutine.yield(CoroutineYields.WaitForSeconds, 3)
                    
                    JoinTrainStates("IC_48150_Gwarek_Train", "IC_48150_Gwarek_2", TrainsetState.tsTrain)

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(6, 07, 55) ) -- DateTimeCreate(2024, 05, 03, 6, 07, 55))
                    SetTrainRoute({"KO_N1", "KO_Skps"})
                end,
            }
        },
        ["IC_48150_Gwarek_1"] = {
            {
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_Tm506", 30, DynamicState.dsDecEmergency, TrainsetState.tsTrain, true, false, false, false, BrakeRegime.RR_Mg)
                    trainState:DisableAutoDespawn()
                end
            }
        },
        ["IC_48150_Gwarek_2"] = {
            {
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_1CLASS_IC_VARIANT_1,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_Tm505", 135, DynamicState.dsDecEmergency, TrainsetState.tsTrain, true, false, false, false, BrakeRegime.RR_Mg)
                    trainState:DisableAutoDespawn()
                end
            }
        },
    }
end
