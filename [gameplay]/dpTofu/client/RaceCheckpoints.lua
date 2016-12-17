RaceCheckpoints = {}
local isActive = false

local checkpointsList = {}
local currentCheckpoint = 1

local markers = {}

local currentBlip
local nextBlip

local currentLap = 1

local defaultSettings = {
	checkpointsVisible = true,
	lapsCount = 1
}
local settings = {}

local function destroyMarkers()
	for name, marker in pairs(markers) do
		if isElement(marker) then
			marker:destroy()
		end
	end

	if isElement(currentBlip) then
		currentBlip:destroy()
	end

	if isElement(nextBlip) then
		nextBlip:destroy()
	end
end

local function onMarkerHit(player)
	if source ~= markers.hit or player ~= localPlayer then
		return
	end
	if settings.checkpointsVisible then
		playSoundFrontEnd(43)
	end
	if currentCheckpoint < #checkpointsList then
		RaceCheckpoints.showNext()
	else
		-- Круг был последний
		if currentLap >= settings.lapsCount then
			currentCheckpoint = currentCheckpoint + 1
			finishTofu()
		else
			-- Следующий круг
			currentLap = currentLap + 1
			currentCheckpoint = 0
			RaceCheckpoints.showNext()
		end
	end
end

function RaceCheckpoints.start(checkpoints, settingsTable)
	if isActive then
		return false
	end
	isActive = true

	if not settingsTable then settingsTable = {} end
	settings = exports.dpUtils:extendTable(settingsTable, defaultSettings)

	currentLap = 1

	checkpointsList = checkpoints
	currentCheckpoint = 0
	RaceCheckpoints.showNext()

	addEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)
end

function RaceCheckpoints.stop()
	if not isActive then
		return false
	end
	destroyMarkers()
	isActive = false
	removeEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)
end

function RaceCheckpoints.showNext()
	destroyMarkers()
	currentCheckpoint = currentCheckpoint + 1

	local x, y, z = unpack(checkpointsList[currentCheckpoint])
	markers.hit = Marker(x, y, z - 1, "cylinder", 9, 0, 0, 0, 0)
	markers.hit.dimension = localPlayer.dimension

	if settings.checkpointsVisible then
		local r, g, b = exports.dpUI:getThemeColor()
		markers.current = Marker(x, y, z, "checkpoint", 7, r, g, b)
		markers.current.dimension = localPlayer.dimension

		local isLast = currentCheckpoint == #checkpointsList
		local isLastLap = currentLap == settings.lapsCount
		if not isLast then
			local cp = checkpointsList[currentCheckpoint + 1]
			local x, y, z = unpack(cp)
			markers.current:setTarget(x, y, z)

			markers.next = Marker(x, y, z, "checkpoint", 7, r, g, b, 100)
			markers.next.dimension = localPlayer.dimension
			local isLast = currentCheckpoint + 1 == #checkpointsList
			if isLast then
				markers.next.icon = "finish"
				if isLastLap then
					markers.next:setColor(255, 255, 255)
				end
			end
		else
			if not isLastLap then
				local x, y, z = unpack(checkpointsList[1])
				markers.current:setTarget(x, y, z)

				markers.next = Marker(x, y, z, "checkpoint", 7, r, g, b, 100)
				markers.next.dimension = localPlayer.dimension
			end
			markers.current.icon = "finish"
			markers.current:setColor(255, 255, 255)
		end
	end

	if isElement(markers.current) then
		currentBlip = createBlipAttachedTo(markers.current, 0)
	end
	if isElement(markers.next) then
		nextBlip = createBlipAttachedTo(markers.next, 0)
	end
end

function RaceCheckpoints.getCurrentCheckpoint()
	return currentCheckpoint - 1 + (currentLap - 1) * #checkpointsList
end

function RaceCheckpoints.getCheckpointsCount()
	return #checkpointsList * settings.lapsCount
end

function RaceCheckpoints.getCheckpointPosition()
	if not isElement(markers.current) then
		return false
	end
	return markers.current.position
end
