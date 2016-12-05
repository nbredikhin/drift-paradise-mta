TURN_OFF_STATION_ID = 0
HIDE_RADIO_NAME_DELAY = 2000

local enabled = true
local currentStationId = TURN_OFF_STATION_ID
local changeStationId = TURN_OFF_STATION_ID
local hideRadioNameTimer = nil
local radioNameVisible = false
local fading = false

local screenSize = Vector2(guiGetScreenSize())
local font = exports.dpAssets:createFont("Cuprum-Bold.ttf", 32, true)

local radios = {
    {localized_name = "radio_user_tracks", url = 12},
    {name = "LIVE", url = "http://giss.tv:8000/allstars_channel.mp3"},
    {name = "Radio Record", url = "http://stream.radiorecord.ru:8100/rr_aac"},
    {name = "Europa Plus", url = "http://ep128.streamr.ru"},
    {name = "D-FM", url = "http://striiming.trio.ee/dfm.mp3"},
    {name = "Dubplate.fm Dub & Bass", url = "http://sc2.dubplate.fm:5000/dubstep/192"},
    {name = "Dubplate.fm Drum 'n Bass", url = "http://sc2.dubplate.fm:5000/DnB/192"},
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
    {name = "Zaycev.FM", url = "http://zaycev.fm:9002/ZaycevFM(128)"},
    {name = "100hitz", url = "http://206.217.213.235:8170/"},
    {name = "DEFJAY", url = "http://212.45.104.39:8008/"},
    {name = "TRAP.FM", url = "http://stream.trap.fm:6002/"}
}

local radioSound = nil

_setRadioChannel = setRadioChannel

function setEnabled(toggle)
    enabled = toggle
    if enabled then
        bindRadioKeys()
        if localPlayer:isInVehicle() then
            setRadio(currentStationId)
        end
    else
        unbindRadioKeys()
        hideRadioName()
    end
end

function setRadioChannel(index)
    changeStationId = index
    _setRadioChannel(index)
end

function resetHideRadioNameTimer()
    if hideRadioNameTimer and isTimer(hideRadioNameTimer) then
        hideRadioNameTimer:destroy()
    end
end

function hideRadioName()
    radioNameVisible = false
    fading = false
    resetHideRadioNameTimer()
end

function stopRadio()
    if isElement(radioSound) then
        radioSound:stop()
    end
end

function setRadio(stationId)
    currentStationId = stationId

    if radioNameVisible then
        alpha = 255
        fading = false
    else
        alpha = 0
        targetAlpha = 255
        fading = "in"
    end

    resetHideRadioNameTimer()
    hideRadioNameTimer = Timer(function ()
        targetAlpha = 0
        fading = "out"
    end, HIDE_RADIO_NAME_DELAY, 1)
    stopRadio()

    if stationId ~= TURN_OFF_STATION_ID then
        setRadioChannel(0)
        if type(radios[stationId].url) == "number" then
            setRadioChannel(radios[stationId].url)
        else
            radioSound = Sound(radios[stationId].url)
        end
    else
        setRadioChannel(0)
    end

    radioNameVisible = true
end

function switchRadio(next)
    local nextStationId = (currentStationId + (next and 1 or -1)) % (#radios + 1)
    setRadio(nextStationId)
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
function ()
    setPlayerHudComponentVisible("radio", false)
    setRadioChannel(0)
    bindRadioKeys()
end)

function bindRadioKeys()
    bindKey("radio_next", "down", function ()
        switchRadio(true)
    end)
    bindKey("radio_previous", "down", function ()
        switchRadio(false)
    end)
end

function unbindRadioKeys()
    unbindKey("radio_next", "down")
    unbindKey("radio_previous", "down")
end

function dxDrawBorderedText(text, left, top, right, bottom, color, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI,
        colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = -1, 1 do
        for oY = -1, 1 do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, borderColor, scale, font,
                alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

local function drawRadioName()
    if enabled and radioNameVisible then
        local text
        if currentStationId == TURN_OFF_STATION_ID then
            text = exports.dpLang:getString("radio_off")
        elseif radios[currentStationId].localized_name then
            text = exports.dpLang:getString(radios[currentStationId].localized_name)
        else
            text = radios[currentStationId].name
        end

        local x, y = screenSize.x, screenSize.y * 0.1
        local r, g, b = exports.dpUI:getThemeColor()

        if fading == "out" then
            alpha = alpha + math.floor((targetAlpha - alpha) * 0.2)
            if alpha <= targetAlpha then
                hideRadioName()
            end
        elseif fading == "in" then
            alpha = alpha + math.ceil((targetAlpha - alpha) * 0.4)
            if alpha >= targetAlpha then
                fading = false
            end
        end

        dxDrawBorderedText(text, 0, 0, x, y, tocolor(r, g, b, alpha), tocolor(0, 0, 0, alpha), 1, font, "center", "center", false, false, true)
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

addEventHandler("onClientPlayerRadioSwitch", localPlayer,
    function (stationId)
        if changeStationId ~= stationId then
            cancelEvent()
        end
    end
)
