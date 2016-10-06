local UI = exports.dpUI
local screenSize = Vector2(UI:getScreenSize())
local ui = {}
local panelWidth = 400
local panelHeight = 250
local BUTTON_HEIGHT = 50

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createDpPanel {
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 1.7,
		width = panelWidth,
		height = panelHeight,
		type = "transparent"
	}
	UI:addChild(ui.panel)

	-- Кнопка "Отмена"
	ui.cancelButton = UI:createDpButton({
		x = 0,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "gift_key_panel_back",
		type = "default_dark"
	})
	UI:addChild(ui.panel, ui.cancelButton)

	ui.activateButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "gift_key_panel_activate",
		type = "primary"
	})
	UI:addChild(ui.panel, ui.activateButton)

	local labelOffset = 0.45
	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = 0,
		width = panelWidth, height = panelHeight * labelOffset,
		type = "dark",
		fontType = "defaultLarge",
		locale = "gift_key_main_label",
		alignX = "center",
		alignY = "center"
	})
	UI:addChild(ui.panel, ui.mainLabel)

	ui.keyInput = UI:createDpInput({
		x = 50,
		y = panelHeight * 0.4,
		width = panelWidth - 100,
		height = 50,
		type = "light",
		locale = "gift_key_input_placeholder",
		forceRegister = "upper",
		regexp = "[a-zA-Z0-9]",
	})
	UI:addChild(ui.panel, ui.keyInput)

	UI:setVisible(ui.panel, false)

	if localPlayer:getData("activeUI") == "giftsPanel" then
		localPlayer:setData("activeUI", false)
		setVisible(false)
	end
end)

function setVisible(visible)
	UI = exports.dpUI
	local isVisible = UI:getVisible(ui.panel)
	if not not isVisible == not not visible then
		return false
	end 
	if visible then
		if localPlayer:getData("activeUI") then
			return false
		end
		localPlayer:setData("activeUI", "giftsPanel")
	else
		localPlayer:setData("activeUI", false)
	end

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.dpHUD:setVisible(not visible)
	exports.dpUI:fadeScreen(visible)
end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.activateButton then
		triggerServerEvent("dpCore.requireKeyActivation", resourceRoot, UI:getText(ui.keyInput))
	elseif widget == ui.cancelButton then
		setVisible(false)
		exports.dpMainPanel:setVisible(true)
	end
end)

addEvent("dpCore.keyActivation", true)
addEventHandler("dpCore.keyActivation", root, function (success, info)
	if success then
		UI:showMessageBox(
			exports.dpLang:getString("gift_key_message_title"), 
			exports.dpLang:getString("gift_key_message_success"))
		setVisible(false)
	else
		UI:showMessageBox(
			exports.dpLang:getString("gift_key_message_title"), 
			exports.dpLang:getString("gift_key_message_fail"))
	end
end)