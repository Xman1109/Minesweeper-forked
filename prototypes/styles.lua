data.raw["gui-style"].default[nindycore.minesweeper.gui.styles["B-1"]] =
{
	type = "button_style",
	--parent = "button",
	minimal_width = 40,
	minimal_height = 40,
	default_graphical_set =
	{
		base = {position={68, 0}, corner_size=8, tint={255, 255, 255}},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position={34, 17}, corner_size=8, tint={255, 255, 255}},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position={51, 17}, corner_size=8, tint={255, 255, 255}},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}