function nindycore.minesweeper.events.generate_player(event)
	local player = nindycore.core.get_player(event.player_index)
	if player == nil then return end
	if player.controller_type == defines.controllers.cutscene then return end
	if nindycore.minesweeper.players[player.name] == nil then
		nindycore.minesweeper.players[player.name] = P:new(player)
        nindycore.minesweeper.players[player.name].gui["mod-gui"] = nindycore.minesweeper.gui.attach_mod_gui(player)
	end
end