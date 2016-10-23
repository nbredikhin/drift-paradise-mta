local token = "241831895:AAEsjJyrJKZ7s4f3S3OosJkjpCebt2-Q8a8"
local chats = {}

addEvent("dpChat.message", true)
addEventHandler("dpChat.message", root, function (player, tabName, text)
    if not isElement(player) then
        return
    end
    if tabName ~= "global" then
        return false
    end
    if player.type ~= "player" then
        return
    end
    
    local playerName = exports.dpUtils:removeHexFromString(player.name)

    for chat_id in pairs(chats) do
        Bot.message({
            chat_id = chat_id,
            text = "*" .. playerName .. "*: " .. text,
            parse_mode = "Markdown"
        })    
    end
end)

addEvent("Bot.connect", false)
addEventHandler("Bot.connect", resourceRoot, function (info)
    --outputChatBox("Bot connected. Username: " .. tostring(info.username))
end)

addEvent("Bot.message", false)
addEventHandler("Bot.message", resourceRoot, function (data)
    if not data.text then
        return
    end
    chats[data.chat.id] = true

    local name = data.from.first_name
    if not name then
        name = data.from.username
    elseif data.from.last_name then
        name = data.from.first_name .. " " .. data.from.last_name
    end
    exports.dpChat:message(root, "global", "#24C8FF" .. tostring(name) .. "#FFFFFF: " .. tostring(data.text), root, 255, 255, 255, true)
end)

Bot.connect(token)