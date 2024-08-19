require("SimRailCore")

function PlayerEvents()
    return {
        { "KO_Tm3", 320,
            function()
                RadioCall("MM_Gwarek_Tm502_20m")

                if (GetPlayerVehicle().vel >= 27) then
                    RadioCall("speed")
                end
            end
        },
        { "KO_Tm3", 302,
            function()
                RadioCall("MM_Gwarek_Tm502_0m")

                coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                
                ---@param response VDReponseCode
                SetShuntingRoute({"KO_Tm502", "t8932k"}, function (response)
                    RadioCall("MM_Gwarek_Tm502_Signal")
                end)
            end
        },
        { "t9103", 58,
            function()
                RadioCall("MM_Gwarek_Second_100m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "t27108", 36,
            function()
                RadioCall("MM_Gwarek_Second_30m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "t27108", 56,
            function()
                RadioCall("MM_Gwarek_Second_10m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "t27108", 61,
            function()
                RadioCall("MM_Gwarek_Second_5m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "t27108", 65,
            function()
                RadioCall("MM_Gwarek_Second_1m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
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
                SetShuntingRoute({"KO_M7", "KO_Tm33", "KO_E13"})
            end
        },
        { "KO_E13", 227,
            function()
                coroutine.yield(CoroutineYields.WaitForSeconds, 10)
                SetShuntingRoute({"KO_Tm29", "KO_Tm35", "KO_N3"})
            end
        },
        { "KO_Tm13", 220,
            function()
                RadioCall("MM_Polonia_Tm29_20m")

                if (GetPlayerVehicle().vel >= 27) then
                    RadioCall("speed")
                end

                -- VDSetManualSignalLightsState("KO_Tm32", SignalLightType.White, LuaSignalLightState.Default)
                -- VDSetManualSignalLightsState("KO_Tm32", SignalLightType.Blue, LuaSignalLightState.Default)
            end,
            function (trainset)
                return GetValue("odraAttached") == true
            end
        },
        { "KO_Tm13", 202,
            function()
                RadioCall("MM_Polonia_Tm29_0m")

                coroutine.yield(CoroutineYields.WaitForSeconds, 15)
                
                ---@param response VDReponseCode
                SetShuntingRoute({"KO_Tm21", "KO_Tm37", "KO_N9"}, function (response)
                    RadioCall("MM_Polonia_Tm29_Signal")
                end)
            end,
            function (trainset)
                return GetValue("odraAttached")
            end
        },
        { "KO_N9", 278,
            function()
                RadioCall("MM_Gwarek_Second_100m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "KO_N9", 208,
            function()
                RadioCall("MM_Gwarek_Second_30m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "KO_N9", 188,
            function()
                RadioCall("MM_Gwarek_Second_10m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "KO_N9", 183,
            function()
                RadioCall("MM_Gwarek_Second_5m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
        { "KO_N9", 178,
            function()
                RadioCall("MM_Gwarek_Second_1m")

                if (GetPlayerVehicle().vel >= 7) then
                    RadioCall("speed")
                end
            end
        },
    }
end