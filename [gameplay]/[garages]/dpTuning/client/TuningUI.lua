TuningUI = {}

local function draw()
	dxDrawText("tuning", 200, 200)
end

function TuningUI.start()
	if exports.dpUtils:isResourceRunning("dpHUD") then
		exports.dpHUD:setVisible(false)
	end

	addEventHandler("onClientRender", root, draw)
end

function TuningUI.stop()
	if exports.dpUtils:isResourceRunning("dpHUD") then
		exports.dpHUD:setVisible(true)
	end

	removeEventHandler("onClientRender", root, draw)
end