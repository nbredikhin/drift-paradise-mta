HouseMenu = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.dpUI
local window = {}

local actions = {
	{"sell", "Продать государству за $5,000,000"},
	{"sellPlayer", "Продать игроку..."},
	{"toggleDoor", "Открыть входную дверь"},
	{"toggleDoor", "Выгнать всех игроков"},
}

function HouseMenu.show()
	if localPlayer:getData("activeMap") ~= "house" then
		return
	end
	if localPlayer:getData("activeUI") then
		return
	end
	localPlayer:setData("activeUI", "houseMenu")

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

addEventHandler("dpUI.click", root, function (widget)
	if widget == window.closeButton then
		HouseMenu.hide()
	elseif widget == window.sell then
		HouseMenu.hide()
		triggerServerEvent("dpHouses.sell", resourceRoot)
		triggerServerEvent("dpHouses.house_exit", resourceRoot, "house_exit_marker_" .. tostring(localPlayer:getData("house_id")))
	end
	--else
	--	BuyWindow.hide()
	--end
end)
