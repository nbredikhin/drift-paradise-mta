function getPlayers()
	local response = getElementsByType("player")
	return response
end

function getScreenshot()

end

addEvent("onScreenshot", true)
addEventHandler("onScreenshot", resourceRoot, function (pixels)
	if fileExists("web/img.jpg") then
		fileDelete("web/img.jpg")
	end
	local file = fileCreate("web/img.jpg")
	file:write(pixels)
	file:close()
end)