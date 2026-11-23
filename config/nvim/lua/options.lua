local opt = vim.opt

-- Giao diện
opt.number         = true
opt.relativenumber = true
opt.numberwidth    = 2
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.fillchars      = { eob = " " }
opt.wrap           = false
opt.scrolloff      = 8
opt.sidescrolloff  = 5
opt.laststatus     = 3
opt.showmode       = false
opt.winborder      = "rounded"
opt.termguicolors  = true
opt.pumblend       = 0          -- không trong suốt popup cho đỡ tốn
opt.pumheight      = 10
opt.background     = "dark"

-- Thụt lề
opt.expandtab   = true
opt.tabstop     = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.smartindent = true

-- Tìm kiếm
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

-- Hệ thống
opt.undofile   = true
opt.swapfile   = false
opt.backup     = false
opt.clipboard  = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 400
opt.splitbelow = true
opt.splitright = true
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
