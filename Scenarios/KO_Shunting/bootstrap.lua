-- SimRail - The Railway Simulator
-- LUA Scripting framework
-- Version: 2.0
--
-- Framework created by Budnix
-- Developed and extended by vardazed
-- Scenario version 1.0

----  REQUIRES  ----

require("SimRailCore")

require("Engine/InitScenarioStory")

require("Scripts/Test")
require("Scripts/CreateAITrains")
require("Scripts/CreateStaticTrains")
require("Scripts/PlayerEvents")
require("Scripts/PlayerRadioCalls")
require("Scripts/TrainEvents")
require("Scripts/TrainStateTriggers")

require("Sounds/SoundsList")


----  DEVELOPER MODE  ----

DeveloperMode = function()
    return true
end


----  REGISTERS  ----

RegisterValue("scenarioBegun",    false)

RegisterValue("phaseGwarekDone",  false)
RegisterValue("phasePoloniaDone", false)
RegisterValue("phaseTLKDone",     false)

RegisterValue("icOdraArrived",    false)
RegisterValue("icOdraDeparted",   false)
RegisterValue("icPoloniaArrived", false)

RegisterValue("gwarekAttached",   false)
RegisterValue("odraAttached",     false)
RegisterValue("tlkAttached",      false)

RegisterValue("outOfKO1",           false)
RegisterValue("odraOutOfPlatforms", false)
RegisterValue("reversedTm1",        false)
RegisterValue("backInKO1",          false)

RegisterValue("Os40907Gone", false)


----  STARTING CONFIG  ----

StartPosition = {-9272.38, 266.57, 1498.98}

IntroDelays = 15
ScenarioStory = {
    radioCalls = PlayerRadioCalls(),
    playerEvents = PlayerEvents(),
    trainEvents = TrainEvents(),
    trainStateTriggers = TrainStateTriggers(),
    aiTrains = CreateAITrains(),
    staticTrains = CreateStaticTrains()
}

--- Function called by SimRail when the loading of scenario starts - generally
--- designed for setting up necessery data and preloading-assets
function PrepareScenario() end

--- Function called by SimRail when the loading finishes - you should set scenario
--- time in here, spawn trains etc. After calling this mission recorder is started
--- and stuff gets registered
function EarlyScenarioStart()
    StartRecorder()
    SetCameraView(CameraView.FirstPersonWalkingOutside)
    SetBlockTeleportation(false)


    -- Date and time of scenario start: 24.08.2024 @ 5:20
    SetScenarioDate( 2024, 08, 24 )
    SetWeather(WeatherConditionCode.FewClouds, 15, 1015, 65, 2000, 353, 1, 0, true)


    -- player train -- KO_Tm501@25 --
    local trainState = SpawnPlayerTrainset("KO_Tm501", 25, false, false, {
        Locomotives.EP07_174_GREEN_OLD,
    })

    -- trainState:GetTrainset().SetState(DynamicState.dsStop, TrainsetState.tsShunting, true)
    trainState:GetTrainset().SetState(DynamicState.dsCold, TrainsetState.tsDeactivation, true)
    trainState:GetTrainset().SetRadioChannel(9, true)
    trainState:GetTrainset().SetPaperTimetable("Papers")
    trainState:SetTimetable("PlayerTimetable25")
    

    -- eye target
    local eyeTarget = FindTrack("t9297").transform.position
    eyeTarget.y = eyeTarget.y + 3
    CameraTurnTowards(eyeTarget, false)


    -- intro message
    DisplayMessage("MissionIntro1", IntroDelays)
    CreateCoroutine(function ()
        coroutine.yield(CoroutineYields.WaitForSeconds, IntroDelays + 1)
        DisplayMessage("MissionIntro2", IntroDelays)
    end)

    -- fail mission if too slow start
    CallAsCoroutine(function ()
        coroutine.yield(CoroutineYields.WaitForIngameDateTime, CreateScenarioTimeStamp(5, 45, 00))
        
        if not GetValue("outOfKO1") then
            DisplayMessage("Mission_time_exceeded", 7)
            coroutine.yield(CoroutineYields.WaitForSeconds, 7)
            FinishMission(MissionResultEnum.Failed)
        end
    end)

    -- initialize story
    InitScenarioStory(ScenarioStory)
end