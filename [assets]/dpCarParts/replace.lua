local wheels = {
	[1082] = "wheel_gn1", 
	[1085] = "wheel_gn2", 
	[1096] = "wheel_gn3",  
	[1097] = "wheel_gn4",  
	[1098] = "wheel_gn5", 
	[1077] = "wheel_lr1", 
	[1083] = "wheel_lr2", 
	[1078] = "wheel_lr3", 
	[1076] = "wheel_lr4", 
	[1084] = "wheel_lr5", 
	[1025] = "wheel_or1", 
	[1079] = "wheel_sr1", 
	[1075] = "wheel_sr2", 
	[1074] = "wheel_sr3", 
	[1081] = "wheel_sr4", 
	[1080] = "wheel_sr5", 
	-- [1073] = "wheel_sr6", 
}

local spoilers = {
	[1000] = "1",
	[1001] = "2",
	[1002] = "3",
	[1003] = "4",
	[1023] = "5",
	[1014] = "6",
	[1015] = "7",
	[1016] = "8",
	[1049] = "9",
	[1050] = "10", 
	[1058] = "11", 
	[1060] = "12",
	[1138] = "13",
	[1139] = "14",
	[1146] = "15",
	[1147] = "16",
	[1158] = "17",
	[1162] = "18",
	[1163] = "19",
	[1164] = "20"
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local wheelsTXD = engineLoadTXD("wheels/wheels.txd")
	engineImportTXD(wheelsTXD, 1082)
	local spoilersTXD = engineLoadTXD("spoilers/spoilers.txd")
	engineImportTXD(spoilersTXD, 1000)

	for model, src in pairs(wheels) do
		local dff = engineLoadDFF("wheels/" .. src .. ".dff")
		engineReplaceModel(dff, model)
	end

	for model, src in pairs(spoilers) do
		local dff = engineLoadDFF("spoilers/" .. src .. ".dff")
		engineReplaceModel(dff, model)
	end	
end)