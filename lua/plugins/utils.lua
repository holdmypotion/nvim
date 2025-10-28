return {
    {
        "rmagatti/auto-session",
        config = function()
            local auto_session = require("auto-session")

            auto_session.setup({
                auto_restore_enabled = false,
                auto_session_suppress_dirs = {
                    "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/",
                },
                bypass_session_save_file_types = { "alpha" },
            })

            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", vim.tbl_extend("force", opts, {
                desc = "Restore session for cwd",
            }))
            vim.keymap.set("n", "<leader>wl", "<cmd>SessionSave<CR>", vim.tbl_extend("force", opts, {
                desc = "Save session for root dir",
            }))
        end,
    },

    {
        'numToStr/Comment.nvim',
        opts = {
            ignore = "^$",
            mappings = {
                basic = true,
                extra = true,
            },
            toggler = {
                line = ',,',
                block = 'gbc',
            },
            opleader = {
                line = ',',
                block = 'gbc',
            },
            extra = {
                above = ',O',
                below = ',o',
                eol = ',A',
            },
        }
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            defaults = {},
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>b", group = "buffer" },
                    { "<leader>c", group = "code" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui" },
                    { "<leader>w", group = "windows" },
                    { "<leader>x", group = "diagnostics/quickfix" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
        end,
    },


    {
        "gbprod/yanky.nvim",
        recommended = true,
        desc = "Better Yank/Paste",
        opts = {
            highlight = { timer = 150 },
        },
        keys = {
            { "y",  "<Plug>(YankyYank)",                      mode = { "n", "x" },                           desc = "Yank Text" },
            { "p",  "<Plug>(YankyPutAfter)",                  mode = { "n", "x" },                           desc = "Put Yanked Text After Cursor" },
            { "P",  "<Plug>(YankyPutBefore)",                 mode = { "n", "x" },                           desc = "Put Yanked Text Before Cursor" },
            { "gp", "<Plug>(YankyGPutAfter)",                 mode = { "n", "x" },                           desc = "Put Yanked Text After Selection" },
            { "gP", "<Plug>(YankyGPutBefore)",                mode = { "n", "x" },                           desc = "Put Yanked Text Before Selection" },
            { "[y", "<Plug>(YankyCycleForward)",              desc = "Cycle Forward Through Yank History" },
            { "]y", "<Plug>(YankyCycleBackward)",             desc = "Cycle Backward Through Yank History" },
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put Indented After Cursor (Linewise)" },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put Indented Before Cursor (Linewise)" },
            { "]P", "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put Indented After Cursor (Linewise)" },
            { "[P", "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put Indented Before Cursor (Linewise)" },
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and Indent Right" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and Indent Left" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put Before and Indent Left" },
            { "=p", "<Plug>(YankyPutAfterFilter)",            desc = "Put After Applying a Filter" },
            { "=P", "<Plug>(YankyPutBeforeFilter)",           desc = "Put Before Applying a Filter" },
        }
    }

}
