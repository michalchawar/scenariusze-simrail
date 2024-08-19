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
                
                SetShuntingRoute({"KO_Tm505", "KO_Tm3", "KO_K", "KO_Tm29", "KO_Tm35", "KO_N1"})
            end,
        },
        ["KO_M3"] = {
            -- after attaching remaining IC 37002 carts on track 3
            function ()
                RadioPlayerCall("Odra_attached")
                coroutine.yield(CoroutineYields.WaitForSeconds, 2)
                
                RadioCall("MM_Polonia_Start")
                coroutine.yield(CoroutineYields.WaitForSeconds, 6)

                SetShuntingRoute({"KO_M3", "KO_Tm32", "KO_E13"})
            end
        }
    }
end