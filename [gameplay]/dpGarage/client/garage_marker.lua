-- TODO: Анимированный вход в гараж

local houseData = localPlayer:getData("house_data")
local position = Vector3 { x = 1823.5, y = -1412, z = 12.6 }
if houseData then
	position = Vector3(unpack(houseData.garage))
end
local garageMarker = exports.dpMarkers:createMarker("garage", position, 180)
addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", garageMarker, enterGarage)

local garageBlip = createBlip(0, 0, 0, 27)
garageBlip:attach(garageMarker)
garageBlip:setData("text", "blip_garage")

addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "house_data" then
		if exports.dpHouses:hasPlayerHouse(localPlayer) then
			local houseData = localPlayer:getData("house_data")
			local position = Vector3(unpack(houseData.garage))
			if position then
				garageMarker.position = position	
			end
		else
			garageMarker.position = Vector3 { x = 1823.5, y = -1412, z = 12.6 }
		end
	end
end)