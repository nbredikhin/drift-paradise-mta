local SPAM_INTERVAL = 2
local SPAM_COLOR = "#FFAA00"
local spamMessages = {
    "* Вступайте в нашу группу: #FFFFFFvk.com/drivecrew",
    "* Премиум можно купить здесь: #FFFFFFdrivecrew.ru"
}
local currentMessage = 1

setTimer(function ()
    message(root, "global", SPAM_COLOR .. tostring(spamMessages[currentMessage]))
    currentMessage = currentMessage + 1
    if currentMessage > #spamMessages then
        currentMessage = 1
    end
end, SPAM_INTERVAL * 1000 * 60, 0)