require("SimRailCore")

function TEST_1()
    Log('TEST_1')
end

function LOG_REGISTERED_TRAINSETS()
    local trainstates = GetRef("_trainStates")

    for k, v in pairs(trainstates) do
        if not v:IsAttached() then
            local txt = ''
            for k, v in pairs(v:GetSubTrainStates()) do
                txt = txt .. v:GetTrainStateName() .. ', '
            end

            Log(k .. "; consists of trainstates: " .. txt)
        end
    end
end

-- function SPAWN()
--     CreateTrainset(
--         "KO_TEST",
--         { 
--             Locomotives.EP07_135_GREEN,
--         }, 
--         {
--             ---@param trainState TrainsetMachineState
--             function (trainState)
--                 trainState:SpawnAt( "KO_N7", 20, DynamicState.dsStop, TrainsetState.tsShunting, true )
--                 trainState:DisableAutoDespawn()
                
--                 SetShuntingRoute({ "KO_N7", "KO_Tm65" })
--                 TriggerTrainState("KO_TEST", "KO_Tm65", 20, {"KO_TEST"})

--                 Log("Set route, applied trigger")
--             end,
--             ---@param trainState TrainsetMachineState
--             function (trainState)
--                 SetShuntingRoute({ "KO_Tm64", "KO_M9" })
--             end,
--         }
--     )
-- end
function SPAWN()
    CreateTrainset(
        "KO_TEST1",
        { 
            -- CargoCars.Z424_BROWN,
            -- CargoCars.Z424_BROWN,
            PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
            PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
            PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
        }, 
        {
            ---@param trainState TrainsetMachineState
            function (trainState)
                trainState:SpawnAt( "KO_F", 25, DynamicState.dsStop, TrainsetState.tsTrain, true, false, false )
                trainState:DisableAutoDespawn()
            end,
        }
    )
end

function JOIN()
    JoinTrainStates("KO_TEST", "IC_14002_Detached")
end

function DESPAWN()
    local ts = GetTrainState("KO_TEST1")
    ts:Despawn()
end

function TEST_2()
    local ts = GetTrainState("Player")
    if (ts:GetTrainset() == nil) then
        Log("TEST_2: Nil player trainset")
    else
        Log("TEST_2: Player trainset found")
    end
end

-- function DETACH_2()
--     local ts = GetTrainState("IC_14002_Polonia")
--     ts:DetachVehiclesFromEnd(2, "IC_14002_Detached")
-- end

-- function TEST_3()
--     SetShuntingRoute("KO_Tm502", "")
-- end