MapUI = {}
local screenSize = Vector2(guiGetScreenSize())
local shadowTexture
local helpTextFont
local helpText = ""

function MapUI.start()
	helpTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 16)
	shadowTexture = exports.dpAssets:createTexture("screen_shadow.png")
	helpText = string.format(
		exports.dpLang:getString("world_map_help_text"),
		exports.dpLang:getString("controls_mouse"),
		exports.dpLang:getString("controls_mouse_wheel"),
		"BACKSPACE"
	)
end

function MapUI.stop()
	destroyElement(shadowTexture)
	destroyElement(helpTextFont)
end

function MapUI.draw()
	dxDrawImage(0, 0, screenSize.x, screenSize.y, shadowTexture, 0, 0, 0, tocolor(255, 255, 255, 150))
	dxDrawText(
		helpText, 
		0, screenSize.y - 50, 
		screenSize.x, screenSize.y, 
		tocolor(255, 255, 255, 150), 
		1, 
		helpTextFont,
		"center",
		"center"
	)	
end