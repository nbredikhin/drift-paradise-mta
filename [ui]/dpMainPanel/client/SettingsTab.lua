SettingsTab = {}
local panel
local widgets = {}

local languageButtonsList = {
	{ name = "en", language = "english" },
	{ name = "ru", language = "russian" },
	{ name = "ua", language = "ukrainian" },
	{ name = "pt", language = "portuguese" },
}

function SettingsTab.create()
	panel = Panel.addTab("settings")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)

	local y = 10
	--
	UI:addChild(panel, UI:createDpLabel {
		x = 20 , y = y,
		width = width / 2, height = 30,
		text = "Настройки игры",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		locale = "main_panel_settings_section_game"
	})

	-- Язык
	y = y + 25
	UI:addChild(panel, UI:createDpLabel {
		x = 20, y = y,
		width = width / 3, height = 30,
		text = "Язык",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_language"
	})

	y = y + 20
	-- Кнопки языков
	local langX = 20
	for i, languageButton in ipairs(languageButtonsList) do
		local button = UI:createDpImageButton({
			x = langX, y = y + 5,
			width = 20, height = 20,
			texture = exports.dpAssets:createTexture("buttons/" .. tostring(languageButton.name) .. ".png")
		})
		UI:addChild(panel, button)
		languageButton.button = button
		langX = langX + 25
	end

	-- Цвет
	y = y + 30
	UI:addChild(panel, UI:createDpLabel {
		x = 20, y = y,
		width = width / 3, height = 30,
		text = "Цвет интерфейса",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_color"
	})

	y = y + 20
	local circleTexture = exports.dpAssets:createTexture("buttons/circle.png", "argb", false, "clamp")
	local colorPurple = UI:createDpImageButton({
		x = 20,
		y = y + 5,
		width = 20, height = 20,
		color = tocolor(150, 0, 255),
		texture = circleTexture
	})
	UI:addChild(panel, colorPurple)

	local colorBlue = UI:createDpImageButton({
		x = 45,
		y = y + 5,
		width = 20, height = 20,
		color = tocolor(16, 160, 207),
		texture = circleTexture
	})
	UI:addChild(panel, colorBlue)

	local colorRed = UI:createDpImageButton({
		x = 70,
		y = y + 5,
		width = 20, height = 20,
		color = tocolor(212, 0, 40),
		texture = circleTexture
	})
	UI:addChild(panel, colorRed)

	y = y + 30
	-- Раздел графики
	UI:addChild(panel, UI:createDpLabel {
		x = 20 , y = y,
		width = width / 2, height = 30,
		text = "Настройки графики",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		locale = "main_panel_settings_section_graphics"
	})

	-- Отражения
	y = y + 30
	local graphicsSectionY = y
	local reflectionsCheckbox = UI:createDpCheckbox {
		x = 20, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, reflectionsCheckbox)
	UI:setState(reflectionsCheckbox, exports.dpConfig:getProperty("graphics.reflections_cars"))
	UI:addChild(panel, UI:createDpLabel {
		x = 50, y = y,
		width = width / 3, height = 30,
		text = "отражения на автомобилях",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_reflections_cars"
	})

	-- Вода
	y = y + 30
	local waterCheckbox = UI:createDpCheckbox {
		x = 20, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, waterCheckbox)
	UI:setState(waterCheckbox, exports.dpConfig:getProperty("graphics.reflections_water"))
	UI:addChild(panel, UI:createDpLabel {
		x = 50, y = y,
		width = width / 3, height = 30,
		text = "отражения на воде",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_reflections_water"
	})

	-- Фары
	y = y + 30
	local carLightsCheckbox = UI:createDpCheckbox {
		x = 20, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, carLightsCheckbox)
	UI:setState(carLightsCheckbox, exports.dpConfig:getProperty("graphics.improved_car_lights"))
	UI:addChild(panel, UI:createDpLabel {
		x = 50, y = y,
		width = width / 3, height = 30,
		text = "улучшенный эффект фар",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_improved_car_lights"
	})

	-- Небо
	y = y + 30
	local improvedSkyCheckbox = UI:createDpCheckbox {
		x = 20, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, improvedSkyCheckbox)
	UI:setState(improvedSkyCheckbox, exports.dpConfig:getProperty("graphics.improved_sky"))
	UI:addChild(panel, UI:createDpLabel {
		x = 50, y = y,
		width = width / 3, height = 30,
		text = "улучшенное небо",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_improved_sky"
	})

	-- Размытие
	y = y + 30
	local blurChechbox = UI:createDpCheckbox {
		x = 20, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, blurChechbox)
	UI:setState(blurChechbox, exports.dpConfig:getProperty("ui.blur"))

	UI:addChild(panel, UI:createDpLabel {
		x = 50, y = y,
		width = width / 3, height = 30,
		text = "размытие экрана",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_screen_blur"
	})

	-- Дым
	local x = width * 0.6
	y = graphicsSectionY
	local smokeCheckbox = UI:createDpCheckbox {
		x = x, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, smokeCheckbox)
	UI:setState(smokeCheckbox, exports.dpConfig:getProperty("graphics.tyres_smoke"))

	UI:addChild(panel, UI:createDpLabel {
		x = x + 30, y = y,
		width = width / 3, height = 30,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_tyres_smoke"
	})

	-- Музыка
	local x = width * 0.6
	y = y + 30
	local musicCheckbox = UI:createDpCheckbox {
		x = x, y = y + 4,
		width = 20, height = 20
	}
	UI:addChild(panel, musicCheckbox)
	UI:setState(musicCheckbox, exports.dpConfig:getProperty("game.background_music"))

	UI:addChild(panel, UI:createDpLabel {
		x = x + 30, y = y,
		width = width / 3, height = 30,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
		locale = "main_panel_settings_background_music"
	})	

	widgets = {
		colorButtons = {
			red = colorRed,
			blue = colorBlue,
			purple = colorPurple
		},
		blurChechbox = blurChechbox,
		improvedSkyCheckbox = improvedSkyCheckbox,
		carLightsCheckbox = carLightsCheckbox,
		waterCheckbox = waterCheckbox,
		reflectionsCheckbox = reflectionsCheckbox,
		smokeCheckbox = smokeCheckbox,
		musicCheckbox = musicCheckbox
	}
end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function(widget)
	
	local checkboxClicked = false

	-- Переключение языка
	for i, languageButton in ipairs(languageButtonsList) do
		if languageButton.button and languageButton.button == widget then
			checkboxClicked = true
			exports.dpLang:setLanguage(languageButton.language)
		end
	end

	if widget == widgets.colorButtons.red then
		checkboxClicked = true
		UI:setTheme("red")
	elseif widget == widgets.colorButtons.purple then
		checkboxClicked = true
		UI:setTheme("purple")
	elseif widget == widgets.colorButtons.blue then
		checkboxClicked = true
		UI:setTheme("blue")
	elseif widget == widgets.blurChechbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("ui.blur", UI:getState(widget))
	elseif widget == widgets.improvedSkyCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("graphics.improved_sky", UI:getState(widget))
	elseif widget == widgets.carLightsCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("graphics.improved_car_lights", UI:getState(widget))
	elseif widget == widgets.waterCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("graphics.reflections_water", UI:getState(widget))
	elseif widget == widgets.reflectionsCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("graphics.reflections_cars", UI:getState(widget))
	elseif widget == widgets.smokeCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("graphics.tyres_smoke", UI:getState(widget))
	elseif widget == widgets.musicCheckbox then
		checkboxClicked = true
		exports.dpConfig:setProperty("game.background_music", UI:getState(widget))
	end

	if checkboxClicked then
		exports.dpSounds:playSound("ui_change.wav")
	end
end)