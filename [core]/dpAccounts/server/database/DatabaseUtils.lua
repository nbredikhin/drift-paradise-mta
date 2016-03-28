DatabaseUtils = {}

function DatabaseUtils.prepareDatabaseOptionsString(options)
	if not options then
		return ""
	end
	local optionsStrings = {}
	for key, value in pairs(options) do
		table.insert(optionsStrings, tostring(key) .. "=" .. tostring(value))
	end
	return table.concat(optionsStrings, ";")
end