local screenWidth, screenHeight = guiGetScreenSize()
local enabled = false
local screenSource

addEventHandler("onClientResourceStart", resourceRoot, function()
    screenSource = dxCreateScreenSource(screenWidth, screenHeight)
end)

function drawScreenSource()
    if screenSource then
        dxUpdateScreenSource(screenSource)
        dxDrawImage(screenWidth - screenWidth, screenHeight - screenHeight,  screenWidth, screenHeight, screenSource, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
end

bindKey("I", "down", function ()
    enabled = not enabled
    if enabled then
        addEventHandler("onClientRender", root, drawScreenSource)
    else
        removeEventHandler("onClientRender", root, drawScreenSource)
    end
end)
