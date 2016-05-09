local SECRET_KEY = "mda_xex_memasiki_podkatili"
local _dxCreateTexture = dxCreateTexture
function dxCreateTexture(path, ...)
	if type(path) == "string" and string.find(path, ".png") then
		path = md5(teaEncode(path, "kek"))
		local file = fileOpen(path)
		if not file then
			return false
		end
		local data = file:read(file.size)
		file:close()

		data = base64Decode(teaDecode(data, SECRET_KEY))
		return _dxCreateTexture(data, ...)
	else
		return _dxCreateTexture(path, ...)
	end
end