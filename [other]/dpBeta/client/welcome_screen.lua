local screenSize = Vector2(	guiGetScreenSize())

local isVisible = false
local font = exports.dpAssets:createFont("Roboto-Light.ttf", 50)
local scale = math.min(1, screenSize.x / 1280)
local activeString = 1
local switchStringTo = 1
local targetAlpha = 0
local alpha = targetAlpha
local targetBackgroundAlpha = 255
local backgroundAlpha = 255

local strings = {
	"Привет",
	"Добро пожаловать на Drift Paradise!",
	"Данный проект является незаконченным",
	"Не стоит оценивать сервер по текущей версии",
	"Желаем вам приятной игры",
}

local function showNextString()
	targetAlpha = 0
	switchStringTo = activeString + 1
	if switchStringTo > #strings then
		switchStringTo = false
		targetBackgroundAlpha = 0
	end
end

function showWelcomeScreen()
	localPlayer:setData("activeUI", "welcomeScreen")
	isVisible = true
	targetAlpha = 0
	alpha = 0

	targetBackgroundAlpha = 255
	backgroundAlpha = 0

	local t = setTimer(function ()
		showNextString()
	end, 5000, #strings)

	setTimer(function ()
		if isTimer(t) then 
			killTimer(t)
		end
		isVisible = false
		localPlayer:setData("activeUI", false)
	end, 5000 * (#strings) + 1000, 1)
end

addEventHandler("onClientRender", root, function()
	if not isVisible then
		return
	end 
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(212, 0, 40, backgroundAlpha))
	dxDrawText(strings[activeString], 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255, alpha), scale, font, "center", "center")

	backgroundAlpha = backgroundAlpha + (targetBackgroundAlpha - backgroundAlpha) * 0.05
	alpha = alpha + (targetAlpha - alpha) * 0.05
	if targetAlpha == 0 and alpha < 10 then
		if switchStringTo then
			activeString = switchStringTo
			targetAlpha = 255
		end
	end
end)

addEvent("dpSkinSelect.start", true)
addEventHandler("dpSkinSelect.start", root, showWelcomeScreen)