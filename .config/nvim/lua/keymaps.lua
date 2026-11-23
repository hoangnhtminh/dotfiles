vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Cơ bản
map("n", "<Esc>",      "<cmd>nohlsearch<CR>", { desc = "Bỏ highlight tìm kiếm" })
map("n", "<leader>w",  "<cmd>w<CR>",          { desc = "Lưu" })
map("n", "<leader>q",  "<cmd>q<CR>",          { desc = "Thoát" })
map("n", "<leader>Q",  "<cmd>qa!<CR>",        { desc = "Thoát tất cả (bỏ thay đổi)" })

-- Cửa sổ
map("n", "<C-h>", "<C-w>h"); map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k"); map("n", "<C-l>", "<C-w>l")
map("n", "<C-Up>",    "<cmd>resize +2<CR>");          map("n", "<C-Down>",  "<cmd>resize -2<CR>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>"); map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Chia dọc" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Chia ngang" })

-- Buffer
map("n", "<Tab>",      "<cmd>bnext<CR>",     { desc = "Buffer sau" })
map("n", "<S-Tab>",    "<cmd>bprevious<CR>", { desc = "Buffer trước" })
map("n", "<leader>bd", "<cmd>bdelete<CR>",   { desc = "Đóng buffer" })

-- Chỉnh sửa
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Dời dòng xuống" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Dời dòng lên" })
map("v", "<", "<gv"); map("v", ">", ">gv")
map("v", "p", '"_dP')

-- Tìm file (fzf-lua dùng chính binary fzf đã cài, nhẹ hơn telescope)
map("n", "<leader>ff", "<cmd>FzfLua files<CR>",     { desc = "Tìm file" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>",   { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>FzfLua helptags<CR>",  { desc = "Help" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>",  { desc = "File gần đây" })

-- File explorer (mini.files)
map("n", "<leader>e", function()
    local mf = require("mini.files")
    if not mf.close() then mf.open(vim.api.nvim_buf_get_name(0), false) end
end, { desc = "Explorer" })

-- LSP (có hiệu lực khi server đã gắn vào buffer)
map("n", "K",          vim.lsp.buf.hover,       { desc = "Hover" })
map("n", "gd",         vim.lsp.buf.definition,  { desc = "Đến định nghĩa" })
map("n", "gr",         vim.lsp.buf.references,  { desc = "Tham chiếu" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename,      { desc = "Đổi tên" })
map("n", "<leader>d",  vim.diagnostic.open_float, { desc = "Chẩn đoán" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Lỗi trước" })
map("n", "]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, { desc = "Lỗi sau" })

-- Terminal tích hợp sẵn (thay toggleterm)
map("n", "<leader>t", "<cmd>botright 15split | terminal<CR>i", { desc = "Terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Thoát chế độ terminal" })
