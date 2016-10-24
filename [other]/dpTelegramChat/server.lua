local token = "243605419:AAGErNZ9_-YXx6tHiHJQAd8fzinZpuLxbFw"
local chatId = "-1001076653418"
local commands = {}

local function addCommand(cmd, description, handler)
    commands[cmd] = {
        description = description,
        handler = handler
    }
end

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

    Bot.message({
        chat_id = chatId,
        text = "*" .. playerName .. "*: " .. urlencode(text),
        parse_mode = "Markdown"
    })    
end) 

local function answerCommand(inputText)
    local command = gettok(inputText, 1, " "):sub(2)
    if command == "" or command == " " then
        return
    end
    local arguments = split(inputText, " ")
    table.remove(arguments, 1)

    if commands[command] then
        return commands[command].handler(unpack(arguments))
    end
end

addEvent("Bot.connect", false)
addEventHandler("Bot.connect", resourceRoot, function (info)
    --outputChatBox("Bot connected. Username: " .. tostring(info.username))
end)

addEvent("Bot.message", false)
addEventHandler("Bot.message", resourceRoot, function (data)
    if not data.text then
        return
    end
    if string.sub(data.text, 1, 1) == "/" then
        local message = answerCommand(data.text)
        if message then
            Bot.message({
                chat_id = data.chat.id,
                text = message,
                parse_mode = "Markdown"
            })  
        end
        return
    end

    local name = data.from.first_name
    if not name then
        name = data.from.username
    elseif data.from.last_name then
        name = data.from.first_name .. " " .. data.from.last_name
    end
    exports.dpChat:message(root, "global", "#24C8FF" .. tostring(name) .. "#FFFFFF: " .. tostring(data.text), root, 255, 255, 255, true)
end)

Bot.connect(token)

addCommand("server", "количество игроков онлайн", function ()
    local playersCount = tostring(#getElementsByType("player")) .. "/" .. tostring(getMaxPlayers())
    return urlencode("*"..tostring(getServerName()).. "*\nИгроки онлайн: *" .. tostring(playersCount) .. "*")
end)

addCommand("help", "помощь", function ()
    local text = "Бот для связи с чатом сервера. "
        .. "Все сообщения, из этого чата видны на сервере и наоборот.\n\n"
        .. "Доступные команды:\n\n"
    for name, command in pairs(commands) do
        text = text .. "/" .. tostring(name) .. " - " .. tostring(command.description) .. "\n"
    end
    return urlencode(text)
end)

addCommand("player", "информация об игроке", function (name)
    if not name then
        return
    end
    local player = exports.dpUtils:getPlayersByPartOfName(name, false)[1]
    if not isElement(player) then
        return "Игрок с таким именем не найден"
    end
    local playerName = tostring(exports.dpUtils:removeHexFromString(player.name))
    if not player:getData("_id") then
        return "Игрок " .. playerName .. " не залогинен"
    end

    local hours = tostring(math.floor((player:getData("playtime") or 0) / 60))
    local text = "Статистика игрока *" .. playerName .. "*:\n\n"
        .. "Уровень: *" .. tostring(player:getData("level")) .. "*\n"
        .. "Деньги: *$" .. tostring(player:getData("money")) .. "*\n"
        .. "Кол-во машин: *" .. tostring(player:getData("garage_cars_count")) .. "*\n"
        .. "Часов в игре: *" .. hours .. "*\n"
    return urlencode(text)
end)