-- SimRail - The Railway Simulator
-- LUA Scripting scenario
-- Version: 1.0
--
require("SimRailCore")
require("Scripts/Test")
require("Engine/InitScenarioStory")
require("Scripts/CreateAITrains")
require("Scripts/CreateStaticTrains")
require("Scripts/PlayerEvents")
require("Scripts/PlayerRadioCalls")
require("Scripts/TrainEvents")
require("Scripts/TrainStateTriggers")

DeveloperMode = function()
    return true
end
-- StartPosition = {-10605.89, 273.49, 1545.28} -- KO
StartPosition = {-9272.38, 265.97, 1498.98}
Sounds = {}

IntroDelays = 15
ScenarioStory = {
    radioCalls = PlayerRadioCalls(),
    playerEvents = PlayerEvents(),
    trainEvents = TrainEvents(),
    trainStateTriggers = TrainStateTriggers(),
    aiTrains = CreateAITrains(),
    staticTrains = CreateStaticTrains()
}

RegisterValue("scenarioBegun",    false)

RegisterValue("phaseGwarekDone",  false)
RegisterValue("phasePoloniaDone", false)

RegisterValue("icOdraArrived",    false)
RegisterValue("icOdraDeparted",   false)
RegisterValue("icPoloniaArrived", false)

RegisterValue("odraAttached",     false)
RegisterValue("tlkAttached",      false)

--- Function called by SimRail when the loading of scenario starts - generally
--- designed for setting up necessery data and preloading-assets
function PrepareScenario() end

--- Function called by SimRail when the loading finishes - you should set scenario
--- time in here, spawn trains etc. After calling this mission recorder is started
--- and stuff gets registered
function EarlyScenarioStart()
    StartRecorder()
    SetCameraView(CameraView.FirstPersonWalkingOutside)

    -- - player train -- KO_Tm501@25 --
    local trainState = SpawnPlayerTrainset("KO_Tm501", 25, false, false, {
        Locomotives.EP07_174_GREEN_OLD,
    })

    -- local eyeTarget = trainState:GetTrainset().transform.position
    local eyeTarget = FindTrack("t9297").transform.position
    eyeTarget.y = eyeTarget.y + 3
    CameraTurnTowards(eyeTarget, false)

    trainState:GetTrainset().SetState(DynamicState.dsStop, TrainsetState.tsShunting, true)
    trainState:GetTrainset().SetRadioChannel(7, true)
    -- trainset.SetPaperTimetable("Papers")

    -- Date and time of scenario start: 24.08.2024 @ 5:20
    SetScenarioDate( 2024, 08, 24 )
    SetWeather(WeatherConditionCode.FewClouds, 15, 1015, 65, 2000, 353, 1, 0, true)
    InitScenarioStory(ScenarioStory)
end