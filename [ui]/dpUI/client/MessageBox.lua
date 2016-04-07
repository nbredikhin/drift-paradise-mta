MessageBox = {}
local FADE_SCREEN = true
local MAX_TRANSORM_ANGLE = 20 
local screenWidth, screenHeight = guiGetScreenSize()
local isActive = false
local headerText = ""
local messageText = ""
local width, height = 300, 150
local headerHeight = 40
local maskShader
local renderTarget
local font

local function draw()
	if not isActive then
		return
	end	
	local mouseX, mouseY = getMousePosition()
	local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
	local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE	

 	dxSetShaderTransform(maskShader, rotationX, rotationY, 0, 0, 0, 0.1)
	dxSetShaderValue(maskShader, "sPicTexture", renderTarget)

	if FADE_SCREEN then
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200))
	end
	dxDrawImage(
		(screenWidth - width) / 2, 
		(screenHeight - height) / 2, 
		width, 
		height,
		maskShader,
		0, 0, 0,
		tocolor(255, 255, 255, 240), 
		true
	)
end

local function drawButton(x, y, w, h, text)
	dxDrawRectangle(x, y, w, h, tocolor(213, 0, 40))
	dxDrawText(text, x, y, x+w, y+h, tocolor(255, 255, 255), 1, font, "center", "center")
end

function MessageBox.redraw()
	if not isActive then
		return
	end
	if not renderTarget then
		return
	end
	dxSetRenderTarget(renderTarget)
	dxDrawRectangle(0, 0, width, height, tocolor(40, 40, 40))
	dxDrawRectangle(0, 0, width, headerHeight, tocolor(30, 30, 30))
	dxDrawText(headerText, 10, 0, width, headerHeight, tocolor(255, 255, 255), 1, font, "left", "center")
	dxDrawText(messageText, 0, headerHeight, width, height - headerHeight, tocolor(255, 255, 255), 1, font, "center", "center")

	drawButton(width / 2, height - headerHeight, width / 2, headerHeight, "Закрыть")
	dxSetRenderTarget()
end

function MessageBox.start()
	maskShader = exports.dpAssets:createShader("texture3d.fx")
	renderTarget = dxCreateRenderTarget(width, height, false)
	font = dxCreateFont("html/screens/fonts/RobotoCondensed-Regular.ttf", 12)

	addEventHandler("onClientClick", root, function (button, state)
		-- govnokod
		local mouseX, mouseY = getMousePosition()
		if mouseX > (screenWidth - width) / 2 + width / 2 and mouseX < (screenWidth - width) / 2 + width and
			mouseY > (screenHeight - height) / 2 + height - headerHeight and mouseY < (screenHeight - height) / 2 + height 
		then
			if state == "down" then			
				MessageBox.hide()
			end
		end
	end)
end

function MessageBox.show(header, text)
	if 	not exports.dpUtils:argcheck(header, "string") or 
		not exports.dpUtils:argcheck(text, "string") 
	then
		return false
	end
	if isActive then
		-- TODO: Добавить окно в очередь окон
		return false
	end
	isActive = true
	headerText = header
	messageText = text
	MessageBox.redraw()
	addEventHandler("onClientRender", root, draw, true, "low-10")
	return true
end

function MessageBox.hide()
	if not isActive then
		return false
	end
	isActive = false
	-- TODO: Показать следующее окно из очереди
	removeEventHandler("onClientRender", root, draw)
	return true
end

function MessageBox.isActive()
	return isActive
end