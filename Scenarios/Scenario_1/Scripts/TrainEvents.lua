require("SimRailCore")

function TrainEvents()
    return {
        {"IC_37002_Odra_Train", "KO_N3", 180, 
            function ()
                SetValue("icOdraArrived", true)
            end
        },
        {"IC_37002_Odra_Train", "t9760", 44, 
            function ()
                SetValue("icOdraDeparted", true)
            end
        },
    }
end
