local hasJob = false

if Config.AllowCommands then
    ESX.RegisterCommand('jail', 'user', function(xPlayer, args, showError)
        for _, v in pairs(Config.AllowedJobs) do
            if xPlayer.getJob().name == v then
                hasJob = true
            end
        end

        if hasJob then
            if tonumber(args.PlayerID) ~= nil and tonumber(args.JailTime) ~= nil then
                if GetPlayerName(args.PlayerID) ~= nil then
                    if (tonumber(args.JailTime) >= Config.minJailTime) then
                        if (tonumber(args.JailTime) <= Config.maxJailTime) then
                            local targetxPlayer = ESX.GetPlayerFromId(args.PlayerID)
                            local sourceName = xPlayer.getName()

                            TriggerClientEvent('mx_jail:jailPlayer', args.PlayerID)

                            TriggerEvent('mx_jail:setHistory', args.PlayerID, args.JailTime, sourceName)
                            TriggerEvent('mx_jail:setTime', args.PlayerID, args.JailTime)

                            TriggerClientEvent('mx_jail:playerNotify', xPlayer.source, _U('notify_jailed_player', args.PlayerID), 5000, 'success')
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
        for _, v in pairs(Config.AllowedJobs) do
            if sourcexPlayer.getJob().name == v then
                hasJob = true
            end
        end

        if hasJob then
            if args.PlayerID ~= nil then
                if GetPlayerName(args.PlayerID) ~= nil then
                    local targetxPlayer = ESX.GetPlayerFromId(args.PlayerID)

                    MySQL.Async.fetchAll('SELECT jail_time, jail_remaintime FROM users WHERE identifier = ?', {targetxPlayer.identifier}, function(result)

                        if #result > 0 then
                            if result[1].jail_remaintime > 0 then
                                TriggerClientEvent('mx_jail:unJailPlayer', args.PlayerID)

                                TriggerEvent('mx_jail:updateHistory', sourcexPlayer.source, args.PlayerID)
                                TriggerEvent('mx_jail:clearTime', args.PlayerID, 0)
                            else
                                sourcexPlayer.triggerEvent('chatMessage', _U('chatnotify_not_jail', args.PlayerID))
                            end
                        elseif Config.Debug then
                            print('[^1ERROR^0] server/commands.lua:57 no result')
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