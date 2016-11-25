MusicPlayer = {}
local MUSIC_VOLUME = 0.45
local TRACKS_COUNT = 10
local currentTrack = 1
local sound
local soundVolume = 0
local soundVolumeSpeed = 5

local function playNextTrack()
	if not exports.dpConfig:getProperty("game.background_music") then
		return
	end
	currentTrack = currentTrack + 1
	if currentTrack > TRACKS_COUNT then
		currentTrack = 1
	end
	if isElement(sound) then
		destroyElement(sound)
	end
	sound = playSound("assets/music/" .. tostring(currentTrack) .. ".mp3", false)	
	sound:setEffectEnabled("reverb", true)
end

local function update(dt)
	dt = dt / 1000

	if not isElement(sound) then
		return
	end

	sound.volume = sound.volume + (soundVolume - sound.volume) * dt * soundVolumeSpeed
end

function MusicPlayer.start()
	addEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
	addEventHandler("onClientPreRender", root, update)

	currentTrack = math.random(1, TRACKS_COUNT)
	playNextTrack()

	if isElement(sound) then
		sound.volume = 0
		sound.playbackPosition = math.random(0, sound.length * 0.7)
	end

	soundVolume = MUSIC_VOLUME
end

function MusicPlayer.fadeOut()
	soundVolume = 0
end

function MusicPlayer.stop()
	removeEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
	removeEventHandler("onClientPreRender", root, update)
	if isElement(sound) then		
		destroyElement(sound)
	end
end