local ui = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("keys", "Gift keys")
end)