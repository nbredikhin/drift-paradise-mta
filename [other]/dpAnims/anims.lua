local anims = {
	wave = {"ON_LOOKERS", "wave_loop"},
	lay = {"BEACH", "SitnWait_loop_W"},
	sit = {"ped", "SEAT_IDLE"},
	sit_relax = {"INT_House", "LOU_Loop"},
	fucku = {"ped", "fucku", false},
	serious = {"COP_AMBIENT", "Coplook_loop"},

	hello = {"ped", "endchat_03", false},
	no = {"ped", "endchat_02", false},
	bye = {"ped", "endchat_01", false},
}

addEvent("dpAnims.playAnim", true)
addEventHandler("dpAnims.playAnim", root, function (name)
	if not anims[name] then
		return
	end
	local loop = true
	if anims[name][3] == false then
		loop = false
	end
	client:setAnimation(anims[name][1], anims[name][2], 0, loop, false)
end)