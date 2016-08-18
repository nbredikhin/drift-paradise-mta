GENERAL_TAB = "general"

Tab = {}

local tabData = {}

addEvent("Chat.onTabAdd")
addEvent("Chat.onTabRemove")

function Tab.getAll()
    local tabs = {}
    for tabName in pairs(tabData) do
        table.insert(tabs, tabName)
    end
    return tabs
end

function Tab.isExists(tabName)
    return (type(tabData[tabName]) == "table")
end

function Tab.add(tabName, text, localized)
    if not check(tabName, "string", "tabName", "Tab.add") or
        not check(text, "string", "text", "Tab.add") then
        return false
    end
    if Tab.isExists(tabName) then
        return false
    end
    if localized == nil then
        localized = true
    else
        if not check(localized, "boolean", "localized", "Tab.add") then
            return false
        end
    end

    if triggerEvent("Chat.onTabAdd", localPlayer, tabName, text, localized) then
        -- Initialize data
        tabData[tabName] = {
            text = text,
            localized = localized,
            messages = {}
        }
    else
        return false
    end

    return true
end

function Tab.remove(tabName)
    if not check(tabName, "string", "tabName", "Tab.remove") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end
    -- Нельзя удалить вкладку с основным чатом
    if tabName == GENERAL_TAB then
        return false
    end

    if triggerEvent("Chat.onTabRemove", localPlayer, tabName) then
        -- Установить основной чат, если была удалена открытая вкладка
        if Chat.getTab() == tabName then
            Chat.setTab(GENERAL_TAB)
        end

        -- Remove data
        tabData[tabName] = nil
    else
        return false
    end

    return true
end

function Tab.addMessage(tabName, text, localized, color, colorCoded)
    if not check(tabName, "string", "tabName", "Tab.addMessage") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    if not check(text, "string", "text", "Tab.addMessage") then
        return false
    end

    if not check(localized, "boolean", "localized", "Tab.addMessage") then
        return false
    end

    table.insert(tabData[tabName].messages, {
        text = text,
        localized = localized,
        color = color,
        colorCoded = colorCoded,
        timestamp = getRealTime().timestamp
    })

    return true
end

-- Clear all messages from tab
function Tab.clearMessages(tabName)
    if not check(tabName, "string", "tabName", "Tab.addMessage") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    for i in ipairs(tabData[tabName].messages) do
        tabData[tabName].messages[i] = nil
    end

    return true
end

function Tab.getMessages(tabName)
    if not check(tabName, "string", "tabName", "Tab.getMessages") then
        return false
    end

    tabName = defaultValue(tabName, Chat.getTab())

    if not Tab.isExists(tabName) then
        return false
    end

    return tabData[tabName].messages
end


function Tab.getText(tabName)
    if not check(tabName, "string", "tabName", "Tab.getText") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    return tabData[tabName].text, tabData[tabName].localized
end

function Tab.isLocalized(tabName)
    if not check(tabName, "string", "tabName", "Tab.isLocalized") then
        return false
    end
    if not Tab.isExists(tabName) then
        return false
    end

    return tabData[tabName].localized
end
