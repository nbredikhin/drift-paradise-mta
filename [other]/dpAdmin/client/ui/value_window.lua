local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(240, 120)
local currentCallback
local justShown = false
local ui = {}

function admin.ui.hideValueWindow()
	ui.window.visible = false
	currentCallback = nil
end

function admin.ui.showValueWindow(title, text, defaultValue, callback)
	if ui.window.visible then
		return false
	end
	ui.window.text = title
	ui.textLabel.text = text
	ui.window.visible = true
	ui.window:bringToFront()
	if not defaultValue then
		defaultValue = 0
	end
	ui.valueEdit.text = tostring(defaultValue)
	currentCallback = callback
end

local function acceptValue()
	if not ui.window.visible then
		return false
	end	
	if type(currentCallback) == "function" then
		currentCallback(tonumber(ui.valueEdit.text))
	end
	admin.ui.hideValueWindow()
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
	ui.valueEdit = GuiEdit(0.05, 0.4, 0.9, 0.2, "", true, ui.window)
	ui.cancelButton = GuiButton(0, 0.7, 0.45, 0.3, "Cancel", true, ui.window)
	ui.acceptButton = GuiButton(0.5, 0.7, 0.45, 0.3, "Accept", true, ui.window)

	ui.window.visible = false
	addEventHandler("onClientGUIClick", resourceRoot, function()	
		if not ui.window.visible then
			return false
		end			
		if source == ui.acceptButton then
			acceptValue()
		elseif source == ui.cancelButton then
			admin.ui.hideValueWindow()
		elseif source ~= ui.valueEdit then
			ui.window:bringToFront()
		end
	end)

	addEventHandler("onClientGUIAccepted", ui.valueEdit, acceptValue)
end)