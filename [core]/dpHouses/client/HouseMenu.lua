HouseMenu = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.dpUI
local window = {}
local kickLocked = false

local actions = {
	{"toggleDoor", "houses_menu_close_door"},
	{"kickPlayers", "houses_menu_kick"},
	{"sell", "houses_menu_sell"},
}

function HouseMenu.show()
	if localPlayer:getData("activeMap") ~= "house" then
		return
	end
	if localPlayer:getData("activeUI") then
		return
	end
	local houseId = localPlayer:getData("house_id")
	if not houseId then
		return
	end
	localPlayer:setData("activeUI", "houseMenu")

	local marker = Element.getByID("house_enter_marker_" .. houseId)
	if isElement(marker) then
		local str = "houses_menu_open_door"
		if marker:getData("house_open") then
			str = "houses_menu_close_door"
		end
		UI:setText(window.toggleDoor, exports.dpLang:getString(str))
	end

	UI:setVisible(window.panel, true)
	UI:fadeScreen(true)
	showCursor(true)
end

function HouseMenu.hide()
	if localPlayer:getData("activeUI") ~= "houseMenu" then
		return
	end
	localPlayer:setData("activeUI", false)

	UI:setVisible(window.panel, false)
	showCursor(false)
	UI:fadeScreen(false)	
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panelWidth = 350
	local panelHeight = 235	
	local logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = panelWidth
	local logoHeight = textureHeight * panelWidth / textureWidth
	window.panel = UI:createDpPanel({
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight + logoHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(window.panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 10,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(window.panel, logoImage)		

	local y = 0

	for i, button in ipairs(actions) do
		if button[1] then
			window[button[1]] = UI:createDpButton({
				x = 0, y = y,
				width = panelWidth,
				height = 45,
				type = "default_dark",
				locale = button[2]
			})
			UI:addChild(window.panel, window[button[1]])
			y = y + 45
		end
	end

	panelHeight = y + 55
	UI:setHeight(window.panel, panelHeight)
	

	window.closeButton = UI:createDpButton({
		x = 0, y = panelHeight - 55,
		width = panelWidth,
		height = 55,
		type = "primary",
		locale = "Закрыть"
	})
	UI:addChild(window.panel, window.closeButton)	

	UI:setVisible(window.panel, false)
end)

bindKey("F3", "down", function ()
	if localPlayer:getData("activeUI") ~= "houseMenu" then
		HouseMenu.show()
	else
		HouseMenu.hide()
	end	
end)

if localPlayer:getData("activeUI") == "houseMenu" then
	HouseMenu.hide()
end

addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == window.closeButton then
		HouseMenu.hide()
	elseif widget == window.sell then
		HouseMenu.hide()
		triggerServerEvent("dpHouses.sell", resourceRoot)
	elseif widget == window.toggleDoor then
		local houseId = localPlayer:getData("house_id")
		if not houseId then
			return
		end
		local marker = Element.getByID("house_enter_marker_" .. tostring(houseId))	
		if not isElement(marker) then
			return
		end
		marker:setData("house_open", not marker:getData("house_open"), true)
		local str = "houses_menu_open_door"
		if marker:getData("house_open") then
			str = "houses_menu_close_door"
		end
		UI:setText(window.toggleDoor, exports.dpLang:getString(str))
	elseif widget == window.kickPlayers then
		if not kickLocked  then
			triggerServerEvent("dpHouses.kickPlayers", resourceRoot)
			kickLocked  = true
			setTimer(function() kickLocked = false end, 2000, 1)
		end
	end
	--else
	--	BuyWindow.hide()
	--end
end)
