Config = {}

Config.OpenMenuButton = 'F4'  -- Keybind to open uber menu
Config.OpenMenuCommand = 'ubermenu'  -- Command to open uber menu

Config.RitPrice = 5 -- default 5 per mil

-- use it as table like this `{'muscle', 'super'}` (you can add moreif you want)
-- or set to `-1` so that every vehicle class is allowed.
Config.AllowedVehiclesCategory = {
    ['offroad'] = true, 
    ['muscle'] = true, 
    ['sports'] = true, 
    ['super'] = true, 
    ['helicopters'] = true,
} 
