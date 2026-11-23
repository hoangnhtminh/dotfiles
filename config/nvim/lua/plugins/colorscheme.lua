-- Gruvbox: tông ấm, hợp với bảng màu "Ember" của cả hệ thống; có sẵn bat/lualine/fzf-lua.
return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            contrast = "hard",
            transparent_mode = true,
            italic = { strings = false, comments = true, operators = false, folds = false },
            palette_overrides = {
                dark0_hard    = "#1a1512",
                bright_orange = "#e8824a",
                neutral_orange = "#c4683a",
                bright_yellow = "#e8c24a",
                bright_red    = "#e85a4a",
                bright_green  = "#8ac44a",
                bright_blue   = "#4a98e8",
            },
        },
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.cmd.colorscheme("gruvbox")
        end,
    },
}
