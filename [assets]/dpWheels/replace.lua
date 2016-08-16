local wheels = {
	[1082] = "wheel_gn1.dff", 
	[1085] = "wheel_gn2.dff", 
	[1096] = "wheel_gn3.dff",  
	[1097] = "wheel_gn4.dff",  
	[1098] = "wheel_gn5.dff", 
	[1077] = "wheel_lr1.dff", 
	[1083] = "wheel_lr2.dff", 
	[1078] = "wheel_lr3.dff", 
	[1076] = "wheel_lr4.dff", 
	[1084] = "wheel_lr5.dff", 
	[1025] = "wheel_or1.dff", 
	[1079] = "wheel_sr1.dff", 
	[1075] = "wheel_sr2.dff", 
	[1074] = "wheel_sr3.dff", 
	[1081] = "wheel_sr4.dff", 
	[1080] = "wheel_sr5.dff", 
	[1073] = "wheel_sr6.dff", 
}

function replaceModel()
	setTimer(
		function()
			engineImportTXD(engineLoadTXD("wheels.txd", 1082), 1082)
			for model, name in pairs(wheels) do
				engineReplaceModel(engineLoadDFF(name, model), model)
			end
		end, 1000, 1
	)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)