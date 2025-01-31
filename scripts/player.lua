P = {
    thisEntity = nil,
    gui = nil,
    board = nil,
    gameStarted = false,
    gameFinished = true,
    gameWon = false,
    width = 2,
    height = 2,
    density = 0.2,
    grace = true,
    mines = 1,
    flags = 1,
    hiddenTiles = 1,
    resetButton = nil
}

function P:new(player)
    if player == nil then return end
    local t = {}
    local mt = {}
    setmetatable(t, mt)
    mt.__index = P
    t.thisEntity = player
    t.gui = {}
    t.board = {}
    return t
end

function P:rebuild(object)
    if object == nil then return end
    local mt = {}
    mt.__index = P
    setmetatable(object, mt)
end

function P:generate_board(guiTable, scrollpane)
    local board = nindycore.core.gui.add_table(guiTable, "", scrollpane, self.width)
    for row = 1, self.height do
        self.board[row] = {}
        for column = 1, self.width do
            self.board[row][column] = {
                button = nindycore.core.gui.add_button(guiTable, nindycore.core.add_mod_tag(minesweeper_id.."Game-MineButton-")..column.."-"..row, board, nindycore.core.sprites["blank32"], nindycore.core.sprites["blank32"], nindycore.core.sprites["blank32"], "", 37, false, true, nil, nindycore.core.gui.styles["B-1"], {ID=self.thisEntity.index, column=column, row=row}),
                is_enabled = true,
                sprite = nindycore.core.sprites["blank32"],
                style = nindycore.core.gui.styles["B-1"],
                tile_id = 0,
                is_flaged = false,
                row = row,
                column = column
            }
        end
    end
    if not self.grace then
        self:generate_mines(nil)
    end
end

function P:generate_mines(button)
    local m = self.mines
    while m > 0 do
        local column = math.random(1, self.width)
        local row = math.random(1, self.height)
        if self.board[row][column].tile_id ~= -1 then
            if button ~= nil and button.row == row and button.column == column then goto skip end
            self.board[row][column].tile_id = -1
            m = m - 1
        end
        ::skip::
    end
    self:generate_numbers()
end

function P:generate_numbers()
    for row_index = 1, self.height do
        for column_index = 1,self.width do
            if self.board[row_index][column_index].tile_id == -1 then goto next end
            local neighbors = 0
            --Checks Top Left
            if row_index > 1 and column_index > 1 and self.board[row_index-1][column_index-1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Top
            if row_index > 1 and self.board[row_index-1][column_index].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Top Right
            if row_index > 1 and column_index < self.width and self.board[row_index-1][column_index+1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Left
            if column_index > 1 and self.board[row_index][column_index-1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Right
            if column_index < self.width and self.board[row_index][column_index+1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Bottom Left
            if row_index < self.height and column_index > 1 and self.board[row_index+1][column_index-1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Bottom
            if row_index < self.height and self.board[row_index+1][column_index].tile_id == -1 then
                neighbors = neighbors + 1
            end
            --Checks Bottom Right
            if row_index < self.height and column_index < self.width and self.board[row_index+1][column_index+1].tile_id == -1 then
                neighbors = neighbors + 1
            end
            self.board[row_index][column_index].tile_id = neighbors
            ::next::
        end
    end
end

function P:load_board(guiTable, scrollpane)
    if self.gameFinished then
        if not self.gameWon then
            nindycore.minesweeper.gui.change_button_icon(self.resetButton, nindycore.minesweeper.sprites["sad"], nindycore.minesweeper.sprites["gasp"], nindycore.minesweeper.sprites["sad"])
        else
            nindycore.minesweeper.gui.change_button_icon(self.resetButton, nindycore.minesweeper.sprites["cool"], nindycore.minesweeper.sprites["gasp"], nindycore.minesweeper.sprites["cool"])
        end
    end
    local board = nindycore.core.gui.add_table(guiTable, "", scrollpane, self.width)
    local temp_board = {}
    for row_index = 1, self.height do
        temp_board[row_index] = {}
        for column_index = 1, self.width do
            temp_board[row_index][column_index] = {
                button = nindycore.core.gui.add_button(guiTable, nindycore.core.add_mod_tag(minesweeper_id.."Game-MineButton-")..column_index.."-"..row_index, board, nindycore.core.sprites["blank32"], nindycore.core.sprites["blank32"], nindycore.core.sprites["blank32"], "", 37, false, true, nil,
                    nindycore.core.gui.styles["B-1"], {ID=self.thisEntity.index, column=column_index, row=row_index}),
                is_enabled = self.board[row_index][column_index].is_enabled,
                sprite = self.board[row_index][column_index].sprite,
                style = self.board[row_index][column_index].style,
                tile_id = self.board[row_index][column_index].tile_id,
                is_flaged = self.board[row_index][column_index].is_flaged,
                row = row_index,
                column = column_index
            }
            self:show_tile(temp_board[row_index][column_index])
        end
    end
    self.board = temp_board
    guiTable.vars["Flags"].caption = {"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Flags"), self.flags}
end

function P:show_tile(button)
    if self.gameFinished then
        nindycore.minesweeper.gui.switch_button_style(button.button, button.style, 37)
        nindycore.minesweeper.gui.change_button_icon(button.button, button.sprite)
        return
    end
    local sprite = ""
    if button.tile_id == 0 then
        sprite = nindycore.core.sprites["blank32"]
    elseif button.tile_id > 0 then
        sprite = nindycore.minesweeper.sprites[tostring(button.tile_id)]
    end
    if button.is_flaged then sprite = nindycore.minesweeper.sprites["flag"] end
    if sprite == "" then return end
    if not button.is_enabled then
        local style = button.tile_id > 0 and nindycore.minesweeper.gui.styles["B-1"] or nindycore.core.gui.styles["B-2"]
        nindycore.minesweeper.gui.switch_button_style(button.button, style, 37)
        nindycore.minesweeper.gui.change_button_icon(button.button, sprite)
        if button.tile_id > 0 then nindycore.minesweeper.gui.change_button_mouse_filter(button.button, {"middle"}) end
        button.style = style
        button.sprite = sprite
    elseif button.is_enabled and button.is_flaged then
        nindycore.minesweeper.gui.change_button_icon(button.button, sprite)
        button.sprite = sprite
    end
end

function P:flag_tile(button)
    if not button.is_flaged and self.flags > 0 then
        nindycore.minesweeper.gui.change_button_icon(button.button, nindycore.minesweeper.sprites["flag"])
        button.sprite = nindycore.minesweeper.sprites["flag"]
        self.flags = self.flags - 1
        button.is_flaged = true
    elseif button.is_flaged then
        nindycore.minesweeper.gui.change_button_icon(button.button, nindycore.core.sprites["blank32"])
        button.sprite = nindycore.core.sprites["blank32"]
        self.flags = self.flags + 1
        button.is_flaged = false
    end
end

function P:validate_chord(button)
    local buttons = {}
    local flags = 0
    local target_flags = button.tile_id
    local row_index = button.row
    local column_index = button.column

    --Checks Top Left
    if row_index > 1 and column_index > 1 then
        if self.board[row_index-1][column_index-1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index-1][column_index-1])
    end
    --Checks Top
    if row_index > 1 then
        if self.board[row_index-1][column_index].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index-1][column_index])
    end
    --Checks Top Right
    if row_index > 1 and column_index < self.width then
        if self.board[row_index-1][column_index+1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index-1][column_index+1])
    end
    --Checks Left
    if column_index > 1 then
        if self.board[row_index][column_index-1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index][column_index-1])
    end
    --Checks Right
    if column_index < self.width then
        if self.board[row_index][column_index+1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index][column_index+1])
    end
    --Checks Bottom Left
    if row_index < self.height and column_index > 1 then
        if self.board[row_index+1][column_index-1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index+1][column_index-1])
    end
    --Checks Bottom
    if row_index < self.height then
        if self.board[row_index+1][column_index].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index+1][column_index])
    end
    --Checks Bottom Right
    if row_index < self.height and column_index < self.width then
        if self.board[row_index+1][column_index+1].is_flaged then flags = flags + 1 end
        table.insert(buttons, self.board[row_index+1][column_index+1])
    end

    if flags ~= target_flags then return end
    for _, button in pairs(buttons) do
        if button.tile_id == -1 and not button.is_flaged then
            self:lose_game(button)
            return
        elseif not button.is_flaged and button.is_enabled then
            button.is_enabled = false
            self.hiddenTiles = self.hiddenTiles - 1
            if button.tile_id == 0 then
                local tiles = {}
                table.insert(tiles, button)
                self:reveal_zeros(tiles)
            else
                self:show_tile(button)
            end
            if self.hiddenTiles ==self.mines then
                self:win_game()
            end
        end
    end
end

function P:lose_game(button)
    self.gameFinished = true
    nindycore.minesweeper.gui.change_button_icon(self.resetButton, nindycore.minesweeper.sprites["sad"], nindycore.minesweeper.sprites["gasp"], nindycore.minesweeper.sprites["sad"])
    nindycore.minesweeper.gui.switch_button_style(button.button, nindycore.core.gui.styles["B-3"], 37)
    nindycore.minesweeper.gui.change_button_icon(button.button, nindycore.minesweeper.sprites["bomb"])
    button.style = nindycore.core.gui.styles["B-3"]
    button.sprite = nindycore.minesweeper.sprites["bomb"]
    for row_index, _ in pairs(self.board) do
        for column_index, _ in pairs(self.board[row_index]) do
            if not self.board[row_index][column_index].is_enabled then goto next end
            if self.board[row_index][column_index].is_flaged and self.board[row_index][column_index].tile_id ~= -1 then
                nindycore.minesweeper.gui.change_button_icon(self.board[row_index][column_index].button, nindycore.minesweeper.sprites["flaged_bomb"])
                self.board[row_index][column_index].sprite = nindycore.minesweeper.sprites["flaged_bomb"]
            elseif not self.board[row_index][column_index].is_flaged and self.board[row_index][column_index].tile_id == -1 then
                nindycore.minesweeper.gui.change_button_icon(self.board[row_index][column_index].button, nindycore.minesweeper.sprites["bomb"])
                self.board[row_index][column_index].sprite = nindycore.minesweeper.sprites["bomb"]
            end
            ::next::
        end
    end
end

function P:win_game()
    self.gameWon = true
    self.gameFinished = true
    nindycore.minesweeper.gui.change_button_icon(self.resetButton, nindycore.minesweeper.sprites["cool"], nindycore.minesweeper.sprites["gasp"], nindycore.minesweeper.sprites["cool"])
    for row_index, _ in pairs(self.board) do
        for column_index, _ in pairs(self.board[row_index]) do
            if not self.board[row_index][column_index].is_enabled or self.board[row_index][column_index].is_flaged then goto next end
            self:flag_tile(self.board[row_index][column_index])
            ::next::
        end
    end
end

function P:reveal_zeros(tiles)
    if nindycore.core.get_table_length(tiles, true) == 0 then return end
    local button = table.remove(tiles, 1)

    if button.tile_id == 0 then
        button.is_enabled = false
        self:show_tile(button)
        local row_index = button.row
        local column_index = button.column

        --Checks Top Left
        if row_index > 1 and column_index > 1 and self.board[row_index-1][column_index-1].is_enabled and not self.board[row_index-1][column_index-1].is_flaged then
            self.board[row_index-1][column_index-1].is_enabled = false
            self:show_tile(self.board[row_index-1][column_index-1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index-1][column_index-1].tile_id == 0 then table.insert(tiles, self.board[row_index-1][column_index-1]) end
        end
        --Checks Top
        if row_index > 1 and self.board[row_index-1][column_index].is_enabled and not self.board[row_index-1][column_index].is_flaged  then
            self.board[row_index-1][column_index].is_enabled = false
            self:show_tile(self.board[row_index-1][column_index])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index-1][column_index].tile_id == 0 then table.insert(tiles, self.board[row_index-1][column_index]) end
        end
        --Checks Top Right
        if row_index > 1 and column_index < self.width and self.board[row_index-1][column_index+1].is_enabled and not self.board[row_index-1][column_index+1].is_flaged  then
            self.board[row_index-1][column_index+1].is_enabled = false
            self:show_tile(self.board[row_index-1][column_index+1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index-1][column_index+1].tile_id == 0 then table.insert(tiles, self.board[row_index-1][column_index+1]) end
        end
        --Checks Left
        if column_index > 1 and self.board[row_index][column_index-1].is_enabled and not self.board[row_index][column_index-1].is_flaged  then
            self.board[row_index][column_index-1].is_enabled = false
            self:show_tile(self.board[row_index][column_index-1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index][column_index-1].tile_id == 0 then table.insert(tiles, self.board[row_index][column_index-1]) end
        end
        --Checks Right
        if column_index < self.width and self.board[row_index][column_index+1].is_enabled and not self.board[row_index][column_index+1].is_flaged  then
            self.board[row_index][column_index+1].is_enabled = false
            self:show_tile(self.board[row_index][column_index+1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index][column_index+1].tile_id == 0 then table.insert(tiles, self.board[row_index][column_index+1]) end
        end
        --Checks Bottom Left
        if row_index < self.height and column_index > 1 and self.board[row_index+1][column_index-1].is_enabled and not self.board[row_index+1][column_index-1].is_flaged  then
            self.board[row_index+1][column_index-1].is_enabled = false
            self:show_tile(self.board[row_index+1][column_index-1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index+1][column_index-1].tile_id == 0 then table.insert(tiles, self.board[row_index+1][column_index-1]) end
        end
        --Checks Bottom
        if row_index < self.height and self.board[row_index+1][column_index].is_enabled and not self.board[row_index+1][column_index].is_flaged  then
            self.board[row_index+1][column_index].is_enabled = false
            self:show_tile(self.board[row_index+1][column_index])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index+1][column_index].tile_id == 0 then table.insert(tiles, self.board[row_index+1][column_index]) end
        end
        --Checks Bottom Right
        if row_index < self.height and column_index < self.width and self.board[row_index+1][column_index+1].is_enabled and not self.board[row_index+1][column_index+1].is_flaged  then
            self.board[row_index+1][column_index+1].is_enabled = false
            self:show_tile(self.board[row_index+1][column_index+1])
            self.hiddenTiles = self.hiddenTiles - 1
            if self.board[row_index+1][column_index+1].tile_id == 0 then table.insert(tiles, self.board[row_index+1][column_index+1]) end
        end
        self:reveal_zeros(tiles)
    end
end

function P:generate_gui(justCreated, guiTable, mainFrame)
    if justCreated then
        if self.gameFinished and not self.gameStarted then
            self.width = settings.get_player_settings(self.thisEntity.index)[nindycore.core.add_mod_tag(minesweeper_id.."Board-Width")].value
            self.height = settings.get_player_settings(self.thisEntity.index)[nindycore.core.add_mod_tag(minesweeper_id.."Board-Height")].value
            self.density = settings.get_player_settings(self.thisEntity.index)[nindycore.core.add_mod_tag(minesweeper_id.."Mine-Density")].value
            self.grace = settings.get_player_settings(self.thisEntity.index)[nindycore.core.add_mod_tag(minesweeper_id.."Grace-Start")].value
            local size = self.width * self.height
            self.hiddenTiles = size
            self.mines = math.min(size-1, math.max(math.floor(size * self.density), 1))
            self.flags = self.mines
        end

        guiTable.vars["title"].caption = {"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Title")}

        local mainFrame = nindycore.core.gui.add_frame(guiTable, "", mainFrame, "vertical", false)
		mainFrame.style = nindycore.core.gui.styles["F-1"]
		mainFrame.style.vertically_stretchable = true
		mainFrame.style.horizontally_stretchable = true
		mainFrame.style.minimal_width = math.min(1200, 37*self.width+25)
        mainFrame.style.minimal_height = math.min(600-60, 37*self.height+25)
		mainFrame.style.padding = 3
        mainFrame.style.margin = 3

        --local mainFlow = nindycore.core.gui.add_flow(guiTable, "", mainFrame, "vertical", false)

        local topBarFlow = nindycore.core.gui.add_flow(guiTable, "", mainFrame, "horizontal", false)
        local bottomBarFlow = nindycore.core.gui.add_flow(guiTable, "", mainFrame, "horizontal", false)

        local flagFrame = nindycore.core.gui.add_frame(guiTable, "", topBarFlow, "horizontal", false)
        flagFrame.style = nindycore.core.gui.styles["F-1"]
        flagFrame.style.vertical_align = "center"
		flagFrame.style.vertically_stretchable = true
		flagFrame.style.horizontally_stretchable = true
		flagFrame.style.minimal_width = 37
        flagFrame.style.minimal_height = 37
		flagFrame.style.padding = 3
        flagFrame.style.margin = 3

        local flagText = nindycore.core.gui.add_label(guiTable, "Flags", flagFrame, {"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Flags"), self.flags}, nindycore.core.gui.colors["white"], "", true)
        flagText.style.font = nindycore.core.gui.fonts["SB-20"]

        nindycore.core.gui.add_label(guiTable, "", topBarFlow, "        ")

        local startstopFrame = nindycore.core.gui.add_frame(guiTable, "", topBarFlow, "horizontal", false)
        startstopFrame.style = nindycore.core.gui.styles["F-1"]
        startstopFrame.style.vertical_align = "center"
		startstopFrame.style.vertically_stretchable = true
		startstopFrame.style.horizontally_stretchable = true
		startstopFrame.style.minimal_width = 37
        startstopFrame.style.minimal_height = 37
		startstopFrame.style.padding = 3
        startstopFrame.style.margin = 3
        self.resetButton = nindycore.core.gui.add_button(guiTable, nindycore.core.add_mod_tag(minesweeper_id.."Game-ResetButton"), startstopFrame, nindycore.minesweeper.sprites["smile"], nindycore.minesweeper.sprites["gasp"], nindycore.minesweeper.sprites["sad"], "", 37, false, true, nil, nindycore.core.gui.styles["B-1"], {ID=self.thisEntity.index})

        local gameFrame = nindycore.core.gui.add_frame(guiTable, "", bottomBarFlow, "vertical", false)
		gameFrame.style = nindycore.core.gui.styles["F-1"]
		gameFrame.style.vertically_stretchable = true
		gameFrame.style.horizontally_stretchable = true
		gameFrame.style.minimal_width = math.min(1200, 37*self.width+25)
        gameFrame.style.minimal_height = math.min(600-60, 37*self.height+25)
		gameFrame.style.padding = 3
        gameFrame.style.margin = 3

		local gameScrollPane = nindycore.core.gui.add_scroll_pane(guiTable, "ScrollPane", gameFrame, 1200, 600-60, true, nil, "always", "always")
		gameScrollPane.style = nindycore.core.gui.styles["SP-1"]
		gameScrollPane.style.vertically_stretchable = true
		gameScrollPane.style.horizontally_stretchable = true
    end

    local gameScrollPane = guiTable.vars["ScrollPane"]
    gameScrollPane.clear()
    if not self.gameStarted and self.gameFinished then
        self:generate_board(guiTable, gameScrollPane)
    else
        self:load_board(guiTable, gameScrollPane)
    end
end

function P.interaction(event, msPlayer)
    local tags = event.element.tags
    local guiTable = msPlayer.gui[nindycore.core.gui.titles["main"]]
    local click = -1
    if event.button == defines.mouse_button_type.left then click = 0 end --Show
	if event.button == defines.mouse_button_type.right then click = 1 end --Flag
    if event.button == defines.mouse_button_type.middle then click = 2 end --Chord
    if click == -1 then return end

    if string.match(event.element.name, "MineButton") ~= nil then
        local button = msPlayer.board[tags.row][tags.column]
        if not msPlayer.gameStarted and msPlayer.gameFinished then
            msPlayer.gameStarted = true
            msPlayer.gameFinished = false
            if msPlayer.grace then
                msPlayer:generate_mines(button)
            end
        end

        if msPlayer.gameStarted and msPlayer.gameFinished then return end

        if click == 0 and not button.is_flaged and button.is_enabled then
            if button.tile_id == -1 then
                button.is_enabled = false
                msPlayer:lose_game(button)
            else
                button.is_enabled = false
                msPlayer.hiddenTiles = msPlayer.hiddenTiles - 1
                if button.tile_id == 0 then
                    local tiles = {}
                    table.insert(tiles, button)
                    msPlayer:reveal_zeros(tiles)
                else
                    msPlayer:show_tile(button)
                end
                if msPlayer.hiddenTiles == msPlayer.mines then
                    msPlayer:win_game()
                end
            end
        elseif click == 1 and button.is_enabled then
            msPlayer:flag_tile(button)
            guiTable.vars["Flags"].caption = {"gui-description."..nindycore.core.add_mod_tag(minesweeper_id.."Flags"), msPlayer.flags}
        elseif click == 2 and not button.is_enabled and button.tile_id > 0 then
            msPlayer:validate_chord(button)
        end
        return
    end

    if string.match(event.element.name, "ResetButton") ~= nil then
        msPlayer.gameStarted = false
        msPlayer.gameFinished = true
        msPlayer.gameWon = false
        nindycore.minesweeper.gui.remove_gui(msPlayer)
        nindycore.minesweeper.gui.open_gui(msPlayer)
        return
    end
end