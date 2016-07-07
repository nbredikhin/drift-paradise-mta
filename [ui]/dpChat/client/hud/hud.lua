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
        dxDrawText(message.text:gsub("#%x%x%x%x%x%x", ""), 33, 33 + j * 20, 0, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, false, false, false, true)
        dxDrawText(message.text, 32, 32 + j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, true, message.colorCoded, true)
        j = j - 1
    end
end

function Hud.drawTabs(currentTab)
    local scale = 1.0
    local font = "default-bold"
    local width = 32

    for i, tabName in ipairs(Tab.getAll()) do
        local tabText
        local text, localized = Tab.getText(tabName)
        if localized then
            tabText = exports.dpLang:getString(text)
        else
            tabText = text
        end
        dxDrawText(tabText:gsub("#%x%x%x%x%x%x", ""), width + 1, 17, 0, 0, 0xFF000000, scale, font, "left", "top", false, false, false, false, true)
        dxDrawText(tabText, width, 16, 0, 0, tabName == currentTab and tocolor(252, 212, 0) or 0xFFFFFFFF, scale, font, "left", "top", false, false, false, false, true)
        width = width + 4 + dxGetTextWidth(tabText, scale, font)
    end
end

function Hud.drawInput()
    local text = exports.dpLang:getString("chat_input_message") .. ": " .. Input.getText()
    local right = 32 + dxGetTextWidth(text:sub(1, 96), 1, "default-bold")
    dxDrawText(text, 33, 33 + MAX_CHAT_LINES * 20, right + 1, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, true, false, false, true)
    dxDrawText(text, 32, 32 + MAX_CHAT_LINES * 20, right, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, true, false, false, true)
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
