function WaitUntilPlayerCabinIsActive(cabin)
    if not (cabin == -1 or cabin == 0 or cabin == 1) then
        return
    end
    
    local playerTrainset = GetPlayerTrainset()
    WaitUntil(function ()
        return playerTrainset.CabinDir == cabin
    end)
end

function IsPlayerActiveCabinEqual(cabin)
    if not (cabin == -1 or cabin == 0 or cabin == 1) then
        return false
    end
    
    local playerTrainset = GetPlayerTrainset()

    if playerTrainset.CabinDir ~= cabin then
        Log("Cabine check not passed, player: " .. playerTrainset.CabinDir .. ", cabin: " .. cabin)
    end

    return playerTrainset.CabinDir == cabin
end

function PlayerActiveCabinCheck(cabin)
    return function ()
        return IsPlayerActiveCabinEqual(cabin)
    end
end