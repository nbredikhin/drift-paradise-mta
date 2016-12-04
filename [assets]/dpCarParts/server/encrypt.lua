local encryptData = {
	wheels = {1082, 1085, 1096, 1097, 1098, 1077, 1083, 1078, 1076, 1084, 1025, 1079, 1075, 1074, 1081, 1080},
	spoilers = {1000, 1001, 1002, 1003, 1023, 1014, 1015, 1016, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},
	exhausts = {1853, 1854, 1855, 1856, 1857, 1858, 1859, 1860, 1861, 1862}
}

local function randomBytes(count)
	local str = ""
	for i = 1, count do
		str = str .. string.char(math.random(0, 255))
	end
	return str
end

addCommandHandler("parts", function (player)
	if not exports.dpUtils:isPlayerAdmin(player) then
		return false
	end
	math.randomseed(1337)
	outputDebugString("Encrypting car parts...")
	local loaderScript = "local packs = {\n"
	for name, models in pairs(encryptData) do
		outputDebugString("Encrypt " .. tostring(name))
		local packInfo = {}
		local packFile = randomBytes(8) .. "DRIFT_PARADISE_ASSETS" .. randomBytes(math.random(1024, 1024 * 4))
		table.insert(packInfo, #packFile)
		local txd = loadFile(name .. "/" .. name .. ".txd")
		packFile = packFile .. txd
		table.insert(packInfo, #txd)
		table.insert(packInfo, #models)
		for i, model in ipairs(models) do
			local dff = loadFile(name .. "/" .. i .. ".dff")
			table.insert(packInfo, model)
			table.insert(packInfo, #dff)
			packFile = packFile .. dff
		end
		saveFile("packs/dp_" .. tostring(name) .. ".bin", packFile)
		loaderScript = loaderScript .. "\t" .. tostring(name) .. " = " .. arrayToString(packInfo) .. ",\n"
	end
	loaderScript = loaderScript .. "}\n\n"
	loaderScript = loaderScript .. loadFile("server/loader.lua")
	saveFile("loader.lua", loaderScript)
	outputDebugString("Finished")
end)