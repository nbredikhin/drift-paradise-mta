Garage = {}
Garage.themePrimaryColor = {}
local isActive = false
local sound

local pendingBuyCallback

-- Фоновая музыка
local musicURLs = {
	"http://online-song.net/mp3/1-21v4/aaabda7058058a/p30/Twista+%28L.A.+Rush+OST%29+%96+Get+Me+%282004%29.mp3",
	"http://online-song.net/mp3/536411v4/7d9c10c44e2c/u174825389/audios/L.A.+Rush+OST+%96+Thinkin+About+Ya.mp3",
	"http://online-song.net/mp3/1-16v4/a05623b8046772/p14/L.A.+Rush+OST+%96+The+Jump+Off.mp3",
	"http://online-song.net/mp3/6180v4/cd8a0d02ff52/u174825389/audios/L.A.+Rush+OST+%96+Tipsy.mp3",
	"http://online-song.net/mp3/1-15v4/83b09133c5a76b/p5/L.A.+Rush+OST+%96+Y+all+Know+Who.mp3",
	"http://online-song.net/mp3/1-46v4/cbce0b5a4a55ee/p22/Depeche+Mode+%96+Enjoy+The+Silence+%28Offsuit+Remix%29.mp3",
	"http://online-song.net/mp3/536103v4/c9fc44ab6723/u31030093/audios/Marlon+Roudette+%96+When+The+Beat+Drops+Out.mp3",
	"http://online-song.net/mp3/1-51v4/a585e81174fd09/p21/Rootkit+%96+Do+It.mp3",
	"http://online-song.net/mp3/4651v4/b70d21cdad5d/u12541798/audios/Deadmau5+ft.+Kaskade+%96+I+Remember.mp3",
	"http://online-song.net/mp3/4592v4/e210cf48318d/u23464125/audios/Snoop+Dog+f…oors+%96+Rider+on+the+storm+%28OST+Need+For+Speed+Underground+2+OST%29.mp3",
	"http://online-song.net/mp3/1-36v4/8f045191ae2b0e/p14/Lil+Jon+ft+Eastside+Boys+%96+Get+low%28full+version%29.mp3",
	"http://online-song.net/mp3/1-46v4/23608cdf9d84c9/p23/Coolio+%96+Gangsta+s+Paradise.mp3"
}

function Garage.start(vehicles, enteredVehicleId, vehicle)
	if isActive then
		return false
	end
	isActive = true

	Garage.themePrimaryColor = {exports.dpUI:getThemeColor()}
	localPlayer.dimension = 0
	exports.dpGameTime:forceTime(12, 0)
	Assets.start()

	exports.dpChat:setVisible(false)
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
		GarageCar.start(vehicle, vehicles)
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
	exports.dpChat:setVisible(true)
	exports.dpHUD:showAll()
	toggleAllControls(true)
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
	sound:setEffectEnabled("reverb", true)
	sound.volume = 0.08
	sound.maxDistance = 50	
end

function Garage.buy(price, level, callback)
	if type(price) ~= "number" or type(level) ~= "number" or type(callback) ~= "function" then
		outputDebugString("Garage.buy: bad arguments")
		return false
	end
	if pendingBuyCallback then
		callback(false)
		exports.dpSounds:playSound("error.wav")
		return false
	end	
	if level > localPlayer:getData("level") then
		outputDebugString("Error: Not enough level")
		exports.dpSounds:playSound("error.wav")
		callback(false)
		return
	end
	if localPlayer:getData("money") < price then
		outputDebugString("Error: Not enough money")
		exports.dpSounds:playSound("error.wav")
		callback(false)
		return 
	end
	pendingBuyCallback = callback
	triggerServerEvent("dpGarage.buy", resourceRoot, price, level)
end

addEvent("dpGarage.buy", true)
addEventHandler("dpGarage.buy", resourceRoot, function (success)
	if type(pendingBuyCallback) ~= "function" then
		exports.dpSounds:playSound("error.wav")
		return false
	end
	if success then
		exports.dpSounds:playSound("sell.wav")
	end
	pendingBuyCallback(success)
	pendingBuyCallback = nil
end)