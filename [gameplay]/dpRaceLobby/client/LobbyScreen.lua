LobbyScreen = {}
LobbyScreen.isVisible = false
LobbyScreen.mapName = ""

local screenSize = Vector2(guiGetScreenSize())
local fonts = {}

local themeColor = {255, 255, 255}
local themeColorHEX = ""

local titleText = ""
local titleWidth = 0
local titleHeight = 0

local buttonText = ""
local buttonWidth = 220
local buttonHeight = 60

local buttonEnabled = false
local buttonMessage = ""

local infoFields = {
    { name = "", locale ="lobby_screen_field_players", value = "0"},
    { name = "", locale ="lobby_screen_field_class",   value = "-"},
}

addEvent("dpRaceLobby.countPlayers", true)

local function draw()
    local mx, my = getCursorPosition()
    if not mx then
        mx, my = 0, 0
    end
    mx, my = mx * screenSize.x, my * screenSize.y

    local x = math.max(screenSize.x * 0.2, screenSize.x / 2 - titleWidth * 0.75)
    local y = screenSize.y * 0.2
    dxDrawText(
        titleText,
        x,
        y,
        x,
        y,
        tocolor(255, 255, 255),
        1,
        fonts.title,
        "left",
        "top",
        false,
        false,
        true,
        true)

    y = y + titleHeight * 1.1

    dxDrawText(
        exports.dpLang:getString("race_lobby_text"),
        x,
        y,
        x,
        y,
        tocolor(255, 255, 255),
        1,
        fonts.info,
        "left",
        "top",
        false,
        false,
        true,
        true)

    y = y + 90   

    for i, field in ipairs(infoFields) do
        dxDrawText(
            field.name .. ": " .. themeColorHEX .. field.value,
            x,
            y,
            x,
            y,
            tocolor(255, 255, 255),
            1,
            fonts.info,
            "left",
            "top",
            false,
            false,
            true,
            true)

        y = y + 50
    end
    y = y + 20
    local buttonAlpha = 200
    local buttonColor = tocolor(255, 255, 255)
    if buttonEnabled then
        if mx >= x and my >=y and mx <= x + buttonWidth and my <= y + buttonHeight then
            buttonAlpha = 255

            if getKeyState("mouse1") then
                local mapName = LobbyScreen.mapName
                LobbyScreen.setVisible(false)
                SearchScreen.startSearch(mapName, infoFields[1].value)
                exports.dpSounds:playSound("ui_change.wav")
            end
        end
        buttonColor = tocolor(themeColor[1], themeColor[2], themeColor[3], buttonAlpha)
    else
        buttonColor = tocolor(40, 42, 41)
        dxDrawText(
            buttonMessage,
            x,
            y + buttonHeight,
            x + buttonWidth,
            y + buttonHeight * 1.8,
            tocolor(255, 255, 255),
            1,
            fonts.buttonMessage,
            "left",
            "bottom",
            false,
            false,
            true,
            true)
    end
    dxDrawRectangle(x, y, buttonWidth, buttonHeight, buttonColor, true)
    dxDrawText(
        buttonText,
        x,
        y,
        x + buttonWidth,
        y + buttonHeight,
        tocolor(255, 255, 255, buttonAlpha),
        1,
        fonts.button,
        "center",
        "center",
        false,
        false,
        true,
        true)
end

local function onVehicleExit(player)
    if player == localPlayer then
        return
    end
end

local function updateCounter(count)
    infoFields[1].value = tostring(count)
end

function LobbyScreen.toggle(mapName)
    if not LobbyScreen.isVisible then
        LobbyScreen.mapName = mapName
    end    
    outputDebugString("Toggle: " .. mapName)
    LobbyScreen.setVisible(not LobbyScreen.isVisible)
end

function LobbyScreen.setVisible(visible)
    visible = not not visible
    if LobbyScreen.isVisible == visible then
        return 
    end
    LobbyScreen.isVisible = visible
    if LobbyScreen.isVisible then
        local mapInfo = exports.dpRaceManager:getMapInfo(LobbyScreen.mapName) or {}
        local mapGamemode = mapInfo.gamemode
        if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
            exports.dpUI:showMessageBox(
                exports.dpLang:getString("race_error_title"), 
                exports.dpLang:getString("race_error_no_vehicle"))
            LobbyScreen.isVisible = false
            return
        end
        if localPlayer.vehicle:getData("owner_id") ~= localPlayer:getData("_id") then
            exports.dpUI:showMessageBox(
                exports.dpLang:getString("race_error_title"), 
                exports.dpLang:getString("race_error_not_owner"))
            LobbyScreen.isVisible = false
            return
        end
        localPlayer:setData("activeUI", "lobbyScreen")
        addEventHandler("onClientRender", root, draw)
        addEventHandler("onClientVehicleExit", localPlayer.vehicle, onVehicleExit)
        addEventHandler("dpRaceLobby.countPlayers", resourceRoot, updateCounter)
        fonts.title = exports.dpAssets:createFont("Roboto-Regular.ttf", 52)
        fonts.info = exports.dpAssets:createFont("Roboto-Regular.ttf", 21)
        fonts.button = exports.dpAssets:createFont("Roboto-Regular.ttf", 22)
        fonts.buttonMessage = exports.dpAssets:createFont("Roboto-Regular.ttf", 16)

        themeColor = {exports.dpUI:getThemeColor()}
        themeColorHEX = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())

        titleText =
            exports.dpLang:getString("lobby_screen_field_title") ..
            ": " .. themeColorHEX ..
            exports.dpLang:getString("race_type_" .. mapGamemode)

        titleWidth = dxGetTextWidth(titleText, 1, fonts.title, true)
        titleHeight = dxGetFontHeight(1, fonts.title)

        buttonText = exports.dpLang:getString("lobby_screen_enter_button")

        for i, field in ipairs(infoFields) do
            field.name = exports.dpLang:getString(field.locale)
        end

        bindKey("backspace", "down", LobbyScreen.toggle)

        buttonMessage = ""
        buttonEnabled = true

        if mapGamemode == "drift" then
            local handlingLevel = localPlayer.vehicle:getData("DriftHandling") 
            if not handlingLevel or handlingLevel < 1 then
                buttonMessage = exports.dpLang:getString("handling_switching_message_no_upgrade")
                buttonEnabled = false
            end
        end

        infoFields[1].value = "0"
        local vehicleClass = exports.dpShared:getVehicleClass(localPlayer.vehicle.model)
        infoFields[2].value = tostring(exports.dpShared:getVehicleClassName(vehicleClass))

        triggerServerEvent("dpRaceLobby.countPlayers", resourceRoot, LobbyScreen.mapName)
    else
        localPlayer:setData("activeUI", false)
        for font in pairs(fonts) do
            if isElement(font) then
                destroyElement(font)
            end
        end
        removeEventHandler("onClientRender", root, draw)
        removeEventHandler("onClientVehicleExit", localPlayer.vehicle, onVehicleExit)
        removeEventHandler("dpRaceLobby.countPlayers", resourceRoot, updateCounter)
        LobbyScreen.mapName = nil
        unbindKey("backspace", "down", LobbyScreen.toggle)
    end

    exports.dpHUD:setVisible(not LobbyScreen.isVisible)
    exports.dpUI:fadeScreen(LobbyScreen.isVisible)
    showCursor(LobbyScreen.isVisible)
end