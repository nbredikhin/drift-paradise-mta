local garageMarker
addEvent("dpMarkers.use", false)

local function updateGarageMarker()
	local houseLocation = getPlayerHouseLocation(localPlayer)
	if not houseLocation then
		return
	end
	garageMarker.position = houseLocation.garage.position - Vector3(0, 0, 0.4)
end

-- Перемещение маркера гаража при покупке/продаже дома или входе на сервер
addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "house_data" or dataName == "_id" then
		updateGarageMarker()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	garageMarker = exports.dpMarkers:createMarker("garage", Vector3(0, 0, 0), 180)

	addEventHandler("dpMarkers.use", garageMarker, function()
		exports.dpGarage:enterGarage()
	end)
	-- Метка на радаре
	local garageBlip = createBlip(0, 0, 0, 27)
	garageBlip:attach(garageMarker)
	garageBlip:setData("text", "blip_garage")

	updateGarageMarker()
end)