AccountTab = {}
local panel
local ui = {}

function AccountTab.create()
	panel = Panel.addTab("account")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)

	local usernameLabel = UI:createDpLabel {
		x = 20, y = 15,
		width = width / 3, height = 50,
		text = "---",
		type = "primary",
		fontType = "defaultLarger"
	}
	UI:addChild(panel, usernameLabel)
	UIDataBinder.bind(usernameLabel, "username", function (value)
		return string.upper(tostring(value))
	end)
	-- Подпись
	local usernameLabelText = UI:createDpLabel {
		x = 20 , y = 55,
		width = width / 3, height = 50,
		text = "Admin",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		locale = "main_panel_account_player"
	}
	UI:addChild(panel, usernameLabelText)
	UIDataBinder.bind(usernameLabelText, "group", function (value)
		if not value then
			return exports.dpLang:getString("groups_player")
		else
			return exports.dpLang:getString("groups_" .. tostring(value))
		end
	end)

	-- local moneyLabel = UI:createDpLabel {
	-- 	x = width - width / 3 - 20 , y = 15,
	-- 	width = width / 3, height = 50,
	-- 	text = "$0",
	-- 	type = "primary",
	-- 	fontType = "defaultLarger",
	-- 	alignX = "right"
	-- }
	-- UI:addChild(panel, moneyLabel)
	-- UIDataBinder.bind(moneyLabel, "money", function (value)
	-- 	return "$" .. tostring(value)
	-- end)
	-- -- Подпись
	-- local moneyLabelText = UI:createDpLabel {
	-- 	x = width - width / 3 - 20 , y = 55,
	-- 	width = width / 3, height = 50,
	-- 	text = "Money",
	-- 	color = tocolor(0, 0, 0, 100),
	-- 	fontType = "defaultSmall",
	-- 	alignX = "right",
	-- 	locale = "main_panel_account_money"
	-- }
	-- UI:addChild(panel, moneyLabelText)

	-- Прогрессбар
	local levelProgressBg = UI:createRectangle {
		x = 20, y = 100,
		width = width - 40,
		height = 30,
		color = tocolor(200, 200, 200),
	}
	UI:addChild(panel, levelProgressBg)
	local levelProgress = UI:createRectangle {
		x = 0, y = 0,
		width = (width - 40) * 0.65,
		height = 30,
		color = tocolor(40, 40, 40),
	}
	UI:addChild(levelProgressBg, levelProgress)
	local levelLabelCurrent = UI:createDpLabel {
		x = 10, y = 0,
		width = 50, height = 30,
		text = "1",
		color = tocolor(110, 110, 110, 255),
		fontType = "defaultSmall",
		alignX = "left",
		alignY = "center"
	}
	UI:addChild(levelProgressBg, levelLabelCurrent)

	local levelLabelNext = UI:createDpLabel {
		x = UI:getWidth(levelProgressBg) - 60, y = 0,
		width = 50, height = 30,
		text = "2",
		color = tocolor(110, 110, 110, 255),
		fontType = "defaultSmall",
		alignX = "right",
		alignY = "center"
	}
	UI:addChild(levelProgressBg, levelLabelNext)

	local xpLabel = UI:createDpLabel {
		x = (UI:getWidth(levelProgressBg) - 50) / 2, y = 0,
		width = 50, height = 30,
		text = "0/0",
		color = tocolor(110, 110, 110, 255),
		fontType = "defaultSmall",
		alignX = "center",
		alignY = "center"
	}
	UI:addChild(levelProgressBg, xpLabel)

	local levelLabel = UI:createDpLabel {
		x = 20, y = 135,
		width = width / 3, height = 50,
		text = "Уровень",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		alignX = "left",
		locale = "main_panel_account_level"
	}
	UI:addChild(panel, levelLabel)

	---------------- Статистика -------------------
	-- Количество автомобилей в гараже
	local carsCountLabel = UI:createDpLabel {
		x = 20, y = 180,
		width = width / 3, height = 50,
		text = "Количество авто: 5",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, carsCountLabel)
	UIDataBinder.bind(carsCountLabel, "garage_cars_count", function (value)
		if not value then
			value = 0
		end
		return exports.dpLang:getString("main_panel_account_cars_count") .. ": " .. tostring(value)
	end)

	-- Время, проведенное на сервере
	local playtimeLabel = UI:createDpLabel {
		x = 20, y = 210,
		width = width / 3, height = 50,
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, playtimeLabel)
	UIDataBinder.bind(playtimeLabel, "playtime", function (value)
		value = tonumber(value)
		if not value then
			value = 0
		end
		value = math.floor(value / 60 * 10) / 10
		return exports.dpLang:getString("main_panel_account_playtime") .. ": " .. tostring(value)
	end)	

	-- Наличие у игрока дома (TODO)
	local premiumLabel = UI:createDpLabel {
		x = width / 2, y = 210,
		width = width / 3, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, premiumLabel)
	UIDataBinder.bind(premiumLabel, "premium_expires", function (value)
		if not localPlayer:getData("isPremium") then
			return ""
		end
		if not value or type(value) ~= "number" then
			return ""
		end
		local time = getRealTime(value)
		local month = tostring(time.month + 1)
		if time.month < 10 then
			month = "0" .. tostring(time.month + 1)
		end
		local day = tostring(time.monthday)
		if time.monthday < 10 then
			day = "0" .. tostring(time.monthday)
		end
		return exports.dpLang:getString("main_panel_account_premium") .. ": " .. tostring(1900 + time.year) .. "-" .. month .. "-" .. day
	end)

	-- Дата регистрации
	local registerDateLabel = UI:createDpLabel {
		x = width / 2, y = 180,
		width = width / 3, height = 50,
		text = "Дата регистрации: 1.01.2016",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, registerDateLabel)
	UIDataBinder.bind(registerDateLabel, "register_time", function (value)
		if type(value) ~= "string" then
			return ""
		end
		local timeString = tostring(value:sub(1, string.find(value, " ")))
		return exports.dpLang:getString("main_panel_account_regtime") .. ": " .. timeString
	end)

	-------------------------- Нижние кнопки ------------------------------
	-- Кнопка "Дополнительно"
	local bottomButtonsHeight = 70
	local helpButton = UI:createDpButton {
		x = 0,
		y = height - bottomButtonsHeight,
		width = width / 2,
		height = bottomButtonsHeight,
		locale = "main_panel_account_help",
		--type = "lig"h
	}
	UI:addChild(panel, helpButton)

	-- Кнопка "Донат"
	local donateButton = UI:createDpButton {
		x = width / 2,
		y = height - bottomButtonsHeight,
		width = width / 2,
		height = bottomButtonsHeight,
		locale = "main_panel_account_donat",
		type = "primary"
	}
	UI:addChild(panel, donateButton)

	ui = {
		levelProgressBg = levelProgressBg,
		levelProgress = levelProgress,

		levelLabelCurrent = levelLabelCurrent,
		levelLabelNext = levelLabelNext,
		xpLabel = xpLabel,

		donateButton = donateButton,
		helpButton = helpButton
	}
end

function AccountTab.refresh()
	local level = localPlayer:getData("level")
	if not level then
		return
	end
	local xp = localPlayer:getData("xp")
	if not xp then
		return
	end

	local maxLevel = exports.dpCore:getMaxLevel()
	local xp1 = exports.dpCore:getXPFromLevel(level)
	local xp2 = exports.dpCore:getXPFromLevel(level + 1)
	local nextLevelXp = xp2 - xp1
	local currentXp = xp - xp1

	local progress = currentXp / nextLevelXp
	if level >= maxLevel then
		progress = 1
	end
	local width = UI:getWidth(ui.levelProgressBg)
	UI:setWidth(ui.levelProgress, width * progress)

	UI:setText(ui.levelLabelCurrent, tostring(level))
	if level >= maxLevel then
		UI:setText(ui.levelLabelNext, "MAX")
		UI:setVisible(ui.xpLabel, false)
	else
		UI:setText(ui.levelLabelNext, tostring(level + 1))
		UI:setText(ui.xpLabel, ("%s/%s XP"):format(exports.dpUtils:format_num(currentXp, 0), exports.dpUtils:format_num(nextLevelXp, 0)))
		UI:setVisible(ui.xpLabel, true)
	end

end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == ui.donateButton then
		Panel.setVisible(false)
		exports.dpGiftsPanel:setVisible(true)
	elseif widget == ui.helpButton then
		Panel.setVisible(false)
		exports.dpHelpPanel:setVisible(true)
	end
end)
