Fonts = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Fonts.default = exports.dpAssets:createFont("Roboto-Regular.ttf", 16)
	Fonts.light = exports.dpAssets:createFont("Roboto-Light.ttf", 16)
end)