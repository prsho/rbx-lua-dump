--[[
  This script takes care of server-specific lighting tasks.

  The main functionality consists of a time cycle, and creating a 'time of day'
  value for other scripts to hook into.
--]]

local timeIncrement = 1.5 -- The amount added on to the current time every recurrence.
local loopSpeed = 0       -- How long the loop will wait() before adding timeIncrement.

local lighting = game.Lighting

--[[
  Note: the 'currentTime' variable needs to be defined inside the scope of
  the functions that will be looped. If it's defined in the global scope, it
  will never be redefined by the loop (getting the current time).
--]]

function runLightingLoop()
  while wait(loopSpeed) do
    outputTimeOfDay()
    timeCycle()
  end
end

--[[
  Increments a value onto the current time to cycle through the day/night.
--]]
function timeCycle()
  local currentTime = lighting:GetMinutesAfterMidnight()

  lighting:SetMinutesAfterMidnight(currentTime + timeIncrement)
end

--[[
  Uses variables to denote the times of the day, checks them against the
  current time and returns a string of the time of day.
--]]
function getCurrentTime()
  local currentTime = lighting:GetMinutesAfterMidnight()

  local midnight = 0
  local dawn     = 300
  local morning  = 360
  local midday   = 720
  local evening  = 1050
  local dusk     = 1100

  -- The '>=' operator is needed or else there's a point where no value is true,
  -- causing the script to break.

  if currentTime >= midnight and currentTime < dawn then
    return "midnight"
  elseif currentTime >= dawn and currentTime < morning then
    return "dawn"
  elseif currentTime >= morning and currentTime < midday then
    return "morning"
  elseif currentTime >= midday and currentTime < evening then
    return "midday"
  elseif currentTime >= evening and currentTime < dusk then
    return "evening"
  -- 'midnight' is a smaller value than 'dusk', need to use the 'or' operator.
  elseif currentTime >= dusk or currentTime < midnight then
    return "dusk"
  end
end


--[[
  Creates the TimeOfDay value if it doesn't exist and defines it as a global
  variable for other scripts to hook into.
--]]
function generateTimeValue()
  if not script:FindFirstChild("TimeOfDay") then
    local timeValue = Instance.new("StringValue", script)
    timeValue.Name = "TimeOfDay"
  end

  _G.TimeOfDay = script.TimeOfDay
end

--[[
  Takes the returned string from getCurrentTime() and applies it to the TimeOfDay
  value.
--]]
function outputTimeOfDay()
  local timeOfDay = script.TimeOfDay

  -- Only update the time if it's changed.
  if timeOfDay.Value ~= getCurrentTime() then
    timeOfDay.Value = getCurrentTime()
  end
end

print("Loaded " .. script.Name)

-- Generate the TimeOfDay value and get the loop started.
generateTimeValue()
runLightingLoop()
