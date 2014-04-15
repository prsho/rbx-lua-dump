--[[
  This module is used to easily make calls to the data store service.

  Usage example:

    -- Where this module is located in the game.
    local Data = require(game.Workspace.DataModule)

    Data:Put("Server", "version", "v0.1.0")
    print(Data:Get("Server", "version")) -- "v0.1.0"

    Data:Delete("Server", "version")
    print(Data:Get("Server", "version")) -- "deleted"

  Namespaces/Scopes can be set as an optional last argument:

    Data:Put("Server", "version", "v0.1.0-alpha.1", "customNamespace")
    print(Data:Get("Server", "version")) -- "v0.1.0" (Assuming you used the earlier example, otherwise no value will appear.)
    print(Data:Get("Server", "version", "customNamespace")) -- "v0.1.0-alpha.1"

  If you want to understand how some aspects of this module works, then I
  encourage you to take a look at the following Wiki pages:

  - http://wiki.roblox.com/index.php?title=Module_scripts
  - http://wiki.roblox.com/index.php?title=Data_store
  - http://wiki.roblox.com/index.php?title=Methods
  - http://wiki.roblox.com/index.php?title=Boolean#Or
--]]

local DataStore = game:GetService("DataStoreService")

local DEFAULT_SCOPE = "global"

local Data = {}

-- Data methods are named after the HTTP request methods. :)

--[[
  string storeName The name of the DataStore you want to access.
  string key       The key name to be used with the value when storing the data.
  any    value     Accepts any value (other than 'nil') to be applied as the value for 'key'.
  string scope     Optional last argument to set the scope/namespace of the DataStore.
--]]

-- Creates a new key/value pair in the data store.
function Data:Post(storeName, key, value, scope)
  local scope = scope or DEFAULT_SCOPE
  local dataStore = DataStore:GetDataStore(storeName, scope)

  dataStore:SetAsync(key, value)
end

-- Updates a key/value pair in the data store and will create the pair if not
-- found.
function Data:Put(storeName, key, value, scope)
  local scope = scope or DEFAULT_SCOPE
  local dataStore = DataStore:GetDataStore(storeName, scope)

  function updateCallback()
    return value
  end

  dataStore:UpdateAsync(key, updateCallback)
end

-- Returns the key from the data store for use in the game.
function Data:Get(storeName, key, scope)
  local scope = scope or DEFAULT_SCOPE
  local dataStore = DataStore:GetDataStore(storeName, scope)

  return dataStore:GetAsync(key)
end

-- Sets the key's value to the string "deleted" to indicate that it's been
-- removed.
function Data:Delete(storeName, key, scope)
  local scope = scope or DEFAULT_SCOPE

  self:Post(storeName, key, "deleted", scope)
end

return Data
