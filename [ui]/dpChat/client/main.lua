import("Lang", "dpLang")
import("Config", "dpConfig")

-- Add and set general tab
addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        Tab.add(GENERAL_TAB, "chat_tab_general", true)
        Chat.setTab(GENERAL_TAB)
    end
)

addCommandHandler("ts",
    function (commandName)
        Hud.setTimestampVisible(not Hud.isTimestampVisible())
    end
)
