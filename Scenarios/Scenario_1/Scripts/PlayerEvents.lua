require("SimRailCore")

function PlayerEvents()
    return {
        { "KO_Tm3", 320,
            function()
                RadioCall("MM_Gwarek_Tm502_20m")
            end
        },
        { "KO_Tm3", 302,
            function()
                RadioCall("MM_Gwarek_Tm502_0m")

                WaitUntilPlayerCabinIsActive(1)
                coroutine.yield(CoroutineYields.WaitForSeconds, 3)
                
                ---@param response VDReponseCode
                SetShuntingRoute({"KO_Tm502", "t8932k"}, function (response)
                    RadioCall("MM_Gwarek_Tm502_Signal")
                end)
            end
        },
        { "t9103", 58,
            function()
                RadioCall("MM_Gwarek_Second_100m")

                if (GetPlayerVehicle().vel > 7) then
                    RadioCall("MM_Speed_warning")
                end
            end
        },
        { "t27108", 36,
            function()
                RadioCall("MM_Gwarek_Second_30m")

                GetPlayerTrainState():SetTimetable("PlayerTimetable3")

                if (GetPlayerVehicle().vel > 4) then
                    RadioCall("MM_Speed_warning")
                end
            end
        },
        { "t27108", 56,
            function()
                RadioCall("MM_Gwarek_Second_10m")
            end
        },
        { "t27108", 61,
            function()
                RadioCall("MM_Gwarek_Second_5m")
            end
        },
        { "t27108", 65,
            function()
                RadioCall("MM_Gwarek_Second_1m")

                FailMissionIfSpeedExceeds(4)
            end
        },
        { "KO_N1", 129,
            function()
                RadioCall("MM_Gwarek_In_place")

                coroutine.yield(CoroutineYields.WaitForVehicleStop, GetPlayerVehicle())
                coroutine.yield(CoroutineYields.WaitForSeconds, 3)
                RadioCall("MM_Gwarek_Done")

                WaitUntil(function ()
                    return GetValue("icOdraDeparted") == true
                end)

                SetShuntingRoute({"KO_N1", "KO_Tm65"})
            end
        },
        { "KO_Tm65", 33,
            function()
                coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                SetShuntingRoute({"KO_Tm64", "KO_M7"})
            end
        },
        { "KO_M7", 280,
            function()
                SetValue("phaseGwarekDone", true)

                coroutine.yield(CoroutineYields.WaitForVehicleStop, GetPlayerVehicle())
                coroutine.yield(CoroutineYields.WaitForSeconds, 40)

                RadioCall("MM_Odra_Start")
                coroutine.yield(CoroutineYields.WaitForSeconds, 20)
                SetShuntingRoute({"KO_M7", "KO_Tm33", "KO_Tm13"})
            end
        },
        { "KO_Tm13", 256,
            function()
                coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                SetShuntingRoute({"KO_Tm21", "KO_Tm35", "KO_N3"})
            end
        },
        { "KO_Tm13", 220,
            function()
                RadioCall("MM_Polonia_Tm21_20m")
            end,
            function (trainset)
                return GetValue("odraAttached") == true
            end
        },
        { "KO_Tm13", 202,
            function()
                SetValue("odraOutOfPlatforms", true)

                RadioCall("MM_Polonia_Tm21_0m")

                coroutine.yield(CoroutineYields.WaitForSeconds, 25)
                WaitUntilPlayerCabinIsActive(-1)
                coroutine.yield(CoroutineYields.WaitForSeconds, 6)
                
                ---@param response VDReponseCode
                SetShuntingRoute({"KO_Tm21", "KO_Tm37", "KO_N9"}, function (response)
                    RadioCall("MM_Polonia_Tm21_Signal")
                end)
            end,
            function (trainset)
                return GetValue("odraAttached")
            end
        },
        { "KO_N9", 282,
            function()
                RadioCall("MM_Polonia_100m")

                if (GetPlayerVehicle().vel > 7) then
                    RadioCall("MM_Speed_warning")
                end
            end
        },
        { "KO_N9", 212,
            function()
                RadioCall("MM_Polonia_30m")

                GetPlayerTrainState():SetTimetable("PlayerTimetable3")

                if (GetPlayerVehicle().vel > 4) then
                    RadioCall("MM_Speed_warning")
                end
            end
        },
        { "KO_N9", 192,
            function()
                RadioCall("MM_Polonia_10m")
            end
        },
        { "KO_N9", 187,
            function()
                RadioCall("MM_Polonia_5m")
            end
        },
        { "KO_N9", 182,
            function()
                RadioCall("MM_Polonia_1m")

                FailMissionIfSpeedExceeds(4)

                coroutine.yield(CoroutineYields.WaitForVehicleStop, GetPlayerVehicle())
                RadioCall("MM_Polonia_Bumped")
            end
        },
        { "KO_Tm7", 155,
            function()
                RadioCall("MM_TLK_Before_Tm1")
            end
        },
        { "t9121", 22,
            function()
                RadioCall("MM_TLK_Tm1_0m")

                coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                SetShuntingRoute({"KO_Tm1", "KO_Tm16", "KO_F"})
            end
        },
        { "t27108", 85,
            function()
                RadioCall("MM_TLK_50m")
                SetSwitchPosition("z248", true)
                SetSwitchPosition("z242", true)
                SetSwitchPosition("z233", true)
                SetSwitchPosition("z231", false)

                SetValue("backInKO1", true)

                WaitUntil(function ()
                    return #GetPlayerTrainset().Vehicles == 1 and GetCameraView() == CameraView.Sitting
                end)

                SetValue("phaseTLKDone", true)
                coroutine.yield(CoroutineYields.WaitForSeconds, 3)
                RadioCall("MM_TLK_Done")
            end,
            function()
                return GetValue("phasePoloniaDone")
            end
        },
        { "t9646", 25,
            function()
                RadioCall("MM_Ending_z231_0m")
                coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                SetSwitchPosition("z231", true)
                SetShuntingRoute({"KO_Tm504", "KO_Tm4"})
            end
        },
        { "KO_Tm4", 401,
            function()
                RadioCall("MM_Ending_Tm501_0m")

                local playerVehicle = GetPlayerVehicle()
                coroutine.yield(CoroutineYields.WaitForVehicleStop, playerVehicle)

                local finish = function ()
                    FinishMission(MissionResultEnum.Success)
                end

                CallAsCoroutine(function ()
                    Log("Starting 135 seconds")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 135)
                    
                    Log("Displaying message")
                    DisplayMessage("Mission_ending_in_30s", 10)
                    coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                end, nil, finish)

                CallAsCoroutine(function ()
                    Log("Waiting for finish")
                    WaitUntil(function ()
                           return GetCameraView() == CameraView.FirstPersonWalkingOutside
                    end)

                    Log("Displaying message")
                    DisplayMessage("Mission_ending_in_15s", 8)
                    coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                end, nil, finish)
            end
        },

        --- SPEED CHANGES WITH TIMETABLE ---
        -- Approaching first part of Gwarek
        { "t8781", 10,
            function()
                GetPlayerTrainState():SetTimetable("PlayerTimetable3")
            end
        },
        { "t27107", 6,
            function()
                FailMissionIfSpeedExceeds(4)
            end
        },
        -- Approaching Odra
        { "t9628", 5,
            function()
                GetPlayerTrainState():SetTimetable("PlayerTimetable3")
            end
        },
        { "t9628", 37,
            function()
                FailMissionIfSpeedExceeds(4)
            end
        },
        -- Approaching TLK
        { "t11231", 34,
            function()
                GetPlayerTrainState():SetTimetable("PlayerTimetable3")
            end
        },
        { "t11230", 28,
            function()
                FailMissionIfSpeedExceeds(4)
            end
        },
    }
end