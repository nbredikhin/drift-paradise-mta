local playerMenu = {
	title = "Игрок Wherry",
	items = {}
}

remotePlayerMenu = {
	{ locale = "context_menu_player_profile", enabled = false},
	{ locale = "context_menu_player_duel", 
		enabled = function(element) 
			if true then
				return false
			end
			if not isElement(element) then return false end 
			if exports.dpDuels:isAcceptWindowActive() then return false end
			return element.type == "vehicle" 
		end,

		click = function(vehicle)
			if true then
				return false
			end
			if not isElement(vehicle) then
				return
			end
			local player
			if vehicle.type == "player" then
				player = vehicle
			else
				player = vehicle.controller
			end
			exports.dpDuels:callPlayer(player)
		end
	},
	{ locale = "context_menu_player_pm", 
		click = function (player)
			if not isElement(player) then
				return
			end
			if player.type == "vehicle" then
				player = player.controller
				if not player then
					return
				end
			end
			exports.dpChat:startPM(player)
		end,

		enabled = true
	},
	{ locale = "context_menu_player_report", enabled = false}	
}

local function playAnim(name)
	return function()
		triggerServerEvent("dpAnims.playAnim", root, name)
	end
end

local localPlayerMenu = {
	{ locale = "context_menu_anim_hello", click = playAnim("hello")},
	{ locale = "context_menu_anim_no", click = playAnim("no")},
	{ locale = "context_menu_anim_bye", click = playAnim("bye")},

	{ locale = "context_menu_anim_wave", click = playAnim("wave")},
	{ locale = "context_menu_anim_lay", click = playAnim("lay")},
	{ locale = "context_menu_anim_sit", click = playAnim("sit")},
	{ locale = "context_menu_anim_fucku", click = playAnim("fucku")},
	{ locale = "context_menu_anim_serious", click = playAnim("serious")},
}

function playerMenu:init(player)
	if not isElement(player) then
		return
	end
	self.title = string.format("%s %s", 
		exports.dpLang:getString("context_menu_title_player"),
		exports.dpUtils:removeHexFromString(tostring(player.name)))

	if player.vehicle then
		return
	end
	if player == localPlayer then
		self.items = localPlayerMenu
	else
		self.items = remotePlayerMenu
	end
end

registerContextMenu("player", playerMenu)