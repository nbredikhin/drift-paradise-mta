TURN_OFF_STATION_ID = 0

local currentStationId = TURN_OFF_STATION_ID
local hideRadioNameTimer = nil
local radioNameVisible = false

local screenSize = Vector2(guiGetScreenSize())
local font = exports.dpAssets:createFont("Cuprum-Bold.ttf", 32, true)

local radios = {
    {name = "YO.FM", url = "http://air.radiorecord.ru:8102/yo_320"},
    {name = "GOP.FM", url = "http://online.radiorecord.ru:8102/gop_128"},
    {name = "Dorojnoe Radio", url = "http://dorognoe48.streamr.ru"},
    {name = "ChartHits.FM", url = "http://95.141.24.3:80/"},
    {name = "Real Dance Radio", url = "http://uk4.internet-radio.com:10138/"},
    {name = "Big R Radio-80s Metal FM", url = "http://107.155.111.234:18310/"},
    {name = "TOP100RAP", url = "http://radio-tochka.com:6570"},
    {name = "1.FM Trance Radio", url = "http://sc8.1.fm:7706/"},
    {name = "GoHamRadioTrance", url = "http://uk4.internet-radio.com:15938/"},
    {name = "Hay.FM Yerevan", url = "http://hayfm.am:8000/HayFm"},
    {name = "Big B Radio #JPOP", url = "http://62.75.253.56:8012/"},
    {name = "Maximum.FM", url = "http://maximum.fmtuner.ru/96kbit/s"},
    {name = "Radio Record", url = "http://stream.radiorecord.ru:8100/rr_aac"},
    {name = "Europa Plus", url = "http://ep128.streamr.ru"},
    {name = "D-FM", url = "http://striiming.trio.ee/dfm.mp3"},
    {name = "Zaycev.FM", url = "http://zaycev.fm:9002/ZaycevFM(128)"},
    {name = "100hitz", url = "http://206.217.213.235:8170/"},
    {name = "DEFJAY", url = "http://212.45.104.39:8008/"},
    {name = "TRAP.FM", url = "http://stream.trap.fm:6002/"},
    {name = "LIVE", url = "http://giss.tv:8000/allstars_channel.mp3"}
}

local radioSound = nil

function resetTimer()
    radioNameVisible = false
end


local function stopRadio()
    if isElement(radioSound) then
        radioSound:stop()
    end
end

local function setRadio(stationId)
    radioNameVisible = true
    currentStationId = stationId

    if hideRadioNameTimer and isTimer(hideRadioNameTimer) then
        hideRadioNameTimer:destroy()
    end
    hideRadioNameTimer = Timer(resetTimer, 2000, 1)
    stopRadio()

    if stationId ~= TURN_OFF_STATION_ID then
        setRadioChannel(0)
        radioSound = Sound(radios[stationId].url)
    end
end

local function switchRadio(next)
    local nextStationId = (currentStationId + (next and 1 or -1)) % (#radios)
    setRadio(nextStationId)
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
function ()
    setPlayerHudComponentVisible("radio", false)
    setRadioChannel(0)

    bindKey("radio_next", "down", function ()
        switchRadio(true)
    end)
    bindKey("radio_previous", "down", function ()
        switchRadio(false)
    end)

end)

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI,
        colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = -1, 1 do
        for oY = -1, 1 do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font,
                alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

local function drawRadioName()
    if radioNameVisible then
        local text
        if currentStationId == TURN_OFF_STATION_ID then
            text = exports.dpLang:getString("radio_off")
        else
            text = radios[currentStationId].name
        end

        local x, y = screenSize.x, screenSize.y * 0.1
        dxDrawBorderedText(text, 0, 0, x, y, tocolor(exports.dpUI:getThemeColor()), 1, font, "center", "center", false, false, true)
    end
end

addEventHandler("onClientRender", root, drawRadioName)

addEventHandler("onClientVehicleExit", root,
    function (player)
        if localPlayer == player then
            stopRadio()
        end
    end
)

addEventHandler("onClientVehicleEnter", root,
    function (player)
        if localPlayer == player then
            setRadio(currentStationId)
        end
    end
)

addEventHandler("onClientElementDestroy", root,
    function ()
        if source and getElementType(source) == "vehicle" then
            if source == localPlayer.o then
                stopRadio()
            end
        end
    end
)

addEventHandler("onClientVehicleExplode", root,
    function ()
        if source and getElementType(source) == "vehicle" then
            if source == localPlayer.vehicle then
                stopRadio()
            end
        end
    end
)
