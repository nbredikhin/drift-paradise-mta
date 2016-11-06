local canStartGame = false

local players = {}
local ball = {}
local screenSize = Vector2(guiGetScreenSize())

local size = 20
local playerSpeed = 20
local startBallSpeed = 10
local botLevel = 100
local botMaxLevel = 200
local ballSpeedMul = 1.05

local function addPlayer(x)
    local player = {
        x = x,
        y = 0,
        width = size,
        height = size * 10,
        score = 0,
        sy = 0
    }
    player.y = screenSize.y / 2 - player.height / 2
    table.insert(players, player)
    return player
end

local function drawPlayer(player)
    dxDrawRectangle(player.x, player.y, player.width, player.height)
end

local function respawnBall(ball)
    if not ball then
        return 
    end
    ball.x = screenSize.x / 2
    ball.y = screenSize.y / 2

    local angle = math.random() * math.pi / 2 - math.pi / 4
    if math.random() > 0.5 then
        angle = -angle
    end
    ball.sx = math.cos(angle) * startBallSpeed
    ball.sy = math.sin(angle) * startBallSpeed
end

local function createBall()
    local ball = {
        x = screenSize.x / 2,
        y = screenSize.y / 2,
        size = size,
        sx = 0,
        sy = 0
    }
    return ball
end

local function drawBall(ball)
    dxDrawRectangle(ball.x - ball.size / 2, ball.y - ball.size / 2, ball.size, ball.size)
end

local function newRound(winner)
    if winner then
        winner.score = winner.score + 1
    end
    respawnBall(ball)
    ball.sx = 0
    ball.sy = 0
    setTimer(function () respawnBall(ball) end, 1000, 1)
end

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0))
    dxDrawLine(screenSize.x / 2, 0, screenSize.x / 2, screenSize.y, tocolor(255, 255, 255, 50))

    dxDrawText(players[1].score, 0, 0, screenSize.x / 2 - size, 0, tocolor(255, 255, 255, 150), 4, "pricedown", "right", "top")
    dxDrawText(players[2].score, screenSize.x / 2 + size, 0, screenSize.x, 0, tocolor(255, 255, 255, 150), 4, "pricedown", "left", "top")

    for i, player in ipairs(players) do
        drawPlayer(player)
    end
    drawBall(ball)

    -- Управление
    if getKeyState("arrow_u") then
        players[1].sy = -playerSpeed
    elseif getKeyState("arrow_d") then
        players[1].sy = playerSpeed
    else
        players[1].sy = 0
    end

    -- Мяч
    ball.x = ball.x + ball.sx
    ball.y = ball.y + ball.sy    

    if ball.y - ball.size / 2 < 0 then
        ball.y = ball.size / 2
        ball.sy = -ball.sy
    elseif ball.y + ball.size / 2 > screenSize.y then
        ball.y = screenSize.y - ball.size / 2
        ball.sy = -ball.sy
    end

    for i, player in ipairs(players) do
        if ball.x <= player.x + player.width and 
            ball.x >= player.x and
            ball.y <= player.y + player.height and
            ball.y >= player.y
        then
            if ball.sx < 0 then
                ball.x = player.x + player.width + ball.size / 2
            else
                ball.x = player.x - ball.size / 2
            end
            ball.sx = -ball.sx * ballSpeedMul
            ball.sy = ball.sy * ballSpeedMul + (ball.y - (player.y + player.height / 2)) * 0.02

            botLevel = botLevel + 1
        end
    end

    if ball.x - ball.size / 2 < 0 then
        newRound(players[2])
    elseif ball.x + ball.size / 2 > screenSize.x then
        newRound(players[1])
    end

    players[2].sy = 0
    if ball.sx > 0 then
        local distance = players[2].y + players[2].height / 2 - ball.y
        local speed = playerSpeed * botLevel / botMaxLevel
        if math.abs(distance) > players[2].height * 0.4 then
            if distance > 0 then
                players[2].sy = -speed
            else
                players[2].sy = speed
            end
        end
    else
        local distance = players[2].y + players[2].height / 2 - ball.y
        if math.abs(distance) > players[2].height * 0.4 then
            if distance > 0 then
                players[2].sy = -playerSpeed * 0.2
            else
                players[2].sy = playerSpeed * 0.2
            end
        end
    end

    for i, player in ipairs(players) do
        player.y = player.y + player.sy
        if player.y < 0 then
            player.y = 0
        elseif player.y + player.height > screenSize.y then
            player.y = screenSize.y - player.height
        end
    end
end

function showGame()
    if not canStartGame then
        return
    end
    canStartGame = false
    showChat(false)

    -- Игроки
    players = {}
    addPlayer(size)
    addPlayer(screenSize.x - size * 2)

    -- Мяч
    ball = createBall()
    respawnBall(ball)

    addEventHandler("onClientRender", root, draw)
end

function hideGame()
    removeEventHandler("onClientRender", root, draw)
    canStartGame = false
    unbindKey("arrow_u", "down", showGame)
    unbindKey("arrow_d", "down", showGame)    
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    canStartGame = true
    bindKey("arrow_u", "down", showGame)
    bindKey("arrow_d", "down", showGame)
end)