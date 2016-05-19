local SECRET_KEY = "mda_xex_memasiki_podkatili"
local _dxCreateTexture = dxCreateTexture
function dxCreateTexture(path, ...)
	if type(path) == "string" and string.find(path, ".png") then
		path = md5(teaEncode(path, "kek"))
		return _dxCreateTexture(path, ...)
	else
		return _dxCreateTexture(path, ...)
	end
end
DxTexture = dxCreateTexture