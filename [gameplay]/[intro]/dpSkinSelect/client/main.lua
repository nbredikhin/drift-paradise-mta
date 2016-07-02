SkinSelect = {}
local screenSize = Vector2(guiGetScreenSize())
local DIMENSION = 1000

local skinsList = {
	0, 1, 2
}

local currentSkin = 1

local PED_POSITION = Vector3({ x = 1637.625, y = -1527.992, z = 13.598 })
local PED_ROTATION = 205
local CAMERA_POSITION = Vector3( { x = 1640.782, y = -1533.632, z = 13.582 })
local pedLeft
local pedRight
local vehicle

local currentState = "stand"
local targetRotation = 0

local POSITION_LEFT = Vector3 { x = 1634.956, y = -1529.954, z = 13.615 }
local POSITION_RIGHT = Vector3 { x = 1641.183, y = -1524.967, z = 13.582 }

local font
local screenText

local function getAngleBetweenPoints(p1, p2)
	local xDiff = p2.x - p1.x
	local yDiff = p2.y - p1.y
	return math.deg(math.atan2(yDiff, xDiff)) - 90
end

local function update()
	local shakeY = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.008
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.01
	local offset = Vector3(0, shakeY, shakeZ) 
	Camera.setMatrix(CAMERA_POSITION - offset / 4, PED_POSITION + offset + Vector3(0, 0, 0.2), 0, 37)

	if currentState == "walk" and getDistanceBetweenPoints2D(pedLeft.position, PED_POSITION) < 0.05 then
		pedLeft.position = PED_POSITION
		--outputDebugString(pedLeft.rotation.z)
		pedLeft.rotation = Vector3(0, 0, PED_ROTATION)
		targetRotation = PED_ROTATION
		setPedControlState(pedLeft, "forwards", false)
		setPedControlState(pedRight, "left", false)
		currentState = "stand"
		pedRight.position = POSITION_LEFT
		pedLeft, pedRight = pedRight, pedLeft
	end
end

local function onKey(key, state)
	if localPlayer:getData("activeUI") ~= "skinSelect" then
		return
	end
	if not state then
		return
	end
	if key == "enter" and currentState == "stand" then
		setTimer(function ()
			SkinSelect.exit()
			triggerServerEvent("dpSkinSelect.selected", resourceRoot, currentSkin)
		end, 2000, 1)

		setTimer(function ()
			fadeCamera(false, 1.3)
		end, 500, 1)
		setPedControlState(pedRight, "backwards", true)
		currentState = "enter"
	end
	if (key == "arrow_r" or key == "arrow_l") and currentState == "stand" then
		if key == "arrow_r" then
			currentSkin = currentSkin + 1
		else
			currentSkin = currentSkin - 1
		end
		if currentSkin < 1 then
			currentSkin = #skinsList
		end
		if currentSkin > #skinsList then
			currentSkin = 1
		end
		--pedRight.rotation = Vector3(0, 0, PED_ROTATION + 90)
		--setPedLookAt(pedRight, POSITION_RIGHT)		
		pedLeft.position = POSITION_LEFT
		pedLeft.model = skinsList[currentSkin]
		pedLeft.rotation = Vector3(0, 0, getAngleBetweenPoints(pedLeft.position, PED_POSITION))
		setPedControlState(pedLeft, "forwards", true)
		setPedControlState(pedRight, "left", true)

		currentState = "walk"
	end
end

local function draw()
	dxDrawText(screenText, 0, 0, screenSize.x, screenSize.y / 4, tocolor(255, 255, 255, alpha), 1, font, "center", "center")
end

function SkinSelect.enter()
	if isElement(pedLeft) then
		return
	end	
	vehicle = Vehicle(
		558, 
		Vector3 { x = 1636.110, y = -1525.063, z = 13.330 }, 
		Vector3 { x = 0.160, y = 359.829, z = 143.062 }
	)
	vehicle:setData("BodyColor", {212, 0, 40})
	vehicle.frozen = true
	vehicle.dimension = DIMENSION
	pedLeft = Ped(skinsList[2], POSITION_LEFT, PED_ROTATION + 90)
	pedLeft.dimension = DIMENSION
	pedRight = Ped(skinsList[1], PED_POSITION, PED_ROTATION)
	pedRight.dimension = DIMENSION
	setPedControlState(pedLeft, "walk", true)
	setPedControlState(pedRight, "walk", true)
	exports.dpHUD:setVisible(false)
	setTime(12, 12)
	setWeather(1)
	fadeCamera(true, 2)

	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientRender", root, draw, true, "high+10")
	addEventHandler("onClientKey", root, onKey)

	localPlayer.dimension = DIMENSION
	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 36)
	screenText = exports.dpLang:getString("skin_select_text")
	showChat(false)
	localPlayer:setData("activeUI", "skinSelect", false)
end

function SkinSelect.exit()
	if not isElement(pedLeft) then
		return
	end
	destroyElement(vehicle)
	destroyElement(pedLeft)
	destroyElement(pedRight)

	fadeCamera(false, 1)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientKey", root, onKey)

	localPlayer.dimension = 0

	showChat(true)
	localPlayer:setData("activeUI", false, true)
end

addEvent("dpSkinSelect.start", true)
addEventHandler("dpSkinSelect.start", root, function(skins)
	if not skins then
		skins = {1, 2}
	end
	skinsList = skins
	SkinSelect.enter()
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
	SkinSelect.exit()
end)