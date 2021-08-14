Config = {}

Config.ESXObject = 'esx:getSharedObject'

Config.EnableImpound = true -- Set to true if you want to enable impound
Config.EnablePoliceGarage = true -- Set to true if you want to enable police garages
Config.EnableEMSGarage = true -- Set to true if you want to enable ems garages

--[[ BUTTONS ]]--
Config.AcessGarageKey = 38 -- Default [E] dont forget to change in lang.lua
Config.AccessImpoundKey = 74 -- Default [H] dont forget to change in lang.lua
Config.SaveGarageCarKey = 38 -- Default [E] dont forget to change in lang.lua

--[[ GERAL ]]--
Config.MenuAlign = "center" -- Change the location of the menu (center, top-left, top-right, bottom-right, bottom-left..)
Config.DrawDistance = 8.0 -- Distance to show marker etc
Config.UseVehicleShop = false -- Set to true if you use esx_vehicleshop

--[[ GARAGES ]]
Config.Garages = {
    ["A"] = { 
        menuPos = { 212.12, -808.6, 30.8 },
        savePos = { 216.64, -787.48, 30.8 },
        spawnPos = vector3(230.44, -798.36, 30.56),
        spawnHeading = 156.7,
    },

    ["B"] = { 
        menuPos = { 273.64, -344.2, 44.92 },
        savePos = { 272.12, -334.0, 44.92 },
        spawnPos = vector3(287.56, -343.72, 44.92),
        spawnHeading = 158.8,
    },

    ["C"] = { 
        menuPos = { -1809.44, -343.76, 43.6 },
        savePos = { -1819.2, -330.52, 43.44 },
        spawnPos = vector3(-1810.72, -337.4, 43.56),
        spawnHeading = 311.1,
    },

    ["D"] = { 
        menuPos = { -69.2, -1831.8, 26.96 },
        savePos = { -56.0, -1838.0, 26.56 },
        spawnPos = vector3(-56.0, -1838.0, 26.56),
        spawnHeading = 314.7,
    },
    
    ["E"] = { 
        menuPos = { 1737.56, 3709.96, 34.12 },
        savePos = { 1738.04, 3718.84, 34.04 },
        spawnPos = vector3(1738.04, 3718.84, 34.04),
        spawnHeading = 20.2
    },

    ["F"] = { 
        menuPos = { 125.0, 6644.72, 31.8 },
        savePos = { 115.64, 6650.6, 31.56 },
        spawnPos = vector3(115.64, 6650.6, 31.56),
        spawnHeading = 132.2
    },

    ["G"] = { 
        menuPos = { 931.72, -68.48, 78.8 },
        savePos = {  919.96, -61.8, 78.76 },
        spawnPos = vector3(923.36, -64.04, 78.76),
        spawnHeading = 138.6
    },

    ["H"] = { 
        menuPos = { 9231.72, -68.48, 78.8 },
        savePos = {  9129.96, -61.8, 78.76 },
        spawnPos = vector3(9223.36, -64.04, 78.76),
        spawnHeading = 138.2
    },
}
Config.GaragesBlip = {
    sprite = 357, 
    display = 4, 
    color = 3, 
    scale = 0.8
}

-- ONLY WORKS IF Config.EnableImpound = true
Config.ImpoundLocation = { 409.28, -1623.08, 29.28 }
Config.ImpoundSpawnPos = vector3(409.92, -1648.04, 29.28)
Config.ImpoundHeading = 230.3
Config.ImpoundPay = 750
Config.ImpoundBlip = {
    sprite = 67, 
    display = 4, 
    color = 1, 
    scale = 0.7
}

-- ONLY WORKS IF Config.EnablePoliceGarages = true
Config.PoliceGarage = { 458.64, -1008.12, 28.28 }
Config.SpawnPDCarPos = vector3(435.0, -1022.56, 28.72)
Config.PoliceCars = {
    { model = "police3" }, --[[ YOU CAN ADD HOW MUCH CARS DO YOU WANT ]]
    { model = "police" }
}

-- ONLY WORKS IF Config.EnableEMSGarages = true
Config.EMSGarage = { 299.44, -580.56, 43.28 }
Config.SpawnEMSCarPos = vector3(291.48, -574.2, 43.2)
Config.EMSCars = {
    { model = "ambulance" }, --[[ YOU CAN ADD HOW MUCH CARS DO YOU WANT ]]
}

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end
