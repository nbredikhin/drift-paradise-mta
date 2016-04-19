TuningUI = {}

local function draw()
	dxDrawText("tuning", 200, 200)
end

function TuningUI.start()
	exports.dpHUD:setVisible(false)

	addEventHandler("onClientRender", root, draw)
end

function TuningUI.stop()
	exports.dpHUD:setVisible(true)

	removeEventHandler("onClientRender", root, draw)
end