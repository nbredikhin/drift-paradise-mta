FinishScreen = {}
local isActive = false
local realScreenSize = Vector2(guiGetScreenSize())
local screenWidth, screenHeight

local cameraStartOffset = Vector3(5, 5, 2)
local cameraEndOffset = Vector3(-5, 5, 1)
local animationProgress = 0
local fadeProgress = 0
local fadeSpeed = 1
local animationSpeed = 0.02

local pedsRandomRadius = 2
local pedsSkins = {1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312}
local pedsCount = 20
local pedsRadius = 4
local peds = {}
local finishPosition = Vector3()

local renderTarget

local itemFont

local themeColor = {212, 0, 40}
local ranksColors = {
    {255, 200, 0},
    {200, 200, 230},
    {200, 70, 30}
}

local columns = {}

--{name = "Wherry", prize = "5000", time = "20:20", score = "125112"},
local playersList = {}

local icons = {}

local panelWidth = 405
local panelHeight = 300

local logoWidth, logoHeight, logoTexture

local itemHeight = 60
local buttonsHeight = 60

local iconsSize = 20

local function getTimeString(value)
    local seconds = math.floor(value)
    local minutes = math.floor(seconds / 60)
    seconds = seconds - minutes * 60
    if minutes < 10 then
        minutes = "0" .. tostring(minutes)
    else
        minutes = tostring(minutes)
    end
    if seconds < 10 then
        seconds = "0" .. tostring(seconds)
    else
        seconds = tostring(seconds)
    end
    return tostring(minutes) .. ":" .. tostring(seconds)
end

local function draw()
    dxDrawRectangle(0, 0, realScreenSize.x, realScreenSize.y, tocolor(0, 0, 0, 200 * fadeProgress))
    dxSetRenderTarget(renderTarget)
    local x = (screenWidth - panelWidth) / 2
    local y = screenHeight / 2 - (panelHeight / 2 + logoHeight / 2 + 30) 
    dxDrawImage(screenWidth / 2 - logoWidth / 2, y, logoWidth, logoHeight, logoTexture, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))
    y = y + logoHeight + 16
    dxDrawRectangle(x, y, panelWidth, panelHeight, tocolor(29, 29, 29, 255 * fadeProgress))
    for i, item in ipairs(playersList) do
        local color = tocolor(29, 29, 29, 255 * fadeProgress)
        if item.isLocal then
            color = tocolor(42, 40, 41, 255 * fadeProgress)
        end
        dxDrawRectangle(x, y, panelWidth, itemHeight, color)

        local cx = x
        for j, column in ipairs(columns) do
            local iconColor = tocolor(themeColor[1], themeColor[2], themeColor[3], 255 * fadeProgress)
            if j == 1 then
                if i <= 3 and not item.nowin then
                    iconColor = tocolor(ranksColors[i][1], ranksColors[i][2], ranksColors[i][3])
                else
                    iconColor = false
                end
            end
            local text = tostring(item[column.source])
            local width = panelWidth * column.size
            if iconColor then
                dxDrawImage(cx + 10, y + itemHeight / 2 - iconsSize / 2, iconsSize, iconsSize, icons[column.icon], 0, 0, 0, iconColor)
            end
            local space = 10
            if column.space then
                space = column.space
            end
            dxDrawText(text, cx + 10 + iconsSize + space, y, cx + width, y + itemHeight, tocolor(255, 255, 255), 1, itemFont, "left", "center", true)
            cx = cx + width
        end
        y = y + itemHeight
    end

    y = y + (6 - #playersList) * itemHeight - buttonsHeight
    local buttonColor = tocolor(212, 0, 40, 255 * fadeProgress)
    local mx, my = getCursorPosition()
    if  mx and 
        mx * realScreenSize.x > x and 
        mx * realScreenSize.x < x + panelWidth and 
        my * realScreenSize.y > y and 
        my * realScreenSize.y < y + buttonsHeight 
    then
        buttonColor = tocolor(222, 20, 60, 255 * fadeProgress)
        
        if getKeyState("mouse1") then
            FinishScreen.stop()
            return
        end
    else
        --self.mouseOver = false
    end
    dxDrawRectangle(x, y, panelWidth, buttonsHeight, buttonColor)
    dxDrawText("Завершить гонку", x, y, x + panelWidth, y + buttonsHeight, tocolor(255, 255, 255), 1, itemFont, "center", "center")
    dxSetRenderTarget()
end

local function update(dt)
    dt = dt / 1000

    animationProgress = math.min(1, animationProgress + animationSpeed * dt)
    fadeProgress = math.min(1, fadeProgress + fadeSpeed * dt)

    local shake = Vector3(math.sin(animationProgress * 200), math.cos(animationProgress * 100), math.sin(animationProgress * 150)) * 0.01
    local offset = cameraStartOffset + (cameraEndOffset - cameraStartOffset) * animationProgress
    setCameraMatrix(finishPosition + shake + offset, finishPosition + shake)
end

function FinishScreen.start()
    if isActive then
        return false
    end
    isActive = true

    screenWidth, screenHeight = exports.dpUI:getScreenSize()
    addEventHandler("onClientRender", root, draw)
    addEventHandler("onClientPreRender", root, update)

    finishPosition = localPlayer.vehicle.position
    localPlayer.vehicle.velocity = Vector3(0, 0, 0)
    toggleAllControls(false)

    animationProgress = 0
    fadeProgress = 0

    renderTarget = exports.dpUI:getRenderTarget()

    icons = {}
    icons["rank"] = dxCreateTexture("assets/rank.png")
    icons["dollar"] = dxCreateTexture("assets/dollar.png")
    icons["time"] = dxCreateTexture("assets/timer.png")
    icons["score"] = dxCreateTexture("assets/score.png")

    logoTexture = exports.dpAssets:createTexture("logo.png")
    local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
    logoWidth = 415
    logoHeight = textureHeight * 415 / textureWidth 

    peds = {}
    for i = 1, pedsCount do
        local angle = i / pedsCount * math.pi * 2
        local offset = Vector3(math.cos(angle), math.sin(angle), 0) * pedsRadius + Vector3(math.random() - 0.5, math.random() - 0.5, 0) * pedsRandomRadius
        local ped = createPed(pedsSkins[math.random(1, #pedsSkins)], finishPosition + offset)
        ped.rotation = Vector3(0, 0, angle / math.pi * 180 + 90)
        table.insert(peds, ped)
    end

    itemFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)

    exports.dpHUD:setVisible(false)
    showCursor(true)
end

function FinishScreen.stop()
    if not isActive then
        return false
    end
    isActive = false

    removeEventHandler("onClientRender", root, draw)
    removeEventHandler("onClientPreRender", root, update)

    if isElement(itemFont) then
        destroyElement(itemFont)
    end

    for i, ped in ipairs(peds) do
        if isElement(ped) then
            destroyElement(ped)
        end
    end

    toggleAllControls(true)

    exports.dpHUD:setVisible(true)
    showCursor(false)
    setCameraTarget(localPlayer)
end

function FinishScreen.show(gridType)
    if not gridType then
        gridType = "default"
    end
    columns = {
        {source = "name", size = 0.5, icon = "rank"},
        {source = "prize", size = 0.25, icon = "dollar", space = 0}
    }

    if gridType == "drift" then
        table.insert(columns, {source = "score", size = 0.25, icon = "score", space = 5})
    else
        table.insert(columns, {source = "time", size = 0.25, icon = "time", space = 5})
    end

    FinishScreen.start()
end

function FinishScreen.addPlayer(player)
    table.insert(playersList, player)
end

function FinishScreen.clearPlayers()
    playersList = {}
end

addEvent("RaceLobby.playerFinished", true)
addEventHandler("RaceLobby.playerFinished", resourceRoot, function (player, prize, exp, time, score)
    FinishScreen.addPlayer({
        name = exports.dpUtils:removeHexFromString(player.name),
        prize = prize,
        time = getTimeString(time),
        score = score
    })
    if player == localPlayer then
        if type(score) == "number" then
            FinishScreen.show("drift")
        else
            FinishScreen.show("default")
        end
    end
end)