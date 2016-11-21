function startIntro()
	exports.dpHUD:setVisible(false)
	exports.dpChat:setVisible(false)
	fadeCamera(false, 0)
	exports.dpIntroVideo:start()

	localPlayer:setData("activeUI", "intro")
end

local function onVideoFinish()
	exports.dpHUD:setVisible(false)
	exports.dpChat:setVisible(false)	
	setTimer(function ()
		IntroCutscene.start()
		fadeCamera(true, 3)
		playSound("assets/background_music.mp3")
	end, 1000, 1)
end

function stopIntro()

end

addEvent("dpIntro.start", true)
addEventHandler("dpIntro.start", root, function ()
	setTimer(startIntro, 1000, 1)
end)

addEvent("dpIntroVideo.finish")
addEventHandler("dpIntroVideo.finish", root, onVideoFinish)