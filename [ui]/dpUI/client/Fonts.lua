Fonts = {}

local SIZE_NORMAL = 16
local SIZE_SMALL = 14

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Fonts.default = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_NORMAL)
	Fonts.light = exports.dpAssets:createFont("Roboto-Light.ttf", SIZE_NORMAL)
	Fonts.lightSmall = exports.dpAssets:createFont("Roboto-Light.ttf", SIZE_SMALL)
end)