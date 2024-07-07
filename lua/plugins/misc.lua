-- Miscelaneous fun stuff
return {
        -- Comment with haste
        {
        "numToStr/Comment.nvim",
        opts = {},
        },
        -- Move stuff with <M-j> and <M-k> in both normal and visual mode
        {
                "echasnovski/mini.move",
                config = function()
                        require("mini.move").setup()
                end,
        },
        -- Better buffer closing actions. Available via the buffers helper.
        {
                "kazhala/close-buffers.nvim",
                opts = {
                        preserve_window_layout = { "this", "nameless" },
                },
        },
        "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
        "tpope/vim-surround", -- Surround stuff with the ys-, cs-, ds- commands
        {
                "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {},
                config = function()
                        local highlight = {
                                "RainbowRed",
                                "RainbowYellow",
                                "RainbowBlue",
                                "RainbowOrange",
                                "RainbowGreen",
                                "RainbowViolet",
                                "RainbowCyan",
                        }

                        local hooks = require "ibl.hooks"
                        -- create the highlight groups in the highlight setup hook, so they are reset
                        -- every time the colorscheme changes
                        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
                        end)

                        require("ibl").setup { indent = { highlight = highlight } }
                end

        },
}
