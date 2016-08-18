addEventHandler("onClientResourceStart", root,
	function (startedResource)
		outputDebugString(startedResource.name)
	end
)
