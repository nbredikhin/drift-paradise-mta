local STRIP_CLUB_POSITION = Vector3 { x = 1022.391, y = -1122.687, z = 23.871 }
local STRIP_CLUB_INTERIOR_POSITION = Vector3  { x = 1022.55, y = -1107.2, z = 4179.453 }

local stripBlip = createBlip(STRIP_CLUB_POSITION, 21)
stripBlip:setData("text", "blip_strip_club")

local enterMarker
local exitMarker

addEventHandler("onClientResourceStart", resourceRoot, function ()
	enterMarker = exports.dpMarkers:createMarker("stripclub", STRIP_CLUB_POSITION - Vector3(0, 0, 0.9), 0)
	enterMarker.dimension = 0

	exitMarker = exports.dpMarkers:createMarker("exit", STRIP_CLUB_INTERIOR_POSITION - Vector3(0, 0, 0.9), 0)
end)

addEventHandler("dpMarkers.use", root, function ()
	if source == enterMarker then
		localPlayer.position = STRIP_CLUB_INTERIOR_POSITION
	elseif source == exitMarker then
		localPlayer.position = STRIP_CLUB_POSITION
	end
end)