addCommandHandler("settab",
    function (commandName, tabName)
        if Chat.setTab(tabName) then
            Chat.output(Chat.getTab(), "Tab set to " .. tabName)
        else
            Chat.output(Chat.getTab(), "Failed to set tab to " .. tabName)
        end
    end
)

addCommandHandler("gettab",
    function (commandName, tabName)
        Chat.output(Chat.getTab(), Chat.getTab())
    end
)

addCommandHandler("send",
    function (commandName, tabName, message)
        Chat.send(tabName, message)
    end
)

addCommandHandler("sendtab",
    function (commandName, message)
        Chat.send(Chat.getTab(), message)
    end
)

addCommandHandler("addtab",
    function (commandName, tabName, text)
        Tab.add(tabName, text)
    end
)

addCommandHandler("removetab",
    function (commandName, tabName)
        Tab.remove(tabName)
    end
)
