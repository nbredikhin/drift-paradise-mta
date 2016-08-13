MapsScreen = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.dpUI
local ui = {}

local panelWidth = 650
local panelHeight = 550

-- Высота кнопки вкладки
local TAB_BUTTON_HEIGHT = 50
local tabsList = {
	{ name = "classic", locale = "race_lobby_mode_classic" },
	{ name = "drift", locale = "race_lobby_mode_drift" },
	{ name = "drag", locale = "race_lobby_mode_drag" },
}
local activeTab

-- Кнопки снизу
local BOTTOM_BUTTON_WIDTH = panelWidth / 2
local BOTTOM_BUTTON_HEIGHT = 60

local MAP_ITEM_INDENT = 5 
local MAP_SELECTED_IMAGE_COLOR = tocolor(255, 255, 255)
local MAP_UNSELECTED_IMAGE_COLOR = tocolor(255, 255, 255, 200)
local MAP_UNSELECTED_LABEL_COLOR = tocolor(0, 0, 0, 100)
local selectedMapsCount = 0

function MapsScreen.setVisible(visible)
	local isVisible = UI:getVisible(ui.panel)
	if not not isVisible == not not visible then
		return false
	end 
	if exports.dpTabPanel:isVisible() then
		return false
	end
	if visible then
		if not localPlayer:getData("username") or localPlayer:getData("dpCore.state") then
			return false
		end
		if localPlayer:getData("activeUI") then
			return false
		end
		localPlayer:setData("activeUI", "raceLobby")
	else
		localPlayer:setData("activeUI", false)
	end

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.dpHUD:setVisible(not visible)
	exports.dpUI:fadeScreen(visible)

	selectedMapsCount = 0
	MapsScreen.openTab(1)	
	return true
end

local function toggleMapItem(map)
	UI:setState(map.checkbox, not UI:getState(map.checkbox))
	
	local labelColor = tocolor(exports.dpUI:getThemeColor())
	if not UI:getState(map.checkbox) then
		labelColor = MAP_UNSELECTED_LABEL_COLOR
		selectedMapsCount = selectedMapsCount - 1
	end
	UI:setColor(map.label, labelColor)

	local imageColor = MAP_UNSELECTED_IMAGE_COLOR
	if UI:getState(map.checkbox) then
		imageColor = MAP_SELECTED_IMAGE_COLOR
		selectedMapsCount = selectedMapsCount + 1
	end
	UI:setColor(map.image, imageColor)

	if selectedMapsCount == 0 then
		UI:setType(ui.playButton, "default_dark")
	else
		UI:setType(ui.playButton, "primary")
	end
end

function MapsScreen.openTab(id)
	if type(id) ~= "number" then
		return false
	end
	local tab = tabsList[id]
	if not tab then		
		return false
	end
	if activeTab then
		UI:setVisible(activeTab.panel, false)
		UI:setType(activeTab.button, "default_dark")
	end
	UI:setVisible(tab.panel, true)

	UI:setType(tab.button, "primary")
	activeTab = tab
	for i, map in ipairs(tab.maps) do
		toggleMapItem(map)
	end
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createDpPanel {
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 1.7,
		width = panelWidth,
		height = panelHeight,
		type = "transparent"
	}
	UI:addChild(ui.panel)

	-- Вкладки
	local tabWidth = panelWidth / #tabsList
	for i, tab in ipairs(tabsList) do
		tab.button = UI:createDpButton({
			x = (i - 1) * tabWidth,
			y = 0,
			width = tabWidth,
			height = TAB_BUTTON_HEIGHT,
			type = "default_dark",
			fontType = "defaultSmall",
			locale = tab.locale			
		})
		UI:addChild(ui.panel, tab.button)

		local tabWidth = panelWidth
		local tabHeight = panelHeight - TAB_BUTTON_HEIGHT - BOTTOM_BUTTON_HEIGHT
		tab.panel = UI:createDpPanel({
			x = 0,
			y = TAB_BUTTON_HEIGHT,
			width = tabWidth,
			height = tabHeight,
			type = "transparent"
		})
		UI:addChild(ui.panel, tab.panel)
		UI:setVisible(tab.panel, false)

		tab.maps = {}
		if mapsList[tab.name] then
			local mapItemWidth = tabWidth / 3 - MAP_ITEM_INDENT * 2 
			local mapItemHeight = tabHeight / 2 - MAP_ITEM_INDENT * 2.5
			for i, map in ipairs(mapsList[tab.name]) do
				local item = UI:createDpPanel({
					x = MAP_ITEM_INDENT * 2 + (mapItemWidth + MAP_ITEM_INDENT) * ((i - 1) % 3),
					y = MAP_ITEM_INDENT * 2 + (mapItemHeight + MAP_ITEM_INDENT) * math.floor((i - 1) / 3),
					width = mapItemWidth,
					height = mapItemHeight,
					type = "light"
				})
				UI:addChild(tab.panel, item)

				local mapNameLabel = UI:createDpLabel({
					x = 0 , y = mapItemHeight - 30,
					width = mapItemWidth, height = 30,
					color = MAP_UNSELECTED_LABEL_COLOR,
					fontType = "defaultSmall",
					text = map.name,
					alignX = "center",
				})
				UI:addChild(item, mapNameLabel)

				local mapCheckbox = UI:createDpCheckbox({
					x = mapItemWidth - 25, y = mapItemHeight - 30,
					width = 20, height = 20
				})
				UI:addChild(item, mapCheckbox)

				local texture
				local path = "assets/" .. tostring(tab.name) .. "/" .. tostring(i) .. ".png"
				if fileExists(path) then
					texture = dxCreateTexture(path)
				else
					texture = dxCreateTexture("assets/default_image.png")
				end
				local mapImage = UI:createImage({
					x = 0,
					y = 0,
					width = mapItemWidth,
					height = mapItemHeight - 40,
					texture = texture,
					color = MAP_UNSELECTED_IMAGE_COLOR
				})
				UI:addChild(item, mapImage)

				table.insert(tab.maps, {
					name = map.name,
					panel = item,
					label = mapNameLabel,
					image = mapImage,
					checkbox = mapCheckbox
				})
			end			
		else
			outputDebugString("No maps for tab: " .. tostring(tab.name))
		end
	end		

	-- Кнопка "Закрыть"
	ui.closeButton = UI:createDpButton({
		x = panelWidth / 2 - BOTTOM_BUTTON_WIDTH,
		y = panelHeight - BOTTOM_BUTTON_HEIGHT,
		width = BOTTOM_BUTTON_WIDTH,
		height = BOTTOM_BUTTON_HEIGHT,
		locale = "race_lobby_close_button",
		type = "default_dark"
	})
	UI:addChild(ui.panel, ui.closeButton)
	-- Кнопка "Искать игру"
	ui.playButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - BOTTOM_BUTTON_HEIGHT,
		width = BOTTOM_BUTTON_WIDTH,
		height = BOTTOM_BUTTON_HEIGHT,
		locale = "race_lobby_play_button",
		type = "default_dark",
	})
	UI:addChild(ui.panel, ui.playButton)

	UI:setVisible(ui.panel, false)

	if localPlayer:getData("activeUI") == "raceLobby" then
		localPlayer:setData("activeUI", false)
	end
	
	MapsScreen.setVisible(false)
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	for i, tab in ipairs(tabsList) do
		if widget == tab.button then
			MapsScreen.openTab(i)
			return
		end
		for j, map in ipairs(tab.maps) do
			if widget == map.image or widget == map.label or widget == map.panel then
				toggleMapItem(map)
			end
		end
	end 

	if widget == ui.closeButton then
		MapsScreen.setVisible(false)
	elseif widget == ui.playButton then
		MapsScreen.setVisible(false)
		SearchScreen.startSearch({"test"})
	end
end)

function setVisible(visible)
	MapsScreen.setVisible(visible)
end