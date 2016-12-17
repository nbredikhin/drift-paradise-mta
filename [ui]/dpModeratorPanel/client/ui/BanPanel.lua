BanPanel = {}
local UI = exports.dpUI
local screenWidth, screenHeight = UI:getScreenSize()
local ui = {}

local panelWidth = 300
local panelHeight = 245

local isVisible = false
local targetPlayer

local selectedDuration = 1

local durationButtons = {
	{ text = "1 час", 	duration = 60 * 60 * 1},
	{ text = "3 часа", 	duration = 60 * 60 * 3 },
	{ text = "6 часов", duration = 60 * 60 * 6 },
	{ text = "1 день", 	duration = 60 * 60 * 24 },
	{ text = "3 дня", 	duration = 60 * 60 * 24 * 3 },
	{ text = "7 дней", 	duration = 60 * 60 * 24 * 7 }
}

local function redrawDurationButtons()
	for i, b in ipairs(durationButtons) do
		if i == selectedDuration then
			UI:setType(b.button, "primary")
		else
			UI:setType(b.button, "default_dark")
		end
	end
end

function BanPanel.show(player)
	if not isElement(player) then
		return 
	end
	if isVisible or localPlayer:getData("activeUI") then
		targetPlayer = player
		return
	end
	targetPlayer = player
	isVisible = true
	UI:setText(ui.infoLabel, "Ban player " .. exports.dpUtils:removeHexFromString(player.name))
	showCursor(true)
	UI:setVisible(ui.panel, true)

	selectedDuration = 1
	redrawDurationButtons()
	localPlayer:setData("activeUI", "moderatorPanel")
	exports.dpUI:fadeScreen(true)
end

function BanPanel.hide()
	if not isVisible then
		return false
	end
	isVisible = false
	targetPlayer = nil
	showCursor(false)
	UI:setVisible(ui.panel, false)
	localPlayer:setData("activeUI", false)
	exports.dpUI:fadeScreen(false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createDpPanel {
		x = (screenWidth - panelWidth) / 2,
		y = (screenHeight - panelHeight) / 2,
		width = panelWidth,
		height = panelHeight,
		type = "light"
	}
	UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)

	ui.infoLabel = UI:createDpLabel {
		x = 0 , y = 10,
		width = panelWidth, height = 50,
		text = "",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		alignX = "center"
	}
	UI:addChild(ui.panel, ui.infoLabel)

	-- Ввод причины
	ui.reasonInput = UI:createDpInput({
		x = 10,
		y = 45,
		width = panelWidth - 20,
		height = 50,
		type = "light",
		locale = "Введите причину..."
	})
	UI:addChild(ui.panel, ui.reasonInput)

	-- Выбор времени
	for i, b in ipairs(durationButtons) do
		local y = 105
		if i > 3 then
			y = 145
		end
		b.button = UI:createDpButton({
			x = 10 + ((i - 1) % 3) * (panelWidth - 20) / 3,
			y = y,
			width = (panelWidth - 20) / 3,
			height = 40,
			locale = b.text,
			type = "default_dark"
		})
		if i == 1 then
			UI:setType(b.button, "primary")
		end
		UI:addChild(ui.panel, b.button)
	end	

	-- Кнопка "Отмена"
	local buttonsHeight = 50
	ui.cancelButton = UI:createDpButton({
		x = 0,
		y = panelHeight - buttonsHeight,
		width = panelWidth / 2,
		height = buttonsHeight,
		locale = "Cancel",
		type = "default_dark"
	})
	UI:addChild(ui.panel, ui.cancelButton)

	ui.acceptButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - buttonsHeight,
		width = panelWidth / 2,
		height = buttonsHeight,
		locale = "Ban",
		type = "primary"
	})
	UI:addChild(ui.panel, ui.acceptButton)
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.acceptButton then		
		local button = durationButtons[selectedDuration]
		if not button then
			return
		end
		local duration = button.duration
		if not duration then
			return
		end
		local reason = UI:getText(ui.reasonInput)
		if not reason or reason == "" or reason == "" then
			exports.dpUI:showMessageBox("Error", "Введите причину бана")
			return
		end
		triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "ban", targetPlayer, duration, reason)
		BanPanel.hide()
	elseif widget == ui.cancelButton then
		BanPanel.hide()
		Panel.show()
	else
		for i, b in ipairs(durationButtons) do
			if widget == b.button then
				selectedDuration = i
				redrawDurationButtons()
			end
		end
	end
end)