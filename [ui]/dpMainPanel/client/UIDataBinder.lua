UIDataBinder = {}
local isActive = false
local bindings = {}

local function processText(value)
	return tostring(value)
end 

local function updateWidget(source, dataName)
	local binding = bindings[dataName]
	if binding then
		if binding.element ~= source then
			return
		end
		local value = source:getData(dataName)
		local text = processText(value)
		if type(binding.callback) == "function" then
			text = binding.callback(value)
		end
		UI:setText(binding.widget, text)
	end
end

function UIDataBinder.bind(widget, dataName, callback, element)
	if not bindings[dataName] then
		bindings[dataName] = {}
	end
	if not element then
		element = localPlayer
	end
	bindings[dataName].element = element
	bindings[dataName].widget = widget
	bindings[dataName].callback = callback

	updateWidget(element, dataName)
end

local function onData(dataName)
	if not isActive then
		return
	end
	updateWidget(source, dataName)
end

function UIDataBinder.refresh()
	for k, v in pairs(bindings) do
		updateWidget(v.element, k)
	end
end

function UIDataBinder.setActive(active)
	active = not not active
	if active == isActive then
		return
	end

	if active then
		UIDataBinder.refresh()
		addEventHandler("onClientElementDataChange", root, onData)
	else
		removeEventHandler("onClientElementDataChange", root, onData)
	end
	isActive = active
end