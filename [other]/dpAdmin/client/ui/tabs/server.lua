local ui = {}

local function onTabOpened()
    ui.playersCountLabel.text = "Players online: " .. tostring(#getElementsByType("player"))
    ui.fpsLimitLabel.text = "FPS limit: " .. tostring(getFPSLimit())
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("server", "Server")

    ui.playersCountLabel = GuiLabel(0.05, 0.05, 0.5, 0.05, "", true, ui.panel)
    ui.fpsLimitLabel = GuiLabel(0.05, 0.1, 0.5, 0.05, "", true, ui.panel)
    addEventHandler("onClientGUITabSwitched", ui.panel, onTabOpened, false)
    addEventHandler("dpAdmin.panelOpened", resourceRoot, onTabOpened)
end)