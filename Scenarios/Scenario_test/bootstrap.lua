-- SimRail - The Railway Simulator
-- LUA Scripting scenario
-- Version: 1.0
--
require("SimRailCore")

DeveloperMode = function()
    return true
end
StartPosition = {-9272.38, 265.97, 1498.98}
Sounds = {}

IntroDelays = 15

--- Function called by SimRail when the loading of scenario starts - generally
--- designed for setting up necessery data and preloading-assets
function PrepareScenario() end

--- Function called by SimRail when the loading finishes - you should set scenario
--- time in here, spawn trains etc. After calling this mission recorder is started
--- and stuff gets registered
function EarlyScenarioStart()
    StartRecorder()
    SetCameraView(CameraView.FirstPersonWalkingOutside)

    PlayerTrainset = SpawnTrainsetOnSignal("Player", FindSignal("KO_Tm506"), 10, false, true, false, false, {
        CreateNewSpawnFullVehicleDescriptor(LocomotiveNames.EP07_174, false, "", 0, BrakeRegime.P),
    })
    PlayerTrainset.SetState(DynamicState.dsStop, TrainsetState.tsTrain, false)
    
    AITrainset = SpawnTrainsetOnSignal("Cars", FindSignal("KO_Tm506"), 35, false, false, false, false, {
        CreateNewSpawnFullVehicleDescriptor(PassengerWagonNames.B10nouz_5151_2071_102_0, false, "", 0, BrakeRegime.P),
        CreateNewSpawnFullVehicleDescriptor(PassengerWagonNames.B11bmnouz_6151_2170_098_8, false, "", 0, BrakeRegime.P),
        CreateNewSpawnFullVehicleDescriptor(PassengerWagonNames.B10nou_5051_2008_607_7, false, "", 0, BrakeRegime.P),
    })

    SetDateTime( DateTimeCreate(2024, 05, 03, 5, 20, 00) )
    SetWeather(WeatherConditionCode.FewClouds, 15, 1015, 65, 2000, 353, 1, 0, true)
end