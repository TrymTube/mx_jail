Config = {}

Config.Debug = false

Config.Locale = 'en' -- the language you want the script in

Config.notification = 1 -- the notification type / 1 - ESX Notification, 2 - Export Notification - Standard okokNotify

Config.F6JailPlayer = true -- if true you can jail players with the F6 Police menu

Config.USClock = false -- this changes the clock style between 12h day and 24h day 

Config.teleportBack = true -- teleports the player back when he tries to escape
Config.JailCoords = vec4(1765.7, 2565.8, 45.5, 175.0) -- Coords x, y, z and heading for the Jail Coords
Config.unjailCoords = vec4(1846.0, 2586.0, 45.6, 270.0) -- Coords when a player gets out of Jail

Config.minJailTime = 10 -- the mininum Jailtime which has to be applied
Config.maxJailTime = 120 -- the maxinum Jailtime which can be applied

Config.AllowCommands = true -- not recommended when you want to jail people only at the jail
Config.AllowedJobs = {
    'police', 'sheriff', -- the Jobs which can jail people
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