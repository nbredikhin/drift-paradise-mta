LOG_CHAT = (get("log_chat") == "true")

Chat = {}

addEvent("Chat.onMessage", true)
addEventHandler("Chat.onMessage", root,
    function (tabName, message, colorCoded)
        local player
        if client then
            player = client
        else
            player = source
        end

        Chat.send(player, tabName, message, colorCoded)
        if LOG_CHAT then
            outputServerLog("[Chat '" .. tabName .. "'] " .. player.name .. ": " .. tostring(message))
        end
    end
)

function Chat.getTab(player)
    return player:getData("chat_tab")
end

-- Send message from player
function Chat.send(fromPlayer, tabName, message, colorCoded)
    if not colorCoded then
        message = message:gsub("#%x%x%x%x%x%x", "")
    end

    local r, g, b = fromPlayer:getNametagColor()
    return Chat.output(tabName, fromPlayer:getName() .. ": #FFFFFF" .. tostring(message), root, r, g, b, true)
end

-- Output message to chat tab
function Chat.output(tabName, message, visibleTo, r, g, b, colorCoded)
    if not check(tabName, "string", "tabName", "Chat.output") or
        not check(message, "string", "message", "Chat.output") then
        return false
    end
    -- Set default color (white)
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
        r = 255
        g = 255
        b = 255
    end
    if visibleTo == nil then
        visibleTo = resourceRoot
    else
        if not isElement(visibleTo) then
            return false
        end
    end
    if colorCoded == nil then
        colorCoded = false
    else
        if not check(colorCoded, "boolean", "colorCoded", "Chat.output") then
            return false
        end
    end

    return triggerClientEvent(visibleTo, "Chat.onOutputChatTab", resourceRoot, tabName, tostring(message), r, g, b, colorCoded)
end

addEventHandler("onPlayerChat", root,
    function (message, messageType)
        if messageType == 0 then -- general
            triggerEvent("Chat.onMessage", source, GENERAL_TAB, message, false)
        -- elseif messageType == 1 then -- action
        --     local r, g, b = source:getNametagColor()
        --     Chat.output(Chat.getTab(source), source:getName() .. " " .. message, r, g, b, false)
        else
            cancelEvent()
        end
    end
)
