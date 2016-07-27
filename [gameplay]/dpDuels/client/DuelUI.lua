-- Интерфейс дуэлей
DuelUI = {}
local UI = exports.dpUI
local screenSize = Vector2(guiGetScreenSize())

local isVisible = false
local targetPlayer
local betAmount = 0

local panelWidth = 350
local panelHeight = 100
-- Отступ от края экран
local panelIndent = 20
local ui = {}

-- Отобразить интерфейс
function DuelUI.show(player)
	if isVisible then
		return false
	end
	isVisible = true
	targetPlayer = player
	betAmount = 100
	UI:setVisible(ui.panel, true)

	UI:setText(ui.playerNameLabel, "Отправить вызов игроку " .. tostring(player.name))
end

-- Скрыть интерфейс дуэли
function DuelUI.hide()
	if not isVisible then
		return false
	end
	isVisible = false
	targetPlayer = nil
	betAmount = 0
	UI:setVisible(panel, false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panel = UI:createDpPanel({
		x = screenSize.x - panelWidth - panelIndent,
		y = panelIndent,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)
	ui.panel = panel

	ui.playerNameLabel = UI:createDpLabel({
		x = 10,
		y = 10,
		width = panelWidth - 20,
		wordBreak = false,
		clip = true,
		height = 20,
		alignX = "left",
		alignY = "top",
		text = "Отправить вызов игроку "
	})
	UI:addChild(panel, ui.playerNameLabel)

	UI:setVisible(panel, false)
end)