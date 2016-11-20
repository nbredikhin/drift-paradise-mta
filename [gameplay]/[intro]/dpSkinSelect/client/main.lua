local isActive = false

local selectedSkinIndex = 2

local cameraAnimationFinished = false

local peds = {}
local pedsInfo = {	
	{ model = 1, position = Vector3(1356, -1111.7, 23.775), rotation = 140},
	{ model = 0, position = Vector3(1359, -1115.355, 23.775), rotation = 90},
	{ model = 2, position = Vector3(1357, -1118.7, 23.775), rotation = 50}
}

local cars = {}
local carsInfo = {
	{ model = 411, position = Vector3(1360.719, -1116.2, 23.380), rotation = 125 },
	{ model = 411, position = Vector3(1357.931, -1120.721, 23.365), rotation = 71 },
	{ model = 411, position = Vector3(1358.115, -1110.498, 23.436), rotation = 170 },
}

local cameraStartPosition = Vector3()
local cameraStartLookPosition = Vector3()
local cameraStartFOV = 0

local cameraEndPosition = pedsInfo[2].position + Vector3(-6, -0.2, 0.2)
local cameraEndLookPosition = pedsInfo[2].position + Vector3(0, -1, 0)
local cameraEndFOV = 50

local cameraEndLookPositionTarget = pedsInfo[2].position + Vector3(0, -1, 0)

local cameraAnimationProgress = 0
local cameraAnimationTime = 6
local lookAnimationProgress = 0
local lookAnimationTime = 5.6

local function finishAnimation()
	if cameraAnimationFinished then
		return
	end
	cameraAnimationFinished = true
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	cameraAnimationProgress = math.min(1, cameraAnimationProgress + deltaTime / cameraAnimationTime)
	if cameraAnimationProgress >= 1 then
		finishAnimation()
	end
	lookAnimationProgress = math.min(1, lookAnimationProgress + deltaTime / lookAnimationTime)
	local positionProgress = getEasingValue(cameraAnimationProgress, "InBack")
	local lookProgress = getEasingValue(lookAnimationProgress, "InOutQuad")
	local fovProgress = getEasingValue(cameraAnimationProgress, "InQuad")

	cameraEndLookPosition = cameraEndLookPosition + (cameraEndLookPositionTarget - cameraEndLookPosition) * deltaTime * 3.5

	setCameraMatrix(
		cameraStartPosition + (cameraEndPosition - cameraStartPosition) * positionProgress,
		cameraStartLookPosition + (cameraEndLookPosition - cameraStartLookPosition) * lookProgress,
		0, 
		cameraStartFOV + (cameraEndFOV - cameraStartFOV) * fovProgress
	)
end

local function onKey(key, down)
	if not down then
		return
	end
	if not cameraAnimationFinished then
		return
	end
	if key == "arrow_r" then
		selectedSkinIndex = selectedSkinIndex + 1
		if selectedSkinIndex > #peds then
			selectedSkinIndex = #peds
		end
	elseif key == "arrow_l" then
		selectedSkinIndex = selectedSkinIndex - 1
		if selectedSkinIndex < 1 then
			selectedSkinIndex = 1
		end
	elseif key == "enter" or key == "space" then
		peds[selectedSkinIndex]:setControlState("backwards", true)
		fadeCamera(false, 0.5)
		setTimer(function ()
			hide()
		end, 1000, 1, true)
	end

	cameraEndLookPositionTarget = peds[selectedSkinIndex].position + Vector3(0, -1, 0)
end

function show()
	if isActive then
		return
	end
	fadeCamera(true)
	isActive = true

	cameraAnimationFinished = false
	selectedSkinIndex = 2
	cameraAnimationProgress = 0
	lookAnimationProgress = 0

	local x, y, z, tx, ty, tz, roll, fov = getCameraMatrix()
	cameraStartPosition = Vector3(x, y, z)
	cameraStartLookPosition = Vector3(tx, ty, tz)
	cameraStartFOV = fov

	for i, info in ipairs(pedsInfo) do
		local ped = createPed(info.model, info.position)
		ped.rotation = Vector3(0, 0, info.rotation)
		table.insert(peds, ped)
	end

	for i, info in ipairs(carsInfo) do
		local car = createVehicle(info.model, info.position)
		car.rotation = Vector3(0, 0, info.rotation)
		table.insert(cars, car)
	end

	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientKey", root, onKey)	
end

function hide()
	if not isActive then
		return 
	end
	isActive = false

	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientKey", root, onKey)

	if isElement(ped) then
		destroyElement(ped)
	end

	for i, car in ipairs(cars) do
		if isElement(car) then
			destroyElement(car)
		end
	end

	for i, ped in ipairs(peds) do
		if isElement(ped) then
			destroyElement(ped)
		end
	end	
end

setCameraMatrix(1141.950, -1092.399, 60.909, 1347.834, -1160.533, 109.864)
setTimer(show, 1000, 1)