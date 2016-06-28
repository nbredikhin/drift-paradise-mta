local CONFIG_PROPERTY_NAME = "graphics.reflections_water"

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()		
		triggerEvent("switchWaterShine", resourceRoot, exports.dpConfig:getProperty(CONFIG_PROPERTY_NAME))
	end
)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			enableWaterShine()
		else
			disableWaterShine()
		end
	end
end)