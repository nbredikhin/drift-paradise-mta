local ui = {}
local stats = {}
local maxStatsValue = 500

local function draw()
    if not admin.isPanelVisible() then
        return
    end
    if admin.getActiveTab() ~= "server" then
        return
    end
    local window = admin.getWindow()
    local x, y = guiGetPosition(window, false)
    local w, h = guiGetSize(window, false)

    x = x + 25
    y = y + 120
    w = w - 50
    h = h - 150
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200), true)

    local step = w / #stats
    local cx = x
    local cy = y + h
    local hc = 5
    for i = 0, hc do
        local tx = x
        local ty = y + h / hc * i
        dxDrawLine(x, ty, x + w, ty, tocolor(255, 255, 255, 30), 1, true)
        dxDrawText(tostring(math.floor(maxStatsValue - maxStatsValue / hc * i)), tx, ty, tx, ty, tocolor(255, 255, 255), 1, "default", "left", "top", false, false, true)        
    end
    for i, value in ipairs(stats) do
        local nx = cx + step
        local ny = y + h - value / maxStatsValue * h * 0.9
        dxDrawLine(cx, y, cx, y + h, tocolor(255, 255, 255, 30), 1, true)
        dxDrawLine(cx, cy, nx, ny, tocolor(255, 255, 255), 2, true)
        cx = nx
        cy = ny
    end
end

local function onTabOpened()
    ui.playersCountLabel.text = "Players online: " .. tostring(#getElementsByType("player"))
    ui.fpsLimitLabel.text = "FPS limit: " .. tostring(getFPSLimit())

    triggerServerEvent("dpStats.requireStats", root, "players_online")
end

addEvent("dpStats.stats", true)
addEventHandler("dpStats.stats", root, function (name, data)
    if name ~= "players_online" then
        return
    end
    if type(data) ~= "table" then
        stats = {}
    else
        stats = data
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("server", "Server")

    ui.playersCountLabel = GuiLabel(0.05, 0.05, 0.5, 0.05, "", true, ui.panel)
    ui.fpsLimitLabel = GuiLabel(0.05, 0.1, 0.5, 0.05, "", true, ui.panel)
    GuiLabel(0.05, 0.15, 0.5, 0.05, "Players online graph for last 24 hours", true, ui.panel)
    addEventHandler("onClientGUITabSwitched", ui.panel, onTabOpened, false)
    addEventHandler("dpAdmin.panelOpened", resourceRoot, onTabOpened)
    addEventHandler("onClientRender", root, draw)
end)