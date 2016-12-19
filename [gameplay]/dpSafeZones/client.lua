local safeZonesList = {
    -- Hotels
    {Vector2( { x = 1841.980, y = -1334.551} ), Vector2( { x = 1775.478, y = -1447.706 })},
    {Vector2( { x = 379.332, y = -1456.512} ), Vector2( { x =  273.774, y = -1579.720 })},
    -- Мерия
    {Vector2( { x = 1554.707, y = -1744.444} ), Vector2( { x = 1402.353, y = -1776.95 })},
    -- Автомагазин
    {Vector2( { x = 1287.114, y = -1841.375} ), Vector2( { x = 1190.152, y = -1722.41 })},
    -- Тофу
    {Vector2(1790.6027832031, -1796.6713867188), Vector2(1860.779296875, -1888.0509033203)},
    {Vector2(432.24169921875, -1325.7239990234), Vector2(490.64590454102, -1262.1707763672)},
    -- Карты
    {Vector2(2771.876953125, 5112.8662109375),         Vector2(2799.732421875, 5097.1987304688)},
    {Vector2(-7924.3671875, -1405.0994873047),         Vector2(-7886.5209960938, -1383.4351806641)},
    {Vector2(237.86991882324, -4658.326171875),     Vector2(195.05337524414, -4692.185546875)},
    {Vector2(-5905.3154296875, -2413.2290039063),     Vector2(-5951.9028320313, -2448.287109375)},
    {Vector2(6981.1333007813, 1178.7818603516),     Vector2(6953.3442382813, 1157.0775146484)},
    {Vector2(-214.69682312012, -432.53936767578),     Vector2(-189.34918212891, -468.30389404297)},
    {Vector2(5641.8676757813, 1673.189453125),         Vector2(5593.595703125, 1612.4780273438)},
    {Vector2(3359.3044433594, 316.08236694336),     Vector2(3397.3383789063, 347.26177978516)},
    {Vector2(-6293.6240234375, -2567.9130859375),     Vector2(-6313.8559570313, -2529.3305664063)},
    {Vector2(5207.3203125, -3557.1743164063),         Vector2(5154.541015625, -3584.1477050781)},
    {Vector2(-1894.6948242188, -2770.9609375),         Vector2(-1836.0220947266, -2740.5415039063)},
    {Vector2(-2747.0402832031, -2822.2143554688),     Vector2(-2690.3395996094, -2789.3166503906)},
    {Vector2(-6516.7192382813, -3321.9428710938),     Vector2(-6466.6528320313, -3287.9343261719)},
    {Vector2(-4704.4877929688, -3173.9436035156),     Vector2(-4676.533203125, -3214.8508300781)}
}

function createSafeZone(pos1, pos2)
    local rectMin = Vector2(0, 0)
    rectMin.x = math.min(pos1.x, pos2.x)
    rectMin.y = math.min(pos1.y, pos2.y)
    local rectMax = Vector2(0, 0)
    rectMax.x = math.max(pos1.x, pos2.x)
    rectMax.y = math.max(pos1.y, pos2.y)
    local size = rectMax - rectMin
    local colShape = ColShape.Rectangle(rectMin, size)
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
    if not isElement(element) then
        return
    end
    if element == localPlayer then
        setCameraClip(true, false)
    end
    if element.type == "player" or element.type == "vehicle" then
        for i, e in ipairs(colshape:getElementsWithin("player")) do
            if isElement(e) then
                element:setCollidableWith(e, false)
            end
        end
        for i, e in ipairs(colshape:getElementsWithin("vehicle")) do
            if isElement(e) then
                element:setCollidableWith(e, false)
            end
        end
    end
end

local function handleColShapeOut(colshape, element, matchingDimension)
    if not matchingDimension or not colshape:getData("dpSafeZone") then
        return
    end
    if element == localPlayer then
        setCameraClip(true, true)
    end
    if not isElement(element) then
        return
    end
    local elementType = getElementType(element)
    if elementType and elementType == "player" or elementType == "vehicle" then
        for i, e in ipairs(colshape:getElementsWithin("player")) do
            element:setCollidableWith(e, true)
        end
        for i, e in ipairs(colshape:getElementsWithin("vehicle")) do
            element:setCollidableWith(e, true)
        end
    end
end

addEventHandler("onClientColShapeLeave", resourceRoot, function (element, matchingDimension)
    handleColShapeOut(source, element, matchingDimension)
end)

addEventHandler("onClientColShapeHit", resourceRoot, function (element, matchingDimension)
    handleColShapeHit(source, element, matchingDimension)
end)

function leaveSafeZones()
    for _, colshape in ipairs(getElementsByType("colshape")) do
        for _, element in ipairs(colshape:getElementsWithin()) do
            handleColShapeOut(colshape, element, true)
        end
    end
end

for _, colshape in ipairs(getElementsByType("colshape")) do
    for _, element in ipairs(colshape:getElementsWithin()) do
        handleColShapeHit(colshape, element, element.dimension == colshape.dimension)
    end
end
