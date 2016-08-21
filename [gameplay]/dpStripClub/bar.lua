local BARMEN_POSITION = Vector3 { x = 1032.138, y = -1110.2, z = 4179.453 }
local barmenPed

local decorativePeds = {
	{ info = {296, Vector3 { x = 1019, y = -1101.522, z = 4180.05 }, -20}, anim = {"BEACH", "ParkSit_M_loop"}},
	{ info = {59, Vector3 { x = 1019.2, y = -1093.522, z = 4179.9 }, -90}, anim = {"FOOD", "FF_Sit_Eat1"}},
	{ info = {223, Vector3  { x = 1033.434, y = -1108.444, z = 4180 }, -200}, anim = {"FOOD", "FF_Sit_Eat1"}},
	{ info = {59, Vector3 { x = 1032.3, y = -1084.8, z = 4180 }, -90}, anim = {"SUNBATHE", "ParkSit_M_IdleA"}},
	{ info = {24, Vector3 { x = 1024.681, y = -1107.723, z = 4179.453 }, 0}, anim = {""}, weapon = true},
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	barmenPed = createPed(84, BARMEN_POSITION)
	barmenPed:setAnimation("BAR", "Barcustom_order")

	for i, p in pairs(decorativePeds) do
		local ped = createPed(unpack(p.info))
		ped:setAnimation(p.anim[1], p.anim[2], -1, true, true, false)
		ped:setCollisionsEnabled(false)
		ped.frozen = true
		if p.weapon then
			setTimer(function()
				givePedWeapon(ped, 22, 30, true)
			end, 500, 1)
		end
	end
end)