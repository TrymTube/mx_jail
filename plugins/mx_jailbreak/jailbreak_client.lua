local status = false
local alreadyUsed = false
local currentInteraction = false
local showHelpNotify = false
local showHelpNotifySearch = false
local entity = nil
local inUse = false
local item = false
local alreadyChecked = false
local enteredMarker = false

CreateThread(function()
    for _, v in pairs(Cfg.PedLocations) do
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
        Wait(0)
        if ESX.IsPlayerLoaded() then
            local ped = PlayerPedId()
            local playerPos = GetEntityCoords(ped)

            -- marker variables
            local vec2_01 = vec4(0, 1, 0, 1)
            local markerColor = Cfg.markerColor
            local markerSize = Cfg.markerSize

            -- coordnates
            local coords = vec3(Cfg.EscapePoint.x, Cfg.EscapePoint.y, Cfg.EscapePoint.z)
            local dist = #(playerPos - coords)

            if dist < 10 then
                hasItem()

                enteredMarker = true

                if item then
                    DrawMarker(Cfg.markerType, coords, 0, 0, 0, 0, 0, 0, markerSize[1], markerSize[2], markerSize[3], markerColor[1], markerColor[2], markerColor[3], markerColor[4], vec2_01) -- DrawMarker()
                else
                    Wait(500)
                end
            else
                alreadyChecked = false
                Wait(500)
                enteredMarker = false
            end
        end
    end
end)

function hasItem()
    if enteredMarker then
        alreadyChecked = false
    end

    if not alreadyChecked then
        alreadyChecked = true
        
        ESX.TriggerServerCallback('mx_jailbreak:getItem', function(hasItem) 
            if hasItem.count >= 1 then
                item = true
            else
                item = false
            end
        end, Cfg.BrakeItem) 
    end
end

CreateThread(function()
    local timeJail = nil
    while true do
        Wait(10)
        local sleep = true

        local playerIndex = PlayerId()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerId = GetPlayerServerId(playerIndex)

        local dist = #(playerCoords - Cfg.EscapePoint)

        if dist <= 0.5 then
            sleep = false

            if item then
                if not showHelpNotify then
                    showHelpNotify = true
                    
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to escape the prison', false, true, 3000)
                end
                
                if IsControlJustReleased(0, 38) then
                    if Config.Debug then 
                        print('Success\n')
                    end

                    ESX.TriggerServerCallback('mx_jail:getDBValues', function(result, osTime) 
                        if result[1].jail_remaintime > 0 then
                            ESX.Streaming.RequestAnimDict('amb@medic@standing@kneel@idle_a', function()
                                TaskPlayAnim(playerPed, 'amb@medic@standing@kneel@idle_a', 'idle_a', 1.0, 1.0, 3000, 1, 1.0, false, false, false)
                                RemoveAnimDict('amb@medic@standing@kneel@idle_a')
                            end)
    
                            Wait(4000)
                            
                            TriggerServerEvent('mx_jailbreak:removeItem', Cfg.BrakeItem, Cfg.ItemAmount)

                            TriggerServerEvent('mx_jail:updateHistory', _U('title_jailbreak'), playerId)
                            TriggerServerEvent('mx_jail:clearTime', playerId, 0)

                            TriggerEvent('mx_jail:playerNotify', 'you broke out of the Jail Successfull', 3000, 'success')
    
                            SetEntityCoords(playerPed, Cfg.EscapeTeleport, false, false, false, false)
                            alreadyUsed = false
                        elseif result[1].jail_remaintime == 0 then
                            TriggerEvent('mx_jail:playerNotify', 'you are not in Jail', 3000, 'error')
                        end


                        -- print(ESX.DumpTable(result))
                    end)
                end
            end

        elseif dist > 0.5 then
            showHelpNotify = false
        end
        
        if sleep then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(10)
        local sleep = true

        for k, v in pairs(Cfg.PedLocations) do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            local dist = #(playerCoords - v.pedlocation)

            if dist <= 2.0 then
                currentPed = k

                sleep = false

                if not showHelpNotify then
                    showHelpNotify = true
                    
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to talk to the prisoner', false, true, 3000)
                end
                
                if IsControlJustReleased(0, 38) then
                    if Config.Debug then 
                        print('Success')
                        print('')
                    end

                    entity = ESX.Game.GetClosestPed(v.pedlocation)
                    local forwardCoord = GetEntityForwardVector(entity)
                    local coords = v.pedlocation + forwardCoord * 0.8

                    TriggerEvent('mx_jailbreak:disableControls')

                    TaskGoToCoordAnyMeans(playerPed, coords, 1.0, 0, 0, 786603, 0xbf800000)

                    Wait(1000)

                    TaskTurnPedToFaceCoord(playerPed, v.pedlocation)
                    
                    Wait(1000)

                    if Config.Debug then
                        print("\nEntity: "..entity)
                        print("\nPed Forward Coord: X = "..string.format('%02.2f', coords.x)..", Y = "..string.format('%02.2f', coords.y)..", Z = "..string.format('%02.2f', coords.z))
                        print("\nPed Location Coords: X = "..string.format('%02.2f', v.pedlocation.x)..", Y = "..string.format('%02.2f', v.pedlocation.y)..", Z = "..string.format('%02.2f', v.pedlocation.z))
                    end 

                    if currentInteraction then
                        giveStuffToNPC()
                    else
                        talkToNPC()
                    end
                end
                
            elseif dist > 2.0 and currentPed == k then
                showHelpNotify = false
            end
        end
        
        if sleep then
            Wait(1000)
        end
    end
end)

AddEventHandler('mx_jailbreak:disableControls', function(parameter)
    local alreadySent = false
    status = not status

    if parameter == false then
        status = parameter
    end
    
    while status do
        Wait(1)
        
        if Config.Debug and not alreadySent then
            alreadySent = true
            print("\nControl Disables Success", "\nWhile Loop Status: "..tostring(status).."\n")
        elseif Config.Debug and not status then
            print("\nWhile Loop Status: "..tostring(status).."\n")
        end
        
        DisableControlAction(0, 1) -- Disables Left/Right Mouse Input
        DisableControlAction(0, 2) -- Disables Up/Down Mouse Input

        DisableControlAction(0, 24) -- Disables Attack Input
        DisableControlAction(0, 257) -- Disables Attack Input
        DisableControlAction(0, 25) -- Disables Aim Input

        DisableControlAction(0, 37) -- Disables Tab Input / Weaponwheel

        DisableControlAction(0, 30) -- Disables W/S Input
        DisableControlAction(0, 31) -- Disables A/D Input

        if parameter then
            break
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(1)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = true

        local dist = #(playerCoords - Cfg.SearchPoint)

        if currentInteraction and not alreadyUsed then
            if dist <= 1.0 then
                sleep = false

                if not showHelpNotifySearch then
                    showHelpNotifySearch = true
                    
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to search for the Object', false, true, 3000)
                end
                
                if IsControlJustReleased(0, 38) and not inUse then
                    inUse = true
                    if Config.Debug then 
                        print('Success')
                        print('')
                    end

                    ESX.Progressbar("Searching Storage...", 5000,{
                        FreezePlayer = false, 
                        animation ={
                            type = "Scenario",
                            Scenario = "PROP_HUMAN_BUM_BIN", 
                        },
                        onFinish = function()
                        print('onFinish')
                        local percentage = math.random(0, 100)
                        local dotPercentage = math.random(0, 9)
                        local fullPercentage = percentage.."."..dotPercentage
                        local numberPercentage = tonumber(fullPercentage)

                        if numberPercentage < Cfg.Percentage then
                            inUse = false
                            alreadyUsed = true
                            TriggerServerEvent('mx_jailbreak:giveItem', Cfg.SearchItem, Cfg.ItemAmount)
                            TriggerEvent('mx_jail:playerNotify', 'you have found the object', 3000, 'success')
                        else
                            inUse = false
                            TriggerEvent('mx_jail:playerNotify', 'Search Again you haven\'t found anything', 3000, 'error')
                        end
                    end, onCancel = function()
                        print('onCancel')

                        Wait(1500)

                        inUse = false
                        alreadyUsed = false
                    end})
                end
                
            elseif dist > 2.0 then
                sleep = true
                showHelpNotifySearch = false
            end
        else
            sleep = true
        end

        if sleep then
            Wait(500)
        end
    end
end)

function setBlip()
    searchPoint = AddBlipForCoord(Cfg.SearchPoint)
            
    SetBlipSprite(searchPoint, Cfg.BlipSprite)
    SetBlipScale(searchPoint, Cfg.BlipScale)
    SetBlipColour(searchPoint, Cfg.BlipColor)
    SetBlipAsShortRange(searchPoint, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Search here')
    EndTextCommandSetBlipName(searchPoint)
end

function setEscapeBlip()
    escapePoint = AddBlipForCoord(Cfg.EscapePoint)
            
    SetBlipSprite(escapePoint, Cfg.BlipSprite)
    SetBlipScale(escapePoint, Cfg.BlipScale)
    SetBlipColour(escapePoint, Cfg.BlipColor)
    SetBlipAsShortRange(escapePoint, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Escape here')
    EndTextCommandSetBlipName(escapePoint)
end

function giveStuffToNPC()
    TriggerEvent('esx:showNotification', '~g~You: ~s~Hey I\'m back!')

    Wait(2000)
    
    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Have you found what I wanted?')

    Wait(500)

    local playerPed = PlayerPedId()
    local elements = {
        {
            unselectable = true,
            icon = "fas fa-comment-dots",
            title = "Talk to the Prisoner",
        },
        {
            icon = "fas fa-exclamation",
            title = "Yes...",
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "No...",
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element) 
        
        if element.title == "Yes..." then
            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I have found the Object you wanted')        
            Wait(2000)

            ESX.TriggerServerCallback('mx_jailbreak:getItem', function(hasItem)
                if hasItem.count >= 1 then
                    currentInteraction = false

                    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Good, give it to me')

                    ESX.Streaming.RequestAnimDict('mp_common', function()
                        TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 1.0, 1.0, 3000, 1, 1.0, false, false, false)
                        TaskPlayAnim(entity, 'mp_common', 'givetake1_a', 1.0, 1.0, 3000, 1, 1.0, false, false, false)
                        RemoveAnimDict('mp_common')
                    end)

                    Wait(1000)
                    
                    TriggerServerEvent('mx_jailbreak:removeItem', Cfg.SearchItem, Cfg.ItemAmount)

                    Wait(2000)

                    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Ok. Take this Item and you are ready to brake out')

                    ESX.Streaming.RequestAnimDict('mp_common', function()
                        TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 1.0, 1.0, 3000, 1, 1.0, false, false, false)
                        TaskPlayAnim(entity, 'mp_common', 'givetake1_a', 1.0, 1.0, 3000, 1, 1.0, false, false, false)
                        RemoveAnimDict('mp_common')
                    end)

                    Wait(1000)

                    TriggerServerEvent('mx_jailbreak:giveItem', Cfg.BrakeItem, Cfg.ItemAmount)

                    RemoveBlip(searchPoint)
                elseif hasItem.count <= 0 then
                    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~do you really think I am stupid?!')

                    Wait(2000)
                    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~you don\'t have that Item! SEARCH AGAIN!!')
                end
                
            end, Cfg.SearchItem)
            TriggerEvent('mx_jailbreak:disableControls', false)
        elseif element.title == "No..." then
            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I have not found the Object you wanted')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Either you search again or stay')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~do you wan\'t to continue or not?')

            Wait(500)

            chooseOption()
        end
    end, function(menu) 
        TriggerEvent('mx_jailbreak:disableControls', false)
    end)
end

function chooseOption()
    local elements = {
        {
            unselectable = true,
            icon = "fas fa-comment-dots",
            title = "Choose your option",
        },
        {
            icon = "fas fa-exclamation",
            title = "Yes...",
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "No...",
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element)
        if element.title == "Yes..." then
            currentInteraction = true

            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I wan\'t to continue the mission')

            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Ok. Now keep looking...')

            TriggerEvent('mx_jailbreak:disableControls', false)
        elseif element.title == "No..." then
            currentInteraction = false

            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I\'m gonna give up')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~your choice. Have fun staying here then!')
            RemoveBlip(searchPoint)


            TriggerEvent('mx_jailbreak:disableControls', false)
        end
    end, function(menu)
        TriggerEvent('mx_jailbreak:disableControls', false)
    end)  
end

function talkToNPC()
    TriggerEvent('esx:showNotification', '~g~You: ~s~Hey')

    Wait(2000)
    
    TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~What do you wan\'t?')

    Wait(500)
    
    local elements = {
        {
            unselectable = true,
            icon = "fas fa-comment-dots",
            title = "Talk to the Prisoner",
        },
        {
            icon = "fas fa-exclamation",
            title = "Break Out...",
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "Nothing...",
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element)
      
        if element.title == "Break Out..." then
            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I wan\'t to break out of this prison!')

            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Go to the wooden boxes near the watchtower and look for a phone!')

            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Come back when you found it')
            setBlip()

            TriggerEvent('mx_jailbreak:disableControls', false)

            currentInteraction = true
        elseif element.title == "Nothing..." then
            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~s~I actually don\'t wan\'t anything!')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~are you messing with me?')

            TriggerEvent('mx_jailbreak:disableControls', false)

            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~s~Get off here or I\'ll beat you up!')
        end
    end, function(menu) 
        TriggerEvent('mx_jailbreak:disableControls', false)
    end)
end