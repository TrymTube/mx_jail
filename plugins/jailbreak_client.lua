local currentInteraction = false

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
                    -- if v.pedAction == 'jailPlayer' then
                        ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to talk to the prisoner', false, true, 3000)
                    -- end
                end
                
                if IsControlJustReleased(0, 38) then
                    if Cfg.Debug then 
                        print('Success')
                        print('')
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

function giveStuffToNPC()
    TriggerEvent('esx:showNotification', '~g~You: ~w~Hey I\'m back!')

    Wait(2000)
    
    TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~Have you found what I wanted?')

    Wait(500)

    local elements = {
        {
            unselectable = true,
            icon = "fas fa-comment-dots",
            title = "Talk to the Prisoner",
        },
        {
            icon = "fas fa-exclamation",
            title = "Yes...",
            -- description="I wan\'t to break out of this prison!"
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "No...",
            -- description="I actually don\'t wan\'t anything!"
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element) -- On Select Function
        --- for a simple element
        if element.title == "Yes..." then
            currentInteraction = false
            
            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I have found the Object you wanted')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~Ok. Now go to...')
        elseif element.title == "No..." then
            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I have not found the Object you wanted')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~Either you search again or stay')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~do you wan\'t to continue or not?')

            Wait(500)

            chooseOption()
        end
    end, function(menu) -- on close

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
            -- description="I wan\'t to break out of this prison!"
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "No...",
            -- description="I actually don\'t wan\'t anything!"
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element) -- On Select Function
        --- for a simple element
        if element.title == "Yes..." then
            currentInteraction = true

            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I wan\'t to continue the mission')

            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~Ok. Now keep looking...')
        elseif element.title == "No..." then
            currentInteraction = false

            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I\'m gonna give up')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~your choice. Have fun staying here then!')
        end
    end, function(menu) -- on close

    end)  
end

function talkToNPC()
    TriggerEvent('esx:showNotification', '~g~You: ~w~Hey')

    Wait(2000)
    
    TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~What do you wan\'t?')

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
            -- description="I wan\'t to break out of this prison!"
        },
        {
            disabled = false,
            icon = "fas fa-times",
            title = "Nothing...",
            -- description="I actually don\'t wan\'t anything!"
        },
    }
      
    ESX.OpenContext("right", elements, function(menu, element) -- On Select Function
        -- print("Element Selected - ",element.title)
      
        --- for a simple element
        if element.title == "Break Out..." then
            ESX.CloseContext()

            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I wan\'t to break out of this prison!')

            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~I can help you.')
            currentInteraction = true
        elseif element.title == "Nothing..." then
            ESX.CloseContext()
            Wait(1000)
            TriggerEvent('esx:showNotification', '~g~You: ~w~I actually don\'t wan\'t anything!')
            
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~are you messing with me?')
            Wait(2000)
            TriggerEvent('esx:showNotification', '~r~Prisoner: ~w~Get off here or I\'ll beat you up!')
        end
    end, function(menu) -- on close

    end)
end