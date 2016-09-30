local function vehicleAction(name, value)
	return function()
		exports.dpVehicles:toggleVehicleParam(name, value)
	end
end

local function switchHandling()
	exports.dpVehicles:switchHandling()
end

local doorsLocales = {
	[2] = {"context_menu_vehicle_door_lf_close", "context_menu_vehicle_door_lf_open"},
	[3] = {"context_menu_vehicle_door_rf_close", "context_menu_vehicle_door_rf_open"},
	[4] = {"context_menu_vehicle_door_lb_close", "context_menu_vehicle_door_lb_open"},
	[5] = {"context_menu_vehicle_door_rb_close", "context_menu_vehicle_door_rb_open"},
}

local function getActionString(name, value)
	return function(vehicle)
		if name == "handling" then
			if vehicle:getData("activeHandling") == "street" then
				return exports.dpLang:getString("context_menu_vehicle_enable_drift_mode")
			else
				return exports.dpLang:getString("context_menu_vehicle_disable_drift_mode")
			end
		elseif name == "engine" then
			if getVehicleEngineState(vehicle) then
				return exports.dpLang:getString("context_menu_vehicle_engine_off")
			else
				return exports.dpLang:getString("context_menu_vehicle_engine_on")
			end
		elseif name == "handbrake" then
			return exports.dpLang:getString("context_menu_vehicle_handbrake_on")
		elseif name == "lights" then
			if vehicle:getData("LightsState") then
				return exports.dpLang:getString("context_menu_vehicle_lights_off")
			else
				return exports.dpLang:getString("context_menu_vehicle_lights_on")
			end
		elseif name == "door" and type(value) == "number" then
			if vehicle:getDoorOpenRatio(value) > 0.5 then
				return exports.dpLang:getString(doorsLocales[value][1])
			else
				return exports.dpLang:getString(doorsLocales[value][2])
			end
		end
	end
end

local myVehicleMenu = {
	{ 
		getText = getActionString("handling"), 	
		click 	= switchHandling,
		enabled = function(vehicle)
			return vehicle:getData("DriftHandling") > 0
		end
	},
	{ getText = getActionString("engine"), 		click = vehicleAction("engine")},
	{ getText = getActionString("handbrake"), 	click = vehicleAction("handbrake"), enabled = false},
	{ getText = getActionString("lights"), 		click = vehicleAction("lights")}, 
	{ getText = getActionString("door", 2), 	click = vehicleAction("door", 2)},
	{ getText = getActionString("door", 3), 	click = vehicleAction("door", 3)},
	{ getText = getActionString("door", 4),
		-- Проверка наличия двери 
		enabled = function(vehicle) 
			return vehicle:getComponentVisible("door_lr_dummy")
		end,

		click = vehicleAction("door", 4)
	},
	{ getText = getActionString("door", 5),
		-- Проверка наличия двери 
		enabled = function(vehicle) 
			return vehicle:getComponentVisible("door_rr_dummy")
		end,

		click = vehicleAction("door", 5)
	},	
}

local vehicleMenu = {
	title = "Автомобиль",
	items = {}
}

function vehicleMenu:init(vehicle)
	if not isElement(vehicle) then
		return
	end
	if not vehicle.controller then
		return false
	end

	if vehicle.controller == localPlayer then
		self.items = myVehicleMenu
		self.title = exports.dpLang:getString("context_menu_title_car")
	else
		local player = vehicle.controller
		self.items = remotePlayerMenu
		outputDebugString(tostring(#self.items))
		self.title = string.format("%s %s", 
			exports.dpLang:getString("context_menu_title_player"),
			tostring(player.name))
	end
end

registerContextMenu("vehicle", vehicleMenu)