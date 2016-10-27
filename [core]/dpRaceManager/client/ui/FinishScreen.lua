FinishScreen = {}
local isActive = false

local screenSize = Vector2(guiGetScreenSize())
local animationProgress = 0
local animationSpeed = 0.7

local mainText = ""
local bottomText = ""

local mainTextFont
local bottomTextFont

local bottomTextFontHeight = 0
local themeColorHEX = "#FFAA00"

local isTimeoutVisible = false

local function draw()
    local scale1 = math.min(1, animationProgress * 2)
    local scale2 = math.min(1, animationProgress * 1.5)
    dxDrawText(mainText, 0, 0, screenSize.x, screenSize.y / 2, tocolor(255, 255, 255, 255 * animationProgress), scale1, mainTextFont, "center", "bottom", false, false, false, true)
    if isTimeoutVisible then
        local timeLeft = tostring(math.floor(RaceTimer.getTimeLeft()))
        if timeLeft == "0" then
            isTimeoutVisible = false
        end
        dxDrawText("Ожидание конца гонки: " .. themeColorHEX .. timeLeft, 0, screenSize.y / 2, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * animationProgress), scale2, bottomTextFont, "center", "top", false, false, false, true)
    end
end

local function update(dt)
    dt = dt / 1000
    animationProgress = math.min(1, animationProgress + animationSpeed * dt)
end

function FinishScreen.show(showTimeout)
    themeColorHEX = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
    mainText = exports.dpLang:getString("Вы финишировали!")
    isTimeoutVisible = not not showTimeout
    FinishScreen.start()
end

function FinishScreen.start()
    if isActive then
        return false
    end
    isActive = true
    addEventHandler("onClientRender", root, draw)
    addEventHandler("onClientPreRender", root, update)

    mainTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 52)
    bottomTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 28)

    bottomTextFontHeight = dxGetFontHeight(1, mainTextFont)
    animationProgress = 0
    return true
end

function FinishScreen.stop()
    if not isActive then
        return false
    end
    isActive = false
    removeEventHandler("onClientRender", root, draw)
    removeEventHandler("onClientPreRender", root, update)

    if isElement(mainTextFont) then destroyElement(mainTextFont) end
    if isElement(bottomTextFont) then destroyElement(bottomTextFont) end

    mainText = ""
    bottomText = ""
    return true
end