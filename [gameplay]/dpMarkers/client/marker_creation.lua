local MARKER_COLLISION_RADIUS = 6

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
		marker:setParent(sourceResourceRoot)
	end
	addMarkerToDraw(marker)
	marker:setData("dpMarkers.direction", math.rad(direction))
	return marker
end