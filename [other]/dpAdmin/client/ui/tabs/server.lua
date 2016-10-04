local ui = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("server", "Server")
end)