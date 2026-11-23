return {
    -- Tìm file / grep (dùng binary fzf + fd + rg đã cài sẵn)
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        opts = { winopts = { border = "rounded", preview = { layout = "vertical" } } },
    },

    -- Git
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = { signs = { add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" } } },
    },

    -- mini.nvim: icons, explorer, pairs, surround, ai, move — 1 repo thay cho 6 plugin
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.icons").setup()
            MiniIcons.mock_nvim_web_devicons()
            require("mini.files").setup({ windows = { preview = true, width_preview = 50 } })
            require("mini.pairs").setup()
            require("mini.surround").setup()
            require("mini.ai").setup()
            require("mini.move").setup()
        end,
    },
}
