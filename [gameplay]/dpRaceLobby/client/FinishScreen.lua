FinishScreen = {}
local isActive = false
local screenSize = Vector2(guiGetScreenSize())

local cameraStartOffset = Vector3(5, 5, 2)
local cameraEndOffset = Vector3(-5, 5, 1)
local animationProgress = 0
local animationSpeed = 0.02

local pedsRandomRadius = 2
local pedsSkins = {1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312}
local pedsCount = 20
local pedsRadius = 4
local peds = {}
local finishPosition = Vector3()

local mainTextFont
local listTextFont
local mainText = "Вы заняли 3 место"
local playersList = {
    "Player1",
    "Player2",
    "Player3"
}

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))
    local y = screenSize.y * 0.2
    dxDrawText(mainText, 0, y, screenSize.x, y, tocolor(255, 255, 255, 255), 1, mainTextFont, "center", "top", false, false, false, true)
    y = y + 100
    dxDrawText("Участники гонки:", 0, y, screenSize.x, y, tocolor(255, 255, 255, 255), 1, listTextFont, "center", "top", false, false, false, true)
    y = y + 40
    for i, p in ipairs(playersList) do
        dxDrawText(p, 0, y, screenSize.x, y, tocolor(255, 255, 255, 255), 1, listTextFont, "center", "top", false, false, false, true)
        y = y + 40
    end
end

local function update(dt)
    dt = dt / 1000

    animationProgress = math.min(1, animationProgress + animationSpeed * dt)

    local shake = Vector3(math.sin(animationProgress * 200), math.cos(animationProgress * 100), math.sin(animationProgress * 150)) * 0.01
    local offset = cameraStartOffset + (cameraEndOffset - cameraStartOffset) * animationProgress
    setCameraMatrix(finishPosition + shake + offset, finishPosition + shake)
end

function FinishScreen.start()
    if isActive then
        return false
    end
    isActive = true

    addEventHandler("onClientRender", root, draw)
    addEventHandler("onClientPreRender", root, update)

    finishPosition = localPlayer.vehicle.position
    localPlayer.rotation = Vector3(0, 0, 0)

    peds = {}
    for i = 1, pedsCount do
        local angle = i / pedsCount * math.pi * 2
        local offset = Vector3(math.cos(angle), math.sin(angle), 0) * pedsRadius + Vector3(math.random() - 0.5, math.random() - 0.5, 0) * pedsRandomRadius
        local ped = createPed(pedsSkins[math.random(1, #pedsSkins)], finishPosition + offset)
        ped.rotation = Vector3(0, 0, angle / math.pi * 180 + 90)
        table.insert(peds, ped)
    end

    mainTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 52)
    listTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 23)

    exports.dpHUD:setVisible(false)
end

function FinishScreen.stop()
    if not isActive then
        return false
    end
    isActive = false

    removeEventHandler("onClientRender", root, draw)
    removeEventHandler("onClientPreRender", root, update)

    if isElement(mainTextFont) then
        destroyElement(mainTextFont)
    end
    if isElement(listTextFont) then
        destroyElement(listTextFont)
    end

    for i, ped in ipairs(peds) do
        if isElement(ped) then
            destroyElement(ped)
        end
    end

    exports.dpHUD:setVisible(true)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    --FinishScreen.start()
end)