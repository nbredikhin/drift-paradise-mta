local isVisible = false

function setVisible(visible)
	visible = not not visible
	if isVisible == visible then
		return
	end
	if visible and localPlayer:getData("dpCore.state") then
		return
	end	
	if visible and localPlayer:getData("activeUI") then
		return
	end
	if exports.dpMainPanel:isVisible() or exports.dpTabPanel:isVisible() then
		return
	end	
	isVisible = visible
	if visible then
		localPlayer:setData("dpCore.state", "map")
	end
	fadeCamera(false, 0.25)
	setTimer(function ()
		exports.dpHUD:setVisible(not visible)
		exports.dpNametags:setVisible(not visible)
		
		if visible then
			Map.start()
			addEventHandler("onClientRender", root, Map.draw)
			addEventHandler("onClientPreRender", root, Map.update)
		else
			removeEventHandler("onClientRender", root, Map.draw)
			removeEventHandler("onClientPreRender", root, Map.update)
			Map.stop()
			setCameraTarget(localPlayer)
			localPlayer:setData("dpCore.state", false)
		end
		fadeCamera(true, 0.25)
	end, 260, 1)
	return true
end

bindKey("backspace", "down", function() setVisible(false) end)
bindKey("m", "down", function() setVisible(not isVisible) end)
bindKey("f11", "down", function() 
	setVisible(not isVisible) 
end)

if localPlayer:getData("dpCore.state") == "map" then
	localPlayer:setData("dpCore.state", false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	toggleControl("radar", false)
end)

setTimer(toggleControl, 1000, 0, "radar", false)