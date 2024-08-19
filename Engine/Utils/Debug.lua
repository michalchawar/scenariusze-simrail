require("SimRailCore")

function LIST_SPAWNED_AI_TRAINS()
    for k, v in pairs(GetRef("_trainStates")) do
        if (v:GetTrainset() ~= nil) then
            Log("AI Train: " .. k)
        end
    end

    Log("Spawned AI trains: " .. GetValue("_spawnedTrainsetsCount"))
end

function LIST_SPAWNED_STATIC_TRAINS()
    for k, staticTrain in pairs(GetRef("_staticTrains")) do
        if (staticTrain:GetTrainset() ~= nil) then
            Log("Static Train: " .. string.gsub(staticTrain:GetTrainset().name, "^trainset%-", ""))
        end
    end

    Log("Spawned static trains: " .. GetValue("_spawnedStaticTrainsetsCount"))
end