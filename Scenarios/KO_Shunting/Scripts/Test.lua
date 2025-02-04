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

            local ts = v:GetTrainset()

            Log(k .. "; trainset: " .. (ts ~= nil and ts.name or "nil") .. "; consists of trainstates: " .. txt)
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
    local trainstates = GetRef("_trainStates")
    local array = {}

    for k, v in pairs(trainstates) do
        table.insert( array, {
            ["Text"] = k,
            ["OnClick"] = function()
                Log("Starting")
                
                if (v:GetTrainset() == nil) then
                    Log("Nil trainset")
                end
                Log("Not nil trainset")

                local desc = GetTrainsetDesc(v:GetTrainset())
                if (desc == nil) then
                    Log("Nil desc")
                    return
                end
                if (desc.pos == nil) then
                    Log("Nil pos")
                end

                Log(desc.pos.lastSignal .. " @ " .. desc.pos.lastDistanceToSignal .. " (" .. desc.pos.signalDistance .. ")")
            end,
        })
    end

    ShowMessageBox("Select TrainState", table.unpack(array))
end

function SWITCH_DIRECTION()
    local ts = GetTrainState("KO_TEST1")
    ts:SwitchDirection()
end

function DESPAWN()
    local ts = GetTrainState("KO_TEST1")
    ts:Despawn()
end

function ASET3()
    local pl = GetTrainState("Player")
    pl:SetTimetable("PlayerTimetable3")
end

function ASET25()
    local pl = GetTrainState("Player")
    pl:SetTimetable("PlayerTimetable25")
end

function NEXT_ODRA_STATE()
   local ts = GetTrainState("IC_37002_Odra_Train")
   ts:NextState()
end