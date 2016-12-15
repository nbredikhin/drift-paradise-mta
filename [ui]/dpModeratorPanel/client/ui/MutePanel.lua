MutePanel = {}
local UI = exports.dpUI
local screenWidth, screenHeight = UI:getScreenSize()
local ui = {}

local panelWidth = 300
local panelHeight = 155

local isVisible = false
local targetPlayer

local selectedDuration = 1

local durationButtons = {
	{ text = "5 мин", 	duration = 60 * 5 },
	{ text = "30 мин", 	duration = 60 * 30 },
	{ text = "1 час", 	duration = 60 * 60 }
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

function MutePanel.show(player)
	if not isElement(player) then
		return 
	end
	if isVisible then
		targetPlayer = player
		return
	end
	targetPlayer = player
	isVisible = true
	UI:setText(ui.infoLabel, "Mute player " .. exports.dpUtils:removeHexFromString(player.name))
	showCursor(true)
	UI:setVisible(ui.panel, true)

	selectedDuration = 1
	redrawDurationButtons()
end

function MutePanel.hide()
	if not isVisible then
		return false
	end
	isVisible = false
	targetPlayer = nil
	showCursor(false)
	UI:setVisible(ui.panel, false)
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

	-- Выбор времени
	for i, b in ipairs(durationButtons) do
		b.button = UI:createDpButton({
			x = 10 + (i - 1) * (panelWidth - 20) / 3,
			y = 50,
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
		locale = "Mute",
		type = "primary"
	})
	UI:addChild(ui.panel, ui.acceptButton)
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.acceptButton then
		MutePanel.hide()
		outputDebugString(tostring(selectedDuration))
	elseif widget == ui.cancelButton then
		MutePanel.hide()
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