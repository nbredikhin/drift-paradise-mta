function startIntro()
	exports.dpHUD:setVisible(false)
	exports.dpChat:setVisible(false)
	fadeCamera(false, 0)
	exports.dpIntroVideo:start()
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

addEventHandler("onClientResourceStart", resourceRoot, function ()
	startIntro()
	--onVideoFinish()
end)

addEvent("dpIntroVideo.finish")
addEventHandler("dpIntroVideo.finish", root, onVideoFinish)