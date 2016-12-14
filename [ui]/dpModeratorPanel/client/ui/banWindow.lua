local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(240, 380)
-- Элементы интерфейса
local ui = {}
local currentCallback

local valueButtons = {
	{ text = "5 minutes", 	value = 60 * 5 },
	{ text = "10 minutes", 	value = 60 * 10 },
	{ text = "30 minutes", 	value = 60 * 30 },
	{ text = "2 hours", 	value = 60 * 60 },
	{ text = "1 day", 		value = 60 * 60 * 24 },
	{ text = "3 days", 		value = 60 * 60 * 24 * 3 },
	{ text = "7 days", 		value = 60 * 60 * 24 * 7 }
}

function Panel.showBanWindow(callback)
	if ui.window.visible then
		return false
	end
	if not callback then
		return false
	end
	ui.window.visible = true
	ui.window:bringToFront()
	if not defaultValue then
		defaultValue = 0
	end
	currentCallback = callback
end

function Panel.hideBanWindow()
	ui.window.visible = false
	currentCallback = nil
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.window = GuiWindow(
		(screenSize.x - windowSize.x) / 2, 
		(screenSize.y - windowSize.y) / 2,
		windowSize.x,
		windowSize.y, 
		"Ban player", 
		false)

	ui.window.sizable = false

	ui.reasonEdit = GuiEdit(0.05, 0.065, 0.9, 0.08, "Reason", true, ui.window)

	for i, valueButton in ipairs(valueButtons) do
		valueButton.button = GuiButton(0.05, 0.16 + 0.1 * (i - 1), 0.9, 0.08, valueButton.text, true, ui.window)
	end

	ui.cancelButton = GuiButton(0.2, 0.87, 0.6, 0.1, "Cancel", true, ui.window)

	ui.window.visible = false
	addEventHandler("onClientGUIClick", resourceRoot, function()	
		if not ui.window.visible then
			return false
		end			
		if source == ui.cancelButton then
			Panel.hideBanWindow()
			return
		end
		for i, b in ipairs(valueButtons) do
			if b.button == source then
				currentCallback(b.value, ui.reasonEdit.text)
				Panel.hideBanWindow()
				return
			end
		end
	end)

	--Panel.showBanWindow(function ()end)
end)