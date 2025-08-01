return {
    {
        "christoomey/vim-tmux-navigator",
    },
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   ft = { "markdown", "codecompanion" }
    -- },
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    -- Move stuff with <M-j> and <M-k> in both normal and visual mode
    {
        "echasnovski/mini.move",
        config = function()
            require("mini.move").setup()
        end,
    },
    {
        "shortcuts/no-neck-pain.nvim",
        cmd = "NoNeckPain",
        keys = { { "<leader>zn", "<cmd>NoNeckPain<cr>", desc = "[N]o [N]eckpain" } },
        config = function()
            require("no-neck-pain").setup({
                width = 120,
            })
        end,
    },
    -- Better buffer closing actions. Available via the buffers helper.
    {
        "kazhala/close-buffers.nvim",
        opts = {
            preserve_window_layout = { "this", "nameless" },
        },
        m,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        -- config = function()
        --   local highlight = {
        --     "RainbowRed",
        --     "RainbowYellow",
        --     "RainbowBlue",
        --     "RainbowOrange",
        --     "RainbowGreen",
        --     "RainbowViolet",
        --     "RainbowCyan",
        --   }
        --
        --   local function set_rainbow_highlight()
        --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#f38b94" })
        --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#f6d79f" })
        --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#84c6f7" })
        --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ebb377" })
        --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#b4d9a0" })
        --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d9a0eb" })
        --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#7ed1dd" })
        --   end
        --
        --   -- Set colors initially
        --   set_rainbow_highlight()
        --
        --   -- Re-apply colors after any colorscheme loads
        --   vim.api.nvim_create_autocmd("ColorScheme", {
        --     callback = set_rainbow_highlight,
        --   })
        --
        --   require("ibl").setup {
        --     indent = { highlight = highlight },
        --   }
        -- end,
    },
    {
        "nvim-tree/nvim-web-devicons",
    },

    -- {
    --   'm4xshen/autoclose.nvim',
    -- },
    -- {
    --   'norcalli/nvim-colorizer.lua',
    --   config = function()
    --     require('colorizer').setup()
    --   end
    -- },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.g.VM_maps = {
                ["Find Under"] = "<C-n>",
                ["Find Subword Under"] = "<C-n>",
                ["Select All"] = "<C-d>",
                ["Visual Add"] = "<C-m>",
            }

            vim.keymap.set("n", "<M-Down>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor down" })
            vim.keymap.set("n", "<M-Up>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor up" })
            vim.keymap.set("n", "<M-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor down" })
            vim.keymap.set("n", "<M-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor up" })

            vim.cmd("highlight VM_Mono cterm=None ctermbg=cyan ctermfg=238 gui=underline guifg=red")
        end,
    },
}

