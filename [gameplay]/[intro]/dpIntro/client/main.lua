local music

function startIntro()
	localPlayer.dimension = 0
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
		music = playSound("assets/background_music.mp3")
	end, 1000, 1)
end

function stopIntro()

end

local function updateMusic(dt)
	dt = dt / 1000

	if not isElement(music) then
		removeEventHandler("onClientPreRender", root, updateMusic)
		return
	end

	music.volume = music.volume - dt	
	if music.volume <= 0.01 then
		destroyElement(music)
	end
end

function stopMusic()
	if isElement(music) then
		addEventHandler("onClientPreRender", root, updateMusic)
	end
end

addEvent("dpIntro.start", true)
addEventHandler("dpIntro.start", root, function ()
	setTimer(startIntro, 1000, 1)
end)

addEvent("dpIntroVideo.finish")
addEventHandler("dpIntroVideo.finish", root, onVideoFinish)