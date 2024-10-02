require("SimRailCore")

function TrainStateTriggers()
    return {
        { "Player", "KO_Tm29", 50, {"IC_48150_Gwarek_Train"} },
        { "Player", "KO_M7", 287, {"IC_48150_Gwarek_Train"} },
        { "Player", "KO_N1", 410, {"Pr_34301"} },
        { "Player", "KO_N1", 180, {"IC_37002_Odra_Train"} },
        { "Player", "KO_K", 150, {"Os_40907"} },
        { "Player", "KO_Tm34", 20, {"IC_14002_Polonia_Train"} },
        { "Player", "KO_N3", 380, {"IC_38103_Chelmonski"} },
        
        { "IC_48150_Gwarek_Train", "KO_Tm65", 15, {"IC_48150_Gwarek_Train"} },
        { "IC_48150_Gwarek_Train", "KO_M1", 390, {"IC_48150_Gwarek_Train"} },
        { "IC_37002_Odra_Train", "KO_N3", 200, {"IC_37002_Odra_Train"} },

        { "Pr_43800", "KO_M10", 150, {"Pr_43800"} },
        { "Pr_43218", "KO_M2",  150, {"Pr_43218"} },
        { "Os_40653", "KO_D",   150, {"Os_40653"} },
        -- { "IC_38103_Chelmonski", "KO_N3",  150, {"IC_38103_Chelmonski"} },
        -- { "Os_40653", "KO_N7",   150, {"Os_40653"} },
        -- { "Os_40606", "KO_M4",   150, {"Os_40606"} },
        
        --- shunting in and out of platforms
        { "Os_40604", "KO_E18",  100, {"Os_40402"} },
        { "Os_40402", "KO_N8",   150, {"Os_40402"} },
        { "Os_40404", "KO_Tm14", 150, {"Os_40404"} },
        { "Os_40404", "KO_N7",   150, {"Os_40404"} },
    }
end