local cityPosition = Vector3(1467.486, -1749.974, 13.147)
local cityTeleports = {
	Vector3 { x = 5806.767, y = -2136.201, z = 1105.473 }
}
local mapsTeleports = {
	primring = Vector3({x = 5808.703, y = -2120.563, z = 1105.933})
}
local isTeleporting = false

local function teleportPlayer(position)
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
			localPlayer.vehicle.position = position
		else
			localPlayer.position = position
		end
		fadeCamera(true)
		isTeleporting = false
	end, 1000, 1)
end

function teleportToMap(name)
	if not name then
		return false
	end
	if not mapsTeleports[name] then
		return
	end
	teleportPlayer(mapsTeleports[name])
	localPlayer:setData("activeMap", name)
end

local function teleportToCity()
	teleportPlayer(cityPosition)
	localPlayer:setData("activeMap", false)
end

addEvent("dpMarkers.enter", false)
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, pos in ipairs(cityTeleports) do
		local marker = exports.dpMarkers:createMarker("city", pos, 180)
		addEventHandler("dpMarkers.enter", marker, teleportToCity)
	end
end)