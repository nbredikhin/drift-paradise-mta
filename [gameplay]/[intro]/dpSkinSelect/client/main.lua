local isActive = false

local screenSize = Vector2(guiGetScreenSize())
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
	{ model = 411, position = Vector3(1358.115, -1110.498, 23.436), rotation = 170 }
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

local font
local arrowTexture
local arrowSize = 100
local arrowsAnimation = 0
local guiAlpha = 0
local guiAlphaTarget = 0

local function finishAnimation()
	if cameraAnimationFinished then
		return
	end
	exports.dpTutorialMessage:hideMessage()
	exports.dpTutorialMessage:showMessage(
		exports.dpLang:getString("tutorial_skin_select_title"), 
		exports.dpLang:getString("tutorial_skin_select_text"), 
		utf8.lower(exports.dpLang:getString("controls_arrows")))

	cameraAnimationFinished = true
	guiAlphaTarget = 1
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

	arrowsAnimation = arrowsAnimation + deltaTime
	if arrowsAnimation > math.pi * 2 then
		arrowsAnimation = 0
	end

	guiAlpha = guiAlpha + (guiAlphaTarget - guiAlpha) * deltaTime * 1
end

local function draw()
	dxDrawText(
		exports.dpLang:getString("skin_select_text"),
		20, 
		20,
		screenSize.x,
		screenSize.y,
		tocolor(255, 255, 255, 255 * guiAlpha),
		1,
		font,
		"center",
		"top")	

	local offset = math.sin(arrowsAnimation * 5) * 10
	local a = 255 * guiAlpha
	if selectedSkinIndex == 1 then
		a = a * 0.3
	end
	dxDrawImage(arrowSize + offset, screenSize.y / 2 - arrowSize / 2, -arrowSize, arrowSize, arrowTexture, 0, 0, 0, tocolor(255, 255, 255, a))
	a = 255 * guiAlpha
	if selectedSkinIndex == #peds then
		a = a * 0.3
	end
	dxDrawImage(screenSize.x - arrowSize - offset, screenSize.y / 2 - arrowSize / 2, arrowSize, arrowSize, arrowTexture, 0, 0, 0, tocolor(255, 255, 255, a))
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
		exports.dpTutorialMessage:hideMessage()
		peds[selectedSkinIndex]:setControlState("backwards", true)
		fadeCamera(false, 0.5)
		guiAlphaTarget = 0
		setTimer(function ()
			triggerServerEvent("dpSkinSelect.selectedSkin", localPlayer, peds[selectedSkinIndex].model)
			hide()
		end, 1000, 1, true)
	end

	cameraEndLookPositionTarget = peds[selectedSkinIndex].position + Vector3(0, -1, 0)
end

function show()
	if isActive then
		return
	end

	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 24)
	arrowTexture = exports.dpAssets:createTexture("arrow.png")
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
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientKey", root, onKey)		

	localPlayer:setData("dpCore.state", "skinSelect")
	localPlayer:setData("activeUI", "skinSelect")

	exports.dpHUD:setVisible(false)
	exports.dpChat:setVisible(false)

	localPlayer.dimension = 0

	guiAlpha = 0
	guiAlphaTarget = 0
end

function hide()
	if not isActive then
		return 
	end
	isActive = false

	if isElement(font) then
		destroyElement(font)
	end
	if isElement(arrowTexture) then
		destroyElement(arrowTexture)
	end

	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientRender", root, draw)
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

	localPlayer:setData("dpCore.state", false)
	localPlayer:setData("activeUI", false)
end