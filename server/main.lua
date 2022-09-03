ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('mx_jail:getDBValues', function(source, cb)
    local source = source
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

-- Get History
ESX.RegisterServerCallback('mx_jail:getHistory', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM jail_history ORDER BY id', {}, function(result)
        cb(result)
    end)
end)

-- Update History
RegisterNetEvent('mx_jail:updateHistory')
AddEventHandler('mx_jail:updateHistory', function(source, player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local sourcexPlayer
    local sourceName

    if type(source) == 'number' then
        sourcexPlayer = ESX.GetPlayerFromId(source) 
        sourceName = source

        if sourcexPlayer ~= nil then
            sourceName = sourcexPlayer.getName()
        end
    elseif type(source) == 'string' then
        sourceName = source
    end

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

    local fullDate = date.." "..clock
    
    if xPlayer then
        -- Old Not Performant
        -- MySQL.Async.fetchAll('SELECT id, identifier FROM jail_history WHERE identifier = ?', {xPlayer.identifier}, function(result)

        --     MySQL.update('UPDATE jail_history SET unjailed_by = ?, unjailed_date = ? WHERE id = ?', {sourceName or _U('title_released'), fullDate, result[#result].id})
        -- end)

        -- New Performant
        MySQL.Async.fetchAll('SELECT id, identifier FROM jail_history WHERE identifier = ? ORDER BY id LIMIT 10', {xPlayer.identifier}, function(result)

            if Config.Debug then
                print(ESX.DumpTable(result))
            end


            MySQL.update('UPDATE jail_history SET unjailed_by = ?, unjailed_date = ? WHERE id = ?', {sourceName or _U('title_released'), fullDate, result[#result].id})
        end)
    else
        -- Old Not Performant
        -- MySQL.Async.fetchAll('SELECT id, identifier FROM jail_history WHERE identifier = ?', {player}, function(result)

        --     MySQL.update('UPDATE jail_history SET unjailed_by = ?, unjailed_date = ? WHERE id = ?', {sourceName or _U('title_released'), fullDate, result[#result].id})
        -- end)

        -- New Performant
        MySQL.Async.fetchAll('SELECT id, identifier FROM jail_history WHERE identifier = ? ORDER BY id LIMIT 10', {player}, function(result)
    
            if Config.Debug then
                print(ESX.DumpTable(result))
            end

            MySQL.update('UPDATE jail_history SET unjailed_by = ?, unjailed_date = ? WHERE id = ?', {sourceName or _U('title_released'), fullDate, result[#result].id})
        end)
    end
end)

-- sets jail history
RegisterNetEvent('mx_jail:setHistory')
AddEventHandler('mx_jail:setHistory', function(playerId, jail_time, jailed_by, jailed_name)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jailedName = xPlayer.getName()
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

    local jailedDate = date.." "..clock

    MySQL.insert('INSERT INTO jail_history (identifier, jail_time, jailed_by, jailed_name, date) VALUES (?, ?, ?, ?, ?)', {xPlayer.identifier, jail_time, jailed_by, jailedName, jailedDate}, function(result)
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

    local jailedDate = date.." "..clock

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
AddEventHandler('mx_jail:jailPlayer', function(target, jail_time, pSource)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jailed_by = xPlayer.getName()

    TriggerEvent('mx_jail:setHistory', pSource, jail_time, jailed_by)
    TriggerClientEvent('mx_jail:jailPlayer', target)
end)

-- Unjail the Player
RegisterNetEvent('mx_jail:unJail')
AddEventHandler('mx_jail:unJail', function(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer ~= nil then
        TriggerClientEvent('mx_jail:unJailPlayer', xPlayer.source)
        TriggerEvent('mx_jail:clearTime', xPlayer.source, 0)

        TriggerEvent('mx_jail:updateHistory', source, xPlayer.source)
    else
        TriggerEvent('mx_jail:clearTimeOffline', identifier, 0) -- Unjail Player when Offline

        TriggerEvent('mx_jail:updateHistory', source, identifier)
    end
end)