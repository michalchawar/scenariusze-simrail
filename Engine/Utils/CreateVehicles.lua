---@param vehiclesList table<PassengerCars | CargoCars | Locomotives | EZT> The vehicle ids/names
---@param reversed? boolean|nil Default: false. Whether to reverse the vehicles list
---@param brakeRegime? BrakeRegime|nil Default: BreakRegime.None. The brake regime that will be set to created vehicles
---@return table<SpawnVehicleDescription>
function CreateVehicles(vehiclesList, reversed, brakeRegime)
    local vehicles = {}

    if reversed == nil then
        reversed = false
    end
    if brakeRegime == nil then
        brakeRegime = BrakeRegime.None
    end
        
    -- if brakeRegime == BrakeRegime.None then
    --     Log("Brake Regime: None, number of vehicles: " .. #vehiclesList)
    -- end

    for k, v in pairs(vehiclesList) do
        local vehicle

        if (type(v) == "table") then
            for l, vehicleDescriptor in pairs(v) do
                if (type(vehicleDescriptor) == "userdata") then
                    table.insert(vehicles, vehicleDescriptor)
                end
            end
        elseif (type(v) == "function") then
            for l, vehicleDescriptor in pairs(v()) do
                if (type(vehicleDescriptor) == "userdata") then
                    table.insert(vehicles, vehicleDescriptor)
                end
            end
        elseif (type(v) == "string") then
            table.insert(vehicles, CreateNewSpawnFullVehicleDescriptor(v, reversed, nil, 0, brakeRegime))
        elseif (type(v) == "userdata") then
            table.insert(vehicles, v)
        end
    end

    if (reversed) then
        vehicles = table.reverse(vehicles)
    end

    return vehicles
end