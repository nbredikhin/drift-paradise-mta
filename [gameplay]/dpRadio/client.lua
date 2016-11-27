local textRadio = ""
local currentRadio = ""
local currentIndex = 1
local localPlayer = getLocalPlayer()
local sx,sy = guiGetScreenSize ()
local loltimer = nil
local templol = false

local carbonFont = dxCreateFont("test.ttf", 20, true)
local color = tocolor(255,255,255)

local radios = {"Radio off",
  "YO.FM",
  "GOP.FM",
  "Dorojnoe Radio",
  "ChartHits.FM",
  "Real Dance Radio",
  "Big R Radio-80s Metal FM ",
  "TOP100RAP",
  "1.FM Trance Radio",
  "GoHamRadioTrance",
  "Hay.FM Yerevan",
  "Big B Radio #JPOP",
  "Maximum.FM",
  "Radio Record",
  "Europa Plus",
  "D-FM",
  "Zaycev.FM",
  "100hitz",
  "DEFJAY",
  "TRAP.FM",
  "LIVE"
}

local radioPaths = {0,
  "http://air.radiorecord.ru:8102/yo_320",
  "http://online.radiorecord.ru:8102/gop_128",
  "http://dorognoe48.streamr.ru",
  "http://95.141.24.3:80/",
  "http://uk4.internet-radio.com:10138/",
  "http://107.155.111.234:18310/",
  "http://radio-tochka.com:6570",
  "http://sc8.1.fm:7706/",
  "http://uk4.internet-radio.com:15938/",
  "http://hayfm.am:8000/HayFm",
  "http://62.75.253.56:8012/",
  "http://maximum.fmtuner.ru/96kbit/s",
  "http://stream.radiorecord.ru:8100/rr_aac",
  "http://ep128.streamr.ru",
  "http://striiming.trio.ee/dfm.mp3",
  "http://zaycev.fm:9002/ZaycevFM(128)",
  "http://206.217.213.235:8170/",
  "http://212.45.104.39:8008/",
  "http://stream.trap.fm:6002/",
  "http://giss.tv:8000/allstars_channel.mp3"
}

local playRadioThing = nil

function resetTimer ()
  textRadio = ""
end

addEventHandler("onClientResourceStart",getResourceRootElement(),
function()
  outputChatBox ("Добро пожаловать на наш сервер!")
  showPlayerHudComponent ("radio",false)
  setRadioChannel (0)
  
  bindKey ("radio_next","down",
    function(key,state)
		color = tocolor(math.random(0,255),math.random(0,255),math.random(0,255))
      local nextIndex = ((currentIndex)%(#radioPaths)) +1
      currentIndex = nextIndex
      local radio = radioPaths[nextIndex]
      textRadio = radios[nextIndex]
      if loltimer and isTimer (loltimer) then
        killTimer (loltimer)
      end
      loltimer = setTimer (resetTimer,1000,1)
      if type (radio) == "number" then
        setRadioChannel (radio)
        if playRadioThing then
          stopSound (playRadioThing)
        end
      else
        setRadioChannel (0)
        if playRadioThing then 
          stopSound (playRadioThing)
        end
        playRadioThing = playSound (radio)
      end
    end
  )
  
  bindKey ("radio_previous","down",
    function(key,state)
		color = tocolor(math.random(0,255),math.random(0,255),math.random(0,255))
      local nextIndex = ((currentIndex -2)%(#radioPaths)) +1
      currentIndex = nextIndex
      local radio = radioPaths[nextIndex]
      textRadio = radios[nextIndex]
      if loltimer and isTimer (loltimer) then
        killTimer (loltimer)
      end
      loltimer = setTimer (resetTimer,1000,1)
      if type (radio) == "number" then
        setRadioChannel (radio)
        if playRadioThing then
          stopSound (playRadioThing)
        end
      else
        setRadioChannel (0)
        if playRadioThing then 
          stopSound (playRadioThing)
        end
        playRadioThing = playSound (radio)
      end
    end
  )
  
end)

function renderRadio ()
	dxDrawText(textRadio, 0,0, sx, 96, color, 1, carbonFont, "center", "center")
end
addEventHandler ("onClientRender",getRootElement(),renderRadio)

addEventHandler ("onClientVehicleExit",getRootElement(),
function(player)
  if localPlayer == player then
    if playRadioThing then
      stopSound (playRadioThing)
    end
    setRadioChannel (0)
    textRadio = ""
  end
end)

addEventHandler ("onClientVehicleEnter",getRootElement(),
function(player)
  if localPlayer == player then
    local radio = radioPaths[currentIndex]
    textRadio = radios[currentIndex]
    if loltimer and isTimer (loltimer) then
      killTimer (loltimer)
    end
    loltimer = setTimer (resetTimer,1000,1)
    if type (radio) == "number" then
      setRadioChannel (radio)
    else
      setRadioChannel (0)
      playRadioThing = playSound (radio)
    end
  end
end)

_setRadioChannel = setRadioChannel

function setRadioChannel (index)
  templol = true
  _setRadioChannel (index)
end

addEventHandler ("onClientPlayerRadioSwitch",getRootElement(),
function()
  if templol == true then
    if not isPedInVehicle (localPlayer) then
      setRadioChannel (0)
    end
    templol = false
  else
    cancelEvent (true)
    if not isPedInVehicle (localPlayer) then
      setRadioChannel (0)
    end
  end
end)

addEventHandler("onClientElementDestroy",getRootElement(),
function()
  if source and getElementType (source) == "vehicle" then
    if source == getPedOccupiedVehicle (localPlayer) then
      if playRadioThing then
        stopSound (playRadioThing)
      end
      setRadioChannel (0)
      textRadio = ""
    end
  end
end)

addEventHandler("onClientVehicleExplode",getRootElement(),
function()
  if source and getElementType (source) == "vehicle" then
    if source == getPedOccupiedVehicle (localPlayer) then
      if playRadioThing then
        stopSound (playRadioThing)
      end
      setRadioChannel (0)
      textRadio = ""
    end
  end
end)
