require("SimRailCore")

function TrainEvents()
    return {
        {"IC_37002_Odra_Train", "KO_Tm65", 5, 
            function ()
                SetValue("icOdraDeparted", true)
            end
        },
    }
end
