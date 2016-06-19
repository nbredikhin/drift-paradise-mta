local labelSize = 128
local screenSize = Vector2(guiGetScreenSize())
local texture

addEventHandler("onClientResourceStart", resourceRoot, function ()
	texture = dxCreateTexture("assets/label.png")
end)

addEventHandler("onClientRender", root, function ()
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end
	dxDrawImage(screenSize.x - labelSize, screenSize.y - labelSize, labelSize, labelSize, texture)
end)