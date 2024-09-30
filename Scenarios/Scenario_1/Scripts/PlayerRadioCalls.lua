require("SimRailCore")

function PlayerRadioCalls()
    return {
        ["KZ_F"] = {
            -- after starting loco but in normal mode so it reads normal semaphore
            {
                function ()
                    RadioPlayerCall("Ready_to_start")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                    SetValue("scenarioBegun", true)
                    
                    RadioCall("MM_Gwarek_Start")
                    
                    WaitUntilVDReady()
                    SetShuntingRoute({"KO_Tm501", "t8935k"})
                end,
                PlayerActiveCabinCheck(1)
            }
        },
        ["KO_Tm506"] = {
            -- after attaching first part of IC 48150 carts
            {
                function ()
                    GetPlayerTrainState():SetTimetable("PlayerTimetable25")

                    RadioPlayerCall("Gwarek_First_attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)

                    RadioCall("MM_Gwarek_First_attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                    
                    SetShuntingRoute({"KO_Tm506", "KO_Tm3"})
                end,
                function ()
                    return IsPlayerActiveCabinEqual(-1) and #GetPlayerTrainset().Vehicles > 1
                end
            }
        },
        ["KO_Tm505"] = {
            -- after attaching second part of IC 48150 carts
            {
                function ()
                    GetPlayerTrainState():SetTimetable("PlayerTimetable25")

                    RadioPlayerCall("Gwarek_Second_attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)

                    RadioCall("MM_Gwarek_Second_attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                    
                    SetShuntingRoute({"KO_Tm505", "KO_Tm3"})

                    WaitUntil(function ()
                        return GetValue("icOdraArrived") == true
                    end)
                    
                    SetShuntingRoute({"KO_Tm3", "KO_K", "KO_Tm29", "KO_Tm35", "KO_N1"})
                end,
                function ()
                    return IsPlayerActiveCabinEqual(-1) and #GetPlayerTrainset().Vehicles > 4
                end
            }
        },
        ["KO_M3"] = {
            -- after attaching remaining IC 37002 carts on track 3
            {    
                function ()
                    GetPlayerTrainState():SetTimetable("PlayerTimetable25")
                    
                    SetValue("odraAttached", true)

                    RadioPlayerCall("Odra_attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                    
                    RadioCall("MM_Polonia_Start")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                    SetShuntingRoute({"KO_M3", "KO_Tm32", "KO_Tm13"})
                end,
                function ()
                    if #GetPlayerTrainset().Vehicles <= 1 then
                        Log("Vehicles check not passed")
                    end
                    return IsPlayerActiveCabinEqual(1) and #GetPlayerTrainset().Vehicles > 1
                end
            }
        },
        ["KO_M9"] = {
            -- after attaching carts to IC 14002 Polonia
            {    
                function ()
                    GetPlayerTrainState():SetTimetable("PlayerTimetable25")

                    SetValue("phasePoloniaDone", true)

                    RadioPlayerCall("Polonia_ready")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                    
                    RadioCall("MM_Polonia_Done")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                    -- SetShuntingRoute({"KO_M9", "KO_Tm34", "KO_E15", "KO_Tm7", "KO_Dkps"})
                    SetShuntingRoute({"KO_M9", "KO_Tm34", "KO_E15"})
                    SetShuntingRoute({"KO_Tm7", "KO_Dkps"}, function ()
                        SetShuntingRoute({"KO_E15", "KO_Tm7"})
                    end)
                end,
                function ()
                    return IsPlayerActiveCabinEqual(1) and #GetPlayerTrainset().Vehicles == 1 
                      and #GetTrainState("IC_14002_Polonia_Train"):GetTrainset().Vehicles > 6
                end
            }
        },
        ["KO_Tm17"] = {
            -- after attaching free TLK carts
            {    
                function ()
                    GetPlayerTrainState():SetTimetable("PlayerTimetable25")

                    SetValue("tlkAttached", true)

                    RadioPlayerCall("TLK_Attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                    
                    RadioCall("MM_TLK_Attached")
                    coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                    SetShuntingRoute({"KO_Tm17", "KO_E20", "KO_Tm502", "t8932k"})
                end,
                function ()
                    return IsPlayerActiveCabinEqual(1) and #GetPlayerTrainset().Vehicles > 1
                end
            }
        },
    }
end