ConfirmWindow = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.dpUI
local window = {}
local confirmCallback

function ConfirmWindow.show(text, callback)
	-- Открыто другое меню
	if localPlayer:getData("activeUI") then
		return
	end	
	localPlayer:setData("activeUI", "confirmWindow")
	if type(text) ~= "string" then
		outputDebugString("ConfirmWindow.show: text must be string")
		return
	end
	if type(callback) ~= "function" then
		outputDebugString("ConfirmWindow.show: callback must be function")
		return
	end
	text = tostring(text)
	confirmCallback = callback

	UI:setText(window.text, text)
	UI:setVisible(window.panel, true)
	UI:fadeScreen(true)
	showCursor(true)
end

function ConfirmWindow.hide()
	if localPlayer:getData("activeUI") ~= "confirmWindow" then
		return
	end		
	localPlayer:setData("activeUI", false)
	UI:setVisible(window.panel, false)
	UI:fadeScreen(false)
	showCursor(false)
	confirmCallback = nil
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panelWidth = 320
	local panelHeight = 180	
	window.panel = UI:createDpPanel({
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(window.panel)	

	window.text = UI:createDpLabel({
		x = 10, y = 10,
		width = panelWidth - 20,
		height = panelHeight - 65,
		text = "...",
		type = "default",
		alignX = "center",
		alignY = "center",
		wordBreak = true
	})
	UI:addChild(window.panel, window.text)

	window.noButton = UI:createDpButton({
		x = 0, y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		locale = "Нет"
	})
	UI:addChild(window.panel, window.noButton)	
	window.yesButton = UI:createDpButton({
		x = panelWidth / 2, y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		locale = "Да"
	})
	UI:addChild(window.panel, window.yesButton)		

	UI:setVisible(window.panel, false)
end)

addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == window.yesButton then
		if type(confirmCallback) == "function" then
			confirmCallback()
		end
		ConfirmWindow.hide()
	elseif widget == window.noButton then
		ConfirmWindow.hide()
	end
end)

if localPlayer:getData("activeUI") == "confirmWindow" then
	ConfirmWindow.hide()
end