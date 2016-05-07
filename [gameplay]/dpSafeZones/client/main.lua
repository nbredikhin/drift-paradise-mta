local safeZonesList = {
	-- Отель
	{Vector3( { x = 1841.980, y = -1334.551, z = 10 }), Vector3( { x = 1775.478, y = -1447.706, z = 30 })}
}

local function createSafeZone(position1, position2)
	local startPos = Vector3()
	startPos.x = math.min(position1.x, position2.x)
	startPos.y = math.min(position1.y, position2.y)
	startPos.z = math.min(position1.z, position2.z)
	endPos = Vector3()
	endPos.x = math.max(position1.x, position2.x)
	endPos.y = math.max(position1.y, position2.y)
	endPos.z = math.max(position1.z, position2.z)	
	local size = endPos - startPos
	local colShape = createColCuboid(startPos, size)
	colShape:setData("dpSafeZone", true)
	return colShape
end

for _, zone in ipairs(safeZonesList) do
	createSafeZone(unpack(zone))
end

local function handleColShapeHit(colshape, element, matchingDimension)
	if not matchingDimension or not colshape:getData("dpSafeZone") then
		return
	end
	if element.type == "player" then
		for i, e in ipairs(colshape:getElementsWithin("player")) do
			element:setCollidableWith(e, false)
		end
	elseif element.type == "vehicle" then
		for i, e in ipairs(colshape:getElementsWithin("vehicle")) do
			element:setCollidableWith(e, false)
		end
	end
end

addEventHandler("onClientColShapeHit", resourceRoot, function (element, matchingDimension)
	handleColShapeHit(source, element, matchingDimension)
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function (element, matchingDimension)
	if not matchingDimension or not source:getData("dpSafeZone") then
		return
	end
	if element.type == "player" then
		for i, e in ipairs(source:getElementsWithin("player")) do
			element:setCollidableWith(e, true)
		end
	elseif element.type == "vehicle" then
		for i, e in ipairs(source:getElementsWithin("vehicle")) do
			element:setCollidableWith(e, true)
		end
	end
end)

for _, colshape in ipairs(getElementsByType("colshape")) do
	for _, element in ipairs(colshape:getElementsWithin()) do
		handleColShapeHit(colshape, element, element.dimension == colshape.dimension)
	end
end