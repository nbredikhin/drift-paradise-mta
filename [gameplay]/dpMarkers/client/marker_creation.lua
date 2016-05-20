local MARKER_COLLISION_RADIUS = 5
local markersByResource = {}

function createMarker(markerType, position, direction)
	if type(markerType) ~= "string" or not position then
		return false
	end
	if type(direction) ~= "number" then
		direction = 0
	end
	local marker = Marker(position, "cylinder", MARKER_COLLISION_RADIUS, 0, 0, 0, 0)
	marker:setData("dpMarkers.type", markerType)
	if isElement(sourceResourceRoot) then
		if not markersByResource[sourceResourceRoot] then
			markersByResource[sourceResourceRoot] = {}
		end
		markersByResource[sourceResourceRoot][marker] = true
	end
	addMarkerToDraw(marker)
	marker:setData("dpMarkers.direction", math.rad(direction))
	return marker
end

addEventHandler("onClientResourceStop", root, function ()
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