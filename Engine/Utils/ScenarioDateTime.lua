require("SimRailCore")

--- Configures some DateTime functions. This doesn't physically set date or time of the scenario. It should be done using scenario's manifest file.
---@param year  integer Year of the date
---@param month integer Month of the date
---@param day   integer Day of the date
function SetScenarioDate(year, month, day)
    SetValue("_scenarioDate", {
        year = year,
        month = month,
        day = day
    })
end

--- Creates TimeSpan of given seconds
---@param seconds integer Duration of TimeSpan in seconds
---@return TimeSpan
function CreateTimeSpanSeconds(seconds) 
    return TimeSpanCreate(0, 0, 0, seconds, 0)
end

--- Returns DateTime object of previously set scenario date and given time.
---@param hours integer Hours 0-23
---@param minutes integer Minutes 0-59
---@param seconds integer Seconds 0-59
---@return DateTime
function CreateScenarioTimeStamp(hours, minutes, seconds)
    local date = GetValue("_scenarioDate")

    return DateTimeCreate(date.year, date.month, date.day, hours, minutes, seconds)
end