data:extend{
    {
        type = "bool-setting",
        setting_type = "runtime-per-user",
        name = "NindyCore-Minesweeper-Grace-Start",
        default_value = true
    },
    {
        type = "double-setting",
        setting_type = "runtime-per-user",
        name = "NindyCore-Minesweeper-Mine-Density",
        default_value = 0.20,
        minimum_value = 0.01,
        maximum_value = 0.99
    },
    {
        type = "int-setting",
        setting_type = "runtime-per-user",
        name = "NindyCore-Minesweeper-Board-Width",
        default_value = 12,
        minimum_value = 2,
        maximum_value = 2^7
    },
    {
        type = "int-setting",
        setting_type = "runtime-per-user",
        name = "NindyCore-Minesweeper-Board-Height",
        default_value = 10,
        minimum_value = 2,
        maximum_value = 2^7
    },
}