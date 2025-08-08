local map = require("helpers.keys").map

-- ═══════════════════════════════════════════
-- File Operations
-- ═══════════════════════════════════════════

map("n", "<leader>fw", "<cmd>w<cr>", "Write")
map("n", "<leader>fa", "<cmd>wa<cr>", "Write all")
map("n", "<leader>qq", "<cmd>q<cr>", "Quit")
map("n", "<leader>qa", "<cmd>qa!<cr>", "Quit all")

-- ═══════════════════════════════════════════
-- Navigation & Movement
-- ═══════════════════════════════════════════

-- Line navigation
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Search navigation
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Scroll with centering
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- ═══════════════════════════════════════════
-- Window Management
-- ═══════════════════════════════════════════

-- Window actions
map("n", "<leader>dw", "<cmd>close<cr>", "Window")
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Window splits
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Window movement
-- map("n", "<S-Left>", "<C-w><S-h>", "Move window to the left")
-- map("n", "<S-Down>", "<C-w><S-j>", "Move window down")
-- map("n", "<S-Up>", "<C-w><S-k>", "Move window up")
-- map("n", "<S-Right>", "<C-w><S-l>", "Move window to the right")

-- Window resizing
map("n", "<C-S-Up>", ":resize +2<CR>")
map("n", "<C-S-Down>", ":resize -2<CR>")
map("n", "<C-S-Left>", ":vertical resize +2<CR>")
map("n", "<C-S-Right>", ":vertical resize -2<CR>")

-- ═══════════════════════════════════════════
-- Buffer Management
-- ═══════════════════════════════════════════

local buffers = require("helpers.buffers")
map("n", "<leader>bd", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

-- ═══════════════════════════════════════════
-- Editing & Text Manipulation
-- ═══════════════════════════════════════════

-- Essential mappings
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "J", "mzJ`z")

-- Visual mode improvements
map("v", "<", "<gv")
map("v", ">", ">gv")
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Text manipulation
map("i", "<M-BS>", "<C-w>", "Remove word")
vim.keymap.set("n", "<Leader>cp", ':let @+ = expand("%")<CR>:echo "Path copied to clipboard"<CR>', { noremap = true, silent = true })

-- ═══════════════════════════════════════════
-- Diagnostics & LSP
-- ═══════════════════════════════════════════

-- Basic diagnostic mappings
map("n", "gx", vim.diagnostic.open_float, "Show diagnostics under cursor")
map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
vim.keymap.set("n", "<leader>q", vim.lsp.buf.format)

-- Diagnostic navigation
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

map("n", "]d", diagnostic_goto(true), "Next Diagnostic")
map("n", "[d", diagnostic_goto(false), "Prev Diagnostic")
map("n", "]e", diagnostic_goto(true, "ERROR"), "Next Error")
map("n", "[e", diagnostic_goto(false, "ERROR"), "Prev Error")
map("n", "]w", diagnostic_goto(true, "WARN"), "Next Warning")
map("n", "[w", diagnostic_goto(false, "WARN"), "Prev Warning")

-- Diagnostic toggles
map("n", "<leader>dt", function()
    local current_value = vim.diagnostic.is_disabled()
    vim.diagnostic.enable()
    if not current_value then
        vim.diagnostic.disable()
    end
end, "Toggle diagnostics globally")

map("n", "<leader>db", function()
    local current_value = vim.diagnostic.is_disabled(0)
    vim.diagnostic.enable(0)
    if not current_value then
        vim.diagnostic.disable(0)
    end
end, "Toggle diagnostics in current buffer")

-- ═══════════════════════════════════════════
-- Quickfix
-- ═══════════════════════════════════════════

map("n", "[q", ":cp<CR>", "Previous quickfix item")
map("n", "]q", ":cn<CR>", "Next quickfix item")
map("n", "<Leader>qo", ":copen<CR>", "Open quickfix list")
map("n", "<Leader>qc", ":cclose<CR>", "Close quickfix list")
map("n", "<Leader>qd", ":RemoveFromQuickfix<CR>", "Delete current quickfix item")

-- ═══════════════════════════════════════════
-- UI & Display Toggles
-- ═══════════════════════════════════════════

-- Theme toggle
map("n", "<leader>ut", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end, "Toggle between light and dark themes")

-- Clear search highlights
map("n", "<leader>ur", "<cmd>nohl<cr>", "Clear highlights")

-- Word wrap toggle
map("n", "<leader>uw", function()
    if vim.wo.wrap then
        vim.wo.wrap = false
        vim.notify("Word wrap disabled", vim.log.levels.INFO)
    else
        vim.wo.wrap = true
        vim.notify("Word wrap enabled", vim.log.levels.INFO)
    end
end, "Toggle word wrap")

-- Colorcolumn toggle
map("n", "<leader>ur", function()
    if vim.wo.colorcolumn == "" then
        local ft = vim.bo.filetype
        if ft == "python" then
            vim.wo.colorcolumn = "90"
        elseif vim.tbl_contains({ "java", "cpp", "c", "rust", "go" }, ft) then
            vim.wo.colorcolumn = "100"
        else
            vim.wo.colorcolumn = "90"
        end
        vim.notify("Colorcolumn enabled", vim.log.levels.INFO)
    else
        vim.wo.colorcolumn = ""
        vim.notify("Colorcolumn disabled", vim.log.levels.INFO)
    end
end, "Toggle ruler (colorcolumn)")

-- Colorizer toggle
vim.keymap.set("n", "<leader>cc", "<cmd>ColorizerToggle<CR>", { desc = "Toggle colorizer" })

-- ═══════════════════════════════════════════
-- External Tools & Integrations
-- ═══════════════════════════════════════════

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { noremap = true, silent = true, desc = "Netrw Explorer" })

-- Auto-format toggle
map("n", "<leader>ft", function()
    vim.g.autoformat_on_save = not vim.g.autoformat_on_save
    local status = vim.g.autoformat_on_save and "enabled" or "disabled"
    vim.notify("Global auto-format on save " .. status, vim.log.levels.INFO)
end, "Toggle global auto-format on save")

-- Avante AI
map("n", "<leader>at", "<cmd>AvanteToggle<cr>", "Run Avante")
map("n", "<leader>ac", "<cmd>AvanteChat<cr>", "Run Avante")

vim.api.nvim_create_autocmd("User", {
    pattern = "ToggleMyPrompt",
    callback = function()
        require("avante.config").override({ system_prompt = "MY CUSTOM SYSTEM PROMPT" })
    end,
})

vim.keymap.set("n", "<leader>am", function()
    vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" })
end, { desc = "avante: toggle my prompt" })

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tsession<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tsession -s 0<CR>")
vim.keymap.set("n", "<M-t>", "<cmd>silent !tmux neww tsession -s 1<CR>")
vim.keymap.set("n", "<M-n>", "<cmd>silent !tmux neww tsession -s 2<CR>")
vim.keymap.set("n", "<M-s>", "<cmd>silent !tmux neww tsession -s 3<CR>")

-- ═══════════════════════════════════════════
-- Search & Replace
-- ═══════════════════════════════════════════

map("n", "<leader>Si", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[S]ubstitute current word [I]nsensitive")
map("n", "<leader>Sc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], "[S]ubstitute current word [C]onfirm")
map("v", "<leader>Si", [["hy:%s/<C-r>h/<C-r>h/gI<left><left><left>]], "[S]ubstitute selection [I]nsensitive")
map("v", "<leader>Sc", [["hy:%s/<C-r>h/<C-r>h/gIc<left><left><left><left>]], "[S]ubstitute selection [C]onfirm")

