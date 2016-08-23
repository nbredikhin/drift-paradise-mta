local playerMenu = {
	title = "Игрок Wherry",
	items = {}
}

local remotePlayerMenu = {
	{ locale = "context_menu_player_profile", enabled = false},
	{ locale = "context_menu_player_duel", enabled = false},
	{ locale = "context_menu_player_pm", 
		click = function (player)
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
		tostring(player.name))

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