local isVisible = false

local screenSize = Vector2(guiGetScreenSize())

local VERTICAL_LINE_OFFSET = 3
local BORDER_LINE_OFFSET = 20

local textBlockX = 0
local textBlockY = 0
local textBlockWidth = screenSize.x * 0.7
local textBlockHeight = 0
local textLines = {}

local messageFont
local messageFontHeight

local infoFont
local infoFontHeight
local infoText = ""
local infoIcon
local infoIconSize
local infoOffset = 5

local animationProgress = 0
local animationTarget = 0
local animationSpeed = 6

local isHiding = false

local function draw()
	-- Фон
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200 * animationProgress))
	-- Линии
	dxDrawLine(
		textBlockX, 
		textBlockY - BORDER_LINE_OFFSET, 
		textBlockX + textBlockWidth, 
		textBlockY - BORDER_LINE_OFFSET, 
		tocolor(255, 255, 255, 255 * animationProgress), 
		1, 
		true)
	dxDrawLine(
		textBlockX, 
		textBlockY + textBlockHeight + BORDER_LINE_OFFSET, 
		textBlockX + textBlockWidth, 
		textBlockY + textBlockHeight + BORDER_LINE_OFFSET, 
		tocolor(255, 255, 255, 255 * animationProgress), 
		1, 
		true)

	-- Заголовок
	local infoY = textBlockY - BORDER_LINE_OFFSET - infoOffset - infoFontHeight
	dxDrawImage(
		textBlockX,
		textBlockY - BORDER_LINE_OFFSET - infoOffset + infoIconSize / 4 - infoFontHeight,
		infoIconSize,
		infoIconSize,
		infoIcon,
		0, 0, 0,
		tocolor(255, 255, 255, 255 * animationProgress))

	dxDrawText(
		infoText,
		textBlockX + infoIconSize * 1.3, 
		infoY,
		textBlockX + textBlockWidth,
		infoY + infoFontHeight,
		tocolor(255, 255, 255, 255 * animationProgress),
		1,
		infoFont,
		"left",
		"center",
		false, true, true, true, false)

	-- Подсказка	
	dxDrawText(
		"BACKPACE - закрыть",
		textBlockX, 
		textBlockY + textBlockHeight + BORDER_LINE_OFFSET,
		textBlockX + textBlockWidth,
		textBlockY + textBlockHeight,
		tocolor(255, 255, 255, 255 * animationProgress),
		1,
		infoFont,
		"right",
		"top",
		false, true, true, true, false)

	-- Текст
	local y = textBlockY
	for i, line in ipairs(textLines) do
		dxDrawText(
			line,
			textBlockX, 
			y, 
			textBlockX + textBlockWidth, 
			y + messageFontHeight, 
			tocolor(255, 255, 255, 255 * animationProgress),
			1,
			messageFont,
			"left",
			"center", 
			false, true, true, true, false)
		y = y + messageFontHeight + VERTICAL_LINE_OFFSET
	end
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000
	animationProgress = animationProgress + (animationTarget - animationProgress) * deltaTime * animationSpeed
	if isHiding and animationProgress <= 0.01 then
		hideMessage()
	end
end

local function startHiding()
	if isHiding then
		return
	end
	exports.dpSounds:playSound("ui_back.wav")
	isHiding = true
	animationSpeed = 15
	animationTarget = 0
end

function showMessage(title, text, ...)
	if isVisible then
		return
	end
	isVisible = true

	infoText = tostring(title)
	infoIcon = dxCreateTexture("info_icon.png")

	messageFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 16)
	messageFontHeight = dxGetFontHeight(1, messageFont)

	infoFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 18)
	infoFontHeight = dxGetFontHeight(1, infoFont)
	infoIconSize = infoFontHeight * 0.7
	
	textLines = {}
	local formatArgs = {...}
	local themeColorHEX = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
	if not themeColorHEX then
		themeColorHEX = "#FFFFFF"
	end
	for i, v in ipairs(formatArgs) do
		formatArgs[i] = themeColorHEX .. tostring(formatArgs[i])  .. "#FFFFFF"
	end
	local words = split(string.format(tostring(text), unpack(formatArgs)), " ")
	local currentLine = ""
	while #words > 0 do
		local word = table.remove(words, 1)		

		if dxGetTextWidth(currentLine .. " " .. word, 1, messageFont, true) > textBlockWidth then
			table.insert(textLines, currentLine)
			currentLine = word
		else
			currentLine = currentLine .. " " .. word
		end
	end
	if #currentLine > 1 then
		table.insert(textLines, currentLine)
	end
	
	textBlockHeight = #textLines * (VERTICAL_LINE_OFFSET + messageFontHeight) - VERTICAL_LINE_OFFSET
	textBlockX = screenSize.x / 2 - textBlockWidth / 2
	textBlockY = screenSize.y / 4

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	animationProgress = 0
	animationTarget = 1

	isHiding = false
	bindKey("backspace", "down", startHiding)

	localPlayer:setData("activeUI", "tutorialMessage")
end

function hideMessage()
	if not isVisible then
		return
	end
	isVisible = false

	if isElement(messageFont) then
		destroyElement(messageFont)
	end
	if isElement(infoFont) then
		destroyElement(infoFont)
	end
	if isElement(infoIcon) then
		destroyElement(infoIcon)
	end

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
	unbindKey("backspace", "down", startHiding)

	localPlayer:setData("activeUI", false)
end

function isMessageVisible()
	return isVisible
end