
local isTeleporting = false

function teleportToMap(name)
	if isTeleporting then
		return false
	end

	isTeleporting = true
	fadeCamera(false, 0.5)
	setTimer(function ()
		triggerServerEvent("dpTeleports.teleport", resourceRoot, name)
		setTimer(fadeCamera, 500, 1, true, 0.5)
		isTeleporting = false
	end, 500, 1)
end

local function teleportToCity()
	teleportToMap()
end

addEvent("dpMarkers.use", false)
addEventHandler("dpMarkers.use", root, function ()
	local markerType = source:getData("dpTeleports.type")
	if markerType and markerType == "city" then
		teleportToCity()
	end
end)

addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "activeMap" then
		local mapName = localPlayer:getData("activeMap")
		exports["TD-RACEMAPS"]:unloadMap()
		if mapName then
			exports["TD-RACEMAPS"]:loadMap(mapName)
		end
	end
end)