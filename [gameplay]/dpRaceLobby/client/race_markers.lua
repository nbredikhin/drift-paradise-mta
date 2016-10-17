function createRaceMarker(position, gamemode)
    local marker = exports.dpMarkers:createMarker("race", position - Vector3(0, 0, 0.9), 180)
    local blip = createBlip(0, 0, 0, 33)
    blip:attach(marker)
    blip:setData("color", "primary")
    blip:setData("text", "race_type_drift")
    return marker
end

local testMarker = createRaceMarker(Vector3 { x = 1258.229, y = -1400.719, z = 13.008 }, "sprint")

addEvent("dpMarkers.use", false)
addEventHandler("dpMarkers.use", root, function()
    if source == testMarker then
        LobbyScreen.toggle()
    end
end)