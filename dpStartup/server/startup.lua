local SHOW_MESSAGE = true
local KICK_PLAYERS = false

local DISCORD_URL = "https://discordapp.com/api/webhooks/239880086801743872/JRfmTJxiZpeH4go0DU0yJE2JaOEcAhgLSOd35S8Mm2cPf5-ZSSbFexJWxyBeG3FzNwLO/slack"
local DISCORD_INFO_INTERVAL = 60

local startupResources = {
	-- Экран загрузки должен загружаться раньше всех ресурсов
	"dpLoadingScreen",

	-- Important
	"geoip",

	-- Assets
	"dpAssets",
	"dpArrows",
	-- Configuration
	"dpConfig",
	"dpShared",
	"dpSounds",

	-- Core
	"dpUtils",
	"dpLogger",
	"dpLang",
	"dpMarkers",
	"dpCore",
	"dpPathGenerator",

	-- UI
	"dpUI",
	"dpHUD",
	"dpWorldMap",
	"dpNametags",
	"dpHideUI",
	"dpChat",

	"dpLoginPanel",
	"dpTabPanel",
	"dpMainPanel",
	"dpHelpPanel",
	"dpGiftsPanel",
	"dpModeratorPanel",

	-- Gameplay
	"dpTutorialMessage",
	"dpTime",
	"dpSafeZones",
	"dpParticles",
	"dpAnims",
	"dpVehicles",
	"dpWheelsManager",
	"dpPhotoMode",
	"dpDriftPoints",
	"dpHouses",
	"dpGarage",
	"dpCarshop",
	"dpDamage",
	"dpCameraViews",
	"dpStripClub",
	"dpTeleports",
	"dpContextMenu",
	"dpSkinSelect",
	"dpTofu",
	"dpIntro",

	-- World
	"MAPPING",
	"TD-INT",
	"TD-CARSHOP",
	"TD-MAPFILES",
	"TD-RACEMAPS",
	"TD-CHRISTMASS",

	-- Admin
	"dpAdmin",

	-- Other
	"dpGreetings",
	"dpTelegramChat",
	"dpStats",
	"server_assets",

	-- Third party
	"blur_box",
	"car_reflections",
	"water_reflections",
	"dynamic_lighting",
	"dynamic_lighting_vehicles",
	"shader_dynamic_sky",
	"snowmod",

	-- Non-important assets
	"dpCarParts",
	"dpCacheLock",
	"dpCarSound",
	"dpRadio",
	"dpAntiAFK",
	"dpDriftSound",
	"dpSkins",
	"fara",
	"svet",
}

local function processResourceByName(resourceName, start)
	local resource = getResourceFromName(resourceName)
	if not resource then
		return false
	end
	if start then
		startResource(resource)
		if resource.state == "running" then
			return true
		else
			return false
		end
	else
		return stopResource(resource)
	end
end

local function showDiscordMessage(message)
	fetchRemote(
		DISCORD_URL,
		function ()end,
		'{"text": "' .. tostring(message) ..'", "username": "' .. tostring(getServerName()) ..'"}')
end

addEventHandler("onResourceStart", resourceRoot, function ()
	showDiscordMessage("Сервер снова **запущен**!")
	local startedResourcesCount = 0
	setMaxPlayers(250)
	for i, resourceName in ipairs(startupResources) do
		if processResourceByName(resourceName, true) then
			startedResourcesCount = startedResourcesCount + 1
		else
			outputDebugString("startup: failed to start '" .. tostring(resourceName) .. "'")
		end
	end
end)

function shutdownGamemode(showMessage, kickPlayers)
	showDiscordMessage("Сервер **выключен**.")
	if showMessage then
		for i = 1, 20 do
			outputChatBox(" ", root, 255, 0, 0)
		end
		outputChatBox("*** GAMEMODE SHUTDOWN ***", root, 255, 0, 0)
	end
	-- Кик всех игроков перед выключением
	if kickPlayers then
		for i, player in ipairs(getElementsByType("player")) do
			player:kick("Drift Paradise", "GAMEMODE RESTART/SHUTDOWN")
		end
	end
	-- Выключение всех ресурсов
	for i, resourceName in ipairs(startupResources) do
		processResourceByName(resourceName, false)
	end
end

addEventHandler("onResourceStop", resourceRoot, function ()
	shutdownGamemode(SHOW_MESSAGE, KICK_PLAYERS)
end)

function shutdownServer()
	shutdownGamemode(true, true)
	setServerPassword("pls_dont_connect_or_everything_could_fuck_up")
	outputServerLog("startup: Shutdown after 3 seconds...")
	setTimer(function()
		setServerPassword(nil)
		shutdown("Server shutdown/restarting")
	end, 3000, 1)
end

setTimer(function ()
	local playersCount = tostring(#getElementsByType("player")) .. "/" .. tostring(getMaxPlayers())
	showDiscordMessage("Количество игроков на сервере: **" .. playersCount .. "**")
end, DISCORD_INFO_INTERVAL * 60 * 1000, 0)
