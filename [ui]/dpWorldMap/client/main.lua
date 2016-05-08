local isVisible = false

function setVisible(visible)
	visible = not not visible
	if isVisible == visible then
		return
	end
	isVisible = visible
	fadeCamera(false, 0.5)
	setTimer(function ()
		exports.dpHUD:setVisible(not visible)
		
		if visible then
			Map.start()
			addEventHandler("onClientRender", root, Map.draw)
			addEventHandler("onClientPreRender", root, Map.update)
		else
			removeEventHandler("onClientRender", root, Map.draw)
			removeEventHandler("onClientPreRender", root, Map.update)
			Map.stop()
			setCameraTarget(localPlayer)
		end
		fadeCamera(true, 0.5)
	end, 600, 1)
	return true
end

bindKey("m", "down", function() setVisible(not isVisible) end)