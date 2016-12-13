local ui = {}
local selectedPlayer

local function updatePlayersFilter()
	ui.playersList:clear()
	for i, player in ipairs(getElementsByType("player")) do
		local playerName = exports.dpUtils:removeHexFromString(player.name)
		if string.find(string.lower(playerName), string.lower(ui.searchNameEdit.text)) then
			local rowIndex = ui.playersList:addRow(playerName)
			ui.playersList:setItemData(rowIndex, 1, player)
		end
	end
end

local function onOpened()
	updatePlayersFilter()
end

local function defaultField(element, field)
	if isElement(element) then
		return tostring(element[field]) 
	else
		return ""
	end
end

local function defaultData(element, data, filter)
	if not isElement(element) then
		return "" 
	end
	local value = element:getData(data)
	if type(filter) == "function" then
		return tostring(filter(value))
	end
	if not value then
		return ""
	end		
	return tostring(value)
end

addEvent("dpAdmin.requirePlayerVehiclesList", true)
addEventHandler("dpAdmin.requirePlayerVehiclesList", resourceRoot, function (vehiclesList)
	if type(vehiclesList) ~= "table" then
		return false
	end
	ui.player.vehiclesList:clear()
	for i, vehicle in ipairs(vehiclesList) do
		local name = exports.dpShared:getVehicleReadableName(vehicle.model)
		ui.player.vehiclesList:addRow(vehicle._id, name)
	end
end)

local function updateSelectedPlayer()
	local selectedItems = ui.playersList:getSelectedItems()
	selectedPlayer = nil
	local player
	if selectedItems and #selectedItems > 0 then		
		player = ui.playersList:getItemData(selectedItems[1].row, 1)
		selectedPlayer = player
	end

	ui.player.nickname.text   = "Player: " .. defaultField(player, "name")
	ui.player.state.text      = "Location: " .. defaultData(player, "dpCore.state", 
		function (state)
			if type(state) ~= "string" then
				return "city"
			else
				return state
			end
		end)

	ui.player.account.text    = "Account name: "    .. defaultData(player, "username")
	ui.player.group.text      = "Account type: "    .. defaultData(player, "group", 
		function (group)
			if not group then
				return "player"
			else
				return group
			end
		end)
	ui.player.registered.text = "Registered: "      .. defaultData(player, "register_time")

	ui.player.level.text    = "Level: "        .. defaultData(player, "level")
	ui.player.money.text    = "Money: $"       .. defaultData(player, "money")
	ui.player.playtime.text = "Hours played: " .. defaultData(player, "playtime", 
		function (v) 
			if not v then return 0 end
			return math.floor(tonumber(v) / 60) 
		end)


	if isElement(player) and not player:getData("group") then
		ui.player.kick.enabled = true
		ui.player.mute.enabled = true
		ui.player.ban.enabled = true
		ui.player.removeCar.enabled = true
	else
		ui.player.kick.enabled = false
		ui.player.mute.enabled = false
		ui.player.ban.enabled = false
		ui.player.removeCar.enabled = false
	end
			ui.player.kick.enabled = true
		ui.player.mute.enabled = true
		ui.player.ban.enabled = true
		ui.player.removeCar.enabled = true
end

local function handleDataChange()
	if source == selectedPlayer then
		updateSelectedPlayer()
	end
end

local function getSelectedVehicleId()
	local selectedItems = ui.player.vehiclesList:getSelectedItems()
	local vehicleId = nil		
	if selectedItems and #selectedItems > 0 then		
		vehicleId = ui.player.vehiclesList:getItemText(selectedItems[1].row, 1)
	end	
	return vehicleId
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = Panel.getWindow()

	local playersListWidth = 0.3
	ui.playersList = GuiGridList(0.01, 0.12, playersListWidth, 0.91, true, ui.panel)
	ui.playersList:setSelectionMode(0)
	ui.playersList:addColumn("Name", 1)
	ui.searchNameEdit = GuiEdit(0.01, 0.06, playersListWidth, 0.05, "", true, ui.panel)

	ui.player = {}
	local x = playersListWidth + 0.03
	local y = 0.12
	local width = 0.45
	local height = 0.04
	ui.player.nickname = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height
	ui.player.state = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height * 2

	ui.player.account = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height
	ui.player.group = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height	
	ui.player.registered = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height * 2

	ui.player.level = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height
	ui.player.money = GuiLabel(x, y, width, height, "", true, ui.panel)
	y = y + height
	ui.player.playtime = GuiLabel(x, y, width, height, "", true, ui.panel)

	local buttonWidth = 0.31
	local buttonHeight = 0.09
	local buttonsX = x
	
	y = 0.75
	ui.player.mute = GuiButton(x, y, buttonWidth, buttonHeight, "Mute", true, ui.panel)
	x = x + buttonWidth * 1.1
	ui.player.kick = GuiButton(x, y, buttonWidth, buttonHeight, "Kick", true, ui.panel)
	x = buttonsX
	y = y + buttonHeight * 1.4
	ui.player.ban = GuiButton(x, y, buttonWidth, buttonHeight, "Ban", true, ui.panel)	
	x = x + buttonWidth * 1.1
	ui.player.removeCar = GuiButton(x, y, buttonWidth, buttonHeight, "Destroy car", true, ui.panel)

	updateSelectedPlayer()
	addEventHandler("dpModeratorPanel.opened", resourceRoot, onOpened)

	addEventHandler("onClientGUIChanged", ui.searchNameEdit, updatePlayersFilter, false)
	addEventHandler("onClientGUIClick", ui.playersList, updateSelectedPlayer, false)

	addEventHandler("onClientElementDataChange", root, handleDataChange)
	addEventHandler("onClientGUIClick", ui.player.mute, function ()
		if not selectedPlayer then
			return
		end
		local name = exports.dpUtils:removeHexFromString(selectedPlayer.name)
		Panel.showTimeSelectWindow(function (duration)
			triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "mute", selectedPlayer, duration)
		end)
	end, false)

	addEventHandler("onClientGUIClick", ui.player.ban, function ()
		if not selectedPlayer then
			return
		end
		local name = exports.dpUtils:removeHexFromString(selectedPlayer.name)
		Panel.showTimeSelectWindow(function (duration)
			triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "ban", selectedPlayer, duration)
		end)
	end, false)


	addEventHandler("onClientGUIClick", ui.player.kick, function ()
		if not selectedPlayer then
			return
		end
		local name = exports.dpUtils:removeHexFromString(selectedPlayer.name)
		triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "kick", selectedPlayer)
	end, false)	

	addEventHandler("onClientGUIClick", ui.player.kick, function ()
		if not selectedPlayer then
			return
		end
		local name = exports.dpUtils:removeHexFromString(selectedPlayer.name)
		triggerServerEvent("dpAdmin.executeCommand", resourceRoot, "destroyCar", selectedPlayer)
	end, false)		
end)
