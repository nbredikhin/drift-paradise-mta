Garage = {}
Garage.themePrimaryColor = {}
local isActive = false
local sound

-- Фоновая музыка
local musicURLs = {
	"http://online-song.net/mp3/1-15v4/48d4fae76f6d99/p5/L.A.+Rush+OST+%96+Y+all+Know+Who.mp3",
	"http://online-song.net/mp3/6180v4/044a8af489ae/u174825389/audios/L.A.+Rush+OST+%96+Tipsy.mp3",
	"http://online-song.net/mp3/1-50v4/04682bcb443fe2/p16/Lil+Jon+and+The+Eastside+Boyz+%96+Get+Low+%28NFS+Underground+OST%29.mp3",
	"http://online-song.net/mp3/1-17v4/29c1f413630141/p4/Tiesto+vs.+Diplo+%96+C+Mon+%28Original+Mix%29.mp3",
	"http://online-song.net/mp3/4764v4/2a6764222eec/u40282349/audios/Ice+Cube+feat.+Das+EFX+%96+Check+Yo+Self+%281992%29.mp3",
	"http://online-song.net/mp3/422131v4/ab75d84b5ad7/u289060294/audios/Above+%26+Beyond+Feat.+Gemma+Hayes+%96+Counting+Down+The+Days+%28WYOMI+Remix%29.mp3",
	"http://online-song.net/mp3/536103v4/f47e1e7015b4/u216317445/audios/Snoop+Dogg+%96+Riders+On+The+Storm.mp3"
}

function Garage.start(vehicles, enteredVehicleId)
	if isActive then
		return false
	end
	isActive = true

	Garage.themePrimaryColor = {exports.dpUI:getThemeColor()}
	localPlayer.dimension = 0
	exports.dpGameTime:forceTime(12, 0)
	Assets.start()

	showChat(false)

	exports.dpMainPanel:setVisible(false)
	exports.dpTabPanel:setVisible(false)
	exports.dpWorldMap:setVisible(false)	
	exports.dpHUD:setVisible(false)

	sound = playSound(musicURLs[math.random(1, #musicURLs)]--[[, 2900, -3200.2, 2550]], false)
	if isElement(sound) then
		sound:setEffectEnabled("reverb", true)
		sound.volume = 0.08
		sound.maxDistance = 50
		sound.playbackPosition = math.random(0, sound.length)
		addEventHandler("onClientSoundStopped", resourceRoot, Garage.playRandomMusic)
	end

	setTimer(function () 
		GarageCar.start(vehicles)
		GarageCar.showCarById(enteredVehicleId)
		CameraManager.start()
		GarageUI.start()		
		setTimer(function () 
			triggerEvent("dpGarage.loaded", resourceRoot)
			CarTexture.start()
			fadeCamera(true)
		end, 500, 1)
	end, 500, 1)
end

-- Garage.start({{model=562}, {model=411}})

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	GarageUI.stop()
	CameraManager.stop()
	CarTexture.stop()
	GarageCar.stop()
	Assets.stop()
	exports.dpGameTime:restoreTime()
	showChat(true)
	exports.dpHUD:setVisible(true)
	if isElement(sound) then
		removeEventHandler("onClientSoundStopped", resourceRoot, Garage.playRandomMusic)
		destroyElement(sound)
	end
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end

function Garage.playRandomMusic(reason)
	if reason ~= "finished" then
		return false
	end
	if isElement(sound) then
		destroyElement(sound)
	end
	sound = playSound(musicURLs[math.random(1, #musicURLs)], false)
end