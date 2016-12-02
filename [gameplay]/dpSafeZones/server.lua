function createSafeZone(pos1, pos2)
    local rectMin = Vector2(0, 0)
    rectMin.x = math.min(pos1.x, pos2.x)
    rectMin.y = math.min(pos1.y, pos2.y)
    local rectMax = Vector2(0, 0)
    rectMax.x = math.max(pos1.x, pos2.x)
    rectMax.y = math.max(pos1.y, pos2.y)
    local size = rectMax - rectMin
    local colShape = createColRectangle(rectMin, size)
    colShape:setData("dpSafeZone", true)
    return colShape
end
