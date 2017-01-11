local ui = {}
local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(350, 510) * 1.2

local tuningFieldsList = {
    {data="FrontBump",   type="ComboBox"},
    {data="RearBump",    type="ComboBox"},
    {data="SideSkirts",  type="ComboBox"},
    {data="Bonnets",     type="ComboBox"},
    
    {data="FrontFends",  type="ComboBox"},
    {data="RearFends",   type="ComboBox"},
    {data="WheelsAngleF",   type="ScrollBar"},
    {data="WheelsAngleR",   type="ScrollBar"},
    {data="WheelsSize",     type="ScrollBar", default=0.6},
    {data="WheelsWidthF",   type="ScrollBar"},    
    {data="Exhaust",     type="ComboBox"},
    {data="Acces",       type="ComboBox"},
    {data="Spoilers",    type="ComboBox"},

    {data="FrontLights",  type="ComboBox"},
    {data="RearLights",  type="ComboBox"},
    {data="WheelsF",        type="ComboBox"},
    {data="WheelsR",        type="ComboBox"},
    {data="WheelsWidthR",   type="ScrollBar"},
    {data="WheelsOffsetF",  type="ScrollBar"},
    {data="WheelsOffsetR",  type="ScrollBar"},    
}

function togglePanel()
    local visible = not ui.window.visible
    if ui.window.visible == visible then
        return 
    end
    ui.window.visible = visible
    showCursor(visible)
    if visible then
        triggerEvent("dpAdmin.panelOpened", resourceRoot)
    else
        triggerEvent("dpAdmin.panelClosed", resourceRoot)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.window = GuiWindow(
        (screenSize.x - windowSize.x) / 2, 
        (screenSize.y - windowSize.y) / 2,
        windowSize.x,
        windowSize.y, 
        "Tuning editor", 
        false)
    ui.window.visible = false

    local y = 0.05
    local x = 0.05
    local width = 0.45
    for i, field in ipairs(tuningFieldsList) do
        local guiElement
        GuiLabel(x, y, width, 0.05, field.data, true, ui.window)
        y = y + 0.04
        if field.type == "ComboBox" then
            guiElement = GuiComboBox(x, y, width, 0.3, field.data, true, ui.window)
            for j = 0, 25 do
                guiElement:addItem(tostring(j))
            end
        elseif field.type == "ScrollBar" then
            guiElement = GuiScrollBar(x, y, width, 0.05, true, true, ui.window)
            if field.default then
                guiElement:setScrollPosition(100 * field.default)
            end
        end
        y = y + 0.05
        if y > 0.95 then
            x = x + width + 0.05
            y = 0.05
        end
        field.guiElement = guiElement
    end

    setTimer(function ()
        if not localPlayer.vehicle then
            return
        end
        for i, field in ipairs(tuningFieldsList) do
            local dataValue = false
            if field.type == "ComboBox" then
                dataValue = math.max(0, field.guiElement:getSelected())
            elseif field.type == "ScrollBar" then
                dataValue = field.guiElement:getScrollPosition() / 100
            end
            localPlayer.vehicle:setData(field.data, dataValue, true)
        end
    end, 50, 0)
end)

bindKey("n", "down", togglePanel)