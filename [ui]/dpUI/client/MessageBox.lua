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
local animationProgress = 0
local ANIMATION_SPEED = 0.03

local function draw()
	if not isActive then
		return
	end	
	animationProgress = math.min(1, animationProgress + ANIMATION_SPEED)
	if FADE_SCREEN then
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200 * animationProgress))
	end
	if maskShader then
		local mouseX, mouseY = getMousePosition()
		local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
		local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE	

	 	dxSetShaderTransform(maskShader, rotationX, rotationY, 0, 0, 0, 0.1)
		dxSetShaderValue(maskShader, "sPicTexture", renderTarget)		
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
	elseif renderTarget then
		dxDrawImage(
			(screenWidth - width) / 2, 
			(screenHeight - height) / 2, 
			width, 
			height,
			renderTarget,
			0, 0, 0,
			tocolor(255, 255, 255, 240), 
			true
		)		
	else
		MessageBox.redraw()
	end
end

local function drawButton(x, y, w, h, text)
	dxDrawRectangle(x, y, w, h, Colors.color("primary"), Drawing.POST_GUI)
	dxDrawText(text, x, y, x+w, y+h, tocolor(255, 255, 255), 1, font, "center", "center", true, false, Drawing.POST_GUI)
end

function MessageBox.redraw()
	if not isActive then
		return
	end
	dxSetRenderTarget(renderTarget)
	dxDrawRectangle(0, 0, width, height, tocolor(40, 40, 40), Drawing.POST_GUI, false)
	dxDrawRectangle(0, 0, width, headerHeight, tocolor(30, 30, 30), Drawing.POST_GUI)
	dxDrawText(headerText, 10, 0, width, headerHeight, tocolor(255, 255, 255), 1, font, "left", "center", true, false, Drawing.POST_GUI)
	dxDrawText(messageText, 0, headerHeight, width, height - headerHeight, tocolor(255, 255, 255), 1, font, "center", "center", true, true, Drawing.POST_GUI)

	drawButton(width / 2, height - headerHeight, width / 2, headerHeight, exports.dpLang:getString("message_box_close"))
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
	if type(header) ~= "string" or type(text) ~= "string" then
		return false
	end
	if isActive then
		-- TODO: Добавить окно в очередь окон
		return false
	end
	isActive = true
	headerText = header
	messageText = text
	animationProgress = 0
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

addEventHandler("onClientKey", root, function (key, state)
	if key == "enter" and state then
		MessageBox.hide()
	end
end)