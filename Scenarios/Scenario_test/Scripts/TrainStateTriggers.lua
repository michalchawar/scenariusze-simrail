require("SimRailCore")

function TrainStateTriggers()
    return {
        { "Player", "KO_Tm29", 50, {"IC_48150_Gwarek_Train"} },
        { "Player", "KO_M7", 287, {"IC_48150_Gwarek_Train"} },
        { "IC_48150_Gwarek_Train", "KO_Tm65", 15, {"IC_48150_Gwarek_Train"} },
        { "IC_48150_Gwarek_Train", "KO_M1", 340, {"IC_48150_Gwarek_Train"} },
        { "IC_37002_Odra_Train", "KO_N3", 200, {"IC_37002_Odra_Train"} },
    }
end