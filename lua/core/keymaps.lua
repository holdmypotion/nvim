local map = require("helpers.keys").map

-- Blazingly fast way out of insert mode
map("i", "jk", "<esc>")

-- Quick access to some common actions
map("n", "<leader>fw", "<cmd>w<cr>", "Write")
map("n", "<leader>fa", "<cmd>wa<cr>", "Write all")
map("n", "<leader>qq", "<cmd>q<cr>", "Quit")
map("n", "<leader>qa", "<cmd>qa!<cr>", "Quit all")
map("n", "<leader>dw", "<cmd>close<cr>", "Window")

-- Diagnostic keymaps
map('n', 'gx', vim.diagnostic.open_float, "Show diagnostics under cursor")

-- Easier access to beginning and end of lines
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", "Navigate windows to the left")
map("n", "<C-j>", "<C-w><C-j>", "Navigate windows down")
map("n", "<C-k>", "<C-w><C-k>", "Navigate windows up")
map("n", "<C-l>", "<C-w><C-l>", "Navigate windows to the right")

-- Move with shift-arrows
map("n", "<S-Left>", "<C-w><S-h>", "Move window to the left")
map("n", "<S-Down>", "<C-w><S-j>", "Move window down")
map("n", "<S-Up>", "<C-w><S-k>", "Move window up")
map("n", "<S-Right>", "<C-w><S-l>", "Move window to the right")

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Deleting buffers
local buffers = require("helpers.buffers")
map("n", "<leader>bd", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Switch between light and dark modes
map("n", "<leader>ut", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end, "Toggle between light and dark themes")

-- Clear after search
map("n", "<leader>ur", "<cmd>nohl<cr>", "Clear highlights")

-- Necessity
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { noremap = true, silent = true, desc = "Netrw Explorer" })
vim.keymap.set("n", "<leader>q", vim.lsp.buf.format)

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.api.nvim_set_keymap('n', '<Leader>cp', ':let @+ = expand("%")<CR>', { noremap = true, silent = true })

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })


-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
map("n", "]d", diagnostic_goto(true), "Next Diagnostic")
map("n", "[d", diagnostic_goto(false), "Prev Diagnostic")
map("n", "]e", diagnostic_goto(true, "ERROR"), "Next Error")
map("n", "[e", diagnostic_goto(false, "ERROR"), "Prev Error")
map("n", "]w", diagnostic_goto(true, "WARN"), "Next Warning")
map("n", "[w", diagnostic_goto(false, "WARN"), "Prev Warning")


map("i", "<M-BS>", "<C-w>", "Remove word")
