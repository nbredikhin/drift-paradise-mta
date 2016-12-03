PathGenerator = {}

local function getNextCheckpointRandom(cp, prev)
	local links = getCheckpointLinks(cp)
	ignoredID = cp.id

	local goodLinks = {}
	for i, link in ipairs(links) do
		local angle = math.abs(getAngleBetweenThreePoints(prev, cp, link))
		if angle > 75 then
			table.insert(goodLinks, link)
		end
	end

	if #goodLinks > 0 then
		local nextIndex = 1
		if #goodLinks > 1 then
			nextIndex = math.random(1, #goodLinks)
		end
		return goodLinks[nextIndex] 
	end


	local nextIndex = 1
	if #links > 1 then
		nextIndex = math.random(1, #links)
	end
	return links[nextIndex] 
end

function getNextCheckpointDirection(cp, x, y)
	local links = getCheckpointLinks(cp)
	ignoredID = cp.id

	if #links == 1 then
		return links[1]
	end

	local maxAngle, maxCp
	for i, tmpCp in ipairs(links) do
		local angle = math.abs(getAngleBetweenThreePoints({x=x, y=y}, cp, tmpCp))

		if not maxAngle or angle > maxAngle then
			maxAngle = angle
			maxCp = tmpCp
		end
	end
	return maxCp
end


local function spliceCheckpoints(x1, y1, z1, x2, y2, z2)
	local ox, oy, oz = (x2 - x1) / 2, (y2 - y1) / 2, (z2 - z1) / 2
	return x1 + ox, y1 + oy, z1 + oz
end

local function generateTrack(x, y, z, dx, dy, angle, totalCheckpointsCount)
	ignoredCheckpoints = {}
	local checkpoints = {}

	ignoredID = -1
	local cp, prev = getStartCheckpoint(x, y, z, angle)
	local firstCp = cp
	if not cp then
		outputDebugString("Слишком далеко от дороги")
		return false
	end

	if getDistanceBetweenPoints3D(cp.x, cp.y, cp.z, x, y, z) > 15 then
		table.insert(checkpoints, {cp.x, cp.y, cp.z})
	end


	prev = cp
	cp = getNextCheckpointDirection(cp, x, y)
	ignoredID = firstCp.id
	if not cp then
		--outputDebugString("wat1")
		return false
	end
	table.insert(checkpoints, {cp.x, cp.y, cp.z})
	--math.randomseed(3) 
	--math.random()
	for i = 1, totalCheckpointsCount do
		local oldCp = cp
		cp = getNextCheckpointRandom(cp, prev, info)

		if not cp then
			return checkpoints
		end
		prev = oldCp
		table.insert(checkpoints, {cp.x, cp.y, cp.z})
	end

	-- Склеивание
	local i = 2
	while i <= #checkpoints do
		local cp1 = checkpoints[i - 1]
		local cp2 = checkpoints[i]
		local distance = getDistanceBetweenPoints3D(cp1[1], cp1[2], cp1[3], cp2[1], cp2[2], cp2[3])
		if distance < 30 then
			-- Размер
			checkpoints[i - 1] = {spliceCheckpoints(cp1[1], cp1[2], cp1[3], cp2[1], cp2[2], cp2[3])}
			table.remove(checkpoints, i)
			
		end
		i = i + 1
	end

	-- Убирание прямых
	local i = 3
	while i <= #checkpoints do
		local cp1 = checkpoints[i - 2]
		local cp2 = checkpoints[i - 1]
		local cp3 = checkpoints[i]
		local distance = getDistanceBetweenPoints2D(cp1[1], cp1[2], cp3[1], cp3[2])
		if distance < 300 then
			local angle = math.abs(getAngleBetweenThreePoints({x=cp1[1],y=cp1[2]}, {x=cp2[1], y=cp2[2]}, {x=cp3[1],y=cp3[2]}) - 180)
			if angle < 10 then
				table.remove(checkpoints, i - 1)
			end
		end
		i = i + 1
	end
	return checkpoints
end

local function get_random_offset(min, max)
	local offset = math.random(min, max)
	if math.random(1, 2) == 2 then
		offset = -offset 
	end
	return offset
end

function PathGenerator.generateCheckpointsFromPoint(x, y, z, checkpointsCount)
	if not x or not y or not z then
		return false
	end
	if not checkpointsCount then
		return false
	end
	-- Чекпойнтов не может быть меньше трёх
	checkpointsCount = math.max(3, checkpointsCount)

	-- Начальные координаты
	local rx, ry, rz = 0, 0, math.random(0, 360)
	local ox, oy, oz = x + get_random_offset(10, 15), y + get_random_offset(10, 15), z

	-- Чекпойнты
	local checkpoints = generateTrack(ox, oy, oz, x, y, rz, checkpointsCount)

	if not checkpoints or type(checkpoints) ~= "table" or #checkpoints == 0 then
		return false
	end

	-- Конвертирование массива координат в таблицу c x, y, z
	--[[for i, checkpoint in ipairs(checkpoints) do
		checkpoints[i] = {x = checkpoint[1], y = checkpoint[2], z = checkpoint[3]}
	end]]
	return checkpoints
end

function PathGenerator.getNearestCheckpoint(player)
	return getStartCheckpoint(player.position.x, player.position.y, player.position.z, player.rotation.z)
end

function PathGenerator.generateCheckpointsForPlayer(player, checkpointsCount)
	if not player.vehicle then
		return false
	end
	if not checkpointsCount then
		return false
	end
	-- Чекпойнтов не может быть меньше трёх
	checkpointsCount = math.max(3, checkpointsCount)

	local vehicle = player.vehicle

	-- Начальные координаты
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	local ox, oy, oz = getPositionFromElementOffset(vehicle, 0, 30, 0)

	-- Чекпойнты
	local checkpoints = generateTrack(ox, oy, oz, x, y, rz, checkpointsCount)

	if not checkpoints or type(checkpoints) ~= "table" or #checkpoints == 0 then
		return false
	end

	-- Конвертирование массива координат в таблицу c x, y, z
	--[[for i, checkpoint in ipairs(checkpoints) do
		checkpoints[i] = {x = checkpoint[1], y = checkpoint[2], z = checkpoint[3]}
	end]]
	return checkpoints
end