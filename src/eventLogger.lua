---@param Config table: Contains the server configuration, including payload size limits for StateBag data and events.
local Config = require('shared.config')

---@param Config table: If the logger is disabled, the script stops here.
if not Config.EnableLogger then return end

---@param bagName string: The name of the StateBag (could be the name of a player, vehicle, etc.)
---@param key string: The key associated with the value inside the StateBag.
---@param value mixed: The value associated with the key in the StateBag. It can be a table, string, boolean, or `nil`.
AddStateBagChangeHandler(nil, nil, function(bagName, key, value)
    local attackName, attack = false, false
    local valData = value
    if #key > Config.maxStateBagPayload then
        attack = true
    elseif #bagName > Config.maxStateBagPayload then
        attackName = true
        attack = true
    end
    if type(value) == 'table' or type(value) == 'string' then
        if #value > Config.maxStateBagPayload then
            attack = true
        end
        valData = tostring(#value) .. ' Bytes'
    elseif type(value) == 'boolean' then
        valData = tostring(value)
    elseif type(value) == 'nil' then
        valData = 'nil'
    end
    if attack then
        if not attackName then
            print('^3[WARNING]^0 Suspicious StateBag Detected: ' .. bagName)
        end
        print(string.format('^3[WARNING]^0 Possible Attack StateBag | BagNameLength: %dB | KeyLength: %dB | ValLength: %s', #bagName, #key, valData))
    elseif #key > Config.maxLogStateBagPayload or #bagName > Config.maxLogStateBagPayload then
        print(string.format('^4[INFO]^0 Logging StateBag | BagName: %s | Key: %s | Val: %s', bagName, key, valData))
    end
end)

---@param resource string: The name of the resource that is generating the event.
---@param eventName string: The name of the event being logged.
---@param eventData table: The data associated with the event.
---@param eventSource string: The source of the event (e.g., "Server", "Client").
---@param eventPayload number: The size of the event data in bytes.
AddEventHandler('consolelog', function(resource, eventName, eventData, eventSource, eventPayload)
    for _, v in pairs(Config.ignoreEvents) do
        if eventName == v then return end
    end
    if eventPayload > Config.maxEventPayload then
        local eventSourceFormatted = eventSource == '' and 'Internal' or eventSource
        print(string.format('^3[WARNING] [C->S]^0 Event Sniper: %s | Name: %s | Src: %s | Size: %dB', resource, eventName, eventSourceFormatted, eventPayload))
    end
end)

---@param resource string: The name of the resource generating the event.
---@param playerId string: The ID of the player sending the event.
---@param eventName string: The name of the event being logged.
---@param eventPayload number: The size of the event data in bytes.
AddEventHandler('consolelog_client', function(resource, playerId, eventName, eventPayload)
    for _, v in pairs(Config.ignoreEvents) do
        if eventName == v then return end
    end
    if eventPayload > Config.maxEventPayload * 5 then
        print(string.format('^1[WARNING] [S->C]^0 Big Event Sniper | Resource: %s | Name: %s | Src: %s | Size: %dB', resource, eventName, playerId, eventPayload))
    elseif eventPayload > Config.maxEventPayload then
        print(string.format('^3[WARNING] [S->C]^0 Event Sniper: %s | Name: %s | Src: %s | Size: %dB', resource, eventName, playerId, eventPayload))
    end
end)

---@param resource string: The name of the resource generating the event.
---@param playerId string: The ID of the player sending the event.
---@param eventName string: The name of the event being logged.
---@param eventPayload number: The size of the event data in bytes.
---@param bps number: The bits per second (bps) rate of the event data.
AddEventHandler('consolelog_client_latent', function(resource, playerId, eventName, eventPayload, bps)
    for _, v in pairs(Config.ignoreEvents) do
        if eventName == v then return end
    end
    if eventPayload > Config.maxEventPayload then
        print(string.format('^4[INFO] [S->C]^0 Latent Event Sniper: %s | Name: %s | Src: %s | Size: %dB | Bps: %d', resource, eventName, playerId, eventPayload, bps))
    end
end)

---@param versionConvar string: The convar representing the current version of the FXServer.
---@param fxServerVersion string: The version of FXServer being used.
---@param code number: The HTTP status code returned from the external check.
---@param data string: The response data from the external check, usually JSON.
---@param errorData string: Error data if the request fails.
local function checkArtifactVersion()
    local versionConvar = GetConvar('version', 'Unknown')
    local fxServerVersion = versionConvar:match('v%d+%.%d+%.%d+%.(%d+)')
    PerformHttpRequest('https://artifacts.jgscripts.com/check?artifact=' .. (fxServerVersion or 'Unknown'), function (code, data, _, errorData)
        if code ~= 200 or not data or errorData then
            print('^4[INFO]^0 Could not check artifact version.')
            return
        end
        local json = json.decode(data)
        if json and json.status == 'BROKEN' then
            print('^3[WARNING]^0 The FXServer version you are currently using has known issues.')
        else
            print('^4[INFO]^0 The FXServer version you are currently using is correct.')
        end
    end)
end

---@param functionCall string: Call to `checkArtifactVersion()`, which checks the FXServer version.
checkArtifactVersion()