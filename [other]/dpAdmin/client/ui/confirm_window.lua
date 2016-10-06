local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(240, 120)
local currentCallback
local ui = {}

function admin.ui.hideConfirmWindow()
	ui.window.visible = false
	currentCallback(false)
	currentCallback = nil
end

function admin.ui.showConfirmWindow(title, text, callback)
	if ui.window.visible then
		return false
	end
	ui.window.text = title
	ui.textLabel.text = text
	ui.window.visible = true
	ui.window:bringToFront()
	currentCallback = callback
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.window = GuiWindow(
		(screenSize.x - windowSize.x) / 2, 
		(screenSize.y - windowSize.y) / 2,
		windowSize.x,
		windowSize.y, 
		"", 
		false)

	ui.window.sizable = false

	ui.textLabel = GuiLabel(0.05, 0.2, 0.9, 0.15, "", true, ui.window)
	ui.cancelButton = GuiButton(0, 0.7, 0.45, 0.3, "No", true, ui.window)
	ui.acceptButton = GuiButton(0.5, 0.7, 0.45, 0.3, "Yes", true, ui.window)

	ui.window.visible = false
	addEventHandler("onClientGUIClick", resourceRoot, function()	
		if not ui.window.visible then
			return false
		end			
		if source == ui.acceptButton then
			if type(currentCallback) == "function" then
				currentCallback(true)
			end
			admin.ui.hideConfirmWindow()
		elseif source == ui.cancelButton then
			admin.ui.hideConfirmWindow()
		end
	end)
end)