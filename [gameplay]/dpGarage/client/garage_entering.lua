-- TODO: Анимированный вход в гараж

local testMarker = exports.dpMarkers:createMarker("garage", Vector3 { x = 1823.5, y = -1412, z = 12.6 }, 180)
addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", testMarker, enterGarage)