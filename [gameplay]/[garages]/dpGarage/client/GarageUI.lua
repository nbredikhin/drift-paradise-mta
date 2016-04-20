GarageUI = {}

local function draw()
	dxDrawText("Garage", 200, 200)
end

function GarageUI.start()
	exports.dpHUD:setVisible(false)

	addEventHandler("onClientRender", root, draw)
end

function GarageUI.stop()
	exports.dpHUD:setVisible(true)

	removeEventHandler("onClientRender", root, draw)
end