RaceCheckpoints = {}
local isActive = false

local checkpointsList = {}
local currentCheckpoint = 1

local currentMarker
local nextMarker
local hitMarker

local currentBlip
local nextBlip

local currentLap = 1

local defaultSettings = {
	checkpointsVisible = true,
	lapsCount = 1
}
local settings = {}

local function destroyMarkers()
	if isElement(currentMarker) then
		destroyElement(currentMarker)
	end

	if isElement(nextMarker) then
		destroyElement(nextMarker)
	end

	if isElement(hitMarker) then
		destroyElement(hitMarker)
	end

	if isElement(currentBlip) then
		destroyElement(currentBlip)
	end

	if isElement(nextBlip) then
		destroyElement(nextBlip)
	end
end

local function onMarkerHit(player)
	if source ~= hitMarker or player ~= localPlayer then
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
			RaceClient.clientFinished()
		else
			-- Следующий круг
			currentLap = currentLap + 1
			currentCheckpoint = 0
			RaceCheckpoints.showNext()
		end
	end	
	RaceClient.checkpointHit(RaceCheckpoints.getCurrentCheckpoint())
end

function RaceCheckpoints.start(checkpoints, settingsTable)
	if isActive then
		return false
	end
	if not settingsTable then settingsTable = {} end
	settings = exports.dpUtils:extendTable(settingsTable, defaultSettings)

	currentLap = 1

	checkpointsList = checkpoints
	currentCheckpoint = 0
	RaceCheckpoints.showNext()

	addEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)
	localPlayer:setData("race_checkpoint", 0)
	isActive = true
end

function RaceCheckpoints.stop()
	if not isActive then
		return false
	end
	destroyMarkers()
	removeEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)
	localPlayer:setData("race_checkpoint", 0)
	isActive = false
end

function RaceCheckpoints.showNext()
	destroyMarkers()
	currentCheckpoint = currentCheckpoint + 1

	local x, y, z = unpack(checkpointsList[currentCheckpoint])
	hitMarker = createMarker(x, y, z - 1, "cylinder", 7, 0, 0, 0, 0)
	hitMarker.dimension = localPlayer.dimension

	if settings.checkpointsVisible then
		local r,g,b = exports.dpUI:getThemeColor()
		currentMarker = createMarker(x, y, z, "checkpoint", 7, r, g, b)
		currentMarker.dimension = localPlayer.dimension

		local isLast = currentCheckpoint == #checkpointsList
		local isLastLap = currentLap == settings.lapsCount 
		if not isLast then
			local cp = checkpointsList[currentCheckpoint + 1]
			local x, y, z = unpack(cp)
			currentMarker:setTarget(x, y, z)

			nextMarker = createMarker(x, y, z, "checkpoint", 7, r, g, b, 100)
			nextMarker.dimension = localPlayer.dimension
			local isLast = currentCheckpoint + 1 == #checkpointsList
			if isLast then
				nextMarker.icon = "finish"
				if isLastLap then
					nextMarker:setColor(255, 255, 255)
				end
			end
		else
			if not isLastLap then
				local x, y, z = unpack(checkpointsList[1])
				currentMarker:setTarget(x, y, z)

				nextMarker = createMarker(x, y, z, "checkpoint", 7, r, g, b, 100)
				nextMarker.dimension = localPlayer.dimension
			end
			currentMarker.icon = "finish"
			currentMarker:setColor(255, 255, 255)
		end		
	end

	if isElement(currentMarker) then
		currentBlip = createBlipAttachedTo(currentMarker, 0)
	end
	if isElement(nextMarker) then
		nextBlip = createBlipAttachedTo(nextMarker, 0)
	end
end

function RaceCheckpoints.getCurrentCheckpoint()
	return currentCheckpoint - 1 + (currentLap - 1) * #checkpointsList
end

function RaceCheckpoints.getCheckpointsCount()
	return #checkpointsList * settings.lapsCount 
end

function RaceCheckpoints.getCheckpointPosition()
	if not isElement(currentMarker) then
		return false
	end
	return currentMarker.position
end