return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require("nvim-tree").setup({
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            view = {
                side = "right",
                width = 30,
            },
            renderer = {
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
                highlight_git = true,
                highlight_opened_files = "none",
            },
            hijack_netrw = false,
            filters = { dotfiles = false, custom = { '^.git$' }},
            git = {
                enable = true,
            },
        })
        vim.keymap.set("n", "<leader>et", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle NvimTree with current file", silent = true })
    end,
}

