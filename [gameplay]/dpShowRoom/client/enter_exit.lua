local ENABLE_SHOWROOOM_CMD = true	-- Команда /showroom для входа в автомагазин
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в автомагазин

addEvent("dpShowRoom.enter", true)
addEventHandler("dpShowRoom.enter", resourceRoot, function (success)
	isEnterExitInProcess = false

	if success then
		ShowRoom.start()
	else
		--[[local errorType = vehiclesList
		fadeCamera(true)
		if errorType then
			local errorText = exports.dpLang:getString(errorType)
			if errorText then
				outputChatBox(errorText, 255, 0, 0)
			end
		end]]
	end
	fadeCamera(true)
end)

addEvent("dpShowRoom.exit", true)
addEventHandler("dpShowRoom.exit", resourceRoot, function (success)
	isEnterExitInProcess = false
	ShowRoom.stop()
	fadeCamera(true)
end)

local function enterExitShowRoom(enter, selectedCarId)
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 1)
	Timer(function ()
		if enter then
			triggerServerEvent("dpShowRoom.enter", resourceRoot)
		else
			triggerServerEvent("dpShowRoom.exit", resourceRoot)
		end
	end, 1000, 1)
	return true
end

function enterShowRoom()
	enterExitShowRoom(true)
end

function exitShowRoom()
	enterExitShowRoom(false)
end

if ENABLE_SHOWROOOM_CMD then
	addCommandHandler("showroom", function ()
		enterExitShowRoom(not ShowRoom.isActive)
	end)
end

local showroomMarker = exports.dpMarkers:createMarker("showroom", Vector3 { x = 1203.585, y = -1733.989, z = 12.6 }, -135)
addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", showroomMarker, enterShowRoom)