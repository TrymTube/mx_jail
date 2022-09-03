RegisterNetEvent('mx_jailbreak:giveItem')
AddEventHandler('mx_jailbreak:giveItem', function(item, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(item, amount)
end)

RegisterNetEvent('mx_jailbreak:removeItem')
AddEventHandler('mx_jailbreak:removeItem', function(item, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(item, amount)
end)

ESX.RegisterServerCallback('mx_jailbreak:getItem', function(source, cb, item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem(item)

    cb(hasItem)
end)