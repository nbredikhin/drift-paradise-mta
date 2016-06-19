-- Отрисовка маркеров

local screenSize = Vector2(guiGetScreenSize())

local MARKER_ANIMATION_SPEED = 0.008

-- Иконка на земле
local MARKER_ICON_SIZE = 6
local MARKER_ANIMATION_SIZE = 0.3

local MARKER_TEXT_SIZE = 5
local MARKER_TEXT_ANIMATION_SIZE = 0.1
local MARKER_TEXT_OFFSET = Vector3(0, 0, 2)

local markersToDraw = {}
local markerTypes = {}

-- Текст на экране
local screenTextFont
local screenTextBottomOffset = 100

-- Маркер, в котором сейчас находится игрок
local currentMarker
local markerKey = "g"

markerTypes.garage = {
	color = {212, 0, 40},
	icon = "assets/garage_icon.png",
	text = "assets/garage_text.png",
	string = "markers_garage_text"
}

markerTypes.city = {
	color = {212, 0, 40},
	icon = "assets/city_icon.png",
	text = "assets/city_text.png",
	string = "markers_city_text"
}

local function drawScreenText(text)
	text = string.format(exports.dpLang:getString(text), string.upper(markerKey))
	local yOffset = math.sin(getTickCount() * MARKER_ANIMATION_SPEED) * 5
	dxDrawText(
		text, 
		10, 
		10 + yOffset, 
		screenSize.x, 
		screenSize.y - screenTextBottomOffset + 2 + yOffset, 
		tocolor(0, 0, 0, 150), 
		1, 
		screenTextFont, 
		"center", 
		"bottom"
	)
	dxDrawText(
		text, 
		0, 
		0 + yOffset, 
		screenSize.x, 
		screenSize.y - screenTextBottomOffset + yOffset, 
		tocolor(255, 255, 255), 
		1, 
		screenTextFont, 
		"center", 
		"bottom"
	)	
end

local function drawMarker(marker)
	local markerType = marker:getData("dpMarkers.type")
	local markerProperties = markerTypes[markerType]
	if not markerProperties then
		return
	end

	local t = getTickCount()

	local color = {
		markerProperties.color[1], 
		markerProperties.color[2], 
		markerProperties.color[3], 
		200 + math.sin(t * MARKER_ANIMATION_SPEED / 3) * 35
	}

	local iconSize = MARKER_ICON_SIZE - math.sin(t * MARKER_ANIMATION_SPEED) * MARKER_ANIMATION_SIZE
	local textSize = MARKER_TEXT_SIZE
	if localPlayer:isWithinMarker(marker) or 
		(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(marker))
	then
		color = {
			232 + math.sin(t * MARKER_ANIMATION_SPEED) * 23, 
			20 + math.sin(t * MARKER_ANIMATION_SPEED) * 20,
			60 + math.sin(t * MARKER_ANIMATION_SPEED) * 30,
			255
		}

		drawScreenText(markerProperties.string)
		currentMarker = marker
	end	

	-- Иконка на земле
	local direction = marker:getData("dpMarkers.direction")
	local ox = math.cos(direction) * iconSize / 2
	local oy =  math.sin(direction) * iconSize / 2
	dxDrawMaterialLine3D(
		marker.position.x + ox,
		marker.position.y + oy,
		marker.position.z,
		marker.position.x - ox,
		marker.position.y - oy,
		marker.position.z,
		markerProperties.icon, 
		iconSize,
		tocolor(255, 255, 255, color[4]),
		marker.position.x,
		marker.position.y,
		marker.position.z + 1
	)

	-- Вертикальная картинка
	local textAnimationOffset = math.sin(t * MARKER_ANIMATION_SPEED) * MARKER_TEXT_ANIMATION_SIZE
	dxDrawMaterialLine3D(
		marker.position.x, 
		marker.position.y,
		marker.position.z + textSize / 2 + MARKER_TEXT_OFFSET.z + textAnimationOffset,
		marker.position.x,
		marker.position.y,
		marker.position.z - textSize / 2 + MARKER_TEXT_OFFSET.z + textAnimationOffset,
		markerProperties.text,
		textSize,
		tocolor(unpack(color))
	)
end

function addMarkerToDraw(marker)
	if isElementStreamedIn(marker) then
		markersToDraw[marker] = true
	end
end

addEventHandler("onClientRender", root, function ()
	if localPlayer:getData("dpCore.state") then
		return
	end
	for marker in pairs(markersToDraw) do
		drawMarker(marker)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source:getData("dpMarkers.type") then
		addMarkerToDraw(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if markersToDraw[source] then
		markersToDraw[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", root, function ()
	if markersToDraw[source] then
		markersToDraw[source] = nil
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for name, markerProperties in pairs(markerTypes) do
		markerProperties.icon = dxCreateTexture(markerProperties.icon)
		markerProperties.text = dxCreateTexture(markerProperties.text)
	end

	screenTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 30)
end)

addEventHandler("onClientKey", root, function (key, state)
	if key == markerKey and state then
		if isMTAWindowActive() then
			return false
		end
		if not isElement(currentMarker) then
			return
		end
		if localPlayer:getData("dpCore.state") then
			return
		end	
		if localPlayer:isWithinMarker(currentMarker) or 
			(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(currentMarker))
		then
			triggerEvent("dpMarkers.enter", currentMarker)
			cancelEvent()
		end		
	end
end)