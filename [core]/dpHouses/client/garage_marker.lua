-- TODO: Анимированный вход в гараж
local HOTEL_GARAGE_POSITION = Vector3 { x = 1823.5, y = -1412, z = 12.6 }

-- Создание маркера гаража
local houseData = localPlayer:getData("house_data")
local position = HOTEL_GARAGE_POSITION
if houseData then
	position = Vector3(unpack(houseData.garage))
end
local garageMarker = exports.dpMarkers:createMarker("garage", position, 180)
addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", garageMarker, function()
	exports.dpGarage:enterGarage()
end)

local garageBlip = createBlip(0, 0, 0, 27)
garageBlip:attach(garageMarker)
garageBlip:setData("text", "blip_garage")

-- Перемещение маркера гаража при покупке/продаже дома
addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "house_data" then
		if exports.dpHouses:hasPlayerHouse(localPlayer) then
			local houseData = localPlayer:getData("house_data")
			local position = Vector3(unpack(houseData.garage))
			if position then
				garageMarker.position = position - Vector3(0, 0, 0.5)	
			end
		else
			garageMarker.position = HOTEL_GARAGE_POSITION
		end
	end
end)