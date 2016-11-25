Locales = {}
-- Если DEBUG включен, вместо отсутствующих строк будут отображаться их названия
local DEBUG = true

local locales = {}
Locales.languages = {
	"english",
	"russian",
	"ukrainian",
	"portuguese"
}

Locales.byCode = {
	en = "english",
	ru = "russian",
	uk = "russian",
	be = "russian"
}

function Locales.load(lang)
	local file = File("languages/" .. tostring(lang) .. ".json")
	if not file then
		outputDebugString("Failed to load locale '" .. tostring(lang) .. "': failed to open language file")
		return false
	end
	local jsonData = file:read(file.size)
	file:close()
	if not jsonData then
		outputDebugString("Failed to load locale '" .. tostring(lang) .. "': failed to read JSON")
		return false
	end
	locales[lang] = fromJSON(jsonData)
	if not locales[lang] then
		outputDebugString("Failed to load locale '" .. tostring(lang) .. "': bad JSON")
		return false
	end
	outputDebugString("Loaded locale '" .. tostring(lang) .. "'")
	return true
end

function Locales.isValid(lang)
	for _, _lang in ipairs(Locales.languages) do
		if lang == _lang then
			return true
		end
	end
	return false
end

function Locales.getLang(lang)
	if not locales[lang] then
		return false
	end
	return locales[lang]
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
		if DEBUG then
			return name
		end
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
