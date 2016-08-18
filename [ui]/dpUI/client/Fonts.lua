Fonts = {}

local SIZE_NORMAL = 16
local SIZE_LARGE = 20
local SIZE_LARGER = 26
local SIZE_SMALL = 14

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Fonts.default = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_NORMAL)
	Fonts.defaultBold = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_NORMAL, true)

	Fonts.defaultSmall = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_SMALL)
	Fonts.defaultLarge = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_LARGE)
	Fonts.defaultLarger = exports.dpAssets:createFont("Roboto-Regular.ttf", SIZE_LARGER)
	
	Fonts.light = exports.dpAssets:createFont("Roboto-Light.ttf", SIZE_NORMAL)
	Fonts.lightSmall = exports.dpAssets:createFont("Roboto-Light.ttf", SIZE_SMALL)

	Fonts.listItemText = exports.dpAssets:createFont("Roboto-Regular.ttf", 13)
end)