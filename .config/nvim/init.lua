-- Neovim 0.11+ (dùng LSP/completion/commenting tích hợp sẵn -> ít plugin hơn, khởi động nhanh)
vim.loader.enable()          -- cache bytecode Lua

require("options")
require("keymaps")           -- đặt leader trước khi nạp plugin

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "Không clone được lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
        return
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    checker = { enabled = false },                -- không tự kiểm tra cập nhật nền
    change_detection = { notify = false },
    ui = { border = "rounded" },
    performance = {
        rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin" } },
    },
})

require("lsp")
