-- LSP bằng API tích hợp của Neovim 0.11+ (không cần lspconfig/mason).
-- Server nào có trong PATH mới được bật:  clangd, lua-language-server, pyright, bash-language-server
if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then return end

local servers = {
    clangd = {
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } },
                             workspace = { checkThirdParty = false } } },
    },
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    },
    bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
    },
}

for name, cfg in pairs(servers) do
    if vim.fn.executable(cfg.cmd[1]) == 1 then
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
    end
end

vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = "●" },
    severity_sort = true,
    float = { border = "rounded" },
})

-- Completion tích hợp sẵn
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/completion") and vim.lsp.completion then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- Treesitter tích hợp sẵn: bật cho filetype nào có parser (lua, c, vim, markdown, …)
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})
