InviteWindow = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.dpUI
local ui = {}

local panelWidth, panelHeight = 400, 250
local BUTTON_HEIGHT = 50

local targetPlayer

function InviteWindow.show(player)
	if InviteWindow.isVisible() then
		return false
	end
	if not isElement(player) then
		return false
	end
	targetPlayer = player

	if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_local_nocar"))
		return
	end
	if localPlayer.vehicle:getData("owner_id") ~= localPlayer:getData("_id") then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_local_not_owner"))
		return
	end
	if not targetPlayer.vehicle or targetPlayer.vehicle.controller ~= targetPlayer then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_remote_nocar"))
		return
	end
	if targetPlayer.vehicle:getData("owner_id") ~= targetPlayer:getData("_id") then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_remote_not_owner"))
		return
	end	
	if (targetPlayer.position - localPlayer.position):getLength() > 14 then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_too_far"))
		return 
	end

	UI:setText(ui.mainLabel, string.format(
		exports.dpLang:getString("duel_invite_duel_with"),
		exports.dpUtils:removeHexFromString(tostring(targetPlayer.name))))
	UI:setText(ui.betInput, tostring(tonumber(exports.dpShared:getEconomicsProperty("duel_bet_min"))))
	InviteWindow.setVisible(true)
end

function InviteWindow.isVisible()
	return not not UI:getVisible(ui.panel)
end

function InviteWindow.setVisible(visible)
	visible = not not visible
	if InviteWindow.isVisible() == visible then
		return false
	end 
	if visible then
		localPlayer:setData("activeUI", "duelInvite")
	else
		localPlayer:setData("activeUI", false)
	end

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.dpHUD:setVisible(not visible)
	exports.dpUI:fadeScreen(visible)
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

	-- Кнопка "Отмена"
	ui.cancelButton = UI:createDpButton({
		x = 0,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "duel_invite_cancel",
		type = "default_dark"
	})
	UI:addChild(ui.panel, ui.cancelButton)

	-- Кнопка "Принять"
	ui.acceptButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - BUTTON_HEIGHT,
		width = panelWidth / 2,
		height = BUTTON_HEIGHT,
		locale = "duel_invite_call",
		type = "primary"
	})
	UI:addChild(ui.panel, ui.acceptButton)

	local labelOffset = 0.45
	local y = 15
	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = y,
		width = panelWidth, height = 40,
		type = "dark",
		fontType = "defaultLarge",
		text = "...",
		clip = true,
		alignX = "center",
		alignY = "top"
	})
	UI:addChild(ui.panel, ui.mainLabel)

	y = y + 50
	ui.infoLabel = UI:createDpLabel({
		x = 15 , y = y,
		width = panelWidth - 30, height = 30,
		type = "light",
		fontType = "defaultSmall",
		locale = "duel_invite_info_label",
		color = tocolor(0, 0, 0, 100),
		alignX = "left",
		alignY = "top",
		wordBreak = true
	})
	UI:addChild(ui.panel, ui.infoLabel)	

	y = y + 60
	ui.betInput = UI:createDpInput({
		x = 15,
		y = y,
		width = panelWidth - 30,
		height = 50,
		type = "light",
		locale = "duel_invite_bet_placeholder",
		regexp = "[0-9]"
	})
	UI:addChild(ui.panel, ui.betInput)

	UI:setVisible(ui.panel, false)
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.acceptButton then
		if not isElement(targetPlayer) then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_error_player_left"))
			return
		end
		if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_local_nocar"))
			InviteWindow.setVisible(false)
			return
		end
		if not targetPlayer.vehicle or targetPlayer.vehicle.controller ~= targetPlayer then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_remote_nocar"))
			InviteWindow.setVisible(false)
			return
		end
		local bet = tonumber(UI:getText(ui.betInput))
		if not bet then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_error_bad_bet_amount"))
			return 
		end
		local betMin = exports.dpShared:getEconomicsProperty("duel_bet_min")
		local betMax = exports.dpShared:getEconomicsProperty("duel_bet_max")
		if bet < betMin then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), string.format(exports.dpLang:getString("duel_invite_error_bet_too_small"), tostring(betMax)))
			return
		end
		if bet > betMax then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), string.format(exports.dpLang:getString("duel_invite_error_bet_too_big"), tostring(betMax)))
			return
		end	
		if localPlayer:getData("money") < bet then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_error_not_enough_money"))
			return
		end
		if targetPlayer:getData("money") < bet then
			exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_error_title"), exports.dpLang:getString("duel_invite_error_player_not_enough_money"))
			return
		end

		InviteWindow.setVisible(false)
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_duel_title"), exports.dpLang:getString("duel_invite_invite_sent_body"))
		exports.dpChat:message("global", exports.dpLang:getString("duel_invite_invite_sent_chatmsg"), 0, 255, 0)
		triggerServerEvent("dpDuels.callPlayer", resourceRoot, targetPlayer, bet)
	elseif widget == ui.cancelButton then
		InviteWindow.setVisible(false)
	end
end)

addEvent("dpDuels.answerCall", true)
addEventHandler("dpDuels.answerCall", resourceRoot, function (player, status)
	if not isElement(targetPlayer) then
		return
	end
	if not isElement(player) then
		return
	end
	if player ~= targetPlayer then
		return
	end
	exports.dpUI:hideMessageBox()
	if not status then
		exports.dpUI:showMessageBox(exports.dpLang:getString("duel_invite_duel_title"), exports.dpLang:getString("duel_invite_invite_player_cancelled"))
	end
end)