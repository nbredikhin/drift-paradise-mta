Panel = {}
local UI = exports.dpUI
local screenWidth, screenHeight = UI:getScreenSize()
local ui = {}

local panelWidth = 500
local panelHeight = 365

local isVisible = false

local playersList = {}
local playersListOffset = 0
local playersShowCount = 7
local selectedPlayer

function Panel.show()
	if isVisible or localPlayer:getData("activeUI") then
		return false
	end
	isVisible = true

	UI:setVisible(ui.panel, true)
	showCursor(true)

	UI:setText(ui.playerSearchInput, "")
	Panel.filterPlayersList()

	Panel.hidePlayerInfo()
	localPlayer:setData("activeUI", "moderatorPanel")
	exports.dpUI:fadeScreen(true)
end

function Panel.filterPlayersList()
	local searchText = utf8.lower(UI:getText(ui.playerSearchInput))
	playersList = {}
	for i, player in ipairs(getElementsByType("player")) do
		if string.find(utf8.lower(player.name), searchText, 1, true) then
			table.insert(playersList, player)
		end
	end
	Panel.redrawPlayersList()
end

function Panel.redrawPlayersList()
	local showPlayers = {}
	local indexStart = math.max(1, playersListOffset + 1)
	local indexEnd = math.min(#playersList, playersListOffset + playersShowCount)
	for i = indexStart, indexEnd do
		local item = { 
			[1] = exports.dpUtils:removeHexFromString(playersList[i].name),
			player = playersList[i]
		}
		table.insert(showPlayers, item)
	end
	UI:setItems(ui.playersList, showPlayers)
end

function Panel.hide()
	if not isVisible then
		return false
	end
	isVisible = false

	UI:setVisible(ui.panel, false)
	showCursor(false)
	localPlayer:setData("activeUI", false)
	exports.dpUI:fadeScreen(false)
end

function Panel.showPlayerInfo(player)
	if not isElement(player) then
		Panel.filterPlayersList()
		return false
	end
	UI:setVisible(ui.playerPanel, true)

	UI:setText(ui.nicknameLabel, exports.dpUtils:removeHexFromString(player.name))
	UI:setText(ui.usernameLabel, "Login: " .. tostring(player:getData("username")))

	UI:setText(ui.moneyLabel, 			exports.dpLang:getString("player_money") .. ": $" .. tostring(player:getData("money")))
	UI:setText(ui.levelLabel, 			exports.dpLang:getString("player_level") .. ": " .. tostring(player:getData("level")))
	UI:setText(ui.carsCountLabel,  	    exports.dpLang:getString("main_panel_account_cars_count") ..": " .. tostring(player:getData("garage_cars_count")))

	local state = player:getData("dpCore.state")
	if not state then
		state = "city"
	end
	UI:setText(ui.locationLabel, 		"Location: " .. tostring(state))

	if player:getData("isMuted") then
		UI:setText(ui.muteButton, "Unmute")
	else
		UI:setText(ui.muteButton, "Mute")
	end

	selectedPlayer = player
end

function Panel.hidePlayerInfo()
	UI:setVisible(ui.playerPanel, false)

	selectedPlayer = nil
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

	-- Список игроков
	local playerSearchInputHeight = 50
	local playerListWidth = 200
	ui.playerSearchInput = UI:createDpInput({
		x = 0,
		y = 0,
		width = playerListWidth,
		height = 50,
		type = "light",
		locale = "Search..."
	})
	UI:addChild(ui.panel, ui.playerSearchInput)	
	ui.playersList = UI:createDpList {
		x = 0, y = playerSearchInputHeight,
		width = playerListWidth, height = panelHeight,
		items = {},
		columns = {
			{size = 1, offset = 0.06, align = "left"}
		}
	}
	UI:addChild(ui.panel, ui.playersList)

	-- Панель с информацией об игроке
	local playerPanelWidth = panelWidth - playerListWidth
	local playerPanelHeight = panelHeight

	local notSelectedLabel = UI:createDpLabel {
		x = playerListWidth, y = 0,
		width = playerPanelWidth, height = playerPanelHeight,
		locale = "Player not selected",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultLarge",
		alignX = "center",
		alignY = "center"
	}	
	UI:addChild(ui.panel, notSelectedLabel)

	ui.playerPanel = UI:createDpPanel {
		x = playerListWidth, y = 0,
		width = playerPanelWidth,
		height = playerPanelHeight,
		type = "light"
	}
	UI:addChild(ui.panel, ui.playerPanel)

	ui.nicknameLabel = UI:createDpLabel {
		x = 20, y = 15,
		width = playerPanelWidth / 3, playerPanelHeight = 50,
		text = "...",
		type = "primary",
		fontType = "defaultLarger"
	}	
	UI:addChild(ui.playerPanel, ui.nicknameLabel)

	ui.usernameLabel = UI:createDpLabel {
		x = 20 , y = 60,
		width = playerPanelWidth, height = 50,
		text = "...",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall"
	}
	UI:addChild(ui.playerPanel, ui.usernameLabel)

	-- Деньги
	ui.moneyLabel = UI:createDpLabel {
		x = 20, y = 100,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(ui.playerPanel, ui.moneyLabel)

	ui.levelLabel = UI:createDpLabel {
		x = 20, y = 130,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(ui.playerPanel, ui.levelLabel)	

	ui.carsCountLabel = UI:createDpLabel {
		x = 20, y = 160,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(ui.playerPanel, ui.carsCountLabel)

	ui.locationLabel = UI:createDpLabel {
		x = 20, y = 190,
		width = playerPanelWidth, height = 50,
		text = "Местоположение: -",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(ui.playerPanel, ui.locationLabel)			

	-- 
	local buttonsHeight = 45
	ui.muteButton = UI:createDpButton {
		x = 0,
		y = playerPanelHeight - buttonsHeight,
		width = playerPanelWidth / 3,
		height = buttonsHeight,
		text = "",
		type = "primary"
	}
	UI:addChild(ui.playerPanel, ui.muteButton)

	ui.kickButton = UI:createDpButton {
		x = playerPanelWidth / 3,
		y = playerPanelHeight - buttonsHeight,
		width = playerPanelWidth / 3,
		height = buttonsHeight,
		text = "Kick",
		type = "primary"
	}
	UI:addChild(ui.playerPanel, ui.kickButton)

	ui.banButton = UI:createDpButton {
		x = playerPanelWidth / 3 * 2,
		y = playerPanelHeight - buttonsHeight,
		width = playerPanelWidth / 3,
		height = buttonsHeight,
		text = "Ban",
		type = "primary"
	}
	UI:addChild(ui.playerPanel, ui.banButton)		
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.playersList then
		local items = exports.dpUI:getItems(ui.playersList)
		local selectedItem = exports.dpUI:getActiveItem(ui.playersList)
		Panel.showPlayerInfo(items[selectedItem].player)
	elseif widget == ui.muteButton then
		Panel.hide()
		if selectedPlayer:getData("isMuted") then
			triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "unmute", selectedPlayer)
		else
			MutePanel.show(selectedPlayer)
		end
	elseif widget == ui.banButton then
		Panel.hide()
		BanPanel.show(selectedPlayer)
	elseif widget == ui.kickButton then		
		triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "kick", selectedPlayer)
		Panel.hidePlayerInfo()
	end
end)

addEvent("dpUI.inputChange", false)
addEventHandler("dpUI.inputChange", resourceRoot, function (widget)
	if widget == ui.playerSearchInput then
		Panel.filterPlayersList()
	end
end)

addEventHandler("onClientKey", root, function (button, down)
	if not down or not isVisible then
		return
	end
	if button == "mouse_wheel_up" then
		playersListOffset = playersListOffset - 1
		if playersListOffset < 0 then
			playersListOffset = 0
		end
		Panel.redrawPlayersList()
	elseif button == "mouse_wheel_down" then
		playersListOffset = playersListOffset + 1

		local count = math.min(#playersList, playersShowCount)
		if playersListOffset > #playersList - count then
			playersListOffset = #playersList - count
		end
		Panel.redrawPlayersList()
	end
end)

bindKey("F4", "down", function ()
	if not localPlayer:getData("group") then
		Panel.hide()
		return
	end
	if not isVisible then
		Panel.show()
	else
		Panel.hide()
	end
end)