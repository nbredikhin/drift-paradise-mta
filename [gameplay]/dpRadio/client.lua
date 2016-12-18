TURN_OFF_STATION_ID = 0
HIDE_RADIO_NAME_DELAY = 3000

local enabled = true
local currentStationId = TURN_OFF_STATION_ID
local changeStationId = TURN_OFF_STATION_ID

local hideRadioNameTimer = nil
local radioNameVisible = false
local fading = false

local screenSize = Vector2(guiGetScreenSize())
local font = exports.dpAssets:createFont("Cuprum-Bold.ttf", 32, true)
local secondFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 16, true)

local radios = {
    {localized_name = "radio_user_tracks", url = 12},
    {name = "Drift Paradise Radio", url="http://stream.radio-hosting.net:8000/dpradio"},
    {name = "BBC 1Xtra", url = "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p"},
    {name = "Radio Record", url = "http://stream.radiorecord.ru:8100/rr_aac"},
    {name = "Europa Plus", url = "http://ep128.streamr.ru"},
    {name = "D-FM", url = "http://striiming.trio.ee/dfm.mp3"},
    {name = "Good Company Radio", url = "http://uk4.internet-radio.com:10104/"},
    {name = "Dubplate.fm Dub & Bass", url = "http://sc2.dubplate.fm:5000/dubstep/192"},
    {name = "Dubplate.fm Drum 'n Bass", url = "http://sc2.dubplate.fm:5000/DnB/192"},
    {name = "Gangsta & Hip-Hop.101", url = "http://ic3.101.ru:8000/c14_11"},
    {name = "TOP100RAP", url = "http://radio-tochka.com:6570"},
    {name = "YO.FM", url = "http://air.radiorecord.ru:8102/yo_320"},
    {name = "GOP.FM", url = "http://online.radiorecord.ru:8102/gop_128"},
    {name = "Dorojnoe Radio", url = "http://dorognoe48.streamr.ru"},
    {name = "Real Dance Radio", url = "http://uk4.internet-radio.com:10138/"},
    {name = "Big R Radio-80s Metal FM", url = "http://107.155.111.234:18310/"},
    {name = "GoHamRadioTrance", url = "http://uk4.internet-radio.com:15938/"},
    {name = "1.FM Trance Radio", url = "http://sc8.1.fm:7706/"},
    {name = "Big B Radio #JPOP", url = "http://62.75.253.56:8012/"},
    {name = "Zaycev.FM", url = "http://zaycev.fm:9002/ZaycevFM(128)"},
    {name = "100hitz", url = "http://206.217.213.235:8170/"},
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

function showRadioName()
    if not localPlayer:getData("dpCore.state") and not localPlayer:getData("activeUI") then
        if radioNameVisible then
            alphaProgress = 1.0
            fading = false
        else
            alphaProgress = 0.0
            fading = "in"
        end

        resetHideRadioNameTimer()
        hideRadioNameTimer = Timer(function ()
            fading = "out"
        end, HIDE_RADIO_NAME_DELAY, 1)

        radioNameVisible = true
    end
end

function setRadio(stationId)
    currentStationId = stationId

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

    showRadioName()
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
    bindKey("z", "down", showRadioName)
end

function unbindRadioKeys()
    unbindKey("radio_next", "down")
    unbindKey("radio_previous", "down")
    unbindKey("z", "down", showRadioName)
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

        local r, g, b = exports.dpUI:getThemeColor()

        if fading == "out" then
            alphaProgress = math.max(0, alphaProgress - (15 / 100))
            if alphaProgress <= 0.0 then
                hideRadioName()
            end
        elseif fading == "in" then
            alphaProgress = math.min(1, alphaProgress + (30 / 100))
            if alphaProgress >= 1.0 then
                fading = false
            end
        end

        local x, y = screenSize.x, screenSize.y * 0.1
        dxDrawBorderedText(text, 0, 0, x, y, tocolor(r, g, b, 255 * alphaProgress), tocolor(0, 0, 0, 100 * alphaProgress), 1, font, "center", "center", false, false, true)

        if isElement(radioSound) then
            local metaTags = radioSound:getMetaTags()
            if metaTags.stream_title then
                dxDrawBorderedText(metaTags.stream_title, 0, 0, x, screenSize.y * 0.18, tocolor(r, g, b, 255 * alphaProgress), tocolor(0, 0, 0, 100 * alphaProgress), 1, secondFont, "center", "center", false, false, true)
            end
        end
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
