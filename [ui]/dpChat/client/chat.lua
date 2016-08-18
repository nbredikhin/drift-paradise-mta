Chat = {}

addEvent("Chat.onOutput", true)
addEventHandler("Chat.onOutput", resourceRoot,
    function (tabName, message, localized, r, g, b, colorCoded)
        if Tab.isExists(tabName) then
            Chat.output(tabName, message, localized, r, g, b, colorCoded)
        end
    end
)

--- Send message from player
function Chat.send(tabName, message, visibleTo, colorCoded)
    if not (check(tabName, "string", "tabName", "Chat.send") and
            check(message, "string", "message", "Chat.send")) then
        return false
    end
    -- Нельзя отправить сообщение в несуществующую вкладку
    if not Tab.isExists(tabName) then
        return false
    end

    visibleTo = defaultValue(visibleTo, root)
    if not isElement(visibleTo) then
        return false
    end

    -- If colorCoded not specified, set it to 'false'
    colorCoded = defaultValue(colorCoded, false)
    if not check(colorCoded, "boolean", "colorCoded", "Chat.send") then
        return false
    end

    -- Execute command
    if message:sub(1, 1) == "/" then
        local commandName = gettok(message, 1, ' '):sub(2)
        local args = message:match(" (.+)")
        executeCommandHandler(commandName, args) -- execute command on client

        -- send request to execute command on server
        return triggerServerEvent("Chat.onCommand", localPlayer, commandName, args)
    end

    -- Trim spaces
    message = removeDoubleSpaces(trimSpaces(message))

    return triggerServerEvent("Chat.onMessage", localPlayer, tabName, message, visibleTo, colorCoded)
end

--- Output message to local chat tab
function Chat.output(tabName, text, localized, r, g, b, colorCoded)
    if not (check(tabName, "string", "tabName", "Chat.output") and
            check(text, "string", "text", "Chat.output")) then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    localized = defaultValue(localized, false)
    if not check(localized, "boolean", "localized", "Chat.output") then
        return false
    end

    -- If colorCoded not specified, set it to 'false'
    colorCoded = defaultValue(colorCoded, false)
    if not check(colorCoded, "boolean", "colorCoded", "Chat.output") then
        return false
    end

    -- Set default color (white)
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
        r = 255
        g = 255
        b = 255
    end

    -- Add message to tab
    Tab.addMessage(tabName, text, localized, tocolor(r, g, b), colorCoded)

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
