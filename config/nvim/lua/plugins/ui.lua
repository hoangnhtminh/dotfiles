-- UI tối giản. Đã bỏ dashboard, noice, notify, bufferline, indent-blankline (nặng, ít giá trị).
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = { theme = "gruvbox", globalstatus = true, component_separators = "", section_separators = "" },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = { delay = 400 },
    },
}
