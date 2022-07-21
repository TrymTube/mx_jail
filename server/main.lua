ESX = exports['es_extended']:getSharedObject()

MySQL.ready(function()
    -- auto-add table if not exists
    MySQL.Sync.execute(
        'ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `jail_time` INT NOT NULL DEFAULT 0, ADD COLUMN IF NOT EXISTS `jail_remaintime` INT NOT NULL DEFAULT 0'
    )
end)

ESX.RegisterServerCallback('mx_jail:getDBValues', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
   
    MySQL.Async.fetchAll('SELECT jail_time, jail_remaintime FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result then 
            cb(result, os.time())
        end
    end)
end)

ESX.RegisterServerCallback('mx_jail:getJailedPlayer', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM users', function(result)
        cb(result, os.time())
    end)
end)

ESX.RegisterServerCallback('mx_jail:getNames', function(source, cb, name)
    local xPlayers = ESX.GetExtendedPlayers()
    local doesNameExist = false

    for k, xPlayer in pairs(xPlayers) do
        local upperName = string.upper(name)
        local upperNames = string.upper(xPlayer.getName())

        if upperName == upperNames then
            doesNameExist = true
        end

        if doesNameExist then
            cb(true, xPlayer.source)
        elseif not doesNameExist then
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('mx_jail:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local JobName = xPlayer.getJob()
    
    if JobName then
        cb(JobName)
    else
        cb('Error')
    end
end)

ESX.RegisterServerCallback('mx_jail:getDBValuesPlayer', function(source, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
   
    MySQL.Async.fetchAll('SELECT jail_time, jail_remaintime FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result then 
            cb(result, os.time())
        else
            print('result nil')
        end
    end)
end)

-- sets the time when jailed
RegisterNetEvent('mx_jail:setTime')
AddEventHandler('mx_jail:setTime', function(playerID, time)
    local targetxPlayer = ESX.GetPlayerFromId(playerID)
    local osTime = os.time()

    MySQL.update('UPDATE users SET jail_time = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, time, targetxPlayer.identifier})
end)

-- sets the time when jailed
RegisterNetEvent('mx_jail:setOSTime')
AddEventHandler('mx_jail:setOSTime', function(targetxPlayer)
    local osTime = os.time()

    MySQL.update('UPDATE users SET jail_time = ? WHERE identifier = ?', {osTime, targetxPlayer.identifier})
end)

-- Updates the time
RegisterNetEvent('mx_jail:updateTime')
AddEventHandler('mx_jail:updateTime', function(identifier, time)
    local osTime = os.time()

    MySQL.update('UPDATE users SET jail_time = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, time, identifier})
end)

-- clear the time when online
RegisterNetEvent('mx_jail:clearTime')
AddEventHandler('mx_jail:clearTime', function(playerID, time)
    local xPlayer = ESX.GetPlayerFromId(playerID)
    local osTime = 0

    MySQL.update('UPDATE users SET jail_time = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, time, xPlayer.identifier})
end)

-- clear the time when player Offline
RegisterNetEvent('mx_jail:clearTimeOffline')
AddEventHandler('mx_jail:clearTimeOffline', function(identifier, time)
    local osTime = 0

    MySQL.update('UPDATE users SET jail_time = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, time, identifier})
end)


-- Jail the Player
RegisterNetEvent('mx_jail:jailPlayer')
AddEventHandler('mx_jail:jailPlayer', function(target)
    TriggerClientEvent('mx_jail:jailPlayer', target)
end)

-- Unjail the Player
RegisterNetEvent('mx_jail:unJail')
AddEventHandler('mx_jail:unJail', function(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer ~= nil then
        TriggerClientEvent('mx_jail:unJailPlayer', xPlayer.source)
        TriggerEvent('mx_jail:clearTime', xPlayer.source, 0)
    else
        TriggerEvent('mx_jail:clearTimeOffline', identifier, 0) -- Unjail Player when Offline
    end
end)