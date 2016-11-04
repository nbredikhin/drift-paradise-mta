local MODEL = 3851

local UVSpeed = {-0.5, 0}
local UVResize = {1, 1}
local pSpeed = 0.5 -- pendulum speed - must be a multiplication of 0.25 value ( set 0 - to turn off )
local pMinBright = 0.35 -- minimum brightness ( 0 - 1)

local walls = {}

function showArrow(object)
    if not isElement(object) then
        return
    end
    if object.model ~= model then
        return
    end

    setObjectBreakable(object, false)
    setElementDoubleSided(object, true)

    local x, y, z = getElementPosition(object)
    local rx, ry, rz = getElementRotation(object)
    walls[object] = createObject(18000, x, y, z, rx, ry, rz)
    setElementAlpha(walls[object], 0)
    setElementParent(walls[object], object)
end

function hideArrow(object)
    if not isElement(object) then
        return
    end
    if object.model ~= MODEL then
        return
    end

    if isElement(walls[object]) then
        destroyElement(walls[object])
    end
end

addEventHandler("onClientElementStreamIn", root, function ()
    showArrow(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    hideArrow(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
    hideArrow(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local col = engineLoadCOL("1.col")
    engineReplaceCOL(col, 18000)
    local dff = engineLoadDFF("1.dff")
    engineReplaceModel(dff, 18000) 

    local shader = dxCreateShader("shader.fx")
    local texture = dxCreateTexture("arrow.png","dxt5")

    dxSetShaderValue(shader,"Tex",texture)
    dxSetShaderValue(shader,"UVSpeed", UVSpeed)
    dxSetShaderValue(shader,"UVResize", UVResize)
    dxSetShaderValue(shader,"pSpeed", pSpeed)
    dxSetShaderValue(shader,"pMinBright", pMinBright)

    engineApplyShaderToWorldTexture(shader,"ws_carshowwin1")
    engineSetModelLODDistance(MODEL, 300)

    for i, object in ipairs(getElementsByType("object")) do
        if object.model == MODEL and isElementStreamedIn(object) then
            showArrow(object)
        end
    end
end)

addEventHandler("onClientObjectBreak", root, function()
    if getElementModel(source) == MODEL then
        cancelEvent()
    end
end)