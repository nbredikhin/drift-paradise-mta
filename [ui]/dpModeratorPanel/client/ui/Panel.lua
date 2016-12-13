Panel = {}
Panel.ui = {}
local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(650, 400)
-- Элементы интерфейса
local ui = {}

addEvent("dpModeratorPanel.opened", false)

function Panel.isVisible()
	return not not ui.window.visible
end

function Panel.getWindow()
	return ui.window
end

function Panel.toggle()
	if not localPlayer:getData("group") then
		return false
	end
	local visible = not ui.window.visible
	if ui.window.visible == visible then
		return 
	end
	ui.window.visible = visible
	showCursor(visible)

	if visible then
		triggerEvent("dpModeratorPanel.opened", resourceRoot)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.window = GuiWindow(
		(screenSize.x - windowSize.x) / 2, 
		(screenSize.y - windowSize.y) / 2,
		windowSize.x,
		windowSize.y, 
		"Drift Paradise Moderator Panel", 
		false)
	ui.window.sizable = false
	ui.window.movable = true
	ui.window.visible = false
end)

-- setTimer(Panel.toggle, 50, 1)
bindKey("f4", "down", Panel.toggle)