-- r2
local script = [[
	local IS_SERVER = not not triggerClientEvent

	local imported = {}

	function isImported(importResourceName)
		return (imported[importResourceName] == true)
	end

	local function _import(varName, importResource)
		local functions = {}
		local functionNames = importResource:getExportedFunctions()
		for i, name in ipairs(functionNames) do
			functions[name] = function (...)
				return exports[importResource.name][name](nil, ...)
			end
		end

		_G[varName] = functions

		-- _G[varName] = exports[resource.name]
	end

	function import(varName, importResourceName)
		if type(importResourceName) ~= "string" then
			return false
		end

		local importResource = Resource.getFromName(importResourceName)
		if not importResource then
			return false
		end

		if importResource:getState() ~= "running" then
			return false
		end

		_import(varName, importResource)

		-- local importResourceRoot = importResource:getRootElement()

		local startEvent
		local stopEvent
		if IS_SERVER then
			startEvent = "onResourceStart"
			stopEvent = "onResourceStop"
		else
			startEvent = "onClientResourceStart"
			stopEvent = "onClientResourceStop"
		end

		addEventHandler(startEvent, root,
			function (startedResource)
				local startedResourceName = startedResource:getName()
				if startedResourceName == importResourceName then
					_import(varName, startedResource)
					imported[importResourceName] = true
				end
			end
		)

		addEventHandler(stopEvent, root,
			function (stoppedResource)
				local stoppedResourceName = stoppedResource:getName()
				if stoppedResourceName == importResourceName then
					imported[importResourceName] = false
					if type(_G[varName]) == "table" then
						for key, value in pairs(_G[varName]) do
							_G[varName][key] = function ()
								outputDebugString("function '" .. key .. "' is not available", 2)
								return false
							end
						end
					end
				end
			end
		)

		imported[importResourceName] = true

		return true
	end
]]

function get()
	return script
end
