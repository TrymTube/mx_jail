RegisterNetEvent('mx_jail:playerNotify')
AddEventHandler('mx_jail:playerNotify', function(msg, time, variant)
    if Config.notification == 1 then
        ESX.ShowNotification(msg, false, true, nil)
    elseif Config.notification == 2 then
        exports['okokNotify']:Alert('INFO', msg, time, variant)
    end
end)