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

-- Текст на экране
local screenTextFont
local screenTextBottomOffset = 60

-- Маркер, в котором сейчас находится игрок
local currentMarker
local markerKey = "g"

local markerTypes = {}
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

markerTypes.showroom = {
	color = {212, 0, 40},
	icon = "assets/showroom_icon.png",
	text = "assets/showroom_text.png",
	string = "markers_showroom_text"
}

markerTypes.house = {
	color = {212, 0, 40},
	icon = "assets/house_floor.png",
	iconSize = 1,
	text = "assets/house_icon.png",
	string = "markers_house_enter_text"
}

markerTypes.stripclub = {
	color = {212, 0, 40},
	icon = "assets/house_floor.png",
	iconSize = 1,
	text = "assets/strip_icon.png",
	string = "markers_strip_enter_text"
}

markerTypes.race = {
	color = {255, 255, 255},
	icon = "assets/race_icon.png",
	iconSize = 12.5,
	text = "assets/race_text.png",
	string = "markers_race_enter_text",
	noPaint = true
}

markerTypes.exit = {
	color = {212, 0, 40},
	text = "assets/exit_icon.png",
	string = "markers_house_exit_text"
}

function getMarkerProperties(type)
	return markerTypes[type]
end

local function dxDrawShadowText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

local function drawScreenText(text)
	text = string.format(exports.dpLang:getString(text), string.upper(markerKey))
	local yOffset = math.sin(getTickCount() * MARKER_ANIMATION_SPEED) * 5
	-- dxDrawText(
	-- 	text, 
	-- 	10, 
	-- 	10 + yOffset, 
	-- 	screenSize.x, 
	-- 	screenSize.y - screenTextBottomOffset + 2 + yOffset, 
	-- 	tocolor(0, 0, 0, 150), 
	-- 	1, 
	-- 	screenTextFont, 
	-- 	"center", 
	-- 	"bottom"
	-- )
	dxDrawShadowText(
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

	-- Текст маркера
	if localPlayer:isWithinMarker(marker) or 
		(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(marker))
	then
		if not markerProperties.noPaint then
			color = {
				232 + math.sin(t * MARKER_ANIMATION_SPEED) * 23, 
				20 + math.sin(t * MARKER_ANIMATION_SPEED) * 20,
				60 + math.sin(t * MARKER_ANIMATION_SPEED) * 30,
				255
			}
		end
		local markerText = marker:getData("dpMarkers.text")
		if not markerText then
			markerText = markerProperties.string
		end
		drawScreenText(markerText)
		if currentMarker ~= marker then
			triggerEvent("dpMarkers.enter", marker)
			currentMarker = marker
		end
	end	

	local mx, my, mz = getElementPosition(marker)
	-- Иконка на земле
	if markerProperties.icon then
		-- Размеры иконки
		local markerIconSize = MARKER_ICON_SIZE
		local animationSize = MARKER_ANIMATION_SIZE
		if markerProperties.iconSize then
			markerIconSize = markerProperties.iconSize
			animationSize = markerIconSize / MARKER_ICON_SIZE * MARKER_ANIMATION_SIZE
		end
		local iconSize = markerIconSize - math.sin(t * MARKER_ANIMATION_SPEED) * animationSize		

		local direction = marker:getData("dpMarkers.direction")
		local ox = math.cos(direction) * iconSize / 2
		local oy =  math.sin(direction) * iconSize / 2
		dxDrawMaterialLine3D(
			mx + ox,
			my + oy,
			mz,
			mx - ox,
			my - oy,
			mz,
			markerProperties.icon, 
			iconSize,
			tocolor(255, 255, 255, color[4]),
			mx,
			my,
			mz + 1
		)
	end

	local textSize = MARKER_TEXT_SIZE
	-- Вертикальная картинка
	local textAnimationOffset = math.sin(t * MARKER_ANIMATION_SPEED) * MARKER_TEXT_ANIMATION_SIZE
	dxDrawMaterialLine3D(
		mx, 
		my,
		mz + textSize / 2 + MARKER_TEXT_OFFSET.z + textAnimationOffset,
		mx,
		my,
		mz - textSize / 2 + MARKER_TEXT_OFFSET.z + textAnimationOffset,
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
		if markerProperties.icon then
			markerProperties.icon = dxCreateTexture(markerProperties.icon)
		end
		if markerProperties.text then
			markerProperties.text = dxCreateTexture(markerProperties.text)
		end
	end

	screenTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 22)
end)

addEventHandler("onClientKey", root, function (key, state)
	if key == markerKey and state then
		if isMTAWindowActive() then
			return false
		end
		if not isElement(currentMarker) then
			return
		end
		if localPlayer:getData("dpCore.state") or localPlayer:getData("activeUI") then
			return
		end	
		if localPlayer:isWithinMarker(currentMarker) or 
			(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(currentMarker))
		then
			triggerEvent("dpMarkers.use", currentMarker)
			cancelEvent()
		end		
	end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function (player)
	if player ~= localPlayer then
		return
	end
	if source == currentMarker then
		currentMarker = nil
	end
end)