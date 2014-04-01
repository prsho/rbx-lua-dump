--[[

]]

repeat wait() until _G.ready

local Data = require(_G.modules.Data)

local version = _G.version -- v0.1.0-alpha.1
local versionNumber = version:match("v%d\.%d\.%d") -- v0.1.0
local preReleaseVersion = version:match("\-%a*\.%d") -- -alpha.1

--[[
  Takes the version string and seperates each part into a key/value pair in a table.
  eg. v0.1.0-alpha.1 would be turned into:

  {
    "full" = "v0.1.0-alpha.1",
    "major" = 0,
    "minor" = 1,
    "patch" = 0,
    "alpha" = 1
  }

]]
function convertVersionToTable()
  local versionTable = {
    full = version
  }

  function majorMinorPatch()
    -- Is there a method I can use to accomplish this
    -- without an iterator variable?
    local iterator = 0
    for digit in versionNumber:gmatch("%d") do
      if iterator == 0 then
        versionTable.major = digit
      elseif iterator == 1 then
        versionTable.minor = digit
      elseif iterator == 2 then
        versionTable.patch = digit
      end

      iterator = iterator +1
    end
  end

  function preRelease()
    versionTable[preReleaseVersion:match("%a+")] = preReleaseVersion:match("%d") -- alpha = 1
  end

  majorMinorPatch()

  if preReleaseVersion then
    preRelease()
  end

  return versionTable
end

convertVersionToTable()