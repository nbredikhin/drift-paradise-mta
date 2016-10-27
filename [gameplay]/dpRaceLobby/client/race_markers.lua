local raceMarkers = {
    { position = Vector3(1258.229, -1400.719, 13.008), gamemode = "drift" },
    { position = Vector3(1988.054, -1463.851, 13.391), gamemode = "sprint" }
}

function createRaceMarker(position, gamemode)
    if not position then
        return false
    end
    if type(gamemode) ~= "string" then
        return false
    end
    local marker = exports.dpMarkers:createMarker("race", position - Vector3(0, 0, 0.9), 180)
    local blip = createBlip(0, 0, 0, 33)
    blip:attach(marker)
    blip:setData("color", "primary")
    blip:setData("text", "race_type_" .. gamemode)

    marker:setData("RaceMarker.gamemode", gamemode)
    return marker
end

addEvent("dpMarkers.use", false)
addEventHandler("dpMarkers.use", root, function()
    local gamemode = source:getData("RaceMarker.gamemode")
    if type(gamemode) ~= "string" then
        return 
    end
    LobbyScreen.toggle(gamemode)
end)

addEventHandler("onClientMarkerLeave", root, function ()
    if source:getData("RaceMarker.gamemode") then
        LobbyScreen.setVisible(false)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, m in ipairs(raceMarkers) do
        createRaceMarker(m.position, m.gamemode)
    end
end)