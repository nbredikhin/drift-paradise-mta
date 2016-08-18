LOG_CHAT = (get("log_chat") == "true")
LOG_COMMANDS = (get("log_commands") == "true")

Chat = {}

addEvent("Chat.onMessage", true)
addEventHandler("Chat.onMessage", root,
    function (tabName, message, visibleTo, colorCoded)
        local player
        if client then
            player = client
        else
            player = source
        end

        Chat.send(player, tabName, message, visibleTo, colorCoded)
        if LOG_CHAT then
            outputServerLog("[CHAT '" .. tabName .. "'] " .. player.name .. ": " .. tostring(message))
        end
    end
)

addEvent("Chat.onCommand", true)
addEventHandler("Chat.onCommand", root,
    function (commandName, args)
        local player
        if client then
            player = client
        else
            player = source
        end

        executeCommandHandler(commandName, player, args) -- execute command on server

        if LOG_COMMANDS then
            outputServerLog("[COMMAND] " .. player.name .. ": " .. tostring(commandName))
        end
    end
)

function Chat.getTab(player)
    return player:getData("chat_tab")
end

-- Send message from player
function Chat.send(fromPlayer, tabName, message, visibleTo, colorCoded)
    if not (isElement(fromPlayer) and fromPlayer:getType() == "player" and
            check(tabName, "string", "tabName", "Chat.send") and
            check(message, "string", "message", "Chat.send")) then
        return false
    end

    visibleTo = defaultValue(visibleTo, root)
    if not isElement(visibleTo) then
        return false
    end

    colorCoded = defaultValue(colorCoded, false)
    if not check(colorCoded, "boolean", "colorCoded", "Chat.output") then
        return false
    end

    if not colorCoded then
        message = message:gsub("#%x%x%x%x%x%x", "")
    end

    local r, g, b = fromPlayer:getNametagColor()
    return Chat.output(tabName, fromPlayer:getName() .. ": #FFFFFF" .. tostring(message), false, visibleTo, r, g, b, true)
end

-- Output message to chat tab
function Chat.output(tabName, text, localized, visibleTo, r, g, b, colorCoded)
    if not (check(tabName, "string", "tabName", "Chat.output") and
            check(text, "string", "text", "Chat.output")) then
        return false
    end

    localized = defaultValue(localized, false)
    if not check(localized, "boolean", "localized", "Chat.output") then
        return false
    end

    visibleTo = defaultValue(visibleTo, root)
    if not isElement(visibleTo) then
        return false
    end

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

    return triggerClientEvent(visibleTo, "Chat.onOutput", resourceRoot, tabName, tostring(text), localized, r, g, b, colorCoded)
end

addEventHandler("onPlayerChat", root,
    function (message, messageType)
        if messageType == 0 then -- general
            triggerEvent("Chat.onMessage", source, GENERAL_TAB, message, false)
        end
        cancelEvent()
    end
)
