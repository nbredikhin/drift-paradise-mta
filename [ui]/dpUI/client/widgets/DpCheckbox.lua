DpCheckbox = {}

local buttonColors = {
	default = "default",
	default_dark = "gray_darker",
	primary = "primary"
}

function DpCheckbox.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	return widget
end