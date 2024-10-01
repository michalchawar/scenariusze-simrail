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
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(5, 34, 30) ) --DateTimeCreate(2024, 05, 03, 5, 35, 00))
                    trainState:NextState()
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9759")
                
                    WaitUntilVDReady()
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_K", "KO_N3" }, nil, true)
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
                    trainState:DespawnAt("t9759")

                    WaitUntilVDReady()
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_L", "KO_N9" })
                    
                    coroutine.yield(CoroutineYields.WaitForVehicleStartedMoving, trainState:GetTrainset().Vehicles[1])
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1])
                    Log("14002: Arrived")
                    
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset())
                    Log("14002: Finished exchange")

                    SetValue("icPoloniaArrived", true)

                    trainState:SetTrainsetState(TrainsetState.tsDeactivation)
                end,
                --- @param trainState TrainsetMachineState
                function(trainState)
                    trainState:SetTrainsetState(TrainsetState.tsTrain)
                    
                    coroutine.yield(CoroutineYields.WaitForSeconds, 120)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(6, 03, 55) ) -- DateTimeCreate(2024, 05, 03, 6, 04, 55))
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

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(6, 05, 35) ) -- DateTimeCreate(2024, 05, 03, 6, 07, 55))
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
                    trainState:SpawnAt("KO_Tm506", 30, DynamicState.dsDecEmergency, TrainsetState.tsDeactivation, true, false, false, false, BrakeRegime.RR_Mg)
                    trainState:DisableAutoDespawn()
                end
            }
        },
        ["IC_48150_Gwarek_2"] = {
            {
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_1CLASS_IC_VARIANT_2,
                PassengerCars.IC_1CLASS_IC_VARIANT_1,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_Tm505", 135, DynamicState.dsDecEmergency, TrainsetState.tsDeactivation, true, false, false, false, BrakeRegime.RR_Mg)
                    trainState:DisableAutoDespawn()
                end
            }
        },
        ["TLK_Free_Carts"] = {
            {
                PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_1CLASS_RED_WAGON_WITH_OVAL_WINDOWS,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_F", 10, DynamicState.dsDecEmergency, TrainsetState.tsDeactivation, true, false, false, false, BrakeRegime.RR_Mg)
                    trainState:DisableAutoDespawn()
                end
            }
        },

        --- FULLY AI CONTROLLED TRAINS FOR AMBIENT TRAFFIC ---

        ["EN76_Shunting_at_start"] = {
            {
                EZT.ELF_EN76_006_KS,
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_Tm504", 35, DynamicState.dsStop, TrainsetState.tsShunting)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KO_K", 15)

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 17, 30 ) )
                    WaitUntilVDReady()
                    SetShuntingRoute({"KO_Tm504", "KO_Tm3", "KO_K"}, nil, true)
                end,
            }
        },
        ["EIC_4850_Fregata"] = {
            {
                Locomotives.EP08_013,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_WARS,
                PassengerCars.IC_1CLASS_IC_VARIANT_2,
                PassengerCars.IC_1CLASS_IC_VARIANT_1,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_E16", 35, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_D2", 30)

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 19, 00 ) )
                    WaitUntilVDReady()
                    SetTrainRoute({"KO_E16", "KO_Ckps", "KZ_O", "KZ_D2"}, nil, true)
                end,
            }
        },
        ["Os_43452"] = {
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SpawnAt("KO_E18", 35, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_E", 30)

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 25, 00 ) )
                    WaitUntilVDReady()
                    SetTrainRoute({"KO_E18", "KO_Akps", "KZ_P", "KZ_E"}, nil, true)
                end,
            }
        },
        ["TLK_54070_Wydmy"] = {
            {
                Locomotives.EU07_092_IC,
                PassengerCars.TLK_1CLASS_RED_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(5, 20, 00) )
                    
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KO_K", 15)
                
                    WaitUntilVDReady()
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_K" }, nil, true)
                end,
            }
        },
        ["Pr_34301"] = {
            {
                EZT.EN57_1219
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 28, 00 ) )
                    
                    trainState:SpawnAt("KZ_M", 10, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)

                    SetTrainRoute({"KZ_M", "KZ_P1Mkps", "KO_B", "KO_G16", "KO_N10"}, nil, true)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:SetTrainsetState(TrainsetState.tsShunting)
                    SetShuntingRoute({"KO_N10", "KO_Pkps"})
                end,
            }
        },
        ["Pr_24901"] = {
            {
                EZT.EN71_005
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 32, 50 ) )
                    
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)

                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_G14", "KO_N2" })
                    
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 45, 00 ) )
                    
                    trainState:SetTrainsetState(TrainsetState.tsShunting)
                    SetShuntingRoute({"KO_N2", "KO_Pkps"})
                end,
            }
        },
        ["Os_40402"] = {
            --- this becomes Os_40507 later on
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 38, 00 ) )
                    
                    trainState:SpawnAt("KO_O", 20, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)
                    
                    SetTrainRoute({ "KO_O", "KO_M4" })
                    
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 42, 00 ) )

                    trainState:SetTrainsetState(TrainsetState.tsShunting)
                    SetShuntingRoute({"KO_M4", "KO_Tm41", "KO_Tm14"}, nil, true)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:GetTrainset().SetTimetable(LoadTimetableFromFile('Os_40507.xml'), false)

                    SetShuntingRoute({"KO_Tm22", "KO_N8"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1] )
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5 )
                    trainState:SetTrainsetState(TrainsetState.tsTrain)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 53, 55 ) )

                    SetTrainRoute({"KO_N8", "KO_Pkps"})
                end,
            }
        },
        ["Os_40604"] = {
            {
                EZT.ELF_EN96_001_PR,
                EZT.ELF_EN96_001_PR,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 39, 00 ) )
                    
                    trainState:SpawnAt("KO_R", 20, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_O", 40)

                    SetTrainRoute({"KO_R", "KO_M8"})
                    
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 43, 00 ) )
                    SetTrainRoute({"KO_M8", "KO_E18", "KO_Ckps", "KZ_O"}, nil, true)
                end,
                -- ---@param trainState TrainsetMachineState
                -- function (trainState)
                --     SetTrainRoute({"KO_M8", "KO_E18", "KO_Ckps", "KZ_O", "KZ_D2"})
                -- end,
            }
        },
        ["Os_40907"] = {
            {
                EZT.ELF_EN76_006_KS,
                EZT.ELF_EN76_006_KS,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 39, 00 ) )
                    
                    trainState:SpawnAt("KZ_M", 10, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)

                    SetTrainRoute({"KZ_M", "KZ_P1Mkps"})
                end,    
                ---@param trainState TrainsetMachineState
                function (trainState)
                    SetTrainRoute({"KO_B", "KO_G18", "KO_N10"}, nil, true)

                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 46, 00 ) )
                    SetTrainRoute({"KO_N10", "KO_Pkps"})
                end,
            }
        },
        ["IC_4522_Skarbek"] = {
            {
                Locomotives.EU07_085_IC,
                PassengerCars.IC_1CLASS_IC_VARIANT_2,
                PassengerCars.IC_WARS,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 46, 00 ) )
                    
                    trainState:SpawnAt("KO_R", 35, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_O", 40)
                    
                    SetTrainRoute({"KO_R", "KO_M4"})

                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 58, 00 ) )
                    SetTrainRoute({"KO_M4", "KO_E14", "KO_Ckps", "KZ_O"}, nil, true)
                end,
            }
        },
        ["IC_38103_Chelmonski"] = {
            {
                Locomotives.EU07_005_IC,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
                PassengerCars.IC_WARS,
                PassengerCars.IC_1CLASS_IC_VARIANT_1,
                PassengerCars.IC_2CLASS_WITH_WC_VARIANT_1,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 47, 30 ) )
                    
                    trainState:SpawnAt("KO_B", 35, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9759")
                    
                    -- SetTrainRoute({"KO_B", "KO_K"})

                    -- WaitUntil(function ()
                    --     return GetValue("odraOutOfPlatforms")
                    -- end)

                    -- SetTrainRoute({"KO_B", "KO_K", "KO_N3"}, nil, true)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    SetTrainRoute({"KO_B", "KO_K"}, nil, true)

                    WaitUntil(function ()
                        return GetValue("odraOutOfPlatforms")
                    end)

                    SetTrainRoute({"KO_K", "KO_N3"}, nil, true)
                -- end,
                -- ---@param trainState TrainsetMachineState
                -- function (trainState)
                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 58, 00 ) )
                    SetTrainRoute({"KO_N3", "KO_Skps"})
                end,
            }
        },
        ["Pr_43800"] = {
            {
                EZT.EN71_005,
                EZT.EN71_005
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 47, 30 ) )
                    
                    trainState:SpawnAt("KO_Tm70", 10, DynamicState.dsStop, TrainsetState.tsShunting)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_E", 30)

                    WaitUntil(function ()
                        return GetValue("Os40907Gone")
                    end)

                    SetShuntingRoute({"KO_Tm70", "KO_Tm62", "KO_M10"}, nil, true)
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1] )
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5 )
                    trainState:SetTrainsetState(TrainsetState.tsTrain)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 05, 50, 55 ) )

                    SetTrainRoute({"KO_M10", "KO_E18", "KO_Akps", "KZ_P", "KZ_E"}, nil, true)
                end,
            }
        },
        ["Os_40404"] = {
            --- this becomes Os_44807/2961 later on
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 05, 40 ) )
                    
                    trainState:SpawnAt("KO_O", 20, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)
                    
                    SetTrainRoute({ "KO_O", "KO_M10" })

                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 09, 00 ) )

                    trainState:SetTrainsetState(TrainsetState.tsShunting)
                    SetShuntingRoute({"KO_M10", "KO_Tm14"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    trainState:GetTrainset().SetTimetable(LoadTimetableFromFile('Os_44807.xml'), false)

                    SetShuntingRoute({"KO_Tm22", "KO_Tm35", "KO_N1"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1] )
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5 )
                    trainState:SetTrainsetState(TrainsetState.tsTrain)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 18, 55 ) )

                    SetTrainRoute({"KO_N1", "KO_Pkps"})
                end,
            }
        },
        ["Os_40653"] = {
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 03, 20 ) )
                    
                    trainState:SpawnAt("KZ_K", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9759")

                    SetTrainRoute({ "KZ_K", "KZ_J1Skps" })

                    WaitUntil(function ()
                        return GetValue("reversedTm1")
                    end)

                    SetTrainRoute({ "KO_D", "KO_L", "KO_N7" })
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 10, 55 ) )
                    
                    SetTrainRoute({ "KO_N7", "KO_Skps" })
                end,
            }
        },
        ["Os_40606"] = {
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 07, 30 ) )
                    
                    trainState:SpawnAt("KO_R", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_D2", 30)

                    SetTrainRoute({ "KO_R", "KO_M4" })
                -- end,
                -- ---@param trainState TrainsetMachineState
                -- function (trainState)
                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 11, 55 ) )
                    
                    SetTrainRoute({ "KO_M4", "KO_E14", "KO_Ckps", "KZ_O", "KZ_D2" })
                end,
            }
        },
        ["Os_34403"] = {
            {
                EZT.ELF_EN96_001_PR
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 16, 00 ) )
                    
                    trainState:SpawnAt("KZ_M", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    -- trainState:DespawnAt("t9759")

                    SetTrainRoute({ "KZ_M", "KZ_J1Skps", "KO_D", "KO_L", "KO_N9" })
                end,
            }
        },
        ["Pr_43218"] = {
            {
                EZT.EN57_1003
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 16, 30 ) )
                    
                    trainState:SpawnAt("KO_Tm70", 10, DynamicState.dsStop, TrainsetState.tsShunting)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_D2", 30)

                    SetShuntingRoute({"KO_Tm70", "KO_Tm60", "KO_M2"})
                end,
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForVehicleStop, trainState:GetTrainset().Vehicles[1] )
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5 )
                    trainState:SetTrainsetState(TrainsetState.tsTrain)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 19, 55 ) )

                    SetTrainRoute({"KO_M2", "KO_E14", "KO_Ckps", "KZ_O", "KZ_D2"}, nil, true)
                end,
            }
        },
        ["Pr_24903"] = {
            {
                EZT.EN71_011
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 16, 50 ) )
                    
                    trainState:SpawnAt("KZ_B1", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)

                    SetTrainRoute({ "KZ_B1", "KZ_K" })
                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    
                    SetTrainRoute({ "KZ_K", "KZ_J1Skps", "KO_D", "KO_G14", "KO_N2" })
                    coroutine.yield(CoroutineYields.WaitForSeconds, 60 )
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    
                    WaitUntil(function ()
                        return GetValue("backInKO1")
                    end)

                    trainState:Despawn()
                end,
            }
        },
        ["Os_94752"] = {
            {
                EZT.ELF_EN76_006_KS
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 21, 30 ) )
                    
                    if not GetValue("backInKO1") then
                        trainState:SpawnAt("KO_O", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                        trainState:DisableAutoDespawn()

                        SetTrainRoute({ "KO_O", "KO_M3" })

                        WaitForTrainStateToSpawn(trainState)
                        coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                        
                        WaitUntil(function ()
                            return GetValue("backInKO1")
                        end)

                        trainState:Despawn()
                    end
                end,
            }
        },
        ["Pr_34303"] = {
            {
                EZT.EN71_005
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 21, 55 ) )
                    
                    trainState:SpawnAt("KZ_A", 10, DynamicState.dsStop, TrainsetState.tsTrain)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("t9855", 10)

                    SetTrainRoute({ "KZ_A", "KZ_M" })
                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    
                    SetTrainRoute({ "KZ_M", "KZ_P1Mkps", "KO_B", "KO_K", "KO_N1" })
                    coroutine.yield(CoroutineYields.WaitForSeconds, 60 )
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )

                    WaitUntil(function ()
                        return GetValue("backInKO1")
                    end)

                    trainState:Despawn()
                end,
            }
        },
        ["TLK_42000_Roztocze"] = {
            {
                Locomotives.EU07_241_YELLOW_HEAD,
                PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_1CLASS_GREY_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_1CLASS_RED_WITH_SQUARE_WINDOWS,
            },
            {
                ---@param trainState TrainsetMachineState
                function (trainState)
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 24, 40 ) )
                    
                    trainState:SpawnAt("KO_R", 15, DynamicState.dsStop, TrainsetState.tsTrain, true)
                    trainState:DisableAutoDespawn()
                    trainState:DespawnAt("KZ_E", 30)
                
                    SetTrainRoute({ "KO_R", "KO_M8" })

                    WaitForTrainStateToSpawn(trainState)
                    coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeStart, trainState:GetTrainset() )
                    coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp( 06, 29, 55 ) )
                    
                    SetTrainRoute({ "KO_M8", "KO_E18", "KO_Akps", "KZ_P", "KZ_E" })
                end,
            }
        },
    }
end
