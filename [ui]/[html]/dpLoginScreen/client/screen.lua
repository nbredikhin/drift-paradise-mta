addEventHandler("onClientResourceStart", resourceRoot, function ()
	exports.dpUI:addScreen("login", resourceRoot)
	exports.dpUI:showScreen("login")
end)