local mapsTeleports = {
    city_ls         = Vector3 { x = 1467.486,   y = -1749.974,  z = 13.147 },
    city_sf         = Vector3 { x = -1991.581,  y = 137.797,    z = 27.234 } ,
    city_lv         = Vector3 { x = 2152.503,   y = 1004.375,   z = 10.515 },

    akina           = Vector3 { x = -8176.514,  y = -1298.812,  z = 1114.472 },
    hakone          = Vector3 { x = 2780.287,   y = 5106.657,   z = 140.441 },
    yz_circuit      = Vector3 { x = -7910.922,  y = -1394.332,  z = 133.452 },
    suzuka_circuit  = Vector3 { x = 210.442,    y = -4674.782,  z = 36.187 },
    sekia           = Vector3 { x = -5928.275,  y = -2430.218,  z = 123.308 },
    project_touge   = Vector3 { x = 6960.235,   y = 1167.320,   z = 108.204 },
    mikawa          = Vector3 { x = -200.763,   y = -441.015,   z = 2.864 },
    mazda_raceway   = Vector3 { x = 5619.636,   y = 1658.270,   z = 53.581 },
    hero_shinoi     = Vector3 { x = 3386.786,   y = 328.936,    z = 13.206 },
    honjo_circuit   = Vector3 { x = -6309.784,  y = -2556.591,  z = 94.505 },
    gateway_raceway = Vector3 { x = 5190.797,   y = -3571.846,  z = 90.224 },
    gokart2         = Vector3 { x = -1877.571,  y = -2758.882,  z = 1120.514 },
    ebisu_west      = Vector3 { x = -2718.073,  y = -2805.739,  z = 1434.322 },
    ebisu_minami    = Vector3 { x = -6492.131,  y = -3290.781,  z = 311.303 },
    bihoku          = Vector3 { x = -4694.072,  y = -3193.400,  z = 116.466 },
    unost           = Vector3 { x = 766.356, y = -4345.913, z = 87.702 },
    winter_rally_race_track = Vector3 { x = 6122.218, y = -1990.260, z = 29.039 }
}

local cityTeleportNames = {
    city_ls = true,
    city_lv = true,
    city_sf = true
}

local cityTeleports = {
    Vector3 { x = -8169.207,    y = -1268.439,  z = 1114.1 },
    Vector3 { x = 2798.335,     y = 5122.248,   z = 140.1 },
    Vector3 { x = -7955.230,    y = -1482.596,  z = 134.011 },
    Vector3 { x = 233.051,      y = -4665.340,  z = 36.3 },
    Vector3 { x = -5947.324,    y = -2445.331,  z = 123.315 },
    Vector3 { x = 6975.113,     y = 1169.032,   z = 108.1 },
    Vector3 { x = -199.635,     y = -463.457,   z = 2.870 },
    Vector3 { x = 5596.313,     y = 1622.232,   z = 53.1 },
    Vector3 { x = 3367.047,     y = 321.202,    z = 12.3 },
    Vector3 { x = -6310.731,    y = -2538.917,  z = 94.2 },
    Vector3 { x = 5160.945,     y = -3572.130,  z = 89.4 },
    Vector3 { x = -1847.451,    y = -2759.856,  z = 1120.3 },
    Vector3 { x = -2740.114,    y = -2806.345,  z = 1436 },
    Vector3 { x = -6470.735,    y = -3292.223,  z = 311 },
    Vector3 { x = -4694.880,    y = -3179.275,  z = 116.1 },
    Vector3 { x = 6137.958,     y = -1999.080,  z = 29.7 },
    Vector3 { x = 803.378,      y = -4351.334,  z = 87.2 },
}

local cityPosition = Vector3(1467.486, -1749.974, 13.147)

addEvent("dpTeleports.resetDimension", true)
addEventHandler("dpTeleports.resetDimension", resourceRoot, function ()
    client.dimension = 0
    client.interior = 0
    if client.vehicle then
        client.vehicle.dimension = 0
        client.vehicle.interior = 0
    end
end)

addEvent("dpTeleports.teleport", true)
addEventHandler("dpTeleports.teleport", resourceRoot, function (mapName)
    local position = mapsTeleports[mapName]
    if not position then
        position = cityPosition
    end
    if cityTeleportNames[mapName] then
        mapName = nil
    end

    client:setData("activeMap", mapName)
    
    if client.vehicle then
        if client.vehicle.controller == client then
            client.vehicle.position = position
            -- Телепортировать всех игроков, сидящих в машине
            for seat, player in pairs(client.vehicle.occupants) do
                player:setData("activeMap", mapName)
            end
        else
            client.vehicle = nil
            client.position = position
        end
    else
        client.position = position
    end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, position in ipairs(cityTeleports) do
        local cityMarker = exports.dpMarkers:createMarker("city", position, 180)
        cityMarker:setData("dpTeleports.type", "city")
    end
end)

    -- if isTeleporting then
    --     return
    -- end
    -- if localPlayer.vehicle and localPlayer.vehicle.controller ~= localPlayer then
    --     return
    -- end
    -- isTeleporting = true
    -- fadeCamera(false)
    -- triggerServerEvent("dpTeleports.teleport", resourceRoot)
    -- setTimer(function()
    --     if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
    --         localPlayer.vehicle.position = position
    --         localPlayer.vehicle.rotation = Vector3(0, 0, localPlayer.vehicle.rotation.z)
    --     elseif not localPlayer.vehicle then
    --         localPlayer.position = position
    --     end
    --     exports["TD-RACEMAPS"]:unloadMap()
    --     exports["TD-RACEMAPS"]:loadMap(loadMap)
    --     fadeCamera(true)
    --     triggerServerEvent("dpTeleports.resetDimension", resourceRoot)
    --     isTeleporting = false
    -- end, 1000, 1)