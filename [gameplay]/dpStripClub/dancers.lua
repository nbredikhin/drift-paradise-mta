local positions = {
	{ Vector3 { x = 1032.741, y = -1102.097, z = 4179.859 }, 120},
	{ Vector3 { x = 1031.477, y = -1097.566, z = 4179.859 }, 45},
	{ Vector3 { x = 1041.258, y = -1096.728, z = 4179.859 }, 100},
	{ Vector3 { x = 1040.823, y = -1106.057, z = 4179.859 }, 30},
	-- Одинокая шлюха
	{ Vector3 { x = 1026.078, y = -1100.725, z = 4179.859 }, 0},

	{ Vector3 { x = 1039.094, y = -1085.602, z = 4179.807 }, 130}
}

local skins = {
	63, 87, 69, 211, 221, 135
}

local anims = {
	"strip_A",
	"strip_B",
	"strip_C",
	"strip_D",
	"strip_E",
	"strip_F",
	"strip_G",
}

local peds = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local j = 1
	local k = 1
	for i, pos in ipairs(positions) do
		local ped = createPed(skins[j], pos[1])
		ped.rotation = Vector3(0, 0, pos[2])
		ped:setAnimation("STRIP", anims[k], -1, true, true, false, false)
		ped.frozen = true

		local colshape = createColSphere(ped.position, 3)
		table.insert(peds, {ped = ped, colshape = colshape, anim = anims[k]})
		j = j + 1
		if j > #skins then
			j = 1
		end

		k = k + 1
		if k > #anims then
			k = 1
		end
	end

	for i, model in ipairs(skins) do
		if fileExists("telki/" .. tostring(model) .. ".dff") then
			local txd = engineLoadTXD("telki/"..tostring(model)..".txd")
			engineImportTXD(txd, model)
			local dff = engineLoadDFF("telki/"..tostring(model)..".dff")
			engineReplaceModel(dff, model)
		end
	end
end)

addEventHandler("onClientKey", root, function (button, state)
	if not state then
		return
	end

	if button == "g" then
		for i, ped in ipairs(peds) do
			if localPlayer:isWithinColShape(ped.colshape) then
				triggerServerEvent("dpStripClub.throwMoney", resourceRoot, i)
				return
			end
		end
	end
end)

-- PLY_CASH и PUN_CASH
addEvent("dpStripClub.throwMoney", true)
addEventHandler("dpStripClub.throwMoney", resourceRoot, function (id)
	if type(id) ~= "number" then
		return
	end
	if not peds[id] then
		return 
	end
	if isTimer(peds[id].timer) then
		return
	end
	peds[id].ped:setAnimation("STRIP", "STR_B2C", -1, false, true, false, false)
	peds[id].timer = setTimer(function()
		peds[id].ped:setAnimation("STRIP", peds[id].anim)
	end, 6000, 1)
end)
