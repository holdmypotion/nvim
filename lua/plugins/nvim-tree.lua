return {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    --         "MunifTanjim/nui.nvim",
    --         -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    --     },
    --     lazy = true,
    --     ---@module "neo-tree"
    --     ---@type neotree.Config?
    --     opts = {
    --         -- fill any relevant options here
    --     },
    --     keys = {
    --         { "<leader>et", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    --     }
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
            git = {
                enable = true,
            },
        })
        vim.keymap.set("n", "<leader>et", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle NvimTree with current file", silent = true })
    end,
}

