AccountTab = {}
local panel

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

	local moneyLabel = UI:createDpLabel {
		x = width - width / 3 - 20 , y = 15,
		width = width / 3, height = 50,
		text = "$0",
		type = "primary",
		fontType = "defaultLarger",
		alignX = "right"
	}
	UI:addChild(panel, moneyLabel)
	UIDataBinder.bind(moneyLabelText, "money", function (value)
		return "$" .. tostring(value)
	end)	
	-- Подпись
	local moneyLabelText = UI:createDpLabel {
		x = width - width / 3 - 20 , y = 55,
		width = width / 3, height = 50,
		text = "Money",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		alignX = "right",
		locale = "main_panel_account_money"
	}
	UI:addChild(panel, moneyLabelText)		

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

	-- Наличие у игрока дома (TODO)
	local hasHouseLabel = UI:createDpLabel {
		x = 20, y = 210,
		width = width / 3, height = 50,
		text = "Дом: нет",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, hasHouseLabel)

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

	-- Время, проведенное на сервере
	local playtimeLabel = UI:createDpLabel {
		x = width / 2, y = 210,
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
		value = math.floor(value / 60)
		return exports.dpLang:getString("main_panel_account_playtime") .. ": " .. tostring(value)
	end)

	-------------------------- Нижние кнопки ------------------------------
	-- Кнопка доната
	local bottomButtonsHeight = 70
	local donatButton = UI:createDpButton {
		x = 0, 
		y = height - bottomButtonsHeight,
		width = width / 2,
		height = bottomButtonsHeight,
		locale = "main_panel_account_donat",
		--type = "lig"h
	}
	UI:addChild(panel, donatButton)

	-- Кнопка "Дополнительно"
	local moreButton = UI:createDpButton {
		x = width / 2, 
		y = height - bottomButtonsHeight,
		width = width / 2,
		height = bottomButtonsHeight,
		locale = "main_panel_account_more",
		type = "primary"
	}
	UI:addChild(panel, moreButton)	
end