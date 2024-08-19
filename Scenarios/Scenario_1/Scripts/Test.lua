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

function SPAWN()
    CreateTrainset(
        "KO_TEST1",
        { 
            Locomotives.EP07_174_GREEN_OLD,
            PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
            PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
            PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
        }, 
        {
            ---@param trainState TrainsetMachineState
            function (trainState)
                trainState:SpawnAt( "KO_F", 25, DynamicState.dsStop, TrainsetState.tsShunting, false, false )
                trainState:DisableAutoDespawn()
            end,
        },
        false
    )
end

function LOG_NEXT_SIGNAL()
    local ts = GetTrainState("KO_TEST1")
    Log(GetTrainsetDesc(ts:GetTrainset()).pos.lastSignal)
end

function SWITCH_DIRECTION()
    local ts = GetTrainState("KO_TEST1")
    ts:SwitchDirection()
end

function DESPAWN()
    local ts = GetTrainState("KO_TEST1")
    ts:Despawn()
end

function IC_GWAREK_NEXT_STATE()
    local ts = GetTrainState("IC_48150_Gwarek_Train")
    ts:NextState()
end

function IC_GWAREK_NEXT_SIGNAL()
    local ts = GetTrainState("IC_48150_Gwarek_Train")

    local trainDesc = GetTrainsetDesc(ts:GetTrainset())
    local signalName = trainDesc.pos.lastSignal
    local distanceToSignal = trainDesc.pos.lastDistanceToSignal or trainDesc.pos.signalDistance

    Log("Found signal " .. signalName .. " at distance of " .. distanceToSignal)
end

function TEST_SIGNALS()
    SetShuntingRoute({"KO_Tm16", "KO_F"}, function ()
        Log("Udalo sie")
    end)
end

function TEST_SWITCHES()
    SetSwitchPosition("z231", false, function ()
        Log("Udalo sie")
    end)
end