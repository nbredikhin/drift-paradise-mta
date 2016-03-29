Locales = {}
-- Если DEBUG включен, вместо отсутствующих строк будут отображаться их названия
local DEBUG = true

local locales = {}
Locales.languages = {
	"english",
	"russian"
}

function Locales.load(lang)
	local file = File("languages/" .. tostring(lang) .. ".json")
	if not file then
		return false
	end
	local jsonData = file:read(file.size)
	file:close()
	if not jsonData then
		return false
	end
	locales[lang] = fromJSON(jsonData)
	if not locales[lang] then
		return false
	end
	return true
end

function Locales.unload(lang)
	if not locales[lang] then
		return false
	end
	locales[lang] = nil
	return true
end

function Locales.getString(lang, name)
	if not locales[lang] then
		return false
	end

	local localizedString = locales[lang][name]
	if not localizedString then
		if DEBUG then
			localizedString = name
		else
			return false
		end
	end
	return localizedString
end