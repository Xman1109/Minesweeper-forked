minesweeper_id = "Minesweeper-"
if not nindycore then nindycore = {} end
if not nindycore.minesweeper then nindycore.minesweeper = {} end
if not nindycore.minesweeper.events then nindycore.minesweeper.events = {} end
if not nindycore.minesweeper.gui then nindycore.minesweeper.gui = {} end
if not nindycore.minesweeper.gui.styles then nindycore.minesweeper.gui.styles = {} end
if not nindycore.minesweeper.sprites then nindycore.minesweeper.sprites = {} end
if not nindycore.minesweeper.players then nindycore.minesweeper.players = {} end

nindycore.minesweeper.gui.styles = {
    ["B-1"] = nindycore.core.add_mod_tag(minesweeper_id.."Style-B-1"),
}

nindycore.minesweeper.sprites = {
    ["bomb"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-bomb"),
    ["flaged_bomb"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-flaged_bomb"),
    ["flag"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-flag"),
    ["smile"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-smile"),
    ["cool"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-cool"),
    ["sad"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-sad"),
    ["gasp"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-gasp"),
    ["1"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-1"),
    ["2"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-2"),
    ["3"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-3"),
    ["4"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-4"),
    ["5"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-5"),
    ["6"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-6"),
    ["7"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-7"),
    ["8"] = nindycore.core.add_mod_tag(minesweeper_id.."Sprite-8"),
}