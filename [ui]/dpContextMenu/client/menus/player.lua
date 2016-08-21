local playerMenu = {
	title = "Игрок Wherry",
	items = {
		{ locale = "context_menu_player_profile", enabled = false},
		{ locale = "context_menu_player_duel", enabled = false},
		{ locale = "context_menu_player_pm", enabled = false},
		{ locale = "context_menu_player_report", enabled = false}	
	}
}

function playerMenu:init(player)
	if player == localPlayer then
		return false
	end	
	self.title = string.format("%s %s", 
		exports.dpLang:getString("context_menu_title_player"),
		tostring(player.name))
end

registerContextMenu("player", playerMenu)