require("SimRailCore")

function PlayerRadioCalls()
    return {
        ["KO_Tm501"] = {
            -- after starting loco
            function ()
                RadioPlayerCall("Ready_to_start")
                coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                SetValue("scenarioBegun", true)
                
                RadioCall("MM_Gwarek_Start")
                
                WaitUntilVDReady()
                SetShuntingRoute({"KO_Tm501", "t8935k"})
            end,
        },
        ["KO_Tm506"] = {
            -- after attaching first part of IC 48150 carts
            function ()
                RadioPlayerCall("Gwarek_First_attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 2)

                RadioCall("MM_Gwarek_First_attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 5)
                
                SetShuntingRoute({"KO_Tm506", "KO_Tm3"})
            end,
        },
        ["KO_Tm505"] = {
            -- after attaching second part of IC 48150 carts
            function ()
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
        },
        ["KO_M3"] = {
            -- after attaching remaining IC 37002 carts on track 3
            function ()
                SetValue("odraAttached", true)

                RadioPlayerCall("Odra_attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                
                RadioCall("MM_Polonia_Start")
                coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                SetShuntingRoute({"KO_M3", "KO_Tm32", "KO_Tm13"})
            end
        },
        ["KO_M9"] = {
            -- after attaching carts to IC 14002 Polonia
            function ()
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
            end
        },
        ["KO_Tm17"] = {
            -- after attaching free TLK carts
            function ()
                SetValue("tlkAttached", true)

                RadioPlayerCall("TLK_Attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                
                RadioCall("MM_TLK_Attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                SetShuntingRoute({"KO_Tm17", "KO_E20", "KO_Tm502", "t8932k"})
            end
        },
    }
end