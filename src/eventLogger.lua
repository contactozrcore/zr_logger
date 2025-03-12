local Config = require('shared.config')

if not Config.EnableLogger then return end

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

AddEventHandler('consolelog', function(resource, eventName, eventData, eventSource, eventPayload)
    for _, v in pairs(Config.ignoreEvents) do
        if eventName == v then return end
    end
    if eventPayload > Config.maxEventPayload then
        local eventSourceFormatted = eventSource == '' and 'Internal' or eventSource
        print(string.format('^3[WARNING] [C->S]^0 Event Sniper: %s | Name: %s | Src: %s | Size: %dB', resource, eventName, eventSourceFormatted, eventPayload))
    end
end)

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

AddEventHandler('consolelog_client_latent', function(resource, playerId, eventName, eventPayload, bps)
    for _, v in pairs(Config.ignoreEvents) do
        if eventName == v then return end
    end
    if eventPayload > Config.maxEventPayload then
        print(string.format('^4[INFO] [S->C]^0 Latent Event Sniper: %s | Name: %s | Src: %s | Size: %dB | Bps: %d', resource, eventName, playerId, eventPayload, bps))
    end
end)

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

checkArtifactVersion()