local textureNames = {"tws-tire", "340", "5Zg", "5Zg2", "AD08_Sidewall", "ADR", "ADVAN", "ADVAN_RacingV2", "ADVAN_RacingV2al", "ADVAN_RGII", "BBS", "BBS_RS_GT", "Boyd_Slayer", "ByMatheus340", "CHROME_07", "CRKai", "cromado", "enkei", "enkei2", "fikse_pro", "freio", "gram_t57", "gram_t57al", "grid", "hamman_editrace", "iForged", "offroad", "Oz1", "rays", "Reflexo", "roda_003", "roda_004", "roda_007", "roda_008", "roda_012", "roda_rv", "Rota_Tamarc", "TE37", "TE37al", "tenzor", "tenzor3", "thread", "Tire(DirT)", "Tire(R)", "Tire", "TireSim", "TireSim_Sidewall", "WED_105", "wed_sa97", "wed_sa97al", "work2", "work4", "work5", "zen_dynm"}
local tiresNames = {"tws-tire", "tire", "thread", "sidewall", "offroad", "ADVAN"}

local wheelsIDs = {
	1025,
	1073,
	1074,
	1075,
	1076,
	1077,
	1078,
	1079,
	1080,
	1081,
	1082,
	1083,
	1084,
	1085,
	1096,
	1097,
	1098
}

local wheelsShaders = {}
local wheelsShadersScale = {}

function setVehicleWheels(vehicle, id)
	resetVehicleWheels(vehicle)
	if not wheelsIDs[id] then
		return
	end

	addVehicleUpgrade(vehicle, wheelsIDs[id])
	setVehicleWheelsColor(vehicle, 255, 255, 255)
	if wheelsShaders[vehicle] then
		local scale = 1
		if WheelsScale[getElementModel(vehicle)] then
			scale = WheelsScale[getElementModel(vehicle)]
		end
		dxSetShaderValue(wheelsShaders[vehicle], "scaleOffset", {scale, scale, scale, 1})
	end
end

function getVehicleWheels(vehicle, id)
	local currentWheelsID = getVehicleUpgradeOnSlot(vehicle, 12)
	for i, id in ipairs(wheelsIDs) do
		if id == currentWheelsID then
			return i
		end
	end
	return 0
end

function setVehicleWheelsColor(vehicle, r, g, b)
	if vehicle then
	setVehicleColor(vehicle,255,255,255,r,g,b)
	return
	else
	return
	end
	
	if getVehicleWheels(vehicle) == 0 then
		return
	end
	if not wheelsShaders[vehicle] then
		wheelsShaders[vehicle] = dxCreateShader("wheels.fx")
	end
	dxSetShaderValue(wheelsShaders[vehicle], "gColor", {r / 255 * 0.53, g / 255 * 0.53, b / 255 * 0.53, 1})
	for i,name in ipairs(textureNames) do
		local found = false
		for i, tireName in ipairs(tiresNames) do
			if string.find(string.lower(tireName), "tire") then
				found = true
			end
		end
		--if not found then
		--engineApplyShaderToWorldTexture(wheelsShaders[vehicle], name, vehicle)
		--end
	end
end

function resetVehicleWheels(vehicle)
	for i, id in ipairs(wheelsIDs) do
		removeVehicleUpgrade(vehicle, id)
	end
	if wheelsShaders[vehicle] then
		local scale = 1
		dxSetShaderValue(wheelsShaders[vehicle], "scaleOffset", {scale, scale, scale, 1})
	end
end