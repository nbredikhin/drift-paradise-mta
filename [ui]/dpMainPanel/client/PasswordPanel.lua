PasswordPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 300
local panelHeight = 300

local isVisible = false
local ui = {}

function PasswordPanel.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.dpHUD:setVisible(false)
    exports.dpUI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "passwordChange")
end

function PasswordPanel.hide()
    if not isVisible then
        return false
    end
    isVisible = false
    exports.dpHUD:setVisible(true)
    exports.dpUI:fadeScreen(false)
    showCursor(false)
    UI:setVisible(ui.panel, false)
    localPlayer:setData("activeUI", false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = UI:createDpPanel {
        x       = (screenWidth  - panelWidth)  / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
        type    = "light"
    }
    UI:addChild(ui.panel)
    UI:setVisible(ui.panel, false)

    -- Высота кнопок
    local buttonsHeight = 50
    -- Кнопка отмены
    ui.cancelButton = UI:createDpButton({
        x      = 0,
        y      = panelHeight - buttonsHeight,
        width  = panelWidth / 2,
        height = buttonsHeight,
        locale = "main_panel_new_password_cancel",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.cancelButton)

    -- Кнопка "принять"
    ui.acceptButton = UI:createDpButton({
        x      = panelWidth / 2,
        y      = panelHeight - buttonsHeight,
        width  = panelWidth / 2,
        height = buttonsHeight,
        locale = "main_panel_new_password_accept",
        type   = "primary"
    })
    UI:addChild(ui.panel, ui.acceptButton)

    -- Ввод нового пароля
    local y = 10
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 0, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        alignX   = "center",
        locale   = "main_panel_password_change_title"
    })
    y = y + 40
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_new_password_label"
    })
    y = y + 30
    ui.newPasswordInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = panelWidth - 20,
        height = 50,
        type   = "light",
        masked = true,
        locale = "main_panel_new_password_placeholder"
    })
    UI:addChild(ui.panel, ui.newPasswordInput)    
    y = y + 65
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_new_password_repeat_label"
    })
    y = y + 30
    ui.newPasswordRepeatInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = panelWidth - 20,
        height = 50,
        type   = "light",
        masked = true,
        locale = "main_panel_new_password_repeat_placeholder"
    })    
    UI:addChild(ui.panel, ui.newPasswordRepeatInput)    
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
    if widget == ui.acceptButton then
        local newPassword = UI:getText(ui.newPasswordInput)
        if not newPassword or string.len(newPassword) < 1 then
            exports.dpUI:showMessageBox(
                exports.dpLang:getString("main_panel_password_change_message"), 
                exports.dpLang:getString("login_panel_err_enter_password")
            )
            exports.dpSounds:playSound("ui_error.wav")
            return
        end
        if newPassword ~= UI:getText(ui.newPasswordRepeatInput) then
            exports.dpUI:showMessageBox(
                exports.dpLang:getString("main_panel_password_change_message"), 
                exports.dpLang:getString("login_panel_err_passwords_do_not_match")
            )
            exports.dpSounds:playSound("ui_error.wav")
            return
        end 
        local success, errorType = exports.dpCore:changePassword(newPassword)
        if not success then
            local errorText = exports.dpLang:getString("main_panel_password_change_error")
            if errorType == "password_too_short" then
                errorText = exports.dpLang:getString("login_panel_err_password_too_short")
            elseif errorType == "password_too_long" then
                errorText = exports.dpLang:getString("login_panel_err_password_too_long")
            end            
            exports.dpUI:showMessageBox(
                exports.dpLang:getString("main_panel_password_change_message"),
                errorText
            )
            outputDebugString("Client password change error: " .. tostring(errorType))
            exports.dpSounds:playSound("ui_error.wav")
            return 
        end
        PasswordPanel.hide()
        exports.dpSounds:playSound("ui_select.wav")
        Panel.setVisible(true)
    elseif widget == ui.cancelButton then
        PasswordPanel.hide()
        exports.dpSounds:playSound("ui_back.wav")
        Panel.setVisible(true)
    end
end)

addEvent("dpCore.passwordChangeResponse", true)
addEventHandler("dpCore.passwordChangeResponse", root, function (success, err)
    if not success then
        exports.dpUI:showMessageBox(
            exports.dpLang:getString("main_panel_password_change_message"),
            exports.dpLang:getString("main_panel_password_change_error")
        )        
        exports.dpSounds:playSound("ui_error.wav")
        return
    end

    exports.dpUI:showMessageBox(
        exports.dpLang:getString("main_panel_password_change_message"),
        exports.dpLang:getString("main_panel_password_change_success")
    )

    local username = localPlayer:getData("username")
    if not username then
        return false
    end
    -- Очистка пароля в автозаполнении
    exports.dpLoginPanel:autologinRemember(username, "")
end)