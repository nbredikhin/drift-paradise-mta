MAX_CHAT_LINES = 10

local Hud = {}

-- TODO: make chat prettier
function Hud.drawChat()
    local currentTab = Chat.getTab()
    if not Tab.isExists(currentTab) then
        return false
    end

    Hud.drawMessages(currentTab)
    Hud.drawTabs(currentTab)
    if Input.isActive() then
        Hud.drawInput()
    end

    return true
end

--- Draw last MAX_CHAT_LINES messages
function Hud.drawMessages(currentTab)
    local messages = Tab.getMessages(currentTab)
    local messageCount = #messages

    local firstIndex = 1
    if messageCount > MAX_CHAT_LINES then
        firstIndex = messageCount - MAX_CHAT_LINES + 1
    end

    local j = MAX_CHAT_LINES - 1
    for i = messageCount, firstIndex, -1 do
        local message = messages[i]
        dxDrawText(message.text:gsub("#%x%x%x%x%x%x", ""), 33, 33 + j * 20, 0, 0, tocolor(0, 0, 0, 255), 1.0, "default-bold", "left", "top", false, false, false, false, true)
        dxDrawText(message.text, 32, 32 + j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, true, message.colorCoded, true)
        j = j - 1
    end
end

function Hud.drawTabs(currentTab)
    local width = 32
    for i, tabName in ipairs(Tab.getAll()) do
        local text, localized = Tab.getText(tabName)
        dxDrawText(text, width, 16, 0, 0, tabName == currentTab and 0xFFFF0000 or 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, false, false, false, true)
        width = width + 4 + dxGetTextWidth(text, 1.0, "default-bold")
    end
end

function Hud.drawInput()
    dxDrawText("Say: " .. Input.getText(), 32, 32 + MAX_CHAT_LINES * 20, 0, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, false, false, false, true)
end

addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        Timer(showChat, 1000, 1, false) -- hide MTA chat
        addEventHandler("onClientRender", root, Hud.drawChat)
        bindKey("T", "down", Input.open)
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function ()
        Input.close()
        showChat(true)
    end
)
