ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('mx_jail:getDBValues', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
   
    MySQL.Async.fetchAll('SELECT jail_time, jailed_date, jail_remaintime FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
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

-- RegisterNetEvent('mx_jail:getPlayerNames')
-- AddEventHandler('mx_jail:getPlayerNames', function()
--     local source = source 
--     local xPlayer = ESX.GetPlayerFromId(source)
    
--     local query = MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = ?', {xPlayer.identifier})
    
--     local data = {
--         firstname = query[1].firstname,
--         lastname = query[1].lastname,
--         fullname = query[1].firstname..' '..query[1].lastname,
--     }
-- end)

ESX.RegisterServerCallback('mx_jail:getNames', function(source, cb, name)
    local xPlayers = ESX.GetExtendedPlayers()
    local doesNameExist = false
    local targetxPlayer

    for k, xPlayer in pairs(xPlayers) do
        local upperName = string.upper(name)
        local upperNames = string.upper(xPlayer.getName())

        if upperName == upperNames then
            doesNameExist = true
        end

        targetxPlayer = xPlayer.source
    end

    if doesNameExist then
        cb(true, targetxPlayer, source)
    elseif not doesNameExist then
        cb(false)
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
   
    MySQL.Async.fetchAll('SELECT jail_time, jailed_date, jail_remaintime FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
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
    local raw = os.date("*t")
    local clock
    local date
    
    if Config.USClock then
        clock = os.date("%I:%M %p")
        date = raw.month.."/"..raw.day.."/"..raw.year
    else
        clock = os.date("%H:%M")
        date = raw.day.."."..raw.month.."."..raw.year
    end

    local jailedDate = date.." ".. clock

    MySQL.update('UPDATE users SET jail_time = ?, jailed_date = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, jailedDate, time, targetxPlayer.identifier})
end)

-- Updates the time
RegisterNetEvent('mx_jail:updateTime')
AddEventHandler('mx_jail:updateTime', function(identifier, time)
    local osTime = os.time()
    local raw = os.date("*t")
    local clock
    local date
    
    if Config.USClock then
        clock = os.date("%I:%M %p")
        date = raw.month.."/"..raw.day.."/"..raw.year
    else
        clock = os.date("%H:%M")
        date = raw.day.."."..raw.month.."."..raw.year
    end

    local jailedDate = date.." ".. clock

    MySQL.update('UPDATE users SET jail_time = ?, jailed_date = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, jailedDate, time, identifier})
end)

-- clear the time when online
RegisterNetEvent('mx_jail:clearTime')
AddEventHandler('mx_jail:clearTime', function(playerID, time)
    local xPlayer = ESX.GetPlayerFromId(playerID)
    local osTime = 0
    local jailedDate = 01 ..".".. 01 ..".".. 2000

    MySQL.update('UPDATE users SET jail_time = ?, jailed_date = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, jailedDate, time, xPlayer.identifier})
end)

-- clear the time when player Offline
RegisterNetEvent('mx_jail:clearTimeOffline')
AddEventHandler('mx_jail:clearTimeOffline', function(identifier, time)
    local osTime = 0
    local jailedDate = 01 ..".".. 01 ..".".. 2000

    MySQL.update('UPDATE users SET jail_time = ?, jailed_date = ?, jail_remaintime = ? WHERE identifier = ?', {osTime, jailedDate, time, identifier})
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