local hasJob = false

function isAllowed(job)
    local allowedjobs = Config.AllowedJobs
    for i=1, #Config.AllowedJobs do 
        if allowedjobs[i] == job then 
            return true
        end
    end
    return false
end

if Config.AllowCommands then
    ESX.RegisterCommand('jail', 'user', function(xPlayer, args, showError)
        if isAllowed(xPlayer.getJob().name) then
            if tonumber(args.PlayerID) ~= nil and tonumber(args.JailTime) ~= nil then
                if GetPlayerName(args.PlayerID) ~= nil then
                    if (tonumber(args.JailTime) >= Config.minJailTime) then
                        if (tonumber(args.JailTime) <= Config.maxJailTime) then

                            TriggerClientEvent('mx_jail:jailPlayer', args.PlayerID)

                            TriggerEvent('mx_jail:setTime', args.PlayerID, args.JailTime)
                        else
                            xPlayer.triggerEvent('chatMessage', _U('chatnotify_max_jailtime', Config.maxJailTime))
                        end
                    else
                        xPlayer.triggerEvent('chatMessage', _U('chatnotify_min_jailtime', Config.minJailTime))
                    end
                else
                    xPlayer.triggerEvent('chatMessage', _U('chatnotify_ply_doesnt_exist', args.PlayerID))
                end
            else
                xPlayer.triggerEvent('chatMessage', _U('chatnotify_id_jailtime'))
            end
        else
            xPlayer.triggerEvent('chatMessage', _U('chatnotify_no_perms'))
        end
    end, false, {help = 'jails a player', arguments = {
        {name = 'PlayerID', help = 'enter the players ID you want to jail', type = 'number'}, 
        {name = 'JailTime', help = 'enter the Jail time in minutes', type = 'number'}
    }})


    ESX.RegisterCommand('unjail', 'user', function(sourcexPlayer, args, showError)
        if isAllowed(sourcexPlayer.getJob().name) then
            if args.PlayerID ~= nil then
                if GetPlayerName(args.PlayerID) ~= nil then
                    local targetxPlayer = ESX.GetPlayerFromId(args.PlayerID)

                    MySQL.Async.fetchAll('SELECT jail_time, jail_remaintime FROM users WHERE identifier = ?', {targetxPlayer.identifier}, function(result)

                        if #result > 0 then
                            debug(ESX.DumpTable(result[1].jail_remaintime))
                            if result[1].jail_remaintime > 0 then
                                TriggerClientEvent('mx_jail:unJailPlayer', args.PlayerID)

                                TriggerEvent('mx_jail:clearTime', args.PlayerID, 0)
                            else
                                sourcexPlayer.triggerEvent('chatMessage', _U('chatnotify_not_jail', args.PlayerID))
                            end
                        else
                            debug('[^1ERROR^0] server/server.lua:101')
                        end
                    end)
                else
                    sourcexPlayer.triggerEvent('chatMessage', _U('chatnotify_ply_doesnt_exist', args.PlayerID))
                end
            else
                sourcexPlayer.triggerEvent('chatMessage', _U('chatnotify_id'))
            end
        else
            xPlayer.triggerEvent('chatMessage', _U('chatnotify_no_perms'))
        end
    end, false, {help = 'unjails a player', arguments = {
        {name = 'PlayerID', help = 'enter the players ID you want to unjail', type = 'number'}
    }})
end