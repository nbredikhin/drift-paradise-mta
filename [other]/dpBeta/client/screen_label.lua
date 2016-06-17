local labelSize = 128
local screenSize = Vector2(guiGetScreenSize())

addEventHandler("onClientRender", root, function ()
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end
	dxDrawImage(screenSize.x - labelSize, screenSize.y - labelSize, labelSize, labelSize, "assets/label.png")
end)