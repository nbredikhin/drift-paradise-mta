local ENABLE_CARSHOP_CMD = true	-- Команда /carshop для входа в автомагазин
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в автомагазин
local openGarageAfterExit = false

addEvent("dpCarshop.enter", true)
addEventHandler("dpCarshop.enter", resourceRoot, function (success)
	isEnterExitInProcess = false
	if success then
		Carshop.start()
	end
	fadeCamera(true)
end)

addEvent("dpCarshop.exit", true)
addEventHandler("dpCarshop.exit", resourceRoot, function (success)
	isEnterExitInProcess = false
	Carshop.stop()
	if openGarageAfterExit then
		openGarageAfterExit = false
		exports.dpGarage:enterGarage()
	else
		fadeCamera(true)
	end
end)

local function enterExitCarshop(enter)
	if enter then
		if localPlayer.vehicle then
			return false
		end
	end
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 1)
	Timer(function ()
		if enter then
			triggerServerEvent("dpCarshop.enter", resourceRoot)
		else
			triggerServerEvent("dpCarshop.exit", resourceRoot)
		end
	end, 1000, 1)
	return true
end

function enterCarshop()
	enterExitCarshop(true)
end

function exitCarshop(goToGarage)
	enterExitCarshop(false)
	openGarageAfterExit = not not goToGarage
end

if ENABLE_CARSHOP_CMD then
	addCommandHandler("carshop", function ()
		enterExitCarshop(not Carshop.isActive)
	end)
end

local enteranceMarker = exports.dpMarkers:createMarker("showroom", Vector3 { x = 1207.585, y = -1747.989, z = 12.7 }, -45)
addEvent("dpMarkers.use", false)
addEventHandler("dpMarkers.use", enteranceMarker, enterCarshop)
local blip = createBlip(0, 0, 0, 55)
blip:attach(enteranceMarker)
blip:setData("text", "blip_carshop")