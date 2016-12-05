local MARKER_POSITIONS = {
	Vector3(1821.247, -1842.192, 12.6),
	Vector3(473.9, -1296.518, 14.5)
}
local PED_POSITIONS = {
	{ position = Vector3(1828.649, -1842.192, 13.578), rotation = 90 },
	{ position = Vector3(468.605, -1290.124, 15.435),  rotation = 210}
}

local PED_MODEL = 10
local MUSIC_POSITIONS = {
	Vector3(1835.613, -1842.073, 13.078),
	Vector3(471.078, -1280.93, 15.435)
}

local CHECKPOINTS_COUNT = 2
local MIN_COLLISION_FORCE = 350

local peds = {}

local isRunning = false
local isThereCollision = false
local startTime = 0

addEvent("dpMarkers.use", false)

local function takeTofu()
	if isRunning then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("tofu_message_box_title"),
			exports.dpLang:getString("tofu_message_box_text"))
		return
	end

	if not localPlayer.vehicle then
		return
	end

	local checkpointsList = PathGenerator.generateCheckpointsForPlayer(localPlayer, CHECKPOINTS_COUNT)
	RaceCheckpoints.start(checkpointsList)
	isRunning = true
	isThereCollision = false
	startTime = getRealTime().timestamp

	for i, ped in ipairs(peds) do
		setPedAnimation(ped, "DANCING", "dance_loop")
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, position in ipairs(MARKER_POSITIONS) do
		local marker = exports.dpMarkers:createMarker("tofu", position, 0)
		addEventHandler("dpMarkers.use", marker, takeTofu)

		local blip = createBlip(0, 0, 0, 27)
		blip:attach(marker)
		blip:setData("text", "tofu_blip_text")
	end

	local txd = engineLoadTXD("skin/1.txd")
	engineImportTXD(txd, PED_MODEL)
	local dff = engineLoadDFF("skin/1.dff")
	engineReplaceModel(dff, PED_MODEL)

	for i, pedPosition in ipairs(PED_POSITIONS) do
		local ped = createPed(PED_MODEL, pedPosition.position, pedPosition.rotation)
		ped.frozen = true
		addEventHandler("onClientPedDamage", ped, cancelEvent)
		peds[i] = ped
	end

	for i, position in ipairs(MUSIC_POSITIONS) do
		local sound = playSound3D("music/music.mp3", position, true)
		sound.minDistance = 20
		sound.maxDistance = 50
	end
end)

function cancelTofu()
	if not isRunning then
		return false
	end
	isRunning = false
	startTime = 0
	RaceCheckpoints.stop()
	for i, ped in ipairs(peds) do
		setPedAnimation(ped)
	end
end

function finishTofu()
	if not isRunning then
		return false
	end
	local timePassed = getRealTime().timestamp - startTime
	outputDebugString(timePassed)

	local bonus = 0
	local prize = exports.dpShared:getEconomicsProperty("tofu_prize")
	if not prize then
		prize = 0
	end
	if not isThereCollision then
		bonus = exports.dpShared:getEconomicsProperty("tofu_perfect_mul")
		if not bonus then
			bonus = 1
		end
		prize = prize * bonus
	end
	FinishScreen.show(prize, timePassed, bonus * 100 - 100)
	cancelTofu()
	triggerServerEvent("dpTofu.finish", resourceRoot, not isThereCollision)
end

addEventHandler("onClientVehicleCollision", root, function (_, force)
	if source ~= localPlayer.vehicle then
		return
	end
	if force < MIN_COLLISION_FORCE then
		return
	end
	if not isRunning then
		return
	end
	isThereCollision = true
end)

addEventHandler("onClientVehicleExit", root, function (player)
	if player ~= localPlayer then
		return
	end
	cancelTofu()
end)
