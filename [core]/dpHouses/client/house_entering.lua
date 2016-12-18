local knockingSound
local knockingDisabled = false

local function enterHouse(marker)
	setTimer(function ()
		triggerServerEvent("dpHouses.house_enter", resourceRoot, marker.id)
		exports.dpHUD:setVisible(false)
	end, 500, 1)
	fadeCamera(false, 0.5)
end

addEvent("dpHouses.knock", true)
addEventHandler("dpHouses.knock", root, function (houseId)
	if not isElement(source) then
		return
	end
	if isElement(knockingSound) then
		return
	end

	if isElementStreamedIn(source) then
		knockingSound = playSound3D("assets/sounds/knocking.wav", source.position)
		knockingSound.maxDistance = 20
		knockingSound.mixDistance = 1
	end
	local exitMarker = Element.getByID("house_exit_marker_" .. tostring(houseId))
	if isElement(exitMarker) and isElementStreamedIn(exitMarker) then
		local sound = playSound3D("assets/sounds/knocking.wav", exitMarker.position)
		sound.maxDistance = 20
		sound.mixDistance = 1
		sound.dimension = exitMarker.dimension
		sound.interior = exitMarker.interior
	end
end)

local function knockHouse(marker)
	if knockingDisabled then
		return
	end
	if not isElement(marker) then
		return
	end
	triggerServerEvent("dpHouses.knock", resourceRoot, marker:getData("_id"))
	knockingDisabled = true
	setTimer(function() knockingDisabled = false end, HOUSE_DOOR_KNOCKING_COOLDOWN, 1)
end

addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", root, function ()
	local marker = source
	if type(marker:getData("house_data")) == "table" then
		local playerId = localPlayer:getData("_id")
		local houseId = localPlayer:getData("house_id")
		local ownerId = marker:getData("owner_id")

		if not ownerId and houseId then
			marker:setData("dpMarkers.text", "", false)
		elseif ownerId and ownerId ~= playerId then
			local isOpen = marker:getData("house_open")

			if not isOpen then
				marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_knock_text"), false)
			else
				marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_enter_text"), false)
			end
		elseif not ownerId and not houseId then
			localPlayer:setData("dpHouses.standingOnHouseId", marker:getData("_id"))
			marker:setData("dpMarkers.text", "markers_house_buy_text", false)
		else
			marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_enter_text"), false)
		end
	end
end)

addEvent("dpMarkers.use", false)
addEventHandler("dpMarkers.use", root, function ()
	local marker = source
	if type(marker:getData("house_data")) == "table" then
		local houseData = marker:getData("house_data")
		local ownerId = marker:getData("owner_id")
		local houseId = localPlayer:getData("house_id")
		local playerId = localPlayer:getData("_id")
		if not ownerId and houseId then
			exports.dpUI:showMessageBox(
				exports.dpLang:getString("houses_message_title"),
				exports.dpLang:getString("houses_message_already_have_house")
			)
			return
		elseif ownerId and ownerId ~= playerId then
			local opened = marker:getData("house_open")
			if opened then
				enterHouse(marker)
				return
			else
				knockHouse(marker)
			end
		elseif not ownerId and not houseId then
			BuyWindow.show(marker)
			return
		end
		if ownerId == playerId then
			enterHouse(marker)
		end
	elseif type(marker:getData("house_exit_position")) == "table" then
		setTimer(function ()
			triggerServerEvent("dpHouses.house_exit", resourceRoot, marker.id)
			exports.dpHUD:setVisible(true)
		end, 500, 1)
		fadeCamera(false, 0.5)
	end
end)

addEvent("dpHouses.kickedFromHouse", true)
addEventHandler("dpHouses.kickedFromHouse", resourceRoot, function ()
	exports.dpHUD:setVisible(true)
end)

addEventHandler("onClientElementDataChange", root, function(dataName)
	if source.type ~= "marker" then
		return
	end
	local marker = source
	-- Текст маркера при открытии/закрытии двери
	if dataName == "house_open" then
		if not isElementStreamedIn(source) then
			return
		end
		local isOpen = marker:getData("house_open")
		if not isOpen then
			marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_knock_text"), false)
		else
			marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_enter_text"), false)
		end
	elseif dataName == "owner_id" then
		local ownerId = marker:getData("owner_id")
		if not ownerId then
			return
		end
		local playerId = localPlayer:getData("_id")
		if not playerId then
			return
		end

		-- Если дом стал принадлежать игроку
		if ownerId == playerId then
			marker:setData("dpMarkers.text", exports.dpLang:getString("markers_house_enter_text"), false)
		end
	end
end)

addEvent("dpCore.spawn", true)
addEventHandler("dpCore.spawn", localPlayer, function(isHotel)
	if not isHotel then
		exports.dpHUD:setVisible(false)
	else
		exports.dpGarage:enterGarage()
	end
end)
