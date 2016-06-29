local CONFIG_PROPERTY_NAME = "graphics.improved_sky"

addEventHandler( "onClientResourceStart", resourceRoot, function()
	triggerEvent("switchDynamicSky", resourceRoot, exports.dpConfig:getProperty(CONFIG_PROPERTY_NAME))
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			startDynamicSky()
		else
			stopDynamicSky()
		end
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, stopDynamicSky)