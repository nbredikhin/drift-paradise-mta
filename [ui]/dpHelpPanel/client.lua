local UI = exports.dpUI

local isVisible = false
local screenWidth, screenHeight = UI:getScreenSize()
local width = 640
local height = 480
local tabWidth
local tabHeight = 50
local ui = {}
local tabs = {
    {
        name = "Основное",
        text = "ОСНОВНЫЕ КЛАВИШИ\nF1 - основная панель, телепорты, настройки\nF2 - включить/выключить курсор.\n1 - включить/выключить фары\n2 - включить/выключить дрифт-режим (сначала нужно купить)\nO - фоторежим\nI - скрыть/показать интерфейс\n\nУРОВЕНЬ И ПРОКАЧКА\nНа Drift Paradise у каждого игрока есть уровень, от которого зависит количество доступных ему возможностей, таких как машины, детали тюнига, наклейки и т. д. Для того, чтобы быстро прокачать уровень, Вам необходимо участвовать в гонках против других игроков."
    },
    {
        name = "Гараж",
        text = "Гараж - место, где всегда находятся все Ваши автомобили. Здесь вы также можете продать свою машину. В разделе тюнинга вы можете кастомизировать свой автомобиль: сменить покраску, устанвоить спойлеры или обвесы, создать винил и улучшить характеристики. Некоторые разделы тюнинга открываются после достижения определённого уровня.\n\nТЮНИНГ\nКомпоненты - установка дисков, обвесов, спойлера, капота, смена номерного знака.\nПокраска - изменение цвета кузова, дисков, спойлера.\nВинилы - создание и редактирование наклеек.\nКонфигурация - улучшение характеристик автомобиля, изменение высоты подвески, радиуса, вылета и развала колёс."
    },    
    {
        name = "Гонки и дуэли",
        text = "На сервере существуют различные виды гонок. Для того, чтобы легко найти гонку, Вы можете воспользоваться картой. Они находятся в случайных точках города и периодически меняются. Гонки являются наиболее эффективным способом заработка денег и получения опыта.\n\nПомимо обычных гонок со случайными противниками, вы можете вызвать определенного игрока на дуэль. Для этого подъедте к игроку, нажмите F2 -> ПКМ по игроку -> \"Вызвать на гонку\".\nЕсли игрок примет вызов, начнётся гонка 1 на 1. За дуэли не даётся опыт."
    },
    {
        name = "Дополнительно",
        text = "Используя F2, вы можете включать курсор и нажимать правой кнопкой мыши на игроков или автомобили, чтобы открыть меню дополнительных действий."
    } 
}

local function showTab(index)
    if not tabs[index] then
        return false
    end

    for i, tab in ipairs(tabs) do
        if tab.button then
            UI:setType(tab.button, "default_dark")
        end
    end
    local tab = tabs[index]
    UI:setType(tab.button, "primary")
    UI:setText(ui.textLabel, exports.dpLang:getString(tab.text))
end

function show()
    if localPlayer:getData("activeUI") then
        return false
    end
    if isVisible then
        return false
    end
    isVisible = true
    localPlayer:setData("activeUI", "helpPanel")
    showCursor(true)
    exports.dpUI:fadeScreen(true)
    UI:setVisible(ui.panel, true)
end

function hide()
    if not isVisible then
        return false
    end
    isVisible = false
    localPlayer:setData("activeUI", false)
    showCursor(false)
    exports.dpUI:fadeScreen(false)
    UI:setVisible(ui.panel, false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    if localPlayer:getData("activeUI") == "helpPanel" then
        localPlayer:setData("activeUI", false)
    end

    ui.panel = UI:createDpPanel {
        x = (screenWidth - width) / 2,
        y = (screenHeight - height) / 1.7,
        width = width,
        height = height,
        type = "light"
    }
    UI:addChild(ui.panel)

    tabWidth = width / #tabs
    for i, tab in ipairs(tabs) do
        tab.button = UI:createDpButton {
            x = (i - 1) * tabWidth,
            y = 0,
            width = tabWidth,
            height = tabHeight,
            type = "default_dark",
            fontType = "defaultSmall",
            locale = tab.name
        }
        UI:addChild(ui.panel, tab.button)
    end

    ui.textLabel = UI:createDpLabel({
        x = 20 , y = tabHeight + 20,
        width = width - 40, height = height,
        type = "dark",
        fontType = "default",
        text = "...",
        alignX = "left",
        alignY = "top",
        wordBreak = true
    })
    UI:addChild(ui.panel, ui.textLabel)     

    UI:setVisible(ui.panel, false)

    showTab(1)
end)

bindKey("f9", "down", function ()
    if not isVisible then
        show()
    else
        hide()
    end
end)

bindKey("f1", "down", function ()
    if isVisible then
        hide()
    end
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
    for i, tab in ipairs(tabs) do
        if tab.button == widget then
            showTab(i)
            exports.dpSounds:playSound("ui_select.wav")
            return
        end
    end 
end)

function setVisible(visible)
    if visible then
        return show()
    else
        return hide()
    end
end