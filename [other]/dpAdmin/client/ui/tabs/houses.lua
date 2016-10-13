local ui = {}

local currentDoorPosition = Vector3()
local currentDoorRotation = 0
local currentGaragePosition = Vector3()
local currentGarageRotation = 0

local scriptString = [[    {
        price = %s,
        data = {
            interior = %s,
            enter = {%s},
            enter_rotation = {%s},
            garage = {%s},
            garage_rotation = {%s}
        }   
    },
]]

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = admin.ui.addTab("houses", "Houses")

    local x = 0.03
    local y = 0.05
    local height = 0.04    
    ui.doorPositionLabel = GuiLabel(x, y, 0.8, height, "Door position:", true, ui.panel)
    GuiLabel(0.7, y, 0.5, height, "Price:", true, ui.panel)
    y = y + height * 1.5
    ui.doorPositionButton = GuiButton(x, y, 0.2, height * 2, "Set position", true, ui.panel)
    ui.priceEdit = GuiEdit(0.7, y, 0.2, height * 2, "1000000", true, ui.panel)
    y = y + height * 2.5
    ui.garagePositionLabel = GuiLabel(x, y, 0.7 - x, height, "Garage position:", true, ui.panel)
    GuiLabel(0.7, y, 0.5, height, "Interior:", true, ui.panel)
    y = y + height * 1.5
    ui.garagePositionButton = GuiButton(x, y, 0.2, height * 2, "Set position", true, ui.panel)
    ui.interiorEdit = GuiEdit(0.7, y, 0.2, height * 2, "3", true, ui.panel)
    y = y + height * 3
    ui.createButton = GuiButton(x, y, 0.3, height * 2, "Create house", true, ui.panel)   
    y = y + height * 2.5
    ui.outputMemo = GuiMemo(x, y, 1 - x * 2, 0.95 - y, "", true, ui.panel)
    ui.outputMemo:setReadOnly(true)

    addEventHandler("onClientGUIClick", ui.doorPositionButton, function ()
        currentDoorPosition = localPlayer.position
        currentDoorRotation = localPlayer.rotation.z
        ui.doorPositionLabel.text = "Door position: " .. tostring(currentDoorPosition)
    end, false)

    addEventHandler("onClientGUIClick", ui.garagePositionButton, function ()
        currentGaragePosition = localPlayer.position
        currentGarageRotation = localPlayer.rotation.z
        ui.garagePositionLabel.text = "Garage position: " .. tostring(currentGaragePosition)
    end, false)        

    addEventHandler("onClientGUIClick", ui.createButton, function ()
        local doorPositionString = table.concat({currentDoorPosition.x, currentDoorPosition.y, currentDoorPosition.z}, ",")
        local garagePositionString = table.concat({currentGaragePosition.x, currentGaragePosition.y, currentGaragePosition.z}, ",")
        ui.outputMemo.text = string.format(
            scriptString, 
            ui.priceEdit.text, 
            ui.interiorEdit.text, 
            doorPositionString, 
            tostring(currentDoorRotation),
            garagePositionString,
            tostring(currentGarageRotation))
    end, false)            
end)