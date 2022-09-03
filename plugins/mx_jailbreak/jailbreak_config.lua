Cfg = {}

Cfg.PedLocations = {
    {
        -- pedAction = 'checkJailTime', -- available : 'checkJailTime', 'jailPlayer'
        pedModel = 1596003233,
        pedlocation = vec3(1725.75, 2494.5, 45.56),
        pedHeading = 75.0,
    },
}

Cfg.SearchPoint = vec3(1689.6, 2552.0, 45.5)
Cfg.EscapePoint = vec3(1756.0, 2412.0, 45.4)
Cfg.EscapeTeleport = vec3(1756.25, 2409.5, 45.4)

Cfg.DrawMarkerDist = 10
Cfg.markerType = 20
Cfg.markerColor = {100, 0, 0, 255}
Cfg.markerSize = {0.3, 0.3, 0.3}

Cfg.Percentage = 40.0 -- the chance of finding (percentage)
Cfg.SearchItem = 'phone' -- The item which has to be found
Cfg.BrakeItem = 'crowbar' -- The item which you can brake out with
Cfg.ItemAmount = 1 -- the amount how many items should get added and get removed

Cfg.BlipSprite = 472
Cfg.BlipScale = 0.8
Cfg.BlipColor = 12
