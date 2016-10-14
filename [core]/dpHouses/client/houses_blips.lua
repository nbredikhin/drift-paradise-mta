local visibleBlips = {}

local function attachBlipToMarker(marker)
    if not isElementStreamedIn(marker) then
        return false
    end
    if not marker:getData("house_data") then
        return 
    end    
    if marker:getData("owner_id") then
        return
    end

    visibleBlips[marker] = Blip(0, 0, 0, 31)
    visibleBlips[marker]:setData("hiddenOnWorldMap", true)
    attachElements(visibleBlips[marker], marker)
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type ~= "marker" then
        return false
    end
    attachBlipToMarker(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if source.type ~= "marker" then
        return false
    end
    local marker = source
    if not marker:getData("house_data") then
        return 
    end
    if marker:getData("owner_id") then
        return
    end

    if isElement(visibleBlips[marker]) then
        destroyElement(visibleBlips[marker])
        visibleBlips[marker] = nil
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, marker in ipairs(getElementsByType("marker")) do
        attachBlipToMarker(marker)
    end
end)

addEventHandler("onClientElementDataChange", root, function (dataName)
    if dataName ~= "owner_id" then
        return
    end
    if isElement(visibleBlips[source]) then
        if source:getData("owner_id") then
            destroyElement(visibleBlips[source])
            visibleBlips[source] = nil
        else
            attachBlipToMarker(source)
        end
    end
end)