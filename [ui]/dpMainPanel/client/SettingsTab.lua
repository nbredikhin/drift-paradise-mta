SettingsTab = {}
local ui = {}

local colorButtonsList = {
    { name = "purple" },
    { name = "blue" },
    { name = "red" },
    { name = "orange" },
    { name = "green" }
}
local languageButtonsList = {
    { name = "en", language = "english" },
    { name = "ru", language = "russian" },
    { name = "ua", language = "ukrainian" },
    { name = "pt", language = "portuguese" },
}

function SettingsTab.create()
    ui.panel = Panel.addTab("settings")

    local width = UI:getWidth(ui.panel)
    local height = UI:getHeight(ui.panel)

    local y = 10

    -- Раздел настроек игры
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = width / 2, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_game"
    })

    -- Подпись к кнопкам выбора языка
    y = y + 25
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_language"
    })

    -- Кнопки выбора языка
    y = y + 20
    local langX = 20
    for i, languageButton in ipairs(languageButtonsList) do
        local button = UI:createDpImageButton({
            x       = langX, 
            y       = y + 5,
            width   = 20, 
            height  = 20,
            texture = exports.dpAssets:createTexture("buttons/" .. tostring(languageButton.name) .. ".png")
        })
        UI:addChild(ui.panel, button)
        languageButton.button = button
        langX = langX + 25
    end

    -- Подпись к кнопкам выбора цвета
    y = y + 30
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_color"
    })

    y = y + 20
    local colorButtonX = 20
    local circleTexture = exports.dpAssets:createTexture("buttons/circle.png", "argb", false, "clamp")
    -- Кнопки выбора цвета
    for i, colorButton in ipairs(colorButtonsList) do
        local button = UI:createDpImageButton({
            x       = colorButtonX,
            y       = y + 5,
            width   = 20, 
            height  = 20,
            color   = tocolor(exports.dpUI:getThemeColor(colorButton.name)),
            texture = circleTexture
        })
        UI:addChild(ui.panel, button)
        colorButtonX = colorButtonX + 25
    end

    -- Раздел настроек чата
    y = y + 30
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20 , 
        y        = y,
        width    = width / 2, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_chat"
    })

    -- Сообщения о подключениях
    y = y + 30
    local chatSectionY = y
    ui.joinQuitMessagesCheckbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.joinQuitMessagesCheckbox)
    UI:setState(ui.joinQuitMessagesCheckbox, exports.dpConfig:getProperty("chat.joinquit_messages"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_joinquit_messages"
    })

    -- Время в чате
    local chatTimestampX = width * 0.6
    ui.chatTimestampCheckbox = UI:createDpCheckbox {
        x      = chatTimestampX, 
        y      = chatSectionY + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.chatTimestampCheckbox)
    UI:setState(ui.chatTimestampCheckbox, exports.dpConfig:getProperty("chat.timestamp"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = chatTimestampX + 30, 
        y        = chatSectionY,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_chat_timestamp"
    })

    -- Заголовок раздела графики
    y = y + 30
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = width / 2, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_graphics"
    })

    -- Отражения
    y = y + 30
    local graphicsSectionY = y
    ui.reflectionsCheckbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.reflectionsCheckbox)
    UI:setState(ui.reflectionsCheckbox, exports.dpConfig:getProperty("graphics.reflections_cars"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_cars"
    })

    -- Вода
    y = y + 30
    ui.waterCheckbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.waterCheckbox)
    UI:setState(ui.waterCheckbox, exports.dpConfig:getProperty("graphics.reflections_water"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_water"
    })

    -- Фары
    y = y + 30
    ui.carLightsCheckbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.carLightsCheckbox)
    UI:setState(ui.carLightsCheckbox, exports.dpConfig:getProperty("graphics.improved_car_lights"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_car_lights"
    })

    -- Небо
    y = y + 30
    ui.improvedSkyCheckbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.improvedSkyCheckbox)
    UI:setState(ui.improvedSkyCheckbox, exports.dpConfig:getProperty("graphics.improved_sky"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_sky"
    })

    -- Размытие
    y = y + 30
    ui.blurChechbox = UI:createDpCheckbox {
        x      = 20, 
        y      = y + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.blurChechbox)
    UI:setState(ui.blurChechbox, exports.dpConfig:getProperty("ui.blur"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50, 
        y        = y,
        width    = width / 3, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_blur"
    })

    -- Дым
    local x = width * 0.6
    ui.smokeCheckbox = UI:createDpCheckbox {
        x      = x, 
        y      = graphicsSectionY + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.smokeCheckbox)
    UI:setState(ui.smokeCheckbox, exports.dpConfig:getProperty("graphics.tyres_smoke"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30, 
        y        = graphicsSectionY,
        width    = width / 3, 
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_tyres_smoke"
    })

    -- Музыка
    local x = width * 0.6
    graphicsSectionY = graphicsSectionY + 30
    ui.musicCheckbox = UI:createDpCheckbox {
        x      = x, 
        y      = graphicsSectionY + 4,
        width  = 20, 
        height = 20
    }
    UI:addChild(ui.panel, ui.musicCheckbox)
    UI:setState(ui.musicCheckbox, exports.dpConfig:getProperty("game.background_music"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30, 
        y        = graphicsSectionY,
        width    = width / 3, 
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_background_music"
    })

    -- Отступ снизу
    y = y + 40
    UI:setHeight(ui.panel, y)

    local passwordButtonWidth  = 180
    local passwordButtonHeight = 40
    ui.passwordChangeButton = UI:createDpButton {
        x      = x,
        y      = y - passwordButtonHeight - 15,
        width  = passwordButtonWidth,
        height = passwordButtonHeight,
        locale = "main_panel_setting_change_password",
        type   = "primary"
    }
    UI:addChild(ui.panel, ui.passwordChangeButton)  
end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function(widget)
    local playClickSound = false

    -- Переключение языка
    for i, languageButton in ipairs(languageButtonsList) do
        if languageButton.button and languageButton.button == widget then
            playClickSound = true
            exports.dpLang:setLanguage(languageButton.language)
        end
    end
    -- Переключение цвета
    for i, colorButton in ipairs(colorButtonsList) do
        if colorButton.button and colorButton.button == widget then
            playClickSound = true
            UI:setTheme(colorButton.name)
        end
    end

    if widget == ui.joinQuitMessagesCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("chat.joinquit_messages", UI:getState(widget))
    elseif widget == ui.chatTimestampCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("chat.timestamp", UI:getState(widget))
    elseif widget == ui.blurChechbox then
        playClickSound = true
        exports.dpConfig:setProperty("ui.blur", UI:getState(widget))
    elseif widget == ui.improvedSkyCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("graphics.improved_sky", UI:getState(widget))
    elseif widget == ui.carLightsCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("graphics.improved_car_lights", UI:getState(widget))
    elseif widget == ui.waterCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("graphics.reflections_water", UI:getState(widget))
    elseif widget == ui.reflectionsCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("graphics.reflections_cars", UI:getState(widget))
    elseif widget == ui.smokeCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("graphics.tyres_smoke", UI:getState(widget))
    elseif widget == ui.musicCheckbox then
        playClickSound = true
        exports.dpConfig:setProperty("game.background_music", UI:getState(widget))
    elseif widget == ui.passwordChangeButton then
        Panel.setVisible(false)
        PasswordPanel.show()
        exports.dpSounds:playSound("ui_select.wav")
    end

    if playClickSound then
        exports.dpSounds:playSound("ui_change.wav")
    end
end)
