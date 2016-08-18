MAX_CHAT_LINES = 10

Hud = {}

local hudVisible = false
local timestampVisible = Config.getProperty("chat.timestamp")
local tabs = {}

addEventHandler("Chat.onTabAdd", localPlayer,
    function (tabName)
        table.insert(tabs, tabName)
    end
)

addEventHandler("Chat.onTabRemove", localPlayer,
    function (tabName)
        for i, _tabName in ipairs(tabs) do
            if tabName == _tabName then
                table.remove(tabs, i)
                break
            end
        end
    end
)

function Hud.setVisible(visible)
    if not check(visible, "boolean", "visible", "Hud.setVisible") then
        return false
    end

    if visible ~= hudVisible then
        if visible then
            addEventHandler("onClientRender", root, drawChat)
            bindKey("T", "down", Input.open)
        else
            removeEventHandler("onClientRender", root, drawChat)
            unbindKey("T", "down", Input.open)
            Input.close()
        end
    end

    hudVisible = visible

    return true
end

function Hud.isVisible()
    return hudVisible
end

function Hud.setTimestampVisible(visible)
    if not check(visible, "boolean", "visible", "Hud.setTimestampVisible") then
        return false
    end

    timestampVisible = visible
    Config.setProperty("chat.timestamp", visible)
end

function Hud.isTimestampVisible()
    return timestampVisible
end

-- TODO: make chat prettier
function drawChat()
    if not isImported("dpLang") then
        return false
    end

    local currentTab = Chat.getTab()
    if not Tab.isExists(currentTab) then
        return false
    end

    drawTabs(currentTab)
    drawMessages(currentTab)
    if Input.isActive() then
        drawInput()
    end

    return true
end

--- Draw last MAX_CHAT_LINES messages
function drawMessages(currentTab)
    local messages = Tab.getMessages(currentTab)
    local messageCount = #messages

    local firstIndex = 1
    if messageCount > MAX_CHAT_LINES then
        firstIndex = messageCount - MAX_CHAT_LINES + 1
    end

    local j = MAX_CHAT_LINES - 1
    for i = messageCount, firstIndex, -1 do
        local message = messages[i]
        local text
        if message.localized then
            text = tostring(Lang.getString(message.text))
        else
            text = message.text
        end
        if timestampVisible then
            local realTime = getRealTime(message.timestamp)
            text = string.format("[%02d:%02d:%02d] ", realTime.hour, realTime.minute, realTime.second) .. text
        end
        dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), 33, 33 + j * 20, 0, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, false, false, false, true)
        dxDrawText(text, 32, 32 + j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, false, message.colorCoded, true)
        j = j - 1
    end

    return true
end

function drawTabs(currentTab)
    local scale = 1.0
    local font = "default-bold"
    local width = 32

    for i, tabName in ipairs(tabs) do
        local tabText
        local text, localized = Tab.getText(tabName)
        if localized then
            tabText = Lang.getString(text)
        else
            tabText = text
        end
        dxDrawText(tabText:gsub("#%x%x%x%x%x%x", ""), width + 1, 17, 0, 0, 0xFF000000, scale, font, "left", "top", false, false, false, false, true)
        dxDrawText(tabText, width, 16, 0, 0, tabName == currentTab and tocolor(252, 212, 0) or 0xFFFFFFFF, scale, font, "left", "top", false, false, false, true, true)
        width = width + 4 + dxGetTextWidth(tabText, scale, font)
    end

    return true
end

function drawInput()
    local text = Lang.getString("chat_input_message") .. ": " .. Input.getText()
    local right = 32 + dxGetTextWidth(text:sub(1, 96), 1, "default-bold")
    dxDrawText(text, 33, 33 + MAX_CHAT_LINES * 20, right + 1, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, true, false, false, true)
    dxDrawText(text, 32, 32 + MAX_CHAT_LINES * 20, right, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, true, false, false, true)

    return true
end

addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        Timer(showChat, 1000, 1, false) -- hide MTA chat
        Hud.setVisible(true)
        bindKey("F7", "down",
            function ()
                Hud.setVisible(not Hud.isVisible())
            end
        )
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function ()
        Input.close()
        showChat(true)
    end
)
