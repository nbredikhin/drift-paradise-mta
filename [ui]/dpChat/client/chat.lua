Chat = {}

addEvent("Chat.onOutputChatTab", true)
addEventHandler("Chat.onOutputChatTab", resourceRoot,
    function (tabName, message, r, g, b, colorCoded)
        if Tab.isExists(tabName) then
            Chat.output(tabName, message, r, g, b, colorCoded)
        end
    end
)

--- Send message from player
function Chat.send(tabName, message, colorCoded)
    if not check(tabName, "string", "tabName", "Chat.send") or
        not check(message, "string", "message", "Chat.send") then
        return false
    end
    -- Нельзя отправить сообщение в несуществующую вкладку
    if not Tab.isExists(tabName) then
        return false
    end

    -- If colorCoded not specified, set it to 'false'
    colorCoded = defaultValue(colorCoded, false)
    if not check(colorCoded, "boolean", "colorCoded", "Chat.send") then
        return false
    end

    -- Execute command
    if message:sub(1, 1) == "/" then
        return executeCommandHandler(gettok(message, 1, ' '):sub(2), message:match(" (.+)"))
    end
    -- Trigger event on server
    return triggerServerEvent("Chat.onMessage", localPlayer, tabName, message, colorCoded)
end

--- Output message to local chat tab
function Chat.output(tabName, text, r, g, b, colorCoded)
    if not check(tabName, "string", "tabName", "Chat.output") or
        not check(text, "string", "text", "Chat.output") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    -- Set default color (white)
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
        r = 255
        g = 255
        b = 255
    end

    -- If colorCoded not specified, set it to 'false'
    colorCoded = defaultValue(colorCoded, false)
    if not check(colorCoded, "boolean", "colorCoded", "Chat.output") then
        return false
    end

    table.insert(tabData[tabName].messages, {
        text = text,
        color = tocolor(r, g, b),
        colorCoded = colorCoded
    })

    return true
end

function Chat.getTab()
    return localPlayer:getData("chat_tab")
end

function Chat.setTab(tabName)
    if not check(tabName, "string", "tabName", "Chat.setTab") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end
    localPlayer:setData("chat_tab", tabName)

    return true
end

-- addEventHandler("onClientChatMessage", root,
--     function (text, r, g, b)
--         outputChatTab(GENERAL_TAB, text, r, g, b, true)
--         cancelEvent()
--     end
-- )
