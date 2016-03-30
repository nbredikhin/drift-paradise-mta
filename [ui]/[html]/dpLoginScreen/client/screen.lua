addEventHandler("onClientResourceStart", resourceRoot, function ()
	exports.dpUI:addScreen("login", resource.name, resourceRoot)
	exports.dpUI:showScreen("login")
end)