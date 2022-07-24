ESX = exports['es_extended']:getSharedObject()

local currentPed
local lastPed

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)

    Wait(10000)

    ESX.TriggerServerCallback('mx_jail:getDBValues', function(result, time, remainTime)
        local dbRemainTime = result[1].jail_remaintime
        local timeRemaining = (time - result[1].jail_time) / 60 
        local playerIndex = PlayerId()
        local playerId = GetPlayerServerId(playerIndex)

        if (timeRemaining >= dbRemainTime) and (dbRemainTime == 0) then
            if Config.Debug then
                print('Jailtime has been set to 0')
            end

            TriggerServerEvent('mx_jail:setTime', playerId, 0)
        elseif timeRemaining < result[1].jail_remaintime then
            teleportJail(PlayerPedId())

            if Config.Debug then
                print('Remaining Time: '..timeRemaining)
            end
        end
    end)
end)

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() ~= name then
        return
    end
    
    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'jail_main_menu')
    ESX.UI.Menu.Close('list', GetCurrentResourceName(), 'jailed_players_list')
    ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'jail_dialog_name')
    ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'jail_dialog_time')
    ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'update_jailtime')
end)

CreateThread(function()
    for _, v in pairs(Config.PedLocations) do
        local coords = vec3(v.pedlocation.x, v.pedlocation.y, v.pedlocation.z - 1)
        
        RequestModel(v.pedModel)
        
        while not HasModelLoaded(v.pedModel) do
          Wait(1)
        end

        ped = CreatePed(4, v.pedModel, coords, v.pedHeading, false, true)
        SetEntityHeading(ped, v.pedHeading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
  
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

CreateThread(function()
    while true do
        Wait(10)
        local sleep = true

        for k, v in pairs(Config.PedLocations) do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            local dist = #(playerCoords - v.pedlocation)

            if dist <= 2.0 then
                currentPed = k

                sleep = false

                if not TextShown then
                    TextShown = true
                    if v.pedAction == 'checkJailTime' then
                        ESX.ShowHelpNotification(_U('help_notify_checkJailTime'), false, true, 3000)
                    elseif v.pedAction == 'jailPlayer' then
                        ESX.ShowHelpNotification(_U('help_notify_jailPlayer'), false, true, 3000)
                    end
                end
                
                if IsControlJustReleased(0, 38) then
                    if Config.Debug then 
                        print('Success')
                        print('')
                    end

                    if v.pedAction == 'checkJailTime' then
                        ESX.TriggerServerCallback('mx_jail:getDBValues', function(result, time) 
                            local timeLeft = (time - result[1].jail_time) / 60
                            local timeRemaining = (result[1].jail_remaintime - timeLeft)
                            local minutes = string.format('%02.0f', timeRemaining)
                    
                            TriggerEvent('mx_jail:playerNotify', _U('notify_checkJailTime', minutes), 5000, 'info')
                        end)
                    elseif v.pedAction == 'jailPlayer' then
                        local hasJob = false
                        ESX.TriggerServerCallback('mx_jail:getJob', function(Job)
                            for _, v in pairs(Config.AllowedJobs) do
                                if Job.name == v then
                                    hasJob = true
                                end
                            end

                            if hasJob then
                                openMenu()
                            else
                                TriggerEvent('mx_jail:playerNotify', _('notify_no_job'), 5000, 'info')
                            end
                        end)
                    else
                        if Config.Debug then
                            print('^0[^3ERROR^0] Invalid pedAction')
                            print('^0[^3ERROR^0] valid actions : \'checkJailTime\', \'jailPlayer\'')
                            TriggerEvent('mx_jail:playerNotify', '[ERROR] invalid pedAction \ncheck print for more information', 5000, 'info')
                        else
                            TriggerEvent('mx_jail:playerNotify', '[ERROR] invalid pedAction \nenable print for more information', 5000, 'info')
                        end
                    end
                end

                lastPed = currentPed
                
            elseif dist > 2.0 and currentPed == k then 
                ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'jail_main_menu')
                ESX.UI.Menu.Close('list', GetCurrentResourceName(), 'jailed_players_list')
                ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'jail_dialog_name')
                ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'jail_dialog_time')
                ESX.UI.Menu.Close('dialog', GetCurrentResourceName(), 'update_jailtime')
                TextShown = false
            end
        end
        
        if sleep then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    local sleep = true

    while true do
        Wait(1000)

        ESX.TriggerServerCallback('mx_jail:getDBValues', function(result, time, remainTime) 
            local timeLeft = (time - result[1].jail_time) / 60
            local timeRemaining = (result[1].jail_remaintime - timeLeft)

            if result[1].jail_remaintime ~= 0.0 then
                local player = PlayerPedId()
                local playerIndex = PlayerId()
                local playerId = GetPlayerServerId(playerIndex)
                
                sleep = false

                if timeLeft > result[1].jail_remaintime then
                    unJail(player)
                    TriggerServerEvent('mx_jail:clearTime', playerId, 0)
                elseif timeLeft < result[1].jail_remaintime then
                    local playerCoords = GetEntityCoords(player)
                    local JailCoords = vec3(Config.JailCoords.x, Config.JailCoords.y, Config.JailCoords.z)

                    local dist = #(JailCoords - playerCoords)

                    if dist > 500 then
                        if Config.teleportBack then
                            teleportJail(player)
                        end
                    end

                    if Config.Debug then
                        print('Remaining Time: '..timeRemaining)
                    end
                end
            elseif result[1].jail_remaintime == 0.0 then 
                
                if Config.Debug then
                    print('not in jail')
                end

                sleep = true
            end
        end)

        if sleep then
            Wait(5000)
        end
    end
end)

AddEventHandler('mx_jail:openF6Menu', function()
    openF6Menu()
end)

function openF6Menu()
    local element = {}

    if Config.F6JailPlayer then
        table.insert(element, {label = _U('title_jail_person'), value = 'jail_person'})
    end

    table.insert(element, {label = _U('title_jailed_players'), value = 'jailed_players'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_f6main_menu', {
        title    = _U('title_jail_menu'),
		align    = 'left',
		elements = element
    }, function(data, menu)
        if data.current.value == "jail_person" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_f6dialog_name',
            {
                title = _U('title_jail_dialog_playername')
            },
            function(data2, menu2)
                
                ESX.TriggerServerCallback('mx_jail:getNames', function(doesNameExist, player, source)
                    if doesNameExist then
                        ESX.TriggerServerCallback('mx_jail:getDBValuesPlayer', function(result, osTime)
                            if result[1].jail_remaintime > 0 then
                                TriggerEvent('mx_jail:playerNotify', _U('notify_player_alrd_jail'), 5000, 'error')
                            else
                                if source ~= player then
                                    menu2.close()
                                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_f6dialog_time',
                                    {
                                        title = _U('title_jail_dialog_jailtime')
                                    },
                                    function(data3, menu3)
                                        if tonumber(data3.value) >= Config.minJailTime then
                                            if tonumber(data3.value) <= Config.maxJailTime then
                                                TriggerServerEvent('mx_jail:jailPlayer', player)
                                                TriggerServerEvent('mx_jail:setTime', player, data3.value)

                                                TriggerEvent('mx_jail:playerNotify', _U('notify_jailed_player', data2.value), 5000, 'success')

                                                menu3.close()
                                            else
                                                TriggerEvent('mx_jail:playerNotify', _U('notify_max_jailtime', Config.maxJailTime), 5000, 'error')
                                            end
                                        else
                                            TriggerEvent('mx_jail:playerNotify', _U('notify_min_jailtime', Config.minJailTime), 5000, 'error')
                                        end
                                    end, function(data3, menu3)
                                        menu3.close()
                                    end)
                                else
                                    TriggerEvent('mx_jail:playerNotify', _U('notify_cant_jail_yourself'), 5000, 'error')
                                end
                            end
                        end, player)
                    else
                        TriggerEvent('mx_jail:playerNotify', _U('notify_invalid_name'), 5000, 'error')
                    end
                end, data2.value)
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'jailed_players' then
            openListMenu()
        end
    end, function(data, menu)
		menu.close()
	end)
end

function openMenu()
    ESX.UI.Menu.CloseAll()

    local element = {
        {label = _U('title_jail_person'), value = 'jail_person'},
        {label = _U('title_jailed_players'), value = 'jailed_players'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_main_menu', {
        title    = _U('title_jail_menu'),
		align    = 'left',
		elements = element
    }, function(data, menu)
        if data.current.value == "jail_person" then
            menu.close()
            
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_dialog_name',
            {
                title = _U('title_jail_dialog_playername')
            },
            function(data2, menu2)
                
                ESX.TriggerServerCallback('mx_jail:getNames', function(doesNameExist, player, source)
                    if doesNameExist then
                        ESX.TriggerServerCallback('mx_jail:getDBValuesPlayer', function(result, osTime)
                            if result[1].jail_remaintime > 0 then
                                TriggerEvent('mx_jail:playerNotify', _U('notify_player_alrd_jail'), 5000, 'error')
                            else
                                if source ~= player then
                                    menu2.close()
                                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_dialog_time',
                                    {
                                        title = _U('title_jail_dialog_jailtime')
                                    },
                                    function(data3, menu3)
                                        if tonumber(data3.value) >= Config.minJailTime then
                                            if tonumber(data3.value) <= Config.maxJailTime then
                                                TriggerServerEvent('mx_jail:jailPlayer', player)
                                                TriggerServerEvent('mx_jail:setTime', player, data3.value)

                                                TriggerEvent('mx_jail:playerNotify', _U('notify_jailed_player', data2.value), 5000, 'success')

                                                menu3.close()
                                            else
                                                TriggerEvent('mx_jail:playerNotify', _U('notify_max_jailtime', Config.maxJailTime), 5000, 'error')
                                            end
                                        else
                                            TriggerEvent('mx_jail:playerNotify', _U('notify_min_jailtime', Config.minJailTime), 5000, 'error')
                                        end
                                    end, function(data3, menu3)
                                        menu3.close()
                                    end)
                                else
                                    TriggerEvent('mx_jail:playerNotify', _U('notify_cant_jail_yourself'), 5000, 'error')
                                end
                            end
                        end, player)
                    else
                        TriggerEvent('mx_jail:playerNotify', _U('notify_invalid_name'), 5000, 'error')
                    end
                end, data2.value)
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'jailed_players' then
            openListMenu()
            menu.close()
        end
    end, function(data, menu)
		menu.close()
	end)
end

function openListMenu()
    ESX.TriggerServerCallback('mx_jail:getJailedPlayer', function(players, time, jailed_date)
        local elements = {
            head = {_U('title_jail_list_ply'), _U('title_jail_list_time'), _U('title_jail_list_timeleft'), _U('title_jail_list_date'), _U('title_jail_list_actions')},
            rows = {}
        }
        
        for k, v in pairs(players) do
            if v.jail_time ~= nil and v.jail_time ~= 0 then
                local jailedName = v.firstname.." "..v.lastname
                local jailedTime = v.jailed_date

                local timeLeft = (time - v.jail_time) / 60
                local timeRemaining = (v.jail_remaintime - timeLeft)
                local minutes = string.format('%02.0f', timeRemaining)
                if tonumber(minutes) > 0 then
                    table.insert(elements.rows, {
                        data = v,
                        cols = {
                            jailedName,
                            v.jail_remaintime, 
                            minutes,
                            jailedTime,
                            '{{'.._U('action_jail_list_update')..'|update}} {{' .. _U('action_jail_list_unjail') .. '|unjail}}'
                        }
                    })
                end
            end
        end
        
        ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'jailed_players_list', elements, function(data, menu)
            if data.value == 'unjail' then
                TriggerServerEvent('mx_jail:unJail', data.data.identifier)
                menu.close()

                Wait(100)
                
                openListMenu()
                
                TriggerEvent('mx_jail:playerNotify', _U('notify_unjailed_player', jailedName), 5000, 'success')
            elseif data.value == 'update' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'update_jailtime',
                {
                    title = _U('title_jail_dialog_update_jailtime', data.data.firstname.." "..data.data.lastname)
                },
                function(data2, menu2)
                    if tonumber(data2.value) >= Config.minJailTime then
                        if tonumber(data2.value) <= Config.maxJailTime then
                            local playerPed = GetPlayerPed(player)
                            local playerId = GetPlayerServerId(playerPed)

                            TriggerServerEvent('mx_jail:updateTime', data.data.identifier, data2.value)

                            menu.close()
                            menu2.close()

                            Wait(100)
                            
                            openListMenu()

                            TriggerEvent('mx_jail:playerNotify', _U('notify_updated_jailtime', data.data.firstname.." "..data.data.lastname, data.data.jail_remaintime, data2.value), 5000, 'success')
                        else
                            TriggerEvent('mx_jail:playerNotify', _U('notify_max_jailtime', Config.maxJailTime), 5000, 'error')
                        end
                    else
                        TriggerEvent('mx_jail:playerNotify', _U('notify_min_jailtime', Config.minJailTime), 5000, 'error')
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

RegisterNetEvent('mx_jail:unJailPlayer')
AddEventHandler('mx_jail:unJailPlayer', function(target)
    local targetPlayer = PlayerPedId(target)

    unJail(targetPlayer)
end)

function unJail(target)
    TriggerEvent('mx_jail:playerNotify', _U('notify_jail_released'), 3000, 'success')
    SetEntityCoords(target, Config.unjailCoords.x, Config.unjailCoords.y, Config.unjailCoords.z, false, false, false, false)
    SetEntityHeading(target, Config.unjailCoords.w)
end

RegisterNetEvent('mx_jail:jailPlayer')
AddEventHandler('mx_jail:jailPlayer', function(target)
    local targetPlayer = PlayerPedId(target)
    
    teleportJail(targetPlayer)
end)

function teleportJail(target)
    SetEntityCoords(target, Config.JailCoords.x, Config.JailCoords.y, Config.JailCoords.z, false, false, false, false)
    SetEntityHeading(target, Config.JailCoords.w)
end