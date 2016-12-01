local MARKER_POSITION = Vector3()
local PED_POSITION = Vector3(1828.649, -1842.192, 13.578)
local PED_MODEL = 10
local MUSIC_POSITION = Vector3(1835.613, -1842.073, 13.078)

local marker

addEvent("dpMarkers.use", false)

local function takeTofu()
	exports.dpUI:showMessageBox("Доставка тофу", "Откройте карту, чтобы узнать, куда везти тофу")
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	marker = exports.dpMarkers:createMarker("tofu", Vector3 { x = 1821.247, y = -1841.963, z = 12.579 }, 0)
	addEventHandler("dpMarkers.use", marker, takeTofu)

	local txd = engineLoadTXD("skin/1.txd")
	engineImportTXD(txd, PED_MODEL)
	local dff = engineLoadDFF("skin/1.dff")
	engineReplaceModel(dff, PED_MODEL)

	local ped = createPed(PED_MODEL, PED_POSITION, 90)
	ped.frozen = true

	local sound = playSound3D("music/music.mp3", MUSIC_POSITION, true)
	sound.minDistance = 10
	sound.maxDistance = 30
end)