local MARKER_POSITION = Vector3(1821.247, -1842.192, 12.6)
local PED_POSITION = Vector3(1828.649, -1842.192, 13.578)
local PED_MODEL = 10
local MUSIC_POSITION = Vector3(1835.613, -1842.073, 13.078)
local CHECKPOINTS_COUNT = 40
local MIN_COLLISION_FORCE = 350

local marker
local ped

local isRunning = false
local isThereCollision = false
local startTime = 0

addEvent("dpMarkers.use", false)

local function takeTofu()
	if isRunning then
		exports.dpUI:showMessageBox("Доставка тофу", "Вы уже взяли тофу! Следуйте маршруту")
		return 
	end

	local checkpointsList = PathGenerator.generateCheckpointsForPlayer(localPlayer, CHECKPOINTS_COUNT)
	RaceCheckpoints.start(checkpointsList)
	isRunning = true
	isThereCollision = false
	startTime = getRealTime().timestamp

	setPedAnimation(ped, "DANCING", "dance_loop")
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	marker = exports.dpMarkers:createMarker("tofu", MARKER_POSITION, 0)
	addEventHandler("dpMarkers.use", marker, takeTofu)

	local txd = engineLoadTXD("skin/1.txd")
	engineImportTXD(txd, PED_MODEL)
	local dff = engineLoadDFF("skin/1.dff")
	engineReplaceModel(dff, PED_MODEL)

	ped = createPed(PED_MODEL, PED_POSITION, 90)
	ped.frozen = true

	local sound = playSound3D("music/music.mp3", MUSIC_POSITION, true)
	sound.minDistance = 20
	sound.maxDistance = 50

	local blip = createBlip(0, 0, 0, 27)
	blip:attach(marker)
	blip:setData("text", "tofu_blip_text")	

	addEventHandler("onClientPedDamage", ped, cancelEvent)
end)

function cancelTofu()
	if not isRunning then
		return false
	end
	isRunning = false
	startTime = 0
	RaceCheckpoints.stop()
	setPedAnimation(ped)
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