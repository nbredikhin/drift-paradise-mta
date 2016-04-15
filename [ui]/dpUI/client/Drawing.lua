Drawing = {}
local POST_GUI = true
local DEFAULT_COLOR = tocolor(255, 255, 255)
local DEFAULT_FONT = "default"

local drawColor = DEFAULT_COLOR
local drawFont = DEFAULT_FONT
local drawX = 0
local drawY = 0

function Drawing.getGlobalPosition(x, y)
	return x + drawX, y + drawY
end

function Drawing.origin()
	drawX = 0
	drawY = 0
end

function Drawing.translate(x, y)
	drawX = drawX + x
	drawY = drawY + y
end

function Drawing.setColor(color)
	drawColor = color or DEFAULT_COLOR
end

function Drawing.setFont(font)
	drawFont = font or DEFAULT_FONT
end

function Drawing.rectangle(x, y, width, height)
	x = x + drawX
	y = y + drawY
	dxDrawRectangle(x, y, width, height, drawColor, POST_GUI, false)
end

function Drawing.line(x1, y1, x2, y2, width)
	x = x + drawX
	y = y + drawY	
	dxDrawLine(x1, y1, x2, y2, drawColor, width, POST_GUI)
end

function Drawing.text(x, y, width, height, text, alignX, alignY, clip, wordBreak, colorCoded)
	x = x + drawX
	y = y + drawY
	dxDrawText(text, x, y, x + width, y + height, drawColor, 1, drawFont, alignX, alignY, clip, wordBreak, POST_GUI, false, colorCoded)
end

function Drawing.image(x, y, width, height, image)
	x = x + drawX
	y = y + drawY
	dxDrawImage(x, y, width, height, image, 0, 0, 0, drawColor, POST_GUI)
end