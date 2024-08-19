require("SimRailCore")

function CreateStaticTrains()
    return {
        -- {
        --     "KO_Tm506", 41, {
        --         PassengerCars.IC_1CLASS_IC_VARIANT_1,
        --         PassengerCars.IC_1CLASS_IC_VARIANT_2,
        --         PassengerCars.IC_2CLASS_WITH_WC_VARIANT_2,
        --         PassengerCars.IC_WARS,
        --         PassengerCars.IC_2CLASS_WITH_WC_FOR_DISABLED,
        --         PassengerCars.IC_2CLASS_WITH_WC_VARIANT_3,
        --     }
        -- },
        {
            "KO_Tm506", 186, {
                PassengerCars.TLK_2CLASS_GREEN_WAGON_WITH_OVAL_WINDOWS,
                PassengerCars.TLK_2CLASS_GREY_WITH_SQUARE_WINDOWS,
                PassengerCars.TLK_2CLASS_GREEN_WITH_SQUARE_WINDOWS,
            }
        },
        {
            "t11398", 33, {
                CreateRandomCargoCars(8, 1, {
                    CargoCars.Z424_BLUE,
                    CargoCars.Z424_BROWN,
                }, {
                    CargoLoads_424Z.SHEET_METAL
                })
            }
        },

    }
end
