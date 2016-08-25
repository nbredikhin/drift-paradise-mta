QuitPrompt = {}
local screenSize = Vector2(guiGetScreenSize())
local BUTTON_HEIGHT = 50
local UI = exports.dpUI
local ui = {}

local panelWidth, panelHeight = 350, 150

function QuitPrompt.isVisible()
	return not not UI:getVisible(ui.panel)
end

function QuitPrompt.show()
	if QuitPrompt.isVisible() then
		return false
	end 
	showCursor(true)
	exports.dpUI:fadeScreen(true)
	UI:setVisible(ui.panel, true)
	return true
end

function QuitPrompt.hide()
	if not QuitPrompt.isVisible() then
		return false
	end 
	showCursor(false)
	exports.dpUI:fadeScreen(false)
	UI:setVisible(ui.panel, false)
	return true	
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createDpPanel {
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 1.7,
		width = panelWidth,
		height = panelHeight,
		type = "dark"
	}
	UI:addChild(ui.panel)

	ui.cancelButton = UI:createDpButton({
		x = 0,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "Отмена",
		type = "default_dark"
	})
	UI:addChild(ui.panel, ui.cancelButton)

	ui.acceptButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "Покинуть",
		type = "primary"
	})
	UI:addChild(ui.panel, ui.acceptButton)	

	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = 0,
		width = panelWidth, height = panelHeight - BUTTON_HEIGHT,
		type = "light",
		fontType = "defaultSmall",
		text = "Вы уверены, что хотите покинуть гонку?",
		wordBreak = true,
		alignX = "center",
		alignY = "center"
	})
	UI:addChild(ui.panel, ui.mainLabel)	

	UI:setVisible(ui.panel, false)
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.cancelButton then
		QuitPrompt.hide()
	elseif widget == ui.acceptButton then
		QuitPrompt.hide()
		triggerServerEvent("leaveRace", resourceRoot)
	end
end)