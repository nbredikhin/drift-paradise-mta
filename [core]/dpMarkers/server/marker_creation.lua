-- Создание (и автоматическое удаление) маркеров

local MARKER_COLLISION_RADIUS = 5
local markerTypes = {
	house = {
		radius = 1,
	},

	exit = {
		radius = 1
	}
}
local markersByResource = {}

function createMarker(markerType, position, direction)
	if type(markerType) ~= "string" or not position then
		return false
	end
	if type(direction) ~= "number" then
		direction = 0
	end
	local radius = MARKER_COLLISION_RADIUS
	if markerTypes[markerType] then
		if markerTypes[markerType].radius then
			radius = markerTypes[markerType].radius
		end
	end
	local marker = Marker(position, "cylinder", radius, 0, 0, 0, 0)
	marker:setData("dpMarkers.type", markerType)
	if isElement(sourceResourceRoot) then
		if not markersByResource[sourceResourceRoot] then
			markersByResource[sourceResourceRoot] = {}
		end
		markersByResource[sourceResourceRoot][marker] = true
	end
	marker:setData("dpMarkers.direction", math.rad(direction))
	return marker
end

addEventHandler("onResourceStop", root, function ()
	-- Удаление маркеров, созданных ресурсом после его остановки
	if markersByResource[source] then
		for marker in pairs(markersByResource[source]) do
			if isElement(marker) then
				destroyElement(marker)
			end
			markersByResource[source][marker] = nil
		end
	end
	markersByResource[source] = nil
end)