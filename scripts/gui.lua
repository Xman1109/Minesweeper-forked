function nindycore.minesweeper.gui.attach_mod_gui(player)
    if player == nil then return end
    local button_flow = mod_gui.get_button_flow(player)
    return button_flow.add{type="sprite-button", name=nindycore.core.add_mod_tag(minesweeper_id.."mod-button"), sprite=nindycore.minesweeper.sprites["flag"], style=mod_gui.button_style}
end

function nindycore.minesweeper.gui.create_window(player)
    local guiTable = nindycore.core.gui.create_base_window(player, nindycore.core.gui.titles["main"], "vertical", false, true, true, "horizontal")
    nindycore.minesweeper.players[player.name].gui[nindycore.core.gui.titles["main"]] = guiTable
    return guiTable
end

function nindycore.minesweeper.gui.update_gui(msPlayer)
    msPlayer:generate_gui(false, msPlayer.gui[nindycore.core.gui.titles["main"]], msPlayer.gui[nindycore.core.gui.titles["main"]].vars[nindycore.core.gui.titles["main"]])
end

function nindycore.minesweeper.gui.open_gui(msPlayer)
    local guiTable = nindycore.minesweeper.gui.create_window(msPlayer.thisEntity)
    msPlayer:generate_gui(true, guiTable, guiTable.vars[nindycore.core.gui.titles["main"]])
    msPlayer.thisEntity.opened = guiTable.gui
end

function nindycore.minesweeper.gui.remove_gui(msPlayer)
    msPlayer.gui[nindycore.core.gui.titles["main"]].gui.destroy()
    msPlayer.gui[nindycore.core.gui.titles["main"]] = nil
end

function nindycore.minesweeper.gui.on_gui_clicked(event)
    local msPlayer = nindycore.minesweeper.players[nindycore.core.get_player(event.player_index).name]
    if msPlayer == nil or msPlayer.valid == false then return end
    local eName = nindycore.core.gsub(event.element.name, "%-", "_")

    if eName == nindycore.core.gsub(nindycore.core.add_mod_tag(minesweeper_id.."mod-button"), "%-", "_") then
        nindycore.minesweeper.gui.open_gui(msPlayer)
        return
    end

    if eName == nindycore.core.gsub(nindycore.core.gui.titles["main"] .. "_CloseButton", "%-", "_") then
        nindycore.minesweeper.gui.remove_gui(msPlayer)
        return
    end

    if string.match(eName, nindycore.core.gsub(nindycore.core.add_mod_tag(minesweeper_id.."Game"), "%-", "_")) ~= nil then
        P.interaction(event, msPlayer)
        --nindycore.minesweeper.gui.update_gui(msPlayer)
        return
    end
end

function nindycore.minesweeper.gui.on_gui_closed(event)
    if event.element == nil or event.element.valid == false then return end
    local msPlayer = nindycore.minesweeper.players[nindycore.core.get_player(event.player_index).name]
    
    if event.element.name == nindycore.core.gui.titles["main"] then
        msPlayer.gui[nindycore.core.gui.titles["main"]].gui.destroy()
        msPlayer.gui[nindycore.core.gui.titles["main"]] = nil
        return
    end
end

function nindycore.minesweeper.gui.switch_button_style(button, style, size)
    if button == nil or button.valid == false then return end
    button.style = style
    button.style.minimal_width = size
    button.style.maximal_width = size
    button.style.minimal_height = size
    button.style.maximal_height = size
    button.style.padding = 0
    button.style.margin = 0
end

function nindycore.minesweeper.gui.change_button_icon(button, default, hover, click)
    if button == nil or button.valid == false then return end
    button.sprite = default
    button.hovered_sprite = hover or default
    button.clicked_sprite = click or default
    return
end

function nindycore.minesweeper.gui.change_button_mouse_filter(button, filter)
    if button == nil or button.valid == false then return end
    button.mouse_button_filter = filter
end