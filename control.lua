require("__NindyCore-forked__/scripts/values.lua")
require("scripts.values")
mod_gui = require("mod-gui")
require("scripts.events")
require("scripts.player")
require("scripts.gui")

function on_init()
    storage.Players = storage.Players or nindycore.minesweeper.players
    for _, player in pairs(game.players) do
		generate_player({player_index=player.index})
	end
end

function on_load()
    nindycore.minesweeper.players = storage.Players or nindycore.minesweeper.players
    for _, playerObj in pairs(nindycore.minesweeper.players) do
        P:rebuild(playerObj)
    end
end

function generate_player(event)
    if nindycore.core.safeCall(nindycore.minesweeper.events.generate_player, event) == false then
        if event.player_index ~= nil and game.players[event.player_index] ~= nil and game.players[event.player_index].name ~= nil then
			game.print({"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Player-Generation-Failed"), game.players[event.player_index].name})
		else
			game.print({"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Player-Generation-Failed"), {"gui-description."..nindycore.core.add_mod_tag("Unknown")}})
		end
    end
end

function on_gui_click(event)
    if nindycore.core.safeCall(nindycore.minesweeper.gui.on_gui_clicked, event) == false then
        if event.player_index ~= nil and game.players[event.player_index] ~= nil and game.players[event.player_index].name ~= nil then
			game.print({"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Gui-Click-Failed"), game.players[event.player_index].name})
		else
			game.print({"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Gui-Click-Failed"), {"gui-description."..nindycore.core.add_mod_tag("Unknown")}})
		end
    end
end

function on_gui_closed(event)
    nindycore.core.safeCall(nindycore.minesweeper.gui.on_gui_closed, event)
end

script.on_init(on_init)
script.on_configuration_changed(on_init)
script.on_load(on_load)

script.on_event(defines.events.on_cutscene_cancelled, generate_player)
script.on_event(defines.events.on_player_created, generate_player)
script.on_event(defines.events.on_player_joined_game, generate_player)

script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_gui_closed, on_gui_closed)