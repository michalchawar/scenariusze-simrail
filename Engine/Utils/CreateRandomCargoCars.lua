---@param carsCount number The number of cars to generate
---@param loadMass number The total mass of loads in all cars
---@param vehiclesPool table<string> The the list of the car types to pick up
---@param loadsPool table<string> The the list of the cargo loads to pick up
---@return function
function CreateRandomCargoCars(carsCount, loadMass, vehiclesPool, loadsPool)
    return function()
        local cars = {}

        for index = 1, carsCount do
            local vehicleType = vehiclesPool[math.random(#vehiclesPool)]
            local loadType = loadsPool[math.random(#loadsPool)]
            local car
            local brakeRegime = BrakeRegime.G

            if (index >= 5) then
                brakeRegime = BrakeRegime.P
            end

            if (loadType == "none") then
                -- car = CreateNewSpawnVehicleDescriptor(vehicleType, false)
                loadType = nil
            end

            car = CreateNewSpawnFullVehicleDescriptor(
                vehicleType,
                false,
                loadType,
                loadMass,
                brakeRegime
            )

            index = index + 1
            table.insert(cars, car)
        end

        return cars;
    end
end