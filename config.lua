Config = {}

Config.Debug = false

Config.Locale = 'en' -- the language you want the script in

Config.notification = 1 -- the notification type / 1 - ESX Notification, 2 - Export Notification - Standard okokNotify

Config.useHistory = true -- if you wanna use this insert the new jail_history.sql // enables jail history
Config.F6JailPlayer = true -- if true you can jail players with the F6 Police menu

Config.USClock = false -- this changes the clock style between 12h day and 24h day 

-- SOON
-- Config.InventoryWipe = true -- whe true the players inventory will be cleared
-- Config.WeaponWipe = true -- when true the players weapon will be cleared

Config.teleportJail = true -- when true the player gets teleported in jail
Config.teleportBack = true -- teleports the player back when he tries to escape
Config.JailCoords = vec4(1765.7, 2565.8, 45.5, 175.0) -- Coords x, y, z and heading for the Jail Coords
Config.unjailCoords = vec4(1846.0, 2586.0, 45.6, 270.0) -- Coords x, y, z and heading for the Release Coords

Config.minJailTime = 10 -- the mininum Jailtime which has to be applied
Config.maxJailTime = 120 -- the maxinum Jailtime which can be applied

Config.AllowCommands = true -- not recommended when you want to jail people only at the jail
Config.AllowedJobs = {
    'police', 'sheriff', -- the Jobs which can jail people
}

Config.UsePrisonerClothing = true -- When true the clothing changes when jailing somebody
Config.PrisonerClothing = {
    ['male'] = {
        ['tshirt_1'] = 15,      ['tshirt_2'] = 0,
        ['torso_1'] = 56,       ['torso_2'] = 0,
        ['decals_1'] = 0,       ['decals_2'] = 0,
        ['arms'] = 0,           ['arms_2'] = 0,
        ['pants_1'] = 105,      ['pants_2'] = 3,
        ['shoes_1'] = 25,       ['shoes_2'] = 0,
        ['helmet_1'] = -1,      ['helmet_2'] = 0,
        ['mask_1'] = 0,         ['mask_2'] = 0,
        ['chain_1'] = 0,        ['chain_2'] = 0,
        ['ears_1'] = 0,         ['ears_2'] = 0,
        ['bags_1'] = 0,         ['bags_2'] = 0,
        ['hair_1'] = 0,         ['hair_2'] = 0,
        ['bproof_1'] = 0,       ['bproof_2'] = 0
    },
    ['female'] = {
        ['tshirt_1'] = 15,      ['tshirt_2'] = 0,
        ['torso_1'] = 118,      ['torso_2'] = 2,
        ['decals_1'] = 0,       ['decals_2'] = 0,
        ['arms'] = 4,           ['arms_2'] = 0,
        ['pants_1'] = 135,      ['pants_2'] = 1,
        ['shoes_1'] = 25,       ['shoes_2'] = 0,
        ['helmet_1'] = -1,      ['helmet_2'] = 0,
        ['mask_1'] = 0,       ['mask_2'] = 0,
        ['chain_1'] = 0,        ['chain_2'] = 0,
        ['ears_1'] = 0,         ['ears_2'] = 0,
        ['bags_1'] = 0,         ['bags_2'] = 0,
        ['hair_1'] = 0,         ['hair_2'] = 0,
        ['bproof_1'] = 0,       ['bproof_2'] = 0
    } 
}

Config.PedLocations = {
    {
        pedAction = 'checkJailTime', -- available : 'checkJailTime', 'jailPlayer'
        pedModel = 1456041926,
        pedlocation = vec3(1775.2, 2552.0, 45.5),
        pedHeading = 90.0,
    },
    {
        pedAction = 'jailPlayer', -- available : 'checkJailTime', 'jailPlayer'
        pedModel = 1456041926,
        pedlocation = vec3(1691.5, 2613.6, 45.6),
        pedHeading = 180.0,
    },
}