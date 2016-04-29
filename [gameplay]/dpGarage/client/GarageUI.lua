GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local shadowTexture

local function draw()
	dxDrawImage(0, 0, screenWidth, screenHeight, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))
	ScreenManager.draw()
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000
	ScreenManager.update(deltaTime)
end

function GarageUI.start()
	shadowTexture = exports.dpAssets:createTexture("screen_shadow.png")
	ScreenManager.show(CarSelectScreen:new())
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
end

function GarageUI.stop()
	ScreenManager.hide()
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
	if isElement(shadowTexture) then
		destroyElement(shadowTexture)
	end	
end