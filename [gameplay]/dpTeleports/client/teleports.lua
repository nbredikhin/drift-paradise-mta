local cityPosition = Vector3(1481.931, -1762.219, 13.063)
local cityTeleports = {
	Vector3 { x = 1584.047, y = -1731.884, z = 12.899 }
}
local isTeleporting = false

local function teleportToCity()
	if isTeleporting then
		return
	end
	if localPlayer.vehicle and localPlayer.vehicle.controller ~= localPlayer then
		return
	end
	isTeleporting = true
	fadeCamera(false)
	setTimer(function()
		if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
			localPlayer.vehicle.position = cityPosition
		else
			localPlayer.position = cityPosition
		end
		fadeCamera(true)
		isTeleporting = false
	end, 1000, 1)
end

addEvent("dpMarkers.enter", false)
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, pos in ipairs(cityTeleports) do
		local marker = exports.dpMarkers:createMarker("city", pos, 180)
		addEventHandler("dpMarkers.enter", marker, teleportToCity)
	end
end)