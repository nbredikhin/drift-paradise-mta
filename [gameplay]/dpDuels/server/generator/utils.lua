math.randomseed(getTickCount()) 
math.random() math.random() math.random()

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end

function getLineAngle(x1, y1, x2, y2)
	local x = x2 - x1
	local y = y2 - y1
	return math.atan2(y, x)
end

function getAngleBetweenThreePoints(a, b, c)
	if not a or not b or not c then
		outputDebugString("Error")
		outputDebugString(debug.traceback())
	end
	local x1 = a.x - b.x
	local x2 = c.x - b.x

	local y1 = a.y - b.y
	local y2 = c.y - b.y

	local d1 = math.sqrt(x1*x1 + y1*y1)
	local d2 = math.sqrt(x2*x2 + y2*y2)

	return math.acos((x1 * x2 + y1 * y2) / (d1 * d2)) / math.pi * 180
end

function getDistanceBetweenPointAndLine(x, y, x1, y1, x2, y2)
	local d0 = math.abs((y1 - y2) * (x1 - x) - (x1 - x2) * (y1 - y))
	x1 = x1 - x2
	y1 = y1 - y2
	d0 = d0 / math.sqrt(x1 * x1 + y1 * y1)

	local xMin, yMin = math.min(x1, x2), math.min(x2, y2)
	local xMax, yMax = math.max(x1, x2), math.max(x2, y2)

	local angle = getLineAngle(x1, y1, x2, y2)

	local x0 = xMin + d0 * math.cos(angle - math.pi)
	local y0 = yMin + d0 * math.sin(angle - math.pi)

	local lineLen = getDistanceBetweenPoints2D(x1, y1, x2, y2)

	local dMin = getDistanceBetweenPoints2D(x, y, xMin, yMin)
	
	if getLineAngle(x0, y0, x, y) ~= angle then
		return dMin
	else
		local dM = getDistanceBetweenPoints2D(x0, y0, x, y)
		if dM >lineLen then
			return getDistanceBetweenPoints2D(x, y, xMax, yMax)
		end
	end
	return d0
end

-- Квадрат
local function sqr(x)
	return x * x
end

-- Квадрат расстояние между точками {x=x, y=y}
local function dist2(v, w)
	return sqr(v.x - w.x) + sqr(v.y - w.y)
end

-- http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
--[[function getDistanceBetweenPointAndLine(x, y, x1, y1, x2, y2)
	local p, v, w = {x=x, y=y}, {x=x1, y=y1}, {x=x2, y=y2}

	local l2 = dist2(v, w)
	if l2 == 0 then
		return dist2(p, v)
	end

	local t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2
	if t < 0 then 
		return dist2(p, v)
	end
	if t > 1 then
		return dist2(p, w)
	end

	return dist2(p,	{x = v.x + t * (w.x - v.x),
					 y = v.y + t * (w.y - v.y)})
end]]

local sqrt = math.sqrt
local fabs = math.abs

function getDistanceBetweenPointAndLine(cx, cy, ax, ay, bx, by)
	local r_numerator = (cx-ax)*(bx-ax) + (cy-ay)*(by-ay)
	local r_denomenator = (bx-ax)*(bx-ax) + (by-ay)*(by-ay)
	local r = r_numerator / r_denomenator

	local px = ax + r*(bx-ax)
	local py = ay + r*(by-ay)

	local s =  ((ay-cy)*(bx-ax)-(ax-cx)*(by-ay) ) / r_denomenator

	local distanceLine = fabs(s)*sqrt(r_denomenator)

	local xx = px
	local yy = py

	local distanceSegment

	if r >= 0 and r <= 1 then
		distanceSegment = distanceLine
	else
		local dist1 = (cx-ax)*(cx-ax) + (cy-ay)*(cy-ay)
		local dist2 = (cx-bx)*(cx-bx) + (cy-by)*(cy-by)
		if dist1 < dist2 then
			xx = ax
			yy = ay
			distanceSegment = math.sqrt(dist1)
		else
			xx = bx
			yy = by
			distanceSegment = sqrt(dist2)
		end
	end

	return distanceSegment
end