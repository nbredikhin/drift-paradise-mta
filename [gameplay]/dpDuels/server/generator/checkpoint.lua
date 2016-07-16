ignoredID = -1
ignoredCheckpoints = {}

function getAreaFromPos(x, y)
	return math.floor((y + 3000)/750)*8 + math.floor((x + 3000)/750)
end

function getCheckpointLinks(cp)
	local links = {}
	for id, area in pairs(cp.links) do
		if id ~= ignoredID then
			table.insert(links, checkpointsTable[area][id])
		end
	end
	if #links > 1 then
		local newLinks = {}
		for i,link in ipairs(links) do
			if not ignoredCheckpoints[id] then
				table.insert(newLinks, link)
			end
		end
		if #newLinks == 0 then
			newLinks = links
		end

		links = newLinks
	end
	for i, link in ipairs(links) do
		ignoredCheckpoints[link] = true
	end
	return links
end

function getStartCheckpoint(x, y, z, angle)
	local areaID = getAreaFromPos(x, y)
	if not checkpointsTable[areaID] then
		return false
	end


	-- Поиск линий рядом 
	local matchingCheckpoints = {}
	local dist, minDist, minCp, minCp2
	for i, cp in pairs(checkpointsTable[areaID]) do
		for _, cp2 in ipairs(getCheckpointLinks(cp)) do
			local cDist = math.abs((math.min(cp.z, cp2.z) + math.abs(cp.z - cp2.z) / 2) - z)
			dist = getDistanceBetweenPointAndLine(x, y, cp.x, cp.y, cp2.x, cp2.y) + cDist * 10
			if not minDist or dist < minDist then
				--table.insert(matchingCheckpoints, cp)
				minDist = dist
				minCp = cp
				minCp2 = cp2
			end
		end
	end

	angle = (angle + 90) / 180 * math.pi
	local ox, oy = x + math.cos(angle) * 10, y + math.sin(angle) * 10
	
	local angle1 = math.abs(getAngleBetweenThreePoints(minCp, {x=x, y=y}, {x=ox, y=oy}))
	--createMarker(minCp.x, minCp.y, minCp.z, "checkpoint", 1, 0, 255, 255)

	local angle2 = math.abs(getAngleBetweenThreePoints(minCp2,{x=x, y=y}, {x=ox, y=oy}))
	--createMarker(minCp2.x, minCp2.y, minCp2.z, "checkpoint", 1, 255, 255, 0)
	--createMarker(x, y, minCp2.z, "checkpoint", 1, 255, 255, 0)
	--createMarker(ox, oy, minCp2.z, "checkpoint", 1, 255, 255, 0)

	if angle2 < angle1 then
		local t = minCp
		minCp = minCp2
		minCp2 = t
	end

	--createMarker(minCp.x, minCp.y, minCp.z, "checkpoint", 1, 0, 255, 255)
	return minCp, minCp2
end