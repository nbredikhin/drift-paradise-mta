local labelSize = 128
local screenSize = Vector2(guiGetScreenSize())

addEventHandler("onClientRender", root, function ()
	dxDrawImage(screenSize.x - labelSize, screenSize.y - labelSize, labelSize, labelSize, "assets/label.png")
end)